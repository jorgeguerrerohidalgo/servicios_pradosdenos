const express = require('express');
const router = express.Router();
const pool = require('../utils/db');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

// ==================== DOCUMENTOS COMUNITARIOS ====================

// GET /api/documentos - Obtener todos los documentos (público)
router.get('/', async (req, res) => {
    try {
        const { tipo, destacado, visible = 'true' } = req.query;
        
        let query = `
            SELECT 
                d.id,
                d.nombre,
                d.descripcion,
                d.link_drive,
                d.nombre_archivo,
                d.tamaño_archivo,
                d.fecha_publicacion,
                d.fecha_vencimiento,
                d.visible,
                d.destacado,
                d.requiere_autenticacion,
                d.created_at,
                d.updated_at,
                td.nombre as tipo_nombre,
                td.icono as tipo_icono,
                td.color as tipo_color,
                au.nombre as subido_por_nombre
            FROM documentos_comunitarios d
            LEFT JOIN tipo_documento td ON d.tipo_documento_id = td.id
            LEFT JOIN admin_users au ON d.subido_por = au.id
            WHERE d.visible = $1
        `;
        
        const params = [visible === 'true'];
        let paramCount = 1;
        
        if (tipo) {
            paramCount++;
            query += ` AND d.tipo_documento_id = $${paramCount}`;
            params.push(tipo);
        }
        
        if (destacado !== undefined) {
            paramCount++;
            query += ` AND d.destacado = $${paramCount}`;
            params.push(destacado === 'true');
        }
        
        // Ordenar por destacado primero, luego por fecha de publicación
        query += ' ORDER BY d.destacado DESC, d.fecha_publicacion DESC';
        
        const result = await pool.query(query, params);
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error al obtener documentos:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// GET /api/documentos/tipos - Obtener tipos de documento
router.get('/tipos', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT id, nombre, descripcion, icono, color, orden
            FROM tipo_documento 
            WHERE activo = true 
            ORDER BY orden, nombre
        `);
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error al obtener tipos de documento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// GET /api/documentos/:id - Obtener documento específico
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(`
            SELECT 
                d.*,
                td.nombre as tipo_nombre,
                td.icono as tipo_icono,
                td.color as tipo_color,
                au.nombre as subido_por_nombre
            FROM documentos_comunitarios d
            LEFT JOIN tipo_documento td ON d.tipo_documento_id = td.id
            LEFT JOIN admin_users au ON d.subido_por = au.id
            WHERE d.id = $1 AND d.visible = true
        `, [id]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Documento no encontrado'
            });
        }
        
        res.json({
            success: true,
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al obtener documento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// POST /api/documentos/download/:id - Registrar descarga de documento
router.post('/download/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { email_descarga, nombre_descarga } = req.body;
        const ip_address = req.ip || req.connection.remoteAddress;
        const user_agent = req.get('User-Agent');
        
        // Verificar que el documento existe
        const docResult = await pool.query(
            'SELECT id FROM documentos_comunitarios WHERE id = $1 AND visible = true',
            [id]
        );
        
        if (docResult.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Documento no encontrado'
            });
        }
        
        // Registrar la descarga
        await pool.query(`
            INSERT INTO descargas_documentos 
            (documento_id, email_descarga, nombre_descarga, ip_address, user_agent, metodo_descarga)
            VALUES ($1, $2, $3, $4, $5, 'google_drive')
        `, [id, email_descarga, nombre_descarga, ip_address, user_agent]);
        
        res.json({
            success: true,
            message: 'Descarga registrada exitosamente'
        });
    } catch (error) {
        console.error('Error al registrar descarga:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// ==================== RUTAS ADMINISTRATIVAS ====================

// GET /api/documentos/admin/all - Obtener todos los documentos (admin)
router.get('/admin/all', authenticateToken, async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT 
                d.id,
                d.nombre,
                d.descripcion,
                d.link_drive,
                d.nombre_archivo,
                d.tamaño_archivo,
                d.fecha_publicacion,
                d.fecha_vencimiento,
                d.visible,
                d.destacado,
                d.requiere_autenticacion,
                d.created_at,
                d.updated_at,
                td.nombre as tipo_nombre,
                td.icono as tipo_icono,
                td.color as tipo_color,
                au.nombre as subido_por_nombre,
                (SELECT COUNT(*) FROM descargas_documentos WHERE documento_id = d.id) as total_descargas
            FROM documentos_comunitarios d
            LEFT JOIN tipo_documento td ON d.tipo_documento_id = td.id
            LEFT JOIN admin_users au ON d.subido_por = au.id
            ORDER BY d.created_at DESC
        `);
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error al obtener documentos (admin):', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// POST /api/documentos/admin - Crear documento (admin)
router.post('/admin', authenticateToken, requireAdmin, async (req, res) => {
    try {
        const {
            nombre,
            descripcion,
            tipo_documento_id,
            link_drive,
            nombre_archivo,
            tamaño_archivo,
            fecha_publicacion,
            fecha_vencimiento,
            visible,
            destacado,
            requiere_autenticacion
        } = req.body;
        
        const result = await pool.query(`
            INSERT INTO documentos_comunitarios 
            (nombre, descripcion, tipo_documento_id, link_drive, nombre_archivo, 
             tamaño_archivo, fecha_publicacion, fecha_vencimiento, visible, 
             destacado, requiere_autenticacion, subido_por)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
            RETURNING *
        `, [
            nombre, descripcion, tipo_documento_id, link_drive, nombre_archivo,
            tamaño_archivo, fecha_publicacion, fecha_vencimiento, visible,
            destacado, requiere_autenticacion, req.user.id
        ]);
        
        res.status(201).json({
            success: true,
            message: 'Documento creado exitosamente',
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al crear documento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// PUT /api/documentos/admin/:id - Actualizar documento (admin)
router.put('/admin/:id', authenticateToken, requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        const {
            nombre,
            descripcion,
            tipo_documento_id,
            link_drive,
            nombre_archivo,
            tamaño_archivo,
            fecha_publicacion,
            fecha_vencimiento,
            visible,
            destacado,
            requiere_autenticacion
        } = req.body;
        
        const result = await pool.query(`
            UPDATE documentos_comunitarios 
            SET nombre = $1, descripcion = $2, tipo_documento_id = $3, 
                link_drive = $4, nombre_archivo = $5, tamaño_archivo = $6,
                fecha_publicacion = $7, fecha_vencimiento = $8, visible = $9,
                destacado = $10, requiere_autenticacion = $11, 
                modificado_por = $12, updated_at = NOW()
            WHERE id = $13
            RETURNING *
        `, [
            nombre, descripcion, tipo_documento_id, link_drive, nombre_archivo,
            tamaño_archivo, fecha_publicacion, fecha_vencimiento, visible,
            destacado, requiere_autenticacion, req.user.id, id
        ]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Documento no encontrado'
            });
        }
        
        res.json({
            success: true,
            message: 'Documento actualizado exitosamente',
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al actualizar documento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// DELETE /api/documentos/admin/:id - Eliminar documento (admin)
router.delete('/admin/:id', authenticateToken, requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(
            'DELETE FROM documentos_comunitarios WHERE id = $1 RETURNING *',
            [id]
        );
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Documento no encontrado'
            });
        }
        
        res.json({
            success: true,
            message: 'Documento eliminado exitosamente'
        });
    } catch (error) {
        console.error('Error al eliminar documento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// GET /api/documentos/admin/:id/descargas - Obtener estadísticas de descarga
router.get('/admin/:id/descargas', authenticateToken, requireAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(`
            SELECT 
                email_descarga,
                nombre_descarga,
                ip_address,
                metodo_descarga,
                created_at
            FROM descargas_documentos 
            WHERE documento_id = $1 
            ORDER BY created_at DESC
        `, [id]);
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error al obtener descargas:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

module.exports = router;
