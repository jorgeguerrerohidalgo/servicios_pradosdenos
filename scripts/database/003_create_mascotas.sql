-- ========================================
-- MIGRACIÓN 003: Módulo MASCOTAS
-- ========================================
-- Descripción: Tabla para gestionar mascotas particulares y comunitarias del condominio
-- Autor: Sistema
-- Fecha: 14/05/2026
-- Dependencias: Requiere tablas 'casas' (001) y 'residentes' (002)
-- ========================================

-- Configurar zona horaria para Santiago de Chile
SET timezone = 'America/Santiago';

-- Tabla de mascotas
CREATE TABLE IF NOT EXISTS mascotas (
  id SERIAL PRIMARY KEY,
  casa_id INTEGER NOT NULL,
  residente_id INTEGER,  -- NULL para mascotas comunitarias
  nombre VARCHAR(100) NOT NULL,
  tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('perro', 'gato', 'otro')),
  raza VARCHAR(100),
  fecha_nacimiento DATE,
  genero VARCHAR(10) CHECK (genero IN ('macho', 'hembra', 'desconocido')),
  color VARCHAR(50),
  certificado_vacunas BOOLEAN DEFAULT FALSE,
  fecha_ultima_vacuna DATE,
  observaciones TEXT,
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (casa_id) REFERENCES casas(id) ON DELETE CASCADE,
  FOREIGN KEY (residente_id) REFERENCES residentes(id) ON DELETE SET NULL,
  CONSTRAINT check_fecha_nacimiento_valida CHECK (fecha_nacimiento IS NULL OR fecha_nacimiento <= CURRENT_DATE),
  CONSTRAINT check_fecha_vacuna_valida CHECK (fecha_ultima_vacuna IS NULL OR fecha_ultima_vacuna <= CURRENT_DATE)
);

-- Índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_mascotas_casa_id ON mascotas(casa_id);
CREATE INDEX IF NOT EXISTS idx_mascotas_residente_id ON mascotas(residente_id);
CREATE INDEX IF NOT EXISTS idx_mascotas_tipo ON mascotas(tipo);
CREATE INDEX IF NOT EXISTS idx_mascotas_activo ON mascotas(activo);
CREATE INDEX IF NOT EXISTS idx_mascotas_casa_activo ON mascotas(casa_id, activo);
CREATE INDEX IF NOT EXISTS idx_mascotas_certificado ON mascotas(certificado_vacunas);

-- Trigger para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_mascotas_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_mascotas_updated_at
  BEFORE UPDATE ON mascotas
  FOR EACH ROW
  EXECUTE FUNCTION update_mascotas_updated_at();

-- Vista completa: mascotas con información de casa, plaza y residente
CREATE OR REPLACE VIEW v_mascotas_completo AS
SELECT 
  m.id,
  m.casa_id,
  c.numero_casa,
  c.direccion as casa_direccion,
  c.plaza_id,
  p.nombre as plaza_nombre,
  m.residente_id,
  CASE 
    WHEN m.residente_id IS NULL THEN 'COMUNITARIA'
    ELSE CONCAT(r.nombre, ' ', r.apellido_paterno, ' ', COALESCE(r.apellido_materno, ''))
  END as dueno_nombre,
  r.run as dueno_run,
  r.telefono as dueno_telefono,
  m.nombre as mascota_nombre,
  m.tipo,
  m.raza,
  m.fecha_nacimiento,
  CASE 
    WHEN m.fecha_nacimiento IS NOT NULL THEN 
      EXTRACT(YEAR FROM AGE(CURRENT_DATE, m.fecha_nacimiento))::INTEGER
    ELSE NULL
  END as edad_anos,
  m.genero,
  m.color,
  m.certificado_vacunas,
  m.fecha_ultima_vacuna,
  CASE 
    WHEN m.fecha_ultima_vacuna IS NOT NULL THEN
      CURRENT_DATE - m.fecha_ultima_vacuna
    ELSE NULL
  END as dias_desde_vacuna,
  m.observaciones,
  m.activo,
  m.created_at,
  m.updated_at
FROM mascotas m
LEFT JOIN casas c ON m.casa_id = c.id
LEFT JOIN plazas p ON c.plaza_id = p.id
LEFT JOIN residentes r ON m.residente_id = r.id;

-- Función: Obtener estadísticas de mascotas
CREATE OR REPLACE FUNCTION get_estadisticas_mascotas()
RETURNS TABLE (
  total_mascotas BIGINT,
  mascotas_particulares BIGINT,
  mascotas_comunitarias BIGINT,
  total_perros BIGINT,
  total_gatos BIGINT,
  total_otros BIGINT,
  con_certificado_vacunas BIGINT,
  sin_certificado_vacunas BIGINT,
  promedio_edad_anos NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COUNT(*) as total_mascotas,
    COUNT(*) FILTER (WHERE residente_id IS NOT NULL) as mascotas_particulares,
    COUNT(*) FILTER (WHERE residente_id IS NULL) as mascotas_comunitarias,
    COUNT(*) FILTER (WHERE tipo = 'perro') as total_perros,
    COUNT(*) FILTER (WHERE tipo = 'gato') as total_gatos,
    COUNT(*) FILTER (WHERE tipo = 'otro') as total_otros,
    COUNT(*) FILTER (WHERE certificado_vacunas = TRUE) as con_certificado_vacunas,
    COUNT(*) FILTER (WHERE certificado_vacunas = FALSE OR certificado_vacunas IS NULL) as sin_certificado_vacunas,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento))), 1) as promedio_edad_anos
  FROM mascotas
  WHERE activo = TRUE;
END;
$$ LANGUAGE plpgsql;

-- Función: Obtener mascotas por casa
CREATE OR REPLACE FUNCTION get_mascotas_por_casa(p_casa_id INTEGER)
RETURNS TABLE (
  mascota_id INTEGER,
  nombre VARCHAR,
  tipo VARCHAR,
  raza VARCHAR,
  edad_anos INTEGER,
  dueno VARCHAR,
  certificado_vacunas BOOLEAN,
  es_comunitaria BOOLEAN
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    m.id as mascota_id,
    m.nombre,
    m.tipo,
    m.raza,
    CASE 
      WHEN m.fecha_nacimiento IS NOT NULL THEN 
        EXTRACT(YEAR FROM AGE(CURRENT_DATE, m.fecha_nacimiento))::INTEGER
      ELSE NULL
    END as edad_anos,
    CASE 
      WHEN m.residente_id IS NULL THEN 'Comunitaria'
      ELSE CONCAT(r.nombre, ' ', r.apellido_paterno)
    END as dueno,
    m.certificado_vacunas,
    (m.residente_id IS NULL) as es_comunitaria
  FROM mascotas m
  LEFT JOIN residentes r ON m.residente_id = r.id
  WHERE m.casa_id = p_casa_id
    AND m.activo = TRUE
  ORDER BY m.nombre;
END;
$$ LANGUAGE plpgsql;

-- Función: Obtener mascotas con vacunas vencidas (más de 1 año)
CREATE OR REPLACE FUNCTION get_mascotas_vacunas_vencidas()
RETURNS TABLE (
  mascota_id INTEGER,
  nombre VARCHAR,
  tipo VARCHAR,
  casa VARCHAR,
  dueno VARCHAR,
  dias_desde_vacuna INTEGER,
  telefono_contacto VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    m.id as mascota_id,
    m.nombre,
    m.tipo,
    c.numero_casa as casa,
    CASE 
      WHEN m.residente_id IS NULL THEN 'Comunitaria'
      ELSE CONCAT(r.nombre, ' ', r.apellido_paterno)
    END as dueno,
    (CURRENT_DATE - m.fecha_ultima_vacuna)::INTEGER as dias_desde_vacuna,
    r.telefono as telefono_contacto
  FROM mascotas m
  LEFT JOIN casas c ON m.casa_id = c.id
  LEFT JOIN residentes r ON m.residente_id = r.id
  WHERE m.activo = TRUE
    AND (
      m.fecha_ultima_vacuna IS NULL 
      OR (CURRENT_DATE - m.fecha_ultima_vacuna) > 365
    )
  ORDER BY m.fecha_ultima_vacuna ASC NULLS FIRST;
END;
$$ LANGUAGE plpgsql;

-- Comentarios en tablas y columnas
COMMENT ON TABLE mascotas IS 'Registro de mascotas particulares y comunitarias del condominio';
COMMENT ON COLUMN mascotas.casa_id IS 'Casa a la que pertenece la mascota (obligatorio)';
COMMENT ON COLUMN mascotas.residente_id IS 'Dueño particular de la mascota. NULL = mascota comunitaria (ON DELETE SET NULL)';
COMMENT ON COLUMN mascotas.tipo IS 'Tipo de mascota: perro, gato, otro';
COMMENT ON COLUMN mascotas.certificado_vacunas IS 'Indica si la mascota tiene certificado de vacunas al día';
COMMENT ON COLUMN mascotas.fecha_ultima_vacuna IS 'Fecha de la última vacunación registrada';
COMMENT ON COLUMN mascotas.activo IS 'Indica si la mascota está activa en el sistema (soft delete)';

COMMENT ON VIEW v_mascotas_completo IS 'Vista completa de mascotas con información de casa, plaza y dueño';
COMMENT ON FUNCTION get_estadisticas_mascotas IS 'Retorna estadísticas generales de mascotas activas';
COMMENT ON FUNCTION get_mascotas_por_casa IS 'Retorna todas las mascotas de una casa específica';
COMMENT ON FUNCTION get_mascotas_vacunas_vencidas IS 'Retorna mascotas con vacunas vencidas o sin registro';

-- Datos de ejemplo (opcional - comentar si no se requiere)
-- INSERT INTO mascotas (casa_id, residente_id, nombre, tipo, raza, fecha_nacimiento, genero, color, certificado_vacunas, fecha_ultima_vacuna)
-- VALUES 
--   (1, 1, 'Max', 'perro', 'Golden Retriever', '2020-03-15', 'macho', 'Dorado', TRUE, '2025-12-01'),
--   (1, 2, 'Luna', 'gato', 'Persa', '2021-07-22', 'hembra', 'Blanco', TRUE, '2026-01-15'),
--   (2, NULL, 'Firulais', 'perro', 'Mestizo', '2018-05-10', 'macho', 'Café', FALSE, NULL)
-- ON CONFLICT DO NOTHING;

-- Verificación
SELECT 'Migración 003_create_mascotas.sql ejecutada correctamente' AS resultado;
SELECT COUNT(*) || ' mascotas registradas' AS estado FROM mascotas;

-- Mostrar estadísticas generales
SELECT * FROM get_estadisticas_mascotas();
