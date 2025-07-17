-- Script para crear/actualizar tabla plaza_tokens
-- Compatible con PostgreSQL

-- Crear tabla plaza_tokens si no existe
CREATE TABLE IF NOT EXISTS plaza_tokens (
  id SERIAL PRIMARY KEY,
  plaza_id INTEGER NOT NULL,
  token VARCHAR(255) NOT NULL UNIQUE,
  fecha_generacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  activo BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (plaza_id) REFERENCES plazas(id)
);

-- Crear índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_plaza_tokens_plaza_id ON plaza_tokens(plaza_id);
CREATE INDEX IF NOT EXISTS idx_plaza_tokens_token ON plaza_tokens(token);
CREATE INDEX IF NOT EXISTS idx_plaza_tokens_activo ON plaza_tokens(activo);

-- Agregar columnas faltantes si la tabla ya existe
DO $$ 
BEGIN 
  BEGIN
    ALTER TABLE plaza_tokens ADD COLUMN fecha_generacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP;
  EXCEPTION
    WHEN duplicate_column THEN 
      NULL;
  END;
  
  BEGIN
    ALTER TABLE plaza_tokens ADD COLUMN activo BOOLEAN DEFAULT TRUE;
  EXCEPTION
    WHEN duplicate_column THEN 
      NULL;
  END;
END $$;

-- Agregar columnas faltantes a tabla plazas si no existen
DO $$ 
BEGIN 
  BEGIN
    ALTER TABLE plazas ADD COLUMN direccion VARCHAR(255);
  EXCEPTION
    WHEN duplicate_column THEN 
      NULL;
  END;
  
  BEGIN
    ALTER TABLE plazas ADD COLUMN descripcion TEXT;
  EXCEPTION
    WHEN duplicate_column THEN 
      NULL;
  END;
  
  BEGIN
    ALTER TABLE plazas ADD COLUMN activo BOOLEAN DEFAULT TRUE;
  EXCEPTION
    WHEN duplicate_column THEN 
      NULL;
  END;
END $$;

-- Actualizar plazas existentes para que estén activas
UPDATE plazas SET activo = TRUE WHERE activo IS NULL;

-- Insertar plazas de ejemplo si no existen
INSERT INTO plazas (nombre, direccion, descripcion, activo) 
SELECT 'Plaza A1', 'Calle Principal 123', 'Plaza de estacionamiento A1', TRUE
WHERE NOT EXISTS (SELECT 1 FROM plazas WHERE nombre = 'Plaza A1');

INSERT INTO plazas (nombre, direccion, descripcion, activo) 
SELECT 'Plaza A2', 'Calle Principal 124', 'Plaza de estacionamiento A2', TRUE
WHERE NOT EXISTS (SELECT 1 FROM plazas WHERE nombre = 'Plaza A2');

INSERT INTO plazas (nombre, direccion, descripcion, activo) 
SELECT 'Plaza B1', 'Calle Secundaria 125', 'Plaza de estacionamiento B1', TRUE
WHERE NOT EXISTS (SELECT 1 FROM plazas WHERE nombre = 'Plaza B1');

INSERT INTO plazas (nombre, direccion, descripcion, activo) 
SELECT 'Plaza B2', 'Calle Secundaria 126', 'Plaza de estacionamiento B2', TRUE
WHERE NOT EXISTS (SELECT 1 FROM plazas WHERE nombre = 'Plaza B2');

INSERT INTO plazas (nombre, direccion, descripcion, activo) 
SELECT 'Plaza C1', 'Avenida Central 127', 'Plaza de estacionamiento C1', TRUE
WHERE NOT EXISTS (SELECT 1 FROM plazas WHERE nombre = 'Plaza C1');

-- Crear vista para obtener plazas con tokens
CREATE OR REPLACE VIEW plazas_con_tokens AS
SELECT 
  p.id,
  p.nombre,
  p.direccion,
  p.descripcion,
  p.activo,
  pt.token,
  pt.fecha_generacion
FROM plazas p
LEFT JOIN plaza_tokens pt ON p.id = pt.plaza_id AND pt.activo = TRUE
WHERE p.activo = TRUE
ORDER BY p.nombre;

-- Comentarios para documentación
COMMENT ON TABLE plaza_tokens IS 'Tabla que almacena tokens únicos para cada plaza';
COMMENT ON COLUMN plaza_tokens.token IS 'Token único generado para identificar la plaza en QR codes';
COMMENT ON COLUMN plaza_tokens.fecha_generacion IS 'Fecha y hora cuando fue generado el token';
COMMENT ON COLUMN plaza_tokens.activo IS 'Indica si el token está activo y puede ser usado';

COMMENT ON VIEW plazas_con_tokens IS 'Vista que combina plazas con sus tokens activos';
