-- Migration 017: Create Vehicle Maintainer Tables
-- Created: 2026-05-XX
-- Description: Implementa mantenedores para normalizar tipos, marcas y modelos de vehículos
--              Mejora la calidad de datos y previene errores de ortografía/normalización

-- 1. Crear tabla tipo_vehiculo (Type of Vehicle)
CREATE TABLE IF NOT EXISTS tipo_vehiculo (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    icono VARCHAR(50), -- Clase de icono (ej: fa-car, fa-motorcycle, fa-truck)
    orden INTEGER DEFAULT 0, -- Para ordenar en dropdowns
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Crear tabla marca_vehiculo (Vehicle Brand)
CREATE TABLE IF NOT EXISTS marca_vehiculo (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    pais_origen VARCHAR(50), -- País de origen de la marca
    logo_url VARCHAR(255), -- URL del logo (opcional)
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Crear tabla modelo_vehiculo (Vehicle Model)
CREATE TABLE IF NOT EXISTS modelo_vehiculo (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    marca_id INTEGER NOT NULL REFERENCES marca_vehiculo(id) ON DELETE RESTRICT,
    tipo_vehiculo_id INTEGER REFERENCES tipo_vehiculo(id) ON DELETE SET NULL,
    anio_inicio INTEGER, -- Año de inicio de producción
    anio_fin INTEGER, -- Año de fin de producción (NULL si aún se produce)
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(nombre, marca_id) -- Un modelo es único por marca
);

-- 4. Modificar tabla vehiculos: agregar FKs a mantenedores (nullable para compatibilidad retroactiva)
ALTER TABLE vehiculos 
ADD COLUMN IF NOT EXISTS tipo_vehiculo_id INTEGER REFERENCES tipo_vehiculo(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS marca_id INTEGER REFERENCES marca_vehiculo(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS modelo_id INTEGER REFERENCES modelo_vehiculo(id) ON DELETE SET NULL;

-- 5. Crear índices para mejorar performance
CREATE INDEX IF NOT EXISTS idx_tipo_vehiculo_activo ON tipo_vehiculo(activo);
CREATE INDEX IF NOT EXISTS idx_tipo_vehiculo_orden ON tipo_vehiculo(orden);

CREATE INDEX IF NOT EXISTS idx_marca_vehiculo_activo ON marca_vehiculo(activo);
CREATE INDEX IF NOT EXISTS idx_marca_vehiculo_nombre ON marca_vehiculo(nombre);

CREATE INDEX IF NOT EXISTS idx_modelo_vehiculo_marca ON modelo_vehiculo(marca_id);
CREATE INDEX IF NOT EXISTS idx_modelo_vehiculo_tipo ON modelo_vehiculo(tipo_vehiculo_id);
CREATE INDEX IF NOT EXISTS idx_modelo_vehiculo_activo ON modelo_vehiculo(activo);

CREATE INDEX IF NOT EXISTS idx_vehiculos_tipo ON vehiculos(tipo_vehiculo_id);
CREATE INDEX IF NOT EXISTS idx_vehiculos_marca ON vehiculos(marca_id);
CREATE INDEX IF NOT EXISTS idx_vehiculos_modelo ON vehiculos(modelo_id);

-- 6. Comentarios para documentación
COMMENT ON TABLE tipo_vehiculo IS 'Mantenedor de tipos de vehículos (Automóvil, Camioneta, SUV, Motocicleta, etc.)';
COMMENT ON TABLE marca_vehiculo IS 'Mantenedor de marcas de vehículos registradas en Chile';
COMMENT ON TABLE modelo_vehiculo IS 'Mantenedor de modelos de vehículos por marca';

COMMENT ON COLUMN vehiculos.tipo_vehiculo_id IS 'FK a tipo_vehiculo (nullable para compatibilidad con registros antiguos)';
COMMENT ON COLUMN vehiculos.marca_id IS 'FK a marca_vehiculo (nullable para compatibilidad con registros antiguos)';
COMMENT ON COLUMN vehiculos.modelo_id IS 'FK a modelo_vehiculo (nullable para compatibilidad con registros antiguos)';
