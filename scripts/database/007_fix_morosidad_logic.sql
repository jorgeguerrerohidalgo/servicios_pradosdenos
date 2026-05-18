-- ========================================
-- MIGRACIÓN 007: Corregir lógica de morosidad
-- ========================================
-- Descripción: Corregir vista v_vehiculos_completo para detectar casas sin pagos registrados
-- Autor: Sistema
-- Fecha: 18/05/2026
-- Bug: Casas sin pagos registrados aparecen como "al_dia" con acceso_permitido=TRUE
-- Solución: Bloquear acceso si no hay ningún pago registrado
-- ========================================

SET timezone = 'America/Santiago';

-- =============================================
-- VISTA CORREGIDA: v_vehiculos_completo
-- =============================================
CREATE OR REPLACE VIEW v_vehiculos_completo AS
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
    
    -- Contadores estadísticos
    (
        SELECT COUNT(*) 
        FROM pagos p 
        WHERE p.casa_id = v.casa_id 
        AND p.estado = 'vencido' 
        AND p.activo = TRUE
    ) as pagos_vencidos,
    (
        SELECT COALESCE(SUM(p.monto), 0)
        FROM pagos p 
        WHERE p.casa_id = v.casa_id 
        AND p.estado = 'vencido' 
        AND p.activo = TRUE
    ) as deuda_total,
    
    -- CORREGIDO: Estado de morosidad considerando si existen pagos
    CASE 
        -- Primero verificar si NO tiene ningún pago registrado
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.activo = TRUE
        ) = 0 THEN 'sin_pagos'
        
        -- Si tiene pagos vencidos, clasificar según gravedad
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.estado = 'vencido' 
            AND p.activo = TRUE
        ) >= 6 THEN 'mora_grave'
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.estado = 'vencido' 
            AND p.activo = TRUE
        ) >= 3 THEN 'mora_moderada'
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.estado = 'vencido' 
            AND p.activo = TRUE
        ) > 0 THEN 'mora_leve'
        
        -- Si tiene pagos pero ninguno vencido → realmente al día
        ELSE 'al_dia'
    END as estado_morosidad,
    
    -- CORREGIDO: Control de acceso - bloquear si no hay pagos o si tiene 3+ vencidos
    CASE 
        -- Bloquear si NO tiene ningún pago registrado
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.activo = TRUE
        ) = 0 THEN FALSE
        
        -- Bloquear si tiene 3 o más pagos vencidos
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
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

-- Comentario sobre el cambio
COMMENT ON VIEW v_vehiculos_completo IS 
'Vista completa de vehículos con información de morosidad. 
CAMBIO 18/05/2026: Ahora bloquea acceso si la casa no tiene pagos registrados (antes permitía acceso).
Estado sin_pagos indica que no se han generado pagos para la casa.';
