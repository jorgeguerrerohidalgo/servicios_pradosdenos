const express = require('express');
const router = express.Router();
const db = require('../utils/db');

// Ruta simple para eventos
router.get('/', async (req, res) => {
    try {
        res.json({
            success: true,
            data: [],
            message: 'Eventos endpoint funcionando'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

router.get('/:id', async (req, res) => {
    try {
        res.json({
            success: true,
            data: null,
            message: 'Evento endpoint funcionando'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

module.exports = router;
