-- Seed Data: Tipos de Vehículos registrados en Chile
-- Fecha: 2026-05
-- Fuente: Basado en categorías de Registro Civil y mercado automotriz chileno

-- Insertar tipos de vehículos más comunes en Chile
INSERT INTO tipo_vehiculo (nombre, descripcion, icono, orden, activo) VALUES
('Automóvil', 'Vehículo de pasajeros tipo sedán, hatchback o citycar', 'fa-car', 1, TRUE),
('Camioneta', 'Camioneta pick-up o doble cabina', 'fa-truck-pickup', 2, TRUE),
('SUV', 'Sport Utility Vehicle - Vehículo utilitario deportivo', 'fa-car-side', 3, TRUE),
('Station Wagon', 'Vehículo familiar tipo station wagon', 'fa-car-rear', 4, TRUE),
('Motocicleta', 'Vehículo motorizado de dos ruedas', 'fa-motorcycle', 5, TRUE),
('Furgón', 'Vehículo de carga cerrado', 'fa-shuttle-van', 6, TRUE),
('Van de Pasajeros', 'Vehículo de transporte de pasajeros (minibús)', 'fa-van-shuttle', 7, TRUE),
('Camión', 'Vehículo de carga pesada', 'fa-truck', 8, TRUE),
('Bus', 'Vehículo de transporte público de pasajeros', 'fa-bus', 9, TRUE),
('Deportivo', 'Vehículo deportivo, coupé o convertible', 'fa-car-burst', 10, TRUE),
('Todo Terreno', 'Vehículo apto para terrenos difíciles (4x4)', 'fa-jeep', 11, TRUE),
('Cuatrimoto', 'Vehículo todo terreno de cuatro ruedas (ATV)', 'fa-person-biking', 12, TRUE)
ON CONFLICT (nombre) DO NOTHING;

-- Verificar inserción
SELECT 
    nombre, 
    descripcion, 
    orden, 
    activo 
FROM tipo_vehiculo 
ORDER BY orden;
