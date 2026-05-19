/**
 * =============================================
 * UTILS: Permissions Helper
 * =============================================
 * Funciones para gestionar permisos de usuarios en el sistema RBAC
 * 
 * @author Sistema
 * @date 19/05/2026
 */

const pool = require('../config/database');

/**
 * Obtiene todos los permisos efectivos de un usuario
 * @param {number} userId - ID del usuario
 * @returns {Promise<string[]>} Array de códigos de permisos (ej: ['guardias.crear', 'pagos.*'])
 */
async function getUserPermissions(userId) {
  try {
    const query = `
      SELECT DISTINCT p.codigo
      FROM permissions p
      INNER JOIN role_permissions rp ON p.id = rp.permission_id
      INNER JOIN user_roles ur ON rp.role_id = ur.role_id
      WHERE ur.user_id = $1 
        AND ur.activo = TRUE 
        AND p.activo = TRUE
        AND (ur.expira_en IS NULL OR ur.expira_en > NOW())
      ORDER BY p.codigo
    `;
    
    const result = await pool.query(query, [userId]);
    return result.rows.map(r => r.codigo);
  } catch (error) {
    console.error('❌ Error al obtener permisos de usuario:', error);
    return [];
  }
}

/**
 * Obtiene roles activos de un usuario con scoping
 * @param {number} userId - ID del usuario
 * @returns {Promise<Array>} Array de roles con información de scope
 */
async function getUserRoles(userId) {
  try {
    const query = `
      SELECT 
        r.id, 
        r.codigo, 
        r.nombre, 
        r.nivel_prioridad,
        ur.scope_type, 
        ur.scope_id,
        ur.expira_en,
        p.nombre as plaza_nombre
      FROM roles r
      INNER JOIN user_roles ur ON r.id = ur.role_id
      LEFT JOIN plazas p ON ur.scope_id = p.id AND ur.scope_type = 'plaza'
      WHERE ur.user_id = $1 
        AND ur.activo = TRUE 
        AND r.activo = TRUE
        AND (ur.expira_en IS NULL OR ur.expira_en > NOW())
      ORDER BY r.nivel_prioridad DESC
    `;
    
    const result = await pool.query(query, [userId]);
    return result.rows;
  } catch (error) {
    console.error('❌ Error al obtener roles de usuario:', error);
    return [];
  }
}

/**
 * Verifica si usuario tiene un permiso específico
 * Soporta wildcards: 'pagos.*' incluye 'pagos.crear', 'pagos.editar'
 * 
 * @param {string[]} userPermissions - Array de permisos del usuario
 * @param {string} requiredPermission - Permiso requerido (ej: 'guardias.crear')
 * @returns {boolean} true si tiene el permiso
 */
function hasPermission(userPermissions, requiredPermission) {
  if (!userPermissions || userPermissions.length === 0) {
    return false;
  }

  return userPermissions.some(p => {
    // Permiso exacto
    if (p === requiredPermission) return true;
    
    // Super admin (wildcard total)
    if (p === '*.*') return true;
    
    // Wildcard de módulo (ej: 'pagos.*' incluye 'pagos.crear', 'pagos.editar')
    if (p.endsWith('.*')) {
      const module = p.slice(0, -2);  // Quitar '.*'
      return requiredPermission.startsWith(module + '.');
    }
    
    return false;
  });
}

/**
 * Verifica si usuario tiene acceso al scope especificado
 * @param {Object} user - Objeto de usuario con roles y scopes
 * @param {number} resourcePlazaId - ID de plaza del recurso a acceder
 * @returns {boolean} true si tiene acceso
 */
function checkScope(user, resourcePlazaId) {
  // Super admin (nivel >= 100) tiene acceso global automático
  if (user.nivel_prioridad >= 100) {
    return true;
  }

  // Si no hay scopes definidos, asumir acceso global (usuarios legacy)
  if (!user.scopes || user.scopes.length === 0) {
    // Admin global (nivel >= 80 sin scope específico)
    return user.nivel_prioridad >= 80;
  }

  // Si recurso no especifica plaza, permitir acceso
  if (!resourcePlazaId) {
    return true;
  }

  // Verificar si usuario tiene scope global (scope_type = NULL)
  const tieneGlobal = user.scopes.some(s => !s.scope_type);
  if (tieneGlobal && user.nivel_prioridad >= 80) {
    return true;
  }

  // Verificar si usuario tiene acceso a esa plaza específica
  const tieneAccesoPlaza = user.scopes.some(s => 
    s.scope_type === 'plaza' && s.scope_id === parseInt(resourcePlazaId)
  );

  return tieneAccesoPlaza;
}

/**
 * Obtiene el nivel de prioridad más alto de un usuario
 * @param {Array} roles - Array de roles del usuario
 * @returns {number} Nivel de prioridad (0-100)
 */
function getMaxPriority(roles) {
  if (!roles || roles.length === 0) return 0;
  return Math.max(...roles.map(r => r.nivel_prioridad || 0));
}

/**
 * Verifica si usuario tiene un rol específico
 * @param {Array} userRoles - Array de roles del usuario
 * @param {string} roleCodigo - Código del rol a verificar
 * @returns {boolean} true si tiene el rol
 */
function hasRole(userRoles, roleCodigo) {
  if (!userRoles || userRoles.length === 0) return false;
  return userRoles.some(r => r.codigo === roleCodigo || r === roleCodigo);
}

/**
 * Filtra recursos por plaza según scopes del usuario
 * @param {Object} user - Objeto de usuario con scopes
 * @returns {string} Fragmento SQL para WHERE clause (ej: "AND plaza_id IN (1, 2)")
 */
function getScopeSQLFilter(user) {
  // Super admin o admin global: sin filtro
  if (user.nivel_prioridad >= 100) {
    return '';
  }

  if (user.nivel_prioridad >= 80 && (!user.scopes || user.scopes.length === 0)) {
    return '';
  }

  // Filtrar por plazas asignadas
  const plazaIds = user.scopes
    .filter(s => s.scope_type === 'plaza' && s.scope_id)
    .map(s => s.scope_id);

  if (plazaIds.length === 0) {
    return 'AND 1=0';  // Sin acceso a ninguna plaza
  }

  return `AND plaza_id IN (${plazaIds.join(',')})`;
}

/**
 * Obtiene IDs de plazas a las que el usuario tiene acceso
 * @param {Object} user - Objeto de usuario con scopes
 * @returns {number[]|null} Array de plaza IDs, o null si tiene acceso global
 */
function getAllowedPlazaIds(user) {
  // Acceso global
  if (user.nivel_prioridad >= 100) {
    return null;  // null = todas las plazas
  }

  if (user.nivel_prioridad >= 80 && (!user.scopes || user.scopes.length === 0)) {
    return null;
  }

  // Extraer IDs de plazas
  const plazaIds = user.scopes
    .filter(s => s.scope_type === 'plaza' && s.scope_id)
    .map(s => s.scope_id);

  return plazaIds.length > 0 ? plazaIds : [];
}

module.exports = {
  getUserPermissions,
  getUserRoles,
  hasPermission,
  checkScope,
  getMaxPriority,
  hasRole,
  getScopeSQLFilter,
  getAllowedPlazaIds
};
