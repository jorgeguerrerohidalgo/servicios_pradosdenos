-- ========================================
-- Actualizar Jorge a Super Usuario
-- ========================================
-- Fecha: 19/05/2026
-- Descripción: Cambiar rol de Jorge de Administrador a Super Usuario

SET timezone = 'America/Santiago';

-- Eliminar rol actual (administrador)
DELETE FROM user_roles
WHERE user_id = (SELECT id FROM admin_users WHERE email = 'jorgeguerrerohidalgo@gmail.com')
  AND role_id = (SELECT id FROM roles WHERE codigo = 'administrador');

-- Asignar rol super_admin
INSERT INTO user_roles (user_id, role_id, scope_type, scope_id, asignado_por, asignado_en, activo)
SELECT 
  u.id,
  r.id,
  NULL,  -- Super admin tiene alcance global
  NULL,
  (SELECT MIN(id) FROM admin_users WHERE activo = TRUE),
  NOW(),
  TRUE
FROM admin_users u
CROSS JOIN roles r
WHERE u.email = 'jorgeguerrerohidalgo@gmail.com'
  AND r.codigo = 'super_admin'
ON CONFLICT (user_id, role_id) DO UPDATE SET activo = TRUE;

-- Actualizar timestamp de cambio de permisos
UPDATE admin_users
SET ultimo_cambio_permisos = NOW()
WHERE email = 'jorgeguerrerohidalgo@gmail.com';

-- Registrar en auditoría
INSERT INTO permission_audit (user_id, accion, target_user_id, role_id, motivo, ip_address, created_at)
SELECT 
  (SELECT MIN(id) FROM admin_users WHERE activo = TRUE),
  'asignar_rol',
  (SELECT id FROM admin_users WHERE email = 'jorgeguerrerohidalgo@gmail.com'),
  (SELECT id FROM roles WHERE codigo = 'super_admin'),
  'Actualización manual: promovido a Super Usuario',
  '127.0.0.1',
  NOW();

-- Verificación
SELECT 
  u.nombre,
  u.email,
  r.nombre as rol,
  CASE 
    WHEN ur.scope_type IS NULL THEN 'Global'
    ELSE ur.scope_type
  END as alcance
FROM admin_users u
INNER JOIN user_roles ur ON u.id = ur.user_id
INNER JOIN roles r ON ur.role_id = r.id
WHERE u.email = 'jorgeguerrerohidalgo@gmail.com'
  AND ur.activo = TRUE;
