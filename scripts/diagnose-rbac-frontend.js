/**
 * DIAGNÓSTICO RBAC FRONTEND
 * Ejecutar en la consola del navegador (F12 → Console)
 * Pegar este código y presionar Enter
 */

console.log('🔍 INICIANDO DIAGNÓSTICO RBAC...\n');

// 1. Verificar que rbac-helper.js está cargado
console.log('=== 1. ARCHIVOS CARGADOS ===');
console.log('✓ loadUserPermissions existe:', typeof loadUserPermissions !== 'undefined');
console.log('✓ hasPermission existe:', typeof hasPermission !== 'undefined');
console.log('✓ applyMenuPermissions existe:', typeof applyMenuPermissions !== 'undefined');
console.log('✓ UserPermissions global:', typeof window.UserPermissions !== 'undefined');
console.log('');

// 2. Estado de permisos cargados
console.log('=== 2. ESTADO DE PERMISOS ===');
if (window.UserPermissions) {
    console.log('Permisos cargados:', window.UserPermissions.loaded);
    console.log('Cantidad de permisos:', window.UserPermissions.permissions.length);
    console.log('Roles:', window.UserPermissions.roles);
    console.log('Nivel prioridad:', window.UserPermissions.nivel_prioridad);
    console.log('Lista de permisos:', window.UserPermissions.permissions);
} else {
    console.log('❌ window.UserPermissions no existe');
}
console.log('');

// 3. Verificar permiso específico para roles
console.log('=== 3. PERMISO ESPECÍFICO ===');
if (typeof hasPermission !== 'undefined') {
    console.log('Tiene permiso roles.leer:', hasPermission('roles.leer'));
    console.log('Tiene wildcard *.*:', hasPermission('*.*'));
    console.log('Tiene wildcard roles.*:', hasPermission('roles.*'));
} else {
    console.log('❌ Función hasPermission no disponible');
}
console.log('');

// 4. Verificar si la sección existe en el DOM
console.log('=== 4. ELEMENTOS DEL DOM ===');
const rolesSection = document.getElementById('rolesSection');
console.log('Sección rolesSection existe:', rolesSection !== null);
if (rolesSection) {
    console.log('Clases de rolesSection:', rolesSection.className);
    console.log('Está visible:', !rolesSection.classList.contains('section-hidden'));
}

const rolesLink = document.querySelector('a[onclick*="showSection(\'roles\')"]');
console.log('Link del menú existe:', rolesLink !== null);
if (rolesLink) {
    console.log('Display del link:', rolesLink.style.display);
    console.log('Texto del link:', rolesLink.textContent.trim());
}
console.log('');

// 5. Verificar mapping de secciones
console.log('=== 5. CONFIGURACIÓN DE SECCIONES ===');
if (typeof SECTION_PERMISSIONS !== 'undefined') {
    console.log('SECTION_PERMISSIONS[\'roles\']:', SECTION_PERMISSIONS['roles']);
} else {
    console.log('❌ SECTION_PERMISSIONS no definido');
}
console.log('');

// 6. Verificar sesión de usuario
console.log('=== 6. VERIFICAR SESIÓN ===');
fetch('/api/auth/check', { credentials: 'include' })
    .then(res => res.json())
    .then(data => {
        console.log('Autenticado:', data.isAuthenticated);
        if (data.guardia) {
            console.log('Usuario:', data.guardia.nombre);
            console.log('Email:', data.guardia.email);
            console.log('Permisos en sesión:', data.guardia.permissions);
            console.log('Roles en sesión:', data.guardia.roles);
            console.log('Nivel prioridad en sesión:', data.guardia.nivel_prioridad);
            
            // Verificar si tiene el permiso
            const tienePermiso = data.guardia.permissions.includes('roles.leer') || 
                                data.guardia.permissions.includes('*.*') ||
                                data.guardia.permissions.includes('roles.*');
            console.log('');
            console.log('🎯 RESULTADO: ', tienePermiso ? 
                '✅ TIENES EL PERMISO - El menú debería aparecer' : 
                '❌ NO TIENES EL PERMISO - Necesitas rol Super Admin');
        }
    })
    .catch(err => console.error('Error verificando sesión:', err));

console.log('');
console.log('=== 7. RECOMENDACIÓN ===');
console.log('Si ves ❌ en cualquier sección arriba:');
console.log('1. Cierra sesión completamente');
console.log('2. Vuelve a iniciar sesión');
console.log('3. Ejecuta este script nuevamente');
console.log('');
console.log('Si después de re-login sigue fallando:');
console.log('1. Ejecuta scripts/check-my-permissions.sql en Supabase');
console.log('2. Verifica que tienes rol Super Usuario o Administrador');
console.log('3. Limpia caché del navegador: Ctrl+Shift+R');
