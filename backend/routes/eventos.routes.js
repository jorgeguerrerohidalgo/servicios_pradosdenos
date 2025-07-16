const express = require('express');
const router = express.Router();
const db = require('../utils/db');

// Ruta para obtener eventos con paginación
router.get('/', async (req, res) => {
    try {
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 10;
        const offset = (page - 1) * limit;
        
        // Por ahora devolvemos datos vacíos pero con el formato correcto
        const result = {
            success: true,
            data: [],
            pagination: {
                total: 0,
                page: page,
                limit: limit,
                totalPages: 0
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
        
        res.json({
            success: true,
            data: null,
            message: 'Evento no encontrado'
        });
    } catch (error) {
        console.error('Error en evento específico:', error);
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

module.exports = router;
