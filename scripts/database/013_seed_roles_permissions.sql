-- ========================================
-- MIGRACIÓN 013: Seed de Roles y Permisos Base
-- ========================================
-- Descripción: Insertar roles y permisos iniciales del sistema
-- Autor: Sistema
-- Fecha: 19/05/2026
-- Cambios:
--   - 5 roles base: super_admin, administrador, delegado, supervisor, guardia
--   - ~70 permisos granulares (14 módulos × CRUD)
--   - Asignación de permisos a roles según matriz de diseño
-- ========================================

SET timezone = 'America/Santiago';

-- =============================================
-- INSERTAR ROLES BASE
-- =============================================

INSERT INTO roles (codigo, nombre, descripcion, nivel_prioridad, es_sistema, activo) VALUES
  ('super_admin', 'Super Usuario', 'Acceso completo al sistema. Puede gestionar roles, permisos y configuración avanzada.', 100, TRUE, TRUE),
  ('administrador', 'Administrador', 'Administrador con acceso completo a módulos operativos. No puede gestionar roles ni super admins.', 80, TRUE, TRUE),
  ('delegado', 'Delegado de Plaza', 'Puede crear, leer y actualizar recursos en sus plazas asignadas. Sin permisos de eliminación críticos.', 60, TRUE, TRUE),
  ('supervisor', 'Supervisor', 'Acceso de solo lectura ampliado con capacidad de gestión de control de acceso.', 40, TRUE, TRUE),
  ('guardia', 'Guardia', 'Usuario operativo con acceso básico de lectura y gestión de control de acceso en su plaza.', 20, TRUE, TRUE)
ON CONFLICT (codigo) DO NOTHING;

-- =============================================
-- INSERTAR PERMISOS BASE (14 módulos)
-- =============================================

-- Módulo: Dashboard
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('dashboard.leer', 'dashboard', 'leer', 'Ver panel de control y estadísticas'),
  ('dashboard.crear', 'dashboard', 'crear', 'Crear widgets y configuraciones de dashboard'),
  ('dashboard.editar', 'dashboard', 'editar', 'Editar configuración de dashboard'),
  ('dashboard.eliminar', 'dashboard', 'eliminar', 'Eliminar widgets y configuraciones'),
  ('dashboard.*', 'dashboard', 'wildcard', 'Todos los permisos de dashboard')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: Eventos
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('eventos.leer', 'eventos', 'leer', 'Ver eventos y notificaciones'),
  ('eventos.crear', 'eventos', 'crear', 'Crear nuevos eventos'),
  ('eventos.editar', 'eventos', 'editar', 'Editar eventos existentes'),
  ('eventos.eliminar', 'eventos', 'eliminar', 'Eliminar eventos'),
  ('eventos.*', 'eventos', 'wildcard', 'Todos los permisos de eventos')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: Documentos
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('documentos.leer', 'documentos', 'leer', 'Ver documentos compartidos'),
  ('documentos.crear', 'documentos', 'crear', 'Subir nuevos documentos'),
  ('documentos.editar', 'documentos', 'editar', 'Editar metadatos de documentos'),
  ('documentos.eliminar', 'documentos', 'eliminar', 'Eliminar documentos'),
  ('documentos.*', 'documentos', 'wildcard', 'Todos los permisos de documentos')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: Guardias
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('guardias.leer', 'guardias', 'leer', 'Ver listado de guardias'),
  ('guardias.crear', 'guardias', 'crear', 'Crear nuevos guardias'),
  ('guardias.editar', 'guardias', 'editar', 'Editar información de guardias'),
  ('guardias.eliminar', 'guardias', 'eliminar', 'Eliminar guardias del sistema'),
  ('guardias.*', 'guardias', 'wildcard', 'Todos los permisos de guardias')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: Plazas
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('plazas.leer', 'plazas', 'leer', 'Ver información de plazas'),
  ('plazas.crear', 'plazas', 'crear', 'Create nuevas plazas'),
  ('plazas.editar', 'plazas', 'editar', 'Editar configuración de plazas'),
  ('plazas.eliminar', 'plazas', 'eliminar', 'Eliminar plazas del sistema'),
  ('plazas.*', 'plazas', 'wildcard', 'Todos los permisos de plazas')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: Administradores
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('administradores.leer', 'administradores', 'leer', 'Ver listado de administradores'),
  ('administradores.crear', 'administradores', 'crear', 'Crear nuevos administradores'),
  ('administradores.editar', 'administradores', 'editar', 'Editar información de administradores'),
  ('administradores.eliminar', 'administradores', 'eliminar', 'Eliminar administradores'),
  ('administradores.*', 'administradores', 'wildcard', 'Todos los permisos de administradores')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: Casas
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('casas.leer', 'casas', 'leer', 'Ver listado de casas'),
  ('casas.crear', 'casas', 'crear', 'Registrar nuevas casas'),
  ('casas.editar', 'casas', 'editar', 'Editar información de casas'),
  ('casas.eliminar', 'casas', 'eliminar', 'Eliminar casas del sistema'),
  ('casas.*', 'casas', 'wildcard', 'Todos los permisos de casas')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: Residentes
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('residentes.leer', 'residentes', 'leer', 'Ver información de residentes'),
  ('residentes.crear', 'residentes', 'crear', 'Registrar nuevos residentes'),
  ('residentes.editar', 'residentes', 'editar', 'Editar datos de residentes'),
  ('residentes.eliminar', 'residentes', 'eliminar', 'Eliminar residentes del sistema'),
  ('residentes.*', 'residentes', 'wildcard', 'Todos los permisos de residentes')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: Mascotas
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('mascotas.leer', 'mascotas', 'leer', 'Ver registro de mascotas'),
  ('mascotas.crear', 'mascotas', 'crear', 'Registrar nuevas mascotas'),
  ('mascotas.editar', 'mascotas', 'editar', 'Editar información de mascotas'),
  ('mascotas.eliminar', 'mascotas', 'eliminar', 'Eliminar mascotas del registro'),
  ('mascotas.*', 'mascotas', 'wildcard', 'Todos los permisos de mascotas')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: Pagos
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('pagos.leer', 'pagos', 'leer', 'Ver estado de pagos'),
  ('pagos.crear', 'pagos', 'crear', 'Generar períodos de pago'),
  ('pagos.editar', 'pagos', 'editar', 'Registrar pagos y actualizar estados'),
  ('pagos.eliminar', 'pagos', 'eliminar', 'Eliminar registros de pago'),
  ('pagos.*', 'pagos', 'wildcard', 'Todos los permisos de pagos')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: Vehículos
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('vehiculos.leer', 'vehiculos', 'leer', 'Ver registro de vehículos'),
  ('vehiculos.crear', 'vehiculos', 'crear', 'Registrar nuevos vehículos'),
  ('vehiculos.editar', 'vehiculos', 'editar', 'Editar información de vehículos'),
  ('vehiculos.eliminar', 'vehiculos', 'eliminar', 'Eliminar vehículos del registro'),
  ('vehiculos.*', 'vehiculos', 'wildcard', 'Todos los permisos de vehículos')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: Control de Acceso
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('acceso.leer', 'acceso', 'leer', 'Ver historial de accesos'),
  ('acceso.crear', 'acceso', 'crear', 'Registrar check-in de vehículos'),
  ('acceso.editar', 'acceso', 'editar', 'Modificar registros de acceso'),
  ('acceso.eliminar', 'acceso', 'eliminar', 'Eliminar registros de acceso'),
  ('acceso.*', 'acceso', 'wildcard', 'Todos los permisos de control de acceso')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: Reportes
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('reportes.leer', 'reportes', 'leer', 'Ver reportes básicos'),
  ('reportes.crear', 'reportes', 'crear', 'Generar reportes personalizados'),
  ('reportes.editar', 'reportes', 'editar', 'Modificar configuración de reportes'),
  ('reportes.eliminar', 'reportes', 'eliminar', 'Eliminar reportes guardados'),
  ('reportes.*', 'reportes', 'wildcard', 'Todos los permisos de reportes')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: QR/Tokens
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('tokens.leer', 'tokens', 'leer', 'Ver tokens QR de plazas'),
  ('tokens.crear', 'tokens', 'crear', 'Generar nuevos tokens QR'),
  ('tokens.editar', 'tokens', 'editar', 'Actualizar tokens existentes'),
  ('tokens.eliminar', 'tokens', 'eliminar', 'Revocar tokens QR'),
  ('tokens.*', 'tokens', 'wildcard', 'Todos los permisos de tokens')
ON CONFLICT (codigo) DO NOTHING;

-- Módulo: Roles (gestión del sistema RBAC)
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('roles.leer', 'roles', 'leer', 'Ver roles y permisos del sistema'),
  ('roles.crear', 'roles', 'crear', 'Crear nuevos roles'),
  ('roles.editar', 'roles', 'editar', 'Modificar roles y asignar permisos'),
  ('roles.eliminar', 'roles', 'eliminar', 'Eliminar roles del sistema'),
  ('roles.*', 'roles', 'wildcard', 'Todos los permisos de roles')
ON CONFLICT (codigo) DO NOTHING;

-- Permiso especial: Wildcard total (solo super_admin)
INSERT INTO permissions (codigo, modulo, accion, descripcion) VALUES
  ('*.*', 'sistema', 'wildcard', 'Acceso total a todos los módulos y acciones')
ON CONFLICT (codigo) DO NOTHING;

-- =============================================
-- ASIGNAR PERMISOS A ROLES
-- =============================================

-- ---------------------
-- SUPER ADMIN (nivel 100)
-- ---------------------
-- Acceso total con wildcard
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r, permissions p
WHERE r.codigo = 'super_admin'
  AND p.codigo = '*.*'
ON CONFLICT DO NOTHING;

-- ---------------------
-- ADMINISTRADOR (nivel 80)
-- ---------------------
-- CRUD completo en: Dashboard, Eventos, Documentos, Guardias, Plazas (CRU), Casas, Residentes, Mascotas, Pagos, Vehículos, Tokens (CRU)
-- Solo lectura en: Administradores
-- Reportes: CR (crear/leer)
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r, permissions p
WHERE r.codigo = 'administrador'
  AND p.codigo IN (
    -- Dashboard: CRUD completo
    'dashboard.leer', 'dashboard.crear', 'dashboard.editar', 'dashboard.eliminar',
    -- Eventos: CRUD completo
    'eventos.leer', 'eventos.crear', 'eventos.editar', 'eventos.eliminar',
    -- Documentos: CRUD completo
    'documentos.leer', 'documentos.crear', 'documentos.editar', 'documentos.eliminar',
    -- Guardias: CRUD completo
    'guardias.leer', 'guardias.crear', 'guardias.editar', 'guardias.eliminar',
    -- Plazas: CRU (no eliminar)
    'plazas.leer', 'plazas.crear', 'plazas.editar',
    -- Administradores: Solo lectura
    'administradores.leer',
    -- Casas: CRUD completo
    'casas.leer', 'casas.crear', 'casas.editar', 'casas.eliminar',
    -- Residentes: CRUD completo
    'residentes.leer', 'residentes.crear', 'residentes.editar', 'residentes.eliminar',
    -- Mascotas: CRUD completo
    'mascotas.leer', 'mascotas.crear', 'mascotas.editar', 'mascotas.eliminar',
    -- Pagos: CRUD completo
    'pagos.leer', 'pagos.crear', 'pagos.editar', 'pagos.eliminar',
    -- Vehículos: CRUD completo
    'vehiculos.leer', 'vehiculos.crear', 'vehiculos.editar', 'vehiculos.eliminar',
    -- Control Acceso: CRUD completo
    'acceso.leer', 'acceso.crear', 'acceso.editar', 'acceso.eliminar',
    -- Reportes: CR (crear/leer)
    'reportes.leer', 'reportes.crear',
    -- Tokens: CRU (no eliminar)
    'tokens.leer', 'tokens.crear', 'tokens.editar'
  )
ON CONFLICT DO NOTHING;

-- ---------------------
-- DELEGADO (nivel 60)
-- ---------------------
-- Dashboard: R
-- Eventos, Documentos: CRU (no eliminar)
-- Guardias: R
-- Plazas: R
-- Casas, Residentes, Mascotas: CRU (no eliminar)
-- Pagos, Vehículos: RU (editar estados, no crear períodos)
-- Control Acceso: R
-- Reportes: R
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r, permissions p
WHERE r.codigo = 'delegado'
  AND p.codigo IN (
    -- Dashboard: Solo lectura
    'dashboard.leer',
    -- Eventos: CRU
    'eventos.leer', 'eventos.crear', 'eventos.editar',
    -- Documentos: CRU
    'documentos.leer', 'documentos.crear', 'documentos.editar',
    -- Guardias: Solo lectura
    'guardias.leer',
    -- Plazas: Solo lectura
    'plazas.leer',
    -- Casas: CRU
    'casas.leer', 'casas.crear', 'casas.editar',
    -- Residentes: CRU
    'residentes.leer', 'residentes.crear', 'residentes.editar',
    -- Mascotas: CRU
    'mascotas.leer', 'mascotas.crear', 'mascotas.editar',
    -- Pagos: RU (editar estados, no crear períodos nuevos)
    'pagos.leer', 'pagos.editar',
    -- Vehículos: RU
    'vehiculos.leer', 'vehiculos.editar',
    -- Control Acceso: Solo lectura
    'acceso.leer',
    -- Reportes: Solo lectura
    'reportes.leer'
  )
ON CONFLICT DO NOTHING;

-- ---------------------
-- SUPERVISOR (nivel 40)
-- ---------------------
-- Todos los módulos: Solo lectura (R)
-- Control Acceso: CRU (puede registrar accesos)
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r, permissions p
WHERE r.codigo = 'supervisor'
  AND p.codigo IN (
    -- Dashboard: R
    'dashboard.leer',
    -- Eventos: R
    'eventos.leer',
    -- Documentos: R
    'documentos.leer',
    -- Guardias: R
    'guardias.leer',
    -- Plazas: R
    'plazas.leer',
    -- Casas: R
    'casas.leer',
    -- Residentes: R
    'residentes.leer',
    -- Mascotas: R
    'mascotas.leer',
    -- Pagos: R
    'pagos.leer',
    -- Vehículos: R
    'vehiculos.leer',
    -- Control Acceso: CRU (puede registrar ingresos)
    'acceso.leer', 'acceso.crear', 'acceso.editar',
    -- Reportes: R
    'reportes.leer'
  )
ON CONFLICT DO NOTHING;

-- ---------------------
-- GUARDIA (nivel 20)
-- ---------------------
-- Dashboard, Eventos, Documentos: R
-- Plazas, Casas, Residentes, Mascotas, Pagos, Vehículos: R (solo su plaza)
-- Control Acceso: CRU (función principal)
-- Reportes: R (reportes básicos)
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r, permissions p
WHERE r.codigo = 'guardia'
  AND p.codigo IN (
    -- Dashboard: R
    'dashboard.leer',
    -- Eventos: R
    'eventos.leer',
    -- Documentos: R
    'documentos.leer',
    -- Plazas: R
    'plazas.leer',
    -- Casas: R
    'casas.leer',
    -- Residentes: R
    'residentes.leer',
    -- Mascotas: R
    'mascotas.leer',
    -- Pagos: R
    'pagos.leer',
    -- Vehículos: R
    'vehiculos.leer',
    -- Control Acceso: CRU (función principal del guardia)
    'acceso.leer', 'acceso.crear', 'acceso.editar',
    -- Reportes: R (básicos)
    'reportes.leer'
  )
ON CONFLICT DO NOTHING;

-- =============================================
-- VERIFICACIÓN
-- =============================================
SELECT 'Migración 013 ejecutada correctamente' as resultado;

-- Ver resumen de roles creados
SELECT 
  r.codigo,
  r.nombre,
  r.nivel_prioridad,
  COUNT(rp.permission_id) as total_permisos
FROM roles r
LEFT JOIN role_permissions rp ON r.id = rp.role_id
GROUP BY r.id, r.codigo, r.nombre, r.nivel_prioridad
ORDER BY r.nivel_prioridad DESC;

-- Ver total de permisos por módulo
SELECT 
  modulo,
  COUNT(*) as total_permisos
FROM permissions
WHERE activo = TRUE
GROUP BY modulo
ORDER BY modulo;
