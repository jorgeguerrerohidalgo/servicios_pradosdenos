const express = require('express');
const router = express.Router();
const { supabase } = require('../utils/supabase');

// Ruta para obtener tipos de documento
router.get('/tipos', async (req, res) => {
    try {
        const { data: tipos, error } = await supabase
            .from('tipo_documento')
            .select('*')
            .order('nombre');
        
        if (error) {
            console.error('Error obteniendo tipos de documento:', error);
            return res.status(500).json({
                success: false,
                error: 'Error al obtener tipos de documento'
            });
        }
        
        res.json({
            success: true,
            data: tipos || []
        });
    } catch (error) {
        console.error('Error en tipos de documento:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

// Ruta principal para obtener documentos
router.get('/', async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        const offset = (page - 1) * limit;
        
        // Obtener documentos desde Supabase con join a tipo_documento
        const { data: documentos, error, count } = await supabase
            .from('documentos_comunitarios')
            .select(`
                *,
                tipo_documento:tipo_documento_id (
                    id,
                    nombre,
                    descripcion
                )
            `, { count: 'exact' })
            .order('fecha_publicacion', { ascending: false })
            .range(offset, offset + limit - 1);
        
        if (error) {
            console.error('Error obteniendo documentos:', error);
            return res.status(500).json({
                success: false,
                error: 'Error al obtener documentos'
            });
        }
        
        res.json({
            success: true,
            data: documentos || [],
            pagination: {
                total: count || 0,
                page: page,
                limit: limit,
                totalPages: Math.ceil((count || 0) / limit)
            }
        });
    } catch (error) {
        console.error('Error en documentos:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

// Ruta para obtener un documento específico
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        const { data: documento, error } = await supabase
            .from('documentos_comunitarios')
            .select(`
                *,
                tipo_documento:tipo_documento_id (
                    id,
                    nombre,
                    descripcion
                )
            `)
            .eq('id', id)
            .single();
        
        if (error) {
            console.error('Error obteniendo documento:', error);
            return res.status(404).json({
                success: false,
                error: 'Documento no encontrado'
            });
        }
        
        res.json({
            success: true,
            data: documento
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
            fecha_publicacion,
            evento_id = null,
            visible = true,
            subido_por 
        } = req.body;
        
        // Validaciones básicas
        if (!nombre || !descripcion || !tipo_documento_id || !link_drive) {
            return res.status(400).json({
                success: false,
                error: 'Nombre, descripción, tipo de documento y link de Drive son requeridos'
            });
        }
        
        const { data: documento, error } = await supabase
            .from('documentos_comunitarios')
            .insert({
                nombre,
                descripcion,
                tipo_documento_id,
                link_drive,
                fecha_publicacion: fecha_publicacion || new Date().toISOString(),
                evento_id,
                visible,
                subido_por
            })
            .select()
            .single();
        
        if (error) {
            console.error('Error creando documento:', error);
            return res.status(500).json({
                success: false,
                error: 'Error al crear documento'
            });
        }
        
        res.status(201).json({
            success: true,
            data: documento,
            message: 'Documento creado exitosamente'
        });
    } catch (error) {
        console.error('Error en crear documento:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

// Ruta para actualizar un documento
router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            nombre, 
            descripcion, 
            tipo_documento_id, 
            link_drive, 
            fecha_publicacion,
            evento_id,
            visible 
        } = req.body;
        
        // Validaciones básicas
        if (!nombre || !descripcion || !tipo_documento_id || !link_drive) {
            return res.status(400).json({
                success: false,
                error: 'Nombre, descripción, tipo de documento y link de Drive son requeridos'
            });
        }
        
        const { data: documento, error } = await supabase
            .from('documentos_comunitarios')
            .update({
                nombre,
                descripcion,
                tipo_documento_id,
                link_drive,
                fecha_publicacion,
                evento_id,
                visible
            })
            .eq('id', id)
            .select()
            .single();
        
        if (error) {
            console.error('Error actualizando documento:', error);
            return res.status(500).json({
                success: false,
                error: 'Error al actualizar documento'
            });
        }
        
        res.json({
            success: true,
            data: documento,
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
        
        const { error } = await supabase
            .from('documentos_comunitarios')
            .delete()
            .eq('id', id);
        
        if (error) {
            console.error('Error eliminando documento:', error);
            return res.status(500).json({
                success: false,
                error: 'Error al eliminar documento'
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
        
        const { data: documentos, error } = await supabase
            .from('documentos_comunitarios')
            .select(`
                *,
                tipo_documento:tipo_documento_id (
                    id,
                    nombre,
                    descripcion
                )
            `)
            .eq('evento_id', evento_id)
            .order('fecha_publicacion', { ascending: false });
        
        if (error) {
            console.error('Error obteniendo documentos por evento:', error);
            return res.status(500).json({
                success: false,
                error: 'Error al obtener documentos del evento'
            });
        }
        
        res.json({
            success: true,
            data: documentos || []
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
