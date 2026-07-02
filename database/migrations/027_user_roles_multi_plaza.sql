-- =====================================================
-- Migración 027: Soporte para múltiples plazas por rol
-- =====================================================
-- Descripción: Permite asignar el mismo rol a un usuario
--              en múltiples plazas (relación N:M real).
--              Cambia el constraint UNIQUE(user_id, role_id)
--              por UNIQUE NULLS NOT DISTINCT(user_id, role_id, scope_type, scope_id)
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

-- 2. Agregar nuevo constraint que permite múltiples plazas por rol
--    NULLS NOT DISTINCT: trata dos NULLs como iguales (para roles globales)
--    Requiere PostgreSQL 15+ (Supabase >=15.x)
ALTER TABLE user_roles
  ADD CONSTRAINT user_roles_user_role_scope_unique
  UNIQUE NULLS NOT DISTINCT (user_id, role_id, scope_type, scope_id);

COMMIT;

-- =====================================================
-- Verificación
-- =====================================================

-- Ver constraints actuales de user_roles
SELECT constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_name = 'user_roles';

-- Ver asignaciones actuales (puede haber duplicados tras la migración)
SELECT user_id, role_id, scope_type, scope_id, COUNT(*) as total
FROM user_roles
WHERE activo = TRUE
GROUP BY user_id, role_id, scope_type, scope_id
HAVING COUNT(*) > 1;
-- Resultado esperado: 0 filas (sin duplicados)
