-- Script de verificación y aplicación de migración 001
-- Ejecutar en Supabase SQL Editor: https://app.supabase.com/project/ixttdxkelassioemefbo/sql/new

-- Paso 1: Verificar si la tabla ya existe
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'casas') THEN
        RAISE NOTICE '✓ Tabla casas ya existe';
    ELSE
        RAISE NOTICE '✗ Tabla casas NO existe - ejecutar migración 001_create_casas.sql';
    END IF;
END $$;

-- Paso 2: Ver estructura actual (si existe)
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'casas'
ORDER BY ordinal_position;

-- Paso 3: Verificar restricciones
SELECT 
    conname AS constraint_name,
    contype AS constraint_type
FROM pg_constraint 
WHERE conrelid = 'casas'::regclass;
