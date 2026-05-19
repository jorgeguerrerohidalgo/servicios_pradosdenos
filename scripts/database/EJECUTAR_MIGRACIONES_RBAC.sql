-- ========================================
-- SCRIPT CONSOLIDADO: Ejecutar Migraciones RBAC
-- ========================================
-- Descripción: Ejecuta las 3 migraciones del sistema RBAC en orden
-- Fecha: 19/05/2026
-- Ejecución: Copiar y pegar en Supabase SQL Editor
-- 
-- ORDEN DE EJECUCIÓN:
-- 1. 012_create_rbac_tables.sql - Crear tablas y modificar existentes
-- 2. 013_seed_roles_permissions.sql - Insertar roles y permisos base
-- 3. 014_migrate_existing_users.sql - Asignar roles a usuarios existentes
-- ========================================

SET timezone = 'America/Santiago';

-- ========================================
-- MIGRACIÓN 012: Crear Tablas RBAC
-- ========================================
-- 🔧 Ejecutando migración 012: Crear tablas RBAC...

-- Tabla: roles
CREATE TABLE IF NOT EXISTS roles (
  id SERIAL PRIMARY KEY,
  codigo VARCHAR(50) UNIQUE NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  nivel_prioridad INTEGER NOT NULL,
  es_sistema BOOLEAN DEFAULT FALSE,
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE roles IS 'Roles del sistema para control de acceso basado en roles (RBAC)';

CREATE INDEX IF NOT EXISTS idx_roles_codigo ON roles(codigo);
CREATE INDEX IF NOT EXISTS idx_roles_nivel ON roles(nivel_prioridad);
CREATE INDEX IF NOT EXISTS idx_roles_activo ON roles(activo);

-- Tabla: permissions
CREATE TABLE IF NOT EXISTS permissions (
  id SERIAL PRIMARY KEY,
  codigo VARCHAR(100) UNIQUE NOT NULL,
  modulo VARCHAR(50) NOT NULL,
  accion VARCHAR(20) NOT NULL,
  descripcion TEXT,
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE permissions IS 'Permisos granulares del sistema (módulo.acción)';

CREATE INDEX IF NOT EXISTS idx_permissions_codigo ON permissions(codigo);
CREATE INDEX IF NOT EXISTS idx_permissions_modulo ON permissions(modulo);
CREATE INDEX IF NOT EXISTS idx_permissions_activo ON permissions(activo);

-- Tabla: role_permissions
CREATE TABLE IF NOT EXISTS role_permissions (
  role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  permission_id INTEGER NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (role_id, permission_id)
);

COMMENT ON TABLE role_permissions IS 'Relación N:M - Permisos asignados a cada rol';

CREATE INDEX IF NOT EXISTS idx_role_permissions_role ON role_permissions(role_id);
CREATE INDEX IF NOT EXISTS idx_role_permissions_permission ON role_permissions(permission_id);

-- Tabla: user_roles
CREATE TABLE IF NOT EXISTS user_roles (
  user_id INTEGER NOT NULL REFERENCES admin_users(id) ON DELETE CASCADE,
  role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  scope_type VARCHAR(20),
  scope_id INTEGER,
  asignado_por INTEGER REFERENCES admin_users(id),
  asignado_en TIMESTAMP DEFAULT NOW(),
  expira_en TIMESTAMP,
  activo BOOLEAN DEFAULT TRUE,
  updated_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (user_id, role_id)
);

COMMENT ON TABLE user_roles IS 'Asignación de roles a usuarios con scoping opcional por plaza';

CREATE INDEX IF NOT EXISTS idx_user_roles_user ON user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role ON user_roles(role_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_activo ON user_roles(activo);
CREATE INDEX IF NOT EXISTS idx_user_roles_scope ON user_roles(scope_type, scope_id);

-- Tabla: permission_audit
CREATE TABLE IF NOT EXISTS permission_audit (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES admin_users(id),
  accion VARCHAR(50) NOT NULL,
  target_user_id INTEGER REFERENCES admin_users(id),
  role_id INTEGER REFERENCES roles(id),
  permission_id INTEGER REFERENCES permissions(id),
  motivo TEXT,
  ip_address VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE permission_audit IS 'Registro de auditoría para cambios en roles y permisos';

CREATE INDEX IF NOT EXISTS idx_permission_audit_user ON permission_audit(user_id);
CREATE INDEX IF NOT EXISTS idx_permission_audit_target ON permission_audit(target_user_id);
CREATE INDEX IF NOT EXISTS idx_permission_audit_created ON permission_audit(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_permission_audit_accion ON permission_audit(accion);

-- Modificar tablas existentes
ALTER TABLE admin_users 
  ADD COLUMN IF NOT EXISTS ultimo_cambio_permisos TIMESTAMP,
  ADD COLUMN IF NOT EXISTS permisos_custom JSONB;

ALTER TABLE guardias
  ADD COLUMN IF NOT EXISTS plaza_id INTEGER REFERENCES plazas(id);

CREATE INDEX IF NOT EXISTS idx_guardias_plaza ON guardias(plaza_id);

-- Trigger para updated_at
CREATE OR REPLACE FUNCTION update_user_roles_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_user_roles_updated_at ON user_roles;
CREATE TRIGGER trigger_user_roles_updated_at
  BEFORE UPDATE ON user_roles
  FOR EACH ROW
  EXECUTE FUNCTION update_user_roles_timestamp();

SELECT '✅ Migración 012 completada: Tablas RBAC creadas' as resultado;

-- ========================================
-- MIGRACIÓN 013: Seed de Roles y Permisos
-- ========================================
-- 🌱 Ejecutando migración 013: Seed de roles y permisos...

-- Insertar roles base
INSERT INTO roles (codigo, nombre, descripcion, nivel_prioridad, es_sistema, activo) VALUES
  ('super_admin', 'Super Usuario', 'Acceso completo al sistema. Puede gestionar roles, permisos y configuración avanzada.', 100, TRUE, TRUE),
  ('administrador', 'Administrador', 'Administrador con acceso completo a módulos operativos. No puede gestionar roles ni super admins.', 80, TRUE, TRUE),
  ('delegado', 'Delegado de Plaza', 'Puede crear, leer y actualizar recursos en sus plazas asignadas. Sin permisos de eliminación críticos.', 60, TRUE, TRUE),
  ('supervisor', 'Supervisor', 'Acceso de solo lectura ampliado con capacidad de gestión de control de acceso.', 40, TRUE, TRUE),
  ('guardia', 'Guardia', 'Usuario operativo con acceso básico de lectura y gestión de control de acceso en su plaza.', 20, TRUE, TRUE)
ON CONFLICT (codigo) DO NOTHING;

-- Insertar permisos (módulos principales)
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  -- Wildcard total
  ('*.*', 'sistema', 'wildcard', 'Acceso total a todos los módulos y acciones'),
  
  -- Dashboard
  ('dashboard.leer', 'dashboard', 'leer', 'Ver panel de control y estadísticas'),
  ('dashboard.crear', 'dashboard', 'crear', 'Crear widgets y configuraciones de dashboard'),
  ('dashboard.editar', 'dashboard', 'editar', 'Editar configuración de dashboard'),
  ('dashboard.eliminar', 'dashboard', 'eliminar', 'Eliminar widgets y configuraciones'),
  
  -- Eventos
  ('eventos.leer', 'eventos', 'leer', 'Ver eventos y notificaciones'),
  ('eventos.crear', 'eventos', 'crear', 'Crear nuevos eventos'),
  ('eventos.editar', 'eventos', 'editar', 'Editar eventos existentes'),
  ('eventos.eliminar', 'eventos', 'eliminar', 'Eliminar eventos'),
  
  -- Documentos
  ('documentos.leer', 'documentos', 'leer', 'Ver documentos compartidos'),
  ('documentos.crear', 'documentos', 'crear', 'Subir nuevos documentos'),
  ('documentos.editar', 'documentos', 'editar', 'Editar metadatos de documentos'),
  ('documentos.eliminar', 'documentos', 'eliminar', 'Eliminar documentos'),
  
  -- Guardias
  ('guardias.leer', 'guardias', 'leer', 'Ver listado de guardias'),
  ('guardias.crear', 'guardias', 'crear', 'Crear nuevos guardias'),
  ('guardias.editar', 'guardias', 'editar', 'Editar información de guardias'),
  ('guardias.eliminar', 'guardias', 'eliminar', 'Eliminar guardias del sistema'),
  
  -- Plazas
  ('plazas.leer', 'plazas', 'leer', 'Ver información de plazas'),
  ('plazas.crear', 'plazas', 'crear', 'Crear nuevas plazas'),
  ('plazas.editar', 'plazas', 'editar', 'Editar configuración de plazas'),
  ('plazas.eliminar', 'plazas', 'eliminar', 'Eliminar plazas del sistema'),
  
  -- Administradores
  ('administradores.leer', 'administradores', 'leer', 'Ver listado de administradores'),
  ('administradores.crear', 'administradores', 'crear', 'Crear nuevos administradores'),
  ('administradores.editar', 'administradores', 'editar', 'Editar información de administradores'),
  ('administradores.eliminar', 'administradores', 'eliminar', 'Eliminar administradores'),
  
  -- Casas
  ('casas.leer', 'casas', 'leer', 'Ver listado de casas'),
  ('casas.crear', 'casas', 'crear', 'Registrar nuevas casas'),
  ('casas.editar', 'casas', 'editar', 'Editar información de casas'),
  ('casas.eliminar', 'casas', 'eliminar', 'Eliminar casas del sistema'),
  
  -- Residentes
  ('residentes.leer', 'residentes', 'leer', 'Ver información de residentes'),
  ('residentes.crear', 'residentes', 'crear', 'Registrar nuevos residentes'),
  ('residentes.editar', 'residentes', 'editar', 'Editar datos de residentes'),
  ('residentes.eliminar', 'residentes', 'eliminar', 'Eliminar residentes del sistema'),
  
  -- Mascotas
  ('mascotas.leer', 'mascotas', 'leer', 'Ver registro de mascotas'),
  ('mascotas.crear', 'mascotas', 'crear', 'Registrar nuevas mascotas'),
  ('mascotas.editar', 'mascotas', 'editar', 'Editar información de mascotas'),
  ('mascotas.eliminar', 'mascotas', 'eliminar', 'Eliminar mascotas del registro'),
  
  -- Pagos
  ('pagos.leer', 'pagos', 'leer', 'Ver estado de pagos'),
  ('pagos.crear', 'pagos', 'crear', 'Generar períodos de pago'),
  ('pagos.editar', 'pagos', 'editar', 'Registrar pagos y actualizar estados'),
  ('pagos.eliminar', 'pagos', 'eliminar', 'Eliminar registros de pago'),
  
  -- Vehículos
  ('vehiculos.leer', 'vehiculos', 'leer', 'Ver registro de vehículos'),
  ('vehiculos.crear', 'vehiculos', 'crear', 'Registrar nuevos vehículos'),
  ('vehiculos.editar', 'vehiculos', 'editar', 'Editar información de vehículos'),
  ('vehiculos.eliminar', 'vehiculos', 'eliminar', 'Eliminar vehículos del registro'),
  
  -- Control de Acceso
  ('acceso.leer', 'acceso', 'leer', 'Ver historial de accesos'),
  ('acceso.crear', 'acceso', 'crear', 'Registrar check-in de vehículos'),
  ('acceso.editar', 'acceso', 'editar', 'Modificar registros de acceso'),
  ('acceso.eliminar', 'acceso', 'eliminar', 'Eliminar registros de acceso'),
  
  -- Reportes
  ('reportes.leer', 'reportes', 'leer', 'Ver reportes básicos'),
  ('reportes.crear', 'reportes', 'crear', 'Generar reportes personalizados'),
  ('reportes.editar', 'reportes', 'editar', 'Modificar configuración de reportes'),
  ('reportes.eliminar', 'reportes', 'eliminar', 'Eliminar reportes guardados'),
  
  -- Tokens/QR
  ('tokens.leer', 'tokens', 'leer', 'Ver tokens QR de plazas'),
  ('tokens.crear', 'tokens', 'crear', 'Generar nuevos tokens QR'),
  ('tokens.editar', 'tokens', 'editar', 'Actualizar tokens existentes'),
  ('tokens.eliminar', 'tokens', 'eliminar', 'Revocar tokens QR'),
  
  -- Roles (gestión RBAC)
  ('roles.leer', 'roles', 'leer', 'Ver roles y permisos del sistema'),
  ('roles.crear', 'roles', 'crear', 'Crear nuevos roles'),
  ('roles.editar', 'roles', 'editar', 'Modificar roles y asignar permisos'),
  ('roles.eliminar', 'roles', 'eliminar', 'Eliminar roles del sistema')
ON CONFLICT (codigo) DO NOTHING;

-- Asignar permisos a roles
-- Super Admin: wildcard total
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p
WHERE r.codigo = 'super_admin' AND p.codigo = '*.*'
ON CONFLICT DO NOTHING;

-- Administrador: acceso completo excepto gestión de roles
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p
WHERE r.codigo = 'administrador' AND p.codigo IN (
  'dashboard.leer', 'dashboard.crear', 'dashboard.editar', 'dashboard.eliminar',
  'eventos.leer', 'eventos.crear', 'eventos.editar', 'eventos.eliminar',
  'documentos.leer', 'documentos.crear', 'documentos.editar', 'documentos.eliminar',
  'guardias.leer', 'guardias.crear', 'guardias.editar', 'guardias.eliminar',
  'plazas.leer', 'plazas.crear', 'plazas.editar',
  'administradores.leer',
  'casas.leer', 'casas.crear', 'casas.editar', 'casas.eliminar',
  'residentes.leer', 'residentes.crear', 'residentes.editar', 'residentes.eliminar',
  'mascotas.leer', 'mascotas.crear', 'mascotas.editar', 'mascotas.eliminar',
  'pagos.leer', 'pagos.crear', 'pagos.editar', 'pagos.eliminar',
  'vehiculos.leer', 'vehiculos.crear', 'vehiculos.editar', 'vehiculos.eliminar',
  'acceso.leer', 'acceso.crear', 'acceso.editar', 'acceso.eliminar',
  'reportes.leer', 'reportes.crear',
  'tokens.leer', 'tokens.crear', 'tokens.editar'
)
ON CONFLICT DO NOTHING;

-- Delegado: CRU en módulos operativos
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p
WHERE r.codigo = 'delegado' AND p.codigo IN (
  'dashboard.leer',
  'eventos.leer', 'eventos.crear', 'eventos.editar',
  'documentos.leer', 'documentos.crear', 'documentos.editar',
  'guardias.leer',
  'plazas.leer',
  'casas.leer', 'casas.crear', 'casas.editar',
  'residentes.leer', 'residentes.crear', 'residentes.editar',
  'mascotas.leer', 'mascotas.crear', 'mascotas.editar',
  'pagos.leer', 'pagos.editar',
  'vehiculos.leer', 'vehiculos.editar',
  'acceso.leer',
  'reportes.leer'
)
ON CONFLICT DO NOTHING;

-- Supervisor: lectura amplia + control de acceso
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p
WHERE r.codigo = 'supervisor' AND p.codigo IN (
  'dashboard.leer', 'eventos.leer', 'documentos.leer', 'guardias.leer',
  'plazas.leer', 'casas.leer', 'residentes.leer', 'mascotas.leer',
  'pagos.leer', 'vehiculos.leer',
  'acceso.leer', 'acceso.crear', 'acceso.editar',
  'reportes.leer'
)
ON CONFLICT DO NOTHING;

-- Guardia: lectura básica + control de acceso
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p
WHERE r.codigo = 'guardia' AND p.codigo IN (
  'dashboard.leer', 'eventos.leer', 'documentos.leer',
  'plazas.leer', 'casas.leer', 'residentes.leer', 'mascotas.leer',
  'pagos.leer', 'vehiculos.leer',
  'acceso.leer', 'acceso.crear', 'acceso.editar',
  'reportes.leer'
)
ON CONFLICT DO NOTHING;

SELECT '✅ Migración 013 completada: Roles y permisos insertados' as resultado;

-- ========================================
-- MIGRACIÓN 014: Migrar Usuarios Existentes
-- ========================================
-- 👥 Ejecutando migración 014: Asignar roles a usuarios existentes...

-- Asignar super_admin al primer admin_user
INSERT INTO user_roles (user_id, role_id, scope_type, scope_id, asignado_por, asignado_en, activo)
SELECT 
  u.id, r.id, NULL, NULL, u.id, NOW(), TRUE
FROM admin_users u
CROSS JOIN roles r
WHERE u.id = (SELECT MIN(id) FROM admin_users WHERE activo = TRUE)
  AND r.codigo = 'super_admin'
  AND u.activo = TRUE
ON CONFLICT (user_id, role_id) DO NOTHING;

-- Asignar administrador a demás admin_users
INSERT INTO user_roles (user_id, role_id, scope_type, scope_id, asignado_por, asignado_en, activo)
SELECT 
  u.id, r.id,
  CASE WHEN u.plaza_id IS NOT NULL THEN 'plaza' ELSE NULL END,
  u.plaza_id,
  (SELECT MIN(id) FROM admin_users WHERE activo = TRUE),
  NOW(), TRUE
FROM admin_users u
CROSS JOIN roles r
WHERE u.id != (SELECT MIN(id) FROM admin_users WHERE activo = TRUE)
  AND r.codigo = 'administrador'
  AND u.activo = TRUE
ON CONFLICT (user_id, role_id) DO NOTHING;

-- NOTA: Los guardias permanecen en su tabla original (guardias)
-- El sistema de autenticación ya busca en ambas tablas (admin_users y guardias)
-- Los roles para guardias se asignarán manualmente según necesidad
-- Estructura de tablas incompatible: admin_users requiere apellido_paterno/materno (NOT NULL)

-- Actualizar timestamps
UPDATE admin_users
SET ultimo_cambio_permisos = NOW()
WHERE id IN (SELECT user_id FROM user_roles);

-- Registrar auditoría
INSERT INTO permission_audit (user_id, accion, motivo, ip_address, created_at)
SELECT 
  (SELECT MIN(id) FROM admin_users WHERE activo = TRUE),
  'migracion_rbac',
  'Migración automática de usuarios existentes al sistema RBAC',
  '127.0.0.1',
  NOW();

SELECT '✅ Migración 014 completada: Roles asignados a usuarios existentes' as resultado;

-- ========================================
-- VERIFICACIÓN FINAL
-- ========================================

SELECT '🎉 TODAS LAS MIGRACIONES COMPLETADAS' as estado;

-- Resumen de roles
SELECT 
  r.nombre as rol,
  r.nivel_prioridad,
  COUNT(DISTINCT ur.user_id) as usuarios,
  COUNT(DISTINCT rp.permission_id) as permisos
FROM roles r
LEFT JOIN user_roles ur ON r.id = ur.role_id AND ur.activo = TRUE
LEFT JOIN role_permissions rp ON r.id = rp.role_id
GROUP BY r.id, r.nombre, r.nivel_prioridad
ORDER BY r.nivel_prioridad DESC;

-- Usuarios con roles
SELECT 
  u.nombre,
  u.email,
  r.nombre as rol,
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
