-- Script para añadir tabla de logs de seguridad
-- Ejecutar en la base de datos PostgreSQL

-- Tabla para logs de seguridad
CREATE TABLE IF NOT EXISTS security_logs (
  id SERIAL PRIMARY KEY,
  ip_address INET NOT NULL,
  event_type VARCHAR(50) NOT NULL,
  details JSONB,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_security_logs_ip ON security_logs(ip_address);
CREATE INDEX IF NOT EXISTS idx_security_logs_event_type ON security_logs(event_type);
CREATE INDEX IF NOT EXISTS idx_security_logs_created_at ON security_logs(created_at);

-- Comentarios para documentación
COMMENT ON TABLE security_logs IS 'Registro de eventos de seguridad del sistema';
COMMENT ON COLUMN security_logs.event_type IS 'Tipo de evento: LOGIN_SUCCESS, LOGIN_FAILED, RATE_LIMIT_EXCEEDED, UNAUTHORIZED_ACCESS, etc.';
COMMENT ON COLUMN security_logs.details IS 'Detalles adicionales del evento en formato JSON';

-- Función para limpiar logs antiguos automáticamente (opcional)
CREATE OR REPLACE FUNCTION clean_old_security_logs() RETURNS void AS $$
BEGIN
  DELETE FROM security_logs WHERE created_at < NOW() - INTERVAL '30 days';
END;
$$ LANGUAGE plpgsql;

-- Crear trigger para limpiar logs antiguos cada día (opcional)
-- Se puede ejecutar como tarea programada en lugar de trigger
-- CREATE EXTENSION IF NOT EXISTS pg_cron;
-- SELECT cron.schedule('clean-security-logs', '0 2 * * *', 'SELECT clean_old_security_logs();');
