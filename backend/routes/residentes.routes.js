const express = require('express');
const router = express.Router();
const { pool } = require('../utils/db');
const { requireAuth, requireAdmin, requireAuthAdmin } = require('../middleware/sessionAuth');

// ==================== GESTIÓN DE RESIDENTES ====================

// GET /api/residentes - Obtener todos los residentes (requiere autenticación admin)
router.get('/', requireAuthAdmin, async (req, res) => {
    try {
        const { casa_id, activo = 'true', search } = req.query;
        
        let sql = `
            SELECT 
                r.id,
                r.casa_id,
                c.numero_casa,
                c.direccion as casa_direccion,
                p.nombre as plaza_nombre,
                r.nombre,
                r.apellido_paterno,
                r.apellido_materno,
                CONCAT(r.nombre, ' ', r.apellido_paterno, ' ', COALESCE(r.apellido_materno, '')) as nombre_completo,
                r.run,
                r.fecha_nacimiento,
                EXTRACT(YEAR FROM AGE(CURRENT_DATE, r.fecha_nacimiento))::INTEGER as edad,
                r.email,
                r.telefono,
                r.activo,
                r.created_at,
                r.updated_at
            FROM residentes r
            LEFT JOIN casas c ON r.casa_id = c.id
            LEFT JOIN plazas p ON c.plaza_id = p.id
            WHERE 1=1
        `;
        
        const params = [];
        let paramCount = 0;
        
        if (activo !== 'all') {
            paramCount++;
            sql += ` AND r.activo = $${paramCount}`;
            params.push(activo === 'true');
        }
        
        if (casa_id) {
            paramCount++;
            sql += ` AND r.casa_id = $${paramCount}`;
            params.push(casa_id);
        }
        
        if (search) {
            paramCount++;
            sql += ` AND (
                r.nombre ILIKE $${paramCount} OR 
                r.apellido_paterno ILIKE $${paramCount} OR 
                r.apellido_materno ILIKE $${paramCount} OR
                r.run ILIKE $${paramCount} OR
                c.numero_casa ILIKE $${paramCount}
            )`;
            params.push(`%${search}%`);
        }
        
        sql += ' ORDER BY c.numero_casa ASC, r.apellido_paterno ASC, r.apellido_materno ASC, r.nombre ASC';
        
        const result = await pool.query(sql, params);
        
        res.json({
            success: true,
            data: result.rows,
            total: result.rows.length
        });
    } catch (error) {
        console.error('Error al obtener residentes:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor',
            error: error.message
        });
    }
});

// GET /api/residentes/casa/:casa_id - Obtener residentes de una casa específica
router.get('/casa/:casa_id', requireAuthAdmin, async (req, res) => {
    try {
        const { casa_id } = req.params;
        const { activo = 'true' } = req.query;
        
        let sql = `
            SELECT 
                r.id,
                r.casa_id,
                r.nombre,
                r.apellido_paterno,
                r.apellido_materno,
                CONCAT(r.nombre, ' ', r.apellido_paterno, ' ', COALESCE(r.apellido_materno, '')) as nombre_completo,
                r.run,
                r.fecha_nacimiento,
                EXTRACT(YEAR FROM AGE(CURRENT_DATE, r.fecha_nacimiento))::INTEGER as edad,
                r.email,
                r.telefono,
                r.activo,
                r.created_at
            FROM residentes r
            WHERE r.casa_id = $1
        `;
        
        const params = [casa_id];
        
        if (activo !== 'all') {
            sql += ' AND r.activo = $2';
            params.push(activo === 'true');
        }
        
        sql += ' ORDER BY r.apellido_paterno ASC, r.apellido_materno ASC, r.nombre ASC';
        
        const result = await pool.query(sql, params);
        
        res.json({
            success: true,
            data: result.rows,
            total: result.rows.length
        });
    } catch (error) {
        console.error('Error al obtener residentes de casa:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// GET /api/residentes/simple - Obtener lista simple para dropdowns
router.get('/simple', requireAuth, async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT 
                id, 
                CONCAT(nombre, ' ', apellido_paterno, ' ', COALESCE(apellido_materno, '')) as nombre_completo,
                run,
                casa_id
            FROM residentes
            WHERE activo = true
            ORDER BY apellido_paterno, apellido_materno, nombre
        `);
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error al obtener residentes simples:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// GET /api/residentes/:id - Obtener residente específico por ID
router.get('/:id', requireAuthAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(`
            SELECT 
                r.id,
                r.casa_id,
                c.numero_casa,
                c.direccion as casa_direccion,
                p.nombre as plaza_nombre,
                r.nombre,
                r.apellido_paterno,
                r.apellido_materno,
                r.run,
                r.fecha_nacimiento,
                EXTRACT(YEAR FROM AGE(CURRENT_DATE, r.fecha_nacimiento))::INTEGER as edad,
                r.email,
                r.telefono,
                r.activo,
                r.created_at,
                r.updated_at
            FROM residentes r
            LEFT JOIN casas c ON r.casa_id = c.id
            LEFT JOIN plazas p ON c.plaza_id = p.id
            WHERE r.id = $1
        `, [id]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Residente no encontrado'
            });
        }
        
        res.json({
            success: true,
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al obtener residente:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// POST /api/residentes - Crear nuevo residente
router.post('/', requireAdmin, async (req, res) => {
    try {
        const { 
            casa_id,
            nombre, 
            apellido_paterno,
            apellido_materno,
            run,
            fecha_nacimiento,
            email,
            telefono
        } = req.body;
        
        // Validar campos requeridos
        if (!casa_id || !nombre || !apellido_paterno || !run || !fecha_nacimiento) {
            return res.status(400).json({
                success: false,
                message: 'Faltan campos requeridos: casa_id, nombre, apellido_paterno, run, fecha_nacimiento'
            });
        }
        
        // Validar formato de RUN (sin puntos, con guión)
        const runRegex = /^\d{7,8}-[\dkK]$/;
        if (!runRegex.test(run)) {
            return res.status(400).json({
                success: false,
                message: 'Formato de RUN inválido. Use formato: 12345678-9 (sin puntos)'
            });
        }
        
        // Validar que la casa existe
        const casaExists = await pool.query('SELECT id FROM casas WHERE id = $1 AND activo = true', [casa_id]);
        if (casaExists.rows.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'La casa especificada no existe o está inactiva'
            });
        }
        
        // Verificar que el RUN no esté duplicado
        const existingRun = await pool.query('SELECT id FROM residentes WHERE run = $1', [run.toUpperCase()]);
        if (existingRun.rows.length > 0) {
            return res.status(400).json({
                success: false,
                message: 'Ya existe un residente con este RUN'
            });
        }
        
        // Validar email si se proporciona
        if (email) {
            const emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
            if (!emailRegex.test(email)) {
                return res.status(400).json({
                    success: false,
                    message: 'Formato de email inválido'
                });
            }
        }
        
        // Validar que la fecha de nacimiento no sea futura
        const fechaNac = new Date(fecha_nacimiento);
        if (fechaNac > new Date()) {
            return res.status(400).json({
                success: false,
                message: 'La fecha de nacimiento no puede ser futura'
            });
        }
        
        // Insertar residente
        const result = await pool.query(`
            INSERT INTO residentes (
                casa_id,
                nombre, 
                apellido_paterno,
                apellido_materno,
                run,
                fecha_nacimiento,
                email,
                telefono,
                activo
            ) 
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, true) 
            RETURNING 
                id,
                casa_id,
                nombre, 
                apellido_paterno,
                apellido_materno,
                run,
                fecha_nacimiento,
                email,
                telefono,
                activo,
                created_at,
                updated_at
        `, [
            casa_id,
            nombre.trim(),
            apellido_paterno.trim(),
            apellido_materno ? apellido_materno.trim() : null,
            run.toUpperCase(),
            fecha_nacimiento,
            email ? email.trim().toLowerCase() : null,
            telefono ? telefono.trim() : null
        ]);
        
        res.status(201).json({
            success: true,
            message: 'Residente creado exitosamente',
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al crear residente:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor',
            error: error.message
        });
    }
});

// PUT /api/residentes/:id - Actualizar residente existente
router.put('/:id', requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            casa_id,
            nombre, 
            apellido_paterno,
            apellido_materno,
            run,
            fecha_nacimiento,
            email,
            telefono,
            activo
        } = req.body;
        
        // Verificar que el residente existe
        const residenteExists = await pool.query('SELECT id FROM residentes WHERE id = $1', [id]);
        if (residenteExists.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Residente no encontrado'
            });
        }
        
        // Si se cambia el RUN, verificar que no esté duplicado
        if (run) {
            const runRegex = /^\d{7,8}-[\dkK]$/;
            if (!runRegex.test(run)) {
                return res.status(400).json({
                    success: false,
                    message: 'Formato de RUN inválido'
                });
            }
            
            const existingRun = await pool.query(
                'SELECT id FROM residentes WHERE run = $1 AND id != $2', 
                [run.toUpperCase(), id]
            );
            if (existingRun.rows.length > 0) {
                return res.status(400).json({
                    success: false,
                    message: 'Ya existe otro residente con este RUN'
                });
            }
        }
        
        // Si se cambia la casa, verificar que existe
        if (casa_id) {
            const casaExists = await pool.query('SELECT id FROM casas WHERE id = $1 AND activo = true', [casa_id]);
            if (casaExists.rows.length === 0) {
                return res.status(400).json({
                    success: false,
                    message: 'La casa especificada no existe o está inactiva'
                });
            }
        }
        
        // Validar email si se proporciona
        if (email) {
            const emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
            if (!emailRegex.test(email)) {
                return res.status(400).json({
                    success: false,
                    message: 'Formato de email inválido'
                });
            }
        }
        
        // Construir query de actualización dinámicamente
        const updates = [];
        const values = [];
        let paramCount = 0;
        
        if (casa_id !== undefined) {
            paramCount++;
            updates.push(`casa_id = $${paramCount}`);
            values.push(casa_id);
        }
        if (nombre !== undefined) {
            paramCount++;
            updates.push(`nombre = $${paramCount}`);
            values.push(nombre.trim());
        }
        if (apellido_paterno !== undefined) {
            paramCount++;
            updates.push(`apellido_paterno = $${paramCount}`);
            values.push(apellido_paterno.trim());
        }
        if (apellido_materno !== undefined) {
            paramCount++;
            updates.push(`apellido_materno = $${paramCount}`);
            values.push(apellido_materno ? apellido_materno.trim() : null);
        }
        if (run !== undefined) {
            paramCount++;
            updates.push(`run = $${paramCount}`);
            values.push(run.toUpperCase());
        }
        if (fecha_nacimiento !== undefined) {
            paramCount++;
            updates.push(`fecha_nacimiento = $${paramCount}`);
            values.push(fecha_nacimiento);
        }
        if (email !== undefined) {
            paramCount++;
            updates.push(`email = $${paramCount}`);
            values.push(email ? email.trim().toLowerCase() : null);
        }
        if (telefono !== undefined) {
            paramCount++;
            updates.push(`telefono = $${paramCount}`);
            values.push(telefono ? telefono.trim() : null);
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
            UPDATE residentes 
            SET ${updates.join(', ')}
            WHERE id = $${paramCount}
            RETURNING 
                id,
                casa_id,
                nombre, 
                apellido_paterno,
                apellido_materno,
                run,
                fecha_nacimiento,
                email,
                telefono,
                activo,
                created_at,
                updated_at
        `, values);
        
        res.json({
            success: true,
            message: 'Residente actualizado exitosamente',
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al actualizar residente:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor',
            error: error.message
        });
    }
});

// DELETE /api/residentes/:id - Eliminar residente (soft delete)
router.delete('/:id', requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        
        // Verificar que el residente existe
        const residenteExists = await pool.query(
            'SELECT id, nombre, apellido_paterno FROM residentes WHERE id = $1', 
            [id]
        );
        
        if (residenteExists.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Residente no encontrado'
            });
        }
        
        // Soft delete
        await pool.query('UPDATE residentes SET activo = false WHERE id = $1', [id]);
        
        res.json({
            success: true,
            message: 'Residente desactivado exitosamente'
        });
    } catch (error) {
        console.error('Error al eliminar residente:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor',
            error: error.message
        });
    }
});

// GET /api/residentes/estadisticas/general - Obtener estadísticas generales
router.get('/estadisticas/general', requireAuthAdmin, async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT 
                COUNT(*) as total_residentes,
                COUNT(DISTINCT casa_id) as casas_con_residentes,
                ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento))), 1) as promedio_edad,
                MAX(EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento)))::INTEGER as edad_maxima,
                MIN(EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento)))::INTEGER as edad_minima
            FROM residentes
            WHERE activo = true
        `);
        
        res.json({
            success: true,
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al obtener estadísticas:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

module.exports = router;
