-- ========================================
-- Verificación: Sesión y Permisos RBAC
-- ========================================
-- Fecha: 19/05/2026
-- Descripción: Verificar qué usuarios tienen acceso a la UI de roles
-- Ejecutar en Supabase SQL Editor para diagnosticar problemas

SET timezone = 'America/Santiago';

-- 1. Verificar usuarios con roles activos
SELECT 
  '=== USUARIOS CON ROLES ===' as seccion;

SELECT 
  u.id,
  u.nombre,
  u.email,
  r.nombre as rol,
  r.nivel_prioridad,
  CASE 
    WHEN ur.scope_type IS NULL THEN 'Global'
    ELSE ur.scope_type || ': ' || COALESCE(p.nombre, ur.scope_id::TEXT)
  END as alcance
FROM admin_users u
INNER JOIN user_roles ur ON u.id = ur.user_id
INNER JOIN roles r ON ur.role_id = r.id
LEFT JOIN plazas p ON ur.scope_id = p.id AND ur.scope_type = 'plaza'
WHERE ur.activo = TRUE AND u.activo = TRUE
ORDER BY r.nivel_prioridad DESC, u.nombre;

-- 2. Verificar permisos específicos de roles
SELECT 
  '=== PERMISOS DE ROLES (roles.*) ===' as seccion;

SELECT 
  r.nombre as rol,
  p.codigo as permiso,
  p.descripcion
FROM roles r
INNER JOIN role_permissions rp ON r.id = rp.role_id
INNER JOIN permissions p ON rp.permission_id = p.id
WHERE p.codigo LIKE 'roles.%'
ORDER BY r.nivel_prioridad DESC, p.codigo;

-- 3. Verificar qué usuarios tienen permiso 'roles.leer'
SELECT 
  '=== USUARIOS CON ACCESO A UI DE ROLES ===' as seccion;

SELECT 
  u.nombre,
  u.email,
  r.nombre as rol,
  STRING_AGG(p.codigo, ', ') as permisos_roles
FROM admin_users u
INNER JOIN user_roles ur ON u.id = ur.user_id AND ur.activo = TRUE
INNER JOIN roles r ON ur.role_id = r.id
INNER JOIN role_permissions rp ON r.id = rp.role_id
INNER JOIN permissions p ON rp.permission_id = p.id
WHERE (p.codigo LIKE 'roles.%' OR p.codigo = '*.*')
  AND u.activo = TRUE
GROUP BY u.id, u.nombre, u.email, r.nombre
ORDER BY r.nivel_prioridad DESC;

-- 4. Verificar timestamp de último cambio de permisos
SELECT 
  '=== ÚLTIMO CAMBIO DE PERMISOS ===' as seccion;

SELECT 
  u.nombre,
  u.email,
  u.ultimo_cambio_permisos,
  u.last_login,
  CASE 
    WHEN u.ultimo_cambio_permisos IS NULL THEN '⚠️ Nunca asignado'
    WHEN u.last_login IS NULL THEN '⚠️ Nunca ha iniciado sesión'
    WHEN u.last_login < u.ultimo_cambio_permisos THEN '❌ Requiere re-login (cambios después del último login)'
    ELSE '✅ Sesión actualizada'
  END as estado_sesion
FROM admin_users u
WHERE u.activo = TRUE
ORDER BY u.id;

-- 5. Listar todos los permisos del módulo 'roles'
SELECT 
  '=== PERMISOS DISPONIBLES PARA ROLES ===' as seccion;

SELECT 
  codigo,
  descripcion,
  activo
FROM permissions
WHERE modulo = 'roles'
ORDER BY codigo;

-- 6. Auditoría reciente de cambios en roles
SELECT 
  '=== AUDITORÍA RECIENTE (últimas 10 acciones) ===' as seccion;

SELECT 
  pa.created_at,
  u.nombre as usuario,
  pa.accion,
  target.nombre as afectado,
  r.nombre as rol,
  pa.motivo
FROM permission_audit pa
LEFT JOIN admin_users u ON pa.user_id = u.id
LEFT JOIN admin_users target ON pa.target_user_id = target.id
LEFT JOIN roles r ON pa.role_id = r.id
ORDER BY pa.created_at DESC
LIMIT 10;
