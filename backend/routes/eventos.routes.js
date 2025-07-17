const express = require('express');
const router = express.Router();
const db = require('../utils/db');

// Ruta para obtener eventos con paginación
router.get('/', async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        const offset = (page - 1) * limit;
        
        // Obtener eventos desde PostgreSQL
        const countQuery = 'SELECT COUNT(*) FROM eventos_vecinales';
        const countResult = await db.query(countQuery);
        const total = parseInt(countResult.rows[0].count);
        
        const eventsQuery = `
            SELECT e.*, te.nombre as tipo_evento_nombre 
            FROM eventos_vecinales e
            LEFT JOIN tipo_evento te ON e.tipo_evento_id = te.id
            ORDER BY e.fecha_inicio DESC
            LIMIT $1 OFFSET $2
        `;
        const eventsResult = await db.query(eventsQuery, [limit, offset]);
        
        const result = {
            success: true,
            data: eventsResult.rows,
            pagination: {
                total: total,
                page: page,
                limit: limit,
                totalPages: Math.ceil(total / limit)
            }
        };
        
        res.json(result);
    } catch (error) {
        console.error('Error en eventos:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

// Ruta para obtener un evento específico
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        const query = `
            SELECT e.*, te.nombre as tipo_evento_nombre 
            FROM eventos_vecinales e
            LEFT JOIN tipo_evento te ON e.tipo_evento_id = te.id
            WHERE e.id = $1
        `;
        const result = await db.query(query, [id]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Evento no encontrado'
            });
        }
        
        res.json({
            success: true,
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error en evento específico:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

// Ruta para crear un nuevo evento
router.post('/', async (req, res) => {
    try {
        const { 
            titulo, 
            descripcion, 
            fecha_inicio, 
            fecha_fin, 
            tipo_evento_id, 
            ubicacion, 
            visible = true,
            creado_por 
        } = req.body;
        
        // Validaciones básicas
        if (!titulo || !descripcion || !fecha_inicio) {
            return res.status(400).json({
                success: false,
                error: 'Título, descripción y fecha de inicio son requeridos'
            });
        }
        
        // Generar link de Google Calendar
        const link_google_cal = `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${encodeURIComponent(titulo)}&dates=${fecha_inicio.replace(/[-:]/g, '').split('.')[0]}/${(fecha_fin || fecha_inicio).replace(/[-:]/g, '').split('.')[0]}&details=${encodeURIComponent(descripcion)}&location=${encodeURIComponent(ubicacion || '')}`;
        
        const query = `
            INSERT INTO eventos_vecinales (titulo, descripcion, fecha_inicio, fecha_fin, tipo_evento_id, ubicacion, visible, creado_por, link_google_cal)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
            RETURNING *
        `;
        const result = await db.query(query, [
            titulo, descripcion, fecha_inicio, fecha_fin, tipo_evento_id, ubicacion, visible, creado_por, link_google_cal
        ]);
        
        res.status(201).json({
            success: true,
            data: result.rows[0],
            message: 'Evento creado exitosamente'
        });
    } catch (error) {
        console.error('Error en crear evento:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

// Ruta para actualizar un evento
router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            titulo, 
            descripcion, 
            fecha_inicio, 
            fecha_fin, 
            tipo_evento_id, 
            ubicacion, 
            visible 
        } = req.body;
        
        // Validaciones básicas
        if (!titulo || !descripcion || !fecha_inicio) {
            return res.status(400).json({
                success: false,
                error: 'Título, descripción y fecha de inicio son requeridos'
            });
        }
        
        // Generar link de Google Calendar actualizado
        const link_google_cal = `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${encodeURIComponent(titulo)}&dates=${fecha_inicio.replace(/[-:]/g, '').split('.')[0]}/${(fecha_fin || fecha_inicio).replace(/[-:]/g, '').split('.')[0]}&details=${encodeURIComponent(descripcion)}&location=${encodeURIComponent(ubicacion || '')}`;
        
        const query = `
            UPDATE eventos_vecinales 
            SET titulo = $1, descripcion = $2, fecha_inicio = $3, fecha_fin = $4, 
                tipo_evento_id = $5, ubicacion = $6, visible = $7, link_google_cal = $8
            WHERE id = $9
            RETURNING *
        `;
        const result = await db.query(query, [
            titulo, descripcion, fecha_inicio, fecha_fin, tipo_evento_id, ubicacion, visible, link_google_cal, id
        ]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Evento no encontrado'
            });
        }
        
        res.json({
            success: true,
            data: result.rows[0],
            message: 'Evento actualizado exitosamente'
        });
    } catch (error) {
        console.error('Error en actualizar evento:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

// Ruta para eliminar un evento
router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        const query = 'DELETE FROM eventos_vecinales WHERE id = $1 RETURNING *';
        const result = await db.query(query, [id]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                error: 'Evento no encontrado'
            });
        }
        
        res.json({
            success: true,
            message: 'Evento eliminado exitosamente'
        });
    } catch (error) {
        console.error('Error en eliminar evento:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

// Ruta para obtener tipos de evento
router.get('/tipos/all', async (req, res) => {
    try {
        const query = 'SELECT * FROM tipo_evento ORDER BY nombre';
        const result = await db.query(query);
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error en tipos de evento:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

module.exports = router;
