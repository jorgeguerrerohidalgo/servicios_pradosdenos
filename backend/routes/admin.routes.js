const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const { query } = require('../utils/db');

// Middleware para verificar que el usuario es administrador
const requireAdmin = (req, res, next) => {
  if (!req.session.guardia || req.session.guardia.tipo !== 'admin') {
    return res.status(403).json({ success: false, message: 'Acceso denegado' });
  }
  next();
};

// ==================== GESTIÓN DE GUARDIAS ====================

// Obtener todos los guardias
router.get('/guardias', requireAdmin, async (req, res) => {
  try {
    const guardias = await query(`
      SELECT 
        id, nombre, email, telefono, activo, 
        created_at, last_login,
        CASE 
          WHEN last_login > NOW() - INTERVAL '7 days' THEN 'Activo'
          WHEN last_login > NOW() - INTERVAL '30 days' THEN 'Inactivo'
          ELSE 'Sin actividad'
        END as estado
      FROM guardias 
      ORDER BY created_at DESC
    `);
    
    res.json({ success: true, guardias });
  } catch (error) {
    console.error('Error obteniendo guardias:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Crear nuevo guardia
router.post('/guardias', requireAdmin, async (req, res) => {
  try {
    const { nombre, email, telefono, password } = req.body;
    
    // Validar campos requeridos
    if (!nombre || !email || !password) {
      return res.status(400).json({ success: false, message: 'Faltan campos requeridos' });
    }
    
    // Verificar si el email ya existe
    const existingGuard = await query('SELECT id FROM guardias WHERE email = $1', [email]);
    if (existingGuard.length > 0) {
      return res.status(400).json({ success: false, message: 'El email ya está registrado' });
    }
    
    // Hash de la contraseña
    const hashedPassword = await bcrypt.hash(password, 10);
    
    // Insertar guardia
    const result = await query(`
      INSERT INTO guardias (nombre, email, telefono, password, activo) 
      VALUES ($1, $2, $3, $4, true) 
      RETURNING id, nombre, email, telefono, activo, created_at
    `, [nombre, email, telefono, hashedPassword]);
    
    res.json({ success: true, guardia: result[0] });
  } catch (error) {
    console.error('Error creando guardia:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Actualizar guardia
router.put('/guardias/:id', requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, email, telefono, activo, password } = req.body;
    
    let updateFields = [];
    let params = [];
    let paramIndex = 1;
    
    if (nombre) {
      updateFields.push(`nombre = $${paramIndex++}`);
      params.push(nombre);
    }
    
    if (email) {
      updateFields.push(`email = $${paramIndex++}`);
      params.push(email);
    }
    
    if (telefono) {
      updateFields.push(`telefono = $${paramIndex++}`);
      params.push(telefono);
    }
    
    if (typeof activo === 'boolean') {
      updateFields.push(`activo = $${paramIndex++}`);
      params.push(activo);
    }
    
    if (password) {
      const hashedPassword = await bcrypt.hash(password, 10);
      updateFields.push(`password = $${paramIndex++}`);
      params.push(hashedPassword);
    }
    
    if (updateFields.length === 0) {
      return res.status(400).json({ success: false, message: 'No hay campos para actualizar' });
    }
    
    params.push(id);
    
    const result = await query(`
      UPDATE guardias 
      SET ${updateFields.join(', ')} 
      WHERE id = $${paramIndex}
      RETURNING id, nombre, email, telefono, activo, created_at
    `, params);
    
    if (result.length === 0) {
      return res.status(404).json({ success: false, message: 'Guardia no encontrado' });
    }
    
    res.json({ success: true, guardia: result[0] });
  } catch (error) {
    console.error('Error actualizando guardia:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Eliminar guardia
router.delete('/guardias/:id', requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    // Verificar si el guardia tiene checkins
    const checkins = await query('SELECT COUNT(*) as total FROM checkins WHERE guardia_id = $1', [id]);
    const totalCheckins = parseInt(checkins[0].total);
    
    if (totalCheckins > 0) {
      // Solo desactivar si tiene checkins
      await query('UPDATE guardias SET activo = false WHERE id = $1', [id]);
      res.json({ success: true, message: 'Guardia desactivado (tiene registros asociados)' });
    } else {
      // Eliminar completamente si no tiene checkins
      const result = await query('DELETE FROM guardias WHERE id = $1 RETURNING id', [id]);
      if (result.length === 0) {
        return res.status(404).json({ success: false, message: 'Guardia no encontrado' });
      }
      res.json({ success: true, message: 'Guardia eliminado' });
    }
  } catch (error) {
    console.error('Error eliminando guardia:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// ==================== GESTIÓN DE PLAZAS ====================

// Obtener todas las plazas
router.get('/plazas', requireAdmin, async (req, res) => {
  try {
    const plazas = await query(`
      SELECT 
        p.id, p.nombre, p.direccion, p.descripcion, p.activo,
        COUNT(c.id) as total_checkins,
        MAX(c.fecha) as ultimo_checkin
      FROM plazas p
      LEFT JOIN checkins c ON p.id = c.plaza_id
      GROUP BY p.id, p.nombre, p.direccion, p.descripcion, p.activo
      ORDER BY p.nombre ASC
    `);
    
    res.json({ success: true, plazas });
  } catch (error) {
    console.error('Error obteniendo plazas:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Crear nueva plaza
router.post('/plazas', requireAdmin, async (req, res) => {
  try {
    const { nombre, direccion, descripcion } = req.body;
    
    if (!nombre) {
      return res.status(400).json({ success: false, message: 'El nombre es requerido' });
    }
    
    const result = await query(`
      INSERT INTO plazas (nombre, direccion, descripcion, activo) 
      VALUES ($1, $2, $3, true) 
      RETURNING id, nombre, direccion, descripcion, activo
    `, [nombre, direccion || null, descripcion || null]);
    
    res.json({ success: true, plaza: result[0] });
  } catch (error) {
    console.error('Error creando plaza:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Actualizar plaza
router.put('/plazas/:id', requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, direccion, descripcion, activo } = req.body;
    
    let updateFields = [];
    let params = [];
    let paramIndex = 1;
    
    if (nombre) {
      updateFields.push(`nombre = $${paramIndex++}`);
      params.push(nombre);
    }
    
    if (direccion !== undefined) {
      updateFields.push(`direccion = $${paramIndex++}`);
      params.push(direccion);
    }
    
    if (descripcion !== undefined) {
      updateFields.push(`descripcion = $${paramIndex++}`);
      params.push(descripcion);
    }
    
    if (typeof activo === 'boolean') {
      updateFields.push(`activo = $${paramIndex++}`);
      params.push(activo);
    }
    
    if (updateFields.length === 0) {
      return res.status(400).json({ success: false, message: 'No hay campos para actualizar' });
    }
    
    params.push(id);
    
    const result = await query(`
      UPDATE plazas 
      SET ${updateFields.join(', ')} 
      WHERE id = $${paramIndex}
      RETURNING id, nombre, direccion, descripcion, activo
    `, params);
    
    if (result.length === 0) {
      return res.status(404).json({ success: false, message: 'Plaza no encontrada' });
    }
    
    res.json({ success: true, plaza: result[0] });
  } catch (error) {
    console.error('Error actualizando plaza:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Eliminar plaza
router.delete('/plazas/:id', requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    // Verificar si la plaza tiene checkins
    const checkins = await query('SELECT COUNT(*) as total FROM checkins WHERE plaza_id = $1', [id]);
    const totalCheckins = parseInt(checkins[0].total);
    
    if (totalCheckins > 0) {
      // Solo desactivar si tiene checkins
      await query('UPDATE plazas SET activo = false WHERE id = $1', [id]);
      res.json({ success: true, message: 'Plaza desactivada (tiene registros asociados)' });
    } else {
      // Eliminar completamente si no tiene checkins
      const result = await query('DELETE FROM plazas WHERE id = $1 RETURNING id', [id]);
      if (result.length === 0) {
        return res.status(404).json({ success: false, message: 'Plaza no encontrada' });
      }
      res.json({ success: true, message: 'Plaza eliminada' });
    }
  } catch (error) {
    console.error('Error eliminando plaza:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// ==================== GESTIÓN DE ADMINISTRADORES ====================

// Obtener todos los administradores
router.get('/admins', requireAdmin, async (req, res) => {
  try {
    const admins = await query(`
      SELECT 
        id, nombre, apellido_paterno, apellido_materno, email, 
        telefono, activo, created_at, last_login
      FROM admin_users 
      ORDER BY created_at DESC
    `);
    
    res.json({ success: true, admins });
  } catch (error) {
    console.error('Error obteniendo administradores:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Crear nuevo administrador
router.post('/admins', requireAdmin, async (req, res) => {
  try {
    const { nombre, apellido_paterno, apellido_materno, email, telefono, password } = req.body;
    
    if (!nombre || !apellido_paterno || !email || !password) {
      return res.status(400).json({ success: false, message: 'Faltan campos requeridos' });
    }
    
    // Verificar si el email ya existe
    const existingAdmin = await query('SELECT id FROM admin_users WHERE email = $1', [email]);
    if (existingAdmin.length > 0) {
      return res.status(400).json({ success: false, message: 'El email ya está registrado' });
    }
    
    // Hash de la contraseña
    const hashedPassword = await bcrypt.hash(password, 10);
    
    const result = await query(`
      INSERT INTO admin_users (nombre, apellido_paterno, apellido_materno, email, telefono, password_hash, activo) 
      VALUES ($1, $2, $3, $4, $5, $6, true) 
      RETURNING id, nombre, apellido_paterno, apellido_materno, email, telefono, activo, created_at
    `, [nombre, apellido_paterno, apellido_materno || null, email, telefono || null, hashedPassword]);
    
    res.json({ success: true, admin: result[0] });
  } catch (error) {
    console.error('Error creando administrador:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Actualizar administrador
router.put('/admins/:id', requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, apellido_paterno, apellido_materno, email, telefono, activo, password } = req.body;
    
    let updateFields = [];
    let params = [];
    let paramIndex = 1;
    
    if (nombre) {
      updateFields.push(`nombre = $${paramIndex++}`);
      params.push(nombre);
    }
    
    if (apellido_paterno) {
      updateFields.push(`apellido_paterno = $${paramIndex++}`);
      params.push(apellido_paterno);
    }
    
    if (apellido_materno !== undefined) {
      updateFields.push(`apellido_materno = $${paramIndex++}`);
      params.push(apellido_materno);
    }
    
    if (email) {
      updateFields.push(`email = $${paramIndex++}`);
      params.push(email);
    }
    
    if (telefono !== undefined) {
      updateFields.push(`telefono = $${paramIndex++}`);
      params.push(telefono);
    }
    
    if (typeof activo === 'boolean') {
      updateFields.push(`activo = $${paramIndex++}`);
      params.push(activo);
    }
    
    if (password) {
      const hashedPassword = await bcrypt.hash(password, 10);
      updateFields.push(`password_hash = $${paramIndex++}`);
      params.push(hashedPassword);
    }
    
    if (updateFields.length === 0) {
      return res.status(400).json({ success: false, message: 'No hay campos para actualizar' });
    }
    
    params.push(id);
    
    const result = await query(`
      UPDATE admin_users 
      SET ${updateFields.join(', ')} 
      WHERE id = $${paramIndex}
      RETURNING id, nombre, apellido_paterno, apellido_materno, email, telefono, activo, created_at
    `, params);
    
    if (result.length === 0) {
      return res.status(404).json({ success: false, message: 'Administrador no encontrado' });
    }
    
    res.json({ success: true, admin: result[0] });
  } catch (error) {
    console.error('Error actualizando administrador:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Eliminar administrador
router.delete('/admins/:id', requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    // No permitir auto-eliminación
    if (parseInt(id) === req.session.guardia.id) {
      return res.status(400).json({ success: false, message: 'No puedes eliminar tu propia cuenta' });
    }
    
    const result = await query('DELETE FROM admin_users WHERE id = $1 RETURNING id', [id]);
    if (result.length === 0) {
      return res.status(404).json({ success: false, message: 'Administrador no encontrado' });
    }
    
    res.json({ success: true, message: 'Administrador eliminado' });
  } catch (error) {
    console.error('Error eliminando administrador:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// ==================== REPORTES Y ESTADÍSTICAS ====================

// Estadísticas generales
router.get('/stats', requireAdmin, async (req, res) => {
  try {
    console.log('Obteniendo estadísticas del dashboard...');
    
    const stats = await Promise.all([
      query('SELECT COUNT(*) as total FROM plazas WHERE activo = true'),
      query('SELECT COUNT(*) as total FROM guardias WHERE activo = true'),
      query(`SELECT COUNT(*) as total FROM checkins 
             WHERE fecha::date >= (CURRENT_DATE - INTERVAL '7 days')`),
      query(`SELECT COUNT(*) as total FROM checkins 
             WHERE fecha::date = CURRENT_DATE`),
      query(`SELECT COUNT(*) as total FROM checkins 
             WHERE fecha::date >= (CURRENT_DATE - INTERVAL '30 days')`),
      query('SELECT COUNT(*) as total FROM checkins'),
    ]);
    
    const result = {
      success: true,
      stats: {
        total_plazas: parseInt(stats[0][0].total) || 0,
        guardias_activos: parseInt(stats[1][0].total) || 0,
        checkins_semana: parseInt(stats[2][0].total) || 0,
        checkins_hoy: parseInt(stats[3][0].total) || 0,
        checkins_mes: parseInt(stats[4][0].total) || 0,
        checkins_total: parseInt(stats[5][0].total) || 0
      }
    };
    
    console.log('Estadísticas obtenidas:', result);
    res.json(result);
  } catch (error) {
    console.error('Error obteniendo estadísticas:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error interno del servidor',
      error: error.message 
    });
  }
});

// Reporte de actividad por fechas
router.get('/reports/activity', requireAdmin, async (req, res) => {
  try {
    const { fecha_inicio, fecha_fin } = req.query;
    
    let whereClause = '';
    let params = [];
    
    if (fecha_inicio && fecha_fin) {
      whereClause = 'WHERE c.fecha BETWEEN $1 AND $2';
      params = [fecha_inicio, fecha_fin];
    } else if (fecha_inicio) {
      whereClause = 'WHERE c.fecha >= $1';
      params = [fecha_inicio];
    } else {
      // Por defecto, últimos 30 días
      whereClause = 'WHERE c.fecha >= CURRENT_DATE - INTERVAL \'30 days\'';
    }
    
    const actividad = await query(`
      SELECT 
        p.nombre as plaza_nombre,
        g.nombre as guardia_nombre,
        COUNT(c.id) as total_checkins,
        MAX(c.fecha) as ultimo_checkin,
        MIN(c.fecha) as primer_checkin
      FROM checkins c
      JOIN plazas p ON c.plaza_id = p.id
      JOIN guardias g ON c.guardia_id = g.id
      ${whereClause}
      GROUP BY p.id, p.nombre, g.id, g.nombre
      ORDER BY total_checkins DESC
    `, params);
    
    res.json({ success: true, actividad });
  } catch (error) {
    console.error('Error obteniendo reporte de actividad:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Reporte de checkins recientes
router.get('/reports/recent', requireAdmin, async (req, res) => {
  try {
    const limite = parseInt(req.query.limit) || 50;
    
    const checkins = await query(`
      SELECT 
        c.id,
        c.fecha AT TIME ZONE 'UTC' AT TIME ZONE 'America/Santiago' as fecha,
        p.nombre as plaza_nombre,
        g.nombre as guardia_nombre,
        g.email as guardia_email
      FROM checkins c
      JOIN plazas p ON c.plaza_id = p.id
      JOIN guardias g ON c.guardia_id = g.id
      ORDER BY c.fecha DESC
      LIMIT $1
    `, [limite]);
    
    res.json({ success: true, checkins });
  } catch (error) {
    console.error('Error obteniendo checkins recientes:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

module.exports = router;
