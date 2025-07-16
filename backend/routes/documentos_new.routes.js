const express = require('express');
const router = express.Router();
const db = require('../utils/db');

// Ruta para obtener categorías de documentos
router.get('/categorias', async (req, res) => {
    try {
        res.json({
            success: true,
            data: [
                { id: 1, nombre: 'Reglamentos', icono: 'fas fa-file-contract', color: '#007bff' },
                { id: 2, nombre: 'Actas', icono: 'fas fa-file-alt', color: '#28a745' },
                { id: 3, nombre: 'Noticias', icono: 'fas fa-newspaper', color: '#ffc107' }
            ]
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

// Ruta principal para documentos
router.get('/', async (req, res) => {
    try {
        const { limit = 10, offset = 0 } = req.query;
        
        res.json({
            success: true,
            data: [
                {
                    id: 1,
                    titulo: 'Reglamento de Convivencia',
                    descripcion: 'Normas básicas de convivencia en el condominio',
                    categoria_nombre: 'Reglamentos',
                    created_at: new Date().toISOString()
                },
                {
                    id: 2,
                    titulo: 'Acta Reunión Directorio',
                    descripcion: 'Acta de la última reunión del directorio',
                    categoria_nombre: 'Actas',
                    created_at: new Date().toISOString()
                }
            ],
            pagination: {
                total: 2,
                limit: parseInt(limit),
                offset: parseInt(offset),
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
