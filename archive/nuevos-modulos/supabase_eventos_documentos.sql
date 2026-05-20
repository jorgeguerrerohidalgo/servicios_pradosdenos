
-- Tabla de tipos de eventos
CREATE TABLE IF NOT EXISTS tipo_evento (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT
);

-- Tabla de tipos de documentos
CREATE TABLE IF NOT EXISTS tipo_documento (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL UNIQUE,
    descripcion TEXT
);

-- Tabla de administradores (referencial)
CREATE TABLE IF NOT EXISTS usuarios_admin (
    id UUID PRIMARY KEY,
    nombre TEXT,
    email TEXT
);

-- Tabla de eventos vecinales
CREATE TABLE IF NOT EXISTS eventos_vecinales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    titulo TEXT NOT NULL,
    descripcion TEXT,
    ubicacion TEXT,
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP NOT NULL,
    tipo_evento_id UUID REFERENCES tipo_evento(id),
    link_google_cal TEXT,
    visible BOOLEAN DEFAULT TRUE,
    creado_por UUID REFERENCES usuarios_admin(id),
    fecha_creacion TIMESTAMP DEFAULT NOW()
);

-- Tabla de documentos comunitarios
CREATE TABLE IF NOT EXISTS documentos_comunitarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL,
    descripcion TEXT,
    tipo_documento_id UUID REFERENCES tipo_documento(id),
    link_drive TEXT NOT NULL,
    fecha_publicacion TIMESTAMP NOT NULL,
    visible BOOLEAN DEFAULT TRUE,
    subido_por UUID REFERENCES usuarios_admin(id),
    fecha_creacion TIMESTAMP DEFAULT NOW()
);

-- Insertar tipos de evento iniciales
INSERT INTO tipo_evento (nombre, descripcion) VALUES
('Reunión', 'Citación formal de copropietarios'),
('Emergencia', 'Evento urgente o no programado'),
('Actividad recreativa', 'Eventos sociales o comunitarios')
ON CONFLICT (nombre) DO NOTHING;

-- Insertar tipos de documento iniciales
INSERT INTO tipo_documento (nombre, descripcion) VALUES
('Acta', 'Registro oficial de una reunión'),
('Reglamento', 'Normas internas del conjunto habitacional'),
('Circular', 'Comunicado general a los vecinos')
ON CONFLICT (nombre) DO NOTHING;
