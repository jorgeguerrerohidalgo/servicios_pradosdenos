// Archivo temporal para probar que las correcciones funcionen
const express = require('express');
const router = express.Router();
const db = require('../utils/db');

// Endpoint simple para eventos
router.get('/', async (req, res) => {
    try {
        console.log('Obteniendo eventos...');
        const result = await db.query('SELECT COUNT(*) as count FROM eventos_vecinales WHERE visible = true');
        
        console.log('Resultado de la consulta:', result);
        
        // Verificar que result es un array
        if (!Array.isArray(result)) {
            throw new Error('db.query no devolvió un array');
        }
        
        const count = result[0].count;
        console.log('Total de eventos:', count);
        
        res.json({
            success: true,
            data: { count: count },
            message: 'Eventos obtenidos exitosamente'
        });
    } catch (error) {
        console.error('Error en eventos:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});

module.exports = router;
