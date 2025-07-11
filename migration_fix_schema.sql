-- Script de migración para corregir inconsistencias en el esquema
-- Ejecutar en Supabase para corregir errores 500

-- Configurar zona horaria
SET timezone = 'America/Santiago';

-- ===============================================
-- CORRECCIÓN DE TABLA PLAZAS
-- ===============================================

-- Agregar campos faltantes en la tabla plazas
ALTER TABLE plazas 
ADD COLUMN IF NOT EXISTS direccion VARCHAR(255),
ADD COLUMN IF NOT EXISTS descripcion TEXT,
ADD COLUMN IF NOT EXISTS activo BOOLEAN DEFAULT TRUE;

-- Actualizar plazas existentes para que tengan activo = true
UPDATE plazas SET activo = TRUE WHERE activo IS NULL;

-- ===============================================
-- CORRECCIÓN DE TABLA ADMIN_USERS
-- ===============================================

-- Agregar campos faltantes en la tabla admin_users
ALTER TABLE admin_users 
ADD COLUMN IF NOT EXISTS telefono VARCHAR(20),
ADD COLUMN IF NOT EXISTS activo BOOLEAN DEFAULT TRUE,
ADD COLUMN IF NOT EXISTS last_login TIMESTAMP NULL;

-- Actualizar administradores existentes para que tengan activo = true
UPDATE admin_users SET activo = TRUE WHERE activo IS NULL;

-- Hacer opcionales algunos campos que no se usan en el código
ALTER TABLE admin_users 
ALTER COLUMN fecha_nacimiento DROP NOT NULL,
ALTER COLUMN direccion DROP NOT NULL,
ALTER COLUMN plaza_id DROP NOT NULL;

-- ===============================================
-- CORRECCIÓN DE TABLA GUARDIAS
-- ===============================================

-- Hacer opcional el campo rut en guardias (no se usa en el código)
ALTER TABLE guardias 
ALTER COLUMN rut DROP NOT NULL;

-- ===============================================
-- VERIFICACIÓN DE DATOS
-- ===============================================

-- Verificar que las tablas tengan los campos correctos
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'plazas' 
ORDER BY ordinal_position;

SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'admin_users' 
ORDER BY ordinal_position;

SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'guardias' 
ORDER BY ordinal_position;

-- ===============================================
-- ACTUALIZACIÓN DE DATOS DE EJEMPLO
-- ===============================================

-- Actualizar algunas plazas con datos de ejemplo
UPDATE plazas SET 
    direccion = 'Condominio Los Prados de Nos',
    descripcion = 'Plaza de vigilancia y seguridad'
WHERE direccion IS NULL;

-- Mostrar resumen de cambios
SELECT 'Plazas actualizadas' as tabla, COUNT(*) as total FROM plazas WHERE activo = TRUE
UNION ALL
SELECT 'Administradores actualizados' as tabla, COUNT(*) as total FROM admin_users WHERE activo = TRUE
UNION ALL
SELECT 'Guardias activos' as tabla, COUNT(*) as total FROM guardias WHERE activo = TRUE;

-- ===============================================
-- MENSAJE DE CONFIRMACIÓN
-- ===============================================
SELECT 'Migración completada exitosamente' as status, NOW() as timestamp;
