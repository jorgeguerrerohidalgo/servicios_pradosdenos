// Rutas para documentos comunitarios - versión funcional
const express = require('express');
const router = express.Router();
const db = require('../utils/db');

// Middleware para verificar autenticación
const verificarAuth = (req, res, next) => {
    if (!req.session || !req.session.userId) {
        return res.status(401).json({
            success: false,
            error: 'No autorizado'
        });
    }
    next();
};

// GET /api/documentos_comunitarios - Obtener todos los documentos
router.get('/', verificarAuth, async (req, res) => {
    try {
        console.log('GET /api/documentos_comunitarios - Obteniendo documentos');
        
        const result = await db.query(`
            SELECT 
                id,
                titulo,
                descripcion,
                tipo,
                url_archivo,
                fecha_creacion,
                fecha_modificacion,
                activo
            FROM documentos_comunitarios 
            WHERE activo = true
            ORDER BY fecha_creacion DESC
        `);
        
        console.log('Documentos obtenidos:', result.length);
        
        res.json({
            success: true,
            data: result || [],
            total: result ? result.length : 0
        });
        
    } catch (error) {
        console.error('Error obteniendo documentos:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor',
            data: []
        });
    }
});

// POST /api/documentos_comunitarios - Crear nuevo documento
router.post('/', verificarAuth, async (req, res) => {
    try {
        console.log('POST /api/documentos_comunitarios - Creando documento');
        
        const { titulo, descripcion, tipo, url_archivo } = req.body;
        
        if (!titulo || !descripcion || !tipo) {
            return res.status(400).json({
                success: false,
                error: 'Título, descripción y tipo son requeridos'
            });
        }
        
        const result = await db.query(`
            INSERT INTO documentos_comunitarios 
            (titulo, descripcion, tipo, url_archivo, fecha_creacion, fecha_modificacion, activo)
            VALUES ($1, $2, $3, $4, NOW(), NOW(), true)
            RETURNING *
        `, [titulo, descripcion, tipo, url_archivo]);
        
        console.log('Documento creado:', result[0]);
        
        res.status(201).json({
            success: true,
            data: result[0],
            message: 'Documento creado exitosamente'
        });
        
    } catch (error) {
        console.error('Error creando documento:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

module.exports = router;
