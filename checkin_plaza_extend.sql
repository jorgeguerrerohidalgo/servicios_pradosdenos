
-- Crear base de datos
CREATE DATABASE IF NOT EXISTS checkin_plaza;
USE checkin_plaza;

-- Tabla de plazas
CREATE TABLE IF NOT EXISTS plazas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(255),
  comuna VARCHAR(100),
  region VARCHAR(100)
);

-- Tabla de tokens QR únicos por plaza
CREATE TABLE IF NOT EXISTS plaza_tokens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  plaza_id INT NOT NULL,
  token VARCHAR(255) NOT NULL UNIQUE,
  FOREIGN KEY (plaza_id) REFERENCES plazas(id)
);

-- Tabla de guardias
CREATE TABLE IF NOT EXISTS guardias (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  rut VARCHAR(12) NOT NULL,
  email VARCHAR(100) NOT NULL,
  password VARCHAR(100) NOT NULL,
  telefono VARCHAR(20)
);

-- Tabla de check-ins
CREATE TABLE IF NOT EXISTS checkins (
  id INT AUTO_INCREMENT PRIMARY KEY,
  guardia_id INT NOT NULL,
  plaza_id INT NOT NULL,
  fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (guardia_id) REFERENCES guardias(id),
  FOREIGN KEY (plaza_id) REFERENCES plazas(id)
);

-- Insertar plazas
INSERT INTO plazas (nombre, direccion, comuna, region) VALUES
('Plaza Norte', 'Av. Principal 123', 'Huechuraba', 'RM'),
('Plaza Sur', 'Calle Secundaria 456', 'Puente Alto', 'RM'),
('Plaza Central', 'Diagonal Norte 789', 'Santiago', 'RM');

-- Insertar tokens QR asociados a las plazas
INSERT INTO plaza_tokens (plaza_id, token) VALUES
(1, 'qr-token-norte-123'),
(2, 'qr-token-sur-456'),
(3, 'qr-token-central-789');

-- Insertar guardias
INSERT INTO guardias (nombre, rut, email, password, telefono) VALUES
('Carlos Torres', '12.345.678-9', 'carlos@example.com', '1234', '+56912345678'),
('María López', '98.765.432-1', 'maria@example.com', '5678', '+56987654321');
