-- =============================================
-- SCRIPT DE MIGRACIÓN COMPLETA
-- Los Prados de Nos - Orden de Ejecución
-- =============================================

-- PASO 1: Ejecutar esquema base (plazas, guardias, admin_users)
-- Ejecutar: database-postgresql.sql

-- PASO 2: Crear extensión UUID (si no existe)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- PASO 3: Crear función update_updated_at_column (si no existe)
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- PASO 4: Crear esquema de eventos y documentos (usa admin_users)
\i 03_eventos_documentos.sql

-- PASO 5: Configuración específica para Chile (opcional)
\i 04_configuracion_chile.sql

-- Verificar que todas las tablas fueron creadas
SELECT 
    schemaname,
    tablename,
    tableowner
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('plazas', 'admin_users', 'tipo_evento', 'tipo_documento', 'eventos_vecinales', 'documentos_comunitarios')
ORDER BY tablename;

-- Mensaje de éxito
DO $$
BEGIN
    RAISE NOTICE 'Migración completada exitosamente. Usando admin_users como tabla de usuarios.';
END $$;
