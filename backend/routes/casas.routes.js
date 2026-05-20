const express = require('express');
const router = express.Router();
const { pool } = require('../utils/db');
const { requireAuth, requireAdmin, requireAuthAdmin } = require('../middleware/sessionAuth');
const { requirePermission } = require('../middleware/rbac');
const { applyScoping, buildPlazaFilter } = require('../middleware/applyScoping');

// ==================== GESTIÓN DE CASAS ====================

// GET /api/casas - Obtener todas las casas (con scoping automático)
router.get('/', requirePermission('casas.leer'), applyScoping, async (req, res) => {
    try {
        const { plaza_id, activo = 'true' } = req.query;
        
        let sql = `
            SELECT 
                c.id,
                c.numero_casa,
                c.direccion,
                c.plaza_id,
                p.nombre as plaza_nombre,
                c.monto_cuota_social,
                c.monto_junta_vecinos,
                (c.monto_cuota_social + c.monto_junta_vecinos) as monto_total_mensual,
                c.metros_cuadrados,
                c.observaciones,
                c.activo,
                c.created_at,
                c.updated_at,
                (SELECT COUNT(*) FROM residentes WHERE casa_id = c.id AND activo = true) as total_residentes
            FROM casas c
            LEFT JOIN plazas p ON c.plaza_id = p.id
            WHERE 1=1
        `;
        
        let params = [];
        let paramCount = 0;
        
        // Filtro por estado activo
        if (activo !== 'all') {
            paramCount++;
            sql += ` AND c.activo = $${paramCount}`;
            params.push(activo === 'true');
        }
        
        // Filtro manual por plaza (si se especifica)
        if (plaza_id) {
            paramCount++;
            sql += ` AND c.plaza_id = $${paramCount}`;
            params.push(plaza_id);
        }
        
        // ⚡ SCOPING AUTOMÁTICO: Filtrar por plazas permitidas del usuario
        const plazaFilter = buildPlazaFilter(req.allowedPlazas, 'c', params);
        sql += plazaFilter.sql;
        params = plazaFilter.params;
        
        sql += ' ORDER BY c.numero_casa ASC';
        
        const result = await pool.query(sql, params);
        
        res.json({
            success: true,
            data: result.rows,
            total: result.rows.length,
            scoping: req.allowedPlazas === null ? 'global' : `plazas: ${req.allowedPlazas?.join(', ') || 'ninguna'}`
        });
    } catch (error) {
        console.error('Error al obtener casas:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor',
            error: error.message
        });
    }
});

// GET /api/casas/simple - Obtener lista simple de casas para dropdowns
router.get('/simple', requireAuth, async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT id, numero_casa, direccion
            FROM casas
            WHERE activo = true
            ORDER BY numero_casa ASC
        `);
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error al obtener casas simples:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// GET /api/casas/:id - Obtener casa específica por ID
router.get('/:id', requireAuthAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(`
            SELECT 
                c.id,
                c.numero_casa,
                c.direccion,
                c.plaza_id,
                p.nombre as plaza_nombre,
                c.monto_cuota_social,
                c.monto_junta_vecinos,
                (c.monto_cuota_social + c.monto_junta_vecinos) as monto_total_mensual,
                c.metros_cuadrados,
                c.observaciones,
                c.activo,
                c.created_at,
                c.updated_at
            FROM casas c
            LEFT JOIN plazas p ON c.plaza_id = p.id
            WHERE c.id = $1
        `, [id]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Casa no encontrada'
            });
        }
        
        res.json({
            success: true,
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al obtener casa:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// POST /api/casas - Crear nueva casa
router.post('/', requireAuth, requirePermission('casas.crear'), async (req, res) => {
    try {
        const { 
            numero_casa, 
            direccion, 
            plaza_id, 
            monto_cuota_social = 0, 
            monto_junta_vecinos = 0,
            metros_cuadrados,
            observaciones 
        } = req.body;
        
        // Validar campos requeridos
        if (!numero_casa || !direccion || !plaza_id) {
            return res.status(400).json({
                success: false,
                message: 'Faltan campos requeridos: numero_casa, direccion, plaza_id'
            });
        }
        
        // Validar que los montos sean positivos
        if (monto_cuota_social < 0 || monto_junta_vecinos < 0) {
            return res.status(400).json({
                success: false,
                message: 'Los montos deben ser valores positivos'
            });
        }
        
        // Validar que la plaza existe
        const plazaExists = await pool.query('SELECT id FROM plazas WHERE id = $1', [plaza_id]);
        if (plazaExists.rows.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'La plaza especificada no existe'
            });
        }
        
        // Verificar que el número de casa no esté duplicado
        const existingCasa = await pool.query(
            'SELECT id FROM casas WHERE numero_casa = $1', 
            [numero_casa]
        );
        if (existingCasa.rows.length > 0) {
            return res.status(400).json({
                success: false,
                message: 'Ya existe una casa con este número'
            });
        }
        
        // Insertar nueva casa
        const result = await pool.query(`
            INSERT INTO casas (
                numero_casa, 
                direccion, 
                plaza_id, 
                monto_cuota_social, 
                monto_junta_vecinos,
                metros_cuadrados,
                observaciones,
                activo
            ) 
            VALUES ($1, $2, $3, $4, $5, $6, $7, true) 
            RETURNING 
                id, 
                numero_casa, 
                direccion, 
                plaza_id, 
                monto_cuota_social, 
                monto_junta_vecinos,
                (monto_cuota_social + monto_junta_vecinos) as monto_total_mensual,
                metros_cuadrados,
                observaciones,
                activo,
                created_at,
                updated_at
        `, [
            numero_casa, 
            direccion, 
            plaza_id, 
            monto_cuota_social, 
            monto_junta_vecinos,
            metros_cuadrados || null,
            observaciones || null
        ]);
        
        res.status(201).json({
            success: true,
            message: 'Casa creada exitosamente',
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al crear casa:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor',
            error: error.message
        });
    }
});

// PUT /api/casas/:id - Actualizar casa existente
router.put('/:id', requireAuth, requirePermission('casas.editar'), async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            numero_casa, 
            direccion, 
            plaza_id, 
            monto_cuota_social, 
            monto_junta_vecinos,
            metros_cuadrados,
            observaciones,
            activo
        } = req.body;
        
        // Verificar que la casa existe
        const casaExists = await pool.query('SELECT id FROM casas WHERE id = $1', [id]);
        if (casaExists.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Casa no encontrada'
            });
        }
        
        // Validar campos si se proporcionan
        if (monto_cuota_social !== undefined && monto_cuota_social < 0) {
            return res.status(400).json({
                success: false,
                message: 'El monto de cuota social debe ser positivo'
            });
        }
        
        if (monto_junta_vecinos !== undefined && monto_junta_vecinos < 0) {
            return res.status(400).json({
                success: false,
                message: 'El monto de junta de vecinos debe ser positivo'
            });
        }
        
        // Si se cambia el número de casa, verificar que no esté duplicado
        if (numero_casa) {
            const existingCasa = await pool.query(
                'SELECT id FROM casas WHERE numero_casa = $1 AND id != $2', 
                [numero_casa, id]
            );
            if (existingCasa.rows.length > 0) {
                return res.status(400).json({
                    success: false,
                    message: 'Ya existe otra casa con este número'
                });
            }
        }
        
        // Si se cambia la plaza, verificar que existe
        if (plaza_id) {
            const plazaExists = await pool.query('SELECT id FROM plazas WHERE id = $1', [plaza_id]);
            if (plazaExists.rows.length === 0) {
                return res.status(400).json({
                    success: false,
                    message: 'La plaza especificada no existe'
                });
            }
        }
        
        // Construir query de actualización dinámicamente
        const updates = [];
        const values = [];
        let paramCount = 0;
        
        if (numero_casa !== undefined) {
            paramCount++;
            updates.push(`numero_casa = $${paramCount}`);
            values.push(numero_casa);
        }
        if (direccion !== undefined) {
            paramCount++;
            updates.push(`direccion = $${paramCount}`);
            values.push(direccion);
        }
        if (plaza_id !== undefined) {
            paramCount++;
            updates.push(`plaza_id = $${paramCount}`);
            values.push(plaza_id);
        }
        if (monto_cuota_social !== undefined) {
            paramCount++;
            updates.push(`monto_cuota_social = $${paramCount}`);
            values.push(monto_cuota_social);
        }
        if (monto_junta_vecinos !== undefined) {
            paramCount++;
            updates.push(`monto_junta_vecinos = $${paramCount}`);
            values.push(monto_junta_vecinos);
        }
        if (metros_cuadrados !== undefined) {
            paramCount++;
            updates.push(`metros_cuadrados = $${paramCount}`);
            values.push(metros_cuadrados || null);
        }
        if (observaciones !== undefined) {
            paramCount++;
            updates.push(`observaciones = $${paramCount}`);
            values.push(observaciones || null);
        }
        if (activo !== undefined) {
            paramCount++;
            updates.push(`activo = $${paramCount}`);
            values.push(activo);
        }
        
        if (updates.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'No se proporcionaron campos para actualizar'
            });
        }
        
        paramCount++;
        values.push(id);
        
        const result = await pool.query(`
            UPDATE casas 
            SET ${updates.join(', ')}
            WHERE id = $${paramCount}
            RETURNING 
                id, 
                numero_casa, 
                direccion, 
                plaza_id, 
                monto_cuota_social, 
                monto_junta_vecinos,
                (monto_cuota_social + monto_junta_vecinos) as monto_total_mensual,
                metros_cuadrados,
                observaciones,
                activo,
                created_at,
                updated_at
        `, values);
        
        res.json({
            success: true,
            message: 'Casa actualizada exitosamente',
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al actualizar casa:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor',
            error: error.message
        });
    }
});

// DELETE /api/casas/:id - Eliminar casa (soft delete)
router.delete('/:id', requireAuth, requirePermission('casas.eliminar'), async (req, res) => {
    try {
        const { id } = req.params;
        
        // Verificar que la casa existe
        const casaExists = await pool.query('SELECT id, numero_casa FROM casas WHERE id = $1', [id]);
        if (casaExists.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Casa no encontrada'
            });
        }
        
        // Verificar si tiene residentes activos
        const residentes = await pool.query(
            'SELECT COUNT(*) as count FROM residentes WHERE casa_id = $1 AND activo = true', 
            [id]
        );
        
        if (parseInt(residentes.rows[0].count) > 0) {
            return res.status(400).json({
                success: false,
                message: 'No se puede eliminar la casa porque tiene residentes activos. Desactívelos primero.'
            });
        }
        
        // Soft delete
        await pool.query('UPDATE casas SET activo = false WHERE id = $1', [id]);
        
        res.json({
            success: true,
            message: 'Casa desactivada exitosamente'
        });
    } catch (error) {
        console.error('Error al eliminar casa:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor',
            error: error.message
        });
    }
});

// GET /api/casas/:id/estadisticas - Obtener estadísticas de una casa
router.get('/:id/estadisticas', requireAuthAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        
        const stats = await pool.query(`
            SELECT 
                (SELECT COUNT(*) FROM residentes WHERE casa_id = $1 AND activo = true) as total_residentes,
                (SELECT COUNT(*) FROM mascotas WHERE residente_id IN 
                    (SELECT id FROM residentes WHERE casa_id = $1 AND activo = true) AND activo = true) as total_mascotas,
                (SELECT COUNT(*) FROM vehiculos WHERE casa_id = $1 AND activo = true) as total_vehiculos,
                (SELECT COUNT(*) FROM pagos_cuotas WHERE casa_id = $1 AND estado = 'pagado') as pagos_realizados,
                (SELECT COUNT(*) FROM pagos_cuotas WHERE casa_id = $1 AND estado = 'pendiente') as pagos_pendientes
        `, [id, id, id, id, id]);
        
        res.json({
            success: true,
            data: stats.rows[0]
        });
    } catch (error) {
        // Si las tablas no existen aún (fases no implementadas), retornar estadísticas básicas
        console.error('Error al obtener estadísticas:', error);
        res.json({
            success: true,
            data: {
                total_residentes: 0,
                total_mascotas: 0,
                total_vehiculos: 0,
                pagos_realizados: 0,
                pagos_pendientes: 0
            }
        });
    }
});

module.exports = router;
