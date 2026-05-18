-- =================================================================
-- INSTRUCCIONES PARA EJECUTAR ESTA MIGRACIÓN
-- =================================================================
-- 1. Abrir Supabase Dashboard: https://supabase.com/dashboard
-- 2. Ir a SQL Editor
-- 3. Copiar y pegar TODO este script
-- 4. Ejecutar (botón Run o Ctrl+Enter)
-- 5. Verificar que no haya errores
-- 6. Recargar la aplicación web con Ctrl+Shift+R
-- =================================================================

-- Ejecutar migración 007: Corrección de lógica de morosidad
\i '007_fix_morosidad_logic.sql'

-- Si el comando anterior falla, copiar manualmente el contenido de 007_fix_morosidad_logic.sql

-- =================================================================
-- VERIFICACIÓN MANUAL (ejecutar después de la migración)
-- =================================================================

-- Ver vehículos por casa sin pagos
SELECT 
    v.patente,
    v.numero_casa,
    v.estado_morosidad,
    v.acceso_permitido,
    (SELECT COUNT(*) FROM pagos WHERE casa_id = v.casa_id AND activo = TRUE) as total_pagos_registrados,
    v.pagos_vencidos,
    v.deuda_total
FROM v_vehiculos_completo v
WHERE v.estado_morosidad IN ('sin_pagos', 'mora_leve', 'mora_moderada', 'mora_grave')
ORDER BY v.estado_morosidad DESC, v.numero_casa;

-- Verificar el vehículo KCLR36 (casa 4977)
SELECT 
    v.*,
    (SELECT COUNT(*) FROM pagos WHERE casa_id = v.casa_id AND activo = TRUE) as total_pagos
FROM v_vehiculos_completo v
WHERE v.patente = 'KCLR36';

-- Ver casas sin ningún pago registrado
SELECT 
    c.id,
    c.numero_casa,
    c.direccion,
    COUNT(p.id) as total_pagos
FROM casas c
LEFT JOIN pagos p ON c.casa_id = p.casa_id AND p.activo = TRUE
WHERE c.activo = TRUE
GROUP BY c.id, c.numero_casa, c.direccion
HAVING COUNT(p.id) = 0
ORDER BY c.numero_casa;
