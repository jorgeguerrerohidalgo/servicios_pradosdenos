/**
 * =============================================
 * MIDDLEWARE: Scoping Automático por Plaza
 * =============================================
 * Filtra automáticamente las consultas SQL basándose en el alcance del usuario
 * 
 * @author Sistema
 * @date 20/05/2026
 */

/**
 * Obtiene las plazas permitidas para el usuario
 * @param {Object} user - Usuario de sesión (req.session.guardia)
 * @returns {Array<number>|null} - Array de plaza_ids permitidos, o null si tiene acceso global
 */
function getAllowedPlazas(user) {
  // Super Admin y Administrador sin scopes = acceso global
  if (!user.scopes || user.scopes.length === 0) {
    // Si nivel >= 80 y sin scopes = acceso global
    if (user.nivel_prioridad >= 80) {
      return null;  // null = todas las plazas
    }
    // Si nivel < 80 sin scopes = sin acceso (no debería pasar)
    return [];
  }

  // Extraer plaza_ids de los scopes tipo 'plaza'
  const plazaIds = user.scopes
    .filter(s => s.scope_type === 'plaza')
    .map(s => parseInt(s.scope_id))
    .filter(id => !isNaN(id));

  // Si tiene scopes pero ninguno es de plaza = sin acceso a plazas
  if (plazaIds.length === 0) {
    return [];
  }

  return plazaIds;
}

/**
 * Middleware que inyecta las plazas permitidas en req.allowedPlazas
 * Uso: router.get('/casas', applyScoping, async (req, res) => { ... })
 */
const applyScoping = (req, res, next) => {
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
    
    // Inyectar plazas permitidas en request
    req.allowedPlazas = getAllowedPlazas(user);
    req.user = user;
    
    next();
  } catch (error) {
    console.error('❌ Error en applyScoping:', error);
    return res.status(500).json({ 
      success: false, 
      error: 'Error al aplicar filtros de alcance',
      code: 'SCOPING_ERROR'
    });
  }
};

/**
 * Construye cláusula SQL WHERE para filtrar por plazas permitidas
 * @param {Array<number>|null} allowedPlazas - Salida de getAllowedPlazas()
 * @param {string} tableAlias - Alias de la tabla (ej: 'c' para casas)
 * @param {Array} params - Array de parámetros SQL existentes
 * @returns {Object} { sql: string, params: Array } - SQL y params actualizados
 */
function buildPlazaFilter(allowedPlazas, tableAlias = '', params = []) {
  // Acceso global = sin filtro
  if (allowedPlazas === null) {
    return { sql: '', params };
  }

  // Sin acceso = filtro imposible (plaza_id = -1)
  if (!Array.isArray(allowedPlazas) || allowedPlazas.length === 0) {
    const prefix = tableAlias ? `${tableAlias}.` : '';
    return { 
      sql: ` AND ${prefix}plaza_id = -1`,  // Nunca retornará resultados
      params 
    };
  }

  // Acceso a plazas específicas
  const prefix = tableAlias ? `${tableAlias}.` : '';
  const paramIndex = params.length + 1;
  
  return {
    sql: ` AND ${prefix}plaza_id = ANY($${paramIndex})`,
    params: [...params, allowedPlazas]
  };
}

/**
 * Valida si el usuario tiene acceso a una plaza específica
 * @param {Array<number>|null} allowedPlazas - Salida de getAllowedPlazas()
 * @param {number} plazaId - ID de plaza a verificar
 * @returns {boolean} - true si tiene acceso
 */
function hasPlazaAccess(allowedPlazas, plazaId) {
  // Acceso global
  if (allowedPlazas === null) {
    return true;
  }

  // Sin acceso
  if (!Array.isArray(allowedPlazas) || allowedPlazas.length === 0) {
    return false;
  }

  // Verificar si está en la lista
  return allowedPlazas.includes(parseInt(plazaId));
}

module.exports = {
  applyScoping,
  getAllowedPlazas,
  buildPlazaFilter,
  hasPlazaAccess
};
