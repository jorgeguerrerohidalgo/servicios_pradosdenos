-- =====================================================
-- Migración 026: Limpiar símbolo "#" de direcciones
-- =====================================================
-- Descripción: Elimina el carácter "#" de todas las direcciones
--              en la tabla casas para mantener consistencia
--              en el formato de datos.
-- 
-- Fecha: 2026-05-24
-- Autor: Sistema
-- =====================================================

-- Permitir transacciones
BEGIN;

-- Actualizar todas las direcciones que contengan "#"
-- Reemplazar "#" por " " (espacio) para mantener legibilidad
UPDATE casas 
SET direccion = REPLACE(direccion, '#', ' ')
WHERE direccion LIKE '%#%';

-- Opcional: Limpiar espacios múltiples que puedan quedar
UPDATE casas
SET direccion = REGEXP_REPLACE(direccion, '\s+', ' ', 'g')
WHERE direccion ~ '\s{2,}';

-- Opcional: Limpiar espacios al inicio y final
UPDATE casas
SET direccion = TRIM(direccion)
WHERE direccion != TRIM(direccion);

COMMIT;

-- =====================================================
-- Verificación de resultados
-- =====================================================

-- Verificar que no queden direcciones con "#"
SELECT COUNT(*) as total_con_hash
FROM casas
WHERE direccion LIKE '%#%';
-- Resultado esperado: 0

-- Ver muestra de direcciones modificadas (primeras 20)
SELECT id, numero_casa, direccion, plaza_id
FROM casas
ORDER BY direccion
LIMIT 20;

-- Contar total de casas afectadas
-- (Ejecutar ANTES de la migración para comparar)
-- SELECT COUNT(*) FROM casas WHERE direccion LIKE '%#%';
