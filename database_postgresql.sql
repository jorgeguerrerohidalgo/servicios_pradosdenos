-- Script de inicialización para PostgreSQL (Supabase)
-- Configurar zona horaria para Santiago de Chile
SET timezone = 'America/Santiago';

-- Tabla de plazas (simplificada)
CREATE TABLE IF NOT EXISTS plazas (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de tokens QR únicos por plaza
CREATE TABLE IF NOT EXISTS plaza_tokens (
  id SERIAL PRIMARY KEY,
  plaza_id INTEGER NOT NULL,
  token VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (plaza_id) REFERENCES plazas(id) ON DELETE CASCADE
);

-- Tabla de guardias
CREATE TABLE IF NOT EXISTS guardias (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  rut VARCHAR(12) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  telefono VARCHAR(20),
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP NULL
);

-- Tabla de check-ins (fecha con zona horaria)
CREATE TABLE IF NOT EXISTS checkins (
  id SERIAL PRIMARY KEY,
  guardia_id INTEGER NOT NULL,
  plaza_id INTEGER NOT NULL,
  fecha TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'),
  ip_address VARCHAR(45),
  user_agent TEXT,
  FOREIGN KEY (guardia_id) REFERENCES guardias(id) ON DELETE CASCADE,
  FOREIGN KEY (plaza_id) REFERENCES plazas(id) ON DELETE CASCADE
);

-- Índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_plazas_nombre ON plazas(nombre);
CREATE INDEX IF NOT EXISTS idx_plaza_tokens_token ON plaza_tokens(token);
CREATE INDEX IF NOT EXISTS idx_guardias_email ON guardias(email);
CREATE INDEX IF NOT EXISTS idx_guardias_rut ON guardias(rut);
CREATE INDEX IF NOT EXISTS idx_checkins_guardia_id ON checkins(guardia_id);
CREATE INDEX IF NOT EXISTS idx_checkins_plaza_id ON checkins(plaza_id);
CREATE INDEX IF NOT EXISTS idx_checkins_fecha ON checkins(fecha);

-- Insertar datos de ejemplo
INSERT INTO plazas (nombre) VALUES
('Plaza Norte - Sector A'),
('Plaza Sur - Sector B'), 
('Plaza Central - Sector C'),
('Plaza Este - Sector D'),
('Plaza Oeste - Sector E'),
('Plaza Principal - Acceso')
ON CONFLICT DO NOTHING;

-- Insertar tokens QR para cada plaza
INSERT INTO plaza_tokens (plaza_id, token) VALUES
(1, 'qr-norte-a-2025'),
(2, 'qr-sur-b-2025'),
(3, 'qr-central-c-2025'),
(4, 'qr-este-d-2025'),
(5, 'qr-oeste-e-2025'),
(6, 'qr-principal-acceso-2025')
ON CONFLICT (token) DO NOTHING;

-- Insertar guardias con contraseñas hasheadas
INSERT INTO guardias (nombre, rut, email, password, telefono) VALUES
('Carlos Mendoza Torres', '18.543.210-9', 'carlos.mendoza@pradosdenos.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+56912345678'),
('María Elena Soto', '16.789.432-1', 'maria.soto@pradosdenos.com', '$2b$10$Hgw2GWfqF7dqLgGxw9v1b.qH7VkGZGK5kOOGK5kL5kOOGK5kL5k', '+56987654321'),
('Juan Carlos Ramirez', '19.234.567-8', 'juan.ramirez@pradosdenos.com', '$2b$10$XYZ123abc456def789ghi012jkl345mno678pqr901stu234vwx567yz', '+56976543210'),
('Patricia Morales Vega', '17.654.321-0', 'patricia.morales@pradosdenos.com', '$2b$10$ABC789def012ghi345jkl678mno901pqr234stu567vwx890yzA123Bc', '+56965432109')
ON CONFLICT (email) DO NOTHING;

-- Insertar check-ins de ejemplo con fechas realistas en zona horaria de Santiago
-- Rondas de los últimos 3 días con horarios típicos de seguridad
INSERT INTO checkins (guardia_id, plaza_id, fecha, ip_address) VALUES
-- Hoy - turnos matutino, vespertino y nocturno
(1, 1, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 hours', '192.168.1.100'),
(1, 2, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 hour 45 minutes', '192.168.1.100'),
(1, 3, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 hour 30 minutes', '192.168.1.100'),
(2, 4, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 hour', '192.168.1.101'),
(2, 5, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '45 minutes', '192.168.1.101'),
(2, 6, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '30 minutes', '192.168.1.101'),

-- Ayer
(3, 1, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 3 hours', '192.168.1.102'),
(3, 2, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 2 hours 45 minutes', '192.168.1.102'),
(3, 3, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 2 hours 30 minutes', '192.168.1.102'),
(4, 4, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 1 hour 30 minutes', '192.168.1.103'),
(4, 5, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 1 hour 15 minutes', '192.168.1.103'),
(4, 6, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 1 hour', '192.168.1.103'),

-- Anteayer
(1, 1, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 4 hours', '192.168.1.100'),
(1, 2, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 3 hours 45 minutes', '192.168.1.100'),
(2, 3, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 3 hours 30 minutes', '192.168.1.101'),
(2, 4, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 2 hours', '192.168.1.101'),
(3, 5, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 1 hour 45 minutes', '192.168.1.102'),
(3, 6, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 1 hour 30 minutes', '192.168.1.102')
ON CONFLICT DO NOTHING;
