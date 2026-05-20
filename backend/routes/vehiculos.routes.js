/**
 * RUTAS DE VEHÍCULOS
 * Gestión completa de vehículos residenciales
 * Incluye verificación de morosidad para control de acceso
 */

const express = require('express');
const router = express.Router();
const { pool } = require('../utils/db');
const { requireAuth, requireAuthAdmin } = require('../middleware/sessionAuth');
const { requirePermission } = require('../middleware/rbac');
const { applyScoping, buildPlazaFilter } = require('../middleware/applyScoping');

/**
 * ==============================================================
 * RUTAS PÚBLICAS - MANTENEDORES DE VEHÍCULOS (Sin autenticación)
 * Estas rutas están ANTES del requireAuth para ser accesibles públicamente
 * Usadas en formularios de registro y dropdowns en cascada
 * ==============================================================
 */

/**
 * GET /api/vehiculos/tipos
 * Obtener todos los tipos de vehículos activos ordenados
 */
router.get('/tipos', async (req, res) => {
    try {
        const result = await pool.query(
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
 * Query params: tipo_id (opcional) - filtrar marcas que tengan modelos de ese tipo
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

        const result = await pool.query(query, params);

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
 * Query params: tipo_id (opcional) - filtrar modelos por tipo de vehículo
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

        const result = await pool.query(query, params);

        // Obtener información de la marca
        const marcaResult = await pool.query(
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

        const result = await pool.query(
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
 * Query params: q (min 2 chars), marca_id (opcional), tipo_id (opcional)
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

        const result = await pool.query(query, params);

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

/**
 * ==============================================================
 * FIN RUTAS PÚBLICAS - INICIO RUTAS PROTEGIDAS
 * ==============================================================
 */

// Aplicar middleware de autenticación a todas las rutas siguientes
router.use(requireAuth);

/**
 * GET /api/vehiculos
 * Lista todos los vehículos con filtros opcionales (con scoping automático)
 * Query params: casa_id, tipo, activo
 */
router.get('/', requirePermission('vehiculos.leer'), applyScoping, async (req, res) => {
    try {
        const { plaza_id, casa_id, tipo, activo, residente_id } = req.query;
        
        let query = `
            SELECT 
                patente,
                casa_id,
                numero_casa,
                casa_direccion,
                plaza_id,
                plaza_nombre,
                residente_id,
                residente_nombre,
                residente_run,
                marca,
                modelo,
                color,
                anio,
                tipo,
                observaciones,
                meses_moroso,
                deuda_total,
                estado_morosidad,
                acceso_permitido,
                activo,
                created_at,
                updated_at
            FROM v_vehiculos_completo
            WHERE 1=1
        `;
        
        let params = [];
        let paramCount = 0;
        
        // Filtro por casa (prioridad sobre plaza)
        if (casa_id) {
            paramCount++;
            query += ` AND casa_id = $${paramCount}`;
            params.push(casa_id);
        } else if (plaza_id) {
            paramCount++;
            query += ` AND plaza_id = $${paramCount}`;
            params.push(plaza_id);
        }
        
        if (tipo) {
            paramCount++;
            query += ` AND tipo = $${paramCount}`;
            params.push(tipo);
        }
        
        if (residente_id) {
        }
        
        if (activo !== undefined) {
            paramCount++;
            query += ` AND activo = $${paramCount}`;
            params.push(activo === 'true');
        }
        
        // ⚡ SCOPING AUTOMÁTICO: Filtrar por plazas permitidas del usuario
        // Nota: v_vehiculos_completo incluye plaza_id de la casa
        const plazaFilter = buildPlazaFilter(req.allowedPlazas, '', params);
        query += plazaFilter.sql;
        params = plazaFilter.params;
        
        query += ' ORDER BY patente ASC';
        
        const result = await pool.query(query, params);
        
        res.json({
            success: true,
            data: result.rows,
            count: result.rows.length,
            scoping: req.allowedPlazas === null ? 'global' : `plazas: ${req.allowedPlazas?.join(', ') || 'ninguna'}`
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
router.post('/', requirePermission('vehiculos.crear'), async (req, res) => {
    try {
        const {
            patente,
            casa_id,
            residente_id,
            // Campos legacy (texto libre)
            marca,
            modelo,
            tipo,
            // Nuevos campos de mantenedores (IDs)
            tipo_vehiculo_id,
            marca_id,
            modelo_id,
            // Otros campos
            color,
            anio,
            observaciones
        } = req.body;
        
        // Validaciones (soportar campos legacy o nuevos mantenedores)
        if (!patente || !casa_id) {
            return res.status(400).json({
                success: false,
                message: 'Faltan campos obligatorios: patente, casa_id'
            });
        }
        
        // Validar que se haya proporcionado marca/modelo/tipo (legacy o IDs)
        const tieneTipo = tipo || tipo_vehiculo_id;
        const tieneMarca = marca || marca_id;
        const tieneModelo = modelo || modelo_id;
        
        if (!tieneTipo || !tieneMarca || !tieneModelo) {
            return res.status(400).json({
                success: false,
                message: 'Faltan campos obligatorios: tipo, marca y modelo son requeridos'
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
        
        // Validar tipo legacy si se proporciona
        if (tipo) {
            const tiposValidos = ['automovil', 'camioneta', 'motocicleta', 'bicicleta', 'otro', 
                                  'Automóvil', 'Camioneta', 'SUV', 'Station Wagon', 
                                  'Motocicleta', 'Furgón', 'Van de Pasajeros', 'Camión', 
                                  'Bus', 'Deportivo', 'Todo Terreno', 'Cuatrimoto'];
            if (!tiposValidos.includes(tipo)) {
                console.warn(`Tipo '${tipo}' no está en la lista predefinida, pero se aceptará`);
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
        
        // Insertar vehículo (con campos legacy y nuevos mantenedores)
        const result = await pool.query(`
            INSERT INTO vehiculos (
                patente, casa_id, residente_id,
                tipo, marca, modelo,
                tipo_vehiculo_id, marca_id, modelo_id,
                color, anio, observaciones
            )
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
            RETURNING *
        `, [
            patenteUpper,
            casa_id,
            residente_id || null,
            tipo ? tipo.trim() : null,
            marca ? marca.trim() : null,
            modelo ? modelo.trim() : null,
            tipo_vehiculo_id || null,
            marca_id || null,
            modelo_id || null,
            color ? color.trim() : null,
            anio || null,
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
        
        // Error de FK (ID de mantenedor inválido)
        if (error.code === '23503') {
            return res.status(400).json({
                success: false,
                message: 'ID de tipo, marca o modelo inválido'
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
router.put('/:patente', requirePermission('vehiculos.editar'), async (req, res) => {
    try {
        const { patente } = req.params;
        const patenteUpper = patente.toUpperCase();
        const {
            casa_id,
            residente_id,
            // Campos legacy
            marca,
            modelo,
            tipo,
            // Nuevos campos de mantenedores
            tipo_vehiculo_id,
            marca_id,
            modelo_id,
            // Otros campos
            color,
            anio,
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
        
        // Validar tipo legacy si se proporciona
        if (tipo) {
            const tiposValidos = ['automovil', 'camioneta', 'motocicleta', 'bicicleta', 'otro',
                                  'Automóvil', 'Camioneta', 'SUV', 'Station Wagon', 
                                  'Motocicleta', 'Furgón', 'Van de Pasajeros', 'Camión', 
                                  'Bus', 'Deportivo', 'Todo Terreno', 'Cuatrimoto'];
            if (!tiposValidos.includes(tipo)) {
                console.warn(`Tipo '${tipo}' no está en la lista predefinida, pero se aceptará`);
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
        
        // Campos legacy
        if (marca !== undefined) {
            updates.push(`marca = $${paramCount}`);
            values.push(marca ? marca.trim() : null);
            paramCount++;
        }
        
        if (modelo !== undefined) {
            updates.push(`modelo = $${paramCount}`);
            values.push(modelo ? modelo.trim() : null);
            paramCount++;
        }
        
        if (tipo !== undefined) {
            updates.push(`tipo = $${paramCount}`);
            values.push(tipo ? tipo.trim() : null);
            paramCount++;
        }
        
        // Nuevos campos de mantenedores
        if (tipo_vehiculo_id !== undefined) {
            updates.push(`tipo_vehiculo_id = $${paramCount}`);
            values.push(tipo_vehiculo_id);
            paramCount++;
        }
        
        if (marca_id !== undefined) {
            updates.push(`marca_id = $${paramCount}`);
            values.push(marca_id);
            paramCount++;
        }
        
        if (modelo_id !== undefined) {
            updates.push(`modelo_id = $${paramCount}`);
            values.push(modelo_id);
            paramCount++;
        }
        
        // Otros campos
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
        
        // Error de FK (ID de mantenedor inválido)
        if (error.code === '23503') {
            return res.status(400).json({
                success: false,
                message: 'ID de tipo, marca o modelo inválido'
            });
        }
        
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
router.delete('/:patente', requirePermission('vehiculos.eliminar'), async (req, res) => {
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
