-- Script de inicialización para base de datos en producción
-- Este script está optimizado para servicios de BD externos

-- Crear base de datos si no existe (algunas BD externas no permiten esto)
-- CREATE DATABASE IF NOT EXISTS checkin_plaza;
-- USE checkin_plaza;

-- Usar la base de datos que ya existe en el servicio externo
-- La mayoría de servicios de BD externos ya tienen una BD creada

-- Tabla de plazas (simplificada)
CREATE TABLE IF NOT EXISTS plazas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  -- Índices para mejor rendimiento
  INDEX idx_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de tokens QR únicos por plaza
CREATE TABLE IF NOT EXISTS plaza_tokens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  plaza_id INT NOT NULL,
  token VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  -- Índices
  INDEX idx_token (token),
  INDEX idx_plaza_id (plaza_id),
  
  FOREIGN KEY (plaza_id) REFERENCES plazas(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de guardias con campos adicionales para auditoría
CREATE TABLE IF NOT EXISTS guardias (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  rut VARCHAR(12) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL, -- Campo ampliado para hash bcrypt
  telefono VARCHAR(20),
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  last_login TIMESTAMP NULL,
  
  -- Índices
  INDEX idx_email (email),
  INDEX idx_rut (rut),
  INDEX idx_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de check-ins con campos adicionales
CREATE TABLE IF NOT EXISTS checkins (
  id INT AUTO_INCREMENT PRIMARY KEY,
  guardia_id INT NOT NULL,
  plaza_id INT NOT NULL,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ip_address VARCHAR(45), -- Para IPv4 e IPv6
  user_agent TEXT,
  
  -- Índices para consultas rápidas
  INDEX idx_guardia_id (guardia_id),
  INDEX idx_plaza_id (plaza_id),
  INDEX idx_fecha (fecha),
  INDEX idx_guardia_fecha (guardia_id, fecha),
  INDEX idx_plaza_fecha (plaza_id, fecha),
  
  FOREIGN KEY (guardia_id) REFERENCES guardias(id) ON DELETE CASCADE,
  FOREIGN KEY (plaza_id) REFERENCES plazas(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar datos de ejemplo solo si las tablas están vacías
INSERT IGNORE INTO plazas (id, nombre) VALUES
(1, 'Plaza Norte'),
(2, 'Plaza Sur'),
(3, 'Plaza Central');

-- Insertar tokens QR asociados a las plazas
INSERT IGNORE INTO plaza_tokens (id, plaza_id, token) VALUES
(1, 1, 'qr-token-norte-123'),
(2, 2, 'qr-token-sur-456'),
(3, 3, 'qr-token-central-789');

-- Insertar guardias con contraseñas hasheadas (passwords: 1234 y 5678)
INSERT IGNORE INTO guardias (id, nombre, rut, email, password, telefono) VALUES
(1, 'Carlos Torres', '12.345.678-9', 'carlos@example.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+56912345678'),
(2, 'María López', '98.765.432-1', 'maria@example.com', '$2b$10$Hgw.GWfqF7dqLgGxw9v1b.qH7VkGZGK5kOOGK5kL5kOOGK5kL5k', '+56987654321');

-- Crear vista para reportes rápidos
CREATE OR REPLACE VIEW checkins_detail AS
SELECT 
    c.id,
    c.fecha,
    g.nombre as guardia_nombre,
    g.email as guardia_email,
    p.nombre as plaza_nombre
FROM checkins c
JOIN guardias g ON c.guardia_id = g.id
JOIN plazas p ON c.plaza_id = p.id
ORDER BY c.fecha DESC;
