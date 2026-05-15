-- ========================================
-- MIGRACIÓN 001: Módulo CASAS
-- ========================================
-- Descripción: Tabla para gestionar las casas del condominio Los Prados de Nos
-- Autor: Sistema
-- Fecha: 14/05/2026
-- Dependencias: Requiere tabla 'plazas' existente
-- ========================================

-- Configurar zona horaria para Santiago de Chile
SET timezone = 'America/Santiago';

-- Tabla de casas del condominio
CREATE TABLE IF NOT EXISTS casas (
  id SERIAL PRIMARY KEY,
  numero_casa VARCHAR(20) NOT NULL UNIQUE,
  direccion VARCHAR(255) NOT NULL,
  plaza_id INTEGER NOT NULL,
  monto_cuota_social DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  monto_junta_vecinos DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  metros_cuadrados DECIMAL(10, 2),
  observaciones TEXT,
  activo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (plaza_id) REFERENCES plazas(id) ON DELETE RESTRICT,
  CONSTRAINT check_montos_positivos CHECK (monto_cuota_social >= 0 AND monto_junta_vecinos >= 0),
  CONSTRAINT check_metros_positivos CHECK (metros_cuadrados IS NULL OR metros_cuadrados > 0)
);

-- Índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_casas_plaza_id ON casas(plaza_id);
CREATE INDEX IF NOT EXISTS idx_casas_numero_casa ON casas(numero_casa);
CREATE INDEX IF NOT EXISTS idx_casas_activo ON casas(activo);
CREATE INDEX IF NOT EXISTS idx_casas_plaza_activo ON casas(plaza_id, activo);

-- Trigger para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_casas_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_casas_updated_at
  BEFORE UPDATE ON casas
  FOR EACH ROW
  EXECUTE FUNCTION update_casas_updated_at();

-- Vista para consultas completas (casa + plaza)
CREATE OR REPLACE VIEW v_casas_completo AS
SELECT 
  c.id,
  c.numero_casa,
  c.direccion,
  c.plaza_id,
  p.nombre as plaza_nombre,
  c.monto_cuota_social,
  c.monto_junta_vecinos,
  (c.monto_cuota_social + c.monto_junta_vecinos) as monto_total_mensual,
  c.metros_cuadrados,
  c.observaciones,
  c.activo,
  c.created_at,
  c.updated_at
FROM casas c
LEFT JOIN plazas p ON c.plaza_id = p.id;

-- Comentarios en tablas y columnas
COMMENT ON TABLE casas IS 'Registro de casas del condominio Los Prados de Nos';
COMMENT ON COLUMN casas.numero_casa IS 'Número identificador único de la casa (ej: 101, A-23, Casa 5)';
COMMENT ON COLUMN casas.direccion IS 'Dirección completa de la casa';
COMMENT ON COLUMN casas.plaza_id IS 'Referencia a la plaza asociada (punto de check-in cercano)';
COMMENT ON COLUMN casas.monto_cuota_social IS 'Monto mensual de cuota social en pesos chilenos';
COMMENT ON COLUMN casas.monto_junta_vecinos IS 'Monto mensual de junta de vecinos en pesos chilenos';
COMMENT ON COLUMN casas.metros_cuadrados IS 'Superficie de la casa en metros cuadrados';
COMMENT ON COLUMN casas.activo IS 'Indica si la casa está activa en el sistema (soft delete)';

-- Datos de ejemplo (opcional - comentar si no se requiere)
-- INSERT INTO casas (numero_casa, direccion, plaza_id, monto_cuota_social, monto_junta_vecinos, metros_cuadrados)
-- VALUES 
--   ('001', 'Calle La Coruña #123', 1, 25000.00, 5000.00, 120.50),
--   ('002', 'Calle La Coruña #125', 1, 25000.00, 5000.00, 115.00),
--   ('003', 'Avenida Valencia #456', 2, 30000.00, 5000.00, 145.75)
-- ON CONFLICT (numero_casa) DO NOTHING;

-- Verificación
SELECT 'Migración 001_create_casas.sql ejecutada correctamente' AS resultado;
SELECT COUNT(*) || ' casas registradas' AS estado FROM casas;
