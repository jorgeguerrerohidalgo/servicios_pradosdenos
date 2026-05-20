-- ========================================
-- MIGRACIÓN 022: Cambiar vistas a SECURITY INVOKER
-- ========================================
-- Descripción: Corrige el warning de Supabase Linter
--              Cambia SECURITY DEFINER → SECURITY INVOKER
-- Autor: Sistema
-- Fecha: 20/05/2026
-- Contexto: Supabase Linter marca ERROR por SECURITY DEFINER
--           SECURITY INVOKER usa permisos del usuario que consulta (más seguro)
-- ========================================

SET timezone = 'America/Santiago';

-- =============================================
-- VISTA: v_vehiculos_completo (SECURITY INVOKER)
-- =============================================

DROP VIEW IF EXISTS v_vehiculos_completo CASCADE;

CREATE VIEW v_vehiculos_completo
WITH (security_invoker = true)  -- CAMBIO: Usa permisos del usuario que consulta
AS
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
    
    -- Contar MESES con Cuota Social vencida
    (
        SELECT COUNT(DISTINCT p.periodo) 
        FROM pagos p 
        WHERE p.casa_id = v.casa_id 
        AND p.tipo_pago = 'cuota_social'
        AND (
            p.estado = 'vencido' 
            OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)
        )
        AND p.activo = TRUE
    ) as meses_moroso,
    
    -- Deuda SOLO de Cuota Social
    (
        SELECT COALESCE(SUM(p.monto), 0)
        FROM pagos p 
        WHERE p.casa_id = v.casa_id 
        AND p.tipo_pago = 'cuota_social'
        AND (
            p.estado = 'vencido' 
            OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)
        )
        AND p.activo = TRUE
    ) as deuda_total,
    
    -- Estado de morosidad
    CASE 
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND p.activo = TRUE
        ) = 0 THEN 'sin_pagos'
        
        WHEN (
            SELECT COUNT(DISTINCT p.periodo) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND (
                p.estado = 'vencido' 
                OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)
            )
            AND p.activo = TRUE
        ) >= 3 THEN 'mora_grave'
        
        WHEN (
            SELECT COUNT(DISTINCT p.periodo) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND (
                p.estado = 'vencido' 
                OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)
            )
            AND p.activo = TRUE
        ) = 2 THEN 'mora_moderada'
        
        WHEN (
            SELECT COUNT(DISTINCT p.periodo) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND (
                p.estado = 'vencido' 
                OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)
            )
            AND p.activo = TRUE
        ) >= 1 THEN 'mora_leve'
        
        ELSE 'al_dia'
    END as estado_morosidad,
    
    -- Control de acceso
    CASE 
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND p.activo = TRUE
        ) = 0 THEN FALSE
        
        WHEN (
            SELECT COUNT(DISTINCT p.periodo) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND (
                p.estado = 'vencido' 
                OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)
            )
            AND p.activo = TRUE
        ) >= 1 THEN FALSE
        
        ELSE TRUE
    END as acceso_permitido,
    
    v.activo,
    v.created_at,
    v.updated_at
FROM vehiculos v
INNER JOIN casas c ON v.casa_id = c.id
INNER JOIN plazas pl ON c.plaza_id = pl.id
LEFT JOIN residentes r ON v.residente_id = r.id
WHERE v.activo = TRUE;

COMMENT ON VIEW v_vehiculos_completo IS 
'Vista completa de vehículos con información de morosidad.
CAMBIO 20/05/2026 (022): SECURITY INVOKER para cumplir con linter Supabase';

-- =============================================
-- VISTA: v_casas_estado_pagos (SECURITY INVOKER)
-- =============================================

DROP VIEW IF EXISTS v_casas_estado_pagos CASCADE;

CREATE VIEW v_casas_estado_pagos
WITH (security_invoker = true)  -- CAMBIO: Usa permisos del usuario que consulta
AS
SELECT 
    c.id,
    c.numero_casa,
    c.direccion,
    c.plaza_id,
    pl.nombre as plaza_nombre,
    c.monto_cuota_social,
    c.monto_junta_vecinos,
    (c.monto_cuota_social + c.monto_junta_vecinos) as monto_total_mensual,
    
    (SELECT COUNT(*) FROM residentes r WHERE r.casa_id = c.id AND r.activo = TRUE) as total_residentes,
    
    -- Estado de pagos
    CASE 
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = c.id 
            AND p.tipo_pago = 'cuota_social'
            AND p.activo = TRUE
        ) = 0 THEN 'sin_pagos'
        
        WHEN (
            SELECT COUNT(DISTINCT p.periodo) 
            FROM pagos p 
            WHERE p.casa_id = c.id 
            AND p.tipo_pago = 'cuota_social'
            AND (
                p.estado = 'vencido' 
                OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)
            )
            AND p.activo = TRUE
        ) >= 3 THEN 'mora_grave'
        
        WHEN (
            SELECT COUNT(DISTINCT p.periodo) 
            FROM pagos p 
            WHERE p.casa_id = c.id 
            AND p.tipo_pago = 'cuota_social'
            AND (
                p.estado = 'vencido' 
                OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)
            )
            AND p.activo = TRUE
        ) = 2 THEN 'mora_moderada'
        
        WHEN (
            SELECT COUNT(DISTINCT p.periodo) 
            FROM pagos p 
            WHERE p.casa_id = c.id 
            AND p.tipo_pago = 'cuota_social'
            AND (
                p.estado = 'vencido' 
                OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)
            )
            AND p.activo = TRUE
        ) >= 1 THEN 'mora_leve'
        
        ELSE 'al_dia'
    END as estado_pago,
    
    -- Meses morosos
    (
        SELECT COUNT(DISTINCT p.periodo) 
        FROM pagos p 
        WHERE p.casa_id = c.id 
        AND p.tipo_pago = 'cuota_social'
        AND (
            p.estado = 'vencido' 
            OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)
        )
        AND p.activo = TRUE
    ) as meses_morosos,
    
    -- Deuda total
    (
        SELECT COALESCE(SUM(p.monto), 0)
        FROM pagos p 
        WHERE p.casa_id = c.id 
        AND p.tipo_pago = 'cuota_social'
        AND (
            p.estado = 'vencido' 
            OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)
        )
        AND p.activo = TRUE
    ) as deuda_total,
    
    c.activo,
    c.created_at,
    c.updated_at
FROM casas c
INNER JOIN plazas pl ON c.plaza_id = pl.id;

COMMENT ON VIEW v_casas_estado_pagos IS 
'Vista de casas con su estado de pagos.
CAMBIO 20/05/2026 (022): SECURITY INVOKER para cumplir con linter Supabase';

-- =============================================
-- VERIFICACIÓN
-- =============================================

-- Verificar que las vistas funcionan correctamente
SELECT COUNT(*) as total_vehiculos FROM v_vehiculos_completo;
SELECT COUNT(*) as total_casas FROM v_casas_estado_pagos;

-- =============================================
-- FIN DE MIGRACIÓN 022
-- =============================================
