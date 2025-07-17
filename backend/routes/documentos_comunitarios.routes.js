const express = require('express');
const router = express.Router();
const db = requ        const docsResult = await db.query(docsQuery, [limit, offset]);
        
        // Formatear los datos para coincidir con lo que espera el frontend
        const formattedDocs = docsResult.map(doc => ({'../utils/db');

// Ruta para obtener tipos de documento
router.get('/tipos', async (req, res) => {
    try {
        const query = 'SELECT * FROM tipo_documento WHERE activo = true ORDER BY orden, nombre';
        const result = await db.query(query);
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error en tipos de documento:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor',
            details: error.message
        });
    }
});

// Ruta para obtener tipos de documento (alias para compatibilidad)
router.get('/tipos/all', async (req, res) => {
    try {
        // Verificar si las tablas existen
        const tableCheckQuery = `
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'tipo_documento'
            );
        `;
        const tableCheck = await db.query(tableCheckQuery);
        
        if (!tableCheck.rows[0].exists) {
            return res.json({
                success: true,
                data: [],
                message: 'Tabla tipo_documento no encontrada'
            });
        }
        
        const query = 'SELECT * FROM tipo_documento ORDER BY nombre';
        const result = await db.query(query);
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error en tipos de documento:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor',
            details: error.message
        });
    }
});

// Ruta principal para obtener documentos
router.get('/', async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        const offset = (page - 1) * limit;
        
        // Obtener documentos desde PostgreSQL con join a tipo_documento
        const countQuery = 'SELECT COUNT(*) FROM documentos_comunitarios';
        const countResult = await db.query(countQuery);
        const total = parseInt(countResult[0].count);
        
        const docsQuery = `
            SELECT d.*, td.nombre as tipo_documento, td.descripcion as tipo_documento_desc,
                   e.titulo as evento_titulo
            FROM documentos_comunitarios d
            LEFT JOIN tipo_documento td ON d.tipo_documento_id = td.id
            LEFT JOIN eventos_vecinales e ON d.evento_id = e.id
            WHERE d.visible = true
            ORDER BY d.fecha_publicacion DESC
            LIMIT $1 OFFSET $2
        `;
        const docsResult = await db.query(docsQuery, [limit, offset]);
        
        // Formatear los datos para coincidir con el frontend
        const formattedDocs = docsResult.map(doc => ({
            id: doc.id,
            titulo: doc.nombre, // Mapear nombre a titulo para el frontend
            descripcion: doc.descripcion,
            tipo_documento: doc.tipo_documento,
            tipo_documento_id: doc.tipo_documento_id,
            evento_titulo: doc.evento_titulo,
            evento_id: doc.evento_id,
            url_documento: doc.link_drive, // Mapear link_drive a url_documento
            activo: doc.visible, // Mapear visible a activo
            fecha_publicacion: doc.fecha_publicacion,
            created_at: doc.created_at,
            updated_at: doc.updated_at
        }));
        
        res.json({
            success: true,
            data: formattedDocs,
            pagination: {
                total: total,
                page: page,
                limit: limit,
                totalPages: Math.ceil(total / limit)
            }
        });
    } catch (error) {
        console.error('Error en documentos:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor',
            details: error.message
        });
    }
});

// Ruta para obtener un documento específico
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        const query = `
            SELECT d.*, td.nombre as tipo_documento_nombre, td.descripcion as tipo_documento_desc,
                   e.titulo as evento_titulo
            FROM documentos_comunitarios d
            LEFT JOIN tipo_documento td ON d.tipo_documento_id = td.id
            LEFT JOIN eventos_vecinales e ON d.evento_id = e.id
            WHERE d.id = $1
        `;
        const result = await db.query(query, [id]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Documento no encontrado'
            });
        }
        
        res.json({
            success: true,
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error en documento específico:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

// Ruta para crear un nuevo documento
router.post('/', async (req, res) => {
    try {
        const { 
            nombre, 
            descripcion, 
            tipo_documento_id, 
            link_drive, 
            evento_id = null,
            visible = true
        } = req.body;
        
        // Validaciones básicas
        if (!nombre || !link_drive) {
            return res.status(400).json({
                success: false,
                error: 'Nombre y link de Google Drive son requeridos'
            });
        }
        
        const query = `
            INSERT INTO documentos_comunitarios (nombre, descripcion, tipo_documento_id, link_drive, visible, fecha_publicacion, subido_por)
            VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP, $6)
            RETURNING *
        `;
        const result = await db.query(query, [
            nombre, descripcion, tipo_documento_id, link_drive, visible, 1
        ]);
        
        res.status(201).json({
            success: true,
            data: result.rows[0],
            message: 'Documento creado exitosamente'
        });
    } catch (error) {
        console.error('Error en crear documento:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor',
            details: error.message
        });
    }
});

// Ruta para actualizar un documento
router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            titulo, 
            descripcion, 
            tipo_documento_id, 
            url_documento, 
            evento_id,
            activo 
        } = req.body;
        
        // Validaciones básicas
        if (!nombre || !descripcion || !tipo_documento_id || !link_drive) {
            return res.status(400).json({
                success: false,
                error: 'Nombre, descripción, tipo de documento y link de Drive son requeridos'
            });
        }
        
        const query = `
            UPDATE documentos_comunitarios 
            SET nombre = $1, descripcion = $2, tipo_documento_id = $3, link_drive = $4, 
                fecha_publicacion = $5, evento_id = $6, visible = $7
            WHERE id = $8
            RETURNING *
        `;
        const result = await db.query(query, [
            nombre, descripcion, tipo_documento_id, link_drive, fecha_publicacion, evento_id, visible, id
        ]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Documento no encontrado'
            });
        }
        
        res.json({
            success: true,
            data: result.rows[0],
            message: 'Documento actualizado exitosamente'
        });
    } catch (error) {
        console.error('Error en actualizar documento:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

// Ruta para eliminar un documento
router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        const query = 'DELETE FROM documentos_comunitarios WHERE id = $1 RETURNING *';
        const result = await db.query(query, [id]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Documento no encontrado'
            });
        }
        
        res.json({
            success: true,
            message: 'Documento eliminado exitosamente'
        });
    } catch (error) {
        console.error('Error en eliminar documento:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

// Ruta para obtener documentos por evento
router.get('/evento/:evento_id', async (req, res) => {
    try {
        const { evento_id } = req.params;
        
        const query = `
            SELECT d.*, td.nombre as tipo_documento_nombre, td.descripcion as tipo_documento_desc
            FROM documentos_comunitarios d
            LEFT JOIN tipo_documento td ON d.tipo_documento_id = td.id
            WHERE d.evento_id = $1
            ORDER BY d.fecha_publicacion DESC
        `;
        const result = await db.query(query, [evento_id]);
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error en documentos por evento:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

module.exports = router;
