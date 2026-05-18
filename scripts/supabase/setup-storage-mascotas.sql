-- ========================================
-- CONFIGURACIÓN: Supabase Storage para Fotos de Mascotas
-- ========================================
-- Ejecutar en Supabase SQL Editor
-- ========================================

-- 1. CREAR BUCKET (solo si no existe)
-- Ejecutar esto en Supabase Dashboard > Storage > Create Bucket
-- Nombre: mascotas-fotos
-- Público: SÍ (para que las URLs sean accesibles sin autenticación)

-- 2. POLÍTICAS DE SEGURIDAD (RLS)
-- Permitir que cualquier usuario autenticado suba fotos

-- Política: Permitir SELECT público (ver fotos)
CREATE POLICY "Permitir acceso público a fotos de mascotas"
ON storage.objects FOR SELECT
USING (bucket_id = 'mascotas-fotos');

-- Política: Permitir INSERT solo a usuarios autenticados
CREATE POLICY "Permitir upload solo a usuarios autenticados"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'mascotas-fotos' 
  AND auth.role() = 'authenticated'
);

-- Política: Permitir UPDATE solo a usuarios autenticados
CREATE POLICY "Permitir actualizar fotos a usuarios autenticados"
ON storage.objects FOR UPDATE
USING (bucket_id = 'mascotas-fotos' AND auth.role() = 'authenticated')
WITH CHECK (bucket_id = 'mascotas-fotos' AND auth.role() = 'authenticated');

-- Política: Permitir DELETE solo a usuarios autenticados
CREATE POLICY "Permitir eliminar fotos a usuarios autenticados"
ON storage.objects FOR DELETE
USING (bucket_id = 'mascotas-fotos' AND auth.role() = 'authenticated');

-- ========================================
-- NOTAS DE CONFIGURACIÓN
-- ========================================
-- 1. En Supabase Dashboard:
--    Storage > mascotas-fotos > Configuration
--    - File size limit: 3 MB (suficiente para fotos de mascotas)
--    - Allowed MIME types: image/jpeg, image/png, image/webp, image/gif
--
-- 2. Estructura de rutas recomendada:
--    mascotas-fotos/{plaza_id}/{casa_id}/{mascota_id}_{timestamp}.jpg
--    Ejemplo: mascotas-fotos/1/25/123_1684512000000.jpg
--
-- 3. URL pública resultante:
--    https://{project-id}.supabase.co/storage/v1/object/public/mascotas-fotos/{path}
