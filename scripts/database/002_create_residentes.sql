-- ========================================
-- MIGRACIÓN 002: Módulo RESIDENTES
-- ========================================
-- Descripción: Tabla para gestionar los residentes de cada casa del condominio
-- Autor: Sistema
-- Fecha: 14/05/2026
-- Dependencias: Requiere tabla 'casas' (migración 001)
-- ========================================

-- Configurar zona horaria para Santiago de Chile
SET timezone = 'America/Santiago';

-- Tabla de residentes
CREATE TABLE IF NOT EXISTS residentes (
  id SERIAL PRIMARY KEY,
  casa_id INTEGER NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  apellido_paterno VARCHAR(100) NOT NULL,
  apellido_materno VARCHAR(100),
  run VARCHAR(12) NOT NULL UNIQUE,
  fecha_nacimiento DATE NOT NULL,
  email VARCHAR(150),
  telefono VARCHAR(20),
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (casa_id) REFERENCES casas(id) ON DELETE CASCADE,
  CONSTRAINT check_edad_valida CHECK (fecha_nacimiento <= CURRENT_DATE),
  CONSTRAINT check_email_formato CHECK (email IS NULL OR email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- Índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_residentes_casa_id ON residentes(casa_id);
CREATE INDEX IF NOT EXISTS idx_residentes_run ON residentes(run);
CREATE INDEX IF NOT EXISTS idx_residentes_email ON residentes(email);
CREATE INDEX IF NOT EXISTS idx_residentes_activo ON residentes(activo);
CREATE INDEX IF NOT EXISTS idx_residentes_casa_activo ON residentes(casa_id, activo);
CREATE INDEX IF NOT EXISTS idx_residentes_nombre_apellido ON residentes(nombre, apellido_paterno);

-- Trigger para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_residentes_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_residentes_updated_at
  BEFORE UPDATE ON residentes
  FOR EACH ROW
  EXECUTE FUNCTION update_residentes_updated_at();

-- Vista completa: residentes con información de casa y plaza
CREATE OR REPLACE VIEW v_residentes_completo AS
SELECT 
  r.id,
  r.casa_id,
  c.numero_casa,
  c.direccion as casa_direccion,
  c.plaza_id,
  p.nombre as plaza_nombre,
  r.nombre,
  r.apellido_paterno,
  r.apellido_materno,
  CONCAT(r.nombre, ' ', r.apellido_paterno, ' ', COALESCE(r.apellido_materno, '')) as nombre_completo,
  r.run,
  r.fecha_nacimiento,
  EXTRACT(YEAR FROM AGE(CURRENT_DATE, r.fecha_nacimiento))::INTEGER as edad,
  r.email,
  r.telefono,
  r.activo,
  r.created_at,
  r.updated_at
FROM residentes r
LEFT JOIN casas c ON r.casa_id = c.id
LEFT JOIN plazas p ON c.plaza_id = p.id;

-- Función helper: Validar RUT chileno (dígito verificador)
CREATE OR REPLACE FUNCTION validar_rut_chileno(rut_completo VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE
  rut_numeros INTEGER;
  digito_verificador CHAR(1);
  suma INTEGER := 0;
  multiplicador INTEGER := 2;
  resto INTEGER;
  dv_calculado CHAR(1);
BEGIN
  -- Limpiar el RUT (quitar puntos y guión)
  rut_completo := REPLACE(REPLACE(rut_completo, '.', ''), '-', '');
  
  -- Separar número y dígito verificador
  rut_numeros := SUBSTRING(rut_completo FROM 1 FOR LENGTH(rut_completo) - 1)::INTEGER;
  digito_verificador := UPPER(SUBSTRING(rut_completo FROM LENGTH(rut_completo)));
  
  -- Calcular dígito verificador
  WHILE rut_numeros > 0 LOOP
    suma := suma + (rut_numeros % 10) * multiplicador;
    rut_numeros := rut_numeros / 10;
    multiplicador := multiplicador + 1;
    IF multiplicador > 7 THEN
      multiplicador := 2;
    END IF;
  END LOOP;
  
  resto := 11 - (suma % 11);
  
  IF resto = 11 THEN
    dv_calculado := '0';
  ELSIF resto = 10 THEN
    dv_calculado := 'K';
  ELSE
    dv_calculado := resto::CHAR(1);
  END IF;
  
  RETURN dv_calculado = digito_verificador;
END;
$$ LANGUAGE plpgsql;

-- Función: Obtener estadísticas de residentes por casa
CREATE OR REPLACE FUNCTION get_estadisticas_residentes(p_casa_id INTEGER DEFAULT NULL)
RETURNS TABLE (
  casa_id INTEGER,
  numero_casa VARCHAR,
  total_residentes BIGINT,
  promedio_edad NUMERIC,
  residente_mayor_edad INTEGER,
  residente_menor_edad INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    c.id as casa_id,
    c.numero_casa,
    COUNT(r.id) as total_residentes,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, r.fecha_nacimiento))), 1) as promedio_edad,
    MAX(EXTRACT(YEAR FROM AGE(CURRENT_DATE, r.fecha_nacimiento)))::INTEGER as residente_mayor_edad,
    MIN(EXTRACT(YEAR FROM AGE(CURRENT_DATE, r.fecha_nacimiento)))::INTEGER as residente_menor_edad
  FROM casas c
  LEFT JOIN residentes r ON c.id = r.casa_id AND r.activo = true
  WHERE (p_casa_id IS NULL OR c.id = p_casa_id)
    AND c.activo = true
  GROUP BY c.id, c.numero_casa
  ORDER BY c.numero_casa;
END;
$$ LANGUAGE plpgsql;

-- Comentarios en tablas y columnas
COMMENT ON TABLE residentes IS 'Registro de residentes que habitan en las casas del condominio';
COMMENT ON COLUMN residentes.casa_id IS 'Referencia a la casa donde reside (ON DELETE CASCADE desactiva residentes si se elimina casa)';
COMMENT ON COLUMN residentes.run IS 'RUT chileno sin puntos con guión (ej: 12345678-9)';
COMMENT ON COLUMN residentes.fecha_nacimiento IS 'Fecha de nacimiento del residente';
COMMENT ON COLUMN residentes.email IS 'Email de contacto opcional';
COMMENT ON COLUMN residentes.telefono IS 'Teléfono de contacto opcional';
COMMENT ON COLUMN residentes.activo IS 'Indica si el residente está activo en el sistema (soft delete)';

COMMENT ON VIEW v_residentes_completo IS 'Vista completa de residentes con información de casa y plaza asociada';
COMMENT ON FUNCTION validar_rut_chileno IS 'Valida el dígito verificador de un RUT chileno';
COMMENT ON FUNCTION get_estadisticas_residentes IS 'Retorna estadísticas de residentes agrupadas por casa';

-- Datos de ejemplo (opcional - comentar si no se requiere)
-- INSERT INTO residentes (casa_id, nombre, apellido_paterno, apellido_materno, run, fecha_nacimiento, email, telefono)
-- VALUES 
--   (1, 'Juan', 'Pérez', 'González', '12345678-9', '1980-05-15', 'juan.perez@email.com', '+56912345678'),
--   (1, 'María', 'Pérez', 'Soto', '98765432-1', '1982-08-22', 'maria.perez@email.com', '+56987654321'),
--   (2, 'Carlos', 'Silva', 'Rojas', '11223344-5', '1975-03-10', 'carlos.silva@email.com', '+56911223344')
-- ON CONFLICT (run) DO NOTHING;

-- Verificación
SELECT 'Migración 002_create_residentes.sql ejecutada correctamente' AS resultado;
SELECT COUNT(*) || ' residentes registrados' AS estado FROM residentes;

-- Mostrar estadísticas generales
SELECT * FROM get_estadisticas_residentes();
