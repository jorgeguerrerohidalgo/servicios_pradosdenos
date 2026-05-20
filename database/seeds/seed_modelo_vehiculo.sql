-- Seed Data: Modelos de Vehículos por Marca (Principales en Chile)
-- Fecha: 2026-05
-- Fuente: Modelos más populares del mercado chileno
-- NOTA: Este seed requiere que primero se ejecuten seed_tipo_vehiculo.sql y seed_marca_vehiculo.sql

-- Función auxiliar para obtener IDs de tipo y marca
DO $$
DECLARE
    tipo_auto INTEGER;
    tipo_camioneta INTEGER;
    tipo_suv INTEGER;
    tipo_moto INTEGER;
    tipo_van INTEGER;
    
    marca_toyota INTEGER;
    marca_chevrolet INTEGER;
    marca_nissan INTEGER;
    marca_hyundai INTEGER;
    marca_kia INTEGER;
    marca_suzuki INTEGER;
    marca_ford INTEGER;
    marca_mazda INTEGER;
    marca_peugeot INTEGER;
    marca_mitsubishi INTEGER;
    marca_honda INTEGER;
    marca_volkswagen INTEGER;
    marca_renault INTEGER;
    marca_subaru INTEGER;
    marca_ram INTEGER;
BEGIN
    -- Obtener IDs de tipos
    SELECT id INTO tipo_auto FROM tipo_vehiculo WHERE nombre = 'Automóvil';
    SELECT id INTO tipo_camioneta FROM tipo_vehiculo WHERE nombre = 'Camioneta';
    SELECT id INTO tipo_suv FROM tipo_vehiculo WHERE nombre = 'SUV';
    SELECT id INTO tipo_moto FROM tipo_vehiculo WHERE nombre = 'Motocicleta';
    SELECT id INTO tipo_van FROM tipo_vehiculo WHERE nombre = 'Van de Pasajeros';
    
    -- Obtener IDs de marcas principales
    SELECT id INTO marca_toyota FROM marca_vehiculo WHERE nombre = 'Toyota';
    SELECT id INTO marca_chevrolet FROM marca_vehiculo WHERE nombre = 'Chevrolet';
    SELECT id INTO marca_nissan FROM marca_vehiculo WHERE nombre = 'Nissan';
    SELECT id INTO marca_hyundai FROM marca_vehiculo WHERE nombre = 'Hyundai';
    SELECT id INTO marca_kia FROM marca_vehiculo WHERE nombre = 'Kia';
    SELECT id INTO marca_suzuki FROM marca_vehiculo WHERE nombre = 'Suzuki';
    SELECT id INTO marca_ford FROM marca_vehiculo WHERE nombre = 'Ford';
    SELECT id INTO marca_mazda FROM marca_vehiculo WHERE nombre = 'Mazda';
    SELECT id INTO marca_peugeot FROM marca_vehiculo WHERE nombre = 'Peugeot';
    SELECT id INTO marca_mitsubishi FROM marca_vehiculo WHERE nombre = 'Mitsubishi';
    SELECT id INTO marca_honda FROM marca_vehiculo WHERE nombre = 'Honda';
    SELECT id INTO marca_volkswagen FROM marca_vehiculo WHERE nombre = 'Volkswagen';
    SELECT id INTO marca_renault FROM marca_vehiculo WHERE nombre = 'Renault';
    SELECT id INTO marca_subaru FROM marca_vehiculo WHERE nombre = 'Subaru';
    SELECT id INTO marca_ram FROM marca_vehiculo WHERE nombre = 'Ram';
    
    -- TOYOTA (marca más vendida en Chile)
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('Corolla', marca_toyota, tipo_auto, 1966, TRUE),
    ('Yaris', marca_toyota, tipo_auto, 1999, TRUE),
    ('Hilux', marca_toyota, tipo_camioneta, 1968, TRUE),
    ('RAV4', marca_toyota, tipo_suv, 1994, TRUE),
    ('C-HR', marca_toyota, tipo_suv, 2016, TRUE),
    ('Camry', marca_toyota, tipo_auto, 1982, TRUE),
    ('Tacoma', marca_toyota, tipo_camioneta, 1995, TRUE),
    ('4Runner', marca_toyota, tipo_suv, 1984, TRUE),
    ('Prius', marca_toyota, tipo_auto, 1997, TRUE),
    ('Land Cruiser', marca_toyota, tipo_suv, 1951, TRUE),
    ('Hiace', marca_toyota, tipo_van, 1967, TRUE),
    ('Fortuner', marca_toyota, tipo_suv, 2004, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- CHEVROLET
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('Spark', marca_chevrolet, tipo_auto, 1998, TRUE),
    ('Sail', marca_chevrolet, tipo_auto, 2001, TRUE),
    ('Cruze', marca_chevrolet, tipo_auto, 2008, TRUE),
    ('Tracker', marca_chevrolet, tipo_suv, 2013, TRUE),
    ('Captiva', marca_chevrolet, tipo_suv, 2006, TRUE),
    ('S10', marca_chevrolet, tipo_camioneta, 1982, TRUE),
    ('Colorado', marca_chevrolet, tipo_camioneta, 2004, TRUE),
    ('Groove', marca_chevrolet, tipo_suv, 2020, TRUE),
    ('Onix', marca_chevrolet, tipo_auto, 2012, TRUE),
    ('Equinox', marca_chevrolet, tipo_suv, 2004, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- NISSAN
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('Versa', marca_nissan, tipo_auto, 2006, TRUE),
    ('Sentra', marca_nissan, tipo_auto, 1982, TRUE),
    ('Kicks', marca_nissan, tipo_suv, 2016, TRUE),
    ('X-Trail', marca_nissan, tipo_suv, 2000, TRUE),
    ('Frontier', marca_nissan, tipo_camioneta, 1997, TRUE),
    ('Qashqai', marca_nissan, tipo_suv, 2006, TRUE),
    ('Patrol', marca_nissan, tipo_suv, 1951, TRUE),
    ('Navara', marca_nissan, tipo_camioneta, 1985, TRUE),
    ('March', marca_nissan, tipo_auto, 1982, TRUE),
    ('Leaf', marca_nissan, tipo_auto, 2010, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- HYUNDAI
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('Accent', marca_hyundai, tipo_auto, 1994, TRUE),
    ('Elantra', marca_hyundai, tipo_auto, 1990, TRUE),
    ('Tucson', marca_hyundai, tipo_suv, 2004, TRUE),
    ('Santa Fe', marca_hyundai, tipo_suv, 2000, TRUE),
    ('Creta', marca_hyundai, tipo_suv, 2014, TRUE),
    ('Kona', marca_hyundai, tipo_suv, 2017, TRUE),
    ('i10', marca_hyundai, tipo_auto, 2007, TRUE),
    ('i30', marca_hyundai, tipo_auto, 2007, TRUE),
    ('Venue', marca_hyundai, tipo_suv, 2019, TRUE),
    ('Palisade', marca_hyundai, tipo_suv, 2018, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- KIA
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('Rio', marca_kia, tipo_auto, 2000, TRUE),
    ('Cerato', marca_kia, tipo_auto, 2004, TRUE),
    ('Sportage', marca_kia, tipo_suv, 1993, TRUE),
    ('Sorento', marca_kia, tipo_suv, 2002, TRUE),
    ('Seltos', marca_kia, tipo_suv, 2019, TRUE),
    ('Stonic', marca_kia, tipo_suv, 2017, TRUE),
    ('Carnival', marca_kia, tipo_van, 1998, TRUE),
    ('Picanto', marca_kia, tipo_auto, 2004, TRUE),
    ('Soul', marca_kia, tipo_suv, 2008, TRUE),
    ('EV6', marca_kia, tipo_suv, 2021, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- SUZUKI
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('Swift', marca_suzuki, tipo_auto, 1983, TRUE),
    ('Baleno', marca_suzuki, tipo_auto, 1995, TRUE),
    ('Vitara', marca_suzuki, tipo_suv, 1988, TRUE),
    ('Jimny', marca_suzuki, tipo_suv, 1970, TRUE),
    ('S-Cross', marca_suzuki, tipo_suv, 2013, TRUE),
    ('Alto', marca_suzuki, tipo_auto, 1979, TRUE),
    ('Dzire', marca_suzuki, tipo_auto, 2008, TRUE),
    ('Ertiga', marca_suzuki, tipo_van, 2012, TRUE),
    ('Grand Vitara', marca_suzuki, tipo_suv, 1998, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- FORD
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('Focus', marca_ford, tipo_auto, 1998, TRUE),
    ('Fiesta', marca_ford, tipo_auto, 1976, TRUE),
    ('Escape', marca_ford, tipo_suv, 2000, TRUE),
    ('Explorer', marca_ford, tipo_suv, 1990, TRUE),
    ('F-150', marca_ford, tipo_camioneta, 1948, TRUE),
    ('Ranger', marca_ford, tipo_camioneta, 1982, TRUE),
    ('EcoSport', marca_ford, tipo_suv, 2003, TRUE),
    ('Edge', marca_ford, tipo_suv, 2006, TRUE),
    ('Mustang', marca_ford, tipo_auto, 1964, TRUE),
    ('Transit', marca_ford, tipo_van, 1965, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- MAZDA
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('2', marca_mazda, tipo_auto, 2002, TRUE),
    ('3', marca_mazda, tipo_auto, 2003, TRUE),
    ('6', marca_mazda, tipo_auto, 2002, TRUE),
    ('CX-3', marca_mazda, tipo_suv, 2015, TRUE),
    ('CX-5', marca_mazda, tipo_suv, 2012, TRUE),
    ('CX-9', marca_mazda, tipo_suv, 2006, TRUE),
    ('CX-30', marca_mazda, tipo_suv, 2019, TRUE),
    ('BT-50', marca_mazda, tipo_camioneta, 2006, TRUE),
    ('MX-5', marca_mazda, tipo_auto, 1989, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- PEUGEOT
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('208', marca_peugeot, tipo_auto, 2012, TRUE),
    ('308', marca_peugeot, tipo_auto, 2007, TRUE),
    ('2008', marca_peugeot, tipo_suv, 2013, TRUE),
    ('3008', marca_peugeot, tipo_suv, 2008, TRUE),
    ('5008', marca_peugeot, tipo_suv, 2009, TRUE),
    ('Partner', marca_peugeot, tipo_van, 1996, TRUE),
    ('Rifter', marca_peugeot, tipo_van, 2018, TRUE),
    ('Traveller', marca_peugeot, tipo_van, 2016, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- MITSUBISHI
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('Lancer', marca_mitsubishi, tipo_auto, 1973, TRUE),
    ('Outlander', marca_mitsubishi, tipo_suv, 2001, TRUE),
    ('ASX', marca_mitsubishi, tipo_suv, 2010, TRUE),
    ('L200', marca_mitsubishi, tipo_camioneta, 1978, TRUE),
    ('Montero', marca_mitsubishi, tipo_suv, 1982, TRUE),
    ('Eclipse Cross', marca_mitsubishi, tipo_suv, 2017, TRUE),
    ('Mirage', marca_mitsubishi, tipo_auto, 1978, TRUE),
    ('Xpander', marca_mitsubishi, tipo_van, 2017, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- HONDA
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('Civic', marca_honda, tipo_auto, 1972, TRUE),
    ('Accord', marca_honda, tipo_auto, 1976, TRUE),
    ('HR-V', marca_honda, tipo_suv, 1998, TRUE),
    ('CR-V', marca_honda, tipo_suv, 1995, TRUE),
    ('Fit', marca_honda, tipo_auto, 2001, TRUE),
    ('City', marca_honda, tipo_auto, 1981, TRUE),
    ('Pilot', marca_honda, tipo_suv, 2002, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- VOLKSWAGEN
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('Gol', marca_volkswagen, tipo_auto, 1980, TRUE),
    ('Polo', marca_volkswagen, tipo_auto, 1975, TRUE),
    ('Golf', marca_volkswagen, tipo_auto, 1974, TRUE),
    ('Jetta', marca_volkswagen, tipo_auto, 1979, TRUE),
    ('T-Cross', marca_volkswagen, tipo_suv, 2018, TRUE),
    ('Tiguan', marca_volkswagen, tipo_suv, 2007, TRUE),
    ('Amarok', marca_volkswagen, tipo_camioneta, 2009, TRUE),
    ('Passat', marca_volkswagen, tipo_auto, 1973, TRUE),
    ('Touareg', marca_volkswagen, tipo_suv, 2002, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- RENAULT
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('Sandero', marca_renault, tipo_auto, 2007, TRUE),
    ('Logan', marca_renault, tipo_auto, 2004, TRUE),
    ('Duster', marca_renault, tipo_suv, 2010, TRUE),
    ('Kwid', marca_renault, tipo_auto, 2015, TRUE),
    ('Captur', marca_renault, tipo_suv, 2013, TRUE),
    ('Koleos', marca_renault, tipo_suv, 2006, TRUE),
    ('Oroch', marca_renault, tipo_camioneta, 2015, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- SUBARU
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('Impreza', marca_subaru, tipo_auto, 1992, TRUE),
    ('Forester', marca_subaru, tipo_suv, 1997, TRUE),
    ('Outback', marca_subaru, tipo_suv, 1994, TRUE),
    ('XV', marca_subaru, tipo_suv, 2011, TRUE),
    ('WRX', marca_subaru, tipo_auto, 1992, TRUE),
    ('Legacy', marca_subaru, tipo_auto, 1989, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    -- RAM
    INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo) VALUES
    ('1500', marca_ram, tipo_camioneta, 2009, TRUE),
    ('2500', marca_ram, tipo_camioneta, 2010, TRUE),
    ('3500', marca_ram, tipo_camioneta, 2010, TRUE),
    ('700', marca_ram, tipo_camioneta, 2020, TRUE)
    ON CONFLICT (nombre, marca_id) DO NOTHING;
    
    RAISE NOTICE 'Seeds de modelos de vehículos insertados exitosamente';
END $$;

-- Verificar inserción
SELECT 
    mv.nombre AS modelo,
    m.nombre AS marca,
    tv.nombre AS tipo,
    mv.anio_inicio,
    mv.activo
FROM modelo_vehiculo mv
JOIN marca_vehiculo m ON mv.marca_id = m.id
LEFT JOIN tipo_vehiculo tv ON mv.tipo_vehiculo_id = tv.id
ORDER BY m.nombre, mv.nombre;
