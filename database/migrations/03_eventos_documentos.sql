-- =============================================
-- ESQUEMA DE BASE DE DATOS - EVENTOS Y DOCUMENTOS
-- Los Prados de Nos - Módulos Comunitarios
-- =============================================

-- Extensión para UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- TABLAS DE TIPOS/CATEGORÍAS
-- =============================================

-- Tabla de tipos de eventos
CREATE TABLE IF NOT EXISTS tipo_evento (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    icono VARCHAR(50) DEFAULT 'calendar',
    color VARCHAR(7) DEFAULT '#007bff',
    activo BOOLEAN DEFAULT TRUE,
    orden INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de tipos de documentos
CREATE TABLE IF NOT EXISTS tipo_documento (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    icono VARCHAR(50) DEFAULT 'file',
    color VARCHAR(7) DEFAULT '#28a745',
    activo BOOLEAN DEFAULT TRUE,
    orden INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- TABLAS PRINCIPALES
-- =============================================

-- Tabla de eventos vecinales
CREATE TABLE IF NOT EXISTS eventos_vecinales (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    ubicacion VARCHAR(200),
    fecha_inicio TIMESTAMP WITH TIME ZONE NOT NULL,
    fecha_fin TIMESTAMP WITH TIME ZONE NOT NULL,
    tipo_evento_id UUID NOT NULL REFERENCES tipo_evento(id) ON DELETE RESTRICT,
    link_google_cal TEXT,
    link_reunion TEXT, -- Para reuniones virtuales
    visible BOOLEAN DEFAULT TRUE,
    destacado BOOLEAN DEFAULT FALSE,
    max_participantes INTEGER,
    requiere_inscripcion BOOLEAN DEFAULT FALSE,
    creado_por INTEGER NOT NULL REFERENCES admin_users(id) ON DELETE RESTRICT,
    modificado_por INTEGER REFERENCES admin_users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT chk_fechas_eventos CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT chk_max_participantes CHECK (max_participantes > 0 OR max_participantes IS NULL)
);

-- Tabla de documentos comunitarios
CREATE TABLE IF NOT EXISTS documentos_comunitarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    tipo_documento_id UUID NOT NULL REFERENCES tipo_documento(id) ON DELETE RESTRICT,
    link_drive TEXT NOT NULL,
    nombre_archivo VARCHAR(255),
    tamaño_archivo BIGINT, -- En bytes
    fecha_publicacion TIMESTAMP WITH TIME ZONE NOT NULL,
    fecha_vencimiento TIMESTAMP WITH TIME ZONE, -- Para documentos temporales
    visible BOOLEAN DEFAULT TRUE,
    destacado BOOLEAN DEFAULT FALSE,
    requiere_autenticacion BOOLEAN DEFAULT FALSE,
    subido_por INTEGER NOT NULL REFERENCES admin_users(id) ON DELETE RESTRICT,
    modificado_por INTEGER REFERENCES admin_users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT chk_tamaño_archivo CHECK (tamaño_archivo > 0 OR tamaño_archivo IS NULL),
    CONSTRAINT chk_fecha_vencimiento CHECK (fecha_vencimiento IS NULL OR fecha_vencimiento > fecha_publicacion)
);

-- =============================================
-- TABLAS DE INTERACCIÓN
-- =============================================

-- Tabla de inscripciones a eventos
CREATE TABLE IF NOT EXISTS inscripciones_eventos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    evento_id UUID NOT NULL REFERENCES eventos_vecinales(id) ON DELETE CASCADE,
    admin_user_id INTEGER NOT NULL REFERENCES admin_users(id) ON DELETE CASCADE,
    estado VARCHAR(20) DEFAULT 'confirmado' CHECK (estado IN ('confirmado', 'cancelado', 'pendiente')),
    comentarios TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Unique constraint para evitar inscripciones duplicadas
    UNIQUE(evento_id, admin_user_id)
);

-- Tabla de descargas de documentos (para auditoría)
CREATE TABLE IF NOT EXISTS descargas_documentos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    documento_id UUID NOT NULL REFERENCES documentos_comunitarios(id) ON DELETE CASCADE,
    email_descarga VARCHAR(150), -- Email de la cuenta Google que descarga
    nombre_descarga VARCHAR(200), -- Nombre del usuario que descarga
    admin_user_id INTEGER REFERENCES admin_users(id) ON DELETE SET NULL, -- Si es un admin conocido
    ip_address INET,
    user_agent TEXT,
    metodo_descarga VARCHAR(20) DEFAULT 'google_drive' CHECK (metodo_descarga IN ('google_drive', 'directo')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =============================================

-- Índices para eventos
CREATE INDEX IF NOT EXISTS idx_eventos_fecha_inicio ON eventos_vecinales(fecha_inicio);
CREATE INDEX IF NOT EXISTS idx_eventos_visible ON eventos_vecinales(visible);
CREATE INDEX IF NOT EXISTS idx_eventos_destacado ON eventos_vecinales(destacado);
CREATE INDEX IF NOT EXISTS idx_eventos_tipo ON eventos_vecinales(tipo_evento_id);
CREATE INDEX IF NOT EXISTS idx_eventos_creado_por ON eventos_vecinales(creado_por);

-- Índices para documentos
CREATE INDEX IF NOT EXISTS idx_documentos_fecha_publicacion ON documentos_comunitarios(fecha_publicacion);
CREATE INDEX IF NOT EXISTS idx_documentos_visible ON documentos_comunitarios(visible);
CREATE INDEX IF NOT EXISTS idx_documentos_destacado ON documentos_comunitarios(destacado);
CREATE INDEX IF NOT EXISTS idx_documentos_tipo ON documentos_comunitarios(tipo_documento_id);
CREATE INDEX IF NOT EXISTS idx_documentos_subido_por ON documentos_comunitarios(subido_por);

-- Índices para inscripciones
CREATE INDEX IF NOT EXISTS idx_inscripciones_evento ON inscripciones_eventos(evento_id);
CREATE INDEX IF NOT EXISTS idx_inscripciones_admin_user ON inscripciones_eventos(admin_user_id);

-- Índices para descargas
CREATE INDEX IF NOT EXISTS idx_descargas_documento ON descargas_documentos(documento_id);
CREATE INDEX IF NOT EXISTS idx_descargas_email ON descargas_documentos(email_descarga);
CREATE INDEX IF NOT EXISTS idx_descargas_admin_user ON descargas_documentos(admin_user_id);
CREATE INDEX IF NOT EXISTS idx_descargas_fecha ON descargas_documentos(created_at);

-- =============================================
-- TRIGGERS PARA UPDATED_AT
-- =============================================

-- Función para actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para updated_at
CREATE TRIGGER update_tipo_evento_updated_at BEFORE UPDATE ON tipo_evento FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tipo_documento_updated_at BEFORE UPDATE ON tipo_documento FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_eventos_updated_at BEFORE UPDATE ON eventos_vecinales FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_documentos_updated_at BEFORE UPDATE ON documentos_comunitarios FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_inscripciones_updated_at BEFORE UPDATE ON inscripciones_eventos FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- DATOS INICIALES
-- =============================================

-- Insertar tipos de evento iniciales
INSERT INTO tipo_evento (nombre, descripcion, icono, color, orden) VALUES
('Reunión Ordinaria', 'Reunión programada de copropietarios', 'users', '#007bff', 1),
('Reunión Extraordinaria', 'Reunión urgente no programada', 'alert-triangle', '#dc3545', 2),
('Actividad Recreativa', 'Eventos sociales y comunitarios', 'calendar-heart', '#28a745', 3),
('Mantenimiento', 'Trabajos de mantenimiento programados', 'wrench', '#ffc107', 4),
('Emergencia', 'Situaciones de emergencia o urgencia', 'alert-octagon', '#dc3545', 5),
('Elecciones', 'Elecciones de la JJVV o Comité de Seguridad', 'users', '#6c757d', 6)
ON CONFLICT (nombre) DO NOTHING;

-- Insertar tipos de documento iniciales
INSERT INTO tipo_documento (nombre, descripcion, icono, color, orden) VALUES
('Acta', 'Registro oficial de reuniones', 'file-text', '#007bff', 1),
('Reglamento', 'Normas internas del conjunto', 'book', '#6f42c1', 2),
('Circular', 'Comunicados generales', 'mail', '#17a2b8', 3),
('Presupuesto', 'Documentos financieros', 'dollar-sign', '#28a745', 4),
('Contrato', 'Contratos y convenios', 'file-plus', '#fd7e14', 5),
('Manual', 'Manuales y procedimientos', 'help-circle', '#6c757d', 6)
ON CONFLICT (nombre) DO NOTHING;

-- =============================================
-- PERMISOS Y SEGURIDAD
-- =============================================

-- Crear roles específicos si no existen
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'eventos_manager') THEN
        CREATE ROLE eventos_manager;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'documentos_manager') THEN
        CREATE ROLE documentos_manager;
    END IF;
END
$$;

-- Conceder permisos específicos
GRANT SELECT, INSERT, UPDATE, DELETE ON eventos_vecinales TO eventos_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON tipo_evento TO eventos_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON inscripciones_eventos TO eventos_manager;

GRANT SELECT, INSERT, UPDATE, DELETE ON documentos_comunitarios TO documentos_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON tipo_documento TO documentos_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON descargas_documentos TO documentos_manager;

-- =============================================
-- FUNCIONES ÚTILES
-- =============================================

-- Función para limpiar eventos antiguos
CREATE OR REPLACE FUNCTION limpiar_eventos_antiguos(dias_antiguedad INTEGER DEFAULT 365)
RETURNS INTEGER AS $$
DECLARE
    eventos_eliminados INTEGER;
BEGIN
    DELETE FROM eventos_vecinales 
    WHERE fecha_fin < NOW() - INTERVAL '1 day' * dias_antiguedad
    AND visible = FALSE;
    
    GET DIAGNOSTICS eventos_eliminados = ROW_COUNT;
    RETURN eventos_eliminados;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener estadísticas de eventos
CREATE OR REPLACE FUNCTION estadisticas_eventos()
RETURNS TABLE(
    total_eventos BIGINT,
    eventos_activos BIGINT,
    eventos_pasados BIGINT,
    eventos_futuros BIGINT,
    total_inscripciones BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) AS total_eventos,
        COUNT(*) FILTER (WHERE visible = TRUE) AS eventos_activos,
        COUNT(*) FILTER (WHERE fecha_fin < NOW()) AS eventos_pasados,
        COUNT(*) FILTER (WHERE fecha_inicio > NOW()) AS eventos_futuros,
        (SELECT COUNT(*) FROM inscripciones_eventos WHERE estado = 'confirmado') AS total_inscripciones
    FROM eventos_vecinales;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener estadísticas de documentos
CREATE OR REPLACE FUNCTION estadisticas_documentos()
RETURNS TABLE(
    total_documentos BIGINT,
    documentos_activos BIGINT,
    documentos_destacados BIGINT,
    total_descargas BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) AS total_documentos,
        COUNT(*) FILTER (WHERE visible = TRUE) AS documentos_activos,
        COUNT(*) FILTER (WHERE destacado = TRUE) AS documentos_destacados,
        (SELECT COUNT(*) FROM descargas_documentos) AS total_descargas
    FROM documentos_comunitarios;
END;
$$ LANGUAGE plpgsql;

-- Función para registrar descarga desde Google Drive
CREATE OR REPLACE FUNCTION registrar_descarga_google_drive(
    p_documento_id UUID,
    p_email_descarga VARCHAR(150),
    p_nombre_descarga VARCHAR(200) DEFAULT NULL,
    p_ip_address INET DEFAULT NULL,
    p_user_agent TEXT DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    descarga_id UUID;
    admin_id INTEGER;
BEGIN
    -- Buscar si el email corresponde a un admin conocido
    SELECT id INTO admin_id FROM admin_users WHERE email = p_email_descarga;
    
    -- Insertar registro de descarga
    INSERT INTO descargas_documentos (
        documento_id, 
        email_descarga, 
        nombre_descarga, 
        admin_user_id, 
        ip_address, 
        user_agent, 
        metodo_descarga
    ) VALUES (
        p_documento_id,
        p_email_descarga,
        p_nombre_descarga,
        admin_id,
        p_ip_address,
        p_user_agent,
        'google_drive'
    ) RETURNING id INTO descarga_id;
    
    RETURN descarga_id;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- COMENTARIOS DE DOCUMENTACIÓN
-- =============================================

COMMENT ON TABLE inscripciones_eventos IS 'Inscripciones de administradores a eventos';
COMMENT ON TABLE descargas_documentos IS 'Auditoría de descargas de documentos con info de Google Drive';

COMMENT ON COLUMN eventos_vecinales.link_google_cal IS 'Enlace para agregar a Google Calendar';
COMMENT ON COLUMN eventos_vecinales.link_reunion IS 'Enlace para reuniones virtuales (Zoom, Meet, etc.)';
COMMENT ON COLUMN eventos_vecinales.requiere_inscripcion IS 'Si el evento requiere inscripción previa';
COMMENT ON COLUMN documentos_comunitarios.requiere_autenticacion IS 'Si requiere login para acceder';
COMMENT ON COLUMN documentos_comunitarios.fecha_vencimiento IS 'Fecha límite de validez del documento';
COMMENT ON COLUMN descargas_documentos.email_descarga IS 'Email de la cuenta Google que realizó la descarga';
COMMENT ON COLUMN descargas_documentos.nombre_descarga IS 'Nombre del usuario que descargó desde Google Drive';
COMMENT ON COLUMN descargas_documentos.metodo_descarga IS 'Método de descarga: google_drive o directo';
