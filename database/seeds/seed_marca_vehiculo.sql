-- Seed Data: Marcas de Vehículos en el mercado chileno
-- Fecha: 2026-05
-- Fuente: Basado en marcas comercializadas en Chile según chileautos.cl y mercado automotriz

-- Insertar marcas principales del mercado chileno (ordenadas alfabéticamente)
INSERT INTO marca_vehiculo (nombre, pais_origen, activo) VALUES
-- Marcas Asiáticas (principales en Chile)
('Changan', 'China', TRUE),
('Chery', 'China', TRUE),
('Great Wall', 'China', TRUE),
('Haval', 'China', TRUE),
('Honda', 'Japón', TRUE),
('Hyundai', 'Corea del Sur', TRUE),
('Isuzu', 'Japón', TRUE),
('JAC', 'China', TRUE),
('Kia', 'Corea del Sur', TRUE),
('Mahindra', 'India', TRUE),
('Mazda', 'Japón', TRUE),
('MG', 'China', TRUE),
('Mitsubishi', 'Japón', TRUE),
('Nissan', 'Japón', TRUE),
('Subaru', 'Japón', TRUE),
('Suzuki', 'Japón', TRUE),
('Toyota', 'Japón', TRUE),

-- Marcas Americanas
('Chevrolet', 'Estados Unidos', TRUE),
('Chrysler', 'Estados Unidos', TRUE),
('Dodge', 'Estados Unidos', TRUE),
('Ford', 'Estados Unidos', TRUE),
('GMC', 'Estados Unidos', TRUE),
('Jeep', 'Estados Unidos', TRUE),
('Ram', 'Estados Unidos', TRUE),
('Tesla', 'Estados Unidos', TRUE),

-- Marcas Europeas
('Audi', 'Alemania', TRUE),
('BMW', 'Alemania', TRUE),
('Citroën', 'Francia', TRUE),
('Fiat', 'Italia', TRUE),
('Jaguar', 'Reino Unido', TRUE),
('Land Rover', 'Reino Unido', TRUE),
('Mercedes-Benz', 'Alemania', TRUE),
('Mini', 'Reino Unido', TRUE),
('Opel', 'Alemania', TRUE),
('Peugeot', 'Francia', TRUE),
('Porsche', 'Alemania', TRUE),
('Renault', 'Francia', TRUE),
('Seat', 'España', TRUE),
('Skoda', 'República Checa', TRUE),
('Volkswagen', 'Alemania', TRUE),
('Volvo', 'Suecia', TRUE),

-- Otras marcas relevantes en Chile
('BYD', 'China', TRUE), -- Vehículos eléctricos
('Geely', 'China', TRUE),
('SsangYong', 'Corea del Sur', TRUE)
ON CONFLICT (nombre) DO NOTHING;

-- Verificar inserción
SELECT 
    id,
    nombre, 
    pais_origen, 
    activo 
FROM marca_vehiculo 
ORDER BY nombre;
