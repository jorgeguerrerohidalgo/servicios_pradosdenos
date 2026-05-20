-- ============================================================================
-- IMPORTACIÃ“N COMPLETA DE MARCAS Y MODELOS DESDE CSV
-- ============================================================================
-- Archivo: marca_tipo_modelo.csv
-- Total modelos: 4304
-- Total marcas Ãºnicas: 260
-- Tipos: AutomÃ³vil, Bus, Camioneta, FurgÃ³n, Motocicleta, Motor Home, SUV, Van
-- ============================================================================

-- Iniciar transacciÃ³n
BEGIN;

-- ============================================================================
-- PASO 1: LIMPIAR DATOS EXISTENTES
-- ============================================================================

-- Eliminar modelos existentes (respeta FK constraints)
DELETE FROM modelo_vehiculo;

-- Eliminar marcas existentes
DELETE FROM marca_vehiculo;

-- ============================================================================
-- PASO 2: INSERTAR MARCAS ÃšNICAS (260 marcas)
-- ============================================================================

INSERT INTO marca_vehiculo (nombre, activo) VALUES
  ('ACADIAN', TRUE),
  ('ACURA', TRUE),
  ('AIMA', TRUE),
  ('ALFA ROMEO', TRUE),
  ('AMERICAN MOTORS', TRUE),
  ('APRILIA', TRUE),
  ('ARO', TRUE),
  ('ASIA MOTORS', TRUE),
  ('ASTON MARTIN', TRUE),
  ('AUDI', TRUE),
  ('AUSTIN', TRUE),
  ('AUTORRAD', TRUE),
  ('BAIC', TRUE),
  ('BAJAJ', TRUE),
  ('BASHAN', TRUE),
  ('BEIGING', TRUE),
  ('BENDA', TRUE),
  ('BENELLI', TRUE),
  ('BENTLEY', TRUE),
  ('BENYI', TRUE),
  ('BENZHOU', TRUE),
  ('BIGFOOT', TRUE),
  ('BIMOTA', TRUE),
  ('BMW', TRUE),
  ('BOATIAN', TRUE),
  ('BRILLIANCE', TRUE),
  ('BRP CAN AM', TRUE),
  ('BUELL', TRUE),
  ('BUICK', TRUE),
  ('BULTACO', TRUE),
  ('BYD', TRUE),
  ('CADILLAC', TRUE),
  ('CAGIVA', TRUE),
  ('CATERHAM', TRUE),
  ('CF MOTO', TRUE),
  ('CFMOTO', TRUE),
  ('CHANGAN', TRUE),
  ('CHANGHE', TRUE),
  ('CHERY', TRUE),
  ('CHEVROLET', TRUE),
  ('CHRYSLER', TRUE),
  ('CITROEN', TRUE),
  ('COMMER', TRUE),
  ('CORSA', TRUE),
  ('CUPRA', TRUE),
  ('CYCLONE', TRUE),
  ('DACIA', TRUE),
  ('DAELIM', TRUE),
  ('DAEWOO', TRUE),
  ('DAGGER', TRUE),
  ('DAIHATSU', TRUE),
  ('DATSUN', TRUE),
  ('DAYUN', TRUE),
  ('DFSK', TRUE),
  ('DODGE', TRUE),
  ('DONGFENG', TRUE),
  ('DS AUTOMOBILES', TRUE),
  ('DUCATI', TRUE),
  ('DUNNA', TRUE),
  ('DYNA', TRUE),
  ('E-TAKASAKI', TRUE),
  ('EUROMOT', TRUE),
  ('EXEED', TRUE),
  ('F.S.O.', TRUE),
  ('FARIZON', TRUE),
  ('FAW', TRUE),
  ('FERRARI', TRUE),
  ('FIAT', TRUE),
  ('FLSTF', TRUE),
  ('FORD', TRUE),
  ('FOTON', TRUE),
  ('FOX', TRUE),
  ('FXA', TRUE),
  ('G.M.C.', TRUE),
  ('GAC', TRUE),
  ('GAC GONOW', TRUE),
  ('GARELLI', TRUE),
  ('GASGAS', TRUE),
  ('GDM', TRUE),
  ('GECKO', TRUE),
  ('GEELY', TRUE),
  ('GILERA', TRUE),
  ('GREAT WALL', TRUE),
  ('GUZZI', TRUE),
  ('HAFEI', TRUE),
  ('HAIMA', TRUE),
  ('HAO JUE', TRUE),
  ('HARLEY-DAVIDSON', TRUE),
  ('HARTFORD', TRUE),
  ('HAVAL', TRUE),
  ('HENSIM', TRUE),
  ('HERO-PUCH', TRUE),
  ('HILLMAN', TRUE),
  ('HONDA', TRUE),
  ('HUSABERG', TRUE),
  ('HUSQVARNA', TRUE),
  ('HYOSUNG', TRUE),
  ('HYUNDAI', TRUE),
  ('INDIAN', TRUE),
  ('INFINITI', TRUE),
  ('INTERNATIONAL', TRUE),
  ('ISUZU', TRUE),
  ('ITALJET', TRUE),
  ('IVECO', TRUE),
  ('JAC', TRUE),
  ('JAECOO', TRUE),
  ('JAGUAR', TRUE),
  ('JAWA', TRUE),
  ('JEEP', TRUE),
  ('JETOUR', TRUE),
  ('JIANSHE', TRUE),
  ('JIM', TRUE),
  ('JINBEI', TRUE),
  ('JMC', TRUE),
  ('KAIYI', TRUE),
  ('KARMA', TRUE),
  ('KARRY', TRUE),
  ('KAWASAKI', TRUE),
  ('KAYAK', TRUE),
  ('KEEWAY', TRUE),
  ('KENBO', TRUE),
  ('KIA MOTORS', TRUE),
  ('KINLON', TRUE),
  ('KOENIGSEGG', TRUE),
  ('KOVE', TRUE),
  ('KTM', TRUE),
  ('KYC', TRUE),
  ('KYMCO', TRUE),
  ('LADA', TRUE),
  ('LAMBORGHINI', TRUE),
  ('LAMBRETTA', TRUE),
  ('LANCIA', TRUE),
  ('LAND ROVER', TRUE),
  ('LANDWIND', TRUE),
  ('LEAPMOTOR', TRUE),
  ('LEXUS', TRUE),
  ('LIFAN', TRUE),
  ('LINCOLN', TRUE),
  ('LINHAI', TRUE),
  ('LIVAN', TRUE),
  ('LML', TRUE),
  ('LONCIN', TRUE),
  ('LOTUS', TRUE),
  ('LUOJIA', TRUE),
  ('LYNK CO', TRUE),
  ('MAHINDRA', TRUE),
  ('MAICO', TRUE),
  ('MAPLE', TRUE),
  ('MASERATI', TRUE),
  ('MAXUS', TRUE),
  ('MAZDA', TRUE),
  ('MCLAREN', TRUE),
  ('MERCEDES BENZ', TRUE),
  ('MERCURY', TRUE),
  ('MG', TRUE),
  ('MINI', TRUE),
  ('MITSUBISHI', TRUE),
  ('MONTELLI', TRUE),
  ('MONTESA', TRUE),
  ('MORGAN', TRUE),
  ('MORINI', TRUE),
  ('MORRIS', TRUE),
  ('MOTO BECANE', TRUE),
  ('MOTOMEL', TRUE),
  ('MOTORRAD', TRUE),
  ('MOTRAC', TRUE),
  ('MSK', TRUE),
  ('MV AGUSTA', TRUE),
  ('NAMMI', TRUE),
  ('NETA', TRUE),
  ('NISSAN', TRUE),
  ('NSU', TRUE),
  ('ODES', TRUE),
  ('OLDSMOBILE', TRUE),
  ('OMODA', TRUE),
  ('OPEL', TRUE),
  ('OSSA', TRUE),
  ('PALLA', TRUE),
  ('PEUGEOT', TRUE),
  ('PGO', TRUE),
  ('PIAGGIO', TRUE),
  ('PIONNER', TRUE),
  ('PLYMOUTH', TRUE),
  ('POLARIS', TRUE),
  ('POLSKI FIAT', TRUE),
  ('PONTIAC', TRUE),
  ('PORSCHE', TRUE),
  ('PROTON', TRUE),
  ('PUMA', TRUE),
  ('QJMOTOR', TRUE),
  ('RAM', TRUE),
  ('RBS', TRUE),
  ('REGAL RAPTOR', TRUE),
  ('RENAULT', TRUE),
  ('RIDDARA', TRUE),
  ('RIZATO', TRUE),
  ('ROLLS ROYCE', TRUE),
  ('ROVER', TRUE),
  ('ROYAL ENFIELD', TRUE),
  ('SAAB', TRUE),
  ('SACHS', TRUE),
  ('SAEHAN', TRUE),
  ('SAMSUNG', TRUE),
  ('SANFU', TRUE),
  ('SANLG', TRUE),
  ('SANYA', TRUE),
  ('SANYANG SYM', TRUE),
  ('SEAT', TRUE),
  ('SEGWAY', TRUE),
  ('SG', TRUE),
  ('SHINERAY', TRUE),
  ('SIMCA', TRUE),
  ('SKODA', TRUE),
  ('SKYGO', TRUE),
  ('SMA', TRUE),
  ('SMART', TRUE),
  ('SPEED UP', TRUE),
  ('SPITZ', TRUE),
  ('SSANGYONG', TRUE),
  ('SUBARU', TRUE),
  ('SUPER SOCO', TRUE),
  ('SUZUKI', TRUE),
  ('SWM', TRUE),
  ('SYM', TRUE),
  ('TAKASAKI', TRUE),
  ('TATA', TRUE),
  ('TESLA', TRUE),
  ('TM', TRUE),
  ('TORITO', TRUE),
  ('TOYOTA', TRUE),
  ('TRIUMPH', TRUE),
  ('TVS', TRUE),
  ('UAZ', TRUE),
  ('UNITED MOTORS', TRUE),
  ('URAL', TRUE),
  ('VERONA', TRUE),
  ('VESPA', TRUE),
  ('VOGE', TRUE),
  ('VOLKSWAGEN', TRUE),
  ('VOLTERA', TRUE),
  ('VOLVO', TRUE),
  ('WANGYE', TRUE),
  ('WILLYS', TRUE),
  ('WOLKEN', TRUE),
  ('XGJAO', TRUE),
  ('XINGYUE', TRUE),
  ('XMOTORS', TRUE),
  ('YAMAHA', TRUE),
  ('YAMAMOTO', TRUE),
  ('YINXIANG', TRUE),
  ('YUGO', TRUE),
  ('ZANELLAS', TRUE),
  ('ZASTAVA', TRUE),
  ('ZNA', TRUE),
  ('ZNEN GROUP', TRUE),
  ('ZONGSHEN', TRUE),
  ('ZONTES', TRUE),
  ('ZOTYE', TRUE),
  ('ZUNDAPP', TRUE),
  ('ZX AUTO', TRUE)
ON CONFLICT (nombre) DO NOTHING;

-- ============================================================================
-- PASO 3: INSERTAR MODELOS (4304 modelos)
-- ============================================================================

INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, activo)
VALUES
  (
    'DB11',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DBS SUPERLEGGERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VANTAGE 4.0 LTS ROADSTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '430I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M850I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'Z4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '430',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '440',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M850',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '420',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M240I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '220I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '420I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M440I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CORVETTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ROMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PORTOFINO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F-TYPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F-TYPE 5.0',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'HURACAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAMBORGHINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GALLARDO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAMBORGHINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VANTAGE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EXIGE CUP 430',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LOTUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MX5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '570S SPIDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AMG S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C 63 S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'E',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AMG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AMG GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'E 53',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'E',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COOPER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'JCW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AERO 8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MORGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PLUS FOUR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MORGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PLUS SIX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MORGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '718',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PORSCHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '911',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PORSCHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IMPREZA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BIGFOOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BIGFOOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BIGFOOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CFMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MPT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAYUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EUROMOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HERO-PUCH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FRT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FTR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KSF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BRUTE FORCE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '90CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '505',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '525',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MXU',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'UXV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAXXER450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LONCIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LONCIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XWOLF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LONCIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ODES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '800ATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ODES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLAW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPORTSMAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PHOENIX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HAWKEYE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PREDATOR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCRAMBLER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RZR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RANGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '1000 EPS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RZR XP TURBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SPITZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SPITZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCARTT 500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FALCON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RANGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'APQ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YFM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YFZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'WOLVERINE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YFM-700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YFM-450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YXZ-1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YFM-350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'M',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LINHAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LINHAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATV 400',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GDM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ADVENTURE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RBS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'COMMANDER 1000 DPS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'COMMANDER 1000 XT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'COMMANDER DPS 700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'COMMANDER MAX XT 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'COMMANDER MAX XTP 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER BASE HD9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER DPS HD9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER HD10 DPS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER HD7 DPS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER MAX BASE HD7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER MAX DPS HD9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER MAX XT HD10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER XT HD10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV MAX DS TURBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV MAX XDS TURBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV MAX XRS TURBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV SPORT DPS 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV X3 DS TURBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV X3 RS TURBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV X3 XRS TURBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV XRC TURBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV XRS TURBO RR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAX X3 XRS TURBO S-S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER 1000 MAX XTP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER 450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER 570',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER 570 XMR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER MAX 6X6 1000 XT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER MAX 6X6 450 DPS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER MAX DPS 450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER MAX DPS 570',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER MAX LTD 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER MAX XT 650',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER MAX XTP 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER XMR 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER XU 450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RENEGADE XMR 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RYKER 600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RYKER 900',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RYKER RALLY 900',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RYKER SPORT 900',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'COMMANDER XT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER BASE HD8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER HD9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER MAX  DPS HD9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DS X 90 CR/B 21',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DS250 4ST RD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DS904STRD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV  RS TURBO RR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV DS TURBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV MAX RS TURBO RR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV MAX XRS TURBO RR SAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV SPORT MAX 1000 DPS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV XRC TURBO RR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV XRS TURBO RR S-S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV XRS TURBO SAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUT MAX DPS 450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUT XMR 570',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTL 450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTL 1000 MAX XTP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTL MAX LTD 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTL MAX XT 850',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTL MAX XTP 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTL450RD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RENEGADE XXC 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPYDER F3 LTD 1330',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SYDERF3S1330',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTL 650 MAX XT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTL MAX 1000 LTD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER MAX BASE 62 HED7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV DS 64 TURB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV TRAIL BASE 50 HD7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER PRO HD5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER XXC 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV SPORT XRC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAV TRIAL BASE 700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER  MAX XT 700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER XMR700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'COMANDER MAX DPS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER PRO DPS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DS250-4ST',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DS904ST',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DSPR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAVERIK TRAIL BASE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER 500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER MAX DPS 500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER MAX DPS 700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER MAX XT 850',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER MXR 700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER BASE 62 HD7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DEFENDER PRO DPS 64 HD10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAVERICK R XRS 77 966',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAVERICK R XRS 77 996NT YL SAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER 2X4 500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OUTLANDER MAX 6X6 DPS 650',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RENEGADE 2X4 110-4ST',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SSV COMMANDER DPS 60 DPS HD7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SSV MAVERICK R X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SSV MAVERICK R X 999T RD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DS 90 X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAVERICK TRAIL DPS 800',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SSV MAVERICK SPT MX DPS 60 1000R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SSV MAVERICK R XRS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SSV MAVERICK R MX X 999T',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RD CANYON REDR 1330 SE6 GN EU 25',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF 1000 ZFORCE SPORT R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF 800 ZFORCE TRAIL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF UFORCE 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF UFORCE 600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CFORCE 1000 OVERLAND',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CFORCE 1000 XC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CFORCE 450L',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CFORCE 520L',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CFORCE 625 TURING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CFORCE 850 XC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF 1000 ZFORCE SPORT R XL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF UFORCE 1000 XL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF110 ECONOMICA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF110 FULL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CFORCE 1000 TOURING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CFORCE 850 TOURING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CFORCE 1000 MUV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CFORCE 625 TOURING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CFORCE GOES TERROX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AT04530F41CHL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEGWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SNARLER AT5 S STANDARD SGW500F-A1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEGWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SNARLER AT5 S STD SGW500F-A1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEGWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FUGLEMAN UT10 CREW PEMIUM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEGWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SEGWAY AT10W PREMIUM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEGWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SEGWAY UT6 STANDARD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEGWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SNARLER AT5 L PREMIUM SGW500F-A2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEGWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPER VILLAIN SX20T PREMIUM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEGWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VILLAN SX10 W PREMIUM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEGWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TOWNER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'PLUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAIC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'GRAND PLUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAIC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'H2L',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'T30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'T32',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'T32',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T52',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'X30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'T50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'S300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CM5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CM10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'M201',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'MD201',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'MD201',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'S100',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'S200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'G10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'COMBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'N300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'N400',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'AK-6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'C15',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'BERLINGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'SPACEVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'MULTISPACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'JUMPER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'NEMO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'JUMPY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'C3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '350-KG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'COMMER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DAMAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'LABO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    '55-WIDE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CAB-VAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'HIJET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'EXTOL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'C20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'SUNNY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'MINISTAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'MINIVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'REFRITRUCK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CARGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'FIORINO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DOBLO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'UNO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'QUBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DUCATO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'E100',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TRANSIT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'EXPEDITION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'MIDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'FT DIESEL 2.8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'K1 DIESEL 2.8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'MIDI TRUCK PLUS 1.5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'LVAV2AVB8NE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'MIDI CARGO BOX 1.3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'MIDI PICK UP CS 1.3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TM3 MAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CARGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GAC GONOW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'VAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GAC GONOW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'RUIYI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAFEI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'ZHONGYI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAFEI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CARGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAFEI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'MINITRUCK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAFEI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'FSTAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAIMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'ACTY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'PORTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'H350 SOLATI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'H-1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'H1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'STARIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'WFR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ISUZU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DAILY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'IVECO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'SUNRAY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'SUNRAY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'X200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'REFINE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'REFINE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'T8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'REFINE M4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'REFINE M4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'X100',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '206',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KENBO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TOWNER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'FRONTIER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    '27150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CARGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TRUCK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'VAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'FOISON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'EV80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'V80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'V90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'G10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DELIVER 9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'EDELIVER 9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'EDELIVER 3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'C35',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'C35',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'EV30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'F1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CITAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'V-200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'SPRINTER 315 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'V-220 D',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'V-250D',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'L100',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'COMBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'VIVARO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    '404',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'J5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'BOXER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'PARTNER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    '206',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    '207',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'EXPERT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TEPEE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'BIPPER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TRAVELLER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'R4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'R1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'EXPRESS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'KANGOO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DOKKER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    '6-ASIENTOS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANFU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TERRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'INCA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'T32',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'X30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'T30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T52',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CARRY-ALL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'UTILITARIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    '700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'E-10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'UTILITARIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CARRY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'FURGON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'APV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'COROLLA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'HIACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'HIACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'SAVEIRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CALIFORNIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CARAVELLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CRAFTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CADDY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TRANSPORTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'AMAROK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'NUEVA AMAROK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'SIN MODELO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZASTAVA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'VAN 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RAM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'VAN 700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RAM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CARGO VAN 1.2 K05S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CARGO VAN 1.2 K05S EPS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CARGO VAN 1.5 SERIE C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CARGO VAN C25',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CARGO VAN C25 AC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4728',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4729',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CARGO BOX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4731',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4732',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4733',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'CARGO VAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4865',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4683',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4724',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4725',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4727',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TRUCK CABINA DOBLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4676',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4677',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4682',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4720',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4721',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4722',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4723',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TRUCK CABINA SIMPLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4533',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4726',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4730',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DFSK 4850',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'REFRITRUCK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TRUCK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'X5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'T3 PICK UP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'T3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'X5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'X5 PLUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'V3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'V5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'DBS COUPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ONE-77',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ZAGATO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DB12',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RS5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CONTINENTAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENTLEY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '218I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M235I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F12 TDF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '12CILINDRI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '458',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MUSTANG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AVENTADOR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAMBORGHINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EMIRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LOTUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EMIRA 2.0 AT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LOTUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GRANTURISMO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MASERATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ARTURA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '765LT COUPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GLC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CLA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CYBERSTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GT-R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'JESKO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KOENIGSEGG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NETA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COMANCHE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AMERICAN MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TOWNER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '500-KGS.',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUSTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'A-40',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUSTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CENTURY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RUDA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'X6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SHARK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'MS201',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'HUNTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'MD301',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'MS301',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'C10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'SCOTTDALE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'APACHE-10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'APACHE-20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'EL_CAMINO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'SILVERADO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'LUV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'C20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'C30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'B-10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'B-20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CHEVY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CHEYENNE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'S10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'C100',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'C1500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CORSA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'GRAND LUV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'AVALANCHE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'MONTANA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'COLORADO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'D-MAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'D CAB 2.8 AUT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'YAGAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '350-KG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'COMMER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '1.304 MIL KGS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DACIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'HIJET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'ROCKY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CHASSIS-CORTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CHASSIS-LARGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '500KG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CON-ESTACAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'D/C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'SUNNY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CABINA_Y_MEDIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'KING-CAB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '500 A 750 KGS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DAKOTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RAM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'MINITRUCK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RICH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DF2500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DF2900',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DFA1025F12QA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DF-412',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DF-212 CAMIONETA EVI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DF-212 DC CAMIONETA EVI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DF-212 DC PLUS CAMIONETA EVI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DF-212 PLUS CAMIONETA EVI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T5L',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RICH 6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DF-212',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FAW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'V80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FAW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    '147',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CITY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'PICK-UP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'FIORINO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'STRADA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'FULLBACK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '700 ADVENTURE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RAM 700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '750_KGS.',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'F100',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RANCHERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'COURIER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RANGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'F1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'F150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'PAMPA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'F250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'F350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'F-150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RANGER ICA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'EXPLORER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MAVERICK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TERRITORY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RANGER EUR6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'FORD RANGER P703',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'F-150 MCA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'SUP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TERRACOTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'FT500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'MIDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'FT-500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'URBAN TRUCK CS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'URBAN TRUCK DC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'G7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'FT BOX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TM3 MAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TM5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TM3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TM3 MAS CARGO BOX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TM3 MAS BOX WINGS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TM3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'G9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'G7 4X2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'G7 4X4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'G7 8AT 4X4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'V9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'SPRINT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'G.M.C.'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'SIERRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'G.M.C.'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'WAY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GAC GONOW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DEER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'WINGLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'SOCOOL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'WINGLE5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'WINGLE6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'WINGLE7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'POER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RUIYI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAFEI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'MINITRUCK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAFEI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'ACTY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RIDGELINE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'PONY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'PORTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'HD 35',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'HD 35 LIGHT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'QX50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '1.000-KGS.',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INTERNATIONAL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '750-KGS.',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INTERNATIONAL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RANCHERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ISUZU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'SUNRAY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T8 PRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'GLADIATOR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JEEP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'BOARDING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JMC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CARRYING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JMC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'VIGUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JMC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'GRAND AVENUE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JMC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T205',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KENBO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'K2400',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CERES',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TOWNER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'FRONTIER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TASMAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '27151',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DEFENDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'PIK-UP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAHINDRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'GENIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAHINDRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'ET90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'EDELIVER 3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'SIN MODELO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'E1600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'E2200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'B2000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'B2600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CREW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'B2200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'B2500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'B2900',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'BT50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '206',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '307',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '310',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'MB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'G',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'L100',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'L200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'L300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'MARINA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MORRIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'C/S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CABINA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CHASSIS-CORTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'D/C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '500-KG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'SUNNY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CHASSIS-LARGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'KING-CAB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'D21',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CORTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'D22',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TERRANO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'NAVARA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'NP300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CORSA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'MOVANO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '404',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '504',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'BOXER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'LANDTREK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'ALASKAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'OROCH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'MAX-PICK-UP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAEHAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAMSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'PLUTUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'STEED',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'PICK-UP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'MUSSO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'A.SPORTS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'ACTYON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'ACTYON SPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'GRAND MUSSO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TORRES',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'BAJA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'EVOLTIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'IMPREZA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '600 KGS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'PICK-UP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CARRY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'APV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'XENON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TATA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'HILUX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'STOUT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'PRERUNNER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TUNDRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'HILUX GRS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '262',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '261',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '265',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'GOL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'SAVEIRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'AMAROK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'POLY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YUGO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DOBLE-CABINA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZASTAVA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'ADMIRAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZX AUTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'GRAND TIGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZX AUTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TERRALORD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZX AUTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'GRAND LION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZX AUTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '1500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RAM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RAM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '1200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RAM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RAM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '2500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RAM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RAMPAGE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RAM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    '3500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RAM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RICH 2.5 DIESEL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RICH 2.4 GAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'DF6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RICH 6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RICH 7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RICH 6 2WD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RICH 6 4WD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CARGO BOX CS 1.3 R14 SERIE V EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CARGO BOX CS C21',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CARGO BOX CS C21 AC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CARGO BOX CS XL 1.3 DA EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'REFRITRUCK XL 1.3 DA EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TRUCK DC 1.3 R14 SERIE V EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK DC 1.5 SERIE C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK DC C22',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK DC C22 AC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK DC XXL 1.0 DA EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK DC XXL 1.3 DA EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK CS 1.5 SERIE C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK CS C21',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK CS C21 AC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK SC 1.3 R14 SERIE V EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK SC XL 1.0 DA EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK SC XL 1.3 DA EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK DC 1.2 R14 SERIE V EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'TRUCK DC C32 1.2 DA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'PICK UP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'X7 PLUS 2.0 PICK UP  DC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'X7 PLUS 2.0 PICK UP SC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'Q51',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KARRY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'Q52',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KARRY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'Q22',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KARRY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'Q22D',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KARRY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'Q22E',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KARRY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RICH 6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLTERA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'F3E EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FARIZON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'BUKHANKA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UAZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'PROFI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UAZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'CYBERTRUCK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TESLA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RE-MAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JIM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'RD6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RIDDARA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Camioneta'),
    TRUE
  ),
  (
    'T3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'V700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'FT-BOX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'K1 CARGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'TOURING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JMC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'SPRINTER 314 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'SPRINTER 316',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'SPRINTER 316 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'VITO 111 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'VITO 114 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'SPRINTER 417 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'SPRINTER 317 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'SPRINTER 419 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'SPRINTER 517 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'NEW V5 CARGO  VAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'E6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FARIZON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'V6E',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FARIZON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'EV48',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GECKO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Furgón'),
    TRUE
  ),
  (
    'ALFASUD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SPRINT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '145',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '147',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '156',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BRERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MITO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GIULIETTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'STELVIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TONALE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'HORNET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AMERICAN MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '100',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RS3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RS6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MINI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUSTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A-7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUSTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUSTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MODELO-1.100',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUSTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUSTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'METRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUSTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'OUTSIDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'UP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAIC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '116',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '120',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '130',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '118',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '114',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M135',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '218',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M140',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '220',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '318',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '320',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '330',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '640',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M240',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '118 I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '118 D',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I3S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '128TI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '118I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FRV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'H220',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F3-R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F0',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SONG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DOLPHIN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'YUAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'D1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BENNI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CV1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DEEPAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SPLA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IQ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BEAT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FULWIN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SKIN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CHEVETTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'HATCH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CITATION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RECORD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CORSA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ASTRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AVEO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SPARK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CRUZE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SONIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ONIX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ONIX TURBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SAIL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CROSS-FIRE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '18-HP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A.Z.U.',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '2CV6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VISA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DYANA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'L.N.A.',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ACADYANE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ZX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SAXO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DS3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C-ELYSEE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CACTUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C3 AIRCROSS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '1.410',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DACIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'NEXIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TICO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LANOS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MATIZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CUORE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CHARADE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GIRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SUPER-CUORE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MIRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SIRION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '260Z',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '100A',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '160J',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '280ZX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '120A',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '200SX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C/S-STD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '130A',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VIPER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'H30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AEOLUS GS CROSS 1.5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'POLONEZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'F.S.O.'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'OLEY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FAW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'V2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FAW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'D60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FAW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '296',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LEVANTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MASERATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SF90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PUROSANGUE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '147',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '126',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RITMO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SILVER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SPAZZIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'UNO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PANDA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TIPO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DIGIT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PUNTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BRAVA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BRAVO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CINQUECENTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PALIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'STILO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IDEA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GRANDE PUNTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'UNO WAY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'UNO SPORTING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '500L',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '500X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ARGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '500C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MOBI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FUTURA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GALAXIE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TORINO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MAVERICK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PINTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PREFECT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LTD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GRANADA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TAUNUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FIESTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ZEPHIR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SIN MODELO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'HERITAGE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LASER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'THUNDERBIRD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SIERRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TELSTAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TAURUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TEMPO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PROBE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FESTIVA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'WINDSTAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'KA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MONDEO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MERCURY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SUPER_CLUB_WAGON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FOCUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FUSION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GEOMETRY C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GX3PRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PERI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FLORID',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VOLEEX-C10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VOLEEX-C20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ORA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LOBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAFEI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'HAIMA2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAIMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'HAIMA3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAIMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ACCORD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CIVIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'QUINTET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BUGGI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'INTEGRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FIT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CITY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PONY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EXCEL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ATOS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ACCENT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MATRIX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GETZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VELOSTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I40',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I-20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IONIQ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GRAND I-10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I-30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'INSTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A137',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A0',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EJS1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PRIDE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MORNING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SOUL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CERATO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '2109',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SAMARA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TAVRIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '21083',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CHARLOTTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'H-P',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LANCIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DELTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LANCIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'Y10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LANCIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CT200H',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CT200F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CT200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'UX200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'UX250H',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '320',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '520',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '330',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'KUV100',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAHINDRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MC20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MASERATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '323',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RX7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MX3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ARTIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MAZDA6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MAZDA3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MAZDA2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'B',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CITAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CAPRI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCURY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BOBCAT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCURY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LYNX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCURY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MG3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MG5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MG4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COUNTRYMAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'JOHN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ROADSTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PACEMAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F56',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F57',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F55 5P COOPER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F56 3P COOPER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F56 3P COOPER S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COOPER 1.5 HB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COOPER S 2.0 HB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'JCW 2.0 HB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COOPER S 2.0',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COOPER 3 PUERTAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COOPER 5 PUERTAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COLT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'STARION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I-MIEV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MIRAGE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'STANZA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PULSAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SUNNY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MARCH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'NINJA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ALMERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TIIDA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'NOTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LEAF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'OLIMPIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'KADDET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'KADETT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ASTRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CORSA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ADAM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MOKKA X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MOKKA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '104',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '205',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '106',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '306',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '206',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '307',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '107',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '207',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '308',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '208',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '108',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'HORIZON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PLYMOUTH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SATRIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PROTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FUEGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R11',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R25',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R19',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CLIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R21',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TWINGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SAFRANE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MEGANE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LAGUNA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MEGANE2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SANDERO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MEGANE3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ZOE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CAPTUR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MEGANE4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'KWID',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MINI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '214',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '216',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '25',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '131',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '133',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PANDA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RITMO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FURA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RONDA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IBIZA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MARBELLA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LEON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '120',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FAVORIT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FELICIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FABIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SPACEBACK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'KAROQ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SCALA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'HATCHBACK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'J10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'J12',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'JUSTY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'STI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IMPREZA 5530',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IMPREZA 5535',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IMPREZA 5540',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'WRX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IMPREZA SPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CERVO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FRONTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FORZA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SWIFT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'JAZZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MARUTI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ALTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IGNIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AERIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SX4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CELERIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BALENO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SPRESSO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FRONX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'STARLET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'YARIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COROLLA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AURIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PRIUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'URBAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ZELAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RUSH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AYGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COROLLA SPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GR SUPRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COROLLA GR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'YARIS GR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ESCARABAJO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BRASILIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GOLF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '105',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GOL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SCIROCO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BUGGY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'POLO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BEETLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FOX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CROSSFOX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SURAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '345',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '343',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '440',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'V40',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'KORAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YUGO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SKALA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YUGO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '55',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YUGO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '65',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YUGO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FLORIDA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YUGO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '750',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZASTAVA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DS3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DS AUTOMOBILES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DS4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DS AUTOMOBILES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DS5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DS AUTOMOBILES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LEON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CUPRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '30X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAPLE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'T03 LUXURY EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEAPMOTOR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '001',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NAMMI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SIN MODELO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motor Home'),
    TRUE
  ),
  (
    'CAMPING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motor Home'),
    TRUE
  ),
  (
    'HIACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motor Home'),
    TRUE
  ),
  (
    'CAMPER-KOMBI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motor Home'),
    TRUE
  ),
  (
    'JORKER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motor Home'),
    TRUE
  ),
  (
    'CAMPING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motor Home'),
    TRUE
  ),
  (
    'CAMPER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motor Home'),
    TRUE
  ),
  (
    'KARGMAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motor Home'),
    TRUE
  ),
  (
    'RS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PEGASO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RALLY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LEONARDO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RXV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SXV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ETV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RSV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TUONO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SHIVER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MANA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPORTCITY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RSV4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CAPONORD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ETX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RS660',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TUAREG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RS457',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'APRILIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CHETAK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAJAJ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'M',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAJAJ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PULSAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAJAJ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DOMINAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAJAJ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BASHAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TORNADO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TNT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TREK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '302R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LEONCINO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TRK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TNT 150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TNT 600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PANAREA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENYI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENZHOU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BIGFOOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DB5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BIMOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DB7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BIMOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TESI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BIMOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DELIRIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BIMOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DB8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BIMOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DB9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BIMOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'IMPETO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BIMOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TESI  H2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BIMOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '750 CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'K',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'G',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HP4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'G 310',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'K 1600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'K1600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R NINET PURE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R NINET URBAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R NINET RACER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'C 400 GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'C 400 X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F 750',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F 850',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R 1250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F 900',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R NINET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'S 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'C 400',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F 750 GS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F 850 GS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R18',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R1200 SCRAMBLER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R 1250 GS ADV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R 1250 GS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R 1200 NINET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'K 1600 GTL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'K 1600 B',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F 850 GS ADVENTURE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R 18',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'M 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'G 310 R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'M 1000 RR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R 1250 RT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R 1300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BOATIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUELL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUELL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '1125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUELL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUELL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PURSANG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BULTACO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ALPINA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BULTACO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SHERPA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BULTACO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FRONTERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BULTACO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STREAKER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BULTACO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MITO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CAGIVA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RAPTOR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CAGIVA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CFMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CFMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JETMAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CFMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'X LANDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CFMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CFMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CFMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TERRALANDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CFMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CFMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'Z6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CFMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CFMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'Z8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CFMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'X8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CFMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LIBERTY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAELIM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DREAM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAELIM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CITI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAELIM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAGMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAELIM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'S2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAELIM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAYUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TORITO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAYUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '500CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '750CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MONSTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HYPERMOTARD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EVO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STREETFIGHTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '1198',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DIAVEL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PANIGALE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MULTISTRADA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HYPERSTRADA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'THROTTLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCRAMBLER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SIXTY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPERSPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XDIAVEL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '1299 PANIGALE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PANIGALE V4 S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PANIGALE V4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '959 PANIGALE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HYPERMOTARD 939',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCRAMBLER 800',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MULTISTRADA 1200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MULTISTRADA 1260',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MULTISTRADA 950',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PANIGALE V4S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MULTISTRADA 950S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCRAMBLER 1100',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCRAMBLER 800 ICON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPERLEGGERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DIAVEL 1260',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MULTISTRADA V4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MULTISTRADA V4 S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PANIGALE V4 SP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MONSTER PLUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PANIGALE V2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DIAVEL 1260S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MULTISTRADA V2 S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STREETFIGHTER V2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STREETFIGHTER V4S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XDIAVEL S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DESERTX STAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DIAVEL V4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MULTISTRADA V4 RALLY FULL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MULTISTRADA V4 RALLY RADAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCRAMBLER 800 NIGHTSHIFT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DESERTX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUCATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FRILLER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DUNNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LOW RIDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DYNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HJ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EUROMOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'QJ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EUROMOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GXT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EUROMOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EUROMOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EUROMOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'QM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EUROMOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'QM-20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EUROMOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VINTAGE CAFE 150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EUROMOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KD150J',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EUROMOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'REX150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EUROMOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FAT BOY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FLSTF'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FOX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOX'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DI FOX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOX'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FXA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GARELLI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GARELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KATTIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GARELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EC 350 F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EX 250F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EX 300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EX 350F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EX 450F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MC 250 F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MC125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EC 250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EC 250 F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EC 300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MC 50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MC 65',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MC 85 19/16',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EX 250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MC 450 F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MC 350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '350 XC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GASGAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RUNNER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GILERA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NEXUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GILERA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GILERA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '850CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GUZZI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BREVA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GUZZI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GRISO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GUZZI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NORGE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GUZZI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GUZZI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STELVIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GUZZI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GUZZI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GUZZI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HAO HJ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAO JUE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAO JUE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DR160S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAO JUE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KA150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAO JUE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NK150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAO JUE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VS125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAO JUE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TR150S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAO JUE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DL160',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAO JUE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '175CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '250CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LOW RIDE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSTF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XLH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHRI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSTC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSTN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDWG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSTC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSTSB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSTS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSTS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLTRI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHRCI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHTCUI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXST',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDXT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSTB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSTD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSTCI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSTFI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSTCI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSTDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPORTSTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHTI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VRSCA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHRSI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSTSI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHPI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDLI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSTI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSTNI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHXI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDBI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSTBI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSTFSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHRC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHRS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHTCU',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHTCUSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VRSCR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VRSCAW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VRSCAWA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VRSCDXA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DYNA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXCW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXCWC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSTSB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHRSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VRSCF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDFSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSTSEE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VRSDXA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLTRX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSTFB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHTK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHXSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSTSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VRSCDX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSBSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLTRXSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VRSCDF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FSXB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHTCUTG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHTKSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHXS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLTRXS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHTCUTC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSTNSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLTRUSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STREET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHTKL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSTFBS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHRXS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDLS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLDE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLFB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLFBS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHCS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXBRS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXBB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXBR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLRT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXFB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXFBS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXLR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHX STREET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHXS STREET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLSB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLTRT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLTRU ROAD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXDRS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XL 1200 NS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XL 1200 XS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHTCUTGSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLTRK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXLRS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXST SOFTAIL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RA1250S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHR   ROAD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXBBS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RH1250S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHXSE CVO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHCSANV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHTKANV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLHXSANV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLFBSANV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLTRKSEANV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLTRXX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FXLRST',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RH975S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARLEY-DAVIDSON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HARTFORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HENSIM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HERO PUCH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HERO-PUCH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TURBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HERO-PUCH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BAJAJ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HERO-PUCH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCOOTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HERO-PUCH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '175CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '100CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '125CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ST',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CBX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XLX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CBF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MTX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'QR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'H',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TRX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VFR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EVE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HURRICANE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AX1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CBR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'Z',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XRV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CRM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XLR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CMT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FES',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VTG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VTR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCOOTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RVT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CRF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CTX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '100 CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CGL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NXR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CGR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CMX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VMEN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'INVICTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XRE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ELITE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MUV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PCX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FZFI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STORM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SHADOW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CGR 125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NEW ELITE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SXS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CRF1100',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CRF1100 SPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NAVI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CB500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XL750 TRANSALP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CRF 300L',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSABERG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSABERG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSABERG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'WR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SMS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NUDA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TXC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TERRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '701',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPERMOTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SVARTPILEN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VITPILEN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '150I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '300I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TC 85 17/14',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '701 SUPERMOTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '701 ENDURO LR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FE 350 ROCKSTAR EDITION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TE 300I ROCKSTAR EDITION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NORDEN 901',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FE 250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TX 300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FX 350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TE 125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FE 350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HUSQVARNA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CRUISE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PRIMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SENSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUP/CAB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CAB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MIDAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'G PRIX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AQUILA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GT250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GT650',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYOSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCOUT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CHIEF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DARKHORSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ROADMASTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CHIEFTAIN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPRINGFIELD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CHALLENGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CHALLENGER 1800',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CHIEFTAIN 1800',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CHIEFTAIN 1900',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FRT 1200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCOUT SIXTY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INDIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '50CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAWA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '350CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAWA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '80 ENDURO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAWA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JIANSHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'Z',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '650',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '1000CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LTD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GPZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LEAD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BELUGA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GTZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NINJA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R TURBO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KDX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GPX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KLR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZZR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '65 HERO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KMX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KLF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KLX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KEF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KVF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MOJAVE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PRAIRE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'WIND',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KFX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VULCAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BAYOU',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MULE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VERSYS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CONCOURS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ATV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KIL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TERYX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'W',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KXF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'Z400',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BRUTE FORCE 300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KLR 650',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KLX 110R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KLX 140RF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KLX 300R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KLX230R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KX250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KX450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NINJA 400',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NINJA ZX10R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VULCAN S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'Z650',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'Z900 ABS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZX6R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VERSYS 300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAWASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAYAK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPEED',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MATRIX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPERLIGHT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DORADO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPERSHADOW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RKS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RKV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NOVA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V BLADE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BLACKSTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RK6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PESARO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CITYBLADE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SILVERBLADE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TARGET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TXM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'K LIGHT 202',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RK 150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RKV 150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TNT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'K LIGHT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RK-200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPERLIGHT 200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V302C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TX150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'M',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VIESTE 300 XDV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KEEWAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KINLON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'WY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KINLON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KINLON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCARTT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KINLON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KINLON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '65',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '380',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '400',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '540',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '640',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '520',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '660',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '950',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '85',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '990',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LC4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPERMOTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SIPERENDURO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPERDUKE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ADVENTURE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EXC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EXC-E',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '530',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '530XC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '325',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '640 SXC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EXC-F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EXC-R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SX-F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RALLY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '625',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '690',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '1190',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '105',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FREERIDE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '390',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '1050',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '1290',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '1090',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '125 SX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '150 SX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '250 SX-F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '250 XC-F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '350 SX-F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '450 SX-F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '450 EXC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '500 EXC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '50 SX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '65 SX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EXC SIX DAYS TPI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EXC TPI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XC-F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPER ADVENTURE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPER ADVENTURE S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DUKE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SX 17/14',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPERDUKE R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EXC-F SIX DAYS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ADVENTURE R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EXC TPI 300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPER ADVENTURE R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XC-W TPI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '690 ENDURO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '250 EXC-F SIX DAYS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '250 SX-F TROY LEE DESIGNS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '300 XC TPI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '350 EXC-F WESS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '790 ADVENTURE R  RALLY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '85 SX 17/14',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XCF-W',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '150 XC-W',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ADVENTURE RALLY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SX 19/16',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '125 XC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '300 WC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '350 XC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '390 DUKE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '85 SX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ADVENTURE 390',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XC-',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '300 SX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SMR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DUKE 250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EXC 250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EXC SIX DAY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XC-W',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KTM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MXER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GRAND DINK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VENOX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PULSAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AGILITY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PEOPLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BET WIND',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XCITING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DOWNTOWN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MONGOOSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAXXER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DOWNTOWN 200I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PEOPLE 150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPER 8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XCITRING500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'K-XCT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'X-TOWN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XTOWN 300I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KYMCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAMBRETTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'P.PROVISORIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VIRAGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF125T-15',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF150-10F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF150GY-4(II)',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF150T-C(II)',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF200-10L',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF200-10P',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF200-10R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF200-3B',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF250-3R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF250-D',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF 150-10E',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF 200-14F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF150-12C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF150-T8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KPV150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SS2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'K19',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V16S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MULTIPROPOSITO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KPT400',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LIBERTY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LML'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LONCIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LX500DS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LONCIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LX650',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LONCIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LX300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LONCIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LONCIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LONCIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LONCIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CJ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LUOJIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAICO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAICO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAICO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MONTELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SNAKE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MONTELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STRONG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MONTELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CHEVELLI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MONTELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MOUNTAIN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MONTELLI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '175CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MONTESA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '250CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MONTESA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '300CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MONTESA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '350CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MONTESA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '50CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MONTESA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'COTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MONTESA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ENDURO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MONTESA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MONTESA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MOBILETTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTO BECANE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPEED',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTOMEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SURFER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTOMEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTOMEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SKUA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTOMEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STRATO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTOMEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RIDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTOMEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'M8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTOMEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MOTORD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTOMEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SIRIUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTOMEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XPLORA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTOMEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FREEWAY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TTX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TYPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CUSTOM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LEOPARD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RETRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MATRIX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'IMPERIAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'REVEL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HIGHWAY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PHANTOM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VMAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MXR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NEW CUSTOM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ELIMINATOR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SMX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SRX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GO KART',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YZF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MOTORRAD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CS1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'REBEL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KDX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KXD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NAKED',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RACER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SKYPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TEKKEN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VIP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CAFE RACER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EXPRESS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CORSA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RACER 300R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CARGO MAX 150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MRC 300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MRC 300 TOURING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TEKKEN 300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TTX150 TYPE BROSS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TTX300 TYPE BROSS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TTX300 TYPE XRE TOURING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RACER 250RR (CBR)',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RACER 250RR TIPO (YZF R6)',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MT25',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R15',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XMM250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TEKKEN 250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TEKKEN 250 TOURING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZX150R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CG150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MRC150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MRC150 TOURING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TTX150 TYPE ROAD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NAKED 150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPER CG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTORRAD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HAWK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLASH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FREEDOM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TWISTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EVOLUTION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EXECUTIVE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MSK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NKT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TROOPER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BRUTALE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '312',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RIVALE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DRAGSTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TURISMO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STRADALE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TURISMO VELOCE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BRUTALE 800',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RUSH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPERVELOCE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BRUTALE 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F3 800',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DRAGSTER 800 RR ABS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RUSH 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BRUTALE 1000 RR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MV AGUSTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OSSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DJANGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'METROPOLIS 400',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TWEET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TWEET 125 PRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DJANGO 125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TWEET 170',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'METROPOLIS ME400',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XP400ZG W3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PGO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GMAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PGO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PGO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VESPA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIAGGIO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TYPHOON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIAGGIO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HEXAGON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIAGGIO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NRG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIAGGIO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZIP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIAGGIO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIAGGIO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LIBERTY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIAGGIO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'X8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIAGGIO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MP3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIAGGIO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XEVO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIAGGIO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'X10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIAGGIO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'APE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIAGGIO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIONNER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XF200-2A',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PIONNER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TRAIL BOSS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TRAIL BLAZER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XPLORER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAGNUM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EFI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RMK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '800',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PRO RMK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CREW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DAKAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FOREST',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FARMHAND',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GENERAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLARIS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'REGAL RAPTOR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LOW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'REGAL RAPTOR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'REGAL RAPTOR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BOBBER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'REGAL RAPTOR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DAYTONA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'REGAL RAPTOR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RAPTOR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'REGAL RAPTOR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPYDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'REGAL RAPTOR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CAFE RACER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'REGAL RAPTOR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PILDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'REGAL RAPTOR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RIZATO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RIZATO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MADASS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SACHS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'X-ROAD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SACHS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AMICI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SACHS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANLG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'X WOLF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JOYRIDE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GTS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CITYCOM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CHIN WANG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAXSYM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'WOLF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HD2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ORBIT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FIDDLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'T',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CROX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'QUADLANDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'QUADRAIDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JOYMAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'X-WOLF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VS 150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CRUISYM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GTS 250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TL 500I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAXSYM 400I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CRUISYM 300I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JOYMAX 300I Z+',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JOYRIDE 200I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SANYANG SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ESCOOTER MO 125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MOTARD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SHARK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VIPER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MATRIX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ADVENTURE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FIREBLADE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'WINDBLADE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TERMINATOR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CRUISER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SHINERAY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ENDURO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ELISE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EXPRESS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ROAD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TIGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAGNUM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RUNNER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPIDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PREMIER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TITAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VESPI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DIAMOND',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SHINERAY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKYGO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CXM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SPITZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DXB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SPITZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TXM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SPITZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JIALING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SPITZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '90CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '125CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '185CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '250CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '500CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '750CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'A',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'M',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GSX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GSL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LTF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RMX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GSXR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RGV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GSF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '750 INTRUDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DRZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LTZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RMZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GSR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VZR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LTR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SFV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HAYATE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TU',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'INAZUMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GSXS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'INTRUDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SV650',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V-STROM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BURGMAN STREET EX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'OB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'WY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HAWK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CHAMPION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GRACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'WINDSTAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XTR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TKR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BIG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VISION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'A9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HJ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GAZELLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KIDDY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BROS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'COLT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'EN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SMX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SMM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '4T',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TORITO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '750CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STREET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DAYTONA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AMERICA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'THRUXTON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCRAMBLER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BONNEVILLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPEEDMASTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPEED',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TIGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPRINT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ROCKET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'THUNDERBIRD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TROPHY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BOBBER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STREET TRIPLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPEED TRIPLE 1050',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TIGER 1200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TIGER 800',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCRAMBLER 1200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TIGER 900',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ROCKET 3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPEED TRIPLE 1200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TIGER 850',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TRIDENT 660',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TIGER 660',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BONNEVILLE SPEEDMASTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPEED TWIN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCRAMBLER 900',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TRIUMPH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCOOTY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TVS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'APACHE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TVS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'APACHE 310RR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TVS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NTORQ 125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TVS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RTR 160 FI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TVS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RTR 200 FI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TVS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RAIDER 125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TVS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RONIN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TVS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAGNETIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MATRIX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'X PEED',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DSF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SMF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RENEGADE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V2S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FASTWIND',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V2C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GP1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'X TREET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'Z',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DSR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DSR-20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RENEGADE-20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XTREET-20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DSRX 150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FASTWIND 150 XR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FLASH XR 110',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'POWERMAX 150 EVO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RENEGADE CLASSIC 300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RENEGADE COMMANDO 300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RENEGADE FREEDOM 300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RENEGADE SPORT 150 S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RENEGADE VEGA 300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XTREET RS 150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MOTOCICLETA XTREET RS 250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XTREET RS 250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UNITED MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TIGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'URAL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VERONA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VERONA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VICCO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VERONA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GIOCCO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VERONA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FINETTI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VERONA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TRENTTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VERONA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BICI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HINDU',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ELECTRONICA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GTS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GRANTURISMO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LXV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '946',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PRIMAVERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VXL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ONE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPRINT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VESPA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'WY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'WANGYE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'WOLKEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FOXHOUND',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'WOLKEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MEGELLI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'WOLKEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CRONOS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'WOLKEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XGJ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'XGJAO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'XINGYUE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'XMOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'G1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XJ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'V',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAXIM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FZR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TENERE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'IZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TDR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'PW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YFS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YFP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XTZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'WR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'JOG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SERROW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RXS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YFB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BWS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'T',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YZF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XVS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TDM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XVZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YFA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XJR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FJR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TTR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VMAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CRUX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FZ6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YBA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'VSTAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FZ1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YBR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YXR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FZ8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZXT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RXT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FZN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XJ6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GDP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YXZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GPD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XSR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KODIAK-20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TRACER-20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TRACER.20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XMAX-20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YFM-20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YZ-20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YZF-20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YZ-250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FZ-S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MOTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BOLT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NMAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YZ-125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YZF-R7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YZF-R3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YZ-450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FZN-150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CIGNUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'FZ-X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAHA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YRF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YAMAMOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'YX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'YINXIANG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BICI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZANELLAS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZNEN GROUP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RAPID',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'Z ONE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'STORM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'THUNDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZSR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RAZOR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'Z ROAD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MILANO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'Z ONES',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZII',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CINECO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RA1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RC3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RX3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONGSHEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'K',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZUNDAPP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'UTV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LINHAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BULLET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROYAL ENFIELD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CLASSIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROYAL ENFIELD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CONTINENTAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROYAL ENFIELD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HIMALAYAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROYAL ENFIELD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'INTERCEPTOR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROYAL ENFIELD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'METE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROYAL ENFIELD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'METEOR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROYAL ENFIELD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCRAM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROYAL ENFIELD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HUNTER 350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROYAL ENFIELD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SHOTGUN 650',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROYAL ENFIELD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SUPER METEOR 650',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROYAL ENFIELD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GRR 450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROYAL ENFIELD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ADX 300I ABS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ADXTG 400I ABS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SYM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TDR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PALLA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'TS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUPER SOCO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MG500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MOTRAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F4N',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CORSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F4R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CORSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'Z4N',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CORSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZX4R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CORSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GP4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CORSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CORSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'N335',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CORSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CORSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZX335',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CORSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'R335',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CORSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RZ3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CORSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CUSTOM 335',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CORSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MG500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CORSA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZT310',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONTES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZT155',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONTES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONTES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GKSPORTS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONTES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'F703',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZONTES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ECO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'E-TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ELT05',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'E-TAKASAKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SCOOTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AIMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GM440',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SWM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SWM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SD440',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SWM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SWM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'XY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SWM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SIX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SWM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'AC6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'HR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '650',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    '250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'LX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZP108',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SPEED UP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZP18',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SPEED UP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RD SPYDER RT LTD 1330',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRP CAN AM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'DRAGSTER 200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ITALJET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF150 NK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF250 NK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF250 SR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF300 CLX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF300 NK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF300 SR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF400 GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF400 NK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF650 GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF650 MT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF650 NK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF650 TR-G',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF700 CLX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF700 SPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF800 MT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF450NK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF450SR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF700 MT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF800 MT EXPLORER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF800 NK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF250 NK FUN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF250 SR FUN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF450 CL-C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF450 MT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF450SR-S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF250 CL-C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF300 SR-S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF450 CL-C BOBBER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF675 NK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF675 SR-R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF700 MT-X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'CF800 MT-X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CF MOTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'WOLVERINE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAGGER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'MAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAGGER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SEIEMMEZZO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MORINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KOVE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'ZF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KOVE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'KY800X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KOVE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BD500-15 (CHINCHILLA 500)',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BD500-15 (NAPOLEON BOB)',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'BD700-2 (LFC 700)',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'RX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CYCLONE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'NX150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'QJMOTOR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Motocicleta'),
    TRUE
  ),
  (
    'SPACETOURER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'M5 - EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'DELIVER 9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'EDELIVER 9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'V80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'EV80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'G10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'G90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'VITO TOURER 116 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'SPRINTER 417 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'SPRINTER 517 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'SPRINTER 419 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'VITO 116 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'TRAVELLER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'BUKHANKA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UAZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Bus'),
    TRUE
  ),
  (
    'BEAUMONT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ACADIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SEDAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ACADIAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LEGEND',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ACURA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'INTEGRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ACURA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SPIDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SEDAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ALFETTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ALFA33',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ALFA75',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '164',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '155',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '146',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GTV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '166',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '159',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GIULIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '4C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PACER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AMERICAN MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DB9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DBS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RAPIDE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VIRAGE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VANQUISH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VANQUISH S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RAPIDE S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VANQUISH S ZAGATO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VANTAGE V12',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CABRIOLET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RS4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'W12',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TTR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TTS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TTRS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RS7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ALLEGRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUSTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'X55PLUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAIC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EU5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAIC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FLYING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENTLEY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MULSANNE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENTLEY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BENTAYGA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENTLEY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BENTAYGA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BENTLEY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '1602',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '520',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '530',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '525',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '2002',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '316',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '518',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '528',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '1.602',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '633',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '728',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '732',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '730',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '733',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '735',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '323',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '630',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '635',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '315',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '628',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '745',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '535',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '325',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '750',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '540',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '740',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '328',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'Z3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '523',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '545',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '645',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '550',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '650',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '760',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '335',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '135',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ACTIVE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '428',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '435',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M235',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '340',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '650 I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '440 I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '530 D',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '540 I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '530E',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '740E',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M550',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '30E',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '418I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '530I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '640I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '740I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '750I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '520D',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M340',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '330E',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '418',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '330I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '220 D',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M440',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M760',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '320I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M340I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M550I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '440I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '520I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '745E',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FSV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SPLENDOR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EUPHORIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'H230',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'KONECT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COMPACTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUICK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GRAN-SPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUICK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RIVIERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUICK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LE-SABRE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUICK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CENTURY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUICK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'APOLLO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUICK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'REGAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUICK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SKYLARK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUICK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SKYHAWK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUICK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'G3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'QIN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'HAN EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SEAL EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'E5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EL-DORADO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CADILLAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FLEETWOOD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CADILLAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CALAIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CADILLAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SEVILLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CADILLAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DE-VILLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CADILLAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SEVEN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CATERHAM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SIGMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CATERHAM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CV2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EADO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ALSVIN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A516',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S21',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ARRIZO 3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ARRIZO 5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ARRIZO 7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ARRIZO 6 PRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CHEVELLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CHEVY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IMPALA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MALIBU',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CAMARO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MONTECARLO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BEL-AIR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CAPRICE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BYSCAINE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CORVAIR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'OPALA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LAGUNA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VEGA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DIPLOMATA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MONTEGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MONZA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COMODORE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CELEBRITY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '1.300_KG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MARAJO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CAVALIER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ASKA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GEMINI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SPECTRUM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BERETTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CORSICA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LUMINA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VECTRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EPICA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'OPTRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COBALT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PRISMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IMPERIAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CORDOVA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LE-BARON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VISION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'NEON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'STRATUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '300 M',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SEBRING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '300 C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C-AZAM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GSA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XANTIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XSARA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ESPERO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RACER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PRINCE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'HEAVEN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SUPER-SALON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'POINTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LEGANZA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'NUBIRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CHARMANT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MAX-CUORE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'APPLAUSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COPEN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SEDAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '260C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '120Y',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '180K',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'B210',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '180B',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '140J',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '160B',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '140Y',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '150Y',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '180SX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BLUEBIRD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CEDRIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LAUREL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DART',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CHARGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CORONET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SEDAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SWINGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VALIANT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ASPEN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GALANT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LANCER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COLT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CROWN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ARIES',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CHALLENGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'A30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'JOYEAR S50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AX4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'YIXUAN AT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'YIXUAN MT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'E70',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AEOLUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S50EVE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '125P',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'F.S.O.'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'V5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FAW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'B50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FAW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F360',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F430',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F599',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F149',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CALIFORNIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F12',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '488',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '812',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GTC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'F8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FERRARI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '124',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '125',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '128',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '132',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '131',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ARGENTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'X-1/9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'OGGI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'REGATA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DUNA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PREMIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TEMPRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MAREA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SIENA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BARCHETTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LINEA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CRONOS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '17-M',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CUSTOM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '12-M',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FAIRLAINE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FALCON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CAPRI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CORTINA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CORCEL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CONSUL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ESCORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FAIRMONT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DEL_REY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CROWN_VICTOR.LX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CONTOUR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EUROESCORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GA5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GAC GONOW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GC7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CK3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EMGRAND 7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VOLEEX-C30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VOLEEX-C50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TRANSFORMADO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HILLMAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PRELUDE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LEGEND',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'STELLAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SONATA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COUPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ELANTRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AZERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GENESIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CENTENNIAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EQUUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'I-10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VERNA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VERNA CB 1.4 MT PLUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'G25',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'G37',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'M37',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'G',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'Q60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'Q70',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'Q50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COUPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ISUZU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SEDAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ISUZU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ISUZU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BCLASS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'J4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XJ6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DAIMLER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SOVEREIGN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XJS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '9000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XJR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XK8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XJ8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S-TYPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XKR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'X-TYPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XJ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'XF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRAND CHEROKEE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JEEP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BRISA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SEPHIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AVELLA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CLARUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'OPTIMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SPECTRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'OPIRUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MAGENTIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CADENZA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'KOUP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'QUORIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'STINGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SOLUTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'K3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SORENTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '2105',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '2107',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '2106',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '21093',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '21060',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '21053',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '21099',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '21074',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '21073',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '21070',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GAMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LANCIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'APPIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LANCIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EXECUTIVE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LANCIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PRISMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LANCIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'THEMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LANCIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DEDRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LANCIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'KAPPA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LANCIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EVOQUE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GS300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IS250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LS460',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SC430',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GS460',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IS350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LS600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GS350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ES350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GS250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GS350F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GS450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IS300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RC350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GS200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ES250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IS200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LS500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LS500H',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ES300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '620',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '530',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '630',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CONTINENTAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LINCOLN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ELISE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LOTUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EXIGE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LOTUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EVORA S SPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LOTUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ELISE CUP 250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LOTUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EXIGE SPORT 390',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LOTUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ELISE SPORT 240',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LOTUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COUPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MASERATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'QUATTROPORTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MASERATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SPYDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MASERATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GRANSPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MASERATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GRANCABRIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MASERATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GHIBLI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MASERATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RX2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '808',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '929',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '616',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '626',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MX6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MIATA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '121',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RX8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MP4-12C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '650',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'P1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'V180',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '570',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '540',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '675LT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '720S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SENNA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '720S SPIDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '765LT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MCLAREN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '190',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '220',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '230',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '280',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '180',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '230/6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '240',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '380',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '260',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '420',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '560',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '320',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CLK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SLK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CLS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CLC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SLS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SLC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'D',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EQS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MAYBACH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COMET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCURY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ZEPHIR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCURY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MONARCH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCURY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COUGAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCURY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'HAT.',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCURY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LIFTGATE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCURY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MARQUIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCURY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SABLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCURY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ZT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '550',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DELUXE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MG550',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MG750',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MG6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MG350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MGGT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MG360',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MG GT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MG 5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GALANT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LANCER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SAPPORO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ECLIPSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '4/4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MORGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PLUS 4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MORGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AERO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MORGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '280',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '180',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BLUEBIRD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CEDRIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LAUREL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SENTRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ALTIMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MAXIMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SILVIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '240',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'V16',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GXE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PRIMERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PLATINA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '350Z',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '370Z',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TEANA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VERSA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SENSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PRINZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '42',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OLDSMOBILE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CUTLASS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OLDSMOBILE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DELTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OLDSMOBILE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'NINETY-EIGHT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OLDSMOBILE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'OMEGA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OLDSMOBILE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TORONADO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OLDSMOBILE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'STAR-FIRE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OLDSMOBILE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COMMODORE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'KAPITAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'REKORD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MANTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ASCONA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'OMEGA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VECTRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CALIBRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'INSIGNIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'INSIGNIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CASCADA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'INSIGNIA GS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '404',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '204',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '504',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '304',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '604',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '305',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '505',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '309',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '405',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '605',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '406',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '806',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '607',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '407',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RCZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '508',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '301',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '508',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '125-P',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLSKI FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'POLONES',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'POLSKI FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BONEVILLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CATALINA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'G.T.O.',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GRAN-PRIX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LE-MANS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TEMPEST',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VENTURA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FIREBIRD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SUNBIRD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TRANS-AM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ASTRE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COUPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PHOENIX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '924',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PORSCHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BOXSTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PORSCHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '910',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PORSCHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CARRERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PORSCHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CAYMAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PORSCHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PANAMERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PORSCHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '918',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PORSCHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TAYCAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PORSCHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'NATURA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PROTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PERSONA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PROTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PREVE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PROTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GTS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PUMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PUMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FLORIDE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IKA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R12',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R18',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LOGAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SYMBOL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'FLUENCE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LATITUDE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GHOST',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROLLS ROYCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PHANTOM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROLLS ROYCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'WRAITH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROLLS ROYCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DAWN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROLLS ROYCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '400',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '800',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '827',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '220',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '414',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '416',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '420',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '620',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '623',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '825',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '45',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '75',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '900',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAAB'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '9000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAAB'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '9-5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAAB'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '9-3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAAB'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BIRD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAEHAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ROYALE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAEHAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S-BIRD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAEHAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SQ5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAMSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SM3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAMSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SM5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAMSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SM7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAMSUNG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '127',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MALAGA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TOLEDO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CORDOBA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GLS-SEDAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SIMCA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'OCTAVIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SUPER_COMFORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'RAPID',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SUPERB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C52',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C61',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C81',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R51',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'R81',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COUPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'HARDTOP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SEDAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '1.6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GLF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '1.8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LOYALE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LEGACY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BRZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'OUTBACK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IMPREZA 5510',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IMPREZA 5515',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'IMPREZA 5520',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'WRX 2625',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'WRX 2606',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'KIZASHI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CIAZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DZIRE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'DZIRE SEDAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CORONA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CROWN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CELICA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CARINA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CRESSIDA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CAMRY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'TERCEL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LEXUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PASEO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AVENSIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COROLLA SEDAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'COROLLA SEDAN HV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'KARGMAN-GHIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'T.L.',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VARIANT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'PASSAT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SCIROCCO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SEDAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'JETTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AMAZON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VOYAGE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SANTANA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ATLANTIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VENTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'BORA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'VIRTUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '164',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '142',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '144',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '244',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '264',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '245',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '262',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '240',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '242',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '360',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '760',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '740',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '460',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '850',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '940',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '960',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'C70',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S40',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S70',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'S60 II',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'SIN MODELO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZASTAVA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '1500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZASTAVA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'REVERO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KARMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GA4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'AION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EMPOW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'LX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EXEED'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    '60S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAPLE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MODEL 3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TESLA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'MODEL Y',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TESLA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MODEL Y',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TESLA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'ALFA33',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ALFA_SPORTWAGON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '500X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ALFA ROMEO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CHEROKEE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AMERICAN MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LAREDO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AMERICAN MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RENEGADE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AMERICAN MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CJ-8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AMERICAN MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'STANDARD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ARO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DACIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ARO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ROCSTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DBX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DBX707',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASTON MARTIN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '100',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'A6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'S2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'S4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'S6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'A4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ALLROAD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'Q5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'S3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'Q3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RS3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RS4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RSQ3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'Q7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RS6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SQ5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'Q2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'A3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'Q8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'E-TRON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RS E-TRON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'Q8 E-TRON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SQ8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RSQ8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SQ7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'Q4 E-TRON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'Q6 E-TRON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X25',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAIC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X35',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAIC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X55',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAIC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BJ40 PLUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAIC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BAIC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BJ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BEIGING'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '535',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '550',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ACTIVE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '320',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '328',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '335',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'M135I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'Z4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'IX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'IX3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'IX1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '330I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'IX2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'V5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'V3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KONECT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'G05',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SPORT-WAGON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUICK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SKYHAW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BUICK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'S6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TANG EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TANG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BYD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ESCALADE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CADILLAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CS1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CS35',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CS15',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CS75',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'A500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CX70',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CS55',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'UNIT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'UNIK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHANGAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIGGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRAND TIGGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIGGO 1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIGGO 3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIGGO 2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIGGO 7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIGGO 4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIGGO 8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'K60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIGGO 2 PRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIGGO 7 PRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIGGO 8 PRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIGGO 3 PRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIGGO 8 PRO MAX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BLAZER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CARAVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'VERANEIRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MARAJO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TROOPER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LUMINA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ZAFIRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TRAILBLAZER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'VIVANT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EQUINOX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CAPTIVA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TRACKER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NG TRAVERSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SPIN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TAHOE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TRAVERSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GROOVE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SUBURBAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BOLT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SPARK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CHEROKEE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'WRANGLER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRAND CHEROKEE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PACIFICA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'AMI-8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GSA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ZX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'REFLEX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XANTIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XSARA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'C4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'C5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRAND C4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DS4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DS5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'C3 AIRCROSS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'C5 AIRCROSS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BASALT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BERLINGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '1.410',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DACIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '10.4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DACIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NUBIRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KORANDO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MUSSO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'REZZO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAEWOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CHARMANT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TAFT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ROCKY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FEROZA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRAN-MOVE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TERIOS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'YRV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DAIHATSU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '100A',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '120Y',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '160J',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '140J',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '140Y',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '150Y',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '180B',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BLUEBIRD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ROYAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CALIBER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DURANGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NITRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JOURNEY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'H30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JOYEAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MULTIPROPOSITO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'OTING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'AX7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '580',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'AX3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'AX5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JOYEAR SX5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JOYEAR SX6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JOYEAR SX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'S500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'YIXUAN GS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'T5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'T5 EVO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MAGE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '1.500-CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'F.S.O.'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'POLONEZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'F.S.O.'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'B50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FAW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FAW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'D60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FAW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'R7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FAW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '128',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '131',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RITMO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PANORAMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DUNA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TEMPRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MAREA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PALIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'STILO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'WEEKEND',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '500L',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '500X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PULSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FASTBACK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'COUNTRY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'E250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'E150',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'U50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BRONCO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BELINA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'E350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'WINDSTAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ESCORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EUROESCORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ESCAPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ECOSPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EDGE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EXPEDITION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ESCAPE MCA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BRONCO SPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SAUVANA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JIMMY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'G.M.C.'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BLAZER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'G.M.C.'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GS5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GAC GONOW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EX7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'COOLRAY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'AZKARRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GEELY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HOVER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SAFE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HAVAL3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HAVAL5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HAVAL-M4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HAVAL-H3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HAVAL-H6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HAVAL6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'H2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HAVAL 3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TANK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JOLION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HAVAL JOLION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HAVAL H7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'H6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GREAT WALL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HAIMA7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAIMA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'H2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAVAL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'H6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAVAL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'H7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAVAL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JOLION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAVAL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DARGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HAVAL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CIVIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ACCORD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CR-V',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HR-V',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'STREAM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PILOT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'WR-V',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ZR-V',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PONY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GALLOPER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ELANTRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SANTA FE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TUCSON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CRETA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRAND SANTA FE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'VENUE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PALISADE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TUCSON NX4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CRETA GRAND',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KONA OS EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KONA OS HEV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'IONIQ 5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KONA SX2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SANTA FE MX5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EX37',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FX37',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'QX60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'QX70',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'QX80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'QX30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'QX 30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'QX 50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'QX 70',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'QX 80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INFINITI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CORTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INTERNATIONAL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SIN MODELO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INTERNATIONAL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'REIN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TRIP',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'S5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'S3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'S2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRAND S3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'S1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'S4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JS2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JS3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JS4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JS8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JS6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EJS4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JS2 PRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JS8 PRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'IGNITE E30X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X-TYPE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XFR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'F-PACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'E-PACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'I-PACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAGUAR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CHEROKEE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JEEP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'WRANGLER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JEEP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'COMPASS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JEEP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PATRIOT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JEEP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RENEGADE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JEEP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GLADIATOR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JEEP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'COMMANDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JEEP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ALTITUDE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JEEP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'AVENGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JEEP'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SPORTAGE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FAMILY-WAGON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CARENS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RETONA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SORENTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NIRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SOUL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SELTOS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SONET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EV6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EV9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'K3 CROSS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EV5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NIVA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '2104',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '21043',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '2107',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '21044',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '21053',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NIEVA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LARGUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LADA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'URUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAMBORGHINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GEMMA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LANCIA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CORTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SANTANA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DISCOVERY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RANGE ROVER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FREELANDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DEFENDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EVOQUE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RANGE ROVER SPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RANGE ROVER VELAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DEFENDER 110',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DEFENDER 130',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DEFENDER 90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RANGE ROVER EVOQUE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DISCOVERY SPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LUX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LANDWIND'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LX570',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RX350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RX450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NX200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NX300H',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NX300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LX 500D',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NX350H',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LBX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LX500D',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NX250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RX350H',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RX500H',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'UX200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'UX250H',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'UX300H',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NX450H',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RX450H',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X70',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIFAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SCORPIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAHINDRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XUV500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAHINDRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'QUANTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAHINDRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XUV300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAHINDRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LEVANTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MASERATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'QUATTROPORTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MASERATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRECALE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MASERATI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EUNIQ 6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EUNIQ 5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EG50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'D60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'D90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '929',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '808',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '323',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '626',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TRIBUTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MAZDA6',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CX7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CX5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CX3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CX9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CX30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CX-60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CX-90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '230',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '250',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '280',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '240',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ML',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'G',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'R',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'C',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GLK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'G',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'CLS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GLA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'GLC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GLB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GLS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GLC 43',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '220',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '400',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '450',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '63 S',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EQA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MONTEGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCURY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRAND-MARQUIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCURY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MGGS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RX5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ZS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RX 5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MG RX 5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ZX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MARVEL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ONE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ZS EV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RX9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CLUBMAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'COUNTRYMAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'F55',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'F54',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'F60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'COOPER 1.5 HB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'COUNTRYMAN COOPER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JOHN COOPER WORKS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'COOPER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'COOPER S 2.0',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ACEMAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GALANT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MONTERO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LANCER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'OUTLANDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ASX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ECLIPSE CROSS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XPANDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MONTERO SPORT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PATROL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BLUEBIRD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SUNNY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'STANZA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SENTRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TERRANO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PRAIRIE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PATHFINDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'V16',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'AD-WAGON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X-TRAIL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MURANO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PRIMERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'QASHQAI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JUKE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KICKS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CUSTOM-CRUISER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OLDSMOBILE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CUTLASS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OLDSMOBILE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'VISTA-CRUISSIER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OLDSMOBILE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CARAVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CARAVAN-OLIMPIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'REKORD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KADDET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KADET-CARAVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KADETT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ASTRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'OMEGA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MERIVA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ANTARA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MOKKA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CROSSLAND X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRANDLAND X',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CORSA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRANDLAND',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CROSSLAND',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OPEL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '504',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '404',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '304',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '505',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '305',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '405',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '806',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '406',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '306',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '307',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '206',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '407',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '308',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '3008',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '4008',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '2008',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '5008',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TRAVELLER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '2008 P2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RIFTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FURY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PLYMOUTH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SATELITE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PLYMOUTH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BELVEDERE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PLYMOUTH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DUSTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PLYMOUTH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'VALIANT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PLYMOUTH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SIN MODELO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PLYMOUTH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'VOLARE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PLYMOUTH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'COLT-VISTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PLYMOUTH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRAND VOYAGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PLYMOUTH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ACCLAIM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PLYMOUTH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CAYENNE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PORSCHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MACAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PORSCHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CAYENNE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PORSCHE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  (
    'EXORA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PROTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'R21',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LAGUNA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SCENIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KOLEOS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DUSTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CAPTUR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ARKANA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CULLINAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ROLLS ROYCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '9-5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAAB'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '9-7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SAAB'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ALTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ALTEA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ARONA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ATECA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TARRACO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CUPRA ATECA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORMAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FELICIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FABIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'OCTAVIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ROOMSTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'YETI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SPACEBACK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KODIAQ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KAROQ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KAMIQ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ELROQ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ENYAQ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KORANDO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'MUSSO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'REXTON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ACTYON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KYRON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIVOLI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XLV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'STAVIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '4WD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LEGACY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'OUTBACK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORESTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EVOLTIS 1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EVOLTIS 1001',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EVOLTIS 1010',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EVOLTIS 1011',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORESTER 7300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORESTER 7305',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORESTER 7310',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORESTER 7315',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORESTER 7320',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORESTER 7325',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORESTER 7330',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORESTER 7331',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORESTER 7335',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORESTER 7340',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'OUTBACK 0585',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'OUTBACK 0595',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'OUTBACK 0600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'OUTBACK 0700',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'OUTBACK 0705',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'OUTBACK 0710',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'OUTBACK 0715',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'OUTBACK 0716',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XV  5710',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XV  5805',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XV  5810',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XV  5815',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XV  5820',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XV  5825',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XV 5715',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CROSSTREK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LJ80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LJ60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SJ410',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SJ408',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SJ413',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SAMURAI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'VITARA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'BALENO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NOMADE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SIDEKICK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRAND NOMADE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GRAND VITARA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'WAGON',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JIMNY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LIANA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'AERIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XL7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SX4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'S-CROSS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ERTIGA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'COROLLA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CORONA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CRESSIDA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TERCEL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LAND CRUISER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CARINA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RAV4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ADVANTAGE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'AVENSIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORTUNER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LEXUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FJ CRUSIER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RUSH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '4RUNNER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LAND CRUISER PRADO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'C-HR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'COROLLA CROSS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RAIZE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'YARIS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORTUNER GRS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'YARIS CROSS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'VARIANT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PARATI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SANTANA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'QUANTUM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GOLF',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PASSAT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GOL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'CROSSOVER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TOUAREG',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TIGUAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ATLAS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'T-CROSS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'NIVUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TAOS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ID.4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TERA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '145',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '245',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '740',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '745',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '940',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '960',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'V40',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'V70',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'V90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'V50',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XC60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'V60',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XC90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'XC40',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'V60CC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'C40',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EX30',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EX40',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EC40',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'WAGONIER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'WILLYS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HUNTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZOTYE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LANDMARK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZX AUTO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DS7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DS AUTOMOBILES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DS3 CROSSBACK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DS AUTOMOBILES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DS3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DS AUTOMOBILES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DS4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DS AUTOMOBILES'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '1000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RAM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SUV 580',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SUV 560',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '560 1.8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'IX5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SERES',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SUV 500',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SUV 600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DFSK'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'G03F',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SWM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'G05',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SWM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'G05 PRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SWM'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GS4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GS3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'GS8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EMKOO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'EMZOOM',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'GAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X70',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JETOUR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X70 PLUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JETOUR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'DASHING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JETOUR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JETOUR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'T2',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JETOUR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORMENTOR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CUPRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'FORMENTOR VZ MID LEATHER 2.0 TSI DSG 7 4X4',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CUPRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'ATECA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CUPRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'PA 2.0 TSI AT 4DRIVE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CUPRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '1.5 TSI MHEV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CUPRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HIGH 1.5 TSI MHEV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CUPRA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EXEED'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TXL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EXEED'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'VX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EXEED'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'RX',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'EXEED'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KYX3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAIYI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KYE5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAIYI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KYX7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KAIYI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'HUNTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UAZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'KAZAK',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'UAZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'C5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OMODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'E5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OMODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'C5 1.5L CVT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'OMODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JAECOO 7 1.6T DCT 2WD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAECOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JAECOO 7 1.6T DCT AWD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAECOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'J7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAECOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JAECOO 6 AWD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAECOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JAECOO 6 RWD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAECOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JAECOO 8 FWD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAECOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAECOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JAECOO5 1.5T CVT FWD',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAECOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'JAECOO7 1.5T SHS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAECOO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'C10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LEAPMOTOR'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'X6 PRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LIVAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '06',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LYNK CO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    '09',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LYNK CO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'AYA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NETA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'U',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NETA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SMART1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SMART'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SMART3',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SMART'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'TOPIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'COMBI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ASIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'Q7',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'AUDI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'H2L',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BRILLIANCE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'DESTINY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHERY'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'BEAUVILLE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'SPORTVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'SUBURBANO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'COACHMAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'WFR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'CHEVY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'ASTRO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'TAHOE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'SUBURBAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VENTURE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'UPLANDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'CAPTIVA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'TRAVERSE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'EXPRESS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'ORLANDO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'SPIN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHEVROLET'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'CARAVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'GRAND CARAVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'TOWN-COUNTRY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'PACIFICA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'GRAND TOWN-COUNTRY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CHRYSLER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'MULTISPACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'SPACETOURER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'BERLINGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'CITROEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VANETTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'URVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DATSUN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    '500 A 750 KGS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'SPORTMAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'WAGONIER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'CARAVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'GRAND CARAVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'DURANGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'JOURNEY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'GRAND CARAVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DODGE'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'SUCCE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'LINGZHI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'DONGFENG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'DUCATO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FIAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'TRANSIT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'AEROSTAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'EXPLORER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'EXPEDITION',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'WINDSTAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'ECONOLINE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FORD'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'CARGO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'ESCOLAR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VIEW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'K1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'FT-CREW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'K1 DIESEL 2.8',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'FOTON'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'CARRY-ALL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'G.M.C.'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'SAFARI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'G.M.C.'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VANDURA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'G.M.C.'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'ODYSSEY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'PILOT',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HONDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'GRACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'ELW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'H1',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'SANTAMO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'TERRACAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'TRAJET',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'COUNTY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VERACRUZ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'SANTA FE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'GRAND SANTA FE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'H350 SOLATI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'HYUNDAI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'CARRY-ALL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'INTERNATIONAL'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'WFR',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ISUZU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'REFINE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'SUNRAY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'HAISE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JINBEI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'HIGH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JINBEI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'TOURING',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'JMC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'BESTA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'TOPIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'CARENS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'CARNIVAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'COMBI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'JOICE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'RIO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'GRAND CARNIVAL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'MOHAVE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'SORENTO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'MOHAVE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'KIA MOTORS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'LARGO109',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'LARGO110',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'DEFENDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'DISCOVERY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'LAND ROVER'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'G10',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'V80',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAXUS'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    '1000_COACH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'E1600',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    '1600_COACH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'E2200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    '2200_COACH',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'MPV',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'E2000',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'MAZDA5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'CX9',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MAZDA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    '307',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    '310',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    '409',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'MB',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'SPRINTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    '312',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VIANO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'GL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'GLC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'GLS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'V-CLASS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'V-200',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'V-220',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VITO TOURER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VITO 116 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VITO TOURER 114 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VITO TOURER 116 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'V-220 CDI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MERCEDES BENZ'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'JCW',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MINI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'),
    TRUE
  ),
  (
    'L300',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'MONTERO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'OUTLANDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'MITSUBISHI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'C20',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'URVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VANETTE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'PATROL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'PATHFINDER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'NV350',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'X-TRAIL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'NISSAN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    '5008',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'TRAVELLER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'BOXER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'RIFTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PEUGEOT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'VOYAGER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PLYMOUTH'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'MINIVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'PONTIAC'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'TRAFIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'ESPACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'MASTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'RENAULT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'ALHAMBRA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SEAT'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'KAROQ',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SKODA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'STAVIC',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SSANGYONG'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'TRIBECA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUBARU'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'MASTERVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'ERTIGA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'SUZUKI'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'LAND CRUISER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'HIACE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'LITE',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'PREVIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'COMMUTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'SEQUOIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'HIACE COMMUTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'TOYOTA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'KLEINBUS',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    '211_KOMBI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'KOMBI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'KLEINBUS-KOMBI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'LT40',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'DANFO',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'CALIFORNIA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'FURGON_PANEL',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'CADDY',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'MULTIVAN',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'TRANSPORTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'CRAFTER',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'PANAMERICANA',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'T5',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLKSWAGEN'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'XC70',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'XC90',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'VOLVO'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  ),
  (
    'KOMBI',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'ZASTAVA'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Van'),
    TRUE
  )
ON CONFLICT (nombre, marca_id) DO NOTHING;

-- ============================================================================
-- FINALIZAR TRANSACCIÃ“N
-- ============================================================================

COMMIT;

-- ============================================================================
-- VERIFICACIÃ“N DE DATOS IMPORTADOS
-- ============================================================================

-- Contar marcas importadas
SELECT 'Marcas importadas' AS descripcion, COUNT(*) AS cantidad FROM marca_vehiculo;

-- Contar modelos importados
SELECT 'Modelos importados' AS descripcion, COUNT(*) AS cantidad FROM modelo_vehiculo;

-- Contar modelos por tipo de vehÃ­culo
SELECT 
    tv.nombre AS tipo_vehiculo,
    COUNT(mv.id) AS cantidad_modelos
FROM tipo_vehiculo tv
LEFT JOIN modelo_vehiculo mv ON mv.tipo_vehiculo_id = tv.id
WHERE tv.activo = TRUE
GROUP BY tv.nombre, tv.id
ORDER BY tv.nombre;

-- Contar modelos por marca (top 20)
SELECT 
    m.nombre AS marca,
    COUNT(mv.id) AS cantidad_modelos
FROM marca_vehiculo m
LEFT JOIN modelo_vehiculo mv ON mv.marca_id = m.id
GROUP BY m.nombre, m.id
ORDER BY cantidad_modelos DESC, m.nombre
LIMIT 20;
