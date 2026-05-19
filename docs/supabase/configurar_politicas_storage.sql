-- ============================================================
-- POLÍTICAS RLS PARA BUCKET mascotas-fotos
-- ============================================================
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- Fecha: 18/05/2026
-- Propósito: Permitir uploads/deletes públicos en bucket mascotas-fotos
-- NOTA: Script idempotente - se puede ejecutar múltiples veces
-- ============================================================

-- Eliminar políticas existentes (si existen)
DROP POLICY IF EXISTS "Permitir uploads públicos" ON storage.objects;
DROP POLICY IF EXISTS "Permitir lectura pública" ON storage.objects;
DROP POLICY IF EXISTS "Permitir borrado público" ON storage.objects;
DROP POLICY IF EXISTS "Permitir actualización pública" ON storage.objects;

-- 1. Permitir INSERT (upload) público
CREATE POLICY "Permitir uploads públicos"
ON storage.objects
FOR INSERT
TO public
WITH CHECK (bucket_id = 'mascotas-fotos');

-- 2. Permitir SELECT (leer) público (ya configurado por bucket público, pero por si acaso)
CREATE POLICY "Permitir lectura pública"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'mascotas-fotos');

-- 3. Permitir DELETE público (para reemplazo de fotos)
CREATE POLICY "Permitir borrado público"
ON storage.objects
FOR DELETE
TO public
USING (bucket_id = 'mascotas-fotos');

-- 4. Permitir UPDATE público (para renombrar/mover archivos - opcional)
CREATE POLICY "Permitir actualización pública"
ON storage.objects
FOR UPDATE
TO public
USING (bucket_id = 'mascotas-fotos')
WITH CHECK (bucket_id = 'mascotas-fotos');

-- ============================================================
-- VERIFICACIÓN (ejecutar después para confirmar)
-- ============================================================
SELECT 
    policyname, 
    cmd,
    CASE 
        WHEN cmd = 'r' THEN 'SELECT'
        WHEN cmd = 'a' THEN 'INSERT'
        WHEN cmd = 'w' THEN 'UPDATE'
        WHEN cmd = 'd' THEN 'DELETE'
        ELSE cmd
    END as operation
FROM pg_policies 
WHERE tablename = 'objects' 
AND schemaname = 'storage'
AND policyname LIKE '%p%blico%'
ORDER BY policyname;

-- ============================================================
-- VERIFICACIÓN (ejecutar después para confirmar)
-- ============================================================
-- SELECT * FROM storage.objects WHERE bucket_id = 'mascotas-fotos';
-- SELECT * FROM storage.buckets WHERE id = 'mascotas-fotos';
