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

-- Tabla de administradores del sistema
CREATE TABLE IF NOT EXISTS admin_users (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido_paterno VARCHAR(100) NOT NULL,
  apellido_materno VARCHAR(100) NOT NULL,
  run VARCHAR(12) NOT NULL UNIQUE,
  email VARCHAR(150) NOT NULL UNIQUE,
  fecha_nacimiento DATE NOT NULL,
  direccion VARCHAR(255) NOT NULL,
  plaza_id INTEGER NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (plaza_id) REFERENCES plazas(id) ON DELETE CASCADE
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
CREATE INDEX IF NOT EXISTS idx_admin_users_email ON admin_users(email);
CREATE INDEX IF NOT EXISTS idx_admin_users_run ON admin_users(run);
CREATE INDEX IF NOT EXISTS idx_checkins_guardia_id ON checkins(guardia_id);
CREATE INDEX IF NOT EXISTS idx_checkins_plaza_id ON checkins(plaza_id);
CREATE INDEX IF NOT EXISTS idx_checkins_fecha ON checkins(fecha);

-- Insertar datos de ejemplo
INSERT INTO plazas (nombre) VALUES
('Plaza La Coruña'),
('Plaza Valencia'), 
('Plaza Marbella'),
('Plaza Evaristo Herrera Molina'),
('Plaza Aaron Osorio Vidal'),
('Plaza Avellino'),
('Plaza Livorno'),
('Plaza Turin'),
('Plaza Castellon'),
('Plaza Perugia'),
('Plaza Ancona'),      
('Plaza Capri'),
('Plaza Napoles'),
('Plaza Reginado Henríquez Miranda'),
('Plaza Mario Arroyo Acuña'),
('Plaza Roberto Risopatron'),
('Plaza Barcelona'),
('Plaza Parque Union Norte'),
('Plaza Parque Union Sur')
ON CONFLICT DO NOTHING;

-- Insertar tokens QR para cada plaza
INSERT INTO plaza_tokens (plaza_id, token) VALUES
(1, 'qr-plaza-la-coruna-2025'),
(2, 'qr-plaza-valencia-2025'),
(3, 'qr-plaza-marbella-2025'),
(4, 'qr-plaza-evaristo-herrera-molina-2025'),
(5, 'qr-plaza-aaron-osorio-vidal-2025'),
(6, 'qr-plaza-avellino-2025'),
(7, 'qr-plaza-livorno-2025'),
(8, 'qr-plaza-turin-2025'),
(9, 'qr-plaza-castellon-2025'),
(10, 'qr-plaza-perugia-2025'),
(11, 'qr-plaza-ancona-2025'),
(12, 'qr-plaza-capri-2025'),
(13, 'qr-plaza-napoles-2025'),
(14, 'qr-plaza-reginado-henriquez-miranda-2025'),
(15, 'qr-plaza-mario-arroyo-acuna-2025'),
(16, 'qr-plaza-roberto-risopatron-2025'),
(17, 'qr-plaza-barcelona-2025'),
(18, 'qr-plaza-parque-union-norte-2025'),
(19, 'qr-plaza-parque-union-sur-2025')
ON CONFLICT (token) DO NOTHING;

-- Insertar guardias con contraseñas hasheadas
INSERT INTO guardias (nombre, rut, email, password, telefono) VALUES
('Carlos Mendoza Torres', '18.543.210-9', 'carlos.mendoza@pradosdenos.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+56912345678'),
('María Elena Soto', '16.789.432-1', 'maria.soto@pradosdenos.com', '$2b$10$Hgw2GWfqF7dqLgGxw9v1b.qH7VkGZGK5kOOGK5kL5kOOGK5kL5k', '+56987654321'),
('Juan Carlos Ramirez', '19.234.567-8', 'juan.ramirez@pradosdenos.com', '$2b$10$XYZ123abc456def789ghi012jkl345mno678pqr901stu234vwx567yz', '+56976543210'),
('Patricia Morales Vega', '17.654.321-0', 'patricia.morales@pradosdenos.com', '$2b$10$ABC789def012ghi345jkl678mno901pqr234stu567vwx890yzA123Bc', '+56965432109')
ON CONFLICT (email) DO NOTHING;

-- Insertar administradores del sistema
INSERT INTO admin_users (nombre, apellido_paterno, apellido_materno, run, email, fecha_nacimiento, direccion, plaza_id, password_hash) VALUES
('Jorge', 'Guerrero', 'Hidalgo', '15.468.127-2', 'jorgeguerrerohidalgo@gmail.com', '1982-04-24', 'Santiago de Compostela 4985', 1, '$2b$10$/MlZ4tqK6S5yts2wDR7dwu6JnMpXY3RrxH6ZxO23lp4YaeRAj2Ij.'),
('Supervisor', 'Seguridad', 'Nocturno', '11.111.222-3', 'supervisor@pradosdenos.com', '1982-05-20', 'Centro de Control Los Prados de Nos', 2, '$2b$10$ABC123def456ghi789jkl012mno345pqr678stu901vwx234yzA567Bc')
ON CONFLICT (email) DO NOTHING;

-- Insertar check-ins de ejemplo con fechas realistas en zona horaria de Santiago
-- Rondas de los últimos 3 días con horarios típicos de seguridad
INSERT INTO checkins (guardia_id, plaza_id, fecha, ip_address) VALUES
-- Hoy - rondas matutinas
(1, 1, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '3 hours', '192.168.1.100'),
(1, 2, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 hours 45 minutes', '192.168.1.100'),
(1, 3, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 hours 30 minutes', '192.168.1.100'),
(1, 7, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 hours 15 minutes', '192.168.1.100'),
(1, 8, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 hours', '192.168.1.100'),

-- Hoy - rondas vespertinas
(2, 4, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 hour 30 minutes', '192.168.1.101'),
(2, 5, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 hour 15 minutes', '192.168.1.101'),
(2, 6, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 hour', '192.168.1.101'),
(2, 9, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '45 minutes', '192.168.1.101'),
(2, 10, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '30 minutes', '192.168.1.101'),

-- Ayer - rondas completas
(3, 11, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 4 hours', '192.168.1.102'),
(3, 12, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 3 hours 45 minutes', '192.168.1.102'),
(3, 13, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 3 hours 30 minutes', '192.168.1.102'),
(3, 14, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 3 hours 15 minutes', '192.168.1.102'),
(4, 15, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 2 hours 30 minutes', '192.168.1.103'),
(4, 16, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 2 hours 15 minutes', '192.168.1.103'),
(4, 17, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 2 hours', '192.168.1.103'),
(4, 18, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 1 hour 45 minutes', '192.168.1.103'),
(4, 19, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '1 day 1 hour 30 minutes', '192.168.1.103'),

-- Anteayer - rondas nocturnas
(1, 1, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 5 hours', '192.168.1.100'),
(1, 5, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 4 hours 45 minutes', '192.168.1.100'),
(1, 10, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 4 hours 30 minutes', '192.168.1.100'),
(2, 2, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 3 hours 15 minutes', '192.168.1.101'),
(2, 7, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 3 hours', '192.168.1.101'),
(2, 12, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 2 hours 45 minutes', '192.168.1.101'),
(3, 3, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 2 hours 30 minutes', '192.168.1.102'),
(3, 8, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 2 hours 15 minutes', '192.168.1.102'),
(3, 15, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 2 hours', '192.168.1.102'),
(4, 6, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 1 hour 45 minutes', '192.168.1.103'),
(4, 11, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 1 hour 30 minutes', '192.168.1.103'),
(4, 16, (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago') - INTERVAL '2 days 1 hour 15 minutes', '192.168.1.103')
ON CONFLICT DO NOTHING;
