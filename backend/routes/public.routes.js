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
