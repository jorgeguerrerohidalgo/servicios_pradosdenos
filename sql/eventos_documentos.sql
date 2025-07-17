-- Script para crear las tablas de eventos y documentos si no existen
-- Ejecutar este script en la base de datos de PostgreSQL

-- Crear tabla tipo_evento si no existe
CREATE TABLE IF NOT EXISTS tipo_evento (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    color VARCHAR(7) DEFAULT '#007bff',
    icono VARCHAR(50) DEFAULT 'fas fa-calendar',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla eventos_vecinales si no existe
CREATE TABLE IF NOT EXISTS eventos_vecinales (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP,
    tipo_evento_id INTEGER REFERENCES tipo_evento(id),
    ubicacion VARCHAR(200),
    visible BOOLEAN DEFAULT true,
    creado_por INTEGER,
    link_google_cal TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla tipo_documento si no existe
CREATE TABLE IF NOT EXISTS tipo_documento (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    color VARCHAR(7) DEFAULT '#28a745',
    icono VARCHAR(50) DEFAULT 'fas fa-file-alt',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla documentos_comunitarios si no existe
CREATE TABLE IF NOT EXISTS documentos_comunitarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    tipo_documento_id INTEGER REFERENCES tipo_documento(id),
    link_drive TEXT NOT NULL,
    fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    evento_id INTEGER REFERENCES eventos_vecinales(id),
    visible BOOLEAN DEFAULT true,
    subido_por INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar tipos de evento por defecto
INSERT INTO tipo_evento (nombre, descripcion, color, icono) VALUES
('Reunión de Directorio', 'Reuniones oficiales del directorio', '#007bff', 'fas fa-users'),
('Asamblea General', 'Asambleas generales de propietarios', '#28a745', 'fas fa-bullhorn'),
('Actividad Social', 'Eventos sociales y recreativos', '#ffc107', 'fas fa-glass-cheers'),
('Mantenimiento', 'Trabajos de mantenimiento programados', '#dc3545', 'fas fa-tools'),
('Capacitación', 'Charlas y capacitaciones', '#6f42c1', 'fas fa-chalkboard-teacher')
ON CONFLICT (nombre) DO NOTHING;

-- Insertar tipos de documento por defecto
INSERT INTO tipo_documento (nombre, descripcion, color, icono) VALUES
('Acta de Reunión', 'Actas oficiales de reuniones', '#007bff', 'fas fa-file-alt'),
('Reglamento', 'Reglamentos y normativas', '#28a745', 'fas fa-file-contract'),
('Comunicado', 'Comunicados oficiales', '#ffc107', 'fas fa-bullhorn'),
('Informe Financiero', 'Estados financieros y reportes', '#17a2b8', 'fas fa-chart-line'),
('Documento Legal', 'Documentos legales y contratos', '#6f42c1', 'fas fa-balance-scale'),
('Manual', 'Manuales y guías', '#fd7e14', 'fas fa-book')
ON CONFLICT (nombre) DO NOTHING;

-- Crear índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_eventos_fecha_inicio ON eventos_vecinales(fecha_inicio);
CREATE INDEX IF NOT EXISTS idx_eventos_visible ON eventos_vecinales(visible);
CREATE INDEX IF NOT EXISTS idx_documentos_fecha_publicacion ON documentos_comunitarios(fecha_publicacion);
CREATE INDEX IF NOT EXISTS idx_documentos_visible ON documentos_comunitarios(visible);
CREATE INDEX IF NOT EXISTS idx_documentos_evento_id ON documentos_comunitarios(evento_id);

-- Comentarios para documentación
COMMENT ON TABLE eventos_vecinales IS 'Tabla para almacenar eventos de la comunidad';
COMMENT ON TABLE documentos_comunitarios IS 'Tabla para almacenar documentos comunitarios';
COMMENT ON TABLE tipo_evento IS 'Catálogo de tipos de eventos disponibles';
COMMENT ON TABLE tipo_documento IS 'Catálogo de tipos de documentos disponibles';
