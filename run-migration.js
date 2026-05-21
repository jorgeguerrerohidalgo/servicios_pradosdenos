const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');
require('dotenv').config({ path: path.join(__dirname, '.env') });

const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

async function runMigration(migrationFile) {
    const migrationPath = path.join(__dirname, 'database', 'migrations', migrationFile);
    
    console.log(`📄 Leyendo migración: ${migrationFile}`);
    
    if (!fs.existsSync(migrationPath)) {
        console.error(`❌ Archivo no encontrado: ${migrationPath}`);
        process.exit(1);
    }
    
    const sql = fs.readFileSync(migrationPath, 'utf8');
    
    console.log(`🚀 Ejecutando migración...`);
    
    try {
        const result = await pool.query(sql);
        console.log(`✅ Migración ejecutada correctamente`);
        
        if (result && result.rows && result.rows.length > 0) {
            console.log('📊 Resultado:', result.rows);
        }
        
    } catch (error) {
        console.error(`❌ Error al ejecutar migración:`, error.message);
        console.error('Stack:', error.stack);
        process.exit(1);
    } finally {
        await pool.end();
    }
}

// Obtener nombre de archivo de migración de argumentos
const migrationFile = process.argv[2];

if (!migrationFile) {
    console.error('❌ Uso: node run-migration.js <archivo-migracion>');
    console.error('   Ejemplo: node run-migration.js 024_fix_historial_alertas_function.sql');
    process.exit(1);
}

runMigration(migrationFile);
