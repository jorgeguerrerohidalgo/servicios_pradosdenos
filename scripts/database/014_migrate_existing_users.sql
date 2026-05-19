-- ========================================
-- MIGRACIÓN 014: Migrar Usuarios Existentes a RBAC
-- ========================================
-- Descripción: Asignar roles a usuarios existentes del sistema
-- Autor: Sistema
-- Fecha: 19/05/2026
-- Cambios:
--   - Asignar roles a admin_users existentes
--   - Convertir guardias a sistema de roles
--   - Configurar scoping por plaza
-- ========================================

SET timezone = 'America/Santiago';

-- =============================================
-- ESTRATEGIA DE MIGRACIÓN
-- =============================================
-- 1. Primer admin_user → super_admin (global)
-- 2. Demás admin_users → administrador (por plaza si tienen plaza_id)
-- 3. Todos los guardias → rol guardia (con scope a su plaza)

-- =============================================
-- ASIGNAR ROLES A ADMIN_USERS
-- =============================================

-- Paso 1: Asignar super_admin al primer usuario creado (ID más bajo)
INSERT INTO user_roles (user_id, role_id, scope_type, scope_id, asignado_por, asignado_en, activo)
SELECT 
  u.id as user_id,
  r.id as role_id,
  NULL as scope_type,      -- Acceso global
  NULL as scope_id,
  u.id as asignado_por,    -- Auto-asignado (migración)
  NOW() as asignado_en,
  TRUE as activo
FROM admin_users u
CROSS JOIN roles r
WHERE u.id = (SELECT MIN(id) FROM admin_users WHERE activo = TRUE)
  AND r.codigo = 'super_admin'
  AND u.activo = TRUE
ON CONFLICT (user_id, role_id) DO NOTHING;

-- Paso 2: Asignar administrador a los demás admin_users
-- Si tienen plaza_id, asignar con scope de plaza
-- Si NO tienen plaza_id, asignar con scope global
INSERT INTO user_roles (user_id, role_id, scope_type, scope_id, asignado_por, asignado_en, activo)
SELECT 
  u.id as user_id,
  r.id as role_id,
  CASE 
    WHEN u.plaza_id IS NOT NULL THEN 'plaza'
    ELSE NULL 
  END as scope_type,
  u.plaza_id as scope_id,
  (SELECT MIN(id) FROM admin_users WHERE activo = TRUE) as asignado_por,  -- Asignado por super_admin
  NOW() as asignado_en,
  TRUE as activo
FROM admin_users u
CROSS JOIN roles r
WHERE u.id != (SELECT MIN(id) FROM admin_users WHERE activo = TRUE)  -- Excluir al super_admin ya asignado
  AND r.codigo = 'administrador'
  AND u.activo = TRUE
ON CONFLICT (user_id, role_id) DO NOTHING;

-- =============================================
-- NOTA: GUARDIAS
-- =============================================
-- Los guardias NO se migran a admin_users porque tienen estructuras incompatibles:
-- - guardias: solo tiene campo "nombre" (nombre completo)
-- - admin_users: requiere apellido_paterno (NOT NULL) y apellido_materno (NOT NULL)
-- 
-- El sistema de autenticación YA busca en ambas tablas (admin_users y guardias)
-- Si en el futuro se necesita asignar roles a guardias específicos, se puede:
-- 1. Crear manualmente el usuario en admin_users con apellidos separados
-- 2. Asignar el rol guardia a ese usuario
-- 3. O modificar la tabla guardias para agregar apellido_paterno/materno

-- =============================================
-- ACTUALIZAR TIMESTAMPS
-- =============================================

-- Marcar que los usuarios tuvieron cambios de permisos
UPDATE admin_users
SET ultimo_cambio_permisos = NOW()
WHERE id IN (SELECT user_id FROM user_roles);

-- =============================================
-- REGISTRAR AUDITORÍA
-- =============================================

-- Registrar migración en auditoría
INSERT INTO permission_audit (user_id, accion, motivo, ip_address, created_at)
SELECT 
  (SELECT MIN(id) FROM admin_users WHERE activo = TRUE) as user_id,
  'migracion_rbac' as accion,
  'Migración automática de usuarios existentes al sistema RBAC' as motivo,
  '127.0.0.1' as ip_address,
  NOW() as created_at;

-- =============================================
-- VERIFICACIÓN
-- =============================================
SELECT 'Migración 014 ejecutada correctamente' as resultado;

-- Ver usuarios con sus roles asignados
SELECT 
  u.id,
  u.nombre,
  u.email,
  r.nombre as rol,
  r.nivel_prioridad,
  CASE 
    WHEN ur.scope_type IS NULL THEN 'Global'
    WHEN ur.scope_type = 'plaza' THEN 'Plaza: ' || COALESCE(p.nombre, ur.scope_id::TEXT)
    ELSE ur.scope_type || ': ' || ur.scope_id::TEXT
  END as alcance,
  u.activo
FROM admin_users u
INNER JOIN user_roles ur ON u.id = ur.user_id
INNER JOIN roles r ON ur.role_id = r.id
LEFT JOIN plazas p ON ur.scope_id = p.id AND ur.scope_type = 'plaza'
WHERE ur.activo = TRUE
ORDER BY r.nivel_prioridad DESC, u.nombre;

-- Ver total de usuarios por rol
SELECT 
  r.nombre as rol,
  COUNT(ur.user_id) as total_usuarios,
  COUNT(CASE WHEN ur.scope_type IS NULL THEN 1 END) as globales,
  COUNT(CASE WHEN ur.scope_type = 'plaza' THEN 1 END) as por_plaza
FROM roles r
LEFT JOIN user_roles ur ON r.id = ur.role_id AND ur.activo = TRUE
GROUP BY r.id, r.nombre, r.nivel_prioridad
ORDER BY r.nivel_prioridad DESC;

SELECT 
  'Usuarios migrados a RBAC' as categoria,
  COUNT(*) as total
FROM admin_users au
INNER JOIN user_roles ur ON au.id = ur.user_id
INNER JOIN roles r ON ur.role_id = r.id
WHERE ur.activo = TRUE;
