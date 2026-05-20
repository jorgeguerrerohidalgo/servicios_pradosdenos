const fs = require('fs');
const path = require('path');

// Leer el archivo CSV
const csvPath = path.join(__dirname, '..', 'docs', 'excel', 'marca_tipo_modelo.csv');
const csvContent = fs.readFileSync(csvPath, 'utf-8');

// Parsear CSV (semicolon-delimited)
const lines = csvContent.trim().split('\n');
const header = lines[0]; // Tipo;Marca;Modelo
const dataLines = lines.slice(1); // Skip header

console.log(`Processing ${dataLines.length} rows from CSV...`);

// Extraer datos
const records = dataLines.map(line => {
    const [tipo, marca, modelo] = line.split(';');
    return { tipo: tipo.trim(), marca: marca.trim(), modelo: modelo.trim() };
});

// Obtener marcas únicas (ordenadas)
const marcasSet = new Set();
records.forEach(r => marcasSet.add(r.marca));
const marcasUnicas = Array.from(marcasSet).sort();

console.log(`Found ${marcasUnicas.length} unique marcas`);

// Generar SQL
let sql = `-- ============================================================================
-- IMPORTACIÓN COMPLETA DE MARCAS Y MODELOS DESDE CSV
-- ============================================================================
-- Archivo: marca_tipo_modelo.csv
-- Total modelos: ${records.length}
-- Total marcas únicas: ${marcasUnicas.length}
-- Tipos: Automóvil, Bus, Camioneta, Furgón, Motocicleta, Motor Home, SUV, Van
-- ============================================================================

-- Iniciar transacción
BEGIN;

-- ============================================================================
-- PASO 1: LIMPIAR DATOS EXISTENTES
-- ============================================================================

-- Eliminar modelos existentes (respeta FK constraints)
DELETE FROM modelo_vehiculo;
COMMIT;
BEGIN;

-- Eliminar marcas existentes
DELETE FROM marca_vehiculo;
COMMIT;
BEGIN;

-- ============================================================================
-- PASO 2: INSERTAR MARCAS ÚNICAS (${marcasUnicas.length} marcas)
-- ============================================================================

INSERT INTO marca_vehiculo (nombre, activo) VALUES\n`;

// Generar INSERTs para marcas
const marcasSQL = marcasUnicas.map(marca => {
    // Escapar comillas simples en SQL
    const escapedMarca = marca.replace(/'/g, "''");
    return `  ('${escapedMarca}', TRUE)`;
}).join(',\n');

sql += marcasSQL;
sql += `\nON CONFLICT (nombre) DO NOTHING;

COMMIT;
BEGIN;

-- ============================================================================
-- PASO 3: INSERTAR MODELOS (${records.length} modelos)
-- ============================================================================

INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, activo)
VALUES\n`;

// Generar INSERTs para modelos
const modelosSQL = records.map(record => {
    const escapedModelo = record.modelo.replace(/'/g, "''");
    const escapedMarca = record.marca.replace(/'/g, "''");
    const escapedTipo = record.tipo.replace(/'/g, "''");
    
    return `  (
    '${escapedModelo}',
    (SELECT id FROM marca_vehiculo WHERE nombre = '${escapedMarca}'),
    (SELECT id FROM tipo_vehiculo WHERE nombre = '${escapedTipo}'),
    TRUE
  )`;
}).join(',\n');

sql += modelosSQL;
sql += `\nON CONFLICT (nombre, marca_id) DO NOTHING;

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
`;

// Escribir el archivo SQL
const outputPath = path.join(__dirname, '..', 'sql', 'EJECUTAR_EN_SUPABASE_IMPORT_CSV.sql');
fs.writeFileSync(outputPath, sql, 'utf-8');

console.log(`\n✅ SQL script generated successfully!`);
console.log(`📁 File: ${outputPath}`);
console.log(`\nStatistics:`);
console.log(`  - ${marcasUnicas.length} marcas únicas`);
console.log(`  - ${records.length} modelos`);
console.log(`\nNext steps:`);
console.log(`  1. Ejecutar migración 019 en Supabase (si aún no se ejecutó)`);
console.log(`  2. Abrir Supabase SQL Editor`);
console.log(`  3. Copiar contenido de: sql/EJECUTAR_EN_SUPABASE_IMPORT_CSV.sql`);
console.log(`  4. Ejecutar el script completo`);
console.log(`  5. Verificar los resultados de las queries de verificación al final`);
