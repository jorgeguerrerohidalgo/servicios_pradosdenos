/**
 * RUTAS DE PAGOS
 * Gestión de pagos de cuota social y junta de vecinos
 * Autor: Sistema
 * Fecha: 14/05/2026
 */

const express = require('express');
const router = express.Router();
const { pool } = require('../utils/db');
const { requireAuthAdmin } = require('../middleware/sessionAuth');

// Aplicar middleware de autenticación a todas las rutas
router.use(requireAuthAdmin);

// ==================== GET: Listar pagos ====================
/**
 * GET /api/pagos
 * Lista todos los pagos con filtros opcionales
 * Query params: casa_id, periodo, tipo_pago, estado, activo
 */
router.get('/', async (req, res) => {
    try {
        const { plaza_id, casa_id, periodo, tipo_pago, estado, activo = 'true' } = req.query;
        
        let query = 'SELECT * FROM v_pagos_completo WHERE 1=1';
        const params = [];
        let paramCount = 1;
        
        // Filtro por casa (prioridad sobre plaza)
        if (casa_id) {
            query += ` AND casa_id = $${paramCount}`;
            params.push(parseInt(casa_id));
            paramCount++;
        } else if (plaza_id) {
            query += ` AND plaza_id = $${paramCount}`;
            params.push(parseInt(plaza_id));
            paramCount++;
        }
        
        // Filtro por período
        if (periodo) {
            query += ` AND periodo = $${paramCount}`;
            params.push(periodo);
            paramCount++;
        }
        
        // Filtro por tipo de pago
        if (tipo_pago && tipo_pago !== 'all') {
            query += ` AND tipo_pago = $${paramCount}`;
            params.push(tipo_pago);
            paramCount++;
        }
        
        // Filtro por estado
        if (estado && estado !== 'all') {
            query += ` AND estado = $${paramCount}`;
            params.push(estado);
            paramCount++;
        }
        
        // Filtro por activo
        if (activo !== 'all') {
            query += ` AND activo = $${paramCount}`;
            params.push(activo === 'true');
            paramCount++;
        }
        
        query += ' ORDER BY periodo DESC, numero_casa, tipo_pago';
        
        const result = await pool.query(query, params);
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
        
    } catch (error) {
        console.error('Error al listar pagos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener pagos',
            error: error.message
        });
    }
});

// ==================== GET: Historial de pagos por casa ====================
/**
 * GET /api/pagos/casa/:casa_id
 * Obtiene el historial de pagos de una casa específica
 * Query params: limite (default: 12)
 */
router.get('/casa/:casa_id', async (req, res) => {
    try {
        const { casa_id } = req.params;
        const { limite = 12 } = req.query;
        
        const result = await pool.query(
            'SELECT * FROM get_historial_pagos_casa($1, $2)',
            [parseInt(casa_id), parseInt(limite)]
        );
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
        
    } catch (error) {
        console.error('Error al obtener historial de pagos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener historial de pagos',
            error: error.message
        });
    }
});

// ==================== GET: Morosidad de una casa ====================
/**
 * GET /api/pagos/morosidad/:casa_id
 * Obtiene información de morosidad de una casa
 */
router.get('/morosidad/:casa_id', async (req, res) => {
    try {
        const { casa_id } = req.params;
        
        const result = await pool.query(
            'SELECT * FROM get_morosidad_casa($1)',
            [parseInt(casa_id)]
        );
        
        res.json({
            success: true,
            data: result.rows[0] || null
        });
        
    } catch (error) {
        console.error('Error al obtener morosidad:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener morosidad',
            error: error.message
        });
    }
});

// ==================== GET: Estadísticas por período ====================
/**
 * GET /api/pagos/estadisticas/periodo
 * Obtiene estadísticas de pagos por período
 * Query params: periodo (opcional, si no se especifica trae todos)
 */
router.get('/estadisticas/periodo', async (req, res) => {
    try {
        const { periodo } = req.query;
        
        const result = await pool.query(
            'SELECT * FROM get_estadisticas_pagos_periodo($1)',
            [periodo || null]
        );
        
        res.json({
            success: true,
            data: result.rows
        });
        
    } catch (error) {
        console.error('Error al obtener estadísticas de pagos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener estadísticas de pagos',
            error: error.message
        });
    }
});

// ==================== GET: Casas morosas ====================
/**
 * GET /api/pagos/morosas
 * Obtiene lista de casas con pagos vencidos
 */
router.get('/morosas', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT DISTINCT
                c.id as casa_id,
                c.numero_casa,
                COUNT(p.id) as pagos_vencidos,
                SUM(p.monto) as deuda_total
            FROM casas c
            INNER JOIN pagos p ON c.id = p.casa_id
            WHERE p.estado = 'vencido'
                AND p.activo = true
                AND c.activo = true
            GROUP BY c.id, c.numero_casa
            ORDER BY deuda_total DESC
        `);
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
        
    } catch (error) {
        console.error('Error al obtener casas morosas:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener casas morosas',
            error: error.message
        });
    }
});

// ==================== POST: Crear pago manual ====================
/**
 * POST /api/pagos
 * Crea un pago manual
 */
router.post('/', async (req, res) => {
    try {
        const { 
            casa_id, 
            periodo, 
            tipo_pago, 
            monto, 
            fecha_vencimiento,
            estado = 'pendiente'
        } = req.body;
        
        // Validaciones
        if (!casa_id || !periodo || !tipo_pago || !monto || !fecha_vencimiento) {
            return res.status(400).json({
                success: false,
                message: 'Faltan campos obligatorios: casa_id, periodo, tipo_pago, monto, fecha_vencimiento'
            });
        }
        
        // Validar período (formato YYYY-MM)
        const periodoRegex = /^\d{4}-(0[1-9]|1[0-2])$/;
        if (!periodoRegex.test(periodo)) {
            return res.status(400).json({
                success: false,
                message: 'Período inválido. Formato esperado: YYYY-MM (ej: 2026-05)'
            });
        }
        
        // Validar tipo de pago
        const tiposValidos = ['cuota_social', 'junta_vecinos'];
        if (!tiposValidos.includes(tipo_pago)) {
            return res.status(400).json({
                success: false,
                message: 'Tipo de pago debe ser: cuota_social o junta_vecinos'
            });
        }
        
        // Validar estado
        const estadosValidos = ['pendiente', 'pagado', 'vencido', 'anulado'];
        if (!estadosValidos.includes(estado)) {
            return res.status(400).json({
                success: false,
                message: 'Estado debe ser: pendiente, pagado, vencido o anulado'
            });
        }
        
        // Verificar que la casa existe
        const casaCheck = await pool.query(
            'SELECT id FROM casas WHERE id = $1 AND activo = true',
            [casa_id]
        );
        
        if (casaCheck.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Casa no encontrada'
            });
        }
        
        // Verificar que no exista ya un pago del mismo tipo en el mismo período
        const pagoExistente = await pool.query(
            'SELECT id FROM pagos WHERE casa_id = $1 AND periodo = $2 AND tipo_pago = $3 AND activo = true',
            [casa_id, periodo, tipo_pago]
        );
        
        if (pagoExistente.rows.length > 0) {
            return res.status(409).json({
                success: false,
                message: 'Ya existe un pago de este tipo para este período'
            });
        }
        
        // Insertar pago
        const result = await pool.query(
            `INSERT INTO pagos (
                casa_id, periodo, tipo_pago, monto, fecha_vencimiento, estado
            ) VALUES ($1, $2, $3, $4, $5, $6)
            RETURNING *`,
            [casa_id, periodo, tipo_pago, monto, fecha_vencimiento, estado]
        );
        
        res.status(201).json({
            success: true,
            message: 'Pago creado correctamente',
            data: result.rows[0]
        });
        
    } catch (error) {
        console.error('Error al crear pago:', error);
        res.status(500).json({
            success: false,
            message: 'Error al crear pago',
            error: error.message
        });
    }
});

// ==================== POST: Generar pagos automáticos ====================
/**
 * POST /api/pagos/generar-periodo
 * Genera pagos automáticamente para todas las casas en un período
 * Body: { periodo, fecha_vencimiento }
 */
router.post('/generar-periodo', async (req, res) => {
    try {
        const { periodo, fecha_vencimiento } = req.body;
        
        if (!periodo) {
            return res.status(400).json({
                success: false,
                message: 'El período es obligatorio'
            });
        }
        
        // Validar período (formato YYYY-MM)
        const periodoRegex = /^\d{4}-(0[1-9]|1[0-2])$/;
        if (!periodoRegex.test(periodo)) {
            return res.status(400).json({
                success: false,
                message: 'Período inválido. Formato esperado: YYYY-MM (ej: 2026-05)'
            });
        }
        
        const result = await pool.query(
            'SELECT * FROM generar_pagos_periodo($1, $2)',
            [periodo, fecha_vencimiento || null]
        );
        
        const stats = result.rows[0];
        
        res.json({
            success: true,
            message: `Pagos generados para período ${periodo}`,
            data: {
                casas_procesadas: stats.casas_procesadas,
                pagos_generados: stats.pagos_generados,
                pagos_saltados: stats.pagos_saltados
            }
        });
        
    } catch (error) {
        console.error('Error al generar pagos automáticos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al generar pagos automáticos',
            error: error.message
        });
    }
});

// ==================== PUT: Registrar pago ====================
/**
 * PUT /api/pagos/:id/registrar
 * Marca un pago como pagado
 * Body: { metodo_pago, numero_comprobante, fecha_pago }
 */
router.put('/:id/registrar', async (req, res) => {
    try {
        const { id } = req.params;
        const { metodo_pago, numero_comprobante, fecha_pago } = req.body;
        
        if (!metodo_pago) {
            return res.status(400).json({
                success: false,
                message: 'El método de pago es obligatorio'
            });
        }
        
        // Validar método de pago
        const metodosValidos = ['efectivo', 'transferencia', 'cheque', 'tarjeta', 'webpay', 'otro'];
        if (!metodosValidos.includes(metodo_pago)) {
            return res.status(400).json({
                success: false,
                message: 'Método de pago inválido. Opciones: ' + metodosValidos.join(', ')
            });
        }
        
        const result = await pool.query(
            'SELECT * FROM registrar_pago($1, $2, $3, $4)',
            [
                parseInt(id),
                metodo_pago,
                numero_comprobante || null,
                fecha_pago || new Date()
            ]
        );
        
        const response = result.rows[0];
        
        if (response.success) {
            res.json({
                success: true,
                message: response.message
            });
        } else {
            res.status(404).json({
                success: false,
                message: response.message
            });
        }
        
    } catch (error) {
        console.error('Error al registrar pago:', error);
        res.status(500).json({
            success: false,
            message: 'Error al registrar pago',
            error: error.message
        });
    }
});

// ==================== PUT: Actualizar pago ====================
/**
 * PUT /api/pagos/:id
 * Actualiza un pago existente
 */
router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            monto, 
            fecha_vencimiento, 
            estado, 
            observaciones,
            activo
        } = req.body;
        
        // Verificar que el pago existe
        const pagoCheck = await pool.query(
            'SELECT id, estado FROM pagos WHERE id = $1',
            [id]
        );
        
        if (pagoCheck.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Pago no encontrado'
            });
        }
        
        // No permitir modificar pagos ya pagados (excepto anular)
        if (pagoCheck.rows[0].estado === 'pagado' && estado !== 'anulado') {
            return res.status(400).json({
                success: false,
                message: 'No se puede modificar un pago ya realizado'
            });
        }
        
        // Validar estado si se proporciona
        if (estado) {
            const estadosValidos = ['pendiente', 'pagado', 'vencido', 'anulado'];
            if (!estadosValidos.includes(estado)) {
                return res.status(400).json({
                    success: false,
                    message: 'Estado debe ser: pendiente, pagado, vencido o anulado'
                });
            }
        }
        
        // Actualizar pago
        const result = await pool.query(
            `UPDATE pagos SET
                monto = COALESCE($1, monto),
                fecha_vencimiento = COALESCE($2, fecha_vencimiento),
                estado = COALESCE($3, estado),
                observaciones = COALESCE($4, observaciones),
                activo = COALESCE($5, activo)
            WHERE id = $6
            RETURNING *`,
            [monto, fecha_vencimiento, estado, observaciones, activo, id]
        );
        
        res.json({
            success: true,
            message: 'Pago actualizado correctamente',
            data: result.rows[0]
        });
        
    } catch (error) {
        console.error('Error al actualizar pago:', error);
        res.status(500).json({
            success: false,
            message: 'Error al actualizar pago',
            error: error.message
        });
    }
});

// ==================== DELETE: Eliminar pago (soft delete) ====================
/**
 * DELETE /api/pagos/:id
 * Realiza soft delete de un pago
 */
router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        // Verificar que el pago existe
        const pagoCheck = await pool.query(
            'SELECT id, estado FROM pagos WHERE id = $1',
            [id]
        );
        
        if (pagoCheck.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Pago no encontrado'
            });
        }
        
        // No permitir eliminar pagos ya pagados
        if (pagoCheck.rows[0].estado === 'pagado') {
            return res.status(400).json({
                success: false,
                message: 'No se puede eliminar un pago ya realizado. Use estado "anulado" en su lugar.'
            });
        }
        
        // Soft delete
        await pool.query(
            'UPDATE pagos SET activo = false WHERE id = $1',
            [id]
        );
        
        res.json({
            success: true,
            message: 'Pago eliminado correctamente'
        });
        
    } catch (error) {
        console.error('Error al eliminar pago:', error);
        res.status(500).json({
            success: false,
            message: 'Error al eliminar pago',
            error: error.message
        });
    }
});

module.exports = router;
