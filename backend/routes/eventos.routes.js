const express = require('express');
const router = express.Router();
const { query, pool } = require('../utils/db');
const { requireAuth, requireAdmin, requireAuthAdmin } = require('../middleware/sessionAuth');

// ==================== EVENTOS VECINALES ====================

// GET /api/eventos - Obtener todos los eventos (público)
router.get('/', async (req, res) => {
    try {
        const { tipo, destacado, visible = 'true', proximos } = req.query;
        
        let sql = `
            SELECT 
                e.id,
                e.titulo,
                e.descripcion,
                e.ubicacion,
                e.fecha_inicio,
                e.fecha_fin,
                e.link_google_cal,
                e.link_reunion,
                e.visible,
                e.destacado,
                e.max_participantes,
                e.requiere_inscripcion,
                e.created_at,
                e.updated_at,
                te.nombre as tipo_nombre,
                te.icono as tipo_icono,
                te.color as tipo_color,
                au.nombre as creado_por_nombre,
                (SELECT COUNT(*) FROM inscripciones_eventos WHERE evento_id = e.id AND estado = 'confirmado') as inscripciones_confirmadas
            FROM eventos_vecinales e
            LEFT JOIN tipo_evento te ON e.tipo_evento_id = te.id
            LEFT JOIN admin_users au ON e.creado_por = au.id
            WHERE e.visible = $1
        `;
        
        const params = [visible === 'true'];
        let paramCount = 1;
        
        if (tipo) {
            paramCount++;
            sql += ` AND e.tipo_evento_id = $${paramCount}`;
            params.push(tipo);
        }
        
        if (destacado !== undefined) {
            paramCount++;
            sql += ` AND e.destacado = $${paramCount}`;
            params.push(destacado === 'true');
        }
        
        if (proximos === 'true') {
            paramCount++;
            sql += ` AND e.fecha_inicio >= NOW()`;
        }
        
        // Ordenar por destacado primero, luego por fecha de inicio
        sql += ' ORDER BY e.destacado DESC, e.fecha_inicio ASC';
        
        const result = await pool.query(sql, params);
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error al obtener eventos:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// GET /api/eventos/tipos - Obtener tipos de evento
router.get('/tipos', async (req, res) => {
    try {
        let result = await pool.query(`
            SELECT id, nombre, descripcion, icono, color, orden
            FROM tipo_evento 
            WHERE activo = true 
            ORDER BY orden, nombre
        `);
        
        // Si no hay tipos, crear algunos básicos
        if (result.rows.length === 0) {
            console.log('No hay tipos de evento, creando tipos básicos...');
            
            const tiposBasicos = [
                { nombre: 'Reunión Comunitaria', descripcion: 'Reuniones generales de la comunidad', icono: 'fas fa-users', color: '#007bff', orden: 1 },
                { nombre: 'Actividad Social', descripcion: 'Eventos sociales y recreativos', icono: 'fas fa-calendar-day', color: '#28a745', orden: 2 },
                { nombre: 'Mantenimiento', descripcion: 'Actividades de mantenimiento comunitario', icono: 'fas fa-tools', color: '#ffc107', orden: 3 },
                { nombre: 'Emergencia', descripcion: 'Comunicados de emergencia', icono: 'fas fa-exclamation-triangle', color: '#dc3545', orden: 4 }
            ];
            
            for (const tipo of tiposBasicos) {
                await pool.query(`
                    INSERT INTO tipo_evento (nombre, descripcion, icono, color, orden, activo)
                    VALUES ($1, $2, $3, $4, $5, true)
                `, [tipo.nombre, tipo.descripcion, tipo.icono, tipo.color, tipo.orden]);
            }
            
            // Obtener los tipos recién creados
            result = await pool.query(`
                SELECT id, nombre, descripcion, icono, color, orden
                FROM tipo_evento 
                WHERE activo = true 
                ORDER BY orden, nombre
            `);
        }
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error al obtener tipos de evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// GET /api/eventos/:id - Obtener evento específico
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(`
            SELECT 
                e.*,
                te.nombre as tipo_nombre,
                te.icono as tipo_icono,
                te.color as tipo_color,
                au.nombre as creado_por_nombre,
                (SELECT COUNT(*) FROM inscripciones_eventos WHERE evento_id = e.id AND estado = 'confirmado') as inscripciones_confirmadas
            FROM eventos_vecinales e
            LEFT JOIN tipo_evento te ON e.tipo_evento_id = te.id
            LEFT JOIN admin_users au ON e.creado_por = au.id
            WHERE e.id = $1 AND e.visible = true
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
        console.error('Error al obtener evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// POST /api/eventos/inscribir/:id - Inscribirse a un evento (requiere autenticación)
router.post('/inscribir/:id', requireAuthAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        const { comentarios } = req.body;
        
        // Verificar que el evento existe y requiere inscripción
        const eventoResult = await pool.query(
            'SELECT id, requiere_inscripcion, max_participantes FROM eventos_vecinales WHERE id = $1 AND visible = true',
            [id]
        );
        
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
        
        // Verificar si ya está inscrito
        const inscripcionExistente = await pool.query(
            'SELECT id FROM inscripciones_eventos WHERE evento_id = $1 AND admin_user_id = $2',
            [id, req.user.id]
        );
        
        if (inscripcionExistente.rows.length > 0) {
            return res.status(400).json({
                success: false,
                message: 'Ya está inscrito en este evento'
            });
        }
        
        // Verificar límite de participantes
        if (evento.max_participantes) {
            const inscripcionesActuales = await pool.query(
                'SELECT COUNT(*) as total FROM inscripciones_eventos WHERE evento_id = $1 AND estado = $2',
                [id, 'confirmado']
            );
            
            if (parseInt(inscripcionesActuales.rows[0].total) >= evento.max_participantes) {
                return res.status(400).json({
                    success: false,
                    message: 'El evento ha alcanzado el límite máximo de participantes'
                });
            }
        }
        
        // Crear inscripción
        const result = await pool.query(`
            INSERT INTO inscripciones_eventos 
            (evento_id, admin_user_id, comentarios, estado)
            VALUES ($1, $2, $3, 'confirmado')
            RETURNING *
        `, [id, req.user.id, comentarios]);
        
        res.status(201).json({
            success: true,
            message: 'Inscripción realizada exitosamente',
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al inscribirse en evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// DELETE /api/eventos/desinscribir/:id - Cancelar inscripción a evento
router.delete('/desinscribir/:id', requireAuthAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(
            'DELETE FROM inscripciones_eventos WHERE evento_id = $1 AND admin_user_id = $2 RETURNING *',
            [id, req.user.id]
        );
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'No se encontró la inscripción'
            });
        }
        
        res.json({
            success: true,
            message: 'Inscripción cancelada exitosamente'
        });
    } catch (error) {
        console.error('Error al cancelar inscripción:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// ==================== RUTAS ADMINISTRATIVAS ====================

// GET /api/eventos/admin/all - Obtener todos los eventos (admin)
router.get('/admin/all', requireAuthAdmin, async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT 
                e.id,
                e.titulo,
                e.descripcion,
                e.ubicacion,
                e.fecha_inicio,
                e.fecha_fin,
                e.link_google_cal,
                e.link_reunion,
                e.visible,
                e.destacado,
                e.max_participantes,
                e.requiere_inscripcion,
                e.created_at,
                e.updated_at,
                te.nombre as tipo_nombre,
                te.icono as tipo_icono,
                te.color as tipo_color,
                au.nombre as creado_por_nombre,
                (SELECT COUNT(*) FROM inscripciones_eventos WHERE evento_id = e.id AND estado = 'confirmado') as inscripciones_confirmadas
            FROM eventos_vecinales e
            LEFT JOIN tipo_evento te ON e.tipo_evento_id = te.id
            LEFT JOIN admin_users au ON e.creado_por = au.id
            ORDER BY e.created_at DESC
        `);
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error al obtener eventos (admin):', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// GET /api/eventos/admin/:id - Obtener evento por ID (admin)
router.get('/admin/:id', requireAuthAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(`
            SELECT 
                e.id,
                e.titulo,
                e.descripcion,
                e.ubicacion,
                e.fecha_inicio,
                e.fecha_fin,
                e.tipo_evento_id,
                e.link_google_cal,
                e.link_reunion,
                e.visible,
                e.destacado,
                e.max_participantes,
                e.requiere_inscripcion,
                e.created_at,
                e.updated_at,
                te.nombre as tipo_nombre,
                te.icono as tipo_icono,
                te.color as tipo_color,
                au.nombre as creado_por_nombre,
                (SELECT COUNT(*) FROM inscripciones_eventos WHERE evento_id = e.id AND estado = 'confirmado') as inscripciones_confirmadas
            FROM eventos_vecinales e
            LEFT JOIN tipo_evento te ON e.tipo_evento_id = te.id
            LEFT JOIN admin_users au ON e.creado_por = au.id
            WHERE e.id = $1
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
        console.error('Error al obtener evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// POST /api/eventos/admin - Crear evento (admin)
router.post('/admin', requireAuthAdmin, async (req, res) => {
    try {
        console.log('🎯 Creando evento - Datos recibidos:', req.body);
        console.log('🎯 Usuario en sesión:', req.user);
        
        const {
            titulo,
            descripcion,
            ubicacion,
            fecha_inicio,
            fecha_fin,
            tipo_evento_id,
            link_google_cal,
            link_reunion,
            visible,
            destacado,
            max_participantes,
            requiere_inscripcion
        } = req.body;

        console.log('🎯 Campos extraídos:', {
            titulo,
            tipo_evento_id,
            visible,
            destacado,
            requiere_inscripcion
        });

        // Validar campos requeridos
        if (!titulo || !tipo_evento_id) {
            console.log('❌ Faltan campos requeridos:', { titulo, tipo_evento_id });
            return res.status(400).json({
                success: false,
                message: 'Título y tipo de evento son requeridos'
            });
        }

        // Validar UUID del tipo de evento
        if (!tipo_evento_id || tipo_evento_id.trim() === '' || tipo_evento_id === 'undefined') {
            console.log('❌ Tipo de evento inválido:', tipo_evento_id);
            return res.status(400).json({
                success: false,
                message: 'Debe seleccionar un tipo de evento válido'
            });
        }

        // Verificar que el tipo de evento existe
        console.log('🔍 Verificando tipo de evento:', tipo_evento_id);
        const tipoExiste = await pool.query(
            'SELECT id FROM tipo_evento WHERE id = $1 AND activo = true',
            [tipo_evento_id]
        );
        
        if (tipoExiste.rows.length === 0) {
            console.log('❌ Tipo de evento no encontrado:', tipo_evento_id);
            return res.status(400).json({
                success: false,
                message: 'El tipo de evento seleccionado no existe'
            });
        }

        // Validar que el usuario esté en sesión
        if (!req.user?.id) {
            console.log('❌ Usuario no válido:', req.user);
            return res.status(401).json({
                success: false,
                message: 'Usuario no válido'
            });
        }

        console.log('✅ Validaciones pasadas, insertando en BD...');
        
        const result = await pool.query(`
            INSERT INTO eventos_vecinales 
            (titulo, descripcion, ubicacion, fecha_inicio, fecha_fin, 
             tipo_evento_id, link_google_cal, link_reunion, visible, 
             destacado, max_participantes, requiere_inscripcion, creado_por)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
            RETURNING *
        `, [
            titulo, descripcion, ubicacion, fecha_inicio, fecha_fin,
            tipo_evento_id, link_google_cal, link_reunion, visible,
            destacado, max_participantes, requiere_inscripcion, req.user.id
        ]);
        
        res.status(201).json({
            success: true,
            message: 'Evento creado exitosamente',
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al crear evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// PUT /api/eventos/admin/:id - Actualizar evento (admin)
router.put('/admin/:id', requireAuthAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        const {
            titulo,
            descripcion,
            ubicacion,
            fecha_inicio,
            fecha_fin,
            tipo_evento_id,
            link_google_cal,
            link_reunion,
            visible,
            destacado,
            max_participantes,
            requiere_inscripcion
        } = req.body;
        
        const result = await pool.query(`
            UPDATE eventos_vecinales 
            SET titulo = $1, descripcion = $2, ubicacion = $3, 
                fecha_inicio = $4, fecha_fin = $5, tipo_evento_id = $6,
                link_google_cal = $7, link_reunion = $8, visible = $9,
                destacado = $10, max_participantes = $11, 
                requiere_inscripcion = $12, modificado_por = $13, updated_at = NOW()
            WHERE id = $14
            RETURNING *
        `, [
            titulo, descripcion, ubicacion, fecha_inicio, fecha_fin,
            tipo_evento_id, link_google_cal, link_reunion, visible,
            destacado, max_participantes, requiere_inscripcion, req.user.id, id
        ]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Evento no encontrado'
            });
        }
        
        res.json({
            success: true,
            message: 'Evento actualizado exitosamente',
            data: result.rows[0]
        });
    } catch (error) {
        console.error('Error al actualizar evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// DELETE /api/eventos/admin/:id - Eliminar evento (admin)
router.delete('/admin/:id', requireAuthAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(
            'DELETE FROM eventos_vecinales WHERE id = $1 RETURNING *',
            [id]
        );
        
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
        console.error('Error al eliminar evento:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

// GET /api/eventos/admin/:id/inscripciones - Obtener inscripciones de un evento
router.get('/admin/:id/inscripciones', requireAuthAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(`
            SELECT 
                i.id,
                i.estado,
                i.comentarios,
                i.created_at,
                i.updated_at,
                au.nombre,
                au.apellido_paterno,
                au.apellido_materno,
                au.email,
                au.telefono
            FROM inscripciones_eventos i
            LEFT JOIN admin_users au ON i.admin_user_id = au.id
            WHERE i.evento_id = $1 
            ORDER BY i.created_at DESC
        `, [id]);
        
        res.json({
            success: true,
            data: result.rows
        });
    } catch (error) {
        console.error('Error al obtener inscripciones:', error);
        res.status(500).json({
            success: false,
            message: 'Error interno del servidor'
        });
    }
});

module.exports = router;
