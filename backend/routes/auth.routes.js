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

router.post('/login', validateLogin, (req, res) => {
  const { email, password } = req.body;
  
  db.query('SELECT * FROM guardias WHERE email = ?', [email], async (err, results) => {
    if (err) {
      console.error('Error en consulta de login:', err);
      return res.status(500).json({ error: 'Error interno del servidor' });
    }
    
    if (results.length === 0) {
      return res.status(401).json({ error: 'Credenciales inválidas' });
    }
    
    const guardia = results[0];
    
    try {
      // Para retrocompatibilidad, si la contraseña no está hasheada, comparar directamente
      let isValidPassword = false;
      if (guardia.password.startsWith('$2b$')) {
        // Contraseña hasheada
        isValidPassword = await bcrypt.compare(password, guardia.password);
      } else {
        // Contraseña en texto plano (temporal para datos existentes)
        isValidPassword = password === guardia.password;
      }
      
      if (!isValidPassword) {
        return res.status(401).json({ error: 'Credenciales inválidas' });
      }
      
      req.session.guardia = {
        id: guardia.id,
        nombre: guardia.nombre,
        email: guardia.email
      };
      
      res.json({ 
        message: 'Login exitoso',
        guardia: {
          id: guardia.id,
          nombre: guardia.nombre,
          email: guardia.email
        }
      });
    } catch (error) {
      console.error('Error al verificar contraseña:', error);
      return res.status(500).json({ error: 'Error interno del servidor' });
    }
  });
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