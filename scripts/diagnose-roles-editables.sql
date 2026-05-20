-- ========================================
-- Diagnóstico: Roles del Sistema
-- ========================================
-- Fecha: 20/05/2026
-- Problema: No puedo editar checkboxes en "Módulos Visibles"
-- Causa posible: Todos los roles tienen es_sistema=true

-- Ver configuración actual de roles
SELECT 
    id,
    nombre,
    es_sistema,
    nivel_prioridad,
    editable,
    eliminable,
    CASE 
        WHEN es_sistema = true THEN '🔒 DESHABILITADO en UI'
        ELSE '✏️ EDITABLE en UI'
    END as estado_ui
FROM roles 
ORDER BY nivel_prioridad DESC;

-- Resumen
SELECT 
    '=== RESUMEN ===' as titulo,
    COUNT(*) as total_roles,
    COUNT(*) FILTER (WHERE es_sistema = true) as roles_sistema_bloqueados,
    COUNT(*) FILTER (WHERE es_sistema = false) as roles_editables
FROM roles;

-- SOLUCIÓN: Si todos tienen es_sistema=true, ejecutar lo siguiente:
-- (Descomenta las líneas de abajo si necesitas aplicar el fix)

/*
-- Marcar como editables los roles que NO son Super Usuario ni Administrador
UPDATE roles 
SET es_sistema = false 
WHERE nombre IN ('Delegado de Plaza', 'Supervisor', 'Guardia');

-- Verificar cambios
SELECT nombre, es_sistema FROM roles ORDER BY nivel_prioridad DESC;
*/
