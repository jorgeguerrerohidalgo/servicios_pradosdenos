/**
 * =============================================
 * ROUTES: Roles y Permisos (RBAC Management)
 * =============================================
 * Endpoints para gestión del sistema de roles y permisos
 * 
 * @author Sistema
 * @date 19/05/2026
 */

const express = require('express');
const router = express.Router();
const { requireAuth } = require('../middleware/sessionAuth');
const { requirePermission, requireRole } = require('../middleware/rbac');
const pool = require('../config/database');
const { getUserPermissions, getUserRoles } = require('../utils/permissions');

// ========================================
// GESTIÓN DE ROLES
// ========================================

/**
 * GET /api/roles
 * Listar todos los roles del sistema
 */
router.get('/', 
  requireAuth, 
  requirePermission('roles.leer'), 
  async (req, res) => {
    try {
      const result = await pool.query(`
        SELECT 
          r.*,
          COUNT(DISTINCT ur.user_id) as total_usuarios,
          COUNT(DISTINCT rp.permission_id) as total_permisos
        FROM roles r
        LEFT JOIN user_roles ur ON r.id = ur.role_id AND ur.activo = TRUE
        LEFT JOIN role_permissions rp ON r.id = rp.role_id
        WHERE r.activo = TRUE
        GROUP BY r.id
        ORDER BY r.nivel_prioridad DESC
      `);
      
      res.json({ success: true, data: result.rows });
    } catch (error) {
      console.error('❌ Error al listar roles:', error);
      res.status(500).json({ success: false, error: 'Error al obtener roles' });
    }
  }
);

/**
 * GET /api/roles/:id
 * Obtener detalles de un rol específico
 */
router.get('/:id',
  requireAuth,
  requirePermission('roles.leer'),
  async (req, res) => {
    try {
      const result = await pool.query(`
        SELECT r.*,
               COUNT(DISTINCT ur.user_id) as total_usuarios,
               COUNT(DISTINCT rp.permission_id) as total_permisos
        FROM roles r
        LEFT JOIN user_roles ur ON r.id = ur.role_id AND ur.activo = TRUE
        LEFT JOIN role_permissions rp ON r.id = rp.role_id
        WHERE r.id = $1 AND r.activo = TRUE
        GROUP BY r.id
      `, [req.params.id]);
      
      if (result.rows.length === 0) {
        return res.status(404).json({ success: false, error: 'Rol no encontrado' });
      }
      
      res.json({ success: true, data: result.rows[0] });
    } catch (error) {
      console.error('❌ Error al obtener rol:', error);
      res.status(500).json({ success: false, error: 'Error al obtener rol' });
    }
  }
);

/**
 * GET /api/roles/:id/permissions
 * Listar permisos asignados a un rol
 */
router.get('/:id/permissions', 
  requireAuth, 
  requirePermission('roles.leer'), 
  async (req, res) => {
    try {
      const result = await pool.query(`
        SELECT p.*, rp.created_at as asignado_en
        FROM permissions p
        INNER JOIN role_permissions rp ON p.id = rp.permission_id
        WHERE rp.role_id = $1 AND p.activo = TRUE
        ORDER BY p.modulo, p.accion
      `, [req.params.id]);
      
      res.json({ success: true, data: result.rows });
    } catch (error) {
      console.error('❌ Error al obtener permisos del rol:', error);
      res.status(500).json({ success: false, error: 'Error al obtener permisos' });
    }
  }
);

/**
 * POST /api/roles
 * Crear nuevo rol custom (solo super_admin)
 */
router.post('/', 
  requireAuth, 
  requireRole('super_admin'), 
  async (req, res) => {
    try {
      const { codigo, nombre, descripcion, nivel_prioridad } = req.body;
      
      // Validaciones
      if (!codigo || !nombre || !nivel_prioridad) {
        return res.status(400).json({ 
          success: false, 
          error: 'Campos requeridos: codigo, nombre, nivel_prioridad' 
        });
      }
      
      // No permitir niveles >= 100 (reservado para super_admin)
      if (nivel_prioridad >= 100) {
        return res.status(400).json({
          success: false,
          error: 'Nivel 100 está reservado para Super Admin'
        });
      }
      
      const result = await pool.query(`
        INSERT INTO roles (codigo, nombre, descripcion, nivel_prioridad, es_sistema, activo)
        VALUES ($1, $2, $3, $4, FALSE, TRUE)
        RETURNING *
      `, [codigo, nombre, descripcion, nivel_prioridad]);
      
      // Auditoría
      await pool.query(`
        INSERT INTO permission_audit (user_id, accion, role_id, motivo, ip_address)
        VALUES ($1, 'crear_rol', $2, $3, $4)
      `, [req.user.id, result.rows[0].id, `Rol custom creado: ${nombre}`, req.ip]);
      
      res.status(201).json({ success: true, data: result.rows[0] });
    } catch (error) {
      console.error('❌ Error al crear rol:', error);
      
      if (error.code === '23505') {  // Unique violation
        return res.status(409).json({ 
          success: false, 
          error: 'Ya existe un rol con ese código' 
        });
      }
      
      res.status(500).json({ success: false, error: 'Error al crear rol' });
    }
  }
);

/**
 * PUT /api/roles/:id
 * Actualizar rol (solo super_admin, no puede modificar roles de sistema)
 */
router.put('/:id',
  requireAuth,
  requireRole('super_admin'),
  async (req, res) => {
    try {
      const { nombre, descripcion, nivel_prioridad, activo } = req.body;
      
      // Verificar que no sea un rol de sistema
      const checkResult = await pool.query(
        'SELECT es_sistema FROM roles WHERE id = $1',
        [req.params.id]
      );
      
      if (checkResult.rows.length === 0) {
        return res.status(404).json({ success: false, error: 'Rol no encontrado' });
      }
      
      if (checkResult.rows[0].es_sistema) {
        return res.status(403).json({ 
          success: false, 
          error: 'No se puede modificar un rol del sistema' 
        });
      }
      
      const result = await pool.query(`
        UPDATE roles
        SET nombre = COALESCE($1, nombre),
            descripcion = COALESCE($2, descripcion),
            nivel_prioridad = COALESCE($3, nivel_prioridad),
            activo = COALESCE($4, activo),
            updated_at = NOW()
        WHERE id = $5 AND es_sistema = FALSE
        RETURNING *
      `, [nombre, descripcion, nivel_prioridad, activo, req.params.id]);
      
      if (result.rows.length === 0) {
        return res.status(404).json({ success: false, error: 'Rol no encontrado o es de sistema' });
      }
      
      // Auditoría
      await pool.query(`
        INSERT INTO permission_audit (user_id, accion, role_id, motivo, ip_address)
        VALUES ($1, 'editar_rol', $2, $3, $4)
      `, [req.user.id, req.params.id, `Rol actualizado: ${nombre}`, req.ip]);
      
      res.json({ success: true, data: result.rows[0] });
    } catch (error) {
      console.error('❌ Error al actualizar rol:', error);
      res.status(500).json({ success: false, error: 'Error al actualizar rol' });
    }
  }
);

// ========================================
// GESTIÓN DE PERMISOS
// ========================================

/**
 * GET /api/roles/permissions/all
 * Listar todos los permisos disponibles agrupados por módulo
 */
router.get('/permissions/all', 
  requireAuth, 
  requirePermission('roles.leer'), 
  async (req, res) => {
    try {
      const result = await pool.query(`
        SELECT 
          modulo,
          json_agg(
            json_build_object(
              'id', id, 
              'codigo', codigo, 
              'accion', accion, 
              'descripcion', descripcion
            ) ORDER BY accion
          ) as permisos
        FROM permissions
        WHERE activo = TRUE
        GROUP BY modulo
        ORDER BY modulo
      `);
      
      res.json({ success: true, data: result.rows });
    } catch (error) {
      console.error('❌ Error al listar permisos:', error);
      res.status(500).json({ success: false, error: 'Error al obtener permisos' });
    }
  }
);

/**
 * POST /api/roles/:id/permissions
 * Asignar permiso a un rol (solo super_admin)
 */
router.post('/:id/permissions', 
  requireAuth, 
  requireRole('super_admin'), 
  async (req, res) => {
    try {
      const { permission_id } = req.body;
      
      if (!permission_id) {
        return res.status(400).json({ 
          success: false, 
          error: 'permission_id es requerido' 
        });
      }
      
      await pool.query(`
        INSERT INTO role_permissions (role_id, permission_id)
        VALUES ($1, $2)
        ON CONFLICT DO NOTHING
      `, [req.params.id, permission_id]);
      
      // Auditoría
      await pool.query(`
        INSERT INTO permission_audit (user_id, accion, role_id, permission_id, ip_address)
        VALUES ($1, 'asignar_permiso', $2, $3, $4)
      `, [req.user.id, req.params.id, permission_id, req.ip]);
      
      res.json({ success: true, message: 'Permiso asignado correctamente' });
    } catch (error) {
      console.error('❌ Error al asignar permiso:', error);
      res.status(500).json({ success: false, error: 'Error al asignar permiso' });
    }
  }
);

/**
 * DELETE /api/roles/:id/permissions/:permission_id
 * Revocar permiso de un rol (solo super_admin)
 */
router.delete('/:id/permissions/:permission_id', 
  requireAuth, 
  requireRole('super_admin'), 
  async (req, res) => {
    try {
      await pool.query(`
        DELETE FROM role_permissions
        WHERE role_id = $1 AND permission_id = $2
      `, [req.params.id, req.params.permission_id]);
      
      // Auditoría
      await pool.query(`
        INSERT INTO permission_audit (user_id, accion, role_id, permission_id, ip_address)
        VALUES ($1, 'revocar_permiso', $2, $3, $4)
      `, [req.user.id, req.params.id, req.params.permission_id, req.ip]);
      
      res.json({ success: true, message: 'Permiso revocado correctamente' });
    } catch (error) {
      console.error('❌ Error al revocar permiso:', error);
      res.status(500).json({ success: false, error: 'Error al revocar permiso' });
    }
  }
);

// ========================================
// ASIGNACIÓN DE ROLES A USUARIOS
// ========================================

/**
 * GET /api/roles/users/:user_id/roles
 * Ver roles asignados a un usuario
 */
router.get('/users/:user_id/roles',
  requireAuth,
  requirePermission('roles.leer'),
  async (req, res) => {
    try {
      const result = await pool.query(`
        SELECT 
          r.*,
          ur.scope_type,
          ur.scope_id,
          ur.asignado_en,
          ur.expira_en,
          p.nombre as plaza_nombre,
          u_asignador.nombre as asignado_por_nombre
        FROM user_roles ur
        INNER JOIN roles r ON ur.role_id = r.id
        LEFT JOIN plazas p ON ur.scope_id = p.id AND ur.scope_type = 'plaza'
        LEFT JOIN admin_users u_asignador ON ur.asignado_por = u_asignador.id
        WHERE ur.user_id = $1 AND ur.activo = TRUE
        ORDER BY r.nivel_prioridad DESC
      `, [req.params.user_id]);
      
      res.json({ success: true, data: result.rows });
    } catch (error) {
      console.error('❌ Error al obtener roles del usuario:', error);
      res.status(500).json({ success: false, error: 'Error al obtener roles' });
    }
  }
);

/**
 * POST /api/roles/users/:user_id/roles
 * Asignar rol a usuario (solo super_admin)
 */
router.post('/users/:user_id/roles', 
  requireAuth, 
  requireRole('super_admin'), 
  async (req, res) => {
    try {
      const { role_id, scope_type, scope_id, expira_en } = req.body;
      
      if (!role_id) {
        return res.status(400).json({ 
          success: false, 
          error: 'role_id es requerido' 
        });
      }
      
      await pool.query(`
        INSERT INTO user_roles (user_id, role_id, scope_type, scope_id, asignado_por, expira_en, activo)
        VALUES ($1, $2, $3, $4, $5, $6, TRUE)
        ON CONFLICT (user_id, role_id) DO UPDATE
        SET scope_type = EXCLUDED.scope_type,
            scope_id = EXCLUDED.scope_id,
            expira_en = EXCLUDED.expira_en,
            asignado_por = EXCLUDED.asignado_por,
            activo = TRUE,
            updated_at = NOW()
      `, [req.params.user_id, role_id, scope_type, scope_id, req.user.id, expira_en]);
      
      // Actualizar timestamp de cambio de permisos
      await pool.query(`
        UPDATE admin_users
        SET ultimo_cambio_permisos = NOW()
        WHERE id = $1
      `, [req.params.user_id]);
      
      // Auditoría
      await pool.query(`
        INSERT INTO permission_audit (user_id, accion, target_user_id, role_id, ip_address)
        VALUES ($1, 'asignar_rol', $2, $3, $4)
      `, [req.user.id, req.params.user_id, role_id, req.ip]);
      
      res.json({ success: true, message: 'Rol asignado correctamente' });
    } catch (error) {
      console.error('❌ Error al asignar rol:', error);
      res.status(500).json({ success: false, error: 'Error al asignar rol' });
    }
  }
);

/**
 * DELETE /api/roles/users/:user_id/roles/:role_id
 * Revocar rol de usuario (solo super_admin)
 */
router.delete('/users/:user_id/roles/:role_id', 
  requireAuth, 
  requireRole('super_admin'), 
  async (req, res) => {
    try {
      await pool.query(`
        UPDATE user_roles
        SET activo = FALSE, updated_at = NOW()
        WHERE user_id = $1 AND role_id = $2
      `, [req.params.user_id, req.params.role_id]);
      
      // Actualizar timestamp
      await pool.query(`
        UPDATE admin_users
        SET ultimo_cambio_permisos = NOW()
        WHERE id = $1
      `, [req.params.user_id]);
      
      // Auditoría
      await pool.query(`
        INSERT INTO permission_audit (user_id, accion, target_user_id, role_id, ip_address)
        VALUES ($1, 'revocar_rol', $2, $3, $4)
      `, [req.user.id, req.params.user_id, req.params.role_id, req.ip]);
      
      res.json({ success: true, message: 'Rol revocado correctamente' });
    } catch (error) {
      console.error('❌ Error al revocar rol:', error);
      res.status(500).json({ success: false, error: 'Error al revocar rol' });
    }
  }
);

/**
 * GET /api/roles/users/:user_id/permissions
 * Ver permisos efectivos de un usuario
 */
router.get('/users/:user_id/permissions', 
  requireAuth, 
  requirePermission('roles.leer'), 
  async (req, res) => {
    try {
      const permissions = await getUserPermissions(req.params.user_id);
      const roles = await getUserRoles(req.params.user_id);
      
      res.json({ 
        success: true, 
        data: { 
          permissions, 
          roles,
          total_permissions: permissions.length,
          total_roles: roles.length
        } 
      });
    } catch (error) {
      console.error('❌ Error al obtener permisos del usuario:', error);
      res.status(500).json({ success: false, error: 'Error al obtener permisos' });
    }
  }
);

// ========================================
// AUDITORÍA
// ========================================

/**
 * GET /api/roles/audit/recent
 * Ver auditoría reciente de cambios en roles/permisos
 */
router.get('/audit/recent',
  requireAuth,
  requireRole('super_admin'),
  async (req, res) => {
    try {
      const limit = parseInt(req.query.limit) || 50;
      
      const result = await pool.query(`
        SELECT 
          pa.*,
          u.nombre as usuario_nombre,
          u.email as usuario_email,
          tu.nombre as target_usuario_nombre,
          tu.email as target_usuario_email,
          r.nombre as rol_nombre,
          p.codigo as permiso_codigo
        FROM permission_audit pa
        LEFT JOIN admin_users u ON pa.user_id = u.id
        LEFT JOIN admin_users tu ON pa.target_user_id = tu.id
        LEFT JOIN roles r ON pa.role_id = r.id
        LEFT JOIN permissions p ON pa.permission_id = p.id
        ORDER BY pa.created_at DESC
        LIMIT $1
      `, [limit]);
      
      res.json({ success: true, data: result.rows });
    } catch (error) {
      console.error('❌ Error al obtener auditoría:', error);
      res.status(500).json({ success: false, error: 'Error al obtener auditoría' });
    }
  }
);

module.exports = router;
