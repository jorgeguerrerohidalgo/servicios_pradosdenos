-- Script de inicialización para PostgreSQL (Supabase)

-- Tabla de plazas
CREATE TABLE IF NOT EXISTS plazas (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(255),
  comuna VARCHAR(100),
  region VARCHAR(100),
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

-- Tabla de check-ins
CREATE TABLE IF NOT EXISTS checkins (
  id SERIAL PRIMARY KEY,
  guardia_id INTEGER NOT NULL,
  plaza_id INTEGER NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ip_address VARCHAR(45),
  user_agent TEXT,
  FOREIGN KEY (guardia_id) REFERENCES guardias(id) ON DELETE CASCADE,
  FOREIGN KEY (plaza_id) REFERENCES plazas(id) ON DELETE CASCADE
);

-- Índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_plazas_nombre ON plazas(nombre);
CREATE INDEX IF NOT EXISTS idx_plazas_comuna ON plazas(comuna);
CREATE INDEX IF NOT EXISTS idx_plaza_tokens_token ON plaza_tokens(token);
CREATE INDEX IF NOT EXISTS idx_guardias_email ON guardias(email);
CREATE INDEX IF NOT EXISTS idx_guardias_rut ON guardias(rut);
CREATE INDEX IF NOT EXISTS idx_checkins_guardia_id ON checkins(guardia_id);
CREATE INDEX IF NOT EXISTS idx_checkins_plaza_id ON checkins(plaza_id);
CREATE INDEX IF NOT EXISTS idx_checkins_fecha ON checkins(fecha);

-- Insertar datos de ejemplo
INSERT INTO plazas (nombre, direccion, comuna, region) VALUES
('Plaza Norte', 'Av. Principal 123', 'Huechuraba', 'RM'),
('Plaza Sur', 'Calle Secundaria 456', 'Puente Alto', 'RM'),
('Plaza Central', 'Diagonal Norte 789', 'Santiago', 'RM')
ON CONFLICT DO NOTHING;

-- Insertar tokens QR
INSERT INTO plaza_tokens (plaza_id, token) VALUES
(1, 'qr-token-norte-123'),
(2, 'qr-token-sur-456'),
(3, 'qr-token-central-789')
ON CONFLICT (token) DO NOTHING;

-- Insertar guardias con contraseñas hasheadas
INSERT INTO guardias (nombre, rut, email, password, telefono) VALUES
('Carlos Torres', '12.345.678-9', 'carlos@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+56912345678'),
('María López', '98.765.432-1', 'maria@example.com', '$2b$10$Hgw2GWfqF7dqLgGxw9v1b.qH7VkGZGK5kOOGK5kL5kOOGK5kL5k', '+56987654321')
ON CONFLICT (email) DO NOTHING;
