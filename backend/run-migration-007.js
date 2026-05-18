/**
 * Script para ejecutar migración 007: Corrección de lógica de morosidad
 * Ejecutar con: node backend/run-migration-007.js
 */

require('dotenv').config();
const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

async function runMigration() {
    const pool = new Pool({
        connectionString: process.env.DATABASE_URL,
        ssl: {
            rejectUnauthorized: false
        }
    });

    try {
        console.log('🔄 Conectando a base de datos...');
        const client = await pool.connect();
        
        console.log('📄 Leyendo script de migración 007...');
        const migrationPath = path.join(__dirname, '../scripts/database/007_fix_morosidad_logic.sql');
        const migrationSQL = fs.readFileSync(migrationPath, 'utf8');
        
        console.log('⚙️  Ejecutando migración...');
        await client.query(migrationSQL);
        
        console.log('✅ Migración 007 ejecutada exitosamente');
        console.log('');
        console.log('📊 Cambios aplicados:');
        console.log('   - Vista v_vehiculos_completo actualizada');
        console.log('   - Nuevo estado: sin_pagos');
        console.log('   - Casas sin pagos ahora tienen acceso_permitido = FALSE');
        console.log('');
        console.log('🧪 Verificando cambios...');
        
        // Verificar un vehículo de ejemplo
        const testQuery = await client.query(`
            SELECT 
                patente, 
                numero_casa, 
                estado_morosidad, 
                acceso_permitido,
                (SELECT COUNT(*) FROM pagos WHERE casa_id = v_vehiculos_completo.casa_id AND activo = TRUE) as total_pagos
            FROM v_vehiculos_completo 
            LIMIT 5
        `);
        
        console.log('');
        console.log('Muestra de vehículos:');
        console.table(testQuery.rows);
        
        client.release();
        await pool.end();
        
        console.log('');
        console.log('✅ Proceso completado exitosamente');
        
    } catch (error) {
        console.error('❌ Error al ejecutar migración:', error);
        console.error(error.stack);
        process.exit(1);
    }
}

runMigration();
