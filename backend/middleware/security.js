const rateLimit = require('express-rate-limit');
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

// Rate limiting general para API
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100, // Máximo 100 requests por IP cada 15 minutos
  message: {
    error: 'Demasiadas peticiones. Intenta nuevamente más tarde.',
    retryAfter: '15 minutos'
  },
  standardHeaders: true,
  legacyHeaders: false
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
