const express = require('express');
const router = express.Router();
const { query } = require('../utils/db');

// Obtener todas las plazas para el dropdown
router.get('/plazas', async (req, res) => {
  try {
    const plazas = await query(`
      SELECT p.id, p.nombre, p.direccion, p.descripcion, p.activo,
             pt.token
      FROM plazas p
      LEFT JOIN plaza_tokens pt ON p.id = pt.plaza_id
      WHERE p.activo = TRUE
      ORDER BY p.nombre ASC
    `);
    
    res.json({
      success: true,
      plazas: plazas
    });
  } catch (error) {
    console.error('Error obteniendo plazas:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error interno del servidor' 
    });
  }
});

// Obtener solo nombres de plazas (para dropdown básico)
router.get('/plazas/simple', async (req, res) => {
  try {
    const plazas = await query('SELECT id, nombre FROM plazas WHERE activo = TRUE ORDER BY nombre ASC');
    res.json(plazas);
  } catch (error) {
    console.error('Error obteniendo plazas simples:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error interno del servidor' 
    });
  }
});

// Obtener checkins con filtros para consulta pública
// IMPORTANTE: Esta ruta debe ir ANTES que /checkins/:plazaId para evitar conflictos
router.get('/checkins/public', async (req, res) => {
  try {
    const { plaza_id, periodo } = req.query;
    
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
    if (periodo) {
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
        case 'todos':
          // No agregar filtro de fecha, mostrar todos los registros
          break;
        default:
          // Por defecto, mostrar solo el día actual si el período no es reconocido
          sql += ` AND c.fecha >= DATE_TRUNC('day', ${now})`;
          break;
      }
    }
    
    sql += ` ORDER BY c.fecha DESC LIMIT 100`;
    
    const checkins = await query(sql, params);
    
    res.json({
      success: true,
      checkins: checkins,
      total: checkins.length
    });

  } catch (error) {
    console.error('Error en consulta pública de checkins:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error interno del servidor',
      error: error.message
    });
  }
});

// Obtener checkins de una plaza específica
router.get('/checkins/:plazaId', async (req, res) => {
  try {
    const { plazaId } = req.params;
    
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

    res.json({
      success: true,
      stats: resultado
    });

  } catch (error) {
    console.error('Error obteniendo estadísticas:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error interno del servidor' 
    });
  }
});

// Endpoint temporal para inicializar la base de datos
router.post('/init-db', async (req, res) => {
  try {
    console.log('🔧 Inicializando base de datos...');
    
    // Verificar si ya hay datos
    const existingPlazas = await query('SELECT COUNT(*) as total FROM plazas');
    const totalPlazas = parseInt(existingPlazas[0].total);
    
    if (totalPlazas > 0) {
      return res.json({
        success: true,
        message: `Base de datos ya inicializada. Hay ${totalPlazas} plazas.`,
        plazas: totalPlazas
      });
    }
    
    console.log('📝 Insertando plazas...');
    
    // Insertar plazas
    await query(`
      INSERT INTO plazas (nombre) VALUES
      ('Plaza La Coruña'),
      ('Plaza Valencia'), 
      ('Plaza Marbella'),
      ('Plaza Evaristo Herrera Molina'),
      ('Plaza Aaron Osorio Vidal'),
      ('Plaza Avellino'),
      ('Plaza Livorno'),
      ('Plaza Turin'),
      ('Plaza Castellon'),
      ('Plaza Perugia'),
      ('Plaza Ancona'),      
      ('Plaza Capri'),
      ('Plaza Napoles'),
      ('Plaza Reginado Henríquez Miranda'),
      ('Plaza Mario Arroyo Acuña'),
      ('Plaza Roberto Risopatron'),
      ('Plaza Barcelona'),
      ('Plaza Parque Union Norte'),
      ('Plaza Parque Union Sur')
      ON CONFLICT DO NOTHING
    `);
    
    console.log('🔑 Insertando tokens QR...');
    
    // Insertar tokens QR
    for (let i = 1; i <= 19; i++) {
      await query(`
        INSERT INTO plaza_tokens (plaza_id, token) VALUES
        ($1, $2) ON CONFLICT (token) DO NOTHING
      `, [i, `qr-plaza-${i}-2025`]);
    }
    
    console.log('👤 Insertando guardias...');
    
    // Insertar guardias
    await query(`
      INSERT INTO guardias (nombre, rut, email, password, telefono) VALUES
      ('Carlos Mendoza Torres', '18.543.210-9', 'carlos.mendoza@pradosdenos.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+56912345678'),
      ('María Elena Soto', '16.789.432-1', 'maria.soto@pradosdenos.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+56987654321'),
      ('Juan Carlos Ramirez', '19.234.567-8', 'juan.ramirez@pradosdenos.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+56976543210'),
      ('Patricia Morales Vega', '17.654.321-0', 'patricia.morales@pradosdenos.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+56965432109')
      ON CONFLICT (email) DO NOTHING
    `);
    
    console.log('👑 Insertando administradores...');
    
    // Insertar administradores
    await query(`
      INSERT INTO admin_users (nombre, apellido_paterno, apellido_materno, run, email, fecha_nacimiento, direccion, plaza_id, password_hash) VALUES
      ('Jorge', 'Guerrero', 'Hidalgo', '15.468.127-2', 'jorgeguerrerohidalgo@gmail.com', '1982-04-24', 'Santiago de Compostela 4985', 1, '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'),
      ('Admin', 'Sistema', 'Principal', '11.111.222-3', 'admin@pradosdenos.com', '1980-01-01', 'Oficina Central', 1, '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi')
      ON CONFLICT (email) DO NOTHING
    `);
    
    console.log('✅ Insertando checkins de ejemplo...');
    
    // Insertar checkins de ejemplo
    await query(`
      INSERT INTO checkins (guardia_id, plaza_id, fecha, ip_address) VALUES
      (1, 1, CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago' - INTERVAL '2 hours', '192.168.1.100'),
      (1, 2, CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago' - INTERVAL '1 hour 45 minutes', '192.168.1.100'),
      (1, 3, CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago' - INTERVAL '1 hour 30 minutes', '192.168.1.100'),
      (2, 4, CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago' - INTERVAL '1 hour', '192.168.1.101'),
      (2, 5, CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago' - INTERVAL '45 minutes', '192.168.1.101'),
      (2, 6, CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago' - INTERVAL '30 minutes', '192.168.1.101'),
      (3, 7, CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago' - INTERVAL '1 day 2 hours', '192.168.1.102'),
      (3, 8, CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago' - INTERVAL '1 day 1 hour 45 minutes', '192.168.1.102'),
      (4, 9, CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago' - INTERVAL '1 day 1 hora 30 minutes', '192.168.1.103')
    `);
    
    // Verificar resultados
    const finalPlazas = await query('SELECT COUNT(*) as total FROM plazas');
    const finalGuardias = await query('SELECT COUNT(*) as total FROM guardias');
    const finalAdmins = await query('SELECT COUNT(*) as total FROM admin_users');
    const finalCheckins = await query('SELECT COUNT(*) as total FROM checkins');
    
    console.log('🎉 Base de datos inicializada exitosamente');
    
    res.json({
      success: true,
      message: 'Base de datos inicializada exitosamente',
      datos: {
        plazas: parseInt(finalPlazas[0].total),
        guardias: parseInt(finalGuardias[0].total),
        administradores: parseInt(finalAdmins[0].total),
        checkins: parseInt(finalCheckins[0].total)
      }
    });
    
  } catch (error) {
    console.error('❌ Error inicializando base de datos:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error inicializando base de datos',
      error: error.message
    });
  }
});

// Ruta de debug para verificar datos
router.get('/debug/data', async (req, res) => {
  try {
    console.log('🔍 Debug: Verificando datos en la base de datos...');
    
    const plazas = await query('SELECT id, nombre FROM plazas ORDER BY nombre');
    const guardias = await query('SELECT id, nombre, email FROM guardias ORDER BY nombre');
    const checkins = await query('SELECT id, plaza_id, guardia_id, fecha FROM checkins ORDER BY fecha DESC LIMIT 10');
    
    // Verificar checkins con JOIN
    const checkinsWithDetails = await query(`
      SELECT 
        c.id,
        c.fecha,
        p.nombre as plaza_nombre,
        g.nombre as guardia_nombre
      FROM checkins c
      INNER JOIN plazas p ON c.plaza_id = p.id
      INNER JOIN guardias g ON c.guardia_id = g.id
      ORDER BY c.fecha DESC
      LIMIT 10
    `);
    
    res.json({
      success: true,
      datos: {
        plazas: {
          total: plazas.length,
          datos: plazas
        },
        guardias: {
          total: guardias.length,
          datos: guardias.map(g => ({ id: g.id, nombre: g.nombre, email: g.email }))
        },
        checkins: {
          total: checkins.length,
          datos: checkins
        },
        checkinsConDetalles: {
          total: checkinsWithDetails.length,
          datos: checkinsWithDetails
        }
      }
    });
    
  } catch (error) {
    console.error('❌ Error en debug:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error en debug',
      error: error.message
    });
  }
});

// ==================== ENDPOINT TEMPORAL: GENERAR TOKENS ====================
// Endpoint temporal para generar tokens automáticamente (sin restricciones de autenticación)
// NOTA: Este endpoint debe ser removido en producción por seguridad
router.post('/generate-tokens-temp', async (req, res) => {
  try {
    console.log('🔧 GENERANDO TOKENS FALTANTES (ENDPOINT TEMPORAL)');
    
    // Obtener plazas sin token
    const plazasSinToken = await query(`
      SELECT p.id, p.nombre
      FROM plazas p
      LEFT JOIN plaza_tokens pt ON p.id = pt.plaza_id
      WHERE p.activo = TRUE AND pt.token IS NULL
    `);
    
    console.log(`📊 Plazas sin token encontradas: ${plazasSinToken.length}`);
    
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
        console.log(`✅ Token generado para ${plaza.nombre}: ${token}`);
      } catch (error) {
        console.error(`❌ Error generando token para ${plaza.nombre}:`, error.message);
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
    
    console.log(`🎉 Proceso completado: ${tokensGenerados} tokens generados`);
    
    res.json({
      success: true,
      message: `Tokens generados exitosamente`,
      tokensGenerados,
      errores,
      estadoFinal: {
        totalPlazas: verificacion.length,
        plazasConToken: conToken.length,
        plazasSinToken: sinToken.length,
        plazasConTokenNombres: conToken.map(p => p.nombre),
        plazasSinTokenNombres: sinToken.map(p => p.nombre)
      }
    });
    
  } catch (error) {
    console.error('❌ Error generando tokens:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Error interno del servidor',
      error: error.message 
    });
  }
});

module.exports = router;
