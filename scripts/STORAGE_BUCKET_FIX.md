# Fix: Storage Bucket "mascotas-fotos" - Eliminar Listado Público

## Problema
El bucket `mascotas-fotos` tiene una política que permite listar todos los archivos públicamente. Esto expone nombres de archivos innecesariamente (aunque el contenido ya es público para URLs directas).

## Solución

### Opción A: Desde Supabase Dashboard (Recomendado)

1. **Ve a Supabase Dashboard**
   - Abre tu proyecto en https://supabase.com/dashboard
   - Ve a **Storage** → **Policies**

2. **Encuentra la política "Permitir lectura pública"**
   - Busca el bucket `mascotas-fotos`
   - Encuentra la política de tipo **SELECT**

3. **Elimina la política SELECT**
   - Haz clic en el botón de eliminar (🗑️)
   - Confirma la eliminación

4. **Verifica que quede solo política de objeto individual**
   - El bucket debe permitir acceso a URLs individuales
   - Pero NO debe permitir listar todos los archivos

### Opción B: Desde SQL Editor

Ejecuta este script en Supabase SQL Editor:

```sql
-- Eliminar política de SELECT amplia en mascotas-fotos
DROP POLICY IF EXISTS "Permitir lectura pública" ON storage.objects;

-- Verificar políticas restantes
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies
WHERE schemaname = 'storage'
AND tablename = 'objects';
```

## Resultado Esperado

✅ Los archivos individuales siguen siendo accesibles vía URL directa  
✅ NO se puede listar todos los archivos del bucket  
✅ Warning "Public Bucket Allows Listing" desaparece del Security Advisor

## Notas Importantes

- **Las fotos de mascotas SIGUEN siendo públicas** (accesibles por URL)
- Solo se elimina la capacidad de **listar** todos los archivos
- Tu galería `/mascotas.html` seguirá funcionando (usa URLs almacenadas en DB)

## Verificación

Después de aplicar el fix:
1. Refresca Supabase Security Advisor
2. Verifica que desaparezca el warning "Public Bucket Allows Listing"
3. Prueba que `/mascotas.html` sigue cargando las fotos correctamente
