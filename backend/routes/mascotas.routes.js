/**
 * RUTAS DE MASCOTAS
 * Gestión de mascotas particulares y comunitarias del condominio
 * Autor: Sistema
 * Fecha: 14/05/2026
 */

const express = require('express');
const router = express.Router();
const { pool } = require('../utils/db');
const { requireAuth, requireAuthAdmin } = require('../middleware/sessionAuth');
const { requirePermission } = require('../middleware/rbac');
const { applyScoping, buildPlazaFilter } = require('../middleware/applyScoping');

// ==================== ENDPOINT PÚBLICO ====================
/**
 * GET /api/mascotas/publico
 * ⚠️ SIN AUTENTICACIÓN - Vista pública para emergencias
 * Lista todas las mascotas activas con información NO SENSIBLE
 * Query params: tipo, plaza, buscar
 * Uso: Galería pública para identificación en emergencias (mascotas perdidas/encontradas)
 */
router.get('/publico', async (req, res) => {
    try {
        console.log('🐾 GET /api/mascotas/publico - Query params:', req.query);
        
        const { tipo, plaza, buscar } = req.query;
        
        let sql = `
            SELECT 
                m.id,
                m.nombre,
                m.tipo,
                COALESCE(m.raza, '') as raza,
                COALESCE(m.genero, '') as genero,
                COALESCE(m.color, '') as color,
                m.foto_url,
                COALESCE(m.observaciones, '') as observaciones,
                COALESCE(EXTRACT(YEAR FROM AGE(CURRENT_DATE, m.fecha_nacimiento))::INTEGER, 0) as edad_anos,
                p.nombre as plaza_nombre,
                COALESCE(p.direccion, '') as plaza_direccion,
                p.id as plaza_id,
                CASE 
                    WHEN m.fecha_ultima_vacuna IS NULL THEN 'sin_info'
                    WHEN (CURRENT_DATE - m.fecha_ultima_vacuna) > 365 THEN 'vencida'
                    ELSE 'al_dia'
                END as estado_vacunas
            FROM mascotas m
            INNER JOIN casas c ON m.casa_id = c.id
            INNER JOIN plazas p ON c.plaza_id = p.id
            WHERE m.activo = TRUE AND c.activo = TRUE AND p.activo = TRUE
        `;
        
        let params = [];
        let paramCount = 0;
        
        // Filtro por tipo de mascota
        if (tipo && tipo !== 'all') {
            paramCount++;
            sql += ` AND m.tipo = $${paramCount}`;
            params.push(tipo);
        }
        
        // Filtro por plaza
        if (plaza && plaza !== 'all') {
            paramCount++;
            sql += ` AND p.id = $${paramCount}`;
            params.push(parseInt(plaza));
        }
        
        // Búsqueda por nombre
        if (buscar) {
            paramCount++;
            sql += ` AND LOWER(m.nombre) LIKE LOWER($${paramCount})`;
            params.push(`%${buscar}%`);
        }
        
        sql += ' ORDER BY p.nombre, m.tipo, m.nombre';
        
        console.log('📊 Ejecutando query con', params.length, 'parámetros');
        
        const result = await pool.query(sql, params);
        
        console.log('✅ Mascotas públicas obtenidas:', result.rows.length);
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
        
    } catch (error) {
        console.error('❌ Error en endpoint público de mascotas:');
        console.error('   Mensaje:', error.message);
        console.error('   Stack:', error.stack);
        console.error('   Query params:', req.query);
        
        res.status(500).json({
            success: false,
            message: 'Error al cargar mascotas',
            error: process.env.NODE_ENV === 'development' ? error.message : 'Error interno'
        });
    }
});

// ==================== FIN ENDPOINT PÚBLICO ====================

// Aplicar middleware de autenticación a todas las rutas SIGUIENTES
router.use(requireAuth);

// ==================== GET: Listar mascotas ====================
/**
 * GET /api/mascotas
 * Lista todas las mascotas con filtros opcionales (con scoping automático)
 * Query params: casa_id, tipo, certificado_vacunas, activo, search
 */
router.get('/', requirePermission('mascotas.leer'), applyScoping, async (req, res) => {
    try {
        const { plaza_id, casa_id, tipo, certificado_vacunas, activo = 'true', search } = req.query;
        
        let query = 'SELECT * FROM v_mascotas_completo WHERE 1=1';
        let params = [];
        let paramCount = 0;
        
        // Filtro por casa (prioridad sobre plaza)
        if (casa_id) {
            paramCount++;
            query += ` AND casa_id = $${paramCount}`;
            params.push(parseInt(casa_id));
        } else if (plaza_id) {
            paramCount++;
            query += ` AND plaza_id = $${paramCount}`;
            params.push(parseInt(plaza_id));
        }
        
        // Filtro por tipo
        if (tipo && tipo !== 'all') {
            paramCount++;
            query += ` AND tipo = $${paramCount}`;
            params.push(tipo);
        }
        
        // Filtro por certificado de vacunas
        if (certificado_vacunas && certificado_vacunas !== 'all') {
            paramCount++;
            query += ` AND certificado_vacunas = $${paramCount}`;
            params.push(certificado_vacunas === 'true');
        }
        
        // Filtro por activo
        if (activo !== 'all') {
            paramCount++;
            query += ` AND activo = $${paramCount}`;
            params.push(activo === 'true');
        }
        
        // Búsqueda general
        if (search) {
            paramCount++;
            query += ` AND (
                LOWER(mascota_nombre) LIKE LOWER($${paramCount}) OR
                LOWER(dueno_nombre) LIKE LOWER($${paramCount}) OR
                LOWER(numero_casa) LIKE LOWER($${paramCount}) OR
                LOWER(raza) LIKE LOWER($${paramCount})
            )`;
            params.push(`%${search}%`);
        }
        
        // ⚡ SCOPING AUTOMÁTICO: Filtrar por plazas permitidas del usuario
        // Nota: v_mascotas_completo incluye plaza_id de la casa
        const plazaFilter = buildPlazaFilter(req.allowedPlazas, '', params);
        query += plazaFilter.sql;
        params = plazaFilter.params;
        
        query += ' ORDER BY numero_casa, mascota_nombre';
        
        const result = await pool.query(query, params);
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length,
            scoping: req.allowedPlazas === null ? 'global' : `plazas: ${req.allowedPlazas?.join(', ') || 'ninguna'}`
        });
        
    } catch (error) {
        console.error('Error al listar mascotas:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener mascotas',
            error: error.message
        });
    }
});

// ==================== GET: Lista simple para dropdowns ====================
/**
 * GET /api/mascotas/simple
 * Lista simplificada de mascotas activas para dropdowns
 */
router.get('/simple', async (req, res) => {
    try {
        const result = await pool.query(
            'SELECT id, nombre as mascota_nombre, tipo FROM mascotas WHERE activo = true ORDER BY nombre'
        );
        
        res.json({
            success: true,
            data: result.rows
        });
        
    } catch (error) {
        console.error('Error al obtener lista simple de mascotas:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener lista de mascotas',
            error: error.message
        });
    }
});

// ==================== GET: Mascotas por casa ====================
/**
 * GET /api/mascotas/casa/:casa_id
 * Obtiene todas las mascotas de una casa específica
 */
router.get('/casa/:casa_id', async (req, res) => {
    try {
        const { casa_id } = req.params;
        
        const result = await pool.query(
            'SELECT * FROM get_mascotas_por_casa($1)',
            [parseInt(casa_id)]
        );
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
        
    } catch (error) {
        console.error('Error al obtener mascotas por casa:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener mascotas de la casa',
            error: error.message
        });
    }
});

// ==================== GET: Estadísticas generales ====================
/**
 * GET /api/mascotas/estadisticas/general
 * Obtiene estadísticas generales de mascotas
 */
router.get('/estadisticas/general', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM get_estadisticas_mascotas()');
        
        res.json({
            success: true,
            data: result.rows[0] || {}
        });
        
    } catch (error) {
        console.error('Error al obtener estadísticas de mascotas:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener estadísticas',
            error: error.message
        });
    }
});

// ==================== GET: Vacunas vencidas ====================
/**
 * GET /api/mascotas/vacunas/vencidas
 * Obtiene mascotas con vacunas vencidas (más de 1 año)
 */
router.get('/vacunas/vencidas', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM get_mascotas_vacunas_vencidas()');
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
        
    } catch (error) {
        console.error('Error al obtener mascotas con vacunas vencidas:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener mascotas con vacunas vencidas',
            error: error.message
        });
    }
});

// ==================== GET: Obtener mascota por ID ====================
/**
 * GET /api/mascotas/:id
 * Obtiene una mascota específica por su ID
 */
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        
        const result = await pool.query(
            'SELECT * FROM v_mascotas_completo WHERE id = $1',
            [parseInt(id)]
        );
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Mascota no encontrada'
            });
        }
        
        res.json({
            success: true,
            data: result.rows[0]
        });
        
    } catch (error) {
        console.error('Error al obtener mascota:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener mascota',
            error: error.message
        });
    }
});

// ==================== POST: Crear mascota ====================
/**
 * POST /api/mascotas
 * Crea una nueva mascota
 */
router.post('/', requirePermission('mascotas.crear'), async (req, res) => {
    try {
        const { 
            casa_id, 
            residente_id, 
            nombre, 
            tipo, 
            raza, 
            fecha_nacimiento,
            genero,
            color,
            certificado_vacunas,
            fecha_ultima_vacuna,
            observaciones,
            foto_url
        } = req.body;
        
        // Validaciones
        if (!casa_id || !nombre || !tipo) {
            return res.status(400).json({
                success: false,
                message: 'Casa, nombre y tipo son obligatorios'
            });
        }
        
        // Validar tipo
        const tiposValidos = ['perro', 'gato', 'otro'];
        if (!tiposValidos.includes(tipo)) {
            return res.status(400).json({
                success: false,
                message: 'Tipo debe ser: perro, gato u otro'
            });
        }
        
        // Validar género si se proporciona
        if (genero) {
            const generosValidos = ['macho', 'hembra', 'desconocido'];
            if (!generosValidos.includes(genero)) {
                return res.status(400).json({
                    success: false,
                    message: 'Género debe ser: macho, hembra o desconocido'
                });
            }
        }
        
        // Verificar que la casa existe
        const casaCheck = await pool.query(
            'SELECT id FROM casas WHERE id = $1 AND activo = true',
            [casa_id]
        );
        
        if (casaCheck.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Casa no encontrada'
            });
        }
        
        // Si se proporciona residente_id, verificar que existe y pertenece a la casa
        if (residente_id) {
            const residenteCheck = await pool.query(
                'SELECT id FROM residentes WHERE id = $1 AND casa_id = $2 AND activo = true',
                [residente_id, casa_id]
            );
            
            if (residenteCheck.rows.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Residente no encontrado o no pertenece a la casa especificada'
                });
            }
        }
        
        // Insertar mascota
        const result = await pool.query(
            `INSERT INTO mascotas (
                casa_id, residente_id, nombre, tipo, raza, 
                fecha_nacimiento, genero, color, 
                certificado_vacunas, fecha_ultima_vacuna, observaciones, foto_url
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
            RETURNING *`,
            [
                casa_id,
                residente_id || null,
                nombre,
                tipo,
                raza || null,
                fecha_nacimiento || null,
                genero || null,
                color || null,
                certificado_vacunas || false,
                fecha_ultima_vacuna || null,
                observaciones || null,
                foto_url || null
            ]
        );
        
        res.status(201).json({
            success: true,
            message: 'Mascota creada correctamente',
            data: result.rows[0]
        });
        
    } catch (error) {
        console.error('Error al crear mascota:', error);
        res.status(500).json({
            success: false,
            message: 'Error al crear mascota',
            error: error.message
        });
    }
});

// ==================== PUT: Actualizar mascota ====================
/**
 * PUT /api/mascotas/:id
 * Actualiza una mascota existente
 */
router.put('/:id', requirePermission('mascotas.editar'), async (req, res) => {
    try {
        const { id } = req.params;
        const { 
            casa_id, 
            residente_id, 
            nombre, 
            tipo, 
            raza, 
            fecha_nacimiento,
            genero,
            color,
            certificado_vacunas,
            fecha_ultima_vacuna,
            observaciones,
            activo,
            foto_url
        } = req.body;
        
        // Verificar que la mascota existe
        const mascotaCheck = await pool.query(
            'SELECT id FROM mascotas WHERE id = $1',
            [id]
        );
        
        if (mascotaCheck.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Mascota no encontrada'
            });
        }
        
        // Validar tipo si se proporciona
        if (tipo) {
            const tiposValidos = ['perro', 'gato', 'otro'];
            if (!tiposValidos.includes(tipo)) {
                return res.status(400).json({
                    success: false,
                    message: 'Tipo debe ser: perro, gato u otro'
                });
            }
        }
        
        // Validar género si se proporciona
        if (genero) {
            const generosValidos = ['macho', 'hembra', 'desconocido'];
            if (!generosValidos.includes(genero)) {
                return res.status(400).json({
                    success: false,
                    message: 'Género debe ser: macho, hembra o desconocido'
                });
            }
        }
        
        // Verificar casa si se proporciona
        if (casa_id) {
            const casaCheck = await pool.query(
                'SELECT id FROM casas WHERE id = $1 AND activo = true',
                [casa_id]
            );
            
            if (casaCheck.rows.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Casa no encontrada'
                });
            }
        }
        
        // Verificar residente si se proporciona
        if (residente_id) {
            const residenteCheck = await pool.query(
                'SELECT id FROM residentes WHERE id = $1 AND activo = true',
                [residente_id]
            );
            
            if (residenteCheck.rows.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Residente no encontrado'
                });
            }
        }
        
        // Actualizar mascota
        const result = await pool.query(
            `UPDATE mascotas SET
                casa_id = COALESCE($1, casa_id),
                residente_id = CASE WHEN $2::INTEGER IS NULL THEN NULL ELSE $2 END,
                nombre = COALESCE($3, nombre),
                tipo = COALESCE($4, tipo),
                raza = $5,
                fecha_nacimiento = $6,
                genero = $7,
                color = $8,
                certificado_vacunas = COALESCE($9, certificado_vacunas),
                fecha_ultima_vacuna = $10,
                observaciones = $11,
                activo = COALESCE($12, activo),
                foto_url = $13
            WHERE id = $14
            RETURNING *`,
            [
                casa_id,
                residente_id,
                nombre,
                tipo,
                raza,
                fecha_nacimiento,
                genero,
                color,
                certificado_vacunas,
                fecha_ultima_vacuna,
                observaciones,
                activo,
                foto_url,
                id
            ]
        );
        
        res.json({
            success: true,
            message: 'Mascota actualizada correctamente',
            data: result.rows[0]
        });
        
    } catch (error) {
        console.error('Error al actualizar mascota:', error);
        res.status(500).json({
            success: false,
            message: 'Error al actualizar mascota',
            error: error.message
        });
    }
});

// ==================== DELETE: Eliminar mascota (soft delete) ====================
/**
 * DELETE /api/mascotas/:id
 * Realiza soft delete de una mascota
 */
router.delete('/:id', requirePermission('mascotas.eliminar'), async (req, res) => {
    try {
        const { id } = req.params;
        
        // Verificar que la mascota existe
        const mascotaCheck = await pool.query(
            'SELECT id, nombre FROM mascotas WHERE id = $1',
            [id]
        );
        
        if (mascotaCheck.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Mascota no encontrada'
            });
        }
        
        // Soft delete
        await pool.query(
            'UPDATE mascotas SET activo = false WHERE id = $1',
            [id]
        );
        
        res.json({
            success: true,
            message: 'Mascota eliminada correctamente'
        });
        
    } catch (error) {
        console.error('Error al eliminar mascota:', error);
        res.status(500).json({
            success: false,
            message: 'Error al eliminar mascota',
            error: error.message
        });
    }
});

module.exports = router;
