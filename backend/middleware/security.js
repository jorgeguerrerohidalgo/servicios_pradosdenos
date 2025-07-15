const rateLimit = require('express-rate-limit');
const helmet = require('helmet');
const cors = require('cors');
const validator = require('validator');

/**
 * Configuración de rate limiting para APIs
 */
const apiLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutos
    max: 100, // límite de 100 requests por ventana por IP
    message: {
        success: false,
        message: 'Demasiadas solicitudes, intenta de nuevo en 15 minutos'
    },
    standardHeaders: true,
    legacyHeaders: false,
    skip: (req) => {
        // Saltar rate limiting para IPs locales en desarrollo
        if (process.env.NODE_ENV === 'development') {
            const ip = req.ip || req.connection.remoteAddress;
            return ip === '127.0.0.1' || ip === '::1' || ip.startsWith('192.168.');
        }
        return false;
    }
});

/**
 * Rate limiting más estricto para endpoints de autenticación
 */
const authLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutos
    max: 5, // solo 5 intentos de login por IP
    message: {
        success: false,
        message: 'Demasiados intentos de login, intenta de nuevo en 15 minutos'
    },
    standardHeaders: true,
    legacyHeaders: false,
    skipSuccessfulRequests: true // no contar requests exitosos
});

/**
 * Configuración de CORS
 */
const corsOptions = {
    origin: function (origin, callback) {
        // Lista de orígenes permitidos
        const allowedOrigins = [
            'http://localhost:3000',
            'http://localhost:8080',
            'http://127.0.0.1:3000',
            'http://127.0.0.1:8080',
            ...(process.env.ALLOWED_ORIGINS ? process.env.ALLOWED_ORIGINS.split(',') : [])
        ];

        // Permitir requests sin origin (aplicaciones móviles, Postman, etc.)
        if (!origin) return callback(null, true);

        if (allowedOrigins.includes(origin)) {
            callback(null, true);
        } else {
            callback(new Error('No permitido por CORS'));
        }
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With']
};

/**
 * Configuración de Helmet para seguridad
 */
const helmetOptions = {
    contentSecurityPolicy: {
        directives: {
            defaultSrc: ["'self'"],
            styleSrc: ["'self'", "'unsafe-inline'", "https://fonts.googleapis.com", "https://cdnjs.cloudflare.com"],
            scriptSrc: ["'self'", "https://cdnjs.cloudflare.com"],
            fontSrc: ["'self'", "https://fonts.gstatic.com"],
            imgSrc: ["'self'", "data:", "https:"],
            connectSrc: ["'self'"],
            frameSrc: ["'none'"],
            objectSrc: ["'none'"]
        }
    },
    crossOriginEmbedderPolicy: false // Desactivar para permitir contenido externo
};

/**
 * Middleware de validación de entrada
 */
const validateInput = (schema) => {
    return (req, res, next) => {
        const errors = [];

        // Validar cada campo según el schema
        Object.keys(schema).forEach(field => {
            const rules = schema[field];
            const value = req.body[field];

            // Verificar campos requeridos
            if (rules.required && (!value || value.toString().trim() === '')) {
                errors.push(`${field} es requerido`);
                return;
            }

            // Si el campo no es requerido y está vacío, saltar validaciones
            if (!rules.required && (!value || value.toString().trim() === '')) {
                return;
            }

            // Validar tipo de datos
            if (rules.type) {
                switch (rules.type) {
                    case 'email':
                        if (!validator.isEmail(value)) {
                            errors.push(`${field} debe ser un email válido`);
                        }
                        break;
                    case 'url':
                        if (!validator.isURL(value)) {
                            errors.push(`${field} debe ser una URL válida`);
                        }
                        break;
                    case 'uuid':
                        if (!validator.isUUID(value)) {
                            errors.push(`${field} debe ser un UUID válido`);
                        }
                        break;
                    case 'date':
                        if (!validator.isISO8601(value)) {
                            errors.push(`${field} debe ser una fecha válida (ISO 8601)`);
                        }
                        break;
                    case 'boolean':
                        if (typeof value !== 'boolean') {
                            errors.push(`${field} debe ser un valor booleano`);
                        }
                        break;
                    case 'number':
                        if (isNaN(value)) {
                            errors.push(`${field} debe ser un número válido`);
                        }
                        break;
                }
            }

            // Validar longitud
            if (rules.minLength && value.length < rules.minLength) {
                errors.push(`${field} debe tener al menos ${rules.minLength} caracteres`);
            }

            if (rules.maxLength && value.length > rules.maxLength) {
                errors.push(`${field} debe tener máximo ${rules.maxLength} caracteres`);
            }

            // Validar patrones personalizados
            if (rules.pattern && !rules.pattern.test(value)) {
                errors.push(`${field} tiene un formato inválido`);
            }

            // Validaciones personalizadas
            if (rules.custom) {
                const customError = rules.custom(value, req.body);
                if (customError) {
                    errors.push(customError);
                }
            }
        });

        if (errors.length > 0) {
            return res.status(400).json({
                success: false,
                message: 'Errores de validación',
                errors: errors
            });
        }

        next();
    };
};

/**
 * Middleware de sanitización de entrada
 */
const sanitizeInput = (req, res, next) => {
    const sanitizeValue = (value) => {
        if (typeof value === 'string') {
            // Limpiar caracteres peligrosos
            return validator.escape(value.trim());
        }
        return value;
    };

    const sanitizeObject = (obj) => {
        const sanitized = {};
        Object.keys(obj).forEach(key => {
            if (obj[key] !== null && obj[key] !== undefined) {
                if (typeof obj[key] === 'object' && !Array.isArray(obj[key])) {
                    sanitized[key] = sanitizeObject(obj[key]);
                } else if (Array.isArray(obj[key])) {
                    sanitized[key] = obj[key].map(item => 
                        typeof item === 'object' ? sanitizeObject(item) : sanitizeValue(item)
                    );
                } else {
                    sanitized[key] = sanitizeValue(obj[key]);
                }
            } else {
                sanitized[key] = obj[key];
            }
        });
        return sanitized;
    };

    if (req.body) {
        req.body = sanitizeObject(req.body);
    }

    if (req.query) {
        req.query = sanitizeObject(req.query);
    }

    if (req.params) {
        req.params = sanitizeObject(req.params);
    }

    next();
};

/**
 * Middleware de logging de seguridad
 */
const securityLogger = (req, res, next) => {
    const startTime = Date.now();
    
    // Log de request
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl} - IP: ${req.ip} - User-Agent: ${req.get('User-Agent')}`);
    
    // Log de response
    const originalSend = res.send;
    res.send = function(body) {
        const duration = Date.now() - startTime;
        console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl} - ${res.statusCode} - ${duration}ms`);
        
        // Log de errores de seguridad
        if (res.statusCode >= 400) {
            console.warn(`[SECURITY] ${res.statusCode} - ${req.method} ${req.originalUrl} - IP: ${req.ip}`);
        }
        
        return originalSend.call(this, body);
    };
    
    next();
};

/**
 * Middleware de detección de ataques
 */
const attackDetection = (req, res, next) => {
    const suspiciousPatterns = [
        /(\<|\>|script|javascript|vbscript|onload|onerror)/i, // XSS
        /(union|select|insert|update|delete|drop|create|alter)/i, // SQL Injection
        /(\.\.|\/etc\/|\/var\/|\/usr\/)/i, // Path traversal
        /(<\?php|\<\%|asp\>)/i // Code injection
    ];

    const checkValue = (value) => {
        if (typeof value === 'string') {
            return suspiciousPatterns.some(pattern => pattern.test(value));
        }
        return false;
    };

    const checkObject = (obj) => {
        return Object.values(obj).some(value => {
            if (typeof value === 'object' && value !== null) {
                return checkObject(value);
            }
            return checkValue(value);
        });
    };

    let suspicious = false;

    // Verificar body, query y params
    if (req.body && checkObject(req.body)) suspicious = true;
    if (req.query && checkObject(req.query)) suspicious = true;
    if (req.params && checkObject(req.params)) suspicious = true;

    if (suspicious) {
        console.error(`[SECURITY ALERT] Suspicious request detected - IP: ${req.ip} - URL: ${req.originalUrl}`);
        return res.status(400).json({
            success: false,
            message: 'Solicitud sospechosa detectada'
        });
    }

    next();
};

// Mantener funciones existentes para compatibilidad
const { query } = require('../utils/db');

// Rate limiting para intentos de login
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 5, // Máximo 5 intentos por IP cada 15 minutos
  message: {
    error: 'Demasiados intentos de login. Intenta nuevamente en 15 minutos.',
    retryAfter: '15 minutos'
  },
  standardHeaders: true,
  legacyHeaders: false,
  // Solo aplicar a fallos de login
  skipSuccessfulRequests: true,
  // Identificar por IP
  keyGenerator: (req) => req.ip,
  // Handler personalizado para logging
  handler: (req, res) => {
    console.log(`🚨 SECURITY: Rate limit excedido para IP ${req.ip} en ${new Date().toISOString()}`);
    
    // Log a la base de datos
    logSecurityEvent(req.ip, 'RATE_LIMIT_EXCEEDED', {
      endpoint: req.path,
      userAgent: req.get('User-Agent'),
      timestamp: new Date().toISOString()
    });
    
    res.status(429).json({
      error: 'Demasiados intentos de login. Intenta nuevamente en 15 minutos.',
      retryAfter: '15 minutos'
    });
  }
});

// Middleware para logging de eventos de seguridad
async function logSecurityEvent(ip, eventType, details = {}) {
  try {
    // Verificar si la tabla existe antes de insertar
    const tableExists = await query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'security_logs'
      );
    `);
    
    if (tableExists[0].exists) {
      await query(
        'INSERT INTO security_logs (ip_address, event_type, details, created_at) VALUES ($1, $2, $3, CURRENT_TIMESTAMP)',
        [ip, eventType, JSON.stringify(details)]
      );
    } else {
      // Si la tabla no existe, solo loggear en consola
      console.log(`📋 SECURITY LOG: ${eventType} from ${ip}:`, details);
    }
  } catch (error) {
    console.error('Error logging security event:', error);
    // Fallback: loggear en consola
    console.log(`📋 SECURITY LOG (fallback): ${eventType} from ${ip}:`, details);
  }
}

// Middleware para validar sesiones
function validateSession(req, res, next) {
  if (!req.session || !req.session.guardia) {
    logSecurityEvent(req.ip, 'UNAUTHORIZED_ACCESS', {
      endpoint: req.path,
      userAgent: req.get('User-Agent'),
      timestamp: new Date().toISOString(),
      reason: 'NO_SESSION'
    });
    return res.status(401).json({ error: 'No autenticado' });
  }
  
  // Verificar que la sesión tenga los campos requeridos
  const guardia = req.session.guardia;
  if (!guardia.id || !guardia.tipo) {
    logSecurityEvent(req.ip, 'UNAUTHORIZED_ACCESS', {
      endpoint: req.path,
      userAgent: req.get('User-Agent'),
      timestamp: new Date().toISOString(),
      reason: 'INVALID_SESSION_DATA',
      sessionData: guardia
    });
    return res.status(401).json({ error: 'Sesión inválida' });
  }
  
  next();
}

// Middleware para validar tipos de usuario
function requireUserType(userType) {
  return (req, res, next) => {
    if (!req.session.guardia) {
      return res.status(401).json({ error: 'No autenticado' });
    }
    
    if (req.session.guardia.tipo !== userType) {
      logSecurityEvent(req.ip, 'UNAUTHORIZED_USER_TYPE', {
        expectedType: userType,
        actualType: req.session.guardia.tipo,
        userId: req.session.guardia.id,
        endpoint: req.path,
        timestamp: new Date().toISOString()
      });
      return res.status(403).json({ error: 'Acceso denegado. Tipo de usuario incorrecto.' });
    }
    
    next();
  };
}

// Middleware para logging de intentos de login
function logLoginAttempt(req, res, next) {
  const originalSend = res.send;
  
  res.send = function(data) {
    const parsedData = typeof data === 'string' ? JSON.parse(data) : data;
    
    if (res.statusCode === 401) {
      // Login fallido
      logSecurityEvent(req.ip, 'LOGIN_FAILED', {
        email: req.body.email,
        userAgent: req.get('User-Agent'),
        timestamp: new Date().toISOString(),
        error: parsedData.error
      });
      console.log(`🚨 SECURITY: Login fallido para ${req.body.email} desde IP ${req.ip}`);
    } else if (res.statusCode === 200 && parsedData.guardia) {
      // Login exitoso
      logSecurityEvent(req.ip, 'LOGIN_SUCCESS', {
        userId: parsedData.guardia.id,
        userType: parsedData.guardia.tipo,
        email: parsedData.guardia.email,
        userAgent: req.get('User-Agent'),
        timestamp: new Date().toISOString()
      });
      console.log(`✅ SECURITY: Login exitoso para ${parsedData.guardia.email} (${parsedData.guardia.tipo}) desde IP ${req.ip}`);
    }
    
    originalSend.call(this, data);
  };
  
  next();
}

// Middleware para headers de seguridad
function securityHeaders(req, res, next) {
  // Prevenir ataques XSS
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  
  // Content Security Policy básico
  res.setHeader('Content-Security-Policy', 
    "default-src 'self'; " +
    "script-src 'self' 'unsafe-inline' https://unpkg.com https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; " +
    "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; " +
    "font-src 'self' https://cdnjs.cloudflare.com; " +
    "img-src 'self' data:; " +
    "connect-src 'self';"
  );
  
  // Prevenir información de versión del servidor
  res.removeHeader('X-Powered-By');
  
  next();
}

// Middleware para limpiar sesiones expiradas
async function cleanExpiredSessions(req, res, next) {
  try {
    // Limpiar logs de seguridad antiguos (más de 30 días)
    const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
    await query('DELETE FROM security_logs WHERE created_at < $1', [thirtyDaysAgo]);
  } catch (error) {
    console.error('Error cleaning expired data:', error);
  }
  next();
}

module.exports = {
  loginLimiter,
  apiLimiter,
  logSecurityEvent,
  validateSession,
  requireUserType,
  logLoginAttempt,
  securityHeaders,
  cleanExpiredSessions
};
