-- ========================================
-- FIX: Function Search Path Mutable
-- ========================================
-- Fecha: 20/05/2026
-- Problema: 31 funciones sin search_path fijo (vulnerables a search_path injection)
-- Solución: Agregar SET search_path = public, pg_catalog a todas las funciones

-- ============================================
-- PARTE 1: FUNCIONES DE SEGURIDAD Y LOGS
-- ============================================

-- Función de limpieza de logs
DO $$
DECLARE
    func_oid OID;
BEGIN
    SELECT oid INTO func_oid 
    FROM pg_proc 
    WHERE proname = 'clean_old_security_logs' AND pronamespace = 'public'::regnamespace;
    
    IF func_oid IS NOT NULL THEN
        EXECUTE format('ALTER FUNCTION %s SET search_path = public, pg_catalog', func_oid::regprocedure);
    END IF;
END $$;

-- ============================================
-- PARTE 2: FUNCIONES DE ACTUALIZACIÓN (TRIGGERS)
-- ============================================

DO $$
DECLARE
    func_names TEXT[] := ARRAY[
        'update_pagos_updated_at',
        'update_updated_at_column',
        'update_vehiculos_updated_at',
        'update_casas_updated_at',
        'update_residentes_updated_at',
        'update_mascotas_updated_at',
        'update_user_roles_timestamp'
    ];
    func_name TEXT;
    func_oid OID;
BEGIN
    FOREACH func_name IN ARRAY func_names
    LOOP
        SELECT oid INTO func_oid 
        FROM pg_proc 
        WHERE proname = func_name AND pronamespace = 'public'::regnamespace;
        
        IF func_oid IS NOT NULL THEN
            EXECUTE format('ALTER FUNCTION %s SET search_path = public, pg_catalog', func_oid::regprocedure);
            RAISE NOTICE 'Fixed: %', func_name;
        END IF;
    END LOOP;
END $$;

-- ============================================
-- PARTE 3: FUNCIONES DE NEGOCIO (PAGOS)
-- ============================================

DO $$
DECLARE
    func_names TEXT[] := ARRAY[
        'actualizar_estado_pagos_vencidos',
        'actualizar_estados_pagos',
        'registrar_pago',
        'generar_pagos_periodo',
        'get_morosidad_casa',
        'get_estadisticas_pagos_periodo',
        'get_historial_pagos_casa'
    ];
    func_name TEXT;
    func_oid OID;
BEGIN
    FOREACH func_name IN ARRAY func_names
    LOOP
        SELECT oid INTO func_oid 
        FROM pg_proc 
        WHERE proname = func_name AND pronamespace = 'public'::regnamespace;
        
        IF func_oid IS NOT NULL THEN
            EXECUTE format('ALTER FUNCTION %s SET search_path = public, pg_catalog', func_oid::regprocedure);
            RAISE NOTICE 'Fixed: %', func_name;
        END IF;
    END LOOP;
END $$;

-- ============================================
-- PARTE 4: FUNCIONES DE EVENTOS Y DOCUMENTOS
-- ============================================

DO $$
DECLARE
    func_names TEXT[] := ARRAY[
        'limpiar_eventos_antiguos',
        'estadisticas_eventos',
        'estadisticas_documentos',
        'registrar_descarga_google_drive'
    ];
    func_name TEXT;
    func_oid OID;
BEGIN
    FOREACH func_name IN ARRAY func_names
    LOOP
        SELECT oid INTO func_oid 
        FROM pg_proc 
        WHERE proname = func_name AND pronamespace = 'public'::regnamespace;
        
        IF func_oid IS NOT NULL THEN
            EXECUTE format('ALTER FUNCTION %s SET search_path = public, pg_catalog', func_oid::regprocedure);
            RAISE NOTICE 'Fixed: %', func_name;
        END IF;
    END LOOP;
END $$;

-- ============================================
-- PARTE 5: FUNCIONES DE RESIDENTES Y MASCOTAS
-- ============================================

DO $$
DECLARE
    func_names TEXT[] := ARRAY[
        'validar_rut_chileno',
        'get_estadisticas_residentes',
        'get_estadisticas_mascotas',
        'get_mascotas_por_casa',
        'get_mascotas_vacunas_vencidas'
    ];
    func_name TEXT;
    func_oid OID;
BEGIN
    FOREACH func_name IN ARRAY func_names
    LOOP
        SELECT oid INTO func_oid 
        FROM pg_proc 
        WHERE proname = func_name AND pronamespace = 'public'::regnamespace;
        
        IF func_oid IS NOT NULL THEN
            EXECUTE format('ALTER FUNCTION %s SET search_path = public, pg_catalog', func_oid::regprocedure);
            RAISE NOTICE 'Fixed: %', func_name;
        END IF;
    END LOOP;
END $$;

-- ============================================
-- PARTE 6: FUNCIONES DE CONTROL DE ACCESO
-- ============================================

DO $$
DECLARE
    func_names TEXT[] := ARRAY[
        'get_vehiculos_bloqueados',
        'verificar_acceso_vehiculo',
        'registrar_acceso_vehiculo',
        'get_accesos_recientes',
        'get_accesos_por_vehiculo',
        'get_estadisticas_accesos'
    ];
    func_name TEXT;
    func_oid OID;
BEGIN
    FOREACH func_name IN ARRAY func_names
    LOOP
        SELECT oid INTO func_oid 
        FROM pg_proc 
        WHERE proname = func_name AND pronamespace = 'public'::regnamespace;
        
        IF func_oid IS NOT NULL THEN
            EXECUTE format('ALTER FUNCTION %s SET search_path = public, pg_catalog', func_oid::regprocedure);
            RAISE NOTICE 'Fixed: %', func_name;
        END IF;
    END LOOP;
END $$;

-- ============================================
-- PARTE 7: VERIFICACIÓN
-- ============================================

-- Ver funciones con search_path configurado
SELECT 
    p.proname as function_name,
    pg_get_function_arguments(p.oid) as arguments,
    CASE 
        WHEN p.proconfig IS NOT NULL THEN 'SET'
        ELSE 'NOT SET'
    END as search_path_status,
    p.proconfig as config
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
AND p.proname IN (
    'clean_old_security_logs',
    'update_pagos_updated_at',
    'update_updated_at_column',
    'actualizar_estado_pagos_vencidos',
    'limpiar_eventos_antiguos',
    'estadisticas_eventos',
    'estadisticas_documentos',
    'update_vehiculos_updated_at',
    'get_vehiculos_bloqueados',
    'update_user_roles_timestamp',
    'registrar_descarga_google_drive',
    'update_casas_updated_at',
    'update_residentes_updated_at',
    'validar_rut_chileno',
    'get_estadisticas_residentes',
    'update_mascotas_updated_at',
    'get_estadisticas_mascotas',
    'get_mascotas_por_casa',
    'get_mascotas_vacunas_vencidas',
    'get_morosidad_casa',
    'get_estadisticas_pagos_periodo',
    'get_historial_pagos_casa',
    'verificar_acceso_vehiculo',
    'registrar_acceso_vehiculo',
    'get_accesos_recientes',
    'get_accesos_por_vehiculo',
    'get_estadisticas_accesos',
    'actualizar_estados_pagos',
    'registrar_pago',
    'generar_pagos_periodo'
)
ORDER BY p.proname;

-- ============================================
-- RESULTADO ESPERADO
-- ============================================
-- ✅ 31 funciones con search_path = public, pg_catalog
-- ✅ 0 warnings de "Function Search Path Mutable"
