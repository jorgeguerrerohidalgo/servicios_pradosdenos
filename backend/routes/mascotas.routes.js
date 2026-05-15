/**
 * RUTAS DE MASCOTAS
 * Gestión de mascotas particulares y comunitarias del condominio
 * Autor: Sistema
 * Fecha: 14/05/2026
 */

const express = require('express');
const router = express.Router();
const { pool } = require('../utils/db');
const { requireAuthAdmin } = require('../middleware/auth');

// Aplicar middleware de autenticación a todas las rutas
router.use(requireAuthAdmin);

// ==================== GET: Listar mascotas ====================
/**
 * GET /api/mascotas
 * Lista todas las mascotas con filtros opcionales
 * Query params: casa_id, tipo, certificado_vacunas, activo, search
 */
router.get('/', async (req, res) => {
    try {
        const { casa_id, tipo, certificado_vacunas, activo = 'true', search } = req.query;
        
        let query = 'SELECT * FROM v_mascotas_completo WHERE 1=1';
        const params = [];
        let paramCount = 1;
        
        // Filtro por casa
        if (casa_id) {
            query += ` AND casa_id = $${paramCount}`;
            params.push(parseInt(casa_id));
            paramCount++;
        }
        
        // Filtro por tipo
        if (tipo && tipo !== 'all') {
            query += ` AND tipo = $${paramCount}`;
            params.push(tipo);
            paramCount++;
        }
        
        // Filtro por certificado de vacunas
        if (certificado_vacunas && certificado_vacunas !== 'all') {
            query += ` AND certificado_vacunas = $${paramCount}`;
            params.push(certificado_vacunas === 'true');
            paramCount++;
        }
        
        // Filtro por activo
        if (activo !== 'all') {
            query += ` AND activo = $${paramCount}`;
            params.push(activo === 'true');
            paramCount++;
        }
        
        // Búsqueda general
        if (search) {
            query += ` AND (
                LOWER(mascota_nombre) LIKE LOWER($${paramCount}) OR
                LOWER(dueno_nombre) LIKE LOWER($${paramCount}) OR
                LOWER(numero_casa) LIKE LOWER($${paramCount}) OR
                LOWER(raza) LIKE LOWER($${paramCount})
            )`;
            params.push(`%${search}%`);
            paramCount++;
        }
        
        query += ' ORDER BY numero_casa, mascota_nombre';
        
        const result = await pool.query(query, params);
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
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

// ==================== POST: Crear mascota ====================
/**
 * POST /api/mascotas
 * Crea una nueva mascota
 */
router.post('/', async (req, res) => {
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
            observaciones
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
                certificado_vacunas, fecha_ultima_vacuna, observaciones
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
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
                observaciones || null
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
router.put('/:id', async (req, res) => {
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
            activo
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
                activo = COALESCE($12, activo)
            WHERE id = $13
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
router.delete('/:id', async (req, res) => {
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
