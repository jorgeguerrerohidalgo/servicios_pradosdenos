-- ========================================
-- MIGRACIÓN 021: Filtrar vehículos activos y eliminar gracia en acceso
-- ========================================
-- Descripción: 
--   1. Agrega filtro v.activo = TRUE para ocultar vehículos borrados
--   2. Cambia acceso_permitido: bloquea desde el primer mes de mora (sin gracia)
-- Autor: Sistema
-- Fecha: 20/05/2026
-- Contexto: Vencimiento día 5 → Bloqueado día 6
--           Si paga después del 5 → Permitido al día siguiente (automático)
-- ========================================

SET timezone = 'America/Santiago';

-- =============================================
-- VISTA ACTUALIZADA: v_vehiculos_completo
-- =============================================
-- Cambios:
-- 1. Agrega WHERE v.activo = TRUE para filtrar vehículos borrados
-- 2. Cambia acceso_permitido: >= 1 mes moroso = BLOQUEADO (antes era >= 3)

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
    
    -- Contar MESES con Cuota Social vencida (estado='vencido' O fecha pasada)
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
    
    -- Deuda SOLO de Cuota Social (estado='vencido' O fecha pasada)
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
    
    -- Estado de morosidad considerando fecha de vencimiento
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
    
    -- NUEVO: Control de acceso SIN GRACIA (1+ mes moroso = BLOQUEADO)
    CASE 
        -- Bloquear si NO tiene Cuota Social registrada
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.tipo_pago = 'cuota_social'
            AND p.activo = TRUE
        ) = 0 THEN FALSE
        
        -- CAMBIO: Bloquear si tiene 1 o más MESES con Cuota Social vencida (antes era >= 3)
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
        
        -- Permitir acceso solo si está al día
        ELSE TRUE
    END as acceso_permitido,
    
    v.activo,
    v.created_at,
    v.updated_at
FROM vehiculos v
INNER JOIN casas c ON v.casa_id = c.id
INNER JOIN plazas pl ON c.plaza_id = pl.id
LEFT JOIN residentes r ON v.residente_id = r.id
WHERE v.activo = TRUE;  -- NUEVO: Filtrar solo vehículos activos

COMMENT ON VIEW v_vehiculos_completo IS 
'Vista completa de vehículos con información de morosidad.
CAMBIO 20/05/2026 (021): 
- Filtra solo vehículos activos (v.activo = TRUE)
- Acceso sin gracia: 1+ mes moroso = BLOQUEADO
- Vencimiento día 5 → Bloqueado día 6
- Si paga después → Permitido al día siguiente (automático)';

-- =============================================
-- VERIFICACIÓN
-- =============================================

-- 1. Verificar que HHDD76 NO aparece (activo=false)
SELECT 
    patente,
    numero_casa,
    meses_moroso,
    estado_morosidad,
    acceso_permitido
FROM v_vehiculos_completo
WHERE patente = 'HHDD76';
-- Debe devolver 0 filas

-- 2. Verificar vehículo KCLR36 (casa 002 con 1 mes moroso)
SELECT 
    patente,
    numero_casa,
    meses_moroso,
    deuda_total,
    estado_morosidad,
    acceso_permitido
FROM v_vehiculos_completo
WHERE patente = 'KCLR36';
-- Debe mostrar: meses_moroso=1, acceso_permitido=FALSE

-- 3. Mostrar todos los vehículos con morosidad
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

-- =============================================
-- FIN DE MIGRACIÓN 021
-- =============================================
