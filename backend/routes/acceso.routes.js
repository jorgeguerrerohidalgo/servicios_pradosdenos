/**
 * RUTAS DE CONTROL DE ACCESO
 * Gestión de entradas y salidas de vehículos
 * Incluye verificación automática de morosidad
 */

const express = require('express');
const router = express.Router();
const { pool } = require('../utils/db');
const { requireAuth, requireAuthAdmin } = require('../middleware/sessionAuth');
const { requirePermission } = require('../middleware/rbac');

// Aplicar middleware de autenticación a todas las rutas
router.use(requireAuth);

/**
 * GET /api/acceso
 * Lista todos los accesos con filtros opcionales
 * Query params: vehiculo_patente, casa_id, tipo_acceso, fecha_desde, fecha_hasta, acceso_permitido, tiene_morosidad
 */
router.get('/', async (req, res) => {
    try {
        const {
            vehiculo_patente,
            casa_id,
            tipo_acceso,
            fecha_desde,
            fecha_hasta,
            acceso_permitido,
            tiene_morosidad,
            limit
        } = req.query;
        
        let query = `
            SELECT 
                id,
                vehiculo_patente,
                marca,
                modelo,
                color,
                tipo_vehiculo,
                casa_id,
                numero_casa,
                casa_direccion,
                plaza_nombre,
                tipo_acceso,
                fecha_hora,
                estado_pago_verificado,
                tiene_morosidad,
                monto_deuda,
                acceso_permitido,
                motivo_bloqueo,
                observaciones,
                usuario_registro,
                residente_nombre,
                tiempo_permanencia,
                created_at
            FROM v_accesos_completo
            WHERE 1=1
        `;
        
        const params = [];
        let paramCount = 1;
        
        if (vehiculo_patente) {
            query += ` AND vehiculo_patente = $${paramCount}`;
            params.push(vehiculo_patente.toUpperCase());
            paramCount++;
        }
        
        if (casa_id) {
            query += ` AND casa_id = $${paramCount}`;
            params.push(casa_id);
            paramCount++;
        }
        
        if (tipo_acceso) {
            query += ` AND tipo_acceso = $${paramCount}`;
            params.push(tipo_acceso);
            paramCount++;
        }
        
        if (fecha_desde) {
            query += ` AND fecha_hora >= $${paramCount}`;
            params.push(fecha_desde);
            paramCount++;
        }
        
        if (fecha_hasta) {
            query += ` AND fecha_hora <= $${paramCount}`;
            params.push(fecha_hasta);
            paramCount++;
        }
        
        if (acceso_permitido !== undefined) {
            query += ` AND acceso_permitido = $${paramCount}`;
            params.push(acceso_permitido === 'true');
            paramCount++;
        }
        
        if (tiene_morosidad !== undefined) {
            query += ` AND tiene_morosidad = $${paramCount}`;
            params.push(tiene_morosidad === 'true');
            paramCount++;
        }
        
        query += ' ORDER BY fecha_hora DESC';
        
        if (limit) {
            query += ` LIMIT $${paramCount}`;
            params.push(parseInt(limit));
        } else {
            query += ' LIMIT 100'; // Límite por defecto
        }
        
        const result = await pool.query(query, params);
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
        
    } catch (error) {
        console.error('Error al obtener accesos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener accesos',
            error: error.message
        });
    }
});

/**
 * GET /api/acceso/recientes
 * Obtiene los últimos N accesos registrados
 * Query params: limit (default: 50)
 */
router.get('/recientes', async (req, res) => {
    try {
        const limit = parseInt(req.query.limit) || 50;
        
        const result = await pool.query(`
            SELECT * FROM get_accesos_recientes($1)
        `, [limit]);
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
        
    } catch (error) {
        console.error('Error al obtener accesos recientes:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener accesos recientes',
            error: error.message
        });
    }
});

/**
 * GET /api/acceso/vehiculo/:patente
 * Historial completo de accesos de un vehículo específico
 * Query params: limit (default: 100)
 */
router.get('/vehiculo/:patente', async (req, res) => {
    try {
        const { patente } = req.params;
        const limit = parseInt(req.query.limit) || 100;
        
        const result = await pool.query(`
            SELECT * FROM get_accesos_por_vehiculo($1, $2)
        `, [patente.toUpperCase(), limit]);
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
        
    } catch (error) {
        console.error('Error al obtener historial del vehículo:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener historial del vehículo',
            error: error.message
        });
    }
});

/**
 * GET /api/acceso/estadisticas
 * Estadísticas de accesos en un rango de fechas
 * Query params: fecha_desde, fecha_hasta (obligatorios)
 */
router.get('/estadisticas', async (req, res) => {
    try {
        const { fecha_desde, fecha_hasta } = req.query;
        
        if (!fecha_desde || !fecha_hasta) {
            return res.status(400).json({
                success: false,
                message: 'Se requieren fecha_desde y fecha_hasta'
            });
        }
        
        const result = await pool.query(`
            SELECT get_estadisticas_accesos($1::TIMESTAMPTZ, $2::TIMESTAMPTZ) as estadisticas
        `, [fecha_desde, fecha_hasta]);
        
        res.json({
            success: true,
            data: result.rows[0].estadisticas
        });
        
    } catch (error) {
        console.error('Error al obtener estadísticas:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener estadísticas',
            error: error.message
        });
    }
});

/**
 * POST /api/acceso/verificar
 * Verifica si un vehículo puede acceder sin registrar el acceso
 * Body: { patente }
 */
router.post('/verificar', requirePermission('acceso.leer'), async (req, res) => {
    try {
        const { patente } = req.body;
        
        if (!patente) {
            return res.status(400).json({
                success: false,
                message: 'Se requiere patente del vehículo'
            });
        }
        
        const result = await pool.query(`
            SELECT verificar_acceso_vehiculo($1) as verificacion
        `, [patente.toUpperCase()]);
        
        const verificacion = result.rows[0].verificacion;
        
        res.json({
            success: true,
            data: verificacion
        });
        
    } catch (error) {
        console.error('Error al verificar acceso:', error);
        res.status(500).json({
            success: false,
            message: 'Error al verificar acceso',
            error: error.message
        });
    }
});

/**
 * POST /api/acceso/registrar
 * Registra un acceso (entrada o salida) con verificación automática de morosidad
 * Body: { patente, tipo_acceso, usuario_registro, observaciones }
 */
router.post('/registrar', requirePermission('acceso.crear'), async (req, res) => {
    try {
        const { patente, tipo_acceso, usuario_registro, observaciones } = req.body;
        
        // Validaciones
        if (!patente || !tipo_acceso) {
            return res.status(400).json({
                success: false,
                message: 'Se requieren patente y tipo_acceso (entrada/salida)'
            });
        }
        
        if (!['entrada', 'salida'].includes(tipo_acceso)) {
            return res.status(400).json({
                success: false,
                message: 'tipo_acceso debe ser "entrada" o "salida"'
            });
        }
        
        // Registrar acceso usando función de la BD (incluye verificación automática)
        const result = await pool.query(`
            SELECT registrar_acceso_vehiculo($1, $2, $3, $4) as acceso_id
        `, [
            patente.toUpperCase(),
            tipo_acceso,
            usuario_registro || 'Sistema',
            observaciones || null
        ]);
        
        const accesoId = result.rows[0].acceso_id;
        
        // Obtener datos completos del acceso registrado
        const accesoCompleto = await pool.query(`
            SELECT * FROM v_accesos_completo WHERE id = $1
        `, [accesoId]);
        
        const acceso = accesoCompleto.rows[0];
        
        res.status(201).json({
            success: true,
            message: acceso.acceso_permitido 
                ? `${tipo_acceso.charAt(0).toUpperCase() + tipo_acceso.slice(1)} registrada exitosamente`
                : `Acceso bloqueado: ${acceso.motivo_bloqueo}`,
            data: acceso
        });
        
    } catch (error) {
        console.error('Error al registrar acceso:', error);
        
        // Error específico de vehículo no encontrado
        if (error.message.includes('no encontrado')) {
            return res.status(404).json({
                success: false,
                message: error.message
            });
        }
        
        res.status(500).json({
            success: false,
            message: 'Error al registrar acceso',
            error: error.message
        });
    }
});

/**
 * POST /api/acceso
 * Crea un registro de acceso manual (sin usar la función automática)
 * Útil para registros históricos o correcciones
 */
router.post('/', requirePermission('acceso.crear'), async (req, res) => {
    try {
        const {
            vehiculo_patente,
            tipo_acceso,
            fecha_hora,
            observaciones,
            usuario_registro
        } = req.body;
        
        // Validaciones
        if (!vehiculo_patente || !tipo_acceso) {
            return res.status(400).json({
                success: false,
                message: 'Se requieren vehiculo_patente y tipo_acceso'
            });
        }
        
        if (!['entrada', 'salida'].includes(tipo_acceso)) {
            return res.status(400).json({
                success: false,
                message: 'tipo_acceso debe ser "entrada" o "salida"'
            });
        }
        
        // Obtener casa_id del vehículo
        const vehiculoCheck = await pool.query(
            'SELECT casa_id FROM vehiculos WHERE patente = $1 AND activo = TRUE',
            [vehiculo_patente.toUpperCase()]
        );
        
        if (vehiculoCheck.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Vehículo no encontrado o inactivo'
            });
        }
        
        const casa_id = vehiculoCheck.rows[0].casa_id;
        
        // Insertar registro manual (sin verificación automática)
        const result = await pool.query(`
            INSERT INTO control_acceso (
                vehiculo_patente,
                casa_id,
                tipo_acceso,
                fecha_hora,
                estado_pago_verificado,
                observaciones,
                usuario_registro
            )
            VALUES ($1, $2, $3, $4, FALSE, $5, $6)
            RETURNING id
        `, [
            vehiculo_patente.toUpperCase(),
            casa_id,
            tipo_acceso,
            fecha_hora || new Date(),
            observaciones || null,
            usuario_registro || 'Manual'
        ]);
        
        // Obtener datos completos
        const accesoCompleto = await pool.query(`
            SELECT * FROM v_accesos_completo WHERE id = $1
        `, [result.rows[0].id]);
        
        res.status(201).json({
            success: true,
            message: 'Acceso manual registrado exitosamente',
            data: accesoCompleto.rows[0]
        });
        
    } catch (error) {
        console.error('Error al crear acceso manual:', error);
        res.status(500).json({
            success: false,
            message: 'Error al crear acceso manual',
            error: error.message
        });
    }
});

/**
 * DELETE /api/acceso/:id
 * Soft delete de un registro de acceso
 */
router.delete('/:id', requirePermission('acceso.eliminar'), async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(`
            UPDATE control_acceso
            SET activo = FALSE
            WHERE id = $1 AND activo = TRUE
            RETURNING id, vehiculo_patente, tipo_acceso, fecha_hora
        `, [id]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Registro de acceso no encontrado o ya inactivo'
            });
        }
        
        res.json({
            success: true,
            message: 'Registro de acceso eliminado exitosamente',
            data: result.rows[0]
        });
        
    } catch (error) {
        console.error('Error al eliminar registro de acceso:', error);
        res.status(500).json({
            success: false,
            message: 'Error al eliminar registro de acceso',
            error: error.message
        });
    }
});

module.exports = router;
