-- ========================================
-- MIGRACIÓN 008: Automatizar actualización de morosidad
-- ========================================
-- Descripción: Función para actualizar automáticamente estados de pagos según fecha de vencimiento
-- Autor: Sistema
-- Fecha: 19/05/2026
-- Lógica: 
--   - Fecha vencimiento: día 5 de cada mes
--   - Después del día 5: estado 'pendiente' → 'vencido'
--   - Al pagar: estado → 'pagado' (independiente de la fecha)
-- ========================================

SET timezone = 'America/Santiago';

-- =============================================
-- FUNCIÓN: Actualizar estados de pagos vencidos
-- =============================================
-- Esta función debe ejecutarse diariamente para mantener
-- los estados actualizados automáticamente

CREATE OR REPLACE FUNCTION actualizar_estados_pagos()
RETURNS TABLE(
    actualizados INTEGER,
    mensaje TEXT
) AS $$
DECLARE
    v_actualizados INTEGER;
BEGIN
    -- Actualizar pagos pendientes que ya vencieron
    UPDATE pagos
    SET estado = 'vencido'
    WHERE estado = 'pendiente'
    AND fecha_vencimiento < CURRENT_DATE
    AND activo = TRUE;
    
    GET DIAGNOSTICS v_actualizados = ROW_COUNT;
    
    RETURN QUERY SELECT 
        v_actualizados,
        CASE 
            WHEN v_actualizados = 0 THEN 'No hay pagos que actualizar'
            WHEN v_actualizados = 1 THEN '1 pago actualizado a vencido'
            ELSE v_actualizados || ' pagos actualizados a vencido'
        END;
END;
$$ LANGUAGE plpgsql;

-- Comentario sobre la función
COMMENT ON FUNCTION actualizar_estados_pagos() IS 
'Actualiza automáticamente el estado de pagos pendientes a vencido cuando la fecha de vencimiento ha pasado.
Debe ejecutarse diariamente mediante un proceso programado.';

-- =============================================
-- FUNCIÓN: Registrar pago y actualizar estado
-- =============================================
-- Esta función se usa cuando se registra el pago de una cuota
-- Actualiza el estado a 'pagado' independientemente de si estaba vencido
-- REEMPLAZA la función de migración 004 con validaciones mejoradas

-- Eliminar función anterior (tiene firma diferente)
DROP FUNCTION IF EXISTS registrar_pago(INTEGER, VARCHAR, VARCHAR, TIMESTAMPTZ);

CREATE OR REPLACE FUNCTION registrar_pago(
    p_pago_id INTEGER,
    p_metodo_pago VARCHAR(30),
    p_numero_comprobante VARCHAR(100) DEFAULT NULL,
    p_fecha_pago TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
)
RETURNS TABLE(
    success BOOLEAN,
    message TEXT
) AS $$
DECLARE
    v_pago RECORD;
    v_dias_atraso INTEGER;
BEGIN
    -- Verificar que el pago existe
    SELECT * INTO v_pago
    FROM pagos
    WHERE id = p_pago_id
    AND activo = TRUE;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT 
            FALSE,
            'Pago no encontrado'::TEXT;
        RETURN;
    END IF;
    
    -- Verificar que el pago no está ya pagado
    IF v_pago.estado = 'pagado' THEN
        RETURN QUERY SELECT 
            FALSE,
            'El pago ya fue registrado anteriormente'::TEXT;
        RETURN;
    END IF;
    
    -- Verificar que el pago no está anulado
    IF v_pago.estado = 'anulado' THEN
        RETURN QUERY SELECT 
            FALSE,
            'No se puede registrar un pago anulado'::TEXT;
        RETURN;
    END IF;
    
    -- Calcular días de atraso
    v_dias_atraso := CASE 
        WHEN p_fecha_pago::DATE > v_pago.fecha_vencimiento 
        THEN (p_fecha_pago::DATE - v_pago.fecha_vencimiento)
        ELSE 0
    END;
    
    -- Actualizar el pago (cambia de 'pendiente' o 'vencido' a 'pagado')
    UPDATE pagos
    SET 
        estado = 'pagado',
        fecha_pago = p_fecha_pago,
        metodo_pago = p_metodo_pago,
        numero_comprobante = p_numero_comprobante
    WHERE id = p_pago_id;
    
    -- Retornar mensaje apropiado
    RETURN QUERY SELECT 
        TRUE,
        CASE 
            WHEN v_dias_atraso > 0 THEN 
                'Pago registrado con ' || v_dias_atraso || ' días de atraso (vencía el ' || 
                TO_CHAR(v_pago.fecha_vencimiento, 'DD/MM/YYYY') || ')'
            ELSE 
                'Pago registrado correctamente'
        END::TEXT;
    
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION registrar_pago(INTEGER, VARCHAR, VARCHAR, TIMESTAMPTZ) IS 
'Registra el pago de una cuota. Si estaba vencida, vuelve a estado "pagado" (al día).
Compatible con endpoint PUT /api/pagos/:id/registrar del backend.
Retorna success (boolean) y mensaje con información de atraso si aplica.';

-- =============================================
-- VISTA: Estado actual de morosidad por casa
-- =============================================
-- Vista que calcula en tiempo real el estado de morosidad
-- independientemente del estado almacenado en la tabla

CREATE OR REPLACE VIEW v_estado_morosidad_casas AS
SELECT 
    c.id as casa_id,
    c.numero_casa,
    c.direccion,
    c.plaza_id,
    pl.nombre as plaza_nombre,
    
    -- Contadores
    COUNT(p.id) FILTER (WHERE p.activo = TRUE) as total_pagos,
    COUNT(p.id) FILTER (WHERE p.estado = 'pendiente' AND p.fecha_vencimiento >= CURRENT_DATE) as pendientes_vigentes,
    COUNT(p.id) FILTER (WHERE p.estado = 'vencido' OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)) as total_vencidos,
    COUNT(p.id) FILTER (WHERE p.estado = 'pagado') as total_pagados,
    
    -- Deuda total (solo vencidos activos)
    COALESCE(SUM(p.monto) FILTER (WHERE (p.estado = 'vencido' OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)) AND p.activo = TRUE), 0) as deuda_total,
    
    -- Estado calculado en tiempo real
    CASE 
        WHEN COUNT(p.id) FILTER (WHERE p.activo = TRUE) = 0 THEN 'sin_pagos'
        WHEN COUNT(p.id) FILTER (WHERE (p.estado = 'vencido' OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)) AND p.activo = TRUE) >= 6 THEN 'mora_grave'
        WHEN COUNT(p.id) FILTER (WHERE (p.estado = 'vencido' OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)) AND p.activo = TRUE) >= 3 THEN 'mora_moderada'
        WHEN COUNT(p.id) FILTER (WHERE (p.estado = 'vencido' OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)) AND p.activo = TRUE) > 0 THEN 'mora_leve'
        ELSE 'al_dia'
    END as estado_morosidad,
    
    -- Acceso permitido (bloqueado si sin pagos o 3+ vencidos)
    CASE 
        WHEN COUNT(p.id) FILTER (WHERE p.activo = TRUE) = 0 THEN FALSE
        WHEN COUNT(p.id) FILTER (WHERE (p.estado = 'vencido' OR (p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE)) AND p.activo = TRUE) >= 3 THEN FALSE
        ELSE TRUE
    END as acceso_permitido

FROM casas c
INNER JOIN plazas pl ON c.plaza_id = pl.id
LEFT JOIN pagos p ON c.id = p.casa_id
WHERE c.activo = TRUE
GROUP BY c.id, c.numero_casa, c.direccion, c.plaza_id, pl.nombre;

COMMENT ON VIEW v_estado_morosidad_casas IS 
'Vista que calcula en tiempo real el estado de morosidad de cada casa.
Considera como vencidos tanto los pagos con estado=vencido como los pendientes con fecha_vencimiento < CURRENT_DATE.
Actualizado: 19/05/2026';

-- =============================================
-- FUNCIÓN DE PRUEBA: Ejecutar actualización manual
-- =============================================
-- Ejecutar esta función para probar la actualización de estados

SELECT * FROM actualizar_estados_pagos();
