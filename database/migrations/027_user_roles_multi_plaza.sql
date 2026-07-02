-- =====================================================
-- Migración 027: Soporte para múltiples plazas por rol
-- =====================================================
-- Descripción: Permite asignar el mismo rol a un usuario
--              en múltiples plazas (relación N:M real).
--              El bloqueo real es el PRIMARY KEY compuesto (user_id, role_id).
--              Se reemplaza por un PK surrogate (id BIGSERIAL) y un índice
--              único en (user_id, role_id, scope_type, scope_id).
--
-- Fecha: 2026-07-02
-- Autor: Sistema
-- =====================================================

BEGIN;

-- 1. Limpiar constraints e índices previos (idempotente)
ALTER TABLE user_roles DROP CONSTRAINT IF EXISTS user_roles_user_id_role_id_key;
ALTER TABLE user_roles DROP CONSTRAINT IF EXISTS user_roles_pkey_user_role;
ALTER TABLE user_roles DROP CONSTRAINT IF EXISTS user_roles_user_role_scope_unique;
DROP INDEX IF EXISTS user_roles_user_role_scope_idx;

-- 2. Eliminar el PRIMARY KEY compuesto (user_id, role_id)
--    Este es el verdadero bloqueo: impide tener 2 filas con el mismo rol
--    aunque tengan diferente plaza (scope_id).
ALTER TABLE user_roles DROP CONSTRAINT IF EXISTS user_roles_pkey;

-- 3. Agregar PK surrogate autoincremental
ALTER TABLE user_roles ADD COLUMN IF NOT EXISTS id BIGSERIAL;
ALTER TABLE user_roles ADD PRIMARY KEY (id);

-- 4. Índice único en combinación completa (rol + scope)
--    COALESCE convierte NULLs en valores fijos para que la unicidad funcione:
--      scope_type NULL → ''   (rol global sin tipo)
--      scope_id   NULL → -1  (rol global sin plaza)
CREATE UNIQUE INDEX IF NOT EXISTS user_roles_user_role_scope_idx
  ON user_roles (user_id, role_id, COALESCE(scope_type, ''), COALESCE(scope_id, -1));

COMMIT;

-- =====================================================
-- Verificación
-- =====================================================

-- Ver constraints e índices actuales de user_roles
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'user_roles';

-- Ver asignaciones duplicadas (deben ser 0)
SELECT user_id, role_id, scope_type, scope_id, COUNT(*) as total
FROM user_roles
WHERE activo = TRUE
GROUP BY user_id, role_id, scope_type, scope_id
HAVING COUNT(*) > 1;
-- Resultado esperado: 0 filas
