const { Pool } = require('pg');
require('dotenv').config();

console.log('=== VERIFICADOR DE DUPLICADOS ===');

// Configuración de la base de datos
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

async function verificarDuplicados() {
  try {
    console.log('🔍 Conectando a la base de datos...');
    
    // Verificar conexión
    const testQuery = await pool.query('SELECT NOW()');
    console.log('✅ Conexión exitosa:', testQuery.rows[0].now);
    
    // Buscar duplicados
    console.log('\n🔍 Buscando plazas duplicadas...');
    const duplicados = await pool.query(`
      SELECT nombre, COUNT(*) as cantidad
      FROM plazas
      GROUP BY nombre
      HAVING COUNT(*) > 1
      ORDER BY cantidad DESC
    `);
    
    if (duplicados.rows.length === 0) {
      console.log('✅ No hay plazas duplicadas');
      return;
    }
    
    console.log('📋 Plazas duplicadas encontradas:');
    duplicados.rows.forEach(d => {
      console.log(`  - ${d.nombre}: ${d.cantidad} ocurrencias`);
    });
    
    // Mostrar detalles
    console.log('\n🔍 Detalles de plazas duplicadas:');
    const detalles = await pool.query(`
      SELECT id, nombre, direccion, activo, created_at
      FROM plazas
      WHERE nombre IN (
        SELECT nombre
        FROM plazas
        GROUP BY nombre
        HAVING COUNT(*) > 1
      )
      ORDER BY nombre, id
    `);
    
    detalles.rows.forEach(p => {
      console.log(`  ID: ${p.id}, Nombre: ${p.nombre}, Activo: ${p.activo}, Creado: ${p.created_at}`);
    });
    
    console.log('\n=== VERIFICACIÓN COMPLETADA ===');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
    console.error('Stack:', error.stack);
  } finally {
    await pool.end();
  }
}

verificarDuplicados();
