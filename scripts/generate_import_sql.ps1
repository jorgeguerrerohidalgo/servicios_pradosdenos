# Script para generar SQL de importación desde CSV
$ErrorActionPreference = "Stop"

Write-Host "Generando SQL de importación desde CSV..." -ForegroundColor Cyan

# Leer CSV
$csvPath = "d:\00.DESARROLLO\REPOS\servicios_pradosdenos\docs\excel\marca_tipo_modelo.csv"
$records = Import-Csv $csvPath -Delimiter ';'

Write-Host "Registros CSV: $($records.Count)" -ForegroundColor Yellow

# Extraer marcas únicas ordenadas
$marcasUnicas = $records | Select-Object -ExpandProperty Marca -Unique | Sort-Object

Write-Host "Marcas únicas: $($marcasUnicas.Count)" -ForegroundColor Yellow

# Iniciar SQL
$sql = @"
-- ============================================================================
-- IMPORTACIÓN COMPLETA DE MARCAS Y MODELOS DESDE CSV
-- ============================================================================
-- Archivo: marca_tipo_modelo.csv
-- Total modelos: $($records.Count)
-- Total marcas únicas: $($marcasUnicas.Count)
-- Tipos: Automóvil, Bus, Camioneta, Furgón, Motocicleta, Motor Home, SUV, Van
-- ============================================================================

-- Iniciar transacción
BEGIN;

-- ============================================================================
-- PASO 1: LIMPIAR DATOS EXISTENTES
-- ============================================================================

-- Eliminar modelos existentes (respeta FK constraints)
DELETE FROM modelo_vehiculo;

-- Eliminar marcas existentes
DELETE FROM marca_vehiculo;

-- ============================================================================
-- PASO 2: INSERTAR MARCAS ÚNICAS ($($marcasUnicas.Count) marcas)
-- ============================================================================

INSERT INTO marca_vehiculo (nombre, activo) VALUES

"@

# Generar INSERT para marcas
$marcasSQL = $marcasUnicas | ForEach-Object {
    $marcaEscaped = $_ -replace "'", "''"
    "  ('$marcaEscaped', TRUE)"
}
$sql += ($marcasSQL -join ",`n")
$sql += "`nON CONFLICT (nombre) DO NOTHING;`n`n"

# Generar INSERT para modelos
$sql += @"
-- ============================================================================
-- PASO 3: INSERTAR MODELOS ($($records.Count) modelos)
-- ============================================================================

INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, activo)
VALUES

"@

$modelosSQL = $records | ForEach-Object {
    $modeloEscaped = $_.Modelo -replace "'", "''"
    $marcaEscaped = $_.Marca -replace "'", "''"
    $tipoEscaped = $_.Tipo -replace "'", "''"
    
    @"
  (
    '$modeloEscaped',
    (SELECT id FROM marca_vehiculo WHERE nombre = '$marcaEscaped'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = '$tipoEscaped'),
    TRUE
  )
"@
}

$sql += ($modelosSQL -join ",`n")
$sql += "`nON CONFLICT (nombre, marca_id) DO NOTHING;`n`n"

# Finalizar SQL
$sql += @"
-- ============================================================================
-- FINALIZAR TRANSACCIÓN
-- ============================================================================

COMMIT;

-- ============================================================================
-- VERIFICACIÓN DE DATOS IMPORTADOS
-- ============================================================================

-- Contar marcas importadas
SELECT 'Marcas importadas' AS descripcion, COUNT(*) AS cantidad FROM marca_vehiculo;

-- Contar modelos importados
SELECT 'Modelos importados' AS descripcion, COUNT(*) AS cantidad FROM modelo_vehiculo;

-- Contar modelos por tipo de vehículo
SELECT 
    tv.nombre AS tipo_vehiculo,
    COUNT(mv.id) AS cantidad_modelos
FROM tipo_vehiculo tv
LEFT JOIN modelo_vehiculo mv ON mv.tipo_vehiculo_id = tv.id
WHERE tv.activo = TRUE
GROUP BY tv.nombre, tv.id
ORDER BY tv.nombre;

-- Contar modelos por marca (top 20)
SELECT 
    m.nombre AS marca,
    COUNT(mv.id) AS cantidad_modelos
FROM marca_vehiculo m
LEFT JOIN modelo_vehiculo mv ON mv.marca_id = m.id
GROUP BY m.nombre, m.id
ORDER BY cantidad_modelos DESC, m.nombre
LIMIT 20;
"@

# Guardar SQL
$outputPath = "d:\00.DESARROLLO\REPOS\servicios_pradosdenos\sql\EJECUTAR_EN_SUPABASE_IMPORT_CSV.sql"
$sql | Out-File -FilePath $outputPath -Encoding UTF8

Write-Host "`nSQL script generado exitosamente!" -ForegroundColor Green
Write-Host "Archivo: $outputPath" -ForegroundColor White
Write-Host "`nEstadisticas:" -ForegroundColor Cyan
Write-Host "  - $($marcasUnicas.Count) marcas unicas" -ForegroundColor White
Write-Host "  - $($records.Count) modelos" -ForegroundColor White
Write-Host "`nProximos pasos:" -ForegroundColor Cyan
Write-Host "  1. Ejecutar migracion 019 en Supabase (si aun no se ejecuto)" -ForegroundColor White
Write-Host "  2. Abrir Supabase SQL Editor" -ForegroundColor White
Write-Host "  3. Copiar contenido de: sql/EJECUTAR_EN_SUPABASE_IMPORT_CSV.sql" -ForegroundColor White
Write-Host "  4. Ejecutar el script completo" -ForegroundColor White
Write-Host "  5. Verificar resultados de las queries de verificacion al final" -ForegroundColor White
