-- MIGRACIÓN 019: Simplificar tipos de vehículos
-- ELIMINAR: Deportivo, Todo Terreno, Cuatrimoto, Station Wagon
-- AGREGAR: Motor Home
-- SIMPLIFICAR: "Van de Pasajeros" → "Van"

SET timezone = 'America/Santiago';
BEGIN;

-- 1. Desactivar tipos eliminados
UPDATE tipo_vehiculo 
SET activo = FALSE 
WHERE nombre IN ('Deportivo', 'Todo Terreno', 'Cuatrimoto', 'Station Wagon');

-- 2. Simplificar "Van de Pasajeros" a "Van"
UPDATE tipo_vehiculo 
SET nombre = 'Van',
    descripcion = 'Vehículo de transporte de pasajeros (minibús) o furgón familiar'
WHERE nombre = 'Van de Pasajeros';

-- 3. Agregar "Motor Home"
INSERT INTO tipo_vehiculo (nombre, descripcion, icono, orden, activo) VALUES
('Motor Home', 'Casa rodante o vehículo recreacional', 'fa-caravan', 9, TRUE)
ON CONFLICT (nombre) DO NOTHING;

-- 4. Reordenar tipos activos
UPDATE tipo_vehiculo SET orden = 1 WHERE nombre = 'Automóvil';
UPDATE tipo_vehiculo SET orden = 2 WHERE nombre = 'Camioneta';
UPDATE tipo_vehiculo SET orden = 3 WHERE nombre = 'SUV';
UPDATE tipo_vehiculo SET orden = 4 WHERE nombre = 'Motocicleta';
UPDATE tipo_vehiculo SET orden = 5 WHERE nombre = 'Furgón';
UPDATE tipo_vehiculo SET orden = 6 WHERE nombre = 'Van';
UPDATE tipo_vehiculo SET orden = 7 WHERE nombre = 'Camión';
UPDATE tipo_vehiculo SET orden = 8 WHERE nombre = 'Bus';
UPDATE tipo_vehiculo SET orden = 9 WHERE nombre = 'Motor Home';

-- 5. Actualizar CHECK constraint
ALTER TABLE vehiculos DROP CONSTRAINT IF EXISTS vehiculos_tipo_check;
ALTER TABLE vehiculos
ADD CONSTRAINT vehiculos_tipo_check CHECK (
    tipo IS NULL OR
    tipo IN (
        'automovil', 'camioneta', 'motocicleta', 'bicicleta', 'otro',
        'Automóvil', 'Camioneta', 'SUV', 'Motocicleta', 'Furgón', 'Van', 'Camión', 'Bus', 'Motor Home',
        'AUTOMÓVIL', 'CAMIONETA', 'SUV', 'MOTOCICLETA', 'FURGÓN', 'VAN', 'CAMIÓN', 'BUS', 'MOTOR HOME',
        'Van de Pasajeros', 'VAN DE PASAJEROS', 'Deportivo', 'DEPORTIVO',
        'Todo Terreno', 'TODO TERRENO', 'Cuatrimoto', 'CUATRIMOTO',
        'Station Wagon', 'STATION WAGON'
    )
);

COMMIT;

-- Ver resultado
SELECT nombre, descripcion, orden, activo FROM tipo_vehiculo ORDER BY orden;
