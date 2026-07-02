-- =====================================================
-- Migración 027: Soporte para múltiples plazas por rol
-- =====================================================
-- Descripción: Permite asignar el mismo rol a un usuario
--              en múltiples plazas (relación N:M real).
--              Elimina el constraint UNIQUE(user_id, role_id) que solo
--              permitía una plaza por rol.
--
-- Fecha: 2026-07-02
-- Autor: Sistema
-- =====================================================

BEGIN;

-- 1. Eliminar el constraint único anterior (solo permite 1 plaza por rol)
ALTER TABLE user_roles
  DROP CONSTRAINT IF EXISTS user_roles_user_id_role_id_key;

-- También eliminar variantes de nombre que pudo haber generado Supabase
ALTER TABLE user_roles
  DROP CONSTRAINT IF EXISTS user_roles_pkey_user_role;

-- Eliminar constraint nuevo si ya fue creado en un intento previo
ALTER TABLE user_roles
  DROP CONSTRAINT IF EXISTS user_roles_user_role_scope_unique;

-- Eliminar índice si fue creado previamente
DROP INDEX IF EXISTS user_roles_user_role_scope_idx;

-- 2. Agregar índice único compatible con cualquier versión de PostgreSQL
--    COALESCE trata NULLs como valores fijos para que la unicidad funcione:
--    - scope_type NULL → string vacío
--    - scope_id NULL   → -1
--    Esto impide duplicados exactos (mismo rol + misma plaza) pero permite
--    un mismo rol con múltiples plazas distintas.
CREATE UNIQUE INDEX user_roles_user_role_scope_idx
  ON user_roles (user_id, role_id, COALESCE(scope_type, ''), COALESCE(scope_id, -1));

COMMIT;

-- =====================================================
-- Verificación
-- =====================================================

-- Ver índices actuales de user_roles
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'user_roles';

-- Ver asignaciones duplicadas (deben ser 0 tras la migración)
SELECT user_id, role_id, scope_type, scope_id, COUNT(*) as total
FROM user_roles
WHERE activo = TRUE
GROUP BY user_id, role_id, scope_type, scope_id
HAVING COUNT(*) > 1;
-- Resultado esperado: 0 filas (sin duplicados)
