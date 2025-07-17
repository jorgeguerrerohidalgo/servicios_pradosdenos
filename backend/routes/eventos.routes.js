const express = require('express');
const router = express.Router();
const { supabase } = require('../utils/supabase');

// Ruta para obtener eventos con paginación
router.get('/', async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        const offset = (page - 1) * limit;
        
        // Obtener eventos desde Supabase
        const { data: eventos, error, count } = await supabase
            .from('eventos_vecinales')
            .select('*', { count: 'exact' })
            .order('fecha_inicio', { ascending: false })
            .range(offset, offset + limit - 1);
        
        if (error) {
            console.error('Error obteniendo eventos:', error);
            return res.status(500).json({
                success: false,
                error: 'Error al obtener eventos'
            });
        }
        
        const result = {
            success: true,
            data: eventos || [],
            pagination: {
                total: count || 0,
                page: page,
                limit: limit,
                totalPages: Math.ceil((count || 0) / limit)
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
        
        const { data: evento, error } = await supabase
            .from('eventos_vecinales')
            .select('*')
            .eq('id', id)
            .single();
        
        if (error) {
            console.error('Error obteniendo evento:', error);
            return res.status(404).json({
                success: false,
                error: 'Evento no encontrado'
            });
        }
        
        res.json({
            success: true,
            data: evento
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
        
        const { data: evento, error } = await supabase
            .from('eventos_vecinales')
            .insert({
                titulo,
                descripcion,
                fecha_inicio,
                fecha_fin,
                tipo_evento_id,
                ubicacion,
                visible,
                creado_por,
                link_google_cal
            })
            .select()
            .single();
        
        if (error) {
            console.error('Error creando evento:', error);
            return res.status(500).json({
                success: false,
                error: 'Error al crear evento'
            });
        }
        
        res.status(201).json({
            success: true,
            data: evento,
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
        
        const { data: evento, error } = await supabase
            .from('eventos_vecinales')
            .update({
                titulo,
                descripcion,
                fecha_inicio,
                fecha_fin,
                tipo_evento_id,
                ubicacion,
                visible,
                link_google_cal
            })
            .eq('id', id)
            .select()
            .single();
        
        if (error) {
            console.error('Error actualizando evento:', error);
            return res.status(500).json({
                success: false,
                error: 'Error al actualizar evento'
            });
        }
        
        res.json({
            success: true,
            data: evento,
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
        
        const { error } = await supabase
            .from('eventos_vecinales')
            .delete()
            .eq('id', id);
        
        if (error) {
            console.error('Error eliminando evento:', error);
            return res.status(500).json({
                success: false,
                error: 'Error al eliminar evento'
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
        const { data: tipos, error } = await supabase
            .from('tipo_evento')
            .select('*')
            .order('nombre');
        
        if (error) {
            console.error('Error obteniendo tipos de evento:', error);
            return res.status(500).json({
                success: false,
                error: 'Error al obtener tipos de evento'
            });
        }
        
        res.json({
            success: true,
            data: tipos || []
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
