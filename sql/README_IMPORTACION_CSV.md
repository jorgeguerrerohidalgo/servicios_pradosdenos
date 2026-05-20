# INSTRUCCIONES - Importación de Marcas y Modelos desde CSV

## 📋 Resumen
Este script reemplaza completamente los datos de marcas y modelos en la base de datos usando el archivo CSV `docs/excel/marca_tipo_modelo.csv`.

## 📊 Estadísticas
- **Total marcas únicas:** 260
- **Total modelos:** 4,304
- **Tipos de vehículos:** 8 (Automóvil, Bus, Camioneta, Furgón, Motocicleta, Motor Home, SUV, Van)

## ⚠️ IMPORTANTE
Este script **ELIMINA** todos los datos existentes de:
- `modelo_vehiculo` (4,304 registros nuevos)
- `marca_vehiculo` (260 registros nuevos)

**NO** modifica la tabla `tipo_vehiculo` (se mantienen los 9 tipos de la migración 019).

## 🚀 Pasos para Ejecutar

### 1️⃣ Prerequisito: Ejecutar Migración 019
Si aún no lo hiciste, ejecuta primero la migración 019 para simplificar los tipos de vehículos:

1. Abre **Supabase SQL Editor**
2. Abre el archivo:  `database/migrations/019_simplify_vehicle_types.sql`
3. Copia y pega el contenido en el editor
4. Ejecuta el script

### 2️⃣ Ejecutar Importación de CSV

1. Abre **Supabase SQL Editor**
2. Abre el archivo: `sql/EJECUTAR_EN_SUPABASE_IMPORT_CSV.sql`
3. Copia y pega el **contenido completo** en el editor
4. **Revisa las estadísticas** en los comentarios del header
5. Ejecuta el script completo (puede tardar 30-60 segundos)

### 3️⃣ Verificar Resultados

Al finalizar, el script ejecuta automáticamente queries de verificación que muestran:

✅ **Marcas importadas:** Debe mostrar **260**
✅ **Modelos importados:** Debe mostrar **4,304**
✅ **Modelos por tipo:** Distribución por cada tipo de vehículo
✅ **Top 20 marcas:** Marcas con más modelos

## 📁 Estructura del Script

```sql
BEGIN;

-- PASO 1: Limpiar datos existentes
DELETE FROM modelo_vehiculo;
DELETE FROM marca_vehiculo;

-- PASO 2: Insertar 260 marcas únicas
INSERT INTO marca_vehiculo (nombre, activo) VALUES
  ('AUDI', TRUE),
  ('BMW', TRUE),
  ...

-- PASO 3: Insertar 4,304 modelos
INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, activo)
VALUES
  (
    '430I',
    (SELECT id FROM marca_vehiculo WHERE nombre = 'BMW'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'),
    TRUE
  ),
  ...

COMMIT;

-- Queries de verificación...
```

## 🔄 Regenerar el Script SQL (si es necesario)

Si necesitas regenerar el script desde el CSV:

```powershell
powershell -ExecutionPolicy Bypass -File "scripts/generate_import_sql.ps1"
```

Esto:
1. Lee `docs/excel/marca_tipo_modelo.csv`
2. Extrae marcas únicas (260)
3. Genera SQL con DELETE + INSERT
4. Guarda en `sql/EJECUTAR_EN_SUPABASE_IMPORT_CSV.sql`

## 📝 Notas Técnicas

### Manejo de Duplicados
- **Marcas:** `ON CONFLICT (nombre) DO NOTHING` - Evita duplicados por nombre único
- **Modelos:** `ON CONFLICT (nombre, marca_id) DO NOTHING` - Permite mismo modelo para distintas marcas (ej: "430" de BMW vs "430" de otra marca)

### Mapeo de Tipos
El script mapea dinámicamente cada tipo del CSV a su ID en `tipo_vehiculo`:
- `Automóvil` → `SELECT id FROM tipo_vehiculo WHERE nombre = 'Automóvil'`
- `SUV` → `SELECT id FROM tipo_vehiculo WHERE nombre = 'SUV'`
- etc.

### Caracteres Especiales
El script maneja correctamente:
- Acentos: Automóvil, Furgón, Motocicleta
- Comillas simples: Se escapa como `''`
- Espacios: BRP CAN AM, MERCEDES BENZ, etc.

## 🛠️ Troubleshooting

### Error: "relation modelo_vehiculo has FK constraint"
**Solución:** Asegúrate de que no haya registros en `vehiculos` que referencien modelos. El script elimina primero `modelo_vehiculo` que tiene FK a `marca_vehiculo`.

### Error: "tipo_vehiculo not found"
**Solución:** Ejecuta la migración 019 primero para crear los 9 tipos activos.

### Timeout en Supabase
**Solución:** El script tiene 26,141 líneas. Si falla por timeout:
1. Divide el script en 2 partes:
   - Parte 1: DELETE + INSERT marcas
   - Parte 2: INSERT modelos
2. Ejecuta cada parte por separado

## 🎯 Resultado Esperado

Después de ejecutar:

```sql
SELECT COUNT(*) FROM marca_vehiculo;
-- Resultado: 260

SELECT COUNT(*) FROM modelo_vehiculo;
-- Resultado: 4304

SELECT tv.nombre, COUNT(mv.id) AS modelos
FROM tipo_vehiculo tv
LEFT JOIN modelo_vehiculo mv ON mv.tipo_vehiculo_id = tv.id
WHERE tv.activo = TRUE
GROUP BY tv.nombre
ORDER BY tv.nombre;
-- Resultado: 8 tipos con distribución de modelos
-- (Camión tendrá 0 porque no hay datos de Camión en el CSV)
```

## 📞 Soporte

Si encuentras problemas:
1. Revisa los logs de Supabase SQL Editor
2. Verifica que la migración 019 se haya ejecutado
3. Consulta los archivos fuente:
   - CSV: `docs/excel/marca_tipo_modelo.csv`
   - Script: `sql/EJECUTAR_EN_SUPABASE_IMPORT_CSV.sql`
   - Generador: `scripts/generate_import_sql.ps1`
