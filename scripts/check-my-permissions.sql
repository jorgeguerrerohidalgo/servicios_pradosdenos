-- ========================================
-- Verificación SIMPLE: ¿Tengo permisos para ver roles?
-- ========================================
-- Ejecutar en Supabase SQL Editor

SET timezone = 'America/Santiago';

-- 1. ¿Qué roles tengo asignados?
SELECT 
  '1. MIS ROLES ASIGNADOS' as info,
  u.nombre,
  u.email,
  r.nombre as rol,
  r.nivel_prioridad,
  ur.activo as rol_activo
FROM admin_users u
INNER JOIN user_roles ur ON u.id = ur.user_id
INNER JOIN roles r ON ur.role_id = r.id
WHERE u.activo = TRUE
ORDER BY r.nivel_prioridad DESC;

-- 2. ¿Qué permisos tengo?
SELECT 
  '2. MIS PERMISOS' as info,
  u.email,
  p.codigo as permiso,
  p.modulo
FROM admin_users u
INNER JOIN user_roles ur ON u.id = ur.user_id AND ur.activo = TRUE
INNER JOIN role_permissions rp ON ur.role_id = rp.role_id
INNER JOIN permissions p ON rp.permission_id = p.id
WHERE u.activo = TRUE
ORDER BY u.email, p.modulo, p.codigo;

-- 3. ¿Tengo el permiso específico 'roles.leer'?
SELECT 
  '3. ¿TENGO ACCESO A ROLES?' as pregunta,
  CASE 
    WHEN COUNT(*) > 0 THEN '✅ SÍ - Deberías ver Gestión de Roles'
    ELSE '❌ NO - Necesitas rol Super Admin o Administrador'
  END as respuesta,
  COUNT(*) as permisos_encontrados
FROM admin_users u
INNER JOIN user_roles ur ON u.id = ur.user_id AND ur.activo = TRUE
INNER JOIN role_permissions rp ON ur.role_id = rp.role_id
INNER JOIN permissions p ON rp.permission_id = p.id
WHERE u.activo = TRUE
  AND (p.codigo = 'roles.leer' OR p.codigo = '*.*');

-- 4. Estado de mi sesión
SELECT 
  '4. ESTADO DE MI SESIÓN' as info,
  u.nombre,
  u.email,
  u.last_login as ultimo_login,
  u.ultimo_cambio_permisos,
  CASE 
    WHEN u.ultimo_cambio_permisos IS NULL THEN '⚠️ Permisos nunca asignados'
    WHEN u.last_login IS NULL THEN '⚠️ Nunca iniciaste sesión'
    WHEN u.last_login < u.ultimo_cambio_permisos THEN '❌ DEBES CERRAR SESIÓN Y VOLVER A ENTRAR'
    ELSE '✅ Sesión actualizada con permisos frescos'
  END as accion_requerida
FROM admin_users u
WHERE u.activo = TRUE
ORDER BY u.id;
