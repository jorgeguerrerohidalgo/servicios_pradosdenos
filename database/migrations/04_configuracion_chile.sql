-- =============================================
-- CONFIGURACIÓN ESPECÍFICA PARA CHILE
-- =============================================

-- Configurar zona horaria para Santiago de Chile
SET timezone = 'America/Santiago';

-- Función para formatear fechas en español chileno
CREATE OR REPLACE FUNCTION fecha_chilena(fecha TIMESTAMP WITH TIME ZONE)
RETURNS TEXT AS $$
BEGIN
    RETURN to_char(fecha AT TIME ZONE 'America/Santiago', 'DD "de" TMMonth "de" YYYY "a las" HH24:MI "hrs"');
END;
$$ LANGUAGE plpgsql;

-- Función para formatear moneda chilena
CREATE OR REPLACE FUNCTION formato_clp(monto DECIMAL)
RETURNS TEXT AS $$
BEGIN
    RETURN '$' || trim(to_char(monto, '999G999G999G999')) || ' CLP';
END;
$$ LANGUAGE plpgsql;

-- Agregar campos de costo a eventos (opcional)
ALTER TABLE eventos_vecinales 
ADD COLUMN IF NOT EXISTS costo_evento DECIMAL(12,0) DEFAULT 0,
ADD COLUMN IF NOT EXISTS moneda VARCHAR(3) DEFAULT 'CLP';

-- Agregar comentarios para contexto chileno
COMMENT ON COLUMN eventos_vecinales.costo_evento IS 'Costo del evento en pesos chilenos';
COMMENT ON COLUMN eventos_vecinales.moneda IS 'Moneda (CLP para pesos chilenos)';

-- Vista para eventos con formato chileno
CREATE OR REPLACE VIEW eventos_formato_chileno AS
SELECT 
    e.*,
    fecha_chilena(e.fecha_inicio) as fecha_inicio_chilena,
    fecha_chilena(e.fecha_fin) as fecha_fin_chilena,
    fecha_chilena(e.created_at) as fecha_creacion_chilena,
    CASE 
        WHEN e.costo_evento > 0 THEN formato_clp(e.costo_evento)
        ELSE 'Gratuito'
    END as costo_formateado,
    te.nombre as tipo_evento_nombre
FROM eventos_vecinales e
JOIN tipo_evento te ON e.tipo_evento_id = te.id;

-- Vista para documentos con formato chileno
CREATE OR REPLACE VIEW documentos_formato_chileno AS
SELECT 
    d.*,
    fecha_chilena(d.fecha_publicacion) as fecha_publicacion_chilena,
    fecha_chilena(d.fecha_vencimiento) as fecha_vencimiento_chilena,
    fecha_chilena(d.created_at) as fecha_creacion_chilena,
    td.nombre as tipo_documento_nombre
FROM documentos_comunitarios d
JOIN tipo_documento td ON d.tipo_documento_id = td.id;

-- Función para eventos próximos (considerando zona horaria chilena)
CREATE OR REPLACE FUNCTION eventos_proximos(dias INTEGER DEFAULT 30)
RETURNS TABLE(
    id UUID,
    titulo VARCHAR(200),
    descripcion TEXT,
    fecha_inicio_chilena TEXT,
    fecha_fin_chilena TEXT,
    tipo_evento VARCHAR(100),
    costo_formateado TEXT,
    dias_restantes INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id,
        e.titulo,
        e.descripcion,
        fecha_chilena(e.fecha_inicio) as fecha_inicio_chilena,
        fecha_chilena(e.fecha_fin) as fecha_fin_chilena,
        te.nombre as tipo_evento,
        CASE 
            WHEN e.costo_evento > 0 THEN formato_clp(e.costo_evento)
            ELSE 'Gratuito'
        END as costo_formateado,
        EXTRACT(DAY FROM (e.fecha_inicio - NOW()))::INTEGER as dias_restantes
    FROM eventos_vecinales e
    JOIN tipo_evento te ON e.tipo_evento_id = te.id
    WHERE e.visible = TRUE
    AND e.fecha_inicio > NOW()
    AND e.fecha_inicio <= NOW() + INTERVAL '1 day' * dias
    ORDER BY e.fecha_inicio ASC;
END;
$$ LANGUAGE plpgsql;

-- Insertar festivos chilenos comunes como eventos automáticos
INSERT INTO eventos_vecinales (
    titulo, descripcion, fecha_inicio, fecha_fin, 
    tipo_evento_id, visible, destacado, requiere_inscripcion, 
    creado_por, costo_evento, moneda
) VALUES 
(
    'Fiestas Patrias', 
    'Celebración de las Fiestas Patrias de Chile',
    '2024-09-18 00:00:00-03'::TIMESTAMP WITH TIME ZONE,
    '2024-09-19 23:59:59-03'::TIMESTAMP WITH TIME ZONE,
    (SELECT id FROM tipo_evento WHERE nombre = 'Actividad Recreativa'),
    TRUE, TRUE, FALSE,
    (SELECT id FROM usuarios LIMIT 1),
    0, 'CLP'
)
ON CONFLICT DO NOTHING;

-- Configurar formato de números para Chile
-- (esto se aplicará a nivel de sesión)
COMMENT ON SCHEMA public IS 'Configurado para Santiago de Chile - Zona horaria America/Santiago, moneda CLP';
