-- ========================================
-- MIGRACIÓN 009: Agregar estado calculado en tiempo real a v_pagos_completo
-- ========================================
-- Descripción: Actualizar vista para mostrar estado real considerando fecha_vencimiento
-- Autor: Sistema
-- Fecha: 19/05/2026
-- ========================================

SET timezone = 'America/Santiago';

-- Eliminar vista anterior (tiene estructura diferente)
DROP VIEW IF EXISTS v_pagos_completo;

-- Crear vista v_pagos_completo con estado calculado
CREATE VIEW v_pagos_completo AS
SELECT 
  p.id,
  p.casa_id,
  c.numero_casa,
  c.direccion as casa_direccion,
  c.plaza_id,
  pl.nombre as plaza_nombre,
  p.periodo,
  EXTRACT(YEAR FROM TO_DATE(p.periodo || '-01', 'YYYY-MM-DD'))::INTEGER as anio,
  EXTRACT(MONTH FROM TO_DATE(p.periodo || '-01', 'YYYY-MM-DD'))::INTEGER as mes,
  p.tipo_pago,
  p.monto,
  p.estado as estado_almacenado,  -- Estado original de la tabla
  -- ESTADO CALCULADO EN TIEMPO REAL
  CASE 
    WHEN p.estado = 'pagado' THEN 'pagado'
    WHEN p.estado = 'anulado' THEN 'anulado'
    WHEN p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE THEN 'vencido'
    WHEN p.estado = 'vencido' THEN 'vencido'
    ELSE 'pendiente'
  END as estado,
  p.fecha_vencimiento,
  CASE 
    WHEN (p.estado = 'pendiente' OR p.estado = 'vencido') AND p.fecha_vencimiento < CURRENT_DATE THEN 
      (CURRENT_DATE - p.fecha_vencimiento)::INTEGER
    ELSE 0
  END as dias_vencido,
  p.fecha_pago,
  p.metodo_pago,
  p.numero_comprobante,
  p.observaciones,
  p.activo,
  p.created_at,
  p.updated_at
FROM pagos p
INNER JOIN casas c ON p.casa_id = c.id
INNER JOIN plazas pl ON c.plaza_id = pl.id;

COMMENT ON VIEW v_pagos_completo IS 
'Vista completa de pagos con información de casa y plaza.
CAMBIO 19/05/2026: Campo "estado" ahora se calcula en tiempo real considerando fecha_vencimiento.
Campo "estado_almacenado" contiene el valor original de la tabla pagos.';

-- Verificar el cambio
SELECT 'Migración 009 ejecutada correctamente' as resultado;
SELECT 
    COUNT(*) FILTER (WHERE estado = 'vencido') as total_vencidos_calculado,
    COUNT(*) FILTER (WHERE estado_almacenado = 'vencido') as total_vencidos_tabla
FROM v_pagos_completo
WHERE activo = TRUE;
