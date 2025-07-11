-- Script para identificar y eliminar plazas duplicadas
-- Fecha: 10 de julio de 2025

-- ===============================================
-- IDENTIFICAR PLAZAS DUPLICADAS
-- ===============================================

-- Buscar plazas con nombres duplicados
SELECT nombre, COUNT(*) as cantidad
FROM plazas
GROUP BY nombre
HAVING COUNT(*) > 1
ORDER BY cantidad DESC;

-- Ver todas las plazas duplicadas con sus IDs
SELECT id, nombre, direccion, descripcion, activo, created_at
FROM plazas
WHERE nombre IN (
    SELECT nombre
    FROM plazas
    GROUP BY nombre
    HAVING COUNT(*) > 1
)
ORDER BY nombre, id;

-- ===============================================
-- ELIMINAR DUPLICADOS - CONSERVAR LA PRIMERA OCURRENCIA
-- ===============================================

-- Eliminar tokens de plazas duplicadas (mantener solo el de la primera ocurrencia)
DELETE FROM plaza_tokens
WHERE plaza_id IN (
    SELECT p2.id
    FROM plazas p1
    JOIN plazas p2 ON p1.nombre = p2.nombre AND p1.id < p2.id
    WHERE p1.nombre IN (
        SELECT nombre
        FROM plazas
        GROUP BY nombre
        HAVING COUNT(*) > 1
    )
);

-- Eliminar checkins asociados a plazas duplicadas
DELETE FROM checkins
WHERE plaza_id IN (
    SELECT p2.id
    FROM plazas p1
    JOIN plazas p2 ON p1.nombre = p2.nombre AND p1.id < p2.id
    WHERE p1.nombre IN (
        SELECT nombre
        FROM plazas
        GROUP BY nombre
        HAVING COUNT(*) > 1
    )
);

-- Eliminar administradores asociados a plazas duplicadas
UPDATE admin_users
SET plaza_id = NULL
WHERE plaza_id IN (
    SELECT p2.id
    FROM plazas p1
    JOIN plazas p2 ON p1.nombre = p2.nombre AND p1.id < p2.id
    WHERE p1.nombre IN (
        SELECT nombre
        FROM plazas
        GROUP BY nombre
        HAVING COUNT(*) > 1
    )
);

-- Finalmente, eliminar las plazas duplicadas (conservar la primera)
DELETE FROM plazas
WHERE id IN (
    SELECT p2.id
    FROM plazas p1
    JOIN plazas p2 ON p1.nombre = p2.nombre AND p1.id < p2.id
    WHERE p1.nombre IN (
        SELECT nombre
        FROM plazas
        GROUP BY nombre
        HAVING COUNT(*) > 1
    )
);

-- ===============================================
-- VERIFICACIÓN POST-ELIMINACIÓN
-- ===============================================

-- Verificar que no hay más duplicados
SELECT nombre, COUNT(*) as cantidad
FROM plazas
GROUP BY nombre
HAVING COUNT(*) > 1;

-- Mostrar todas las plazas actuales
SELECT id, nombre, direccion, descripcion, activo
FROM plazas
ORDER BY id;

-- Verificar tokens QR
SELECT p.id, p.nombre, pt.token
FROM plazas p
LEFT JOIN plaza_tokens pt ON p.id = pt.plaza_id
ORDER BY p.id;

-- ===============================================
-- REGENERAR SECUENCIA DE IDs (OPCIONAL)
-- ===============================================

-- Si quieres reordenar los IDs después de eliminar duplicados
-- NOTA: Esto puede afectar referencias existentes, usar con cuidado

-- Crear tabla temporal con nuevos IDs
CREATE TEMP TABLE plazas_temp AS
SELECT ROW_NUMBER() OVER (ORDER BY id) as new_id, id as old_id, nombre, direccion, descripcion, activo
FROM plazas
ORDER BY id;

-- Actualizar referencias en plaza_tokens
UPDATE plaza_tokens
SET plaza_id = pt.new_id
FROM plazas_temp pt
WHERE plaza_tokens.plaza_id = pt.old_id;

-- Actualizar referencias en checkins
UPDATE checkins
SET plaza_id = pt.new_id
FROM plazas_temp pt
WHERE checkins.plaza_id = pt.old_id;

-- Actualizar referencias en admin_users
UPDATE admin_users
SET plaza_id = pt.new_id
FROM plazas_temp pt
WHERE admin_users.plaza_id = pt.old_id;

-- Actualizar la tabla plazas con nuevos IDs
-- (Esto requiere desactivar temporalmente las restricciones)
ALTER TABLE plazas DROP CONSTRAINT IF EXISTS plazas_pkey;
UPDATE plazas
SET id = pt.new_id
FROM plazas_temp pt
WHERE plazas.id = pt.old_id;

-- Recrear la clave primaria
ALTER TABLE plazas ADD CONSTRAINT plazas_pkey PRIMARY KEY (id);

-- Ajustar la secuencia
SELECT setval('plazas_id_seq', (SELECT MAX(id) FROM plazas));

-- ===============================================
-- MENSAJE DE CONFIRMACIÓN
-- ===============================================
SELECT 'Eliminación de duplicados completada' as status, NOW() as timestamp;
SELECT COUNT(*) as total_plazas_final FROM plazas;
