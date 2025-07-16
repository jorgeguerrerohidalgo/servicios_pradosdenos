const express = require('express');
const router = express.Router();
const db = require('../utils/db');

// Ruta simple para documentos
router.get('/', async (req, res) => {
    try {
        res.json({
            success: true,
            data: [],
            message: 'Documentos endpoint funcionando'
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
            message: 'Documento endpoint funcionando'
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

// Ruta simple para documentos
router.get('/', async (req, res) => {
    try {
        res.json({
            success: true,
            data: [],
            message: 'Documentos endpoint funcionando'
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
            message: 'Documento endpoint funcionando'
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            error: 'Error interno del servidor'
        });
    }
});

module.exports = router;
            limit = 10,
            offset = 0 
        } = req.query;

        let query = `
            SELECT 
                d.id,
                d.titulo,
                d.descripcion,
                d.tipo_documento,
                d.link_drive,
                d.importante,
                d.fecha_documento,
                d.created_at,
                cd.nombre as categoria_nombre,
                cd.icono as categoria_icono,
                cd.color as categoria_color,
                u.nombre as creado_por_nombre
            FROM documentos_comunitarios d
            JOIN categoria_documento cd ON d.categoria_id = cd.id
            LEFT JOIN usuarios u ON d.creado_por = u.id
            WHERE d.visible = TRUE
        `;

        const params = [];
        let paramIndex = 1;

        // Filtros
        if (categoria) {
            query += ` AND cd.nombre = $${paramIndex}`;
            params.push(categoria);
            paramIndex++;
        }

        if (importante === 'true') {
            query += ` AND d.importante = TRUE`;
        }

        if (buscar) {
            query += ` AND (
                d.titulo ILIKE $${paramIndex} OR 
                d.descripcion ILIKE $${paramIndex} OR
                cd.nombre ILIKE $${paramIndex}
            )`;
            params.push(`%${buscar}%`);
            paramIndex++;
        }

        // Ordenamiento
        query += ` ORDER BY d.importante DESC, d.fecha_documento DESC, d.created_at DESC`;

        // Paginación
        query += ` LIMIT $${paramIndex} OFFSET $${paramIndex + 1}`;
        params.push(parseInt(limit), parseInt(offset));

        const result = await db.query(query, params);

        // Obtener total de documentos para paginación
        let countQuery = `
            SELECT COUNT(*) as total
            FROM documentos_comunitarios d
            JOIN categoria_documento cd ON d.categoria_id = cd.id
            WHERE d.visible = TRUE
        `;
        
        const countParams = [];
        let countParamIndex = 1;
        
        if (categoria) {
            countQuery += ` AND cd.nombre = $${countParamIndex}`;
            countParams.push(categoria);
            countParamIndex++;
        }
        
        if (importante === 'true') {
            countQuery += ` AND d.importante = TRUE`;
        }
        
        if (buscar) {
            countQuery += ` AND (
                d.titulo ILIKE $${countParamIndex} OR 
                d.descripcion ILIKE $${countParamIndex} OR
                cd.nombre ILIKE $${countParamIndex}
            )`;
            countParams.push(`%${buscar}%`);
            countParamIndex++;
        }

        const countResult = await db.query(countQuery, countParams);
        const total = parseInt(countResult.rows[0].total);

        res.json({
            success: true,
            data: result.rows,
            pagination: {
                total,
                limit: parseInt(limit),
                offset: parseInt(offset),
                hasMore: (parseInt(offset) + parseInt(limit)) < total
            }
        });

    } catch (error) {
        console.error('Error obteniendo documentos:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

/**
 * GET /api/documentos/categorias
 * Obtiene las categorías de documentos disponibles
 */
router.get('/categorias', apiLimiter, async (req, res) => {
    try {
        const result = await db.query(`
            SELECT 
                cd.id, 
                cd.nombre, 
                cd.descripcion, 
                cd.icono, 
                cd.color, 
                cd.orden,
                COUNT(d.id) as total_documentos
            FROM categoria_documento cd
            LEFT JOIN documentos_comunitarios d ON cd.id = d.categoria_id AND d.visible = TRUE
            WHERE cd.activo = TRUE 
            GROUP BY cd.id, cd.nombre, cd.descripcion, cd.icono, cd.color, cd.orden
            ORDER BY cd.orden ASC, cd.nombre ASC
        `);

        res.json({
            success: true,
            data: result.rows
        });

    } catch (error) {
        console.error('Error obteniendo categorías:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

/**
 * GET /api/documentos/:id
 * Obtiene un documento específico
 */
router.get('/:id', apiLimiter, async (req, res) => {
    try {
        const { id } = req.params;

        const result = await db.query(`
            SELECT 
                d.id,
                d.titulo,
                d.descripcion,
                d.tipo_documento,
                d.link_drive,
                d.importante,
                d.fecha_documento,
                d.created_at,
                cd.nombre as categoria_nombre,
                cd.icono as categoria_icono,
                cd.color as categoria_color,
                u.nombre as creado_por_nombre
            FROM documentos_comunitarios d
            JOIN categoria_documento cd ON d.categoria_id = cd.id
            LEFT JOIN usuarios u ON d.creado_por = u.id
            WHERE d.id = $1 AND d.visible = TRUE
        `, [id]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Documento no encontrado'
            });
        }

        // Registrar visualización del documento
        await db.query(`
            INSERT INTO documento_visualizaciones (documento_id, ip_address, user_agent)
            VALUES ($1, $2, $3)
            ON CONFLICT (documento_id, ip_address) DO UPDATE SET
                contador = documento_visualizaciones.contador + 1,
                ultima_visita = NOW()
        `, [id, req.ip, req.get('User-Agent') || 'unknown']);

        res.json({
            success: true,
            data: result.rows[0]
        });

    } catch (error) {
        console.error('Error obteniendo documento:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

/**
 * GET /api/documentos/:id/estadisticas
 * Obtiene estadísticas básicas de un documento
 */
router.get('/:id/estadisticas', apiLimiter, async (req, res) => {
    try {
        const { id } = req.params;

        // Verificar que el documento existe y es visible
        const documentoResult = await db.query(`
            SELECT id FROM documentos_comunitarios 
            WHERE id = $1 AND visible = TRUE
        `, [id]);

        if (documentoResult.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Documento no encontrado'
            });
        }

        // Obtener estadísticas
        const estadisticasResult = await db.query(`
            SELECT 
                COALESCE(SUM(contador), 0) as total_visualizaciones,
                COUNT(DISTINCT ip_address) as visitantes_unicos,
                MAX(ultima_visita) as ultima_visualizacion
            FROM documento_visualizaciones 
            WHERE documento_id = $1
        `, [id]);

        const estadisticas = estadisticasResult.rows[0];

        res.json({
            success: true,
            data: {
                total_visualizaciones: parseInt(estadisticas.total_visualizaciones),
                visitantes_unicos: parseInt(estadisticas.visitantes_unicos),
                ultima_visualizacion: estadisticas.ultima_visualizacion
            }
        });

    } catch (error) {
        console.error('Error obteniendo estadísticas:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

// =============================================
// RUTAS ADMINISTRATIVAS
// =============================================

/**
 * POST /api/documentos
 * Crea un nuevo documento (solo administradores)
 */
router.post('/', authMiddleware, requireRole('admin'), apiLimiter, async (req, res) => {
    try {
        const {
            titulo,
            descripcion,
            tipo_documento,
            link_drive,
            categoria_id,
            fecha_documento,
            importante = false,
            visible = true
        } = req.body;

        // Validaciones
        if (!titulo || !link_drive || !categoria_id) {
            return res.status(400).json({
                success: false,
                message: 'Faltan campos obligatorios: título, enlace y categoría'
            });
        }

        // Validar que la categoría existe
        const categoriaResult = await db.query(`
            SELECT id FROM categoria_documento 
            WHERE id = $1 AND activo = TRUE
        `, [categoria_id]);

        if (categoriaResult.rows.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'La categoría especificada no existe o no está activa'
            });
        }

        // Validar URL de Google Drive
        const driveUrlPattern = /^https:\/\/drive\.google\.com/;
        if (!driveUrlPattern.test(link_drive)) {
            return res.status(400).json({
                success: false,
                message: 'El enlace debe ser una URL válida de Google Drive'
            });
        }

        const result = await db.query(`
            INSERT INTO documentos_comunitarios (
                titulo, descripcion, tipo_documento, link_drive, categoria_id,
                fecha_documento, importante, visible, creado_por
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
            RETURNING id
        `, [
            titulo, descripcion, tipo_documento, link_drive, categoria_id,
            fecha_documento, importante, visible, req.user.id
        ]);

        res.json({
            success: true,
            message: 'Documento creado exitosamente',
            data: {
                documento_id: result.rows[0].id
            }
        });

    } catch (error) {
        console.error('Error creando documento:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

/**
 * PUT /api/documentos/:id
 * Actualiza un documento existente (solo administradores)
 */
router.put('/:id', authMiddleware, requireRole('admin'), apiLimiter, async (req, res) => {
    try {
        const { id } = req.params;
        const {
            titulo,
            descripcion,
            tipo_documento,
            link_drive,
            categoria_id,
            fecha_documento,
            importante,
            visible
        } = req.body;

        // Validar que el documento existe
        const documentoExistente = await db.query(`
            SELECT id FROM documentos_comunitarios WHERE id = $1
        `, [id]);

        if (documentoExistente.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Documento no encontrado'
            });
        }

        // Validar categoría si se proporciona
        if (categoria_id) {
            const categoriaResult = await db.query(`
                SELECT id FROM categoria_documento 
                WHERE id = $1 AND activo = TRUE
            `, [categoria_id]);

            if (categoriaResult.rows.length === 0) {
                return res.status(400).json({
                    success: false,
                    message: 'La categoría especificada no existe o no está activa'
                });
            }
        }

        // Validar URL de Google Drive si se proporciona
        if (link_drive) {
            const driveUrlPattern = /^https:\/\/drive\.google\.com/;
            if (!driveUrlPattern.test(link_drive)) {
                return res.status(400).json({
                    success: false,
                    message: 'El enlace debe ser una URL válida de Google Drive'
                });
            }
        }

        // Construir query de actualización dinámico
        const updates = [];
        const params = [];
        let paramIndex = 1;

        const fields = {
            titulo, descripcion, tipo_documento, link_drive, categoria_id,
            fecha_documento, importante, visible
        };

        Object.entries(fields).forEach(([key, value]) => {
            if (value !== undefined) {
                updates.push(`${key} = $${paramIndex}`);
                params.push(value);
                paramIndex++;
            }
        });

        if (updates.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'No se proporcionaron campos para actualizar'
            });
        }

        // Agregar campos de auditoría
        updates.push(`modificado_por = $${paramIndex}`);
        params.push(req.user.id);
        paramIndex++;

        params.push(id);

        const query = `
            UPDATE documentos_comunitarios 
            SET ${updates.join(', ')} 
            WHERE id = $${paramIndex}
            RETURNING id
        `;

        await db.query(query, params);

        res.json({
            success: true,
            message: 'Documento actualizado exitosamente'
        });

    } catch (error) {
        console.error('Error actualizando documento:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

/**
 * DELETE /api/documentos/:id
 * Elimina un documento (solo administradores)
 */
router.delete('/:id', authMiddleware, requireRole('admin'), apiLimiter, async (req, res) => {
    try {
        const { id } = req.params;

        const result = await db.query(`
            DELETE FROM documentos_comunitarios 
            WHERE id = $1
            RETURNING id
        `, [id]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Documento no encontrado'
            });
        }

        res.json({
            success: true,
            message: 'Documento eliminado exitosamente'
        });

    } catch (error) {
        console.error('Error eliminando documento:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

/**
 * GET /api/documentos/admin/estadisticas
 * Obtiene estadísticas generales de documentos (solo administradores)
 */
router.get('/admin/estadisticas', authMiddleware, requireRole('admin'), apiLimiter, async (req, res) => {
    try {
        // Estadísticas generales
        const generalResult = await db.query(`
            SELECT 
                COUNT(*) as total_documentos,
                COUNT(CASE WHEN importante = TRUE THEN 1 END) as documentos_importantes,
                COUNT(CASE WHEN visible = TRUE THEN 1 END) as documentos_visibles,
                COUNT(CASE WHEN created_at >= NOW() - INTERVAL '30 days' THEN 1 END) as documentos_recientes
            FROM documentos_comunitarios
        `);

        // Estadísticas por categoría
        const categoriaResult = await db.query(`
            SELECT 
                cd.nombre as categoria,
                COUNT(d.id) as total_documentos,
                COALESCE(SUM(dv.contador), 0) as total_visualizaciones
            FROM categoria_documento cd
            LEFT JOIN documentos_comunitarios d ON cd.id = d.categoria_id
            LEFT JOIN documento_visualizaciones dv ON d.id = dv.documento_id
            WHERE cd.activo = TRUE
            GROUP BY cd.id, cd.nombre
            ORDER BY total_documentos DESC
        `);

        // Documentos más vistos
        const masVistosResult = await db.query(`
            SELECT 
                d.titulo,
                d.id,
                COALESCE(SUM(dv.contador), 0) as total_visualizaciones
            FROM documentos_comunitarios d
            LEFT JOIN documento_visualizaciones dv ON d.id = dv.documento_id
            WHERE d.visible = TRUE
            GROUP BY d.id, d.titulo
            ORDER BY total_visualizaciones DESC
            LIMIT 10
        `);

        res.json({
            success: true,
            data: {
                general: generalResult.rows[0],
                por_categoria: categoriaResult.rows,
                mas_vistos: masVistosResult.rows
            }
        });

    } catch (error) {
        console.error('Error obteniendo estadísticas:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

// =============================================
// RUTAS PARA GESTIÓN DE CATEGORÍAS
// =============================================

/**
 * POST /api/documentos/categorias
 * Crea una nueva categoría (solo administradores)
 */
router.post('/categorias', authMiddleware, requireRole('admin'), apiLimiter, async (req, res) => {
    try {
        const {
            nombre,
            descripcion,
            icono = 'fas fa-file',
            color = '#007bff',
            orden = 0
        } = req.body;

        if (!nombre) {
            return res.status(400).json({
                success: false,
                message: 'El nombre de la categoría es obligatorio'
            });
        }

        const result = await db.query(`
            INSERT INTO categoria_documento (nombre, descripcion, icono, color, orden)
            VALUES ($1, $2, $3, $4, $5)
            RETURNING id
        `, [nombre, descripcion, icono, color, orden]);

        res.json({
            success: true,
            message: 'Categoría creada exitosamente',
            data: {
                categoria_id: result.rows[0].id
            }
        });

    } catch (error) {
        console.error('Error creando categoría:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

/**
 * PUT /api/documentos/categorias/:id
 * Actualiza una categoría existente (solo administradores)
 */
router.put('/categorias/:id', authMiddleware, requireRole('admin'), apiLimiter, async (req, res) => {
    try {
        const { id } = req.params;
        const { nombre, descripcion, icono, color, orden, activo } = req.body;

        // Construir query de actualización dinámico
        const updates = [];
        const params = [];
        let paramIndex = 1;

        const fields = { nombre, descripcion, icono, color, orden, activo };

        Object.entries(fields).forEach(([key, value]) => {
            if (value !== undefined) {
                updates.push(`${key} = $${paramIndex}`);
                params.push(value);
                paramIndex++;
            }
        });

        if (updates.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'No se proporcionaron campos para actualizar'
            });
        }

        params.push(id);

        const query = `
            UPDATE categoria_documento 
            SET ${updates.join(', ')} 
            WHERE id = $${paramIndex}
            RETURNING id
        `;

        const result = await db.query(query, params);

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Categoría no encontrada'
            });
        }

        res.json({
            success: true,
            message: 'Categoría actualizada exitosamente'
        });

    } catch (error) {
        console.error('Error actualizando categoría:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

module.exports = router;
