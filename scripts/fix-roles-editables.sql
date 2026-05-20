-- ========================================
-- FIX: Habilitar Edición de Roles
-- ========================================
-- Fecha: 20/05/2026
-- Problema: 75 checkboxes deshabilitados (todos los roles tienen es_sistema=true)
-- Solución: Marcar como editables los roles que NO son super críticos

-- ANTES: Ver estado actual
SELECT 
    'ANTES DEL FIX' as momento,
    nombre,
    es_sistema,
    CASE WHEN es_sistema = true THEN '🔒 BLOQUEADO' ELSE '✏️ EDITABLE' END as estado
FROM roles 
ORDER BY nivel_prioridad DESC;

-- APLICAR FIX: Solo Super Usuario y Administrador deben ser es_sistema=true
UPDATE roles 
SET es_sistema = false 
WHERE nombre IN ('Delegado de Plaza', 'Supervisor', 'Guardia');

-- DESPUÉS: Verificar corrección
SELECT 
    'DESPUÉS DEL FIX' as momento,
    nombre,
    es_sistema,
    CASE WHEN es_sistema = true THEN '🔒 BLOQUEADO' ELSE '✏️ EDITABLE' END as estado
FROM roles 
ORDER BY nivel_prioridad DESC;

-- Resumen final
SELECT 
    '=== RESULTADO ===' as titulo,
    COUNT(*) as total_roles,
    COUNT(*) FILTER (WHERE es_sistema = true) as bloqueados,
    COUNT(*) FILTER (WHERE es_sistema = false) as editables_ahora
FROM roles;
