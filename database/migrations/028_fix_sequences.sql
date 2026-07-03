-- =====================================================
-- Migración 028: Resetear secuencias desincronizadas
-- =====================================================
-- Descripción: Las importaciones masivas (bulk import) insertaron filas
--              con IDs explícitos sin avanzar el contador de la secuencia.
--              Esto causa "duplicate key value violates unique constraint"
--              al intentar crear nuevos registros.
--
-- Fecha: 2026-07-03
-- Autor: Sistema
-- =====================================================

-- Resetear secuencia de casas al MAX(id) actual
SELECT setval('casas_id_seq', (SELECT MAX(id) FROM casas));

-- Resetear otras secuencias por precaución
SELECT setval('residentes_id_seq',    (SELECT COALESCE(MAX(id), 1) FROM residentes));
SELECT setval('mascotas_id_seq',      (SELECT COALESCE(MAX(id), 1) FROM mascotas));
SELECT setval('plazas_id_seq',        (SELECT COALESCE(MAX(id), 1) FROM plazas));
SELECT setval('admin_users_id_seq',   (SELECT COALESCE(MAX(id), 1) FROM admin_users));
SELECT setval('pagos_id_seq',         (SELECT COALESCE(MAX(id), 1) FROM pagos));
SELECT setval('vehiculos_id_seq',     (SELECT COALESCE(MAX(id), 1) FROM vehiculos));

-- =====================================================
-- Verificación: revisar estado actual de secuencias
-- =====================================================
SELECT
    t.relname AS tabla,
    s.relname AS secuencia,
    last_value AS valor_actual,
    (SELECT MAX(id) FROM casas) AS max_id_casas
FROM pg_class s
JOIN pg_depend d ON d.objid = s.oid
JOIN pg_class t ON d.refobjid = t.oid
JOIN pg_sequences ps ON ps.sequencename = s.relname
WHERE s.relkind = 'S'
  AND t.relname IN ('casas','residentes','mascotas','plazas','admin_users','pagos','vehiculos')
ORDER BY t.relname;
