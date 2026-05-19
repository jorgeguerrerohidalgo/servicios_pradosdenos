const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const { query, pool } = require('../utils/db');
const { requireAuth, requireAdmin, requireAuthAdmin } = require('../middleware/sessionAuth');
const { requirePermission } = require('../middleware/rbac');

// ==================== GESTIÓN DE GUARDIAS ====================

// Obtener todos los guardias
router.get('/guardias', requireAuthAdmin, async (req, res) => {
  try {
    const guardias = await query(`
      SELECT 
        id, nombre, email, telefono, activo, validation_code,
        created_at, last_login,
        CASE 
          WHEN last_login > NOW() - INTERVAL '7 days' THEN 'Activo'
          WHEN last_login > NOW() - INTERVAL '30 days' THEN 'Inactivo'
          ELSE 'Sin actividad'
        END as estado
      FROM guardias 
      ORDER BY created_at DESC
    `);
    
    res.json({ success: true, data: guardias, guardias: guardias });
  } catch (error) {
    console.error('Error obteniendo guardias:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// GET /api/admin/guardias/:id - Obtener guardia por ID
router.get('/guardias/:id', requireAuthAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    const guardias = await query(`
      SELECT 
        id, nombre, rut, email, telefono, activo, validation_code,
        created_at, last_login,
        CASE 
          WHEN last_login > NOW() - INTERVAL '7 days' THEN 'Activo'
          WHEN last_login > NOW() - INTERVAL '30 days' THEN 'Inactivo'
          ELSE 'Sin actividad'
        END as estado
      FROM guardias 
      WHERE id = $1
    `, [id]);
    
    if (guardias.length === 0) {
      return res.status(404).json({ success: false, message: 'Guardia no encontrado' });
    }
    
    res.json({ success: true, data: guardias[0] });
  } catch (error) {
    console.error('Error obteniendo guardia:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Crear nuevo guardia
router.post('/guardias', requireAuth, requirePermission('guardias.crear'), async (req, res) => {
  try {
    const { nombre, rut, email, telefono, password } = req.body;
    
    // Validar campos requeridos
    if (!nombre || !rut || !email || !password) {
      return res.status(400).json({ success: false, message: 'Faltan campos requeridos' });
    }
    
    // Verificar si el email ya existe
    const existingEmail = await query('SELECT id FROM guardias WHERE email = $1', [email]);
    if (existingEmail.length > 0) {
      return res.status(400).json({ success: false, message: 'El email ya está registrado' });
    }
    
    // Verificar si el RUT ya existe
    const existingRut = await query('SELECT id FROM guardias WHERE rut = $1', [rut]);
    if (existingRut.length > 0) {
      return res.status(400).json({ success: false, message: 'El RUT ya está registrado' });
    }
    
    // Hash de la contraseña
    const bcrypt = require('bcrypt');
    const hashedPassword = await bcrypt.hash(password, 10);
    
    // Generar código de validación único
    const validationCode = await generateUniqueValidationCode();
    
    // Insertar guardia
    const result = await query(`
      INSERT INTO guardias (nombre, rut, email, telefono, password, activo, validation_code) 
      VALUES ($1, $2, $3, $4, $5, true, $6) 
      RETURNING id, nombre, rut, email, telefono, activo, validation_code, created_at
    `, [nombre, rut, email, telefono, hashedPassword, validationCode]);
    
    res.json({ success: true, data: result[0] });
  } catch (error) {
    console.error('Error creando guardia:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Función para generar código de validación único
async function generateUniqueValidationCode() {
  let code;
  let attempts = 0;
  const maxAttempts = 10;
  
  do {
    // Generar código de 4 dígitos
    code = Math.floor(1000 + Math.random() * 9000).toString();
    
    // Verificar si ya existe
    const existing = await query('SELECT id FROM guardias WHERE validation_code = $1', [code]);
    if (existing.length === 0) {
      return code;
    }
    
    attempts++;
  } while (attempts < maxAttempts);
  
  // Si no se pudo generar un código único, usar timestamp
  return Date.now().toString().slice(-4);
}

// Actualizar guardia
router.put('/guardias/:id', requireAuth, requirePermission('guardias.editar'), async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, rut, email, telefono, activo, password } = req.body;
    
    let updateFields = [];
    let params = [];
    let paramIndex = 1;
    
    if (nombre) {
      updateFields.push(`nombre = $${paramIndex++}`);
      params.push(nombre);
    }
    
    if (rut) {
      // Verificar si el RUT ya existe en otro guardia
      const existingRut = await query('SELECT id FROM guardias WHERE rut = $1 AND id != $2', [rut, id]);
      if (existingRut.length > 0) {
        return res.status(400).json({ success: false, message: 'El RUT ya está registrado en otro guardia' });
      }
      updateFields.push(`rut = $${paramIndex++}`);
      params.push(rut);
    }
    
    if (email) {
      // Verificar si el email ya existe en otro guardia
      const existingEmail = await query('SELECT id FROM guardias WHERE email = $1 AND id != $2', [email, id]);
      if (existingEmail.length > 0) {
        return res.status(400).json({ success: false, message: 'El email ya está registrado en otro guardia' });
      }
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
      const bcrypt = require('bcrypt');
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
      RETURNING id, nombre, rut, email, telefono, activo, created_at
    `, params);
    
    if (result.length === 0) {
      return res.status(404).json({ success: false, message: 'Guardia no encontrado' });
    }
    
    res.json({ success: true, data: result[0] });
  } catch (error) {
    console.error('Error actualizando guardia:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Eliminar guardia
router.delete('/guardias/:id', requireAuth, requirePermission('guardias.eliminar'), async (req, res) => {
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

// Regenerar código de validación para un guardia
router.post('/guardias/:id/regenerar-codigo', requireAuth, requirePermission('guardias.editar'), async (req, res) => {
  try {
    const { id } = req.params;
    
    // Verificar que el guardia existe
    const guardiaExists = await query('SELECT id FROM guardias WHERE id = $1', [id]);
    if (guardiaExists.length === 0) {
      return res.status(404).json({ success: false, message: 'Guardia no encontrado' });
    }
    
    // Generar nuevo código de validación
    const newValidationCode = await generateUniqueValidationCode();
    
    // Actualizar el código
    await query('UPDATE guardias SET validation_code = $1 WHERE id = $2', [newValidationCode, id]);
    
    res.json({ 
      success: true, 
      message: 'Código de validación regenerado exitosamente',
      validation_code: newValidationCode
    });
  } catch (error) {
    console.error('Error regenerando código:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// ==================== GESTIÓN DE PLAZAS ====================

// Obtener todas las plazas
router.get('/plazas', requireAuthAdmin, async (req, res) => {
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
    
    res.json({ success: true, data: plazas, plazas: plazas });
  } catch (error) {
    console.error('Error obteniendo plazas:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// GET /api/admin/plazas/:id - Obtener plaza por ID
router.get('/plazas/:id', requireAuthAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    const plazas = await query(`
      SELECT 
        p.id, p.nombre, p.direccion, p.descripcion, p.activo,
        p.created_at, p.updated_at,
        COUNT(c.id) as total_checkins,
        MAX(c.fecha) as ultimo_checkin
      FROM plazas p
      LEFT JOIN checkins c ON p.id = c.plaza_id
      WHERE p.id = $1
      GROUP BY p.id, p.nombre, p.direccion, p.descripcion, p.activo, p.created_at, p.updated_at
    `, [id]);
    
    if (plazas.length === 0) {
      return res.status(404).json({ success: false, message: 'Plaza no encontrada' });
    }
    
    res.json({ success: true, data: plazas[0] });
  } catch (error) {
    console.error('Error obteniendo plaza:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Crear nueva plaza
router.post('/plazas', requireAuth, requirePermission('plazas.crear'), async (req, res) => {
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
    
    res.json({ success: true, data: result[0] });
  } catch (error) {
    console.error('Error creando plaza:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Actualizar plaza
router.put('/plazas/:id', requireAuth, requirePermission('plazas.editar'), async (req, res) => {
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
    
    res.json({ success: true, data: result[0] });
  } catch (error) {
    console.error('Error actualizando plaza:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Eliminar plaza
router.delete('/plazas/:id', requireAuth, requirePermission('plazas.eliminar'), async (req, res) => {
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
router.get('/admins', requireAuthAdmin, async (req, res) => {
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

// Obtener administrador específico por ID
router.get('/admins/:id', requireAuthAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    
    const admin = await query(`
      SELECT 
        id, nombre, apellido_paterno, apellido_materno, email, 
        telefono, activo, created_at, last_login
      FROM admin_users 
      WHERE id = $1
    `, [id]);
    
    if (admin.length === 0) {
      return res.status(404).json({ success: false, message: 'Administrador no encontrado' });
    }
    
    res.json({ success: true, admin: admin[0] });
  } catch (error) {
    console.error('Error obteniendo administrador:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Crear nuevo administrador
router.post('/admins', requireAuth, requirePermission('administradores.crear'), async (req, res) => {
  try {
    const { nombre, apellido_paterno, apellido_materno, email, telefono, password } = req.body;
    
    if (!nombre || !apellido_paterno || !email || !password) {
      return res.status(400).json({ success: false, message: 'Faltan campos requeridos' });
    }
    
    // Verificar si el email ya existe (usando pool directamente para PostgreSQL)
    const existingCheck = await pool.query('SELECT id FROM admin_users WHERE email = $1', [email]);
    if (existingCheck.rows.length > 0) {
      return res.status(400).json({ success: false, message: 'El email ya está registrado' });
    }
    
    // Hash de la contraseña
    const hashedPassword = await bcrypt.hash(password, 10);
    
    // Insertar usando pool directamente (PostgreSQL nativo)
    const result = await pool.query(`
      INSERT INTO admin_users (nombre, apellido_paterno, apellido_materno, email, telefono, password_hash, activo) 
      VALUES ($1, $2, $3, $4, $5, $6, true) 
      RETURNING id, nombre, apellido_paterno, apellido_materno, email, telefono, activo, created_at
    `, [nombre, apellido_paterno, apellido_materno || null, email, telefono || null, hashedPassword]);
    
    res.json({ success: true, admin: result.rows[0] });
  } catch (error) {
    console.error('Error creando administrador:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// Actualizar administrador
router.put('/admins/:id', requireAuth, requirePermission('administradores.editar'), async (req, res) => {
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
router.delete('/admins/:id', requireAuth, requirePermission('administradores.eliminar'), async (req, res) => {
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
router.get('/stats', requireAuth, requirePermission('dashboard.leer'), async (req, res) => {
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
router.get('/reports/activity', requireAuth, requirePermission('reportes.leer'), async (req, res) => {
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
router.get('/reports/recent', requireAuthAdmin, async (req, res) => {
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

// Reporte completo de checkins con filtros y ordenamiento
router.get('/reports/checkins', requireAuth, requirePermission('reportes.leer'), async (req, res) => {
  try {
    const { fecha_inicio, fecha_fin, orden_campo, orden_direccion } = req.query;
    
    // Construir cláusula WHERE
    let whereClause = 'WHERE 1=1';
    let params = [];
    let paramIndex = 1;
    
    if (fecha_inicio) {
      whereClause += ` AND c.fecha >= $${paramIndex}`;
      params.push(fecha_inicio + ' 00:00:00');
      paramIndex++;
    }
    
    if (fecha_fin) {
      whereClause += ` AND c.fecha <= $${paramIndex}`;
      params.push(fecha_fin + ' 23:59:59');
      paramIndex++;
    }
    
    // Construir cláusula ORDER BY
    let orderClause = 'ORDER BY c.fecha DESC';
    const camposValidos = ['fecha', 'plaza_nombre', 'guardia_nombre', 'guardia_email'];
    const direccionesValidas = ['ASC', 'DESC'];
    
    if (orden_campo && camposValidos.includes(orden_campo)) {
      const direccion = (orden_direccion && direccionesValidas.includes(orden_direccion.toUpperCase())) 
        ? orden_direccion.toUpperCase() 
        : 'ASC';
      
      switch (orden_campo) {
        case 'fecha':
          orderClause = `ORDER BY c.fecha ${direccion}`;
          break;
        case 'plaza_nombre':
          orderClause = `ORDER BY p.nombre ${direccion}`;
          break;
        case 'guardia_nombre':
          orderClause = `ORDER BY g.nombre ${direccion}`;
          break;
        case 'guardia_email':
          orderClause = `ORDER BY g.email ${direccion}`;
          break;
      }
    }
    
    const checkins = await query(`
      SELECT 
        c.id,
        TO_CHAR(c.fecha AT TIME ZONE 'UTC' AT TIME ZONE 'America/Santiago', 'DD/MM/YYYY HH24:MI:SS') as fecha,
        p.nombre as plaza_nombre,
        g.nombre as guardia_nombre,
        g.email as guardia_email,
        g.telefono as guardia_telefono
      FROM checkins c
      JOIN plazas p ON c.plaza_id = p.id
      JOIN guardias g ON c.guardia_id = g.id
      ${whereClause}
      ${orderClause}
    `, params);
    
    // Estadísticas adicionales
    const totalCheckins = checkins.length;
    const plazasUnicas = [...new Set(checkins.map(c => c.plaza_nombre))];
    const guardiasUnicos = [...new Set(checkins.map(c => c.guardia_nombre))];
    
    res.json({ 
      success: true, 
      checkins,
      estadisticas: {
        total_checkins: totalCheckins,
        total_plazas: plazasUnicas.length,
        total_guardias: guardiasUnicos.length,
        fecha_inicio: fecha_inicio || 'Sin filtro',
        fecha_fin: fecha_fin || 'Sin filtro'
      }
    });
  } catch (error) {
    console.error('Error obteniendo reporte de checkins:', error);
    res.status(500).json({ success: false, message: 'Error interno del servidor' });
  }
});

// ==================== ENDPOINT TEMPORAL: GENERAR TOKENS ====================
// Endpoint temporal para generar tokens automáticamente para plazas sin token
router.post('/generate-tokens', requireAuth, requirePermission('tokens.crear'), async (req, res) => {
  try {
    console.log('=== GENERANDO TOKENS FALTANTES ===');
    
    // Obtener plazas sin token
    const plazasSinToken = await query(`
      SELECT p.id, p.nombre
      FROM plazas p
      LEFT JOIN plaza_tokens pt ON p.id = pt.plaza_id
      WHERE p.activo = TRUE AND pt.token IS NULL
    `);
    
    console.log(`Plazas sin token encontradas: ${plazasSinToken.length}`);
    
    if (plazasSinToken.length === 0) {
      return res.json({ 
        success: true, 
        message: 'Todas las plazas ya tienen tokens asignados',
        tokensGenerados: 0 
      });
    }
    
    let tokensGenerados = 0;
    const errores = [];
    
    // Generar tokens para cada plaza
    for (const plaza of plazasSinToken) {
      const token = `qr-plaza-${plaza.id}-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
      
      try {
        await query(`
          INSERT INTO plaza_tokens (plaza_id, token, created_at)
          VALUES ($1, $2, NOW())
        `, [plaza.id, token]);
        
        tokensGenerados++;
        console.log(`✓ Token generado para ${plaza.nombre}: ${token}`);
      } catch (error) {
        console.error(`✗ Error generando token para ${plaza.nombre}:`, error.message);
        errores.push(`Error en ${plaza.nombre}: ${error.message}`);
      }
    }
    
    // Verificación final
    const verificacion = await query(`
      SELECT p.id, p.nombre, pt.token
      FROM plazas p
      LEFT JOIN plaza_tokens pt ON p.id = pt.plaza_id
      WHERE p.activo = TRUE
      ORDER BY p.nombre ASC
    `);
    
    const conToken = verificacion.filter(p => p.token);
    const sinToken = verificacion.filter(p => !p.token);
    
    res.json({
      success: true,
      message: `Tokens generados exitosamente`,
      tokensGenerados,
      errores,
      estadoFinal: {
        totalPlazas: verificacion.length,
        plazasConToken: conToken.length,
        plazasSinToken: sinToken.length
      }
    });
    
  } catch (error) {
    console.error('Error generando tokens:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error interno del servidor',
      error: error.message 
    });
  }
});

// ==================== CORRECCIÓN DE DUPLICADOS ====================

// Verificar duplicados de plazas
router.get('/check-duplicates', requireAuth, requirePermission('dashboard.leer'), async (req, res) => {
  try {
    console.log('🔍 Verificando duplicados de plazas...');
    
    // Buscar plazas duplicadas
    const duplicados = await query(`
      SELECT nombre, COUNT(*) as cantidad
      FROM plazas
      GROUP BY nombre
      HAVING COUNT(*) > 1
      ORDER BY cantidad DESC
    `);
    
    if (duplicados.length === 0) {
      return res.json({
        success: true,
        message: 'No hay plazas duplicadas',
        duplicados: []
      });
    }
    
    // Obtener detalles de las plazas duplicadas
    const detalles = await query(`
      SELECT id, nombre, direccion, descripcion, activo, created_at
      FROM plazas
      WHERE nombre IN (
        SELECT nombre
        FROM plazas
        GROUP BY nombre
        HAVING COUNT(*) > 1
      )
      ORDER BY nombre, id
    `);
    
    res.json({
      success: true,
      message: `Encontrados ${duplicados.length} grupos de plazas duplicadas`,
      duplicados,
      detalles
    });
    
  } catch (error) {
    console.error('Error verificando duplicados:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error verificando duplicados',
      error: error.message 
    });
  }
});

// Corregir duplicados de plazas
router.post('/fix-duplicates', requireAuth, requirePermission('dashboard.editar'), async (req, res) => {
  try {
    console.log('🛠️ Iniciando corrección de duplicados...');
    
    // Verificar si hay duplicados
    const duplicados = await query(`
      SELECT nombre, COUNT(*) as cantidad
      FROM plazas
      GROUP BY nombre
      HAVING COUNT(*) > 1
    `);
    
    if (duplicados.length === 0) {
      return res.json({
        success: true,
        message: 'No hay plazas duplicadas para corregir',
        eliminados: 0
      });
    }
    
    console.log(`🔍 Encontrados ${duplicados.length} grupos de duplicados`);
    
    // Obtener IDs de plazas duplicadas (conservar la primera)
    const idsParaEliminar = await query(`
      SELECT p2.id, p2.nombre
      FROM plazas p1
      JOIN plazas p2 ON p1.nombre = p2.nombre AND p1.id < p2.id
      WHERE p1.nombre IN (
        SELECT nombre
        FROM plazas
        GROUP BY nombre
        HAVING COUNT(*) > 1
      )
    `);
    
    console.log(`🗑️ Plazas a eliminar: ${idsParaEliminar.length}`);
    
    let tokensEliminados = 0;
    let checkinsAfectados = 0;
    
    if (idsParaEliminar.length > 0) {
      const idsArray = idsParaEliminar.map(row => row.id);
      
      // Eliminar tokens de plazas duplicadas
      const tokensResult = await query(`
        DELETE FROM plaza_tokens
        WHERE plaza_id = ANY($1::int[])
      `, [idsArray]);
      tokensEliminados = tokensResult.rowCount || 0;
      
      // Eliminar checkins asociados a plazas duplicadas
      const checkinsResult = await query(`
        DELETE FROM checkins
        WHERE plaza_id = ANY($1::int[])
      `, [idsArray]);
      checkinsAfectados = checkinsResult.rowCount || 0;
      
      // Actualizar admin_users para quitar referencias a plazas duplicadas
      await query(`
        UPDATE admin_users
        SET plaza_id = NULL
        WHERE plaza_id = ANY($1::int[])
      `, [idsArray]);
      
      // Finalmente, eliminar las plazas duplicadas
      const plazasResult = await query(`
        DELETE FROM plazas
        WHERE id = ANY($1::int[])
      `, [idsArray]);
      
      console.log(`✅ Eliminadas ${plazasResult.rowCount} plazas duplicadas`);
      console.log(`🔑 Eliminados ${tokensEliminados} tokens`);
      console.log(`📝 Afectados ${checkinsAfectados} checkins`);
    }
    
    // Verificación final
    const duplicadosFinales = await query(`
      SELECT nombre, COUNT(*) as cantidad
      FROM plazas
      GROUP BY nombre
      HAVING COUNT(*) > 1
    `);
    
    const plazasFinales = await query(`
      SELECT id, nombre, direccion, activo
      FROM plazas
      ORDER BY id
    `);
    
    res.json({
      success: true,
      message: 'Duplicados corregidos exitosamente',
      eliminados: idsParaEliminar.length,
      tokensEliminados,
      checkinsAfectados,
      duplicadosRestantes: duplicadosFinales.length,
      totalPlazas: plazasFinales.length,
      plazasFinales
    });
    
  } catch (error) {
    console.error('Error corrigiendo duplicados:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error corrigiendo duplicados',
      error: error.message 
    });
  }
});

module.exports = router;
