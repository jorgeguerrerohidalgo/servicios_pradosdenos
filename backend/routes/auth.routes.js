const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const db = require('../utils/db');
const { 
  loginLimiter, 
  logSecurityEvent, 
  logLoginAttempt,
  requireUserType,
  validateSession
} = require('../middleware/security');

// Constantes de seguridad
const SALT_ROUNDS = 12;
const MAX_LOGIN_ATTEMPTS = 5;
const LOCKOUT_TIME = 15 * 60 * 1000; // 15 minutos

// Middleware de validación mejorado
const validateLogin = (req, res, next) => {
  const { email, password } = req.body;
  
  if (!email || !password) {
    return res.status(400).json({ error: 'Email y contraseña son requeridos' });
  }
  
  // Validación más estricta de email
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return res.status(400).json({ error: 'Formato de email inválido' });
  }
  
  // Validación básica de contraseña
  if (password.length < 4) {
    return res.status(400).json({ error: 'Contraseña demasiado corta' });
  }
  
  // Sanitizar email
  req.body.email = email.toLowerCase().trim();
  
  next();
};

// Middleware para verificar bloqueos por intentos fallidos
const checkLoginAttempts = async (req, res, next) => {
  const { email } = req.body;
  const ip = req.ip;
  
  try {
    // Verificar intentos fallidos por IP en los últimos 15 minutos
    const ipAttempts = await db.query(
      `SELECT COUNT(*) as attempts FROM security_logs 
       WHERE ip_address = $1 
       AND event_type = 'LOGIN_FAILED' 
       AND created_at > NOW() - INTERVAL '15 minutes'`,
      [ip]
    );
    
    if (ipAttempts[0].attempts >= MAX_LOGIN_ATTEMPTS) {
      await logSecurityEvent(ip, 'IP_BLOCKED', {
        email,
        attempts: ipAttempts[0].attempts,
        userAgent: req.get('User-Agent')
      });
      
      return res.status(429).json({ 
        error: 'IP bloqueada por demasiados intentos. Intenta en 15 minutos.',
        blockedUntil: new Date(Date.now() + LOCKOUT_TIME).toISOString()
      });
    }
    
    // Verificar intentos fallidos por email en los últimos 15 minutos
    const emailAttempts = await db.query(
      `SELECT COUNT(*) as attempts FROM security_logs 
       WHERE details->>'email' = $1 
       AND event_type = 'LOGIN_FAILED' 
       AND created_at > NOW() - INTERVAL '15 minutes'`,
      [email]
    );
    
    if (emailAttempts[0].attempts >= MAX_LOGIN_ATTEMPTS) {
      await logSecurityEvent(ip, 'EMAIL_BLOCKED', {
        email,
        attempts: emailAttempts[0].attempts,
        userAgent: req.get('User-Agent')
      });
      
      return res.status(429).json({ 
        error: 'Email bloqueado por demasiados intentos. Intenta en 15 minutos.',
        blockedUntil: new Date(Date.now() + LOCKOUT_TIME).toISOString()
      });
    }
    
    next();
  } catch (error) {
    console.error('Error checking login attempts:', error);
    next(); // Continuar en caso de error
  }
};

// Función para hash de contraseñas
async function hashPassword(password) {
  return await bcrypt.hash(password, SALT_ROUNDS);
}

// Ruta de login con seguridad mejorada
router.post('/login', 
  loginLimiter,
  validateLogin, 
  checkLoginAttempts,
  logLoginAttempt,
  async (req, res) => {
    const { email, password } = req.body;
    const ip = req.ip;
    const userAgent = req.get('User-Agent');
    
    try {
      // Primero buscar en guardias
      let user = await db.query('SELECT * FROM guardias WHERE email = $1 AND activo = true', [email]);
      let userType = 'guardia';
      
      // Si no se encuentra, buscar en admin_users
      if (user.length === 0) {
        user = await db.query('SELECT *, password_hash as password FROM admin_users WHERE email = $1', [email]);
        userType = 'admin';
      }
      
      if (user.length === 0) {
        await logSecurityEvent(ip, 'LOGIN_FAILED', {
          email,
          reason: 'USER_NOT_FOUND',
          userAgent,
          timestamp: new Date().toISOString()
        });
        
        return res.status(401).json({ error: 'Credenciales inválidas' });
      }
      
      const foundUser = user[0];
      
      // Verificar si el usuario está activo (solo para guardias)
      if (userType === 'guardia' && !foundUser.activo) {
        await logSecurityEvent(ip, 'LOGIN_FAILED', {
          email,
          reason: 'USER_INACTIVE',
          userId: foundUser.id,
          userAgent
        });
        
        return res.status(401).json({ error: 'Usuario inactivo' });
      }
      
      // Verificar contraseña
      let isValidPassword = false;
      
      if (!foundUser.password) {
        await logSecurityEvent(ip, 'LOGIN_FAILED', {
          email,
          reason: 'NO_PASSWORD_SET',
          userId: foundUser.id,
          userAgent
        });
        
        return res.status(401).json({ error: 'Credenciales inválidas' });
      }
      
      if (foundUser.password.startsWith('$2b$')) {
        // Contraseña hasheada
        isValidPassword = await bcrypt.compare(password, foundUser.password);
      } else {
        // Contraseña en texto plano - MIGRAR AUTOMÁTICAMENTE
        isValidPassword = password === foundUser.password;
        
        if (isValidPassword) {
          // Hash automático de contraseña en texto plano
          const hashedPassword = await hashPassword(password);
          
          if (userType === 'guardia') {
            await db.query('UPDATE guardias SET password = $1 WHERE id = $2', [hashedPassword, foundUser.id]);
          } else {
            await db.query('UPDATE admin_users SET password_hash = $1 WHERE id = $2', [hashedPassword, foundUser.id]);
          }
          
          await logSecurityEvent(ip, 'PASSWORD_MIGRATED', {
            userId: foundUser.id,
            userType,
            userAgent
          });
          
          console.log(`🔒 SECURITY: Contraseña migrada automáticamente para usuario ${foundUser.id} (${userType})`);
        }
      }
      
      if (!isValidPassword) {
        await logSecurityEvent(ip, 'LOGIN_FAILED', {
          email,
          reason: 'INVALID_PASSWORD',
          userId: foundUser.id,
          userAgent
        });
        
        return res.status(401).json({ error: 'Credenciales inválidas' });
      }
      
      // Actualizar último login
      if (userType === 'guardia') {
        await db.query('UPDATE guardias SET last_login = CURRENT_TIMESTAMP WHERE id = $1', [foundUser.id]);
      }
      
      // Crear sesión segura
      const userName = userType === 'guardia' ? foundUser.nombre : `${foundUser.nombre} ${foundUser.apellido_paterno}`;
      
      // Regenerar ID de sesión para prevenir session fixation
      req.session.regenerate((err) => {
        if (err) {
          console.error('Error regenerating session:', err);
        }
        
        req.session.guardia = {
          id: foundUser.id,
          nombre: userName,
          email: foundUser.email,
          tipo: userType,
          loginTime: new Date().toISOString(),
          ip: ip
        };
        
        req.session.save((err) => {
          if (err) {
            console.error('Error saving session:', err);
            return res.status(500).json({ error: 'Error interno del servidor' });
          }
          
          // Log exitoso
          logSecurityEvent(ip, 'LOGIN_SUCCESS', {
            userId: foundUser.id,
            userType,
            email: foundUser.email,
            userAgent,
            sessionId: req.sessionID
          });
          
          res.json({ 
            message: 'Login exitoso',
            guardia: {
              id: foundUser.id,
              nombre: userName,
              email: foundUser.email,
              tipo: userType
            }
          });
        });
      });
      
    } catch (error) {
      console.error('❌ Error en login:', error);
      
      await logSecurityEvent(ip, 'LOGIN_ERROR', {
        email,
        error: error.message,
        userAgent
      });
      
      res.status(500).json({ error: 'Error interno del servidor' });
    }
  }
);

// Ruta para verificar si el usuario está autenticado
router.get('/check', validateSession, (req, res) => {
  // Verificar que la sesión no sea demasiado antigua (opcional)
  const sessionAge = Date.now() - new Date(req.session.guardia.loginTime || 0).getTime();
  const maxSessionAge = 24 * 60 * 60 * 1000; // 24 horas
  
  if (sessionAge > maxSessionAge) {
    req.session.destroy();
    return res.json({ authenticated: false, reason: 'session_expired' });
  }
  
  res.json({ 
    authenticated: true, 
    guardia: {
      id: req.session.guardia.id,
      nombre: req.session.guardia.nombre,
      email: req.session.guardia.email,
      tipo: req.session.guardia.tipo
    }
  });
});

// Ruta para cerrar sesión mejorada
router.post('/logout', (req, res) => {
  const ip = req.ip;
  const userAgent = req.get('User-Agent');
  
  if (req.session.guardia) {
    // Log del logout
    logSecurityEvent(ip, 'LOGOUT', {
      userId: req.session.guardia.id,
      userType: req.session.guardia.tipo,
      sessionDuration: Date.now() - new Date(req.session.guardia.loginTime || 0).getTime(),
      userAgent,
      sessionId: req.sessionID
    });
    
    console.log(`🔓 SECURITY: Logout para usuario ${req.session.guardia.id} (${req.session.guardia.tipo}) desde IP ${ip}`);
  }
  
  req.session.destroy((err) => {
    if (err) {
      console.error('Error cerrando sesión:', err);
      return res.status(500).json({ success: false, message: 'Error al cerrar sesión' });
    }
    
    // Limpiar cookie de sesión
    res.clearCookie('checkin.sid', {
      path: '/',
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax'
    });
    
    res.json({ success: true, message: 'Sesión cerrada exitosamente' });
  });
});

// Ruta para cambiar contraseña (nueva funcionalidad de seguridad)
router.post('/change-password', validateSession, async (req, res) => {
  const { currentPassword, newPassword } = req.body;
  const userId = req.session.guardia.id;
  const userType = req.session.guardia.tipo;
  const ip = req.ip;
  
  try {
    // Validaciones
    if (!currentPassword || !newPassword) {
      return res.status(400).json({ error: 'Contraseña actual y nueva son requeridas' });
    }
    
    if (newPassword.length < 6) {
      return res.status(400).json({ error: 'La nueva contraseña debe tener al menos 6 caracteres' });
    }
    
    // Verificar contraseña actual
    let user;
    if (userType === 'guardia') {
      user = await db.query('SELECT password FROM guardias WHERE id = $1', [userId]);
    } else {
      user = await db.query('SELECT password_hash as password FROM admin_users WHERE id = $1', [userId]);
    }
    
    if (user.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }
    
    const currentHashedPassword = user[0].password;
    let isCurrentValid = false;
    
    if (currentHashedPassword.startsWith('$2b$')) {
      isCurrentValid = await bcrypt.compare(currentPassword, currentHashedPassword);
    } else {
      isCurrentValid = currentPassword === currentHashedPassword;
    }
    
    if (!isCurrentValid) {
      await logSecurityEvent(ip, 'PASSWORD_CHANGE_FAILED', {
        userId,
        userType,
        reason: 'INVALID_CURRENT_PASSWORD'
      });
      
      return res.status(401).json({ error: 'Contraseña actual incorrecta' });
    }
    
    // Hash nueva contraseña
    const newHashedPassword = await hashPassword(newPassword);
    
    // Actualizar contraseña
    if (userType === 'guardia') {
      await db.query('UPDATE guardias SET password = $1 WHERE id = $2', [newHashedPassword, userId]);
    } else {
      await db.query('UPDATE admin_users SET password_hash = $1 WHERE id = $2', [newHashedPassword, userId]);
    }
    
    // Log exitoso
    await logSecurityEvent(ip, 'PASSWORD_CHANGED', {
      userId,
      userType,
      timestamp: new Date().toISOString()
    });
    
    console.log(`🔒 SECURITY: Contraseña cambiada para usuario ${userId} (${userType})`);
    
    res.json({ success: true, message: 'Contraseña cambiada exitosamente' });
    
  } catch (error) {
    console.error('Error cambiando contraseña:', error);
    
    await logSecurityEvent(ip, 'PASSWORD_CHANGE_ERROR', {
      userId,
      userType,
      error: error.message
    });
    
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Ruta para obtener logs de seguridad (solo admins)
router.get('/security-logs', validateSession, requireUserType('admin'), async (req, res) => {
  try {
    const { limit = 50, offset = 0, eventType } = req.query;
    
    let query = 'SELECT * FROM security_logs';
    const params = [];
    
    if (eventType) {
      query += ' WHERE event_type = $1';
      params.push(eventType);
      query += ' ORDER BY created_at DESC LIMIT $2 OFFSET $3';
      params.push(limit, offset);
    } else {
      query += ' ORDER BY created_at DESC LIMIT $1 OFFSET $2';
      params.push(limit, offset);
    }
    
    const logs = await db.query(query, params);
    
    res.json({
      success: true,
      logs: logs,
      total: logs.length
    });
    
  } catch (error) {
    console.error('Error obteniendo logs de seguridad:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

module.exports = router;