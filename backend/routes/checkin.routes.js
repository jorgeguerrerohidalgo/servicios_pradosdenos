const express = require('express');
const router = express.Router();
const { query } = require('../utils/db');

// Middleware de autenticación
const requireAuth = (req, res, next) => {
  if (!req.session.guardia) {
    return res.status(401).json({ error: 'No autenticado' });
  }
  next();
};

// Middleware de validación
const validateCheckin = (req, res, next) => {
  const { token, validation_code } = req.body;
  
  if (!token || typeof token !== 'string' || token.trim() === '') {
    return res.status(400).json({ error: 'Token QR requerido y debe ser válido' });
  }
  
  if (!validation_code || typeof validation_code !== 'string' || validation_code.trim() === '') {
    return res.status(400).json({ error: 'Código de validación requerido' });
  }
  
  next();
};

// Endpoint para realizar check-in
router.post('/', requireAuth, validateCheckin, async (req, res) => {
  try {
    const { token, validation_code } = req.body;
    const guardia_id = req.session.guardia.id;
    
    // Verificar que el código de validación pertenece al guardia
    const guardiaData = await query('SELECT id, nombre, validation_code FROM guardias WHERE id = $1', [guardia_id]);
    
    if (guardiaData.length === 0) {
      return res.status(404).json({ error: 'Guardia no encontrado' });
    }
    
    if (guardiaData[0].validation_code !== validation_code.trim()) {
      return res.status(400).json({ error: 'Código de validación incorrecto' });
    }
    
    // Verificar que el token QR existe y obtener la plaza
    const tokenData = await query('SELECT plaza_id FROM plaza_tokens WHERE token = $1', [token.trim()]);
    
    if (tokenData.length === 0) {
      return res.status(400).json({ error: 'Token QR inválido o no encontrado' });
    }
    
    const plaza_id = tokenData[0].plaza_id;
    
    // Verificar si ya existe un check-in reciente (último check-in en las últimas 2 horas)
    const twoHoursAgo = new Date(Date.now() - 2 * 60 * 60 * 1000);
    
    const existingCheckins = await query(
      'SELECT * FROM checkins WHERE guardia_id = $1 AND plaza_id = $2 AND fecha > $3', 
      [guardia_id, plaza_id, twoHoursAgo]
    );
    
    if (existingCheckins.length > 0) {
      return res.status(409).json({ 
        error: 'Ya tienes un check-in reciente en esta plaza',
        lastCheckin: existingCheckins[0].fecha
      });
    }
    
    // Registrar el check-in
    const checkinResult = await query(
      'INSERT INTO checkins (guardia_id, plaza_id, ip_address, user_agent) VALUES ($1, $2, $3, $4) RETURNING id, fecha', 
      [guardia_id, plaza_id, req.ip, req.get('User-Agent')]
    );
    
    // Obtener información de la plaza para la respuesta
    const plazaData = await query('SELECT nombre FROM plazas WHERE id = $1', [plaza_id]);
    
    res.json({ 
      success: true,
      message: 'Check-in registrado correctamente',
      checkin: {
        id: checkinResult[0].id,
        fecha: checkinResult[0].fecha,
        plaza: plazaData.length > 0 ? plazaData[0].nombre : 'Plaza desconocida',
        guardia: guardiaData[0].nombre
      }
    });
    
  } catch (error) {
    console.error('Error al registrar check-in:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

// Ruta para obtener el historial de check-ins del guardia
router.get('/history', requireAuth, async (req, res) => {
  try {
    const historial = await query(`
      SELECT c.id, c.fecha AT TIME ZONE 'UTC' AT TIME ZONE 'America/Santiago' as fecha, p.nombre as plaza_nombre
      FROM checkins c 
      JOIN plazas p ON c.plaza_id = p.id 
      WHERE c.guardia_id = $1 
      ORDER BY c.fecha DESC 
      LIMIT 50
    `, [req.session.guardia.id]);
    
    res.json({ success: true, historial });
  } catch (error) {
    console.error('Error al obtener historial:', error);
    res.status(500).json({ error: 'Error al obtener historial' });
  }
});

// Ruta para obtener el código de validación del guardia
router.get('/validation-code', requireAuth, async (req, res) => {
  try {
    const guardiaData = await query('SELECT validation_code FROM guardias WHERE id = $1', [req.session.guardia.id]);
    
    if (guardiaData.length === 0) {
      return res.status(404).json({ error: 'Guardia no encontrado' });
    }
    
    res.json({ 
      success: true, 
      validation_code: guardiaData[0].validation_code 
    });
  } catch (error) {
    console.error('Error al obtener código de validación:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
});

module.exports = router;