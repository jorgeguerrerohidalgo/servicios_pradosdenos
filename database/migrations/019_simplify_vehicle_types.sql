-- =============================================
-- MIGRACIÓN 019: Simplificar tipos de vehículos
-- =============================================
-- Descripción: Reducir tipos de vehículos a categorías útiles
-- Cambios:
--   ELIMINAR: Deportivo, Todo Terreno, Cuatrimoto, Station Wagon
--   AGREGAR: Motor Home
--   SIMPLIFICAR: "Van de Pasajeros" → "Van"
-- Fecha: Mayo 2026
-- =============================================

SET timezone = 'America/Santiago';

BEGIN;

-- 1. DESACTIVAR tipos eliminados (no eliminar para mantener integridad referencial)
UPDATE tipo_vehiculo 
SET activo = FALSE 
WHERE nombre IN ('Deportivo', 'Todo Terreno', 'Cuatrimoto', 'Station Wagon');

-- 2. SIMPLIFICAR "Van de Pasajeros" a "Van"
UPDATE tipo_vehiculo 
SET nombre = 'Van',
    descripcion = 'Vehículo de transporte de pasajeros (minibús) o furgón familiar'
WHERE nombre = 'Van de Pasajeros';

-- 3. AGREGAR "Motor Home"
INSERT INTO tipo_vehiculo (nombre, descripcion, icono, orden, activo) VALUES
('Motor Home', 'Casa rodante o vehículo recreacional', 'fa-caravan', 13, TRUE)
ON CONFLICT (nombre) DO NOTHING;

-- 4. REORDENAR tipos activos
UPDATE tipo_vehiculo SET orden = 1 WHERE nombre = 'Automóvil';
UPDATE tipo_vehiculo SET orden = 2 WHERE nombre = 'Camioneta';
UPDATE tipo_vehiculo SET orden = 3 WHERE nombre = 'SUV';
UPDATE tipo_vehiculo SET orden = 4 WHERE nombre = 'Motocicleta';
UPDATE tipo_vehiculo SET orden = 5 WHERE nombre = 'Furgón';
UPDATE tipo_vehiculo SET orden = 6 WHERE nombre = 'Van';
UPDATE tipo_vehiculo SET orden = 7 WHERE nombre = 'Camión';
UPDATE tipo_vehiculo SET orden = 8 WHERE nombre = 'Bus';
UPDATE tipo_vehiculo SET orden = 9 WHERE nombre = 'Motor Home';

-- 5. ACTUALIZAR CHECK constraint para reflejar nuevos valores
ALTER TABLE vehiculos 
DROP CONSTRAINT IF EXISTS vehiculos_tipo_check;

ALTER TABLE vehiculos
ADD CONSTRAINT vehiculos_tipo_check CHECK (
    tipo IS NULL OR
    tipo IN (
        -- Valores legacy (minúsculas)
        'automovil', 'camioneta', 'motocicleta', 'bicicleta', 'otro',
        
        -- Valores simplificados (capitalizado)
        'Automóvil', 'Camioneta', 'SUV', 'Motocicleta',
        'Furgón', 'Van', 'Camión', 'Bus', 'Motor Home',
        
        -- Valores normalizados (MAYÚSCULAS)
        'AUTOMÓVIL', 'CAMIONETA', 'SUV', 'MOTOCICLETA',
        'FURGÓN', 'VAN', 'CAMIÓN', 'BUS', 'MOTOR HOME',
        
        -- Compatibilidad con valores antiguos (desactivados pero existentes en BD)
        'Van de Pasajeros', 'VAN DE PASAJEROS',
        'Deportivo', 'DEPORTIVO',
        'Todo Terreno', 'TODO TERRENO',
        'Cuatrimoto', 'CUATRIMOTO',
        'Station Wagon', 'STATION WAGON'
    )
);

-- 6. VERIFICAR cambios
SELECT 
    nombre, 
    descripcion, 
    orden, 
    activo 
FROM tipo_vehiculo 
ORDER BY orden;

COMMIT;

-- Mostrar resumen
DO $$
DECLARE
    activos INTEGER;
    desactivados INTEGER;
BEGIN
    SELECT COUNT(*) INTO activos FROM tipo_vehiculo WHERE activo = TRUE;
    SELECT COUNT(*) INTO desactivados FROM tipo_vehiculo WHERE activo = FALSE;
    
    RAISE NOTICE '========================================';
    RAISE NOTICE 'MIGRACIÓN 019 COMPLETADA';
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Tipos activos: %', activos;
    RAISE NOTICE 'Tipos desactivados: %', desactivados;
    RAISE NOTICE '';
    RAISE NOTICE 'TIPOS ACTIVOS:';
    RAISE NOTICE '1. Automóvil';
    RAISE NOTICE '2. Camioneta';
    RAISE NOTICE '3. SUV';
    RAISE NOTICE '4. Motocicleta';
    RAISE NOTICE '5. Furgón';
    RAISE NOTICE '6. Van';
    RAISE NOTICE '7. Camión';
    RAISE NOTICE '8. Bus';
    RAISE NOTICE '9. Motor Home (NUEVO)';
    RAISE NOTICE '';
    RAISE NOTICE 'TIPOS DESACTIVADOS:';
    RAISE NOTICE '- Deportivo';
    RAISE NOTICE '- Todo Terreno';
    RAISE NOTICE '- Cuatrimoto';
    RAISE NOTICE '- Station Wagon';
    RAISE NOTICE '========================================';
END $$;
