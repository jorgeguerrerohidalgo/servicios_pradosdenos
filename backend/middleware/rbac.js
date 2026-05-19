/**
 * =============================================
 * MIDDLEWARE: RBAC (Role-Based Access Control)
 * =============================================
 * Middlewares para control de acceso basado en roles y permisos
 * 
 * @author Sistema
 * @date 19/05/2026
 */

const { getUserPermissions, hasPermission, checkScope } = require('../utils/permissions');

/**
 * Middleware: Requiere permiso específico
 * Uso: router.post('/guardias', requirePermission('guardias.crear'), ...)
 * 
 * @param {string} permission - Permiso requerido (ej: 'guardias.crear')
 * @returns {Function} Express middleware
 */
const requirePermission = (permission) => async (req, res, next) => {
  try {
    // Verificar autenticación
    if (!req.session || !req.session.guardia) {
      return res.status(401).json({ 
        success: false, 
        error: 'No autenticado',
        code: 'AUTH_REQUIRED'
      });
    }

    const user = req.session.guardia;

    // Cargar permisos del usuario si no están en sesión
    if (!user.permissions || user.permissions.length === 0) {
      user.permissions = await getUserPermissions(user.id);
      req.session.guardia.permissions = user.permissions;  // Actualizar sesión
    }

    // Verificar permiso
    if (!hasPermission(user.permissions, permission)) {
      console.warn(`⚠️ Permiso denegado: Usuario ${user.email} intentó ${permission}`);
      
      return res.status(403).json({ 
        success: false, 
        error: 'Sin permisos suficientes', 
        required: permission,
        code: 'PERMISSION_DENIED'
      });
    }

    // Permiso concedido
    req.user = user;  // Inyectar usuario en request
    next();

  } catch (error) {
    console.error('❌ Error en requirePermission:', error);
    return res.status(500).json({ 
      success: false, 
      error: 'Error al verificar permisos',
      code: 'PERMISSION_CHECK_ERROR'
    });
  }
};

/**
 * Middleware: Requiere uno de varios roles
 * Uso: router.post('/roles', requireRole('super_admin', 'administrador'), ...)
 * 
 * @param {...string} roles - Códigos de roles permitidos
 * @returns {Function} Express middleware
 */
const requireRole = (...roles) => (req, res, next) => {
  try {
    // Verificar autenticación
    if (!req.session || !req.session.guardia) {
      return res.status(401).json({ 
        success: false, 
        error: 'No autenticado',
        code: 'AUTH_REQUIRED'
      });
    }

    const user = req.session.guardia;

    // Verificar si tiene roles cargados
    if (!user.roles || user.roles.length === 0) {
      return res.status(403).json({ 
        success: false, 
        error: 'Usuario sin roles asignados',
        code: 'NO_ROLES'
      });
    }

    // Verificar si tiene alguno de los roles requeridos
    const userRoles = user.roles.map(r => r.codigo || r);
    const hasRole = userRoles.some(r => roles.includes(r));

    if (!hasRole) {
      console.warn(`⚠️ Rol insuficiente: Usuario ${user.email} (${userRoles.join(', ')}) necesita ${roles.join(' o ')}`);
      
      return res.status(403).json({ 
        success: false, 
        error: 'Rol insuficiente', 
        required: roles,
        userRoles: userRoles,
        code: 'ROLE_DENIED'
      });
    }

    // Rol válido
    req.user = user;
    next();

  } catch (error) {
    console.error('❌ Error en requireRole:', error);
    return res.status(500).json({ 
      success: false, 
      error: 'Error al verificar rol',
      code: 'ROLE_CHECK_ERROR'
    });
  }
};

/**
 * Middleware: Valida scope de plaza
 * Extrae plaza_id de params, body o query y verifica acceso
 * Uso: router.get('/casas/:id', requireScope, ...)
 * 
 * @param {Object} req - Express request
 * @param {Object} res - Express response
 * @param {Function} next - Express next
 */
const requireScope = (req, res, next) => {
  try {
    // Verificar autenticación
    if (!req.session || !req.session.guardia) {
      return res.status(401).json({ 
        success: false, 
        error: 'No autenticado',
        code: 'AUTH_REQUIRED'
      });
    }

    const user = req.session.guardia;

    // Extraer plaza_id de diferentes fuentes
    const resourcePlazaId = req.params.plaza_id || 
                           req.body.plaza_id || 
                           req.query.plaza_id;

    // Si no se especifica plaza, asumir que el endpoint no require scope
    if (!resourcePlazaId) {
      req.user = user;
      return next();
    }

    // Verificar scope
    if (!checkScope(user, resourcePlazaId)) {
      console.warn(`⚠️ Scope denegado: Usuario ${user.email} intentó acceder a plaza ${resourcePlazaId}`);
      
      return res.status(403).json({ 
        success: false, 
        error: 'Acceso fuera de alcance (plaza)', 
        plaza_id: resourcePlazaId,
        allowed_plazas: user.scopes?.filter(s => s.scope_type === 'plaza').map(s => s.scope_id) || [],
        code: 'SCOPE_DENIED'
      });
    }

    // Scope válido
    req.user = user;
    next();

  } catch (error) {
    console.error('❌ Error en requireScope:', error);
    return res.status(500).json({ 
      success: false, 
      error: 'Error al verificar alcance',
      code: 'SCOPE_CHECK_ERROR'
    });
  }
};

/**
 * Middleware combinado: Requiere permiso Y scope
 * Uso: router.put('/casas/:id', requirePermissionAndScope('casas.editar'), ...)
 * 
 * @param {string} permission - Permiso requerido
 * @returns {Function} Express middleware
 */
const requirePermissionAndScope = (permission) => async (req, res, next) => {
  // Ejecutar requirePermission primero
  await new Promise((resolve, reject) => {
    requirePermission(permission)(req, res, (err) => {
      if (err) reject(err);
      else resolve();
    });
  }).catch(() => {
    return;  // requirePermission ya envió la respuesta
  });

  // Si pasó, ejecutar requireScope
  requireScope(req, res, next);
};

/**
 * Middleware: Verifica nivel de prioridad mínimo
 * Útil para operaciones críticas que requieren admin de alto nivel
 * 
 * @param {number} minLevel - Nivel mínimo requerido (ej: 80)
 * @returns {Function} Express middleware
 */
const requireMinLevel = (minLevel) => (req, res, next) => {
  try {
    if (!req.session || !req.session.guardia) {
      return res.status(401).json({ 
        success: false, 
        error: 'No autenticado',
        code: 'AUTH_REQUIRED'
      });
    }

    const user = req.session.guardia;
    const userLevel = user.nivel_prioridad || 0;

    if (userLevel < minLevel) {
      return res.status(403).json({ 
        success: false, 
        error: 'Nivel de autorización insuficiente',
        required_level: minLevel,
        user_level: userLevel,
        code: 'LEVEL_DENIED'
      });
    }

    req.user = user;
    next();

  } catch (error) {
    console.error('❌ Error en requireMinLevel:', error);
    return res.status(500).json({ 
      success: false, 
      error: 'Error al verificar nivel',
      code: 'LEVEL_CHECK_ERROR'
    });
  }
};

module.exports = {
  requirePermission,
  requireRole,
  requireScope,
  requirePermissionAndScope,
  requireMinLevel
};
