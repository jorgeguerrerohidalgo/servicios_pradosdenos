-- =============================================
-- ESQUEMA DE USUARIOS - MIGRACIÓN PREVIA
-- Los Prados de Nos - Tabla de Usuarios
-- =============================================

-- Crear la tabla usuarios que falta en el esquema
CREATE TABLE IF NOT EXISTS usuarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100),
    apellido_materno VARCHAR(100),
    run VARCHAR(12) UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    fecha_nacimiento DATE,
    password_hash VARCHAR(255) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    tipo_usuario VARCHAR(20) DEFAULT 'residente' CHECK (tipo_usuario IN ('admin', 'residente', 'guardia', 'comite')),
    plaza_id INTEGER,
    verificado BOOLEAN DEFAULT FALSE,
    fecha_verificacion TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login TIMESTAMP WITH TIME ZONE
);

-- Índices para la tabla usuarios
CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios(email);
CREATE INDEX IF NOT EXISTS idx_usuarios_run ON usuarios(run);
CREATE INDEX IF NOT EXISTS idx_usuarios_activo ON usuarios(activo);
CREATE INDEX IF NOT EXISTS idx_usuarios_tipo ON usuarios(tipo_usuario);
CREATE INDEX IF NOT EXISTS idx_usuarios_plaza ON usuarios(plaza_id);

-- Trigger para updated_at en usuarios
CREATE TRIGGER update_usuarios_updated_at 
BEFORE UPDATE ON usuarios 
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Migrar datos existentes de admin_users a usuarios (si existe)
INSERT INTO usuarios (
    nombre, 
    apellido_paterno, 
    apellido_materno, 
    run, 
    email, 
    direccion, 
    fecha_nacimiento, 
    password_hash, 
    tipo_usuario, 
    plaza_id, 
    activo, 
    verificado,
    created_at
)
SELECT 
    nombre,
    apellido_paterno,
    apellido_materno,
    run,
    email,
    direccion,
    fecha_nacimiento,
    password_hash,
    'admin' as tipo_usuario,
    plaza_id,
    TRUE as activo,
    TRUE as verificado,
    created_at
FROM admin_users
WHERE NOT EXISTS (SELECT 1 FROM usuarios WHERE usuarios.email = admin_users.email)
ON CONFLICT (email) DO NOTHING;

-- Migrar datos existentes de guardias a usuarios (si existe)
INSERT INTO usuarios (
    nombre, 
    run, 
    email, 
    telefono,
    password_hash, 
    tipo_usuario, 
    activo, 
    verificado,
    created_at,
    last_login
)
SELECT 
    nombre,
    rut as run,
    email,
    telefono,
    password as password_hash,
    'guardia' as tipo_usuario,
    activo,
    TRUE as verificado,
    created_at,
    last_login
FROM guardias
WHERE NOT EXISTS (SELECT 1 FROM usuarios WHERE usuarios.email = guardias.email)
ON CONFLICT (email) DO NOTHING;

-- Crear usuario administrador por defecto si no existe
INSERT INTO usuarios (
    nombre, 
    apellido_paterno, 
    apellido_materno, 
    email, 
    password_hash, 
    tipo_usuario, 
    activo, 
    verificado,
    run
) VALUES (
    'Administrador',
    'Sistema',
    'Prados',
    'admin@pradosdenos.cl',
    '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: admin123
    'admin',
    TRUE,
    TRUE,
    '11111111-1'
)
ON CONFLICT (email) DO NOTHING;

-- Comentarios de documentación
COMMENT ON TABLE usuarios IS 'Tabla principal de usuarios del sistema';
COMMENT ON COLUMN usuarios.tipo_usuario IS 'Tipo de usuario: admin, residente, guardia, comite';
COMMENT ON COLUMN usuarios.verificado IS 'Si el usuario ha sido verificado por un administrador';
COMMENT ON COLUMN usuarios.plaza_id IS 'ID de la plaza asociada (referencia a plazas.id)';
