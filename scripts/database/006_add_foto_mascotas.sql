-- ========================================
-- MIGRACIÓN 006: Agregar campo foto a mascotas
-- ========================================
-- Descripción: Agrega columna foto_url para almacenar imagen de la mascota
-- Autor: Sistema
-- Fecha: 15/05/2026
-- ========================================

-- Agregar columna foto_url a tabla mascotas
ALTER TABLE mascotas 
ADD COLUMN IF NOT EXISTS foto_url TEXT;

-- Comentario para documentar el campo
COMMENT ON COLUMN mascotas.foto_url IS 'URL o path de la foto de la mascota para identificación visual';

-- Actualizar vista v_mascotas_completo para incluir foto_url
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
  END as edad_anios,
  m.genero,
  m.color,
  m.certificado_vacunas,
  m.fecha_ultima_vacuna,
  m.foto_url,  -- Nuevo campo agregado
  m.observaciones,
  m.activo,
  m.created_at,
  m.updated_at
FROM mascotas m
INNER JOIN casas c ON m.casa_id = c.id
INNER JOIN plazas p ON c.plaza_id = p.id
LEFT JOIN residentes r ON m.residente_id = r.id
ORDER BY p.nombre, c.numero_casa, m.nombre;

-- Mensaje de confirmación
DO $$
BEGIN
  RAISE NOTICE 'Migración 006 completada: Campo foto_url agregado a mascotas';
END $$;
