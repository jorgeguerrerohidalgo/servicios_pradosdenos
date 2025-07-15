const express = require('express');
const router = express.Router();
const db = require('../utils/db');
const { authMiddleware, requireRole } = require('../middleware/auth');
const { apiLimiter } = require('../middleware/security');

// =============================================
// RUTAS PÚBLICAS - OBTENER EVENTOS
// =============================================

/**
 * GET /api/eventos
 * Obtiene eventos visibles para el público
 */
router.get('/', apiLimiter, async (req, res) => {
    try {
        const { 
            tipo = null, 
            destacados = false, 
            proximos = true,
            limit = 10,
            offset = 0 
        } = req.query;

        let query = `
            SELECT 
                e.id,
                e.titulo,
                e.descripcion,
                e.ubicacion,
                e.fecha_inicio,
                e.fecha_fin,
                e.link_google_cal,
                e.link_reunion,
                e.destacado,
                e.max_participantes,
                e.requiere_inscripcion,
                e.created_at,
                te.nombre as tipo_nombre,
                te.icono as tipo_icono,
                te.color as tipo_color,
                u.nombre as creado_por_nombre,
                COALESCE(
                    (SELECT COUNT(*) FROM inscripciones_eventos ie WHERE ie.evento_id = e.id AND ie.estado = 'confirmado'),
                    0
                ) as total_inscripciones
            FROM eventos_vecinales e
            JOIN tipo_evento te ON e.tipo_evento_id = te.id
            LEFT JOIN usuarios u ON e.creado_por = u.id
            WHERE e.visible = TRUE
        `;

        const params = [];
        let paramIndex = 1;

        // Filtros
        if (tipo) {
            query += ` AND te.nombre = $${paramIndex}`;
            params.push(tipo);
            paramIndex++;
        }

        if (destacados === 'true') {
            query += ` AND e.destacado = TRUE`;
        }

        if (proximos === 'true') {
            query += ` AND e.fecha_inicio >= NOW()`;
        }

        // Ordenamiento
        query += ` ORDER BY e.destacado DESC, e.fecha_inicio ASC`;

        // Paginación
        query += ` LIMIT $${paramIndex} OFFSET $${paramIndex + 1}`;
        params.push(parseInt(limit), parseInt(offset));

        const result = await db.query(query, params);

        // Obtener total de eventos para paginación
        let countQuery = `
            SELECT COUNT(*) as total
            FROM eventos_vecinales e
            JOIN tipo_evento te ON e.tipo_evento_id = te.id
            WHERE e.visible = TRUE
        `;
        
        const countParams = [];
        let countParamIndex = 1;
        
        if (tipo) {
            countQuery += ` AND te.nombre = $${countParamIndex}`;
            countParams.push(tipo);
            countParamIndex++;
        }
        
        if (destacados === 'true') {
            countQuery += ` AND e.destacado = TRUE`;
        }
        
        if (proximos === 'true') {
            countQuery += ` AND e.fecha_inicio >= NOW()`;
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
        console.error('Error obteniendo eventos:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

/**
 * GET /api/eventos/tipos
 * Obtiene los tipos de eventos disponibles
 */
router.get('/tipos', apiLimiter, async (req, res) => {
    try {
        const result = await db.query(`
            SELECT id, nombre, descripcion, icono, color, orden
            FROM tipo_evento 
            WHERE activo = TRUE 
            ORDER BY orden ASC, nombre ASC
        `);

        res.json({
            success: true,
            data: result.rows
        });

    } catch (error) {
        console.error('Error obteniendo tipos de eventos:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

/**
 * GET /api/eventos/:id
 * Obtiene un evento específico
 */
router.get('/:id', apiLimiter, async (req, res) => {
    try {
        const { id } = req.params;

        const result = await db.query(`
            SELECT 
                e.id,
                e.titulo,
                e.descripcion,
                e.ubicacion,
                e.fecha_inicio,
                e.fecha_fin,
                e.link_google_cal,
                e.link_reunion,
                e.destacado,
                e.max_participantes,
                e.requiere_inscripcion,
                e.created_at,
                te.nombre as tipo_nombre,
                te.icono as tipo_icono,
                te.color as tipo_color,
                u.nombre as creado_por_nombre,
                COALESCE(
                    (SELECT COUNT(*) FROM inscripciones_eventos ie WHERE ie.evento_id = e.id AND ie.estado = 'confirmado'),
                    0
                ) as total_inscripciones
            FROM eventos_vecinales e
            JOIN tipo_evento te ON e.tipo_evento_id = te.id
            LEFT JOIN usuarios u ON e.creado_por = u.id
            WHERE e.id = $1 AND e.visible = TRUE
        `, [id]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Evento no encontrado'
            });
        }

        res.json({
            success: true,
            data: result.rows[0]
        });

    } catch (error) {
        console.error('Error obteniendo evento:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

// =============================================
// RUTAS AUTENTICADAS - INSCRIPCIONES
// =============================================

/**
 * POST /api/eventos/:id/inscribir
 * Inscribe al usuario autenticado en un evento
 */
router.post('/:id/inscribir', authMiddleware, apiLimiter, async (req, res) => {
    try {
        const { id } = req.params;
        const { comentarios = null } = req.body;
        const userId = req.user.id;

        // Verificar que el evento existe y requiere inscripción
        const eventoResult = await db.query(`
            SELECT id, titulo, max_participantes, requiere_inscripcion, fecha_inicio
            FROM eventos_vecinales 
            WHERE id = $1 AND visible = TRUE
        `, [id]);

        if (eventoResult.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Evento no encontrado'
            });
        }

        const evento = eventoResult.rows[0];

        if (!evento.requiere_inscripcion) {
            return res.status(400).json({
                success: false,
                message: 'Este evento no requiere inscripción'
            });
        }

        // Verificar si el evento ya pasó
        if (new Date(evento.fecha_inicio) < new Date()) {
            return res.status(400).json({
                success: false,
                message: 'No se puede inscribir a un evento que ya ha comenzado'
            });
        }

        // Verificar si ya está inscrito
        const inscripcionExistente = await db.query(`
            SELECT id FROM inscripciones_eventos 
            WHERE evento_id = $1 AND usuario_id = $2
        `, [id, userId]);

        if (inscripcionExistente.rows.length > 0) {
            return res.status(400).json({
                success: false,
                message: 'Ya estás inscrito en este evento'
            });
        }

        // Verificar cupo disponible
        if (evento.max_participantes) {
            const inscritosResult = await db.query(`
                SELECT COUNT(*) as total
                FROM inscripciones_eventos 
                WHERE evento_id = $1 AND estado = 'confirmado'
            `, [id]);

            const totalInscritos = parseInt(inscritosResult.rows[0].total);
            
            if (totalInscritos >= evento.max_participantes) {
                return res.status(400).json({
                    success: false,
                    message: 'No hay cupos disponibles para este evento'
                });
            }
        }

        // Crear inscripción
        const inscripcionResult = await db.query(`
            INSERT INTO inscripciones_eventos (evento_id, usuario_id, comentarios)
            VALUES ($1, $2, $3)
            RETURNING id
        `, [id, userId, comentarios]);

        res.json({
            success: true,
            message: 'Inscripción realizada exitosamente',
            data: {
                inscripcion_id: inscripcionResult.rows[0].id
            }
        });

    } catch (error) {
        console.error('Error inscribiendo usuario:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

/**
 * DELETE /api/eventos/:id/inscribir
 * Cancela la inscripción del usuario autenticado
 */
router.delete('/:id/inscribir', authMiddleware, apiLimiter, async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.user.id;

        const result = await db.query(`
            UPDATE inscripciones_eventos 
            SET estado = 'cancelado', updated_at = NOW()
            WHERE evento_id = $1 AND usuario_id = $2 AND estado = 'confirmado'
            RETURNING id
        `, [id, userId]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'No se encontró una inscripción activa para este evento'
            });
        }

        res.json({
            success: true,
            message: 'Inscripción cancelada exitosamente'
        });

    } catch (error) {
        console.error('Error cancelando inscripción:', error);
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
 * POST /api/eventos
 * Crea un nuevo evento (solo administradores)
 */
router.post('/', authMiddleware, requireRole('admin'), apiLimiter, async (req, res) => {
    try {
        const {
            titulo,
            descripcion,
            ubicacion,
            fecha_inicio,
            fecha_fin,
            tipo_evento_id,
            link_reunion,
            max_participantes,
            requiere_inscripcion = false,
            visible = true,
            destacado = false
        } = req.body;

        // Validaciones
        if (!titulo || !fecha_inicio || !fecha_fin || !tipo_evento_id) {
            return res.status(400).json({
                success: false,
                message: 'Faltan campos obligatorios'
            });
        }

        if (new Date(fecha_fin) <= new Date(fecha_inicio)) {
            return res.status(400).json({
                success: false,
                message: 'La fecha de fin debe ser posterior a la fecha de inicio'
            });
        }

        // Generar enlace de Google Calendar
        const link_google_cal = `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${encodeURIComponent(titulo)}&dates=${fecha_inicio.replace(/[-:]/g, '').split('.')[0]}Z/${fecha_fin.replace(/[-:]/g, '').split('.')[0]}Z&details=${encodeURIComponent(descripcion || '')}&location=${encodeURIComponent(ubicacion || '')}`;

        const result = await db.query(`
            INSERT INTO eventos_vecinales (
                titulo, descripcion, ubicacion, fecha_inicio, fecha_fin, 
                tipo_evento_id, link_google_cal, link_reunion, max_participantes, 
                requiere_inscripcion, visible, destacado, creado_por
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
            RETURNING id
        `, [
            titulo, descripcion, ubicacion, fecha_inicio, fecha_fin,
            tipo_evento_id, link_google_cal, link_reunion, max_participantes,
            requiere_inscripcion, visible, destacado, req.user.id
        ]);

        res.json({
            success: true,
            message: 'Evento creado exitosamente',
            data: {
                evento_id: result.rows[0].id
            }
        });

    } catch (error) {
        console.error('Error creando evento:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

/**
 * PUT /api/eventos/:id
 * Actualiza un evento existente (solo administradores)
 */
router.put('/:id', authMiddleware, requireRole('admin'), apiLimiter, async (req, res) => {
    try {
        const { id } = req.params;
        const {
            titulo,
            descripcion,
            ubicacion,
            fecha_inicio,
            fecha_fin,
            tipo_evento_id,
            link_reunion,
            max_participantes,
            requiere_inscripcion,
            visible,
            destacado
        } = req.body;

        // Validar que el evento existe
        const eventoExistente = await db.query(`
            SELECT id FROM eventos_vecinales WHERE id = $1
        `, [id]);

        if (eventoExistente.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Evento no encontrado'
            });
        }

        // Validar fechas si se proporcionan
        if (fecha_inicio && fecha_fin && new Date(fecha_fin) <= new Date(fecha_inicio)) {
            return res.status(400).json({
                success: false,
                message: 'La fecha de fin debe ser posterior a la fecha de inicio'
            });
        }

        // Construir query de actualización dinámico
        const updates = [];
        const params = [];
        let paramIndex = 1;

        const fields = {
            titulo, descripcion, ubicacion, fecha_inicio, fecha_fin,
            tipo_evento_id, link_reunion, max_participantes,
            requiere_inscripcion, visible, destacado
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

        // Actualizar link de Google Calendar si se modifican fechas o título
        if (titulo || fecha_inicio || fecha_fin) {
            const eventoActual = await db.query(`
                SELECT titulo, descripcion, ubicacion, fecha_inicio, fecha_fin
                FROM eventos_vecinales WHERE id = $1
            `, [id]);

            const evento = eventoActual.rows[0];
            const nuevoTitulo = titulo || evento.titulo;
            const nuevaDescripcion = descripcion || evento.descripcion;
            const nuevaUbicacion = ubicacion || evento.ubicacion;
            const nuevaFechaInicio = fecha_inicio || evento.fecha_inicio;
            const nuevaFechaFin = fecha_fin || evento.fecha_fin;

            const link_google_cal = `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${encodeURIComponent(nuevoTitulo)}&dates=${nuevaFechaInicio.toISOString().replace(/[-:]/g, '').split('.')[0]}Z/${nuevaFechaFin.toISOString().replace(/[-:]/g, '').split('.')[0]}Z&details=${encodeURIComponent(nuevaDescripcion || '')}&location=${encodeURIComponent(nuevaUbicacion || '')}`;

            updates.push(`link_google_cal = $${paramIndex}`);
            params.push(link_google_cal);
            paramIndex++;
        }

        // Agregar campos de auditoría
        updates.push(`modificado_por = $${paramIndex}`);
        params.push(req.user.id);
        paramIndex++;

        params.push(id);

        const query = `
            UPDATE eventos_vecinales 
            SET ${updates.join(', ')} 
            WHERE id = $${paramIndex}
            RETURNING id
        `;

        await db.query(query, params);

        res.json({
            success: true,
            message: 'Evento actualizado exitosamente'
        });

    } catch (error) {
        console.error('Error actualizando evento:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

/**
 * DELETE /api/eventos/:id
 * Elimina un evento (solo administradores)
 */
router.delete('/:id', authMiddleware, requireRole('admin'), apiLimiter, async (req, res) => {
    try {
        const { id } = req.params;

        const result = await db.query(`
            DELETE FROM eventos_vecinales 
            WHERE id = $1
            RETURNING id
        `, [id]);

        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Evento no encontrado'
            });
        }

        res.json({
            success: true,
            message: 'Evento eliminado exitosamente'
        });

    } catch (error) {
        console.error('Error eliminando evento:', error);
        res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
});

/**
 * GET /api/eventos/:id/inscripciones
 * Obtiene las inscripciones de un evento (solo administradores)
 */
router.get('/:id/inscripciones', authMiddleware, requireRole('admin'), apiLimiter, async (req, res) => {
    try {
        const { id } = req.params;

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
