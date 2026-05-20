/**
 * Vehicle Maintainers Routes
 * GET /api/vehiculos/tipos - Obtener todos los tipos de vehículos activos
 * GET /api/vehiculos/marcas - Obtener todas las marcas activas (opcional: filtrar por tipo)
 * GET /api/vehiculos/marcas/:id/modelos - Obtener modelos de una marca específica
 * GET /api/vehiculos/modelos/:id - Obtener detalles de un modelo específico
 * 
 * Estos endpoints son públicos (no requieren autenticación) para usarlos en formularios
 */

const express = require('express');
const router = express.Router();
const db = require('../../database/db');

/**
 * GET /api/vehiculos/tipos
 * Obtener todos los tipos de vehículos activos ordenados por orden
 */
router.get('/tipos', async (req, res) => {
    try {
        const result = await db.query(
            `SELECT id, nombre, descripcion, icono, orden 
             FROM tipo_vehiculo 
             WHERE activo = TRUE 
             ORDER BY orden ASC`
        );

        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
    } catch (error) {
        console.error('Error al obtener tipos de vehículos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener tipos de vehículos',
            error: error.message
        });
    }
});

/**
 * GET /api/vehiculos/marcas
 * Obtener todas las marcas activas
 * Query params opcionales:
 * - tipo_id: Filtrar modelos por tipo de vehículo (para precargar solo marcas relevantes)
 */
router.get('/marcas', async (req, res) => {
    try {
        const { tipo_id } = req.query;

        let query = `
            SELECT DISTINCT m.id, m.nombre, m.pais_origen
            FROM marca_vehiculo m
            WHERE m.activo = TRUE
        `;
        const params = [];

        // Si se proporciona tipo_id, filtrar marcas que tengan modelos de ese tipo
        if (tipo_id) {
            query += ` AND EXISTS (
                SELECT 1 FROM modelo_vehiculo mv 
                WHERE mv.marca_id = m.id 
                AND mv.tipo_vehiculo_id = $1 
                AND mv.activo = TRUE
            )`;
            params.push(tipo_id);
        }

        query += ` ORDER BY m.nombre ASC`;

        const result = await db.query(query, params);

        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length,
            filteredByTipo: !!tipo_id
        });
    } catch (error) {
        console.error('Error al obtener marcas de vehículos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener marcas de vehículos',
            error: error.message
        });
    }
});

/**
 * GET /api/vehiculos/marcas/:id/modelos
 * Obtener modelos activos de una marca específica
 * Query params opcionales:
 * - tipo_id: Filtrar modelos por tipo de vehículo
 */
router.get('/marcas/:id/modelos', async (req, res) => {
    try {
        const { id } = req.params;
        const { tipo_id } = req.query;

        let query = `
            SELECT 
                mv.id, 
                mv.nombre, 
                mv.anio_inicio, 
                mv.anio_fin,
                tv.nombre AS tipo_vehiculo,
                tv.id AS tipo_vehiculo_id
            FROM modelo_vehiculo mv
            LEFT JOIN tipo_vehiculo tv ON mv.tipo_vehiculo_id = tv.id
            WHERE mv.marca_id = $1 
            AND mv.activo = TRUE
        `;
        const params = [id];

        // Filtrar por tipo de vehículo si se proporciona
        if (tipo_id) {
            query += ` AND mv.tipo_vehiculo_id = $2`;
            params.push(tipo_id);
        }

        query += ` ORDER BY mv.nombre ASC`;

        const result = await db.query(query, params);

        // Obtener información de la marca
        const marcaResult = await db.query(
            'SELECT nombre, pais_origen FROM marca_vehiculo WHERE id = $1',
            [id]
        );

        if (marcaResult.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Marca no encontrada'
            });
        }

        res.json({
            success: true,
            marca: marcaResult.rows[0],
            data: result.rows,
            count: result.rows.length,
            filteredByTipo: !!tipo_id
        });
    } catch (error) {
        console.error('Error al obtener modelos de la marca:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener modelos de la marca',
            error: error.message
        });
    }
});

/**
 * GET /api/vehiculos/modelos/:id
 * Obtener detalles completos de un modelo específico
 */
router.get('/modelos/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const result = await db.query(
            `SELECT 
                mv.id,
                mv.nombre,
                mv.anio_inicio,
                mv.anio_fin,
                m.nombre AS marca,
                m.id AS marca_id,
                m.pais_origen,
                tv.nombre AS tipo_vehiculo,
                tv.id AS tipo_vehiculo_id,
                tv.icono AS tipo_icono
             FROM modelo_vehiculo mv
             JOIN marca_vehiculo m ON mv.marca_id = m.id
             LEFT JOIN tipo_vehiculo tv ON mv.tipo_vehiculo_id = tv.id
             WHERE mv.id = $1`,
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Modelo no encontrado'
            });
        }

        res.json({
            success: true,
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al obtener detalles del modelo:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener detalles del modelo',
            error: error.message
        });
    }
});

/**
 * GET /api/vehiculos/search-modelo
 * Búsqueda de modelos por nombre (autocomplete)
 * Query params:
 * - q: Término de búsqueda (mínimo 2 caracteres)
 * - marca_id: (opcional) Filtrar por marca
 * - tipo_id: (opcional) Filtrar por tipo
 */
router.get('/search-modelo', async (req, res) => {
    try {
        const { q, marca_id, tipo_id } = req.query;

        if (!q || q.length < 2) {
            return res.status(400).json({
                success: false,
                message: 'El término de búsqueda debe tener al menos 2 caracteres'
            });
        }

        let query = `
            SELECT 
                mv.id,
                mv.nombre,
                m.nombre AS marca,
                m.id AS marca_id,
                tv.nombre AS tipo_vehiculo
            FROM modelo_vehiculo mv
            JOIN marca_vehiculo m ON mv.marca_id = m.id
            LEFT JOIN tipo_vehiculo tv ON mv.tipo_vehiculo_id = tv.id
            WHERE mv.activo = TRUE
            AND mv.nombre ILIKE $1
        `;
        const params = [`%${q}%`];
        let paramIndex = 2;

        if (marca_id) {
            query += ` AND mv.marca_id = $${paramIndex}`;
            params.push(marca_id);
            paramIndex++;
        }

        if (tipo_id) {
            query += ` AND mv.tipo_vehiculo_id = $${paramIndex}`;
            params.push(tipo_id);
            paramIndex++;
        }

        query += ` ORDER BY m.nombre, mv.nombre LIMIT 20`;

        const result = await db.query(query, params);

        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
    } catch (error) {
        console.error('Error en búsqueda de modelos:', error);
        res.status(500).json({
            success: false,
            message: 'Error en búsqueda de modelos',
            error: error.message
        });
    }
});

module.exports = router;
