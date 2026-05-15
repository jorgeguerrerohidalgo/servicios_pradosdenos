-- =============================================
-- MIGRACIÓN 005: FASE 5 - VEHÍCULOS Y CONTROL DE ACCESO
-- =============================================
-- Descripción: Sistema completo de registro vehicular y control de acceso
--              basado en estado de pagos (morosidad)
-- Dependencias: Requiere migraciones 001 (casas), 002 (residentes), 004 (pagos)
-- Fecha: Mayo 2026
-- =============================================

-- Configurar zona horaria
SET timezone = 'America/Santiago';

-- =============================================
-- TABLA: vehiculos
-- =============================================
-- Almacena información de vehículos asociados a casas/residentes
CREATE TABLE IF NOT EXISTS vehiculos (
    patente VARCHAR(10) PRIMARY KEY, -- Patente única (ej: ABCD12, AA1234)
    casa_id INTEGER NOT NULL,
    residente_id INTEGER, -- Opcional: propietario específico del vehículo
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    color VARCHAR(30),
    anio INTEGER CHECK (anio >= 1900 AND anio <= EXTRACT(YEAR FROM CURRENT_DATE) + 1),
    tipo VARCHAR(20) NOT NULL DEFAULT 'automovil' CHECK (tipo IN ('automovil', 'camioneta', 'motocicleta', 'bicicleta', 'otro')),
    observaciones TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_vehiculo_casa FOREIGN KEY (casa_id) 
        REFERENCES casas(id) ON DELETE CASCADE,
    CONSTRAINT fk_vehiculo_residente FOREIGN KEY (residente_id) 
        REFERENCES residentes(id) ON DELETE SET NULL
);

-- Índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_vehiculos_casa ON vehiculos(casa_id);
CREATE INDEX IF NOT EXISTS idx_vehiculos_residente ON vehiculos(residente_id);
CREATE INDEX IF NOT EXISTS idx_vehiculos_activo ON vehiculos(activo);
CREATE INDEX IF NOT EXISTS idx_vehiculos_tipo ON vehiculos(tipo);

-- Trigger para actualizar updated_at
CREATE OR REPLACE FUNCTION update_vehiculos_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_vehiculos_updated_at
    BEFORE UPDATE ON vehiculos
    FOR EACH ROW
    EXECUTE FUNCTION update_vehiculos_updated_at();

-- =============================================
-- TABLA: control_acceso
-- =============================================
-- Registra entradas/salidas de vehículos con verificación de estado de pago
CREATE TABLE IF NOT EXISTS control_acceso (
    id SERIAL PRIMARY KEY,
    vehiculo_patente VARCHAR(10) NOT NULL,
    casa_id INTEGER NOT NULL,
    tipo_acceso VARCHAR(10) NOT NULL CHECK (tipo_acceso IN ('entrada', 'salida')),
    fecha_hora TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    -- Verificación de morosidad al momento del acceso
    estado_pago_verificado BOOLEAN DEFAULT FALSE, -- ¿Se verificó el estado de pago?
    tiene_morosidad BOOLEAN DEFAULT FALSE, -- ¿La casa tiene pagos vencidos?
    monto_deuda DECIMAL(10,2) DEFAULT 0, -- Deuda total al momento del acceso
    acceso_permitido BOOLEAN DEFAULT TRUE, -- Resultado final: ¿se permitió el acceso?
    motivo_bloqueo VARCHAR(200), -- Razón si se bloqueó (ej: "Casa con 3 meses de morosidad")
    
    -- Información adicional
    observaciones TEXT,
    usuario_registro VARCHAR(100), -- Guardia que registró el acceso
    
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_acceso_vehiculo FOREIGN KEY (vehiculo_patente) 
        REFERENCES vehiculos(patente) ON DELETE CASCADE,
    CONSTRAINT fk_acceso_casa FOREIGN KEY (casa_id) 
        REFERENCES casas(id) ON DELETE CASCADE
);

-- Índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_acceso_vehiculo ON control_acceso(vehiculo_patente);
CREATE INDEX IF NOT EXISTS idx_acceso_casa ON control_acceso(casa_id);
CREATE INDEX IF NOT EXISTS idx_acceso_fecha ON control_acceso(fecha_hora DESC);
CREATE INDEX IF NOT EXISTS idx_acceso_tipo ON control_acceso(tipo_acceso);
CREATE INDEX IF NOT EXISTS idx_acceso_permitido ON control_acceso(acceso_permitido);
CREATE INDEX IF NOT EXISTS idx_acceso_morosidad ON control_acceso(tiene_morosidad);

-- =============================================
-- VISTA: v_vehiculos_completo
-- =============================================
-- Vista completa con información de casas, residentes y estado de pago
CREATE OR REPLACE VIEW v_vehiculos_completo AS
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
    
    -- Estado de morosidad de la casa (crítico para control de acceso)
    (
        SELECT COUNT(*) 
        FROM pagos p 
        WHERE p.casa_id = v.casa_id 
        AND p.estado = 'vencido' 
        AND p.activo = TRUE
    ) as pagos_vencidos,
    (
        SELECT COALESCE(SUM(p.monto), 0)
        FROM pagos p 
        WHERE p.casa_id = v.casa_id 
        AND p.estado = 'vencido' 
        AND p.activo = TRUE
    ) as deuda_total,
    CASE 
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.estado = 'vencido' 
            AND p.activo = TRUE
        ) = 0 THEN 'al_dia'
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.estado = 'vencido' 
            AND p.activo = TRUE
        ) <= 2 THEN 'mora_leve'
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.estado = 'vencido' 
            AND p.activo = TRUE
        ) <= 5 THEN 'mora_moderada'
        ELSE 'mora_grave'
    END as estado_morosidad,
    
    -- Control de acceso: ¿Debe bloquearse?
    CASE 
        WHEN (
            SELECT COUNT(*) 
            FROM pagos p 
            WHERE p.casa_id = v.casa_id 
            AND p.estado = 'vencido' 
            AND p.activo = TRUE
        ) >= 3 THEN FALSE -- Bloquear si tiene 3+ meses vencidos
        ELSE TRUE
    END as acceso_permitido,
    
    v.activo,
    v.created_at,
    v.updated_at
FROM vehiculos v
INNER JOIN casas c ON v.casa_id = c.id
INNER JOIN plazas pl ON c.plaza_id = pl.id
LEFT JOIN residentes r ON v.residente_id = r.id;

-- =============================================
-- VISTA: v_accesos_completo
-- =============================================
-- Vista completa de accesos con información contextual
CREATE OR REPLACE VIEW v_accesos_completo AS
SELECT 
    a.id,
    a.vehiculo_patente,
    v.marca,
    v.modelo,
    v.color,
    v.tipo as tipo_vehiculo,
    a.casa_id,
    c.numero_casa,
    c.direccion as casa_direccion,
    c.plaza_id,
    pl.nombre as plaza_nombre,
    a.tipo_acceso,
    a.fecha_hora,
    a.estado_pago_verificado,
    a.tiene_morosidad,
    a.monto_deuda,
    a.acceso_permitido,
    a.motivo_bloqueo,
    a.observaciones,
    a.usuario_registro,
    a.created_at,
    
    -- Información adicional del vehículo
    v.residente_id,
    CASE 
        WHEN v.residente_id IS NOT NULL THEN 
            r.nombre || ' ' || r.apellido_paterno || COALESCE(' ' || r.apellido_materno, '')
        ELSE 'Sin residente asignado'
    END as residente_nombre,
    
    -- Calcular tiempo de permanencia (solo si hay entrada y salida)
    CASE 
        WHEN a.tipo_acceso = 'salida' THEN
            (
                SELECT (a.fecha_hora - MAX(a2.fecha_hora))
                FROM control_acceso a2
                WHERE a2.vehiculo_patente = a.vehiculo_patente
                AND a2.tipo_acceso = 'entrada'
                AND a2.fecha_hora < a.fecha_hora
                AND a2.activo = TRUE
            )
        ELSE NULL
    END as tiempo_permanencia
    
FROM control_acceso a
INNER JOIN vehiculos v ON a.vehiculo_patente = v.patente
INNER JOIN casas c ON a.casa_id = c.id
INNER JOIN plazas pl ON c.plaza_id = pl.id
LEFT JOIN residentes r ON v.residente_id = r.id
WHERE a.activo = TRUE;

-- =============================================
-- FUNCIÓN: verificar_acceso_vehiculo
-- =============================================
-- Verifica si un vehículo puede acceder según estado de pago de su casa
-- RETORNA: JSON con {permitido: boolean, morosidad: boolean, deuda: decimal, motivo: text}
CREATE OR REPLACE FUNCTION verificar_acceso_vehiculo(p_patente VARCHAR)
RETURNS JSON AS $$
DECLARE
    v_casa_id INTEGER;
    v_pagos_vencidos INTEGER;
    v_deuda_total DECIMAL(10,2);
    v_permitido BOOLEAN;
    v_motivo TEXT;
BEGIN
    -- Obtener casa_id del vehículo
    SELECT casa_id INTO v_casa_id
    FROM vehiculos
    WHERE patente = p_patente AND activo = TRUE;
    
    IF v_casa_id IS NULL THEN
        RETURN json_build_object(
            'permitido', FALSE,
            'morosidad', FALSE,
            'deuda', 0,
            'motivo', 'Vehículo no encontrado o inactivo'
        );
    END IF;
    
    -- Obtener morosidad usando función existente
    SELECT 
        total_vencidos,
        deuda_pendiente
    INTO v_pagos_vencidos, v_deuda_total
    FROM get_morosidad_casa(v_casa_id);
    
    -- Política de acceso: bloquear si tiene 3+ meses vencidos
    IF v_pagos_vencidos >= 3 THEN
        v_permitido := FALSE;
        v_motivo := 'Casa con ' || v_pagos_vencidos || ' meses de morosidad. Deuda: $' || v_deuda_total;
    ELSE
        v_permitido := TRUE;
        v_motivo := CASE 
            WHEN v_pagos_vencidos > 0 THEN 'Acceso permitido con ' || v_pagos_vencidos || ' mes(es) vencido(s)'
            ELSE 'Acceso permitido. Casa al día'
        END;
    END IF;
    
    RETURN json_build_object(
        'permitido', v_permitido,
        'morosidad', v_pagos_vencidos > 0,
        'deuda', COALESCE(v_deuda_total, 0),
        'motivo', v_motivo,
        'pagos_vencidos', v_pagos_vencidos
    );
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- FUNCIÓN: registrar_acceso_vehiculo
-- =============================================
-- Registra entrada/salida con verificación automática de morosidad
-- RETORNA: ID del registro creado
CREATE OR REPLACE FUNCTION registrar_acceso_vehiculo(
    p_patente VARCHAR,
    p_tipo_acceso VARCHAR,
    p_usuario VARCHAR DEFAULT 'Sistema',
    p_observaciones TEXT DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
    v_casa_id INTEGER;
    v_verificacion JSON;
    v_permitido BOOLEAN;
    v_tiene_morosidad BOOLEAN;
    v_deuda DECIMAL(10,2);
    v_motivo TEXT;
    v_acceso_id INTEGER;
BEGIN
    -- Obtener casa_id del vehículo
    SELECT casa_id INTO v_casa_id
    FROM vehiculos
    WHERE patente = p_patente AND activo = TRUE;
    
    IF v_casa_id IS NULL THEN
        RAISE EXCEPTION 'Vehículo no encontrado o inactivo: %', p_patente;
    END IF;
    
    -- Verificar estado de acceso
    v_verificacion := verificar_acceso_vehiculo(p_patente);
    v_permitido := (v_verificacion->>'permitido')::BOOLEAN;
    v_tiene_morosidad := (v_verificacion->>'morosidad')::BOOLEAN;
    v_deuda := (v_verificacion->>'deuda')::DECIMAL;
    v_motivo := v_verificacion->>'motivo';
    
    -- Insertar registro de acceso
    INSERT INTO control_acceso (
        vehiculo_patente,
        casa_id,
        tipo_acceso,
        estado_pago_verificado,
        tiene_morosidad,
        monto_deuda,
        acceso_permitido,
        motivo_bloqueo,
        observaciones,
        usuario_registro
    ) VALUES (
        p_patente,
        v_casa_id,
        p_tipo_acceso,
        TRUE,
        v_tiene_morosidad,
        v_deuda,
        v_permitido,
        CASE WHEN NOT v_permitido THEN v_motivo ELSE NULL END,
        p_observaciones,
        p_usuario
    )
    RETURNING id INTO v_acceso_id;
    
    RETURN v_acceso_id;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- FUNCIÓN: get_accesos_recientes
-- =============================================
-- Retorna los últimos accesos registrados
CREATE OR REPLACE FUNCTION get_accesos_recientes(p_limite INTEGER DEFAULT 50)
RETURNS TABLE (
    id INTEGER,
    patente VARCHAR,
    marca VARCHAR,
    modelo VARCHAR,
    numero_casa VARCHAR,
    tipo_acceso VARCHAR,
    fecha_hora TIMESTAMPTZ,
    acceso_permitido BOOLEAN,
    tiene_morosidad BOOLEAN,
    usuario_registro VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id,
        a.vehiculo_patente,
        a.marca,
        a.modelo,
        a.numero_casa,
        a.tipo_acceso,
        a.fecha_hora,
        a.acceso_permitido,
        a.tiene_morosidad,
        a.usuario_registro
    FROM v_accesos_completo a
    ORDER BY a.fecha_hora DESC
    LIMIT p_limite;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- FUNCIÓN: get_accesos_por_vehiculo
-- =============================================
-- Historial completo de accesos de un vehículo específico
CREATE OR REPLACE FUNCTION get_accesos_por_vehiculo(
    p_patente VARCHAR,
    p_limite INTEGER DEFAULT 100
)
RETURNS TABLE (
    id INTEGER,
    tipo_acceso VARCHAR,
    fecha_hora TIMESTAMPTZ,
    acceso_permitido BOOLEAN,
    tiene_morosidad BOOLEAN,
    monto_deuda DECIMAL,
    motivo_bloqueo VARCHAR,
    usuario_registro VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id,
        a.tipo_acceso,
        a.fecha_hora,
        a.acceso_permitido,
        a.tiene_morosidad,
        a.monto_deuda,
        a.motivo_bloqueo,
        a.usuario_registro
    FROM control_acceso a
    WHERE a.vehiculo_patente = p_patente
    AND a.activo = TRUE
    ORDER BY a.fecha_hora DESC
    LIMIT p_limite;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- FUNCIÓN: get_estadisticas_accesos
-- =============================================
-- Estadísticas de accesos en un rango de fechas
CREATE OR REPLACE FUNCTION get_estadisticas_accesos(
    p_fecha_desde TIMESTAMPTZ,
    p_fecha_hasta TIMESTAMPTZ
)
RETURNS JSON AS $$
DECLARE
    v_total_accesos INTEGER;
    v_total_entradas INTEGER;
    v_total_salidas INTEGER;
    v_accesos_bloqueados INTEGER;
    v_vehiculos_unicos INTEGER;
    v_casas_con_morosidad INTEGER;
BEGIN
    SELECT 
        COUNT(*),
        COUNT(*) FILTER (WHERE tipo_acceso = 'entrada'),
        COUNT(*) FILTER (WHERE tipo_acceso = 'salida'),
        COUNT(*) FILTER (WHERE NOT acceso_permitido),
        COUNT(DISTINCT vehiculo_patente),
        COUNT(DISTINCT casa_id) FILTER (WHERE tiene_morosidad)
    INTO 
        v_total_accesos,
        v_total_entradas,
        v_total_salidas,
        v_accesos_bloqueados,
        v_vehiculos_unicos,
        v_casas_con_morosidad
    FROM control_acceso
    WHERE fecha_hora BETWEEN p_fecha_desde AND p_fecha_hasta
    AND activo = TRUE;
    
    RETURN json_build_object(
        'periodo', json_build_object(
            'desde', p_fecha_desde,
            'hasta', p_fecha_hasta
        ),
        'total_accesos', COALESCE(v_total_accesos, 0),
        'total_entradas', COALESCE(v_total_entradas, 0),
        'total_salidas', COALESCE(v_total_salidas, 0),
        'accesos_bloqueados', COALESCE(v_accesos_bloqueados, 0),
        'vehiculos_unicos', COALESCE(v_vehiculos_unicos, 0),
        'casas_con_morosidad', COALESCE(v_casas_con_morosidad, 0),
        'tasa_bloqueo', CASE 
            WHEN v_total_accesos > 0 THEN 
                ROUND((v_accesos_bloqueados::DECIMAL / v_total_accesos) * 100, 2)
            ELSE 0
        END
    );
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- FUNCIÓN: get_vehiculos_bloqueados
-- =============================================
-- Lista de vehículos activos cuyas casas tienen morosidad que bloquea acceso
CREATE OR REPLACE FUNCTION get_vehiculos_bloqueados()
RETURNS TABLE (
    patente VARCHAR,
    marca VARCHAR,
    modelo VARCHAR,
    numero_casa VARCHAR,
    residente_nombre TEXT,
    pagos_vencidos BIGINT,
    deuda_total NUMERIC,
    estado_morosidad TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.patente,
        v.marca,
        v.modelo,
        v.numero_casa,
        v.residente_nombre,
        v.pagos_vencidos,
        v.deuda_total,
        v.estado_morosidad
    FROM v_vehiculos_completo v
    WHERE v.activo = TRUE
    AND v.acceso_permitido = FALSE
    ORDER BY v.pagos_vencidos DESC, v.deuda_total DESC;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- COMENTARIOS EN TABLAS
-- =============================================
COMMENT ON TABLE vehiculos IS 'Registro de vehículos asociados a casas y residentes';
COMMENT ON COLUMN vehiculos.patente IS 'Patente única del vehículo (PK)';
COMMENT ON COLUMN vehiculos.casa_id IS 'Casa a la que pertenece el vehículo (obligatorio)';
COMMENT ON COLUMN vehiculos.residente_id IS 'Residente propietario del vehículo (opcional)';
COMMENT ON COLUMN vehiculos.tipo IS 'Tipo: automovil, camioneta, motocicleta, bicicleta, otro';

COMMENT ON TABLE control_acceso IS 'Registro de entradas/salidas con verificación automática de morosidad';
COMMENT ON COLUMN control_acceso.estado_pago_verificado IS 'Indica si se verificó el estado de pago al momento del acceso';
COMMENT ON COLUMN control_acceso.tiene_morosidad IS 'Indica si la casa tenía pagos vencidos al momento del acceso';
COMMENT ON COLUMN control_acceso.acceso_permitido IS 'Resultado final: TRUE=permitido, FALSE=bloqueado por morosidad';
COMMENT ON COLUMN control_acceso.motivo_bloqueo IS 'Razón del bloqueo si acceso_permitido=FALSE';

-- =============================================
-- DATOS DE EJEMPLO (OPCIONAL - COMENTAR EN PRODUCCIÓN)
-- =============================================
/*
-- Ejemplo: Insertar vehículo de prueba
INSERT INTO vehiculos (patente, casa_id, marca, modelo, color, anio, tipo)
VALUES ('AA1234', 1, 'Toyota', 'Corolla', 'Gris', 2020, 'automovil');

-- Ejemplo: Registrar acceso con verificación automática
SELECT registrar_acceso_vehiculo('AA1234', 'entrada', 'Juan Pérez', 'Ingreso normal');

-- Ejemplo: Verificar estado de acceso de un vehículo
SELECT verificar_acceso_vehiculo('AA1234');

-- Ejemplo: Ver vehículos bloqueados por morosidad
SELECT * FROM get_vehiculos_bloqueados();

-- Ejemplo: Estadísticas de los últimos 30 días
SELECT get_estadisticas_accesos(
    CURRENT_TIMESTAMP - INTERVAL '30 days',
    CURRENT_TIMESTAMP
);
*/

-- =============================================
-- FIN DE MIGRACIÓN 005
-- =============================================
