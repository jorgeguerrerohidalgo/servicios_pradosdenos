/**
 * RUTAS DE VEHÍCULOS
 * Gestión completa de vehículos residenciales
 * Incluye verificación de morosidad para control de acceso
 */

const express = require('express');
const router = express.Router();
const { pool } = require('../config/database');
const { requireAuthAdmin } = require('../middleware/auth');

// Aplicar middleware de autenticación a todas las rutas
router.use(requireAuthAdmin);

/**
 * GET /api/vehiculos
 * Lista todos los vehículos con filtros opcionales
 * Query params: casa_id, tipo, activo
 */
router.get('/', async (req, res) => {
    try {
        const { casa_id, tipo, activo, residente_id } = req.query;
        
        let query = `
            SELECT 
                patente,
                casa_id,
                numero_casa,
                casa_direccion,
                plaza_nombre,
                residente_id,
                residente_nombre,
                residente_rut,
                marca,
                modelo,
                color,
                anio,
                tipo,
                observaciones,
                pagos_vencidos,
                deuda_total,
                estado_morosidad,
                acceso_permitido,
                activo,
                created_at,
                updated_at
            FROM v_vehiculos_completo
            WHERE 1=1
        `;
        
        const params = [];
        let paramCount = 1;
        
        if (casa_id) {
            query += ` AND casa_id = $${paramCount}`;
            params.push(casa_id);
            paramCount++;
        }
        
        if (tipo) {
            query += ` AND tipo = $${paramCount}`;
            params.push(tipo);
            paramCount++;
        }
        
        if (residente_id) {
            query += ` AND residente_id = $${paramCount}`;
            params.push(residente_id);
            paramCount++;
        }
        
        if (activo !== undefined) {
            query += ` AND activo = $${paramCount}`;
            params.push(activo === 'true');
            paramCount++;
        }
        
        query += ' ORDER BY patente ASC';
        
        const result = await pool.query(query, params);
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
        
    } catch (error) {
        console.error('Error al obtener vehículos:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener vehículos',
            error: error.message
        });
    }
});

/**
 * GET /api/vehiculos/bloqueados
 * Lista de vehículos bloqueados por morosidad (3+ meses vencidos)
 */
router.get('/bloqueados', async (req, res) => {
    try {
        const result = await pool.query(`
            SELECT * FROM get_vehiculos_bloqueados()
        `);
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
        
    } catch (error) {
        console.error('Error al obtener vehículos bloqueados:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener vehículos bloqueados',
            error: error.message
        });
    }
});

/**
 * GET /api/vehiculos/casa/:casa_id
 * Obtiene todos los vehículos de una casa específica
 */
router.get('/casa/:casa_id', async (req, res) => {
    try {
        const { casa_id } = req.params;
        
        const result = await pool.query(`
            SELECT * FROM v_vehiculos_completo
            WHERE casa_id = $1
            ORDER BY patente ASC
        `, [casa_id]);
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length
        });
        
    } catch (error) {
        console.error('Error al obtener vehículos de la casa:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener vehículos de la casa',
            error: error.message
        });
    }
});

/**
 * GET /api/vehiculos/:patente
 * Obtiene información completa de un vehículo específico
 */
router.get('/:patente', async (req, res) => {
    try {
        const { patente } = req.params;
        
        const result = await pool.query(`
            SELECT * FROM v_vehiculos_completo
            WHERE patente = $1
        `, [patente.toUpperCase()]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Vehículo no encontrado'
            });
        }
        
        res.json({
            success: true,
            data: result.rows[0]
        });
        
    } catch (error) {
        console.error('Error al obtener vehículo:', error);
        res.status(500).json({
            success: false,
            message: 'Error al obtener vehículo',
            error: error.message
        });
    }
});

/**
 * POST /api/vehiculos
 * Crea un nuevo vehículo
 */
router.post('/', async (req, res) => {
    try {
        const {
            patente,
            casa_id,
            residente_id,
            marca,
            modelo,
            color,
            anio,
            tipo,
            observaciones
        } = req.body;
        
        // Validaciones
        if (!patente || !casa_id || !marca || !modelo || !tipo) {
            return res.status(400).json({
                success: false,
                message: 'Faltan campos obligatorios: patente, casa_id, marca, modelo, tipo'
            });
        }
        
        // Validar patente (formato básico)
        const patenteUpper = patente.toUpperCase().trim();
        if (!/^[A-Z0-9]{4,10}$/.test(patenteUpper)) {
            return res.status(400).json({
                success: false,
                message: 'Formato de patente inválido (4-10 caracteres alfanuméricos)'
            });
        }
        
        // Validar tipo
        const tiposValidos = ['automovil', 'camioneta', 'motocicleta', 'bicicleta', 'otro'];
        if (!tiposValidos.includes(tipo)) {
            return res.status(400).json({
                success: false,
                message: `Tipo inválido. Debe ser: ${tiposValidos.join(', ')}`
            });
        }
        
        // Validar año si se proporciona
        if (anio) {
            const currentYear = new Date().getFullYear();
            if (anio < 1900 || anio > currentYear + 1) {
                return res.status(400).json({
                    success: false,
                    message: `Año inválido. Debe estar entre 1900 y ${currentYear + 1}`
                });
            }
        }
        
        // Verificar que la casa existe y está activa
        const casaCheck = await pool.query(
            'SELECT id FROM casas WHERE id = $1 AND activo = TRUE',
            [casa_id]
        );
        
        if (casaCheck.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Casa no encontrada o inactiva'
            });
        }
        
        // Verificar que el residente existe y pertenece a la casa (si se especifica)
        if (residente_id) {
            const residenteCheck = await pool.query(
                'SELECT id FROM residentes WHERE id = $1 AND casa_id = $2 AND activo = TRUE',
                [residente_id, casa_id]
            );
            
            if (residenteCheck.rows.length === 0) {
                return res.status(400).json({
                    success: false,
                    message: 'El residente no existe o no pertenece a esta casa'
                });
            }
        }
        
        // Insertar vehículo
        const result = await pool.query(`
            INSERT INTO vehiculos (
                patente, casa_id, residente_id, marca, modelo,
                color, anio, tipo, observaciones
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
            RETURNING *
        `, [
            patenteUpper,
            casa_id,
            residente_id || null,
            marca.trim(),
            modelo.trim(),
            color ? color.trim() : null,
            anio || null,
            tipo,
            observaciones || null
        ]);
        
        // Obtener datos completos desde la vista
        const vehiculoCompleto = await pool.query(
            'SELECT * FROM v_vehiculos_completo WHERE patente = $1',
            [patenteUpper]
        );
        
        res.status(201).json({
            success: true,
            message: 'Vehículo registrado exitosamente',
            data: vehiculoCompleto.rows[0]
        });
        
    } catch (error) {
        console.error('Error al crear vehículo:', error);
        
        // Error de duplicado
        if (error.code === '23505') {
            return res.status(409).json({
                success: false,
                message: 'Ya existe un vehículo con esa patente'
            });
        }
        
        res.status(500).json({
            success: false,
            message: 'Error al crear vehículo',
            error: error.message
        });
    }
});

/**
 * PUT /api/vehiculos/:patente
 * Actualiza información de un vehículo existente
 */
router.put('/:patente', async (req, res) => {
    try {
        const { patente } = req.params;
        const patenteUpper = patente.toUpperCase();
        const {
            casa_id,
            residente_id,
            marca,
            modelo,
            color,
            anio,
            tipo,
            observaciones
        } = req.body;
        
        // Verificar que el vehículo existe
        const vehiculoCheck = await pool.query(
            'SELECT patente FROM vehiculos WHERE patente = $1',
            [patenteUpper]
        );
        
        if (vehiculoCheck.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Vehículo no encontrado'
            });
        }
        
        // Validar tipo si se proporciona
        if (tipo) {
            const tiposValidos = ['automovil', 'camioneta', 'motocicleta', 'bicicleta', 'otro'];
            if (!tiposValidos.includes(tipo)) {
                return res.status(400).json({
                    success: false,
                    message: `Tipo inválido. Debe ser: ${tiposValidos.join(', ')}`
                });
            }
        }
        
        // Validar año si se proporciona
        if (anio) {
            const currentYear = new Date().getFullYear();
            if (anio < 1900 || anio > currentYear + 1) {
                return res.status(400).json({
                    success: false,
                    message: `Año inválido. Debe estar entre 1900 y ${currentYear + 1}`
                });
            }
        }
        
        // Verificar que la casa existe si se cambia
        if (casa_id) {
            const casaCheck = await pool.query(
                'SELECT id FROM casas WHERE id = $1 AND activo = TRUE',
                [casa_id]
            );
            
            if (casaCheck.rows.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Casa no encontrada o inactiva'
                });
            }
        }
        
        // Verificar que el residente pertenece a la casa si se especifica
        if (residente_id && casa_id) {
            const residenteCheck = await pool.query(
                'SELECT id FROM residentes WHERE id = $1 AND casa_id = $2 AND activo = TRUE',
                [residente_id, casa_id]
            );
            
            if (residenteCheck.rows.length === 0) {
                return res.status(400).json({
                    success: false,
                    message: 'El residente no existe o no pertenece a esta casa'
                });
            }
        }
        
        // Construir query de actualización dinámica
        const updates = [];
        const values = [];
        let paramCount = 1;
        
        if (casa_id !== undefined) {
            updates.push(`casa_id = $${paramCount}`);
            values.push(casa_id);
            paramCount++;
        }
        
        if (residente_id !== undefined) {
            updates.push(`residente_id = $${paramCount}`);
            values.push(residente_id);
            paramCount++;
        }
        
        if (marca !== undefined) {
            updates.push(`marca = $${paramCount}`);
            values.push(marca.trim());
            paramCount++;
        }
        
        if (modelo !== undefined) {
            updates.push(`modelo = $${paramCount}`);
            values.push(modelo.trim());
            paramCount++;
        }
        
        if (color !== undefined) {
            updates.push(`color = $${paramCount}`);
            values.push(color ? color.trim() : null);
            paramCount++;
        }
        
        if (anio !== undefined) {
            updates.push(`anio = $${paramCount}`);
            values.push(anio);
            paramCount++;
        }
        
        if (tipo !== undefined) {
            updates.push(`tipo = $${paramCount}`);
            values.push(tipo);
            paramCount++;
        }
        
        if (observaciones !== undefined) {
            updates.push(`observaciones = $${paramCount}`);
            values.push(observaciones);
            paramCount++;
        }
        
        if (updates.length === 0) {
            return res.status(400).json({
                success: false,
                message: 'No se proporcionaron campos para actualizar'
            });
        }
        
        // Agregar patente como último parámetro
        values.push(patenteUpper);
        
        const query = `
            UPDATE vehiculos
            SET ${updates.join(', ')}
            WHERE patente = $${paramCount}
            RETURNING *
        `;
        
        await pool.query(query, values);
        
        // Obtener datos completos desde la vista
        const vehiculoCompleto = await pool.query(
            'SELECT * FROM v_vehiculos_completo WHERE patente = $1',
            [patenteUpper]
        );
        
        res.json({
            success: true,
            message: 'Vehículo actualizado exitosamente',
            data: vehiculoCompleto.rows[0]
        });
        
    } catch (error) {
        console.error('Error al actualizar vehículo:', error);
        res.status(500).json({
            success: false,
            message: 'Error al actualizar vehículo',
            error: error.message
        });
    }
});

/**
 * DELETE /api/vehiculos/:patente
 * Soft delete de un vehículo
 */
router.delete('/:patente', async (req, res) => {
    try {
        const { patente } = req.params;
        const patenteUpper = patente.toUpperCase();
        
        const result = await pool.query(`
            UPDATE vehiculos
            SET activo = FALSE
            WHERE patente = $1 AND activo = TRUE
            RETURNING patente, marca, modelo
        `, [patenteUpper]);
        
        if (result.rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Vehículo no encontrado o ya inactivo'
            });
        }
        
        res.json({
            success: true,
            message: 'Vehículo eliminado exitosamente',
            data: result.rows[0]
        });
        
    } catch (error) {
        console.error('Error al eliminar vehículo:', error);
        res.status(500).json({
            success: false,
            message: 'Error al eliminar vehículo',
            error: error.message
        });
    }
});

module.exports = router;
