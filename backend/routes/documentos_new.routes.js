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

module.exports = router;

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
                hasMore: false
            }
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

// Ruta para documento específico
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        res.json({
            success: true,
            data: {
                id: parseInt(id),
                titulo: 'Documento ' + id,
                descripcion: 'Descripción del documento',
                categoria_nombre: 'Reglamentos',
                created_at: new Date().toISOString()
            }
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

module.exports = router;
