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

module.exports = router;onst express = require('express');
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

        const result = await db.query(`
            SELECT 
                i.id,
                i.estado,
                i.comentarios,
                i.created_at,
                u.nombre as usuario_nombre,
                u.email as usuario_email,
                u.telefono as usuario_telefono
            FROM inscripciones_eventos i
            JOIN usuarios u ON i.usuario_id = u.id
            WHERE i.evento_id = $1
            ORDER BY i.created_at ASC
        `, [id]);

        res.json({
            success: true,
            data: result.rows
        });

    } catch (error) {
        console.error('Error obteniendo inscripciones:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

module.exports = router;
