/**
 * RBAC HELPER - Frontend
 * Sistema de control de permisos para el frontend
 * Autor: Sistema
 * Fecha: 19/05/2026
 */

// Estado global de permisos
window.UserPermissions = {
    permissions: [],
    roles: [],
    nivel_prioridad: 0,
    scopes: [],
    loaded: false
};

/**
 * Cargar permisos del usuario desde la sesión
 * @returns {Promise<boolean>} true si se cargaron correctamente
 */
async function loadUserPermissions() {
    try {
        console.log('🔐 Cargando permisos del usuario...');
        
        const response = await fetch('/api/auth/check', {
            method: 'GET',
            credentials: 'include'
        });
        
        if (!response.ok) {
            console.error('❌ Error cargando permisos:', response.status);
            return false;
        }
        
        const sessionData = await response.json();
        
        if (sessionData.isAuthenticated && sessionData.guardia) {
            // Guardar permisos en el objeto global
            window.UserPermissions.permissions = sessionData.guardia.permissions || [];
            window.UserPermissions.roles = sessionData.guardia.roles || [];
            window.UserPermissions.nivel_prioridad = sessionData.guardia.nivel_prioridad || 0;
            window.UserPermissions.scopes = sessionData.guardia.scopes || [];
            window.UserPermissions.loaded = true;
            
            console.log('✅ Permisos cargados:', {
                permissions: window.UserPermissions.permissions.length,
                roles: window.UserPermissions.roles.length,
                nivel: window.UserPermissions.nivel_prioridad,
                scopes: window.UserPermissions.scopes.length
            });
            
            return true;
        }
        
        console.warn('⚠️ No se encontraron permisos en la sesión');
        return false;
        
    } catch (error) {
        console.error('❌ Error cargando permisos:', error);
        return false;
    }
}

/**
 * Verificar si el usuario tiene un permiso específico
 * Soporta wildcards: *.* (total), modulo.* (módulo completo)
 * @param {string} permission - Permiso a verificar (ej: 'guardias.crear')
 * @returns {boolean}
 */
function hasPermission(permission) {
    if (!window.UserPermissions.loaded) {
        console.warn('⚠️ Permisos no cargados aún');
        return false;
    }
    
    const userPermissions = window.UserPermissions.permissions;
    
    // Sin permisos = sin acceso
    if (!userPermissions || userPermissions.length === 0) {
        return false;
    }
    
    // Verificar wildcard total
    if (userPermissions.includes('*.*')) {
        return true;
    }
    
    // Verificar permiso exacto
    if (userPermissions.includes(permission)) {
        return true;
    }
    
    // Verificar wildcard de módulo (ej: guardias.* permite guardias.crear)
    const [modulo, accion] = permission.split('.');
    const moduleWildcard = `${modulo}.*`;
    
    if (userPermissions.includes(moduleWildcard)) {
        return true;
    }
    
    return false;
}

/**
 * Verificar si el usuario tiene alguno de los permisos listados
 * @param {string[]} permissions - Array de permisos
 * @returns {boolean}
 */
function hasAnyPermission(...permissions) {
    return permissions.some(perm => hasPermission(perm));
}

/**
 * Verificar si el usuario tiene todos los permisos listados
 * @param {string[]} permissions - Array de permisos
 * @returns {boolean}
 */
function hasAllPermissions(...permissions) {
    return permissions.every(perm => hasPermission(perm));
}

/**
 * Verificar si el usuario tiene un rol específico
 * @param {string} roleCodigo - Código del rol (ej: 'super_admin')
 * @returns {boolean}
 */
function hasRole(roleCodigo) {
    if (!window.UserPermissions.loaded) {
        return false;
    }
    
    return window.UserPermissions.roles.some(role => role.codigo === roleCodigo);
}

/**
 * Verificar si el nivel de prioridad del usuario es mayor o igual al especificado
 * @param {number} minLevel - Nivel mínimo requerido (100=super_admin, 80=admin, etc.)
 * @returns {boolean}
 */
function hasMinLevel(minLevel) {
    if (!window.UserPermissions.loaded) {
        return false;
    }
    
    return window.UserPermissions.nivel_prioridad >= minLevel;
}

/**
 * Ocultar/mostrar elemento basado en permiso
 * @param {string} elementId - ID del elemento HTML
 * @param {string} permission - Permiso requerido
 */
function toggleElementByPermission(elementId, permission) {
    const element = document.getElementById(elementId);
    if (!element) {
        console.warn(`⚠️ Elemento no encontrado: ${elementId}`);
        return;
    }
    
    if (hasPermission(permission)) {
        element.style.display = '';
        element.removeAttribute('disabled');
    } else {
        element.style.display = 'none';
    }
}

/**
 * Deshabilitar elemento si no tiene permiso (pero mantenerlo visible)
 * @param {string} elementId - ID del elemento HTML
 * @param {string} permission - Permiso requerido
 */
function disableElementByPermission(elementId, permission) {
    const element = document.getElementById(elementId);
    if (!element) {
        console.warn(`⚠️ Elemento no encontrado: ${elementId}`);
        return;
    }
    
    if (!hasPermission(permission)) {
        element.setAttribute('disabled', 'true');
        element.classList.add('disabled');
        element.title = 'No tienes permisos para esta acción';
    } else {
        element.removeAttribute('disabled');
        element.classList.remove('disabled');
        element.title = '';
    }
}

/**
 * Filtrar menú lateral basado en permisos
 * Mapeo de secciones a permisos requeridos
 */
const SECTION_PERMISSIONS = {
    'dashboard': 'dashboard.leer',
    'eventos': 'eventos.leer',
    'documentos': 'documentos.leer',
    'guardias': 'guardias.leer',
    'plazas': 'plazas.leer',
    'admins': 'administradores.leer',
    'casas': 'casas.leer',
    'residentes': 'residentes.leer',
    'mascotas': 'mascotas.leer',
    'pagos': 'pagos.leer',
    'vehiculos': 'vehiculos.leer',
    'acceso': 'acceso.leer',
    'reportes': 'reportes.leer',
    'qr-plazas': 'tokens.leer',
    'generar-tokens': 'tokens.crear',
    'roles': 'roles.leer'  // Fase 5: Gestión de Roles
};

/**
 * Aplicar filtrado de menú basado en permisos
 */
function applyMenuPermissions() {
    console.log('🔐 Aplicando permisos al menú...');
    
    const navLinks = document.querySelectorAll('.sidebar .nav-link[onclick*="showSection"]');
    let hiddenCount = 0;
    
    navLinks.forEach(link => {
        // Extraer nombre de sección del onclick
        const onclickAttr = link.getAttribute('onclick');
        const match = onclickAttr.match(/showSection\('(.+?)'\)/);
        
        if (match) {
            const sectionName = match[1];
            const requiredPermission = SECTION_PERMISSIONS[sectionName];
            
            if (requiredPermission) {
                if (hasPermission(requiredPermission)) {
                    link.style.display = '';
                } else {
                    link.style.display = 'none';
                    hiddenCount++;
                }
            }
        }
    });
    
    console.log(`✅ Menú filtrado: ${hiddenCount} elementos ocultos`);
}

/**
 * Aplicar permisos a los botones de acción (Nuevo, Editar, Eliminar)
 * Debe llamarse después de renderizar cada tabla
 * @param {string} modulo - Nombre del módulo (ej: 'eventos', 'guardias')
 */
function applyButtonPermissions(modulo) {
    console.log(`🔐 Aplicando permisos de botones para módulo: ${modulo}`);
    
    // Permisos necesarios para cada acción
    const permissions = {
        crear: `${modulo}.crear`,
        editar: `${modulo}.editar`,
        eliminar: `${modulo}.eliminar`
    };
    
    // Ocultar botón "Nuevo/Crear" si no tiene permiso de crear
    const createButtons = document.querySelectorAll(`[onclick*="show${capitalize(modulo)}Form"]`);
    createButtons.forEach(btn => {
        if (!hasPermission(permissions.crear)) {
            btn.style.display = 'none';
        }
    });
    
    // Ocultar/deshabilitar botones de editar
    const editButtons = document.querySelectorAll(`.edit-${modulo}-btn`);
    editButtons.forEach(btn => {
        if (!hasPermission(permissions.editar)) {
            btn.style.display = 'none';
        }
    });
    
    // Ocultar/deshabilitar botones de eliminar
    const deleteButtons = document.querySelectorAll(`.delete-${modulo}-btn`);
    deleteButtons.forEach(btn => {
        if (!hasPermission(permissions.eliminar)) {
            btn.style.display = 'none';
        }
    });
}

/**
 * Capitalizar primera letra
 * @param {string} str 
 * @returns {string}
 */
function capitalize(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
}

/**
 * Mostrar mensaje de permiso denegado
 * @param {string} accion - Acción que requería permiso
 */
function showPermissionDenied(accion = 'realizar esta acción') {
    Swal.fire({
        title: 'Permiso Denegado',
        text: `No tienes permisos para ${accion}`,
        icon: 'warning',
        confirmButtonText: 'Entendido'
    });
}

/**
 * Wrapper para funciones que requieren permiso
 * @param {string} permission - Permiso requerido
 * @param {Function} func - Función a ejecutar
 * @param {string} accion - Descripción de la acción (para mensaje de error)
 * @returns {Function}
 */
function requirePermission(permission, func, accion) {
    return function(...args) {
        if (hasPermission(permission)) {
            return func.apply(this, args);
        } else {
            showPermissionDenied(accion);
            return null;
        }
    };
}

/**
 * Inicializar sistema RBAC en el frontend
 * Debe llamarse después de verificar la sesión
 */
async function initializeRBAC() {
    console.log('🚀 Inicializando sistema RBAC en frontend...');
    
    const loaded = await loadUserPermissions();
    
    if (loaded) {
        // Aplicar permisos al menú
        applyMenuPermissions();
        
        console.log('✅ Sistema RBAC inicializado correctamente');
        return true;
    } else {
        console.error('❌ No se pudieron cargar los permisos del usuario');
        return false;
    }
}

/**
 * Obtener información de permisos para debugging
 * @returns {object}
 */
function getPermissionsInfo() {
    return {
        loaded: window.UserPermissions.loaded,
        permissions_count: window.UserPermissions.permissions.length,
        permissions: window.UserPermissions.permissions,
        roles: window.UserPermissions.roles.map(r => r.nombre),
        nivel_prioridad: window.UserPermissions.nivel_prioridad,
        scopes: window.UserPermissions.scopes,
        is_super_admin: hasRole('super_admin'),
        is_admin: hasMinLevel(80)
    };
}

// Exponer funciones globalmente
window.loadUserPermissions = loadUserPermissions;
window.hasPermission = hasPermission;
window.hasAnyPermission = hasAnyPermission;
window.hasAllPermissions = hasAllPermissions;
window.hasRole = hasRole;
window.hasMinLevel = hasMinLevel;
window.toggleElementByPermission = toggleElementByPermission;
window.disableElementByPermission = disableElementByPermission;
window.applyMenuPermissions = applyMenuPermissions;
window.applyButtonPermissions = applyButtonPermissions;
window.showPermissionDenied = showPermissionDenied;
window.requirePermission = requirePermission;
window.initializeRBAC = initializeRBAC;
window.getPermissionsInfo = getPermissionsInfo;

console.log('✅ RBAC Helper cargado correctamente');
