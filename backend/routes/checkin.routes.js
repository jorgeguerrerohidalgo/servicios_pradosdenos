const express = require('express');
const router = express.Router();
const db = require('../utils/db');

// Middleware de autenticación
const requireAuth = (req, res, next) => {
  if (!req.session.guardia) {
    return res.status(401).json({ error: 'No autenticado' });
  }
  next();
};

// Middleware de validación
const validateCheckin = (req, res, next) => {
  const { token } = req.body;
  
  if (!token || typeof token !== 'string' || token.trim() === '') {
    return res.status(400).json({ error: 'Token requerido y debe ser válido' });
  }
  
  next();
};

router.post('/', requireAuth, validateCheckin, (req, res) => {
  const { token } = req.body;
  
  // Verificar que el token existe y obtener la plaza
  db.query('SELECT plaza_id FROM plaza_tokens WHERE token = ?', [token.trim()], (err, rows) => {
    if (err) {
      console.error('Error al verificar token:', err);
      return res.status(500).json({ error: 'Error interno del servidor' });
    }
    
    if (rows.length === 0) {
      return res.status(400).json({ error: 'Token inválido o no encontrado' });
    }
    
    const plaza_id = rows[0].plaza_id;
    
    // Verificar si ya existe un check-in reciente (último check-in en las últimas 2 horas)
    const twoHoursAgo = new Date(Date.now() - 2 * 60 * 60 * 1000);
    
    db.query(
      'SELECT * FROM checkins WHERE guardia_id = ? AND plaza_id = ? AND fecha > ?', 
      [req.session.guardia.id, plaza_id, twoHoursAgo], 
      (checkErr, existingCheckins) => {
        if (checkErr) {
          console.error('Error al verificar check-ins existentes:', checkErr);
          return res.status(500).json({ error: 'Error interno del servidor' });
        }
        
        if (existingCheckins.length > 0) {
          return res.status(409).json({ 
            error: 'Ya tienes un check-in reciente en esta plaza',
            lastCheckin: existingCheckins[0].fecha
          });
        }
        
        // Registrar el check-in
        db.query(
          'INSERT INTO checkins (guardia_id, plaza_id) VALUES (?, ?)', 
          [req.session.guardia.id, plaza_id], 
          (insertErr, result) => {
            if (insertErr) {
              console.error('Error al registrar check-in:', insertErr);
              return res.status(500).json({ error: 'Error al registrar check-in' });
            }
            
            // Obtener información de la plaza para la respuesta
            db.query(
              'SELECT nombre FROM plazas WHERE id = ?', 
              [plaza_id], 
              (plazaErr, plazaData) => {
                if (plazaErr) {
                  console.error('Error al obtener datos de plaza:', plazaErr);
                }
                
                res.json({ 
                  message: 'Check-in registrado correctamente',
                  checkinId: result.insertId,
                  plaza: plazaData.length > 0 ? plazaData[0].nombre : 'Plaza desconocida',
                  fecha: new Date()
                });
              }
            );
          }
        );
      }
    );
  });
});

// Ruta para obtener el historial de check-ins del guardia
router.get('/history', requireAuth, (req, res) => {
  const query = `
    SELECT c.id, c.fecha, p.nombre as plaza_nombre
    FROM checkins c 
    JOIN plazas p ON c.plaza_id = p.id 
    WHERE c.guardia_id = ? 
    ORDER BY c.fecha DESC 
    LIMIT 50
  `;
  
  db.query(query, [req.session.guardia.id], (err, results) => {
    if (err) {
      console.error('Error al obtener historial:', err);
      return res.status(500).json({ error: 'Error al obtener historial' });
    }
    
    res.json(results);
  });
});

module.exports = router;