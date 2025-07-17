// Archivo temporal para probar que las correcciones funcionen
const express = require('express');
const router = express.Router();
const db = require('../utils/db');

// Endpoint simple para documentos
router.get('/', async (req, res) => {
    try {
        console.log('Obteniendo documentos...');
        const result = await db.query('SELECT COUNT(*) as count FROM documentos_comunitarios');
        
        console.log('Resultado de la consulta:', result);
        
        // Verificar que result es un array
        if (!Array.isArray(result)) {
            throw new Error('db.query no devolvió un array');
        }
        
        const count = result[0].count;
        console.log('Total de documentos:', count);
        
        res.json({
            success: true,
            data: { count: count },
            message: 'Documentos obtenidos exitosamente'
        });
    } catch (error) {
        console.error('Error en documentos:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});

module.exports = router;
