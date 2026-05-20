-- ========================================
-- MIGRACIÓN 020: Corregir detección de pagos vencidos y agregar estado a casas
-- ========================================
-- Descripción: Corrige la lógica para detectar pagos vencidos considerando también
--              pagos pendientes con fecha_vencimiento pasada
-- Autor: Sistema
-- Fecha: 20/05/2026
-- Contexto: Vencimiento día 5 de cada mes
-- Problema: Vehículos mostraban "al día" cuando casa tenía pagos vencidos
--           porque solo verificaba estado='vencido' y no fecha_vencimiento
-- ========================================

SET timezone = 'America/Santiago';

-- =============================================
-- VISTA ACTUALIZADA: v_vehiculos_completo
-- =============================================
-- Corrige la detección de pagos vencidos para considerar:
-- 1. Pagos con estado = 'vencido' (marcados explícitamente)
-- 2. Pagos con estado = 'pendiente' Y fecha_vencimiento < CURRENT_DATE

DROP VIEW IF EXISTS v_vehiculos_completo CASCADE;

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
    
    -- CORREGIDO: Contar MESES con Cuota Social vencida (estado='vencido' O fecha pasada)
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
    
    -- CORREGIDO: Deuda SOLO de Cuota Social (estado='vencido' O fecha pasada)
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
    
    -- CORREGIDO: Estado de morosidad considerando fecha de vencimiento
    CASE 
        -- Si NO tiene ninguna Cuota Social registrada
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND p.activo = TRUE
        ) = 0 THEN 'sin_pagos'
        
        -- Clasificar por MESES morosos (considerando fecha de vencimiento)
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
        
        -- Si tiene Cuotas Sociales pero ninguna vencida
        ELSE 'al_dia'
    END as estado_morosidad,
    
    -- CORREGIDO: Control de acceso considerando fecha de vencimiento
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
            AND (
                p.estado = 'vencido' 
                OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)
            )
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

COMMENT ON VIEW v_vehiculos_completo IS 
'Vista completa de vehículos con información de morosidad.
CAMBIO 20/05/2026: Corrige detección de pagos vencidos.
Considera como vencidos: estado=vencido O (estado=pendiente Y fecha_vencimiento < CURRENT_DATE).
Vencimiento día 5 de cada mes. Si no se paga antes del día 5, queda vencido.';

-- =============================================
-- NUEVA VISTA: v_casas_estado_pagos
-- =============================================
-- Vista para mostrar estado de pagos de cada casa

CREATE OR REPLACE VIEW v_casas_estado_pagos AS
SELECT 
    c.id,
    c.numero_casa,
    c.direccion,
    c.plaza_id,
    pl.nombre as plaza_nombre,
    c.monto_cuota_social,
    c.monto_junta_vecinos,
    (c.monto_cuota_social + c.monto_junta_vecinos) as monto_total_mensual,
    
    -- Contador de residentes
    (SELECT COUNT(*) FROM residentes r WHERE r.casa_id = c.id AND r.activo = TRUE) as total_residentes,
    
    -- ESTADO DE PAGOS: Basado en Cuota Social
    CASE 
        -- Sin pagos registrados
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = c.id 
            AND p.tipo_pago = 'cuota_social'
            AND p.activo = TRUE
        ) = 0 THEN 'sin_pagos'
        
        -- Mora grave: 3+ meses vencidos
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
        
        -- Mora moderada: 2 meses vencidos
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
        
        -- Mora leve: 1 mes vencido
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
        
        -- Al día
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
Incluye: estado_pago, meses_morosos, deuda_total.
Vencimiento día 5 de cada mes.';

-- =============================================
-- VERIFICACIÓN
-- =============================================

-- Mostrar vehículos con su estado de morosidad
SELECT 
    patente,
    numero_casa,
    plaza_nombre,
    meses_moroso,
    deuda_total,
    estado_morosidad,
    acceso_permitido
FROM v_vehiculos_completo
WHERE meses_moroso > 0
ORDER BY meses_moroso DESC, patente
LIMIT 20;

-- Mostrar casas con su estado de pagos
SELECT 
    numero_casa,
    plaza_nombre,
    estado_pago,
    meses_morosos,
    deuda_total
FROM v_casas_estado_pagos
WHERE estado_pago != 'al_dia'
ORDER BY meses_morosos DESC, numero_casa
LIMIT 20;

-- Comparación de pagos pendientes con fecha vencida
SELECT 
    COUNT(*) as total_pagos_pendientes_vencidos
FROM pagos
WHERE estado = 'pendiente' 
AND fecha_vencimiento < CURRENT_DATE
AND tipo_pago = 'cuota_social'
AND activo = TRUE;

-- =============================================
-- FIN DE MIGRACIÓN 020
-- =============================================
