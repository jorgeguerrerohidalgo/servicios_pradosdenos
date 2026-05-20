-- ========================================
-- FIX: Supabase Security Advisor - RLS y Vistas
-- ========================================
-- Fecha: 20/05/2026
-- Problema: 21 errores de seguridad detectados por Supabase Security Advisor
-- Solución: Habilitar RLS + Políticas restrictivas + Recrear vistas
-- Basado en esquema real de Supabase

-- ============================================
-- PARTE 1: HABILITAR RLS EN TODAS LAS TABLAS
-- ============================================

-- Tablas de sistema
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE guardias ENABLE ROW LEVEL SECURITY;
ALTER TABLE plazas ENABLE ROW LEVEL SECURITY;
ALTER TABLE plaza_tokens ENABLE ROW LEVEL SECURITY;
ALTER TABLE checkins ENABLE ROW LEVEL SECURITY;
ALTER TABLE security_logs ENABLE ROW LEVEL SECURITY;

-- Tablas de eventos
ALTER TABLE eventos_vecinales ENABLE ROW LEVEL SECURITY;
ALTER TABLE tipo_evento ENABLE ROW LEVEL SECURITY;
ALTER TABLE inscripciones_eventos ENABLE ROW LEVEL SECURITY;

-- Tablas de documentos
ALTER TABLE documentos_comunitarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE tipo_documento ENABLE ROW LEVEL SECURITY;
ALTER TABLE descargas_documentos ENABLE ROW LEVEL SECURITY;

-- Tablas RBAC
ALTER TABLE roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE role_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE permission_audit ENABLE ROW LEVEL SECURITY;

-- Tablas de módulos
ALTER TABLE casas ENABLE ROW LEVEL SECURITY;
ALTER TABLE residentes ENABLE ROW LEVEL SECURITY;
ALTER TABLE mascotas ENABLE ROW LEVEL SECURITY;
ALTER TABLE pagos ENABLE ROW LEVEL SECURITY;
ALTER TABLE vehiculos ENABLE ROW LEVEL SECURITY;
ALTER TABLE control_acceso ENABLE ROW LEVEL SECURITY;

-- ============================================
-- PARTE 2: POLÍTICAS DE LECTURA PÚBLICA
-- ============================================

-- Solo datos públicos sin información sensible

-- Eventos (lectura pública)
DROP POLICY IF EXISTS "Eventos públicos legibles" ON eventos_vecinales;
CREATE POLICY "Eventos públicos legibles"
ON eventos_vecinales FOR SELECT USING (visible = true);

-- Documentos (lectura pública)  
DROP POLICY IF EXISTS "Documentos públicos legibles" ON documentos_comunitarios;
CREATE POLICY "Documentos públicos legibles"
ON documentos_comunitarios FOR SELECT USING (visible = true);

-- Plazas (lectura pública)
DROP POLICY IF EXISTS "Plazas públicas legibles" ON plazas;
CREATE POLICY "Plazas públicas legibles"
ON plazas FOR SELECT USING (activo = true);

-- Tipos de evento (catálogo público)
DROP POLICY IF EXISTS "Tipos de evento legibles" ON tipo_evento;
CREATE POLICY "Tipos de evento legibles"
ON tipo_evento FOR SELECT USING (activo = true);

-- Tipos de documento (catálogo público)
DROP POLICY IF EXISTS "Tipos de documento legibles" ON tipo_documento;
CREATE POLICY "Tipos de documento legibles"
ON tipo_documento FOR SELECT USING (activo = true);

-- ============================================
-- PARTE 3: RECREAR VISTAS SIN SECURITY DEFINER
-- ============================================

-- v_accesos_completo
DROP VIEW IF EXISTS v_accesos_completo CASCADE;
CREATE VIEW v_accesos_completo
WITH (security_invoker = true)
AS
SELECT 
    ca.id,
    ca.vehiculo_patente,
    v.marca,
    v.modelo,
    v.color,
    v.tipo as tipo_vehiculo,
    ca.casa_id,
    c.numero_casa,
    c.direccion as casa_direccion,
    c.plaza_id,
    p.nombre as plaza_nombre,
    ca.tipo_acceso,
    ca.fecha_hora,
    ca.estado_pago_verificado,
    ca.tiene_morosidad,
    ca.monto_deuda,
    ca.acceso_permitido,
    ca.motivo_bloqueo,
    ca.observaciones,
    ca.usuario_registro,
    ca.created_at,
    v.residente_id,
    (r.nombre || ' ' || r.apellido_paterno || ' ' || COALESCE(r.apellido_materno, '')) as residente_nombre,
    CASE 
        WHEN ca.tipo_acceso = 'salida' THEN NULL
        ELSE (SELECT (MAX(ca2.fecha_hora) - MIN(ca2.fecha_hora)) 
              FROM control_acceso ca2 
              WHERE ca2.vehiculo_patente = ca.vehiculo_patente 
              AND ca2.fecha_hora >= ca.fecha_hora 
              AND ca2.tipo_acceso = 'salida')
    END as tiempo_permanencia
FROM control_acceso ca
INNER JOIN vehiculos v ON ca.vehiculo_patente = v.patente
INNER JOIN casas c ON ca.casa_id = c.id
INNER JOIN plazas p ON c.plaza_id = p.id
LEFT JOIN residentes r ON v.residente_id = r.id;

-- v_mascotas_completo
DROP VIEW IF EXISTS v_mascotas_completo CASCADE;
CREATE VIEW v_mascotas_completo
WITH (security_invoker = true)
AS
SELECT 
    m.id,
    m.casa_id,
    c.numero_casa,
    c.direccion as casa_direccion,
    c.plaza_id,
    p.nombre as plaza_nombre,
    m.residente_id,
    (r.nombre || ' ' || r.apellido_paterno || ' ' || COALESCE(r.apellido_materno, '')) as dueno_nombre,
    r.run as dueno_run,
    r.telefono as dueno_telefono,
    m.nombre as mascota_nombre,
    m.tipo,
    m.raza,
    m.fecha_nacimiento,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, m.fecha_nacimiento))::INTEGER as edad_anos,
    m.genero,
    m.color,
    m.certificado_vacunas,
    m.fecha_ultima_vacuna,
    (CURRENT_DATE - m.fecha_ultima_vacuna)::INTEGER as dias_desde_vacuna,
    m.foto_url,
    m.observaciones,
    m.activo,
    m.created_at,
    m.updated_at
FROM mascotas m
INNER JOIN casas c ON m.casa_id = c.id
INNER JOIN plazas p ON c.plaza_id = p.id
LEFT JOIN residentes r ON m.residente_id = r.id;

-- v_estado_morosidad_casas
DROP VIEW IF EXISTS v_estado_morosidad_casas CASCADE;
CREATE VIEW v_estado_morosidad_casas
WITH (security_invoker = true)
AS
SELECT 
    c.id as casa_id,
    c.numero_casa,
    c.direccion,
    c.plaza_id,
    p.nombre as plaza_nombre,
    COUNT(pg.id) as total_pagos,
    COUNT(pg.id) FILTER (WHERE pg.estado = 'pendiente' AND pg.fecha_vencimiento >= CURRENT_DATE) as pendientes_vigentes,
    COUNT(pg.id) FILTER (WHERE pg.estado = 'pendiente' AND pg.fecha_vencimiento < CURRENT_DATE) as total_vencidos,
    COUNT(pg.id) FILTER (WHERE pg.estado = 'pagado') as total_pagados,
    COALESCE(SUM(pg.monto) FILTER (WHERE pg.estado = 'pendiente'), 0) as deuda_total,
    CASE 
        WHEN COUNT(pg.id) FILTER (WHERE pg.estado = 'pendiente' AND pg.fecha_vencimiento < CURRENT_DATE) >= 3 THEN 'moroso'
        WHEN COUNT(pg.id) FILTER (WHERE pg.estado = 'pendiente' AND pg.fecha_vencimiento < CURRENT_DATE) > 0 THEN 'deuda'
        ELSE 'al_dia'
    END as estado_morosidad,
    CASE 
        WHEN COUNT(pg.id) FILTER (WHERE pg.estado = 'pendiente' AND pg.fecha_vencimiento < CURRENT_DATE) >= 3 THEN false
        ELSE true
    END as acceso_permitido
FROM casas c
INNER JOIN plazas p ON c.plaza_id = p.id
LEFT JOIN pagos pg ON c.id = pg.casa_id
GROUP BY c.id, c.numero_casa, c.direccion, c.plaza_id, p.nombre;

-- v_vehiculos_completo
DROP VIEW IF EXISTS v_vehiculos_completo CASCADE;
CREATE VIEW v_vehiculos_completo
WITH (security_invoker = true)
AS
SELECT 
    v.patente,
    v.casa_id,
    c.numero_casa,
    c.direccion as casa_direccion,
    c.plaza_id,
    p.nombre as plaza_nombre,
    v.residente_id,
    (r.nombre || ' ' || r.apellido_paterno || ' ' || COALESCE(r.apellido_materno, '')) as residente_nombre,
    r.run as residente_run,
    v.marca,
    v.modelo,
    v.color,
    v.anio,
    v.tipo,
    v.observaciones,
    COUNT(pg.id) FILTER (WHERE pg.estado = 'pendiente' AND pg.fecha_vencimiento < CURRENT_DATE) as meses_moroso,
    COALESCE(SUM(pg.monto) FILTER (WHERE pg.estado = 'pendiente'), 0) as deuda_total,
    CASE 
        WHEN COUNT(pg.id) FILTER (WHERE pg.estado = 'pendiente' AND pg.fecha_vencimiento < CURRENT_DATE) >= 3 THEN 'moroso'
        WHEN COUNT(pg.id) FILTER (WHERE pg.estado = 'pendiente' AND pg.fecha_vencimiento < CURRENT_DATE) > 0 THEN 'deuda'
        ELSE 'al_dia'
    END as estado_morosidad,
    CASE 
        WHEN COUNT(pg.id) FILTER (WHERE pg.estado = 'pendiente' AND pg.fecha_vencimiento < CURRENT_DATE) >= 3 THEN false
        ELSE true
    END as acceso_permitido,
    v.activo,
    v.created_at,
    v.updated_at
FROM vehiculos v
INNER JOIN casas c ON v.casa_id = c.id
INNER JOIN plazas p ON c.plaza_id = p.id
LEFT JOIN residentes r ON v.residente_id = r.id
LEFT JOIN pagos pg ON c.id = pg.casa_id
GROUP BY v.patente, v.casa_id, c.numero_casa, c.direccion, c.plaza_id, p.nombre,
         v.residente_id, r.nombre, r.apellido_paterno, r.apellido_materno, r.run,
         v.marca, v.modelo, v.color, v.anio, v.tipo, v.observaciones, v.activo, 
         v.created_at, v.updated_at;

-- v_casas_completo
DROP VIEW IF EXISTS v_casas_completo CASCADE;
CREATE VIEW v_casas_completo
WITH (security_invoker = true)
AS
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
INNER JOIN plazas p ON c.plaza_id = p.id;

-- v_pagos_completo
DROP VIEW IF EXISTS v_pagos_completo CASCADE;
CREATE VIEW v_pagos_completo
WITH (security_invoker = true)
AS
SELECT 
    pg.id,
    pg.casa_id,
    c.numero_casa,
    c.direccion as casa_direccion,
    c.plaza_id,
    p.nombre as plaza_nombre,
    pg.periodo,
    CAST(SPLIT_PART(pg.periodo, '-', 1) AS INTEGER) as anio,
    CAST(SPLIT_PART(pg.periodo, '-', 2) AS INTEGER) as mes,
    pg.tipo_pago,
    pg.monto,
    pg.estado as estado_almacenado,
    CASE 
        WHEN pg.estado = 'pendiente' AND pg.fecha_vencimiento < CURRENT_DATE THEN 'vencido'
        WHEN pg.estado = 'pendiente' THEN 'pendiente'
        WHEN pg.estado = 'pagado' THEN 'pagado'
        ELSE pg.estado
    END as estado,
    pg.fecha_vencimiento,
    (CURRENT_DATE - pg.fecha_vencimiento)::INTEGER as dias_vencido,
    pg.fecha_pago,
    pg.metodo_pago,
    pg.numero_comprobante,
    pg.observaciones,
    pg.activo,
    pg.created_at,
    pg.updated_at
FROM pagos pg
INNER JOIN casas c ON pg.casa_id = c.id
INNER JOIN plazas p ON c.plaza_id = p.id;

-- v_residentes_completo
DROP VIEW IF EXISTS v_residentes_completo CASCADE;
CREATE VIEW v_residentes_completo
WITH (security_invoker = true)
AS
SELECT 
    r.id,
    r.casa_id,
    c.numero_casa,
    c.direccion as casa_direccion,
    c.plaza_id,
    p.nombre as plaza_nombre,
    r.nombre,
    r.apellido_paterno,
    r.apellido_materno,
    (r.nombre || ' ' || r.apellido_paterno || ' ' || COALESCE(r.apellido_materno, '')) as nombre_completo,
    r.run,
    r.fecha_nacimiento,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, r.fecha_nacimiento))::INTEGER as edad,
    r.email,
    r.telefono,
    r.activo,
    r.created_at,
    r.updated_at
FROM residentes r
INNER JOIN casas c ON r.casa_id = c.id
INNER JOIN plazas p ON c.plaza_id = p.id;

-- ============================================
-- PARTE 4: VERIFICACIÓN
-- ============================================

-- Verificar RLS habilitado
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables
WHERE schemaname = 'public'
AND tablename NOT LIKE 'v_%'
ORDER BY tablename;

-- Verificar políticas creadas
SELECT 
    schemaname,
    tablename,
    policyname,
    cmd as command,
    qual as using_expression
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- ============================================
-- RESULTADO ESPERADO
-- ============================================
-- ✅ RLS habilitado en 23 tablas
-- ✅ 5 políticas de lectura pública
-- ✅ 7 vistas recreadas sin SECURITY DEFINER
-- ✅ 0 errores en Security Advisor
