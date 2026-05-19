-- ========================================
-- MIGRACIÓN 011: Morosidad solo por Cuota Social
-- ========================================
-- Descripción: Corregir lógica de morosidad para considerar solo Cuota Social (obligatoria)
-- Autor: Sistema
-- Fecha: 19/05/2026
-- Cambios:
--   - Ignorar Junta de Vecinos (pago voluntario) para calcular morosidad
--   - Contar MESES MOROSOS (periodos únicos) en lugar de cantidad de pagos
--   - Solo Cuota Social afecta el acceso de vehículos
-- ========================================

SET timezone = 'America/Santiago';

-- =============================================
-- VISTA ACTUALIZADA: v_vehiculos_completo
-- =============================================

-- Eliminar vista anterior (cambio de columnas)
DROP VIEW IF EXISTS v_vehiculos_completo;

-- Crear vista con nueva estructura
CREATE VIEW v_vehiculos_completo AS
SELECT 
    v.patente,
    v.casa_id,
    c.numero_casa,
    c.direccion as casa_direccion,
    c.plaza_id,
    pl.nombre as plaza_nombre,
    v.residente_id,
    CASE 
        WHEN v.residente_id IS NOT NULL THEN 
            r.nombre || ' ' || r.apellido_paterno || COALESCE(' ' || r.apellido_materno, '')
        ELSE 'Sin residente asignado'
    END as residente_nombre,
    CASE 
        WHEN v.residente_id IS NOT NULL THEN r.run
        ELSE NULL
    END as residente_run,
    v.marca,
    v.modelo,
    v.color,
    v.anio,
    v.tipo,
    v.observaciones,
    
    -- NUEVO: Cantidad de MESES con Cuota Social vencida (periodos únicos)
    (
        SELECT COUNT(DISTINCT p.periodo) 
        FROM pagos p 
        WHERE p.casa_id = v.casa_id 
        AND p.tipo_pago = 'cuota_social'
        AND p.estado = 'vencido' 
        AND p.activo = TRUE
    ) as meses_moroso,
    
    -- Deuda SOLO de Cuota Social (ignorar Junta de Vecinos)
    (
        SELECT COALESCE(SUM(p.monto), 0)
        FROM pagos p 
        WHERE p.casa_id = v.casa_id 
        AND p.tipo_pago = 'cuota_social'
        AND p.estado = 'vencido' 
        AND p.activo = TRUE
    ) as deuda_total,
    
    -- Estado de morosidad basado SOLO en Cuota Social
    CASE 
        -- Si NO tiene ninguna Cuota Social registrada
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND p.activo = TRUE
        ) = 0 THEN 'sin_pagos'
        
        -- Clasificar por MESES morosos (no cantidad de pagos)
        WHEN (
            SELECT COUNT(DISTINCT p.periodo) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND p.estado = 'vencido' 
            AND p.activo = TRUE
        ) >= 3 THEN 'mora_grave'
        
        WHEN (
            SELECT COUNT(DISTINCT p.periodo) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND p.estado = 'vencido' 
            AND p.activo = TRUE
        ) = 2 THEN 'mora_moderada'
        
        WHEN (
            SELECT COUNT(DISTINCT p.periodo) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND p.estado = 'vencido' 
            AND p.activo = TRUE
        ) = 1 THEN 'mora_leve'
        
        -- Si tiene Cuotas Sociales pero ninguna vencida
        ELSE 'al_dia'
    END as estado_morosidad,
    
    -- Control de acceso basado SOLO en Cuota Social
    CASE 
        -- Bloquear si NO tiene Cuota Social registrada
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND p.activo = TRUE
        ) = 0 THEN FALSE
        
        -- Bloquear si tiene 3 o más MESES con Cuota Social vencida
        WHEN (
            SELECT COUNT(DISTINCT p.periodo) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND p.estado = 'vencido' 
            AND p.activo = TRUE
        ) >= 3 THEN FALSE
        
        -- Permitir acceso en otros casos
        ELSE TRUE
    END as acceso_permitido,
    
    v.activo,
    v.created_at,
    v.updated_at
FROM vehiculos v
INNER JOIN casas c ON v.casa_id = c.id
INNER JOIN plazas pl ON c.plaza_id = pl.id
LEFT JOIN residentes r ON v.residente_id = r.id;

-- =============================================
-- COMENTARIO
-- =============================================
COMMENT ON VIEW v_vehiculos_completo IS 
'Vista completa de vehículos con información de morosidad.
CAMBIO 19/05/2026: Morosidad calculada SOLO con Cuota Social (obligatoria).
- Junta de Vecinos es VOLUNTARIA y NO afecta acceso vehicular
- meses_moroso cuenta PERIODOS únicos, no cantidad de pagos
- Clasificación: mora_leve (1 mes), mora_moderada (2 meses), mora_grave (3+ meses)
- Acceso bloqueado con 3+ meses de Cuota Social vencida';

-- =============================================
-- VERIFICACIÓN
-- =============================================
SELECT 'Migración 011 ejecutada correctamente' as resultado;

-- Mostrar estado actual de vehículos con nueva lógica
SELECT 
    patente,
    numero_casa,
    meses_moroso,
    deuda_total,
    estado_morosidad,
    acceso_permitido
FROM v_vehiculos_completo
ORDER BY numero_casa;
