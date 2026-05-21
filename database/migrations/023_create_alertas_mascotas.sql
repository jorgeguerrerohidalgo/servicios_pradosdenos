-- ========================================
-- MIGRACIÓN 023: Sistema de Alertas de Mascotas Comunitarias
-- ========================================
-- Descripción: 
--   - Tabla alertas_mascotas para registrar mascotas extraviadas y comportamiento agresivo
--   - Vista pública con alertas activas
--   - Funciones para gestión de alertas
-- Autor: Sistema
-- Fecha: 20/05/2026
-- Contexto: Los vecinos necesitan alertarse mutuamente sobre mascotas extraviadas
--           y mascotas con comportamiento agresivo para seguridad comunitaria
-- ========================================

SET timezone = 'America/Santiago';

-- =============================================
-- TABLA: alertas_mascotas
-- =============================================

CREATE TABLE IF NOT EXISTS alertas_mascotas (
    id SERIAL PRIMARY KEY,
    mascota_id INTEGER NOT NULL,
    tipo_alerta VARCHAR(20) NOT NULL CHECK (tipo_alerta IN ('extraviada', 'encontrada', 'agresiva', 'otra')),
    descripcion TEXT NOT NULL,
    ubicacion_referencia TEXT,  -- Dónde se vio por última vez / incidente
    fecha_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_fin TIMESTAMP,  -- NULL mientras esté activa, se llena al resolver
    activa BOOLEAN DEFAULT TRUE,
    reportado_por INTEGER,  -- Residente que reportó (puede ser admin)
    resuelto_por INTEGER,   -- Quien marcó como resuelta
    notas_resolucion TEXT,  -- Cómo se resolvió
    prioridad VARCHAR(10) CHECK (prioridad IN ('baja', 'media', 'alta')) DEFAULT 'media',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_mascota FOREIGN KEY (mascota_id) 
        REFERENCES mascotas(id) ON DELETE CASCADE,
    CONSTRAINT fk_reportado_por FOREIGN KEY (reportado_por) 
        REFERENCES residentes(id) ON DELETE SET NULL,
    CONSTRAINT fk_resuelto_por FOREIGN KEY (resuelto_por) 
        REFERENCES residentes(id) ON DELETE SET NULL,
    CONSTRAINT check_fecha_valida CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

-- Índices para rendimiento
CREATE INDEX IF NOT EXISTS idx_alertas_mascota_activa ON alertas_mascotas(mascota_id, activa);
CREATE INDEX IF NOT EXISTS idx_alertas_tipo_activa ON alertas_mascotas(tipo_alerta, activa);
CREATE INDEX IF NOT EXISTS idx_alertas_prioridad ON alertas_mascotas(prioridad, activa);
CREATE INDEX IF NOT EXISTS idx_alertas_fecha_inicio ON alertas_mascotas(fecha_inicio DESC);

-- Trigger para actualizar updated_at
CREATE OR REPLACE FUNCTION update_alertas_mascotas_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_alertas_mascotas_updated_at
    BEFORE UPDATE ON alertas_mascotas
    FOR EACH ROW
    EXECUTE FUNCTION update_alertas_mascotas_updated_at();

-- =============================================
-- VISTA: v_mascotas_publico_alertas
-- =============================================
-- Vista pública de mascotas con alertas activas para mostrar en frontend público

CREATE OR REPLACE VIEW v_mascotas_publico_alertas
WITH (security_invoker = true)
AS
SELECT 
    m.id as mascota_id,
    m.nombre as mascota_nombre,
    m.tipo,
    COALESCE(m.raza, 'Sin especificar') as raza,
    COALESCE(m.genero, 'Desconocido') as genero,
    COALESCE(m.color, 'Sin especificar') as color,
    COALESCE(m.foto_url, '') as foto_url,
    CASE 
        WHEN m.fecha_nacimiento IS NOT NULL THEN 
            EXTRACT(YEAR FROM AGE(CURRENT_DATE, m.fecha_nacimiento))::INTEGER
        ELSE NULL
    END as edad_anos,
    
    -- Información de ubicación
    p.id as plaza_id,
    p.nombre as plaza_nombre,
    c.numero_casa,
    c.direccion,
    
    -- Información del dueño (si existe)
    m.residente_id,
    CASE 
        WHEN m.residente_id IS NOT NULL THEN 
            CONCAT(r.nombre, ' ', r.apellido_paterno, ' ', COALESCE(r.apellido_materno, ''))
        ELSE 'Mascota Comunitaria'
    END as dueno_nombre,
    r.telefono as telefono_contacto,
    r.email as email_contacto,
    
    -- Información de alerta activa (si existe)
    a.id as alerta_id,
    a.tipo_alerta,
    a.descripcion as alerta_descripcion,
    a.ubicacion_referencia,
    a.fecha_inicio as alerta_desde,
    a.prioridad as alerta_prioridad,
    
    -- Calcular días desde la alerta
    CASE 
        WHEN a.fecha_inicio IS NOT NULL THEN
            EXTRACT(DAY FROM (CURRENT_TIMESTAMP - a.fecha_inicio))::INTEGER
        ELSE NULL
    END as dias_alerta,
    
    -- Información del reportante
    CASE 
        WHEN a.reportado_por IS NOT NULL THEN 
            CONCAT(rep.nombre, ' ', rep.apellido_paterno)
        ELSE 'Administrador'
    END as reportado_por_nombre,
    
    -- Estado de vacunas
    CASE 
        WHEN m.fecha_ultima_vacuna IS NULL THEN 'sin_info'
        WHEN (CURRENT_DATE - m.fecha_ultima_vacuna) > 365 THEN 'vencida'
        ELSE 'al_dia'
    END as estado_vacunas,
    
    m.observaciones,
    m.created_at as mascota_registrada_el
    
FROM mascotas m
INNER JOIN casas c ON m.casa_id = c.id
INNER JOIN plazas p ON c.plaza_id = p.id
LEFT JOIN residentes r ON m.residente_id = r.id
LEFT JOIN alertas_mascotas a ON m.id = a.mascota_id AND a.activa = TRUE
LEFT JOIN residentes rep ON a.reportado_por = rep.id
WHERE m.activo = TRUE;

COMMENT ON VIEW v_mascotas_publico_alertas IS 
'Vista pública de mascotas con alertas activas.
Incluye información de contacto y detalles de alerta para sistema comunitario.
SECURITY INVOKER para cumplir con Supabase Linter.';

-- =============================================
-- FUNCIONES: Gestión de Alertas
-- =============================================

-- Función: Obtener estadísticas de alertas activas
CREATE OR REPLACE FUNCTION get_estadisticas_alertas()
RETURNS TABLE (
    total_alertas_activas BIGINT,
    mascotas_extraviadas BIGINT,
    mascotas_con_alerta_agresiva BIGINT,
    alertas_alta_prioridad BIGINT,
    alertas_resueltas_hoy BIGINT,
    promedio_dias_resolucion NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) FILTER (WHERE activa = TRUE) as total_alertas_activas,
        COUNT(*) FILTER (WHERE activa = TRUE AND tipo_alerta = 'extraviada') as mascotas_extraviadas,
        COUNT(*) FILTER (WHERE activa = TRUE AND tipo_alerta = 'agresiva') as mascotas_con_alerta_agresiva,
        COUNT(*) FILTER (WHERE activa = TRUE AND prioridad = 'alta') as alertas_alta_prioridad,
        COUNT(*) FILTER (WHERE activa = FALSE AND DATE(fecha_fin) = CURRENT_DATE) as alertas_resueltas_hoy,
        ROUND(AVG(EXTRACT(EPOCH FROM (fecha_fin - fecha_inicio)) / 86400), 1) 
            FILTER (WHERE fecha_fin IS NOT NULL) as promedio_dias_resolucion
    FROM alertas_mascotas;
END;
$$ LANGUAGE plpgsql;

-- Función: Obtener historial de alertas de una mascota
CREATE OR REPLACE FUNCTION get_historial_alertas_mascota(p_mascota_id INTEGER)
RETURNS TABLE (
    alerta_id INTEGER,
    tipo_alerta VARCHAR,
    descripcion TEXT,
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    dias_duracion INTEGER,
    reportado_por VARCHAR,
    resuelto_por VARCHAR,
    notas_resolucion TEXT,
    prioridad VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id as alerta_id,
        a.tipo_alerta,
        a.descripcion,
        a.fecha_inicio,
        a.fecha_fin,
        CASE 
            WHEN a.fecha_fin IS NOT NULL THEN
                EXTRACT(DAY FROM (a.fecha_fin - a.fecha_inicio))::INTEGER
            ELSE
                EXTRACT(DAY FROM (CURRENT_TIMESTAMP - a.fecha_inicio))::INTEGER
        END as dias_duracion,
        CASE 
            WHEN a.reportado_por IS NOT NULL THEN 
                CONCAT(r1.nombre, ' ', r1.apellido_paterno)
            ELSE 'Administrador'
        END as reportado_por,
        CASE 
            WHEN a.resuelto_por IS NOT NULL THEN 
                CONCAT(r2.nombre, ' ', r2.apellido_paterno)
            ELSE NULL
        END as resuelto_por,
        a.notas_resolucion,
        a.prioridad
    FROM alertas_mascotas a
    LEFT JOIN residentes r1 ON a.reportado_por = r1.id
    LEFT JOIN residentes r2 ON a.resuelto_por = r2.id
    WHERE a.mascota_id = p_mascota_id
    ORDER BY a.fecha_inicio DESC;
END;
$$ LANGUAGE plpgsql;

-- Función: Resolver alerta (marcar como inactiva)
CREATE OR REPLACE FUNCTION resolver_alerta(
    p_alerta_id INTEGER,
    p_resuelto_por INTEGER,
    p_notas_resolucion TEXT
)
RETURNS TABLE (
    success BOOLEAN,
    message TEXT
) AS $$
DECLARE
    v_alerta_existe BOOLEAN;
BEGIN
    -- Verificar que la alerta existe y está activa
    SELECT EXISTS(
        SELECT 1 FROM alertas_mascotas 
        WHERE id = p_alerta_id AND activa = TRUE
    ) INTO v_alerta_existe;
    
    IF NOT v_alerta_existe THEN
        RETURN QUERY SELECT FALSE, 'Alerta no encontrada o ya resuelta'::TEXT;
        RETURN;
    END IF;
    
    -- Actualizar alerta
    UPDATE alertas_mascotas SET
        activa = FALSE,
        fecha_fin = CURRENT_TIMESTAMP,
        resuelto_por = p_resuelto_por,
        notas_resolucion = p_notas_resolucion
    WHERE id = p_alerta_id;
    
    RETURN QUERY SELECT TRUE, 'Alerta resuelta correctamente'::TEXT;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- COMENTARIOS EN TABLAS
-- =============================================

COMMENT ON TABLE alertas_mascotas IS 'Registro de alertas comunitarias sobre mascotas (extraviadas, agresivas, etc.)';
COMMENT ON COLUMN alertas_mascotas.tipo_alerta IS 'Tipo: extraviada, encontrada, agresiva, otra';
COMMENT ON COLUMN alertas_mascotas.activa IS 'TRUE = alerta vigente, FALSE = resuelta';
COMMENT ON COLUMN alertas_mascotas.prioridad IS 'Nivel de urgencia: baja, media, alta';
COMMENT ON COLUMN alertas_mascotas.ubicacion_referencia IS 'Lugar del último avistamiento o incidente';
COMMENT ON COLUMN alertas_mascotas.fecha_fin IS 'Fecha en que se resolvió la alerta (NULL si activa)';

COMMENT ON FUNCTION get_estadisticas_alertas IS 'Retorna estadísticas de alertas activas y resueltas';
COMMENT ON FUNCTION get_historial_alertas_mascota IS 'Retorna historial completo de alertas de una mascota';
COMMENT ON FUNCTION resolver_alerta IS 'Marca una alerta como resuelta con notas y responsable';

-- =============================================
-- DATOS DE EJEMPLO (Opcional - Comentar en producción)
-- =============================================

-- Ejemplo de alerta de mascota extraviada
-- INSERT INTO alertas_mascotas (mascota_id, tipo_alerta, descripcion, ubicacion_referencia, prioridad, reportado_por)
-- VALUES (
--     1,
--     'extraviada',
--     'Max no regresó a casa desde ayer en la tarde. Es muy amigable y responde a su nombre. Tiene collar azul con placa de identificación.',
--     'Última vez visto cerca del parque infantil de Plaza Los Robles',
--     'alta',
--     1
-- );

-- Ejemplo de alerta de comportamiento agresivo
-- INSERT INTO alertas_mascotas (mascota_id, tipo_alerta, descripcion, ubicacion_referencia, prioridad)
-- VALUES (
--     2,
--     'agresiva',
--     'Perro mostró comportamiento agresivo con niños el día de hoy. Gruñidos y intento de mordida. Se recomienda precaución.',
--     'Área común frente a Casa 15',
--     'alta'
-- );

-- =============================================
-- VERIFICACIÓN
-- =============================================

SELECT 'Migración 023 ejecutada correctamente' AS resultado;

-- Verificar tabla creada
SELECT COUNT(*) || ' alertas registradas' AS estado FROM alertas_mascotas;

-- Verificar vista
SELECT COUNT(*) || ' mascotas en vista pública' AS vista_publica FROM v_mascotas_publico_alertas;

-- Verificar funciones
SELECT * FROM get_estadisticas_alertas();

-- =============================================
-- FIN DE MIGRACIÓN 023
-- =============================================
