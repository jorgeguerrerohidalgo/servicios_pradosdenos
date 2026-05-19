-- ========================================
-- Limpieza: Eliminar Roles Duplicados
-- ========================================
-- Fecha: 19/05/2026
-- Descripción: Eliminar roles de menor prioridad cuando un usuario tiene múltiples roles
-- Ejecutar después de EJECUTAR_MIGRACIONES_RBAC.sql

SET timezone = 'America/Santiago';

-- Ver estado actual (antes de limpieza)
SELECT 
  u.nombre,
  u.email,
  r.nombre as rol,
  r.nivel_prioridad,
  CASE 
    WHEN ur.scope_type IS NULL THEN 'Global'
    WHEN ur.scope_type = 'plaza' THEN 'Plaza: ' || COALESCE(p.nombre, ur.scope_id::TEXT)
    ELSE ur.scope_type
  END as alcance
FROM admin_users u
INNER JOIN user_roles ur ON u.id = ur.user_id
INNER JOIN roles r ON ur.role_id = r.id
LEFT JOIN plazas p ON ur.scope_id = p.id AND ur.scope_type = 'plaza'
WHERE ur.activo = TRUE
ORDER BY u.email, r.nivel_prioridad DESC;

-- Identificar usuarios con múltiples roles
SELECT 
  u.email,
  COUNT(*) as cantidad_roles,
  STRING_AGG(r.nombre, ', ' ORDER BY r.nivel_prioridad DESC) as roles
FROM admin_users u
INNER JOIN user_roles ur ON u.id = ur.user_id AND ur.activo = TRUE
INNER JOIN roles r ON ur.role_id = r.id
GROUP BY u.id, u.email
HAVING COUNT(*) > 1;

-- Desactivar roles de menor prioridad (mantener solo el más alto por usuario)
WITH ranked_roles AS (
  SELECT 
    ur.user_id,
    ur.role_id,
    r.nivel_prioridad,
    ROW_NUMBER() OVER (
      PARTITION BY ur.user_id 
      ORDER BY r.nivel_prioridad DESC
    ) as rn
  FROM user_roles ur
  INNER JOIN roles r ON ur.role_id = r.id
  WHERE ur.activo = TRUE
)
UPDATE user_roles
SET activo = FALSE,
    updated_at = NOW()
FROM ranked_roles rr
WHERE user_roles.user_id = rr.user_id
  AND user_roles.role_id = rr.role_id
  AND rr.rn > 1;  -- Desactivar todos excepto el de mayor prioridad

-- Registrar en auditoría
INSERT INTO permission_audit (user_id, accion, motivo, ip_address, created_at)
VALUES (
  (SELECT MIN(id) FROM admin_users WHERE activo = TRUE),
  'limpieza_roles_duplicados',
  'Limpieza automática: desactivados roles de menor prioridad cuando existían múltiples roles por usuario',
  '127.0.0.1',
  NOW()
);

-- Ver estado final (después de limpieza)
SELECT '✅ Limpieza completada' as resultado;

SELECT 
  u.nombre,
  u.email,
  r.nombre as rol,
  r.nivel_prioridad,
  CASE 
    WHEN ur.scope_type IS NULL THEN 'Global'
    WHEN ur.scope_type = 'plaza' THEN 'Plaza: ' || COALESCE(p.nombre, ur.scope_id::TEXT)
    ELSE ur.scope_type
  END as alcance
FROM admin_users u
INNER JOIN user_roles ur ON u.id = ur.user_id
INNER JOIN roles r ON ur.role_id = r.id
LEFT JOIN plazas p ON ur.scope_id = p.id AND ur.scope_type = 'plaza'
WHERE ur.activo = TRUE
ORDER BY r.nivel_prioridad DESC, u.nombre;

-- Resumen final
SELECT 
  COUNT(DISTINCT user_id) as usuarios_con_roles,
  COUNT(*) as asignaciones_activas
FROM user_roles
WHERE activo = TRUE;
