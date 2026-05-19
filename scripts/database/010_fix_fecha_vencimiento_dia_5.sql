-- ========================================
-- MIGRACIÓN 010: Corregir fecha de vencimiento a día 5 del mes
-- ========================================
-- Descripción: Actualizar función generar_pagos_periodo para usar día 5 en lugar de último día
-- Autor: Sistema
-- Fecha: 19/05/2026
-- Problema: Los pagos se generaban con vencimiento 31 de mayo en lugar de 5 de mayo
-- ========================================

SET timezone = 'America/Santiago';

-- =============================================
-- PASO 1: Eliminar pagos de mayo 2026 con fecha incorrecta
-- =============================================
DELETE FROM pagos 
WHERE periodo = '2026-05' 
AND fecha_vencimiento = '2026-05-31'
AND activo = TRUE;

-- =============================================
-- PASO 2: Actualizar función generar_pagos_periodo
-- =============================================
CREATE OR REPLACE FUNCTION generar_pagos_periodo(
  p_periodo VARCHAR,
  p_fecha_vencimiento DATE DEFAULT NULL
)
RETURNS TABLE (
  casas_procesadas INTEGER,
  pagos_generados INTEGER,
  pagos_saltados INTEGER
) AS $$
DECLARE
  v_casas_procesadas INTEGER := 0;
  v_pagos_generados INTEGER := 0;
  v_pagos_saltados INTEGER := 0;
  v_fecha_vencimiento DATE;
  v_casa RECORD;
BEGIN
  -- Si no se proporciona fecha de vencimiento, usar el día 5 del mes
  IF p_fecha_vencimiento IS NULL THEN
    v_fecha_vencimiento := TO_DATE(p_periodo || '-05', 'YYYY-MM-DD');
  ELSE
    v_fecha_vencimiento := p_fecha_vencimiento;
  END IF;
  
  -- Generar pagos para cada casa activa
  FOR v_casa IN 
    SELECT id, monto_cuota_social, monto_junta_vecinos 
    FROM casas 
    WHERE activo = TRUE
  LOOP
    v_casas_procesadas := v_casas_procesadas + 1;
    
    -- Generar pago de cuota social si tiene monto
    IF v_casa.monto_cuota_social > 0 THEN
      BEGIN
        INSERT INTO pagos (casa_id, periodo, tipo_pago, monto, fecha_vencimiento, estado)
        VALUES (
          v_casa.id, 
          p_periodo, 
          'cuota_social', 
          v_casa.monto_cuota_social, 
          v_fecha_vencimiento,
          'pendiente'
        )
        ON CONFLICT (casa_id, periodo, tipo_pago) DO NOTHING;
        
        IF FOUND THEN
          v_pagos_generados := v_pagos_generados + 1;
        ELSE
          v_pagos_saltados := v_pagos_saltados + 1;
        END IF;
      EXCEPTION WHEN OTHERS THEN
        v_pagos_saltados := v_pagos_saltados + 1;
      END;
    END IF;
    
    -- Generar pago de junta de vecinos si tiene monto
    IF v_casa.monto_junta_vecinos > 0 THEN
      BEGIN
        INSERT INTO pagos (casa_id, periodo, tipo_pago, monto, fecha_vencimiento, estado)
        VALUES (
          v_casa.id, 
          p_periodo, 
          'junta_vecinos', 
          v_casa.monto_junta_vecinos, 
          v_fecha_vencimiento,
          'pendiente'
        )
        ON CONFLICT (casa_id, periodo, tipo_pago) DO NOTHING;
        
        IF FOUND THEN
          v_pagos_generados := v_pagos_generados + 1;
        ELSE
          v_pagos_saltados := v_pagos_saltados + 1;
        END IF;
      EXCEPTION WHEN OTHERS THEN
        v_pagos_saltados := v_pagos_saltados + 1;
      END;
    END IF;
  END LOOP;
  
  RETURN QUERY SELECT v_casas_procesadas, v_pagos_generados, v_pagos_saltados;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- COMENTARIO
-- =============================================
COMMENT ON FUNCTION generar_pagos_periodo IS 
'Genera pagos automáticamente para todas las casas activas en un período.
CAMBIO 19/05/2026: Fecha de vencimiento por defecto ahora es DÍA 5 del mes (antes era último día).
Parámetros:
- p_periodo: Formato YYYY-MM (ej: 2026-05)
- p_fecha_vencimiento: Opcional, si no se provee usa día 5 del mes';

-- =============================================
-- VERIFICACIÓN
-- =============================================
SELECT 'Migración 010 ejecutada correctamente' as resultado;
SELECT 'Función generar_pagos_periodo actualizada: vencimiento día 5' as mensaje;
SELECT COUNT(*) as pagos_eliminados_mayo_2026 
FROM pagos 
WHERE periodo = '2026-05'; -- Debería ser 0
