-- ========================================
-- MIGRACIÓN 024: Corregir función get_historial_alertas_mascota
-- ========================================
-- Descripción: 
--   - Agregar campos faltantes: activa, ubicacion_referencia
--   - Renombrar alerta_id a id para consistencia con frontend
--   - Renombrar reportado_por a reportado_por_nombre
-- Autor: Sistema
-- Fecha: 20/05/2026
-- Contexto: Frontend admin necesita campo 'activa' para filtrar alertas activas
-- ========================================

SET timezone = 'America/Santiago';

-- Eliminar función existente (necesario cuando cambia la firma de retorno)
DROP FUNCTION IF EXISTS get_historial_alertas_mascota(INTEGER);

-- Recrear función con campos adicionales
CREATE OR REPLACE FUNCTION get_historial_alertas_mascota(p_mascota_id INTEGER)
RETURNS TABLE (
    id INTEGER,
    tipo_alerta VARCHAR,
    descripcion TEXT,
    ubicacion_referencia TEXT,
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    activa BOOLEAN,
    dias_duracion INTEGER,
    reportado_por_nombre VARCHAR,
    resuelto_por VARCHAR,
    notas_resolucion TEXT,
    prioridad VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id,
        a.tipo_alerta,
        a.descripcion,
        a.ubicacion_referencia,
        a.fecha_inicio,
        a.fecha_fin,
        a.activa,
        CASE 
            WHEN a.fecha_fin IS NOT NULL THEN
                EXTRACT(DAY FROM (a.fecha_fin - a.fecha_inicio))::INTEGER
            ELSE
                EXTRACT(DAY FROM (CURRENT_TIMESTAMP - a.fecha_inicio))::INTEGER
        END as dias_duracion,
        CASE 
            WHEN a.reportado_por IS NOT NULL THEN 
                CONCAT(r1.nombre, ' ', r1.apellido_paterno)
            ELSE 'Administrador'
        END::VARCHAR as reportado_por_nombre,
        CASE 
            WHEN a.resuelto_por IS NOT NULL THEN 
                CONCAT(r2.nombre, ' ', r2.apellido_paterno)
            ELSE NULL
        END as resuelto_por,
        a.notas_resolucion,
        a.prioridad
    FROM alertas_mascotas a
    LEFT JOIN residentes r1 ON a.reportado_por = r1.id
    LEFT JOIN residentes r2 ON a.resuelto_por = r2.id
    WHERE a.mascota_id = p_mascota_id
    ORDER BY a.fecha_inicio DESC;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION get_historial_alertas_mascota IS 
'Retorna historial completo de alertas de una mascota.
Actualizado para incluir campos: activa, ubicacion_referencia, id.
Usado por frontend admin para filtrar alertas activas.';

-- =============================================
-- VERIFICACIÓN
-- =============================================

SELECT 'Migración 024 ejecutada correctamente' AS resultado;

-- =============================================
-- FIN DE MIGRACIÓN 024
-- =============================================
