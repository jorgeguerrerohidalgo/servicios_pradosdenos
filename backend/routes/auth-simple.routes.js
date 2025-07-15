const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const { query } = require('../utils/db');

// Middleware de validación básico
const validateLogin = (req, res, next) => {
  const { email, password } = req.body;
  
  if (!email || !password) {
    return res.status(400).json({ error: 'Email y contraseña son requeridos' });
  }
  
  // Validación básica de email
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return res.status(400).json({ error: 'Formato de email inválido' });
  }
  
  // Sanitizar email
  req.body.email = email.toLowerCase().trim();
  
  next();
};

// ==================== LOGIN DE ADMINISTRADOR ====================
router.post('/admin/login', validateLogin, async (req, res) => {
  try {
    const { email, password } = req.body;
    
    console.log('🔐 Intento de login admin:', email);
    
    // Buscar administrador
    const admin = await query('SELECT * FROM admin_users WHERE email = $1 AND activo = true', [email]);
    
    if (!admin || admin.length === 0) {
      console.log('❌ Admin no encontrado:', email);
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }
    
    // Verificar contraseña
    const isValidPassword = await bcrypt.compare(password, admin[0].password);
    
    if (!isValidPassword) {
      console.log('❌ Contraseña incorrecta para admin:', email);
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }
    
    // Actualizar último login
    await query('UPDATE admin_users SET updated_at = NOW() WHERE id = $1', [admin[0].id]);
    
    // Crear sesión
    req.session.admin = {
      id: admin[0].id,
      email: admin[0].email,
      nombre: admin[0].nombre,
      tipo: 'admin'
    };
    
    console.log('✅ Login admin exitoso:', email);
    
    res.json({
      success: true,
      message: 'Login exitoso',
      redirect: '/admin-panel.html',
      user: {
        id: admin[0].id,
        email: admin[0].email,
        nombre: admin[0].nombre,
        tipo: 'admin'
      }
    });
    
  } catch (error) {
    console.error('Error en login admin:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// ==================== LOGIN DE GUARDIA ====================
router.post('/guardia/login', validateLogin, async (req, res) => {
  try {
    const { email, password } = req.body;
    
    console.log('🔐 Intento de login guardia:', email);
    
    // Buscar guardia
    const guardia = await query('SELECT * FROM guardias WHERE email = $1 AND activo = true', [email]);
    
    if (!guardia || guardia.length === 0) {
      console.log('❌ Guardia no encontrado:', email);
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }
    
    // Verificar contraseña
    const isValidPassword = await bcrypt.compare(password, guardia[0].password);
    
    if (!isValidPassword) {
      console.log('❌ Contraseña incorrecta para guardia:', email);
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }
    
    // Actualizar último login
    await query('UPDATE guardias SET last_login = NOW() WHERE id = $1', [guardia[0].id]);
    
    // Crear sesión
    req.session.guardia = {
      id: guardia[0].id,
      email: guardia[0].email,
      nombre: guardia[0].nombre,
      tipo: 'guardia'
    };
    
    console.log('✅ Login guardia exitoso:', email);
    
    res.json({
      success: true,
      message: 'Login exitoso',
      redirect: '/checkin.html',
      user: {
        id: guardia[0].id,
        email: guardia[0].email,
        nombre: guardia[0].nombre,
        tipo: 'guardia'
      }
    });
    
  } catch (error) {
    console.error('Error en login guardia:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// ==================== VERIFICACIÓN DE SESIÓN ====================
router.get('/verify', (req, res) => {
  try {
    if (req.session.admin) {
      res.json({
        success: true,
        user: req.session.admin,
        tipo: 'admin'
      });
    } else if (req.session.guardia) {
      res.json({
        success: true,
        user: req.session.guardia,
        tipo: 'guardia'
      });
    } else {
      res.status(401).json({ error: 'No autenticado' });
    }
  } catch (error) {
    console.error('Error verificando sesión:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// ==================== LOGOUT ====================
router.post('/logout', (req, res) => {
  try {
    req.session.destroy((err) => {
      if (err) {
        console.error('Error destruyendo sesión:', err);
        return res.status(500).json({ error: 'Error cerrando sesión' });
      }
      
      res.json({ success: true, message: 'Sesión cerrada' });
    });
  } catch (error) {
    console.error('Error en logout:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// ==================== CAMBIO DE CONTRASEÑA ====================
router.post('/change-password', async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;
    
    if (!currentPassword || !newPassword) {
      return res.status(400).json({ error: 'Contraseña actual y nueva son requeridas' });
    }
    
    if (newPassword.length < 6) {
      return res.status(400).json({ error: 'La nueva contraseña debe tener al menos 6 caracteres' });
    }
    
    let user = null;
    let userType = null;
    
    if (req.session.admin) {
      user = await query('SELECT * FROM admin_users WHERE id = $1', [req.session.admin.id]);
      userType = 'admin';
    } else if (req.session.guardia) {
      user = await query('SELECT * FROM guardias WHERE id = $1', [req.session.guardia.id]);
      userType = 'guardia';
    } else {
      return res.status(401).json({ error: 'No autenticado' });
    }
    
    if (!user || user.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }
    
    // Verificar contraseña actual
    const isValidPassword = await bcrypt.compare(currentPassword, user[0].password);
    
    if (!isValidPassword) {
      return res.status(401).json({ error: 'Contraseña actual incorrecta' });
    }
    
    // Hash de nueva contraseña
    const hashedPassword = await bcrypt.hash(newPassword, 12);
    
    // Actualizar contraseña
    if (userType === 'admin') {
      await query('UPDATE admin_users SET password = $1, updated_at = NOW() WHERE id = $2', 
        [hashedPassword, user[0].id]);
    } else {
      await query('UPDATE guardias SET password = $1 WHERE id = $2', 
        [hashedPassword, user[0].id]);
    }
    
    res.json({ success: true, message: 'Contraseña actualizada exitosamente' });
    
  } catch (error) {
    console.error('Error cambiando contraseña:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

module.exports = router;
