-- ========================================
-- MIGRACIÓN 004: Módulo PAGOS
-- ========================================
-- Descripción: Tabla para gestionar pagos de cuota social y junta de vecinos
-- Autor: Sistema
-- Fecha: 14/05/2026
-- Dependencias: Requiere tabla 'casas' (001)
-- ========================================

-- Configurar zona horaria para Santiago de Chile
SET timezone = 'America/Santiago';

-- Tabla de pagos
CREATE TABLE IF NOT EXISTS pagos (
  id SERIAL PRIMARY KEY,
  casa_id INTEGER NOT NULL,
  periodo VARCHAR(7) NOT NULL, -- Formato: YYYY-MM (ej: 2026-05)
  tipo_pago VARCHAR(20) NOT NULL CHECK (tipo_pago IN ('cuota_social', 'junta_vecinos')),
  monto DECIMAL(10,2) NOT NULL CHECK (monto >= 0),
  estado VARCHAR(20) NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'pagado', 'vencido', 'anulado')),
  fecha_vencimiento DATE NOT NULL,
  fecha_pago TIMESTAMPTZ,
  metodo_pago VARCHAR(30) CHECK (metodo_pago IN ('efectivo', 'transferencia', 'cheque', 'tarjeta', 'webpay', 'otro')),
  numero_comprobante VARCHAR(100),
  observaciones TEXT,
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (casa_id) REFERENCES casas(id) ON DELETE CASCADE,
  CONSTRAINT check_fecha_pago_valida CHECK (fecha_pago IS NULL OR fecha_pago <= CURRENT_TIMESTAMP),
  CONSTRAINT check_periodo_valido CHECK (periodo ~ '^\d{4}-(0[1-9]|1[0-2])$')
);

-- Índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_pagos_casa_id ON pagos(casa_id);
CREATE INDEX IF NOT EXISTS idx_pagos_periodo ON pagos(periodo);
CREATE INDEX IF NOT EXISTS idx_pagos_estado ON pagos(estado);
CREATE INDEX IF NOT EXISTS idx_pagos_tipo_pago ON pagos(tipo_pago);
CREATE INDEX IF NOT EXISTS idx_pagos_casa_periodo ON pagos(casa_id, periodo);
CREATE INDEX IF NOT EXISTS idx_pagos_casa_estado ON pagos(casa_id, estado);
CREATE INDEX IF NOT EXISTS idx_pagos_fecha_vencimiento ON pagos(fecha_vencimiento);
CREATE INDEX IF NOT EXISTS idx_pagos_activo ON pagos(activo);

-- Constraint único: Una casa no puede tener dos pagos del mismo tipo en el mismo período
CREATE UNIQUE INDEX IF NOT EXISTS idx_pagos_unico_periodo 
ON pagos(casa_id, periodo, tipo_pago) 
WHERE activo = TRUE;

-- Trigger para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_pagos_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_pagos_updated_at
  BEFORE UPDATE ON pagos
  FOR EACH ROW
  EXECUTE FUNCTION update_pagos_updated_at();

-- Trigger para actualizar estado a 'vencido' automáticamente
CREATE OR REPLACE FUNCTION actualizar_estado_pagos_vencidos()
RETURNS TRIGGER AS $$
BEGIN
  -- Solo actualizar si el estado es 'pendiente' y la fecha de vencimiento ya pasó
  IF NEW.estado = 'pendiente' AND NEW.fecha_vencimiento < CURRENT_DATE THEN
    NEW.estado := 'vencido';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_estado_vencido
  BEFORE INSERT OR UPDATE ON pagos
  FOR EACH ROW
  EXECUTE FUNCTION actualizar_estado_pagos_vencidos();

-- Vista completa: pagos con información de casa y plaza
CREATE OR REPLACE VIEW v_pagos_completo AS
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
  p.estado,
  p.fecha_vencimiento,
  CASE 
    WHEN p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE THEN 
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

-- Función: Obtener morosidad por casa
CREATE OR REPLACE FUNCTION get_morosidad_casa(p_casa_id INTEGER)
RETURNS TABLE (
  casa_id INTEGER,
  numero_casa VARCHAR,
  total_deuda DECIMAL,
  pagos_vencidos BIGINT,
  meses_moroso INTEGER,
  estado_morosidad VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    c.id as casa_id,
    c.numero_casa,
    COALESCE(SUM(p.monto) FILTER (WHERE p.estado IN ('pendiente', 'vencido')), 0) as total_deuda,
    COUNT(*) FILTER (WHERE p.estado = 'vencido') as pagos_vencidos,
    COUNT(DISTINCT p.periodo) FILTER (WHERE p.estado = 'vencido')::INTEGER as meses_moroso,
    CASE 
      WHEN COUNT(*) FILTER (WHERE p.estado = 'vencido') = 0 THEN 'al_dia'
      WHEN COUNT(*) FILTER (WHERE p.estado = 'vencido') <= 2 THEN 'mora_leve'
      WHEN COUNT(*) FILTER (WHERE p.estado = 'vencido') <= 5 THEN 'mora_moderada'
      ELSE 'mora_grave'
    END as estado_morosidad
  FROM casas c
  LEFT JOIN pagos p ON c.id = p.casa_id AND p.activo = TRUE
  WHERE c.id = p_casa_id
    AND c.activo = TRUE
  GROUP BY c.id, c.numero_casa;
END;
$$ LANGUAGE plpgsql;

-- Función: Obtener estadísticas de pagos por período
CREATE OR REPLACE FUNCTION get_estadisticas_pagos_periodo(p_periodo VARCHAR DEFAULT NULL)
RETURNS TABLE (
  periodo VARCHAR,
  total_pagos BIGINT,
  monto_total DECIMAL,
  pagos_pendientes BIGINT,
  monto_pendiente DECIMAL,
  pagos_pagados BIGINT,
  monto_pagado DECIMAL,
  pagos_vencidos BIGINT,
  monto_vencido DECIMAL,
  tasa_cumplimiento NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.periodo,
    COUNT(*) as total_pagos,
    COALESCE(SUM(p.monto), 0) as monto_total,
    COUNT(*) FILTER (WHERE p.estado = 'pendiente') as pagos_pendientes,
    COALESCE(SUM(p.monto) FILTER (WHERE p.estado = 'pendiente'), 0) as monto_pendiente,
    COUNT(*) FILTER (WHERE p.estado = 'pagado') as pagos_pagados,
    COALESCE(SUM(p.monto) FILTER (WHERE p.estado = 'pagado'), 0) as monto_pagado,
    COUNT(*) FILTER (WHERE p.estado = 'vencido') as pagos_vencidos,
    COALESCE(SUM(p.monto) FILTER (WHERE p.estado = 'vencido'), 0) as monto_vencido,
    ROUND(
      CASE 
        WHEN COUNT(*) > 0 THEN 
          (COUNT(*) FILTER (WHERE p.estado = 'pagado')::NUMERIC / COUNT(*)::NUMERIC * 100)
        ELSE 0
      END, 
      2
    ) as tasa_cumplimiento
  FROM pagos p
  WHERE p.activo = TRUE
    AND (p_periodo IS NULL OR p.periodo = p_periodo)
  GROUP BY p.periodo
  ORDER BY p.periodo DESC;
END;
$$ LANGUAGE plpgsql;

-- Función: Obtener historial de pagos de una casa
CREATE OR REPLACE FUNCTION get_historial_pagos_casa(
  p_casa_id INTEGER,
  p_limite INTEGER DEFAULT 12
)
RETURNS TABLE (
  pago_id INTEGER,
  periodo VARCHAR,
  tipo_pago VARCHAR,
  monto DECIMAL,
  estado VARCHAR,
  fecha_vencimiento DATE,
  fecha_pago TIMESTAMPTZ,
  metodo_pago VARCHAR,
  dias_vencido INTEGER
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id as pago_id,
    p.periodo,
    p.tipo_pago,
    p.monto,
    p.estado,
    p.fecha_vencimiento,
    p.fecha_pago,
    p.metodo_pago,
    CASE 
      WHEN p.estado = 'vencido' THEN (CURRENT_DATE - p.fecha_vencimiento)::INTEGER
      ELSE 0
    END as dias_vencido
  FROM pagos p
  WHERE p.casa_id = p_casa_id
    AND p.activo = TRUE
  ORDER BY p.periodo DESC, p.tipo_pago
  LIMIT p_limite;
END;
$$ LANGUAGE plpgsql;

-- Función: Generar pagos automáticos para un período
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
  -- Si no se proporciona fecha de vencimiento, usar el último día del mes
  IF p_fecha_vencimiento IS NULL THEN
    v_fecha_vencimiento := (DATE_TRUNC('MONTH', TO_DATE(p_periodo || '-01', 'YYYY-MM-DD')) + INTERVAL '1 MONTH - 1 DAY')::DATE;
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
          CASE 
            WHEN v_fecha_vencimiento < CURRENT_DATE THEN 'vencido'
            ELSE 'pendiente'
          END
        );
        v_pagos_generados := v_pagos_generados + 1;
      EXCEPTION
        WHEN unique_violation THEN
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
          CASE 
            WHEN v_fecha_vencimiento < CURRENT_DATE THEN 'vencido'
            ELSE 'pendiente'
          END
        );
        v_pagos_generados := v_pagos_generados + 1;
      EXCEPTION
        WHEN unique_violation THEN
          v_pagos_saltados := v_pagos_saltados + 1;
      END;
    END IF;
  END LOOP;
  
  RETURN QUERY SELECT v_casas_procesadas, v_pagos_generados, v_pagos_saltados;
END;
$$ LANGUAGE plpgsql;

-- Función: Registrar pago
CREATE OR REPLACE FUNCTION registrar_pago(
  p_pago_id INTEGER,
  p_metodo_pago VARCHAR,
  p_numero_comprobante VARCHAR DEFAULT NULL,
  p_fecha_pago TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
)
RETURNS TABLE (
  success BOOLEAN,
  message VARCHAR
) AS $$
BEGIN
  -- Actualizar el pago
  UPDATE pagos 
  SET 
    estado = 'pagado',
    fecha_pago = p_fecha_pago,
    metodo_pago = p_metodo_pago,
    numero_comprobante = p_numero_comprobante
  WHERE id = p_pago_id
    AND estado IN ('pendiente', 'vencido')
    AND activo = TRUE;
  
  IF FOUND THEN
    RETURN QUERY SELECT TRUE, 'Pago registrado correctamente'::VARCHAR;
  ELSE
    RETURN QUERY SELECT FALSE, 'Pago no encontrado o ya está pagado'::VARCHAR;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Comentarios en tablas y columnas
COMMENT ON TABLE pagos IS 'Registro de pagos de cuota social y junta de vecinos por casa';
COMMENT ON COLUMN pagos.casa_id IS 'Casa que debe realizar el pago (ON DELETE CASCADE)';
COMMENT ON COLUMN pagos.periodo IS 'Período del pago en formato YYYY-MM (ej: 2026-05)';
COMMENT ON COLUMN pagos.tipo_pago IS 'Tipo de pago: cuota_social o junta_vecinos';
COMMENT ON COLUMN pagos.monto IS 'Monto a pagar en pesos chilenos';
COMMENT ON COLUMN pagos.estado IS 'Estado del pago: pendiente, pagado, vencido, anulado';
COMMENT ON COLUMN pagos.fecha_vencimiento IS 'Fecha límite de pago';
COMMENT ON COLUMN pagos.fecha_pago IS 'Fecha en que se realizó el pago (NULL si no está pagado)';
COMMENT ON COLUMN pagos.metodo_pago IS 'Método de pago: efectivo, transferencia, cheque, tarjeta, webpay, otro';
COMMENT ON COLUMN pagos.numero_comprobante IS 'Número de comprobante o boleta';
COMMENT ON COLUMN pagos.activo IS 'Indica si el pago está activo en el sistema (soft delete)';

COMMENT ON VIEW v_pagos_completo IS 'Vista completa de pagos con información de casa y plaza';
COMMENT ON FUNCTION get_morosidad_casa IS 'Retorna información de morosidad de una casa específica';
COMMENT ON FUNCTION get_estadisticas_pagos_periodo IS 'Retorna estadísticas de pagos por período';
COMMENT ON FUNCTION get_historial_pagos_casa IS 'Retorna historial de pagos de una casa';
COMMENT ON FUNCTION generar_pagos_periodo IS 'Genera pagos automáticamente para todas las casas activas en un período';
COMMENT ON FUNCTION registrar_pago IS 'Registra el pago de una obligación pendiente o vencida';

-- Verificación
SELECT 'Migración 004_create_pagos.sql ejecutada correctamente' AS resultado;
SELECT COUNT(*) || ' pagos registrados' AS estado FROM pagos;
