-- ========================================
-- MIGRACIÓN 012: Tablas RBAC (Role-Based Access Control)
-- ========================================
-- Descripción: Crear sistema de roles y permisos granulares
-- Autor: Sistema
-- Fecha: 19/05/2026
-- Cambios:
--   - 5 tablas nuevas: roles, permissions, role_permissions, user_roles, permission_audit
--   - Soporte para scoping por plaza
--   - Sistema de auditoría de cambios de permisos
-- ========================================

SET timezone = 'America/Santiago';

-- =============================================
-- TABLA: roles
-- =============================================
-- Roles del sistema (super_admin, administrador, delegado, supervisor, guardia)
CREATE TABLE IF NOT EXISTS roles (
  id SERIAL PRIMARY KEY,
  codigo VARCHAR(50) UNIQUE NOT NULL,        -- 'super_admin', 'administrador', 'delegado', 'supervisor', 'guardia'
  nombre VARCHAR(100) NOT NULL,              -- Nombre descriptivo
  descripcion TEXT,                          -- Descripción del rol
  nivel_prioridad INTEGER NOT NULL,          -- 100=super, 80=admin, 60=delegado, 40=supervisor, 20=guardia
  es_sistema BOOLEAN DEFAULT FALSE,          -- TRUE = no se puede eliminar
  activo BOOLEAN DEFAULT TRUE,               -- Soft delete
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Comentario
COMMENT ON TABLE roles IS 'Roles del sistema para control de acceso basado en roles (RBAC)';
COMMENT ON COLUMN roles.nivel_prioridad IS 'Nivel de autoridad: 100=Super Admin, 80=Administrador, 60=Delegado, 40=Supervisor, 20=Guardia';
COMMENT ON COLUMN roles.es_sistema IS 'Si TRUE, el rol no puede ser eliminado (roles base del sistema)';

-- Índices
CREATE INDEX IF NOT EXISTS idx_roles_codigo ON roles(codigo);
CREATE INDEX IF NOT EXISTS idx_roles_nivel ON roles(nivel_prioridad);
CREATE INDEX IF NOT EXISTS idx_roles_activo ON roles(activo);

-- =============================================
-- TABLA: permissions
-- =============================================
-- Permisos granulares (módulo.acción)
CREATE TABLE IF NOT EXISTS permissions (
  id SERIAL PRIMARY KEY,
  codigo VARCHAR(100) UNIQUE NOT NULL,       -- 'guardias.crear', 'pagos.editar', '*.*' (wildcard)
  modulo VARCHAR(50) NOT NULL,               -- 'guardias', 'pagos', 'casas', 'dashboard'
  accion VARCHAR(20) NOT NULL,               -- 'crear', 'leer', 'editar', 'eliminar'
  descripcion TEXT,                          -- Descripción del permiso
  activo BOOLEAN DEFAULT TRUE,               -- Soft delete
  created_at TIMESTAMP DEFAULT NOW()
);

-- Comentario
COMMENT ON TABLE permissions IS 'Permisos granulares del sistema (módulo.acción)';
COMMENT ON COLUMN permissions.codigo IS 'Formato: modulo.accion (ej: guardias.crear, pagos.*). Wildcard *.*  = acceso total';

-- Índices
CREATE INDEX IF NOT EXISTS idx_permissions_codigo ON permissions(codigo);
CREATE INDEX IF NOT EXISTS idx_permissions_modulo ON permissions(modulo);
CREATE INDEX IF NOT EXISTS idx_permissions_activo ON permissions(activo);

-- =============================================
-- TABLA: role_permissions
-- =============================================
-- Relación N:M entre roles y permisos
CREATE TABLE IF NOT EXISTS role_permissions (
  role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  permission_id INTEGER NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (role_id, permission_id)
);

-- Comentario
COMMENT ON TABLE role_permissions IS 'Relación N:M - Permisos asignados a cada rol';

-- Índices
CREATE INDEX IF NOT EXISTS idx_role_permissions_role ON role_permissions(role_id);
CREATE INDEX IF NOT EXISTS idx_role_permissions_permission ON role_permissions(permission_id);

-- =============================================
-- TABLA: user_roles
-- =============================================
-- Asignación de roles a usuarios (con scoping opcional)
CREATE TABLE IF NOT EXISTS user_roles (
  user_id INTEGER NOT NULL REFERENCES admin_users(id) ON DELETE CASCADE,
  role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  scope_type VARCHAR(20),                    -- NULL (global), 'plaza', 'casa'
  scope_id INTEGER,                          -- ID de plaza/casa (si aplica)
  asignado_por INTEGER REFERENCES admin_users(id),  -- Quién asignó este rol
  asignado_en TIMESTAMP DEFAULT NOW(),       -- Cuándo se asignó
  expira_en TIMESTAMP,                       -- NULL = permanente
  activo BOOLEAN DEFAULT TRUE,               -- Soft delete
  updated_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (user_id, role_id)
);

-- Comentario
COMMENT ON TABLE user_roles IS 'Asignación de roles a usuarios con scoping opcional por plaza';
COMMENT ON COLUMN user_roles.scope_type IS 'Alcance del rol: NULL=global, plaza=solo esa plaza, casa=solo esa casa';
COMMENT ON COLUMN user_roles.scope_id IS 'ID del scope (plaza_id o casa_id según scope_type)';
COMMENT ON COLUMN user_roles.expira_en IS 'Fecha de expiración del rol (NULL = permanente)';

-- Índices
CREATE INDEX IF NOT EXISTS idx_user_roles_user ON user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role ON user_roles(role_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_activo ON user_roles(activo);
CREATE INDEX IF NOT EXISTS idx_user_roles_scope ON user_roles(scope_type, scope_id);

-- =============================================
-- TABLA: permission_audit
-- =============================================
-- Auditoría de cambios en permisos y roles
CREATE TABLE IF NOT EXISTS permission_audit (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES admin_users(id),        -- Quién hizo el cambio
  accion VARCHAR(50) NOT NULL,                       -- 'asignar_rol', 'revocar_rol', 'asignar_permiso', 'revocar_permiso'
  target_user_id INTEGER REFERENCES admin_users(id), -- Usuario afectado (si aplica)
  role_id INTEGER REFERENCES roles(id),              -- Rol involucrado (si aplica)
  permission_id INTEGER REFERENCES permissions(id),  -- Permiso involucrado (si aplica)
  motivo TEXT,                                       -- Razón del cambio
  ip_address VARCHAR(45),                            -- IP desde donde se hizo el cambio
  user_agent TEXT,                                   -- Navegador/cliente
  created_at TIMESTAMP DEFAULT NOW()
);

-- Comentario
COMMENT ON TABLE permission_audit IS 'Registro de auditoría para cambios en roles y permisos';
COMMENT ON COLUMN permission_audit.accion IS 'Tipo de acción: asignar_rol, revocar_rol, asignar_permiso, revocar_permiso, crear_rol, eliminar_rol';

-- Índices
CREATE INDEX IF NOT EXISTS idx_permission_audit_user ON permission_audit(user_id);
CREATE INDEX IF NOT EXISTS idx_permission_audit_target ON permission_audit(target_user_id);
CREATE INDEX IF NOT EXISTS idx_permission_audit_created ON permission_audit(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_permission_audit_accion ON permission_audit(accion);

-- =============================================
-- MODIFICACIONES A TABLAS EXISTENTES
-- =============================================

-- admin_users: Agregar campos para tracking de permisos
ALTER TABLE admin_users 
  ADD COLUMN IF NOT EXISTS ultimo_cambio_permisos TIMESTAMP,
  ADD COLUMN IF NOT EXISTS permisos_custom JSONB;  -- Permisos excepcionales (formato: ["guardias.crear", "pagos.*"])

COMMENT ON COLUMN admin_users.ultimo_cambio_permisos IS 'Última vez que se modificaron roles/permisos del usuario';
COMMENT ON COLUMN admin_users.permisos_custom IS 'Permisos excepcionales en formato JSON (ej: ["guardias.crear", "pagos.*"])';

-- guardias: Agregar plaza_id para scoping
ALTER TABLE guardias
  ADD COLUMN IF NOT EXISTS plaza_id INTEGER REFERENCES plazas(id);

COMMENT ON COLUMN guardias.plaza_id IS 'Plaza asignada al guardia (para scoping de acceso)';

-- Índice
CREATE INDEX IF NOT EXISTS idx_guardias_plaza ON guardias(plaza_id);

-- =============================================
-- TRIGGER: Actualizar updated_at en user_roles
-- =============================================
CREATE OR REPLACE FUNCTION update_user_roles_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_user_roles_updated_at
  BEFORE UPDATE ON user_roles
  FOR EACH ROW
  EXECUTE FUNCTION update_user_roles_timestamp();

-- =============================================
-- VERIFICACIÓN
-- =============================================
SELECT 'Migración 012 ejecutada correctamente' as resultado;

-- Mostrar tablas creadas
SELECT 
  table_name, 
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as columnas
FROM information_schema.tables t
WHERE table_name IN ('roles', 'permissions', 'role_permissions', 'user_roles', 'permission_audit')
  AND table_schema = 'public'
ORDER BY table_name;
