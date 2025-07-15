-- Script completo para crear todas las tablas necesarias en Supabase
-- Ejecutar en la consola SQL de Supabase
-- Sistema de Check-in para Los Prados de Nos

-- ====================================
-- CONFIGURACIÓN INICIAL
-- ====================================

-- Configurar zona horaria para Santiago de Chile
SET timezone = 'America/Santiago';

-- Crear extensión para generar UUIDs si no existe
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ====================================
-- TABLAS PRINCIPALES DEL SISTEMA
-- ====================================

-- Tabla de plazas
CREATE TABLE IF NOT EXISTS plazas (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  direccion VARCHAR(255),
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago')
);

-- Tabla de tokens QR únicos por plaza
CREATE TABLE IF NOT EXISTS plaza_tokens (
  id SERIAL PRIMARY KEY,
  plaza_id INTEGER NOT NULL,
  token VARCHAR(255) NOT NULL UNIQUE,
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'),
  expires_at TIMESTAMP WITH TIME ZONE,
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
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'),
  last_login TIMESTAMP WITH TIME ZONE NULL
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
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'),
  last_login TIMESTAMP WITH TIME ZONE NULL,
  FOREIGN KEY (plaza_id) REFERENCES plazas(id) ON DELETE CASCADE
);

-- Tabla de check-ins con zona horaria
CREATE TABLE IF NOT EXISTS checkins (
  id SERIAL PRIMARY KEY,
  guardia_id INTEGER NOT NULL,
  plaza_id INTEGER NOT NULL,
  fecha TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'),
  ip_address VARCHAR(45),
  user_agent TEXT,
  coordenadas JSONB,
  notas TEXT,
  FOREIGN KEY (guardia_id) REFERENCES guardias(id) ON DELETE CASCADE,
  FOREIGN KEY (plaza_id) REFERENCES plazas(id) ON DELETE CASCADE
);

-- ====================================
-- TABLA DE LOGS DE SEGURIDAD
-- ====================================

-- Tabla para logs de seguridad (REQUERIDA POR EL SISTEMA)
CREATE TABLE IF NOT EXISTS security_logs (
  id SERIAL PRIMARY KEY,
  ip_address INET NOT NULL,
  event_type VARCHAR(50) NOT NULL,
  details JSONB,
  user_id INTEGER NULL,
  user_type VARCHAR(20) NULL,
  session_id VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago')
);

-- ====================================
-- TABLAS PARA MÓDULOS ADICIONALES
-- ====================================

-- Tabla de eventos
CREATE TABLE IF NOT EXISTS eventos (
  id SERIAL PRIMARY KEY,
  titulo VARCHAR(255) NOT NULL,
  descripcion TEXT,
  fecha_inicio TIMESTAMP WITH TIME ZONE NOT NULL,
  fecha_fin TIMESTAMP WITH TIME ZONE NOT NULL,
  ubicacion VARCHAR(255),
  precio DECIMAL(10,2) DEFAULT 0.00,
  moneda VARCHAR(3) DEFAULT 'CLP',
  organizador VARCHAR(255),
  contacto_email VARCHAR(255),
  contacto_telefono VARCHAR(20),
  imagen_url VARCHAR(500),
  estado VARCHAR(20) DEFAULT 'activo',
  plaza_id INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'),
  FOREIGN KEY (plaza_id) REFERENCES plazas(id) ON DELETE SET NULL
);

-- Tabla de documentos
CREATE TABLE IF NOT EXISTS documentos (
  id SERIAL PRIMARY KEY,
  titulo VARCHAR(255) NOT NULL,
  descripcion TEXT,
  tipo VARCHAR(50) NOT NULL,
  archivo_url VARCHAR(500) NOT NULL,
  archivo_nombre VARCHAR(255) NOT NULL,
  archivo_tamaño INTEGER,
  archivo_tipo VARCHAR(100),
  categoria VARCHAR(100),
  publico BOOLEAN DEFAULT TRUE,
  fecha_subida TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'),
  fecha_vigencia DATE,
  subido_por INTEGER,
  plaza_id INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago'),
  FOREIGN KEY (subido_por) REFERENCES admin_users(id) ON DELETE SET NULL,
  FOREIGN KEY (plaza_id) REFERENCES plazas(id) ON DELETE SET NULL
);

-- Tabla de categorías de documentos
CREATE TABLE IF NOT EXISTS categorias_documentos (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL UNIQUE,
  descripcion TEXT,
  color VARCHAR(7) DEFAULT '#007bff',
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago')
);

-- ====================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- ====================================

-- Índices para plazas
CREATE INDEX IF NOT EXISTS idx_plazas_nombre ON plazas(nombre);
CREATE INDEX IF NOT EXISTS idx_plazas_activo ON plazas(activo);

-- Índices para tokens
CREATE INDEX IF NOT EXISTS idx_plaza_tokens_token ON plaza_tokens(token);
CREATE INDEX IF NOT EXISTS idx_plaza_tokens_plaza_id ON plaza_tokens(plaza_id);
CREATE INDEX IF NOT EXISTS idx_plaza_tokens_activo ON plaza_tokens(activo);

-- Índices para guardias
CREATE INDEX IF NOT EXISTS idx_guardias_email ON guardias(email);
CREATE INDEX IF NOT EXISTS idx_guardias_rut ON guardias(rut);
CREATE INDEX IF NOT EXISTS idx_guardias_activo ON guardias(activo);

-- Índices para admin_users
CREATE INDEX IF NOT EXISTS idx_admin_users_email ON admin_users(email);
CREATE INDEX IF NOT EXISTS idx_admin_users_run ON admin_users(run);
CREATE INDEX IF NOT EXISTS idx_admin_users_activo ON admin_users(activo);

-- Índices para checkins
CREATE INDEX IF NOT EXISTS idx_checkins_guardia_id ON checkins(guardia_id);
CREATE INDEX IF NOT EXISTS idx_checkins_plaza_id ON checkins(plaza_id);
CREATE INDEX IF NOT EXISTS idx_checkins_fecha ON checkins(fecha);

-- Índices para security_logs
CREATE INDEX IF NOT EXISTS idx_security_logs_ip ON security_logs(ip_address);
CREATE INDEX IF NOT EXISTS idx_security_logs_event_type ON security_logs(event_type);
CREATE INDEX IF NOT EXISTS idx_security_logs_created_at ON security_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_security_logs_user_id ON security_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_security_logs_user_type ON security_logs(user_type);

-- Índices para eventos
CREATE INDEX IF NOT EXISTS idx_eventos_fecha_inicio ON eventos(fecha_inicio);
CREATE INDEX IF NOT EXISTS idx_eventos_fecha_fin ON eventos(fecha_fin);
CREATE INDEX IF NOT EXISTS idx_eventos_estado ON eventos(estado);
CREATE INDEX IF NOT EXISTS idx_eventos_plaza_id ON eventos(plaza_id);

-- Índices para documentos
CREATE INDEX IF NOT EXISTS idx_documentos_tipo ON documentos(tipo);
CREATE INDEX IF NOT EXISTS idx_documentos_categoria ON documentos(categoria);
CREATE INDEX IF NOT EXISTS idx_documentos_publico ON documentos(publico);
CREATE INDEX IF NOT EXISTS idx_documentos_plaza_id ON documentos(plaza_id);
CREATE INDEX IF NOT EXISTS idx_documentos_subido_por ON documentos(subido_por);

-- ====================================
-- COMENTARIOS PARA DOCUMENTACIÓN
-- ====================================

COMMENT ON TABLE plazas IS 'Plazas del complejo Los Prados de Nos';
COMMENT ON TABLE plaza_tokens IS 'Tokens QR únicos para cada plaza';
COMMENT ON TABLE guardias IS 'Guardias de seguridad del complejo';
COMMENT ON TABLE admin_users IS 'Usuarios administradores del sistema';
COMMENT ON TABLE checkins IS 'Registro de check-ins de guardias en plazas';
COMMENT ON TABLE security_logs IS 'Logs de eventos de seguridad del sistema';
COMMENT ON TABLE eventos IS 'Eventos del complejo';
COMMENT ON TABLE documentos IS 'Documentos del sistema';

COMMENT ON COLUMN security_logs.event_type IS 'Tipos: LOGIN_SUCCESS, LOGIN_FAILED, RATE_LIMIT_EXCEEDED, UNAUTHORIZED_ACCESS, PASSWORD_CHANGED, etc.';
COMMENT ON COLUMN security_logs.details IS 'Detalles adicionales del evento en formato JSON';
COMMENT ON COLUMN security_logs.user_type IS 'Tipo de usuario: admin, guardia';

-- ====================================
-- DATOS INICIALES
-- ====================================

-- Insertar plazas principales
INSERT INTO plazas (nombre, descripcion, direccion) VALUES
('Plaza La Coruña', 'Plaza principal del sector norte', 'Sector Norte - Los Prados de Nos'),
('Plaza Valencia', 'Plaza central del complejo', 'Sector Central - Los Prados de Nos'), 
('Plaza Marbella', 'Plaza del sector sur', 'Sector Sur - Los Prados de Nos'),
('Plaza Evaristo Herrera Molina', 'Plaza conmemorativa', 'Sector Este - Los Prados de Nos'),
('Plaza Aaron Osorio Vidal', 'Plaza del sector oeste', 'Sector Oeste - Los Prados de Nos'),
('Plaza Avellino', 'Plaza residencial', 'Sector Residencial - Los Prados de Nos'),
('Plaza Livorno', 'Plaza comercial', 'Sector Comercial - Los Prados de Nos'),
('Plaza Turin', 'Plaza deportiva', 'Sector Deportivo - Los Prados de Nos'),
('Plaza Castellon', 'Plaza cultural', 'Sector Cultural - Los Prados de Nos'),
('Plaza Perugia', 'Plaza educativa', 'Sector Educativo - Los Prados de Nos'),
('Plaza Ancona', 'Plaza de servicios', 'Sector Servicios - Los Prados de Nos'),      
('Plaza Capri', 'Plaza recreativa', 'Sector Recreativo - Los Prados de Nos'),
('Plaza Napoles', 'Plaza familiar', 'Sector Familiar - Los Prados de Nos'),
('Plaza Reginado Henríquez Miranda', 'Plaza histórica', 'Sector Histórico - Los Prados de Nos'),
('Plaza Mario Arroyo Acuña', 'Plaza memorial', 'Sector Memorial - Los Prados de Nos'),
('Plaza Roberto Risopatron', 'Plaza del agua', 'Sector Agua - Los Prados de Nos'),
('Plaza Barcelona', 'Plaza principal sur', 'Sector Sur Principal - Los Prados de Nos'),
('Plaza Parque Union Norte', 'Parque norte', 'Sector Norte Parque - Los Prados de Nos'),
('Plaza Parque Union Sur', 'Parque sur', 'Sector Sur Parque - Los Prados de Nos')
ON CONFLICT (nombre) DO NOTHING;

-- Insertar tokens QR para cada plaza
INSERT INTO plaza_tokens (plaza_id, token) VALUES
(1, 'qr-plaza-la-coruna-2025-seg'),
(2, 'qr-plaza-valencia-2025-seg'),
(3, 'qr-plaza-marbella-2025-seg'),
(4, 'qr-plaza-evaristo-herrera-molina-2025-seg'),
(5, 'qr-plaza-aaron-osorio-vidal-2025-seg'),
(6, 'qr-plaza-avellino-2025-seg'),
(7, 'qr-plaza-livorno-2025-seg'),
(8, 'qr-plaza-turin-2025-seg'),
(9, 'qr-plaza-castellon-2025-seg'),
(10, 'qr-plaza-perugia-2025-seg'),
(11, 'qr-plaza-ancona-2025-seg'),
(12, 'qr-plaza-capri-2025-seg'),
(13, 'qr-plaza-napoles-2025-seg'),
(14, 'qr-plaza-reginado-henriquez-miranda-2025-seg'),
(15, 'qr-plaza-mario-arroyo-acuna-2025-seg'),
(16, 'qr-plaza-roberto-risopatron-2025-seg'),
(17, 'qr-plaza-barcelona-2025-seg'),
(18, 'qr-plaza-parque-union-norte-2025-seg'),
(19, 'qr-plaza-parque-union-sur-2025-seg')
ON CONFLICT (token) DO NOTHING;

-- Insertar usuario administrador principal
INSERT INTO admin_users (nombre, apellido_paterno, apellido_materno, run, email, fecha_nacimiento, direccion, plaza_id, password_hash) VALUES
('Admin', 'Sistema', 'Principal', '11.111.111-1', 'admin@pradosdenos.cl', '1990-01-01', 'Centro de Control Los Prados de Nos', 1, '$2b$12$LQv3c1yqBwlVHpfqRQ0Q0.JHjmxrZJzNhPVqUgTfCOdXYRqvgG.Be'),
('Jorge', 'Guerrero', 'Hidalgo', '15.468.127-2', 'jorgeguerrerohidalgo@gmail.com', '1982-04-24', 'Santiago de Compostela 4985', 1, '$2b$12$LQv3c1yqBwlVHpfqRQ0Q0.JHjmxrZJzNhPVqUgTfCOdXYRqvgG.Be')
ON CONFLICT (email) DO NOTHING;

-- Insertar guardia de prueba
INSERT INTO guardias (nombre, rut, email, password, telefono) VALUES
('Guardia', '22.222.222-2', 'guardia@pradosdenos.cl', '$2b$12$LQv3c1yqBwlVHpfqRQ0Q0.JHjmxrZJzNhPVqUgTfCOdXYRqvgG.Be', '+56912345678'),
('Carlos', '18.543.210-9', 'carlos.torres@pradosdenos.cl', '$2b$12$LQv3c1yqBwlVHpfqRQ0Q0.JHjmxrZJzNhPVqUgTfCOdXYRqvgG.Be', '+56987654321')
ON CONFLICT (email) DO NOTHING;

-- Insertar categorías de documentos
INSERT INTO categorias_documentos (nombre, descripcion, color) VALUES
('Reglamentos', 'Reglamentos internos del complejo', '#dc3545'),
('Procedimientos', 'Procedimientos operativos', '#007bff'),
('Seguridad', 'Documentos de seguridad', '#ffc107'),
('Mantención', 'Manuales de mantención', '#28a745'),
('Eventos', 'Documentos relacionados con eventos', '#6f42c1'),
('Administración', 'Documentos administrativos', '#fd7e14')
ON CONFLICT (nombre) DO NOTHING;

-- ====================================
-- FUNCIONES AUXILIARES
-- ====================================

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = (CURRENT_TIMESTAMP AT TIME ZONE 'America/Santiago');
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para actualizar updated_at
CREATE TRIGGER update_plazas_updated_at BEFORE UPDATE ON plazas FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_guardias_updated_at BEFORE UPDATE ON guardias FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_admin_users_updated_at BEFORE UPDATE ON admin_users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_eventos_updated_at BEFORE UPDATE ON eventos FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_documentos_updated_at BEFORE UPDATE ON documentos FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Función para limpiar logs de seguridad antiguos
CREATE OR REPLACE FUNCTION clean_old_security_logs() RETURNS void AS $$
BEGIN
  DELETE FROM security_logs WHERE created_at < NOW() - INTERVAL '30 days';
END;
$$ LANGUAGE plpgsql;

-- ====================================
-- VISTA PARA REPORTES
-- ====================================

-- Vista para reporte de check-ins con información completa
CREATE OR REPLACE VIEW vista_checkins AS
SELECT 
  c.id,
  c.fecha,
  g.nombre as guardia_nombre,
  g.email as guardia_email,
  p.nombre as plaza_nombre,
  c.ip_address,
  c.notas,
  DATE(c.fecha AT TIME ZONE 'America/Santiago') as fecha_local,
  EXTRACT(HOUR FROM c.fecha AT TIME ZONE 'America/Santiago') as hora_local
FROM checkins c
JOIN guardias g ON c.guardia_id = g.id
JOIN plazas p ON c.plaza_id = p.id
ORDER BY c.fecha DESC;

-- Vista para estadísticas de seguridad
CREATE OR REPLACE VIEW vista_security_stats AS
SELECT 
  DATE(created_at AT TIME ZONE 'America/Santiago') as fecha,
  event_type,
  COUNT(*) as cantidad
FROM security_logs
GROUP BY DATE(created_at AT TIME ZONE 'America/Santiago'), event_type
ORDER BY fecha DESC, cantidad DESC;

-- ====================================
-- POLÍTICAS DE SEGURIDAD (RLS)
-- ====================================

-- Habilitar RLS en tablas sensibles
ALTER TABLE security_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

-- Política para admin_users: solo pueden ver sus propios datos
CREATE POLICY admin_users_policy ON admin_users
  FOR ALL USING (auth.email() = email);

-- Política para security_logs: solo admins pueden ver logs
CREATE POLICY security_logs_policy ON security_logs
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM admin_users 
      WHERE email = auth.email() AND activo = true
    )
  );

-- ====================================
-- VERIFICACIÓN FINAL
-- ====================================

-- Verificar que todas las tablas fueron creadas
SELECT 
  table_name,
  table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('plazas', 'plaza_tokens', 'guardias', 'admin_users', 'checkins', 'security_logs', 'eventos', 'documentos', 'categorias_documentos')
ORDER BY table_name;

-- Verificar que los índices fueron creados
SELECT 
  indexname,
  tablename
FROM pg_indexes 
WHERE tablename IN ('plazas', 'plaza_tokens', 'guardias', 'admin_users', 'checkins', 'security_logs', 'eventos', 'documentos')
ORDER BY tablename, indexname;

-- Mensaje de confirmación
SELECT 'Base de datos inicializada correctamente para Los Prados de Nos' as mensaje;
