-- =============================================
-- MIGRACIÓN 018: Actualizar CHECK constraint de tipo en tabla vehiculos
-- =============================================
-- Descripción: Permite valores de tipo_vehiculo (con mayúsculas/acentos) 
--              además de valores legacy en minúsculas
-- Razón: Compatibilidad con sistema de mantenedores (migración 017)
-- Fecha: Mayo 2026
-- =============================================

-- Configurar zona horaria
SET timezone = 'America/Santiago';

BEGIN;

-- 1. Eliminar el constraint antiguo
ALTER TABLE vehiculos 
DROP CONSTRAINT IF EXISTS vehiculos_tipo_check;

-- 2. Crear nuevo constraint que permita:
--    - Valores legacy (minúsculas): automovil, camioneta, motocicleta, bicicleta, otro
--    - Valores nuevos (tipo_vehiculo): Automóvil, Camioneta, SUV, etc.
--    - NULL cuando se usa tipo_vehiculo_id
ALTER TABLE vehiculos
ADD CONSTRAINT vehiculos_tipo_check CHECK (
    tipo IS NULL OR
    tipo IN (
        -- Valores legacy (compatibilidad con registros antiguos)
        'automovil', 'camioneta', 'motocicleta', 'bicicleta', 'otro',
        -- Valores nuevos desde tipo_vehiculo
        'Automóvil', 'Camioneta', 'SUV', 'Station Wagon',
        'Motocicleta', 'Furgón', 'Van de Pasajeros', 'Camión',
        'Bus', 'Deportivo', 'Todo Terreno', 'Cuatrimoto'
    )
);

-- 3. Verificar constraint aplicado
SELECT 
    conname as constraint_name,
    pg_get_constraintdef(oid) as definition
FROM pg_constraint
WHERE conrelid = 'vehiculos'::regclass 
AND conname = 'vehiculos_tipo_check';

COMMIT;

-- Registro en tabla de migraciones (si existe)
INSERT INTO schema_migrations (version, name, executed_at)
VALUES (18, 'update_vehiculos_tipo_constraint', CURRENT_TIMESTAMP)
ON CONFLICT (version) DO NOTHING;

SELECT 'Migración 018 completada: CHECK constraint actualizado' AS status;
