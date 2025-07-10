const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const db = require('../utils/db');

// Middleware de validación
const validateLogin = (req, res, next) => {
  const { email, password } = req.body;
  
  if (!email || !password) {
    return res.status(400).json({ error: 'Email y contraseña son requeridos' });
  }
  
  if (!email.includes('@')) {
    return res.status(400).json({ error: 'Formato de email inválido' });
  }
  
  next();
};

router.post('/login', validateLogin, async (req, res) => {
  const { email, password } = req.body;
  
  try {
    // Primero buscar en guardias
    let user = await db.query('SELECT * FROM guardias WHERE email = $1', [email]);
    let userType = 'guardia';
    
    // Si no se encuentra, buscar en admin_users
    if (user.length === 0) {
      user = await db.query('SELECT *, password_hash as password FROM admin_users WHERE email = $1', [email]);
      userType = 'admin';
    }
    
    if (user.length === 0) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }
    
    const foundUser = user[0];
    
    // Verificar contraseña
    let isValidPassword = false;
    if (foundUser.password.startsWith('$2b$')) {
      // Contraseña hasheada
      isValidPassword = await bcrypt.compare(password, foundUser.password);
    } else {
      // Contraseña en texto plano (temporal para datos existentes)
      isValidPassword = password === foundUser.password;
    }
    
    if (!isValidPassword) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }
    
    // Actualizar último login solo para guardias
    if (userType === 'guardia') {
      await db.query('UPDATE guardias SET last_login = CURRENT_TIMESTAMP WHERE id = $1', [foundUser.id]);
    }
    
    // Crear sesión
    const userName = userType === 'guardia' ? foundUser.nombre : `${foundUser.nombre} ${foundUser.apellido_paterno}`;
    
    req.session.guardia = {
      id: foundUser.id,
      nombre: userName,
      email: foundUser.email,
      tipo: userType
    };
    
    res.json({ 
      message: 'Login exitoso',
      guardia: {
        id: foundUser.id,
        nombre: userName,
        email: foundUser.email,
        tipo: userType
      }
    });
    
  } catch (error) {
    console.error('❌ Error en login:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

router.get('/logout', (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).json({ error: 'Error al cerrar sesión' });
    }
    res.json({ message: 'Sesión cerrada exitosamente' });
  });
});

// Ruta para verificar si el usuario está autenticado
router.get('/check', (req, res) => {
  if (req.session.guardia) {
    res.json({ 
      authenticated: true, 
      guardia: req.session.guardia 
    });
  } else {
    res.json({ authenticated: false });
  }
});

module.exports = router;