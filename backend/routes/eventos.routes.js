const express = require('express');
const router = express.Router();
const db = require('../utils/db');

// Ruta para obtener eventos con paginación
router.get('/', async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        const offset = (page - 1) * limit;
        
        // Verificar si las tablas existen
        const tableCheckQuery = `
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'eventos_vecinales'
            );
        `;
        const tableCheck = await db.query(tableCheckQuery);
        
        if (!tableCheck.rows[0].exists) {
            return res.json({
                success: true,
                data: [],
                pagination: {
                    total: 0,
                    page: page,
                    limit: limit,
                    totalPages: 0
                },
                message: 'Tabla eventos_vecinales no encontrada'
            });
        }
        
        // Obtener eventos desde PostgreSQL
        const countQuery = 'SELECT COUNT(*) FROM eventos_vecinales';
        const countResult = await db.query(countQuery);
        const total = parseInt(countResult.rows[0].count);
        
        const eventsQuery = `
            SELECT e.*, te.nombre as tipo_evento 
            FROM eventos_vecinales e
            LEFT JOIN tipo_evento te ON e.tipo_evento_id = te.id
            WHERE e.visible = true
            ORDER BY e.fecha_inicio DESC
            LIMIT $1 OFFSET $2
        `;
        const eventsResult = await db.query(eventsQuery, [limit, offset]);
        
        // Formatear los datos para coincidir con lo que espera el frontend
        const formattedEvents = eventsResult.rows.map(event => ({
            id: event.id,
            titulo: event.titulo,
            descripcion: event.descripcion,
            fecha_evento: event.fecha_inicio,
            fecha_fin: event.fecha_fin,
            hora_evento: event.fecha_inicio ? new Date(event.fecha_inicio).toTimeString().slice(0, 5) : null,
            lugar: event.ubicacion,
            tipo_evento: event.tipo_evento,
            tipo_evento_id: event.tipo_evento_id,
            activo: event.visible,
            link_google_cal: event.link_google_cal,
            created_at: event.created_at,
            updated_at: event.updated_at
        }));
        
        const result = {
            success: true,
            data: formattedEvents,
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
            error: 'Error interno del servidor',
            details: error.message
        });
    }
});

// Ruta para obtener un evento específico
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        const query = `
            SELECT e.*, te.nombre as tipo_evento 
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
        
        // Formatear el evento para coincidir con el frontend
        const evento = result.rows[0];
        const formattedEvent = {
            id: evento.id,
            titulo: evento.titulo,
            descripcion: evento.descripcion,
            fecha_evento: evento.fecha_inicio,
            fecha_fin: evento.fecha_fin,
            hora_evento: evento.fecha_inicio ? new Date(evento.fecha_inicio).toTimeString().slice(0, 5) : null,
            lugar: evento.ubicacion,
            tipo_evento: evento.tipo_evento,
            tipo_evento_id: evento.tipo_evento_id,
            activo: evento.visible,
            link_google_cal: evento.link_google_cal,
            created_at: evento.created_at,
            updated_at: evento.updated_at
        };
        
        res.json({
            success: true,
            data: formattedEvent
        });
    } catch (error) {
        console.error('Error en evento específico:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor',
            details: error.message
        });
    }
});

// Ruta para crear un nuevo evento
router.post('/', async (req, res) => {
    try {
        const { 
            titulo, 
            descripcion, 
            fecha_evento, 
            hora_evento, 
            tipo_evento_id, 
            lugar, 
            activo = true
        } = req.body;
        
        // Validaciones básicas
        if (!titulo) {
            return res.status(400).json({
                success: false,
                error: 'Título es requerido'
            });
        }
        
        // Combinar fecha y hora para crear fecha_inicio
        let fecha_inicio = null;
        let fecha_fin = null;
        
        if (fecha_evento) {
            if (hora_evento) {
                fecha_inicio = new Date(`${fecha_evento}T${hora_evento}:00`);
            } else {
                fecha_inicio = new Date(`${fecha_evento}T00:00:00`);
            }
            
            // fecha_fin es obligatoria, por defecto será 2 horas después
            fecha_fin = new Date(fecha_inicio.getTime() + 2*60*60*1000);
        }
        
        // Generar link de Google Calendar
        let link_google_cal = null;
        if (fecha_inicio && fecha_fin) {
            const startDate = fecha_inicio.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z';
            const endDate = fecha_fin.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z';
            link_google_cal = `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${encodeURIComponent(titulo)}&dates=${startDate}/${endDate}&details=${encodeURIComponent(descripcion || '')}&location=${encodeURIComponent(lugar || '')}`;
        }
        
        const query = `
            INSERT INTO eventos_vecinales (titulo, descripcion, fecha_inicio, fecha_fin, tipo_evento_id, ubicacion, visible, link_google_cal, creado_por)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
            RETURNING *
        `;
        const result = await db.query(query, [
            titulo, descripcion, fecha_inicio, fecha_fin, tipo_evento_id, lugar, activo, link_google_cal, 1
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
            error: 'Error interno del servidor',
            details: error.message
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
            fecha_evento, 
            hora_evento, 
            tipo_evento_id, 
            lugar, 
            activo = true
        } = req.body;
        
        // Validaciones básicas
        if (!titulo) {
            return res.status(400).json({
                success: false,
                error: 'Título es requerido'
            });
        }
        
        // Combinar fecha y hora para crear fecha_inicio
        let fecha_inicio = null;
        let fecha_fin = null;
        
        if (fecha_evento) {
            if (hora_evento) {
                fecha_inicio = new Date(`${fecha_evento}T${hora_evento}:00`);
            } else {
                fecha_inicio = new Date(`${fecha_evento}T00:00:00`);
            }
            
            // fecha_fin es obligatoria, por defecto será 2 horas después
            fecha_fin = new Date(fecha_inicio.getTime() + 2*60*60*1000);
        }
        
        // Generar link de Google Calendar actualizado
        let link_google_cal = null;
        if (fecha_inicio && fecha_fin) {
            const startDate = fecha_inicio.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z';
            const endDate = fecha_fin.toISOString().replace(/[-:]/g, '').split('.')[0] + 'Z';
            link_google_cal = `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${encodeURIComponent(titulo)}&dates=${startDate}/${endDate}&details=${encodeURIComponent(descripcion || '')}&location=${encodeURIComponent(lugar || '')}`;
        }
        
        const query = `
            UPDATE eventos_vecinales 
            SET titulo = $1, descripcion = $2, fecha_inicio = $3, fecha_fin = $4,
                tipo_evento_id = $5, ubicacion = $6, visible = $7, link_google_cal = $8,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = $9
            RETURNING *
        `;
        const result = await db.query(query, [
            titulo, descripcion, fecha_inicio, fecha_fin, tipo_evento_id, lugar, activo, link_google_cal, id
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
        // Verificar si las tablas existen
        const tableCheckQuery = `
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'tipo_evento'
            );
        `;
        const tableCheck = await db.query(tableCheckQuery);
        
        if (!tableCheck.rows[0].exists) {
            return res.json({
                success: true,
                data: [],
                message: 'Tabla tipo_evento no encontrada'
            });
        }
        
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
            error: 'Error interno del servidor',
            details: error.message
        });
    }
});

module.exports = router;
