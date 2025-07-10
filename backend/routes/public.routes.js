const express = require('express');
const router = express.Router();
const { query } = require('../utils/db');

// Obtener todas las plazas para el dropdown
router.get('/plazas', async (req, res) => {
  try {
    console.log('📍 Solicitando lista de plazas...');
    
    const plazas = await query('SELECT id, nombre FROM plazas ORDER BY nombre ASC');
    
    console.log('✅ Plazas encontradas:', plazas.length);
    res.json(plazas);
  } catch (error) {
    console.error('❌ Error obteniendo plazas:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error interno del servidor' 
    });
  }
});

// Obtener checkins de una plaza específica
router.get('/checkins/:plazaId', async (req, res) => {
  try {
    const { plazaId } = req.params;
    
    console.log('🔍 Consultando checkins para plaza ID:', plazaId);
    
    // Validar que plazaId sea un número
    if (!plazaId || isNaN(plazaId)) {
      return res.status(400).json({
        success: false,
        message: 'ID de plaza inválido'
      });
    }

    // Obtener los últimos 50 checkins de la plaza, con datos del guardia
    // Convertir fecha a zona horaria de Santiago
    const registros = await query(`
      SELECT 
        g.nombre as guardia_nombre,
        c.fecha AT TIME ZONE 'UTC' AT TIME ZONE 'America/Santiago' as fecha,
        c.fecha as fecha_utc
      FROM checkins c
      INNER JOIN guardias g ON c.guardia_id = g.id
      WHERE c.plaza_id = $1
      ORDER BY c.fecha DESC
      LIMIT 50
    `, [plazaId]);

    console.log('📊 Registros encontrados:', registros.length);

    // Formatear las fechas para el frontend
    const registrosFormateados = registros.map(registro => ({
      guardia_nombre: registro.guardia_nombre,
      fecha: registro.fecha,
      fecha_formateada: new Date(registro.fecha).toLocaleString('es-CL', {
        timeZone: 'America/Santiago',
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
      })
    }));

    res.json({
      success: true,
      registros: registrosFormateados,
      total: registros.length
    });

  } catch (error) {
    console.error('❌ Error obteniendo checkins:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error interno del servidor' 
    });
  }
});

// Obtener checkins con filtros para consulta pública
router.get('/checkins/public', async (req, res) => {
  try {
    const { plaza_id, periodo } = req.query;
    
    console.log('🔍 Consulta pública de checkins - Plaza:', plaza_id, 'Período:', periodo);
    
    let sql = `
      SELECT 
        c.id,
        c.fecha AT TIME ZONE 'UTC' AT TIME ZONE 'America/Santiago' as fecha,
        p.nombre as plaza_nombre,
        g.nombre as guardia_nombre,
        c.plaza_id
      FROM checkins c
      INNER JOIN plazas p ON c.plaza_id = p.id
      INNER JOIN guardias g ON c.guardia_id = g.id
      WHERE 1=1
    `;
    
    const params = [];
    let paramIndex = 1;
    
    // Filtro por plaza
    if (plaza_id && plaza_id !== '') {
      sql += ` AND c.plaza_id = $${paramIndex}`;
      params.push(plaza_id);
      paramIndex++;
    }
    
    // Filtro por período
    if (periodo && periodo !== 'todos') {
      const now = "CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'";
      
      switch (periodo) {
        case 'hoy':
          sql += ` AND c.fecha >= DATE_TRUNC('day', ${now})`;
          break;
        case 'ayer':
          sql += ` AND c.fecha >= DATE_TRUNC('day', ${now}) - INTERVAL '1 day'`;
          sql += ` AND c.fecha < DATE_TRUNC('day', ${now})`;
          break;
        case 'semana':
          sql += ` AND c.fecha >= ${now} - INTERVAL '7 days'`;
          break;
        case 'mes':
          sql += ` AND c.fecha >= ${now} - INTERVAL '30 days'`;
          break;
      }
    } else if (!periodo) {
      // Por defecto, mostrar solo el día actual
      sql += ` AND c.fecha >= DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago')`;
    }
    
    sql += ` ORDER BY c.fecha DESC LIMIT 100`;
    
    console.log('🔍 SQL generado:', sql);
    console.log('🔍 Parámetros:', params);
    
    const checkins = await query(sql, params);
    
    console.log('✅ Checkins encontrados:', checkins.length);
    
    res.json({
      success: true,
      checkins: checkins,
      total: checkins.length
    });

  } catch (error) {
    console.error('❌ Error en consulta pública de checkins:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error interno del servidor',
      error: error.message
    });
  }
});

// Estadísticas generales (para dashboard futuro)
router.get('/stats', async (req, res) => {
  try {
    console.log('📈 Solicitando estadísticas generales...');
    
    const stats = await Promise.all([
      query('SELECT COUNT(*) as total FROM plazas'),
      query('SELECT COUNT(*) as total FROM guardias WHERE activo = true'),
      query(`SELECT COUNT(*) as total FROM checkins 
             WHERE fecha >= CURRENT_DATE - INTERVAL '7 days'`),
      query(`SELECT COUNT(*) as total FROM checkins 
             WHERE fecha >= CURRENT_DATE`)
    ]);

    const resultado = {
      total_plazas: parseInt(stats[0][0].total),
      guardias_activos: parseInt(stats[1][0].total),
      checkins_semana: parseInt(stats[2][0].total),
      checkins_hoy: parseInt(stats[3][0].total)
    };

    console.log('✅ Estadísticas generadas:', resultado);
    res.json({
      success: true,
      stats: resultado
    });

  } catch (error) {
    console.error('❌ Error obteniendo estadísticas:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error interno del servidor' 
    });
  }
});

module.exports = router;
