const { Pool } = require('pg');

// URL de Supabase corregida
const DATABASE_URL = 'postgresql://postgres:MacBookPro710@db.ixttdxkelassioemefbo.supabase.co:5432/postgres';

async function probarConexion() {
  console.log('🔍 Probando conexión a Supabase...\n');
  
  const pool = new Pool({
    connectionString: DATABASE_URL,
    ssl: { rejectUnauthorized: false }
  });
  
  try {
    console.log('🔌 Conectando...');
    const client = await pool.connect();
    
    console.log('✅ Conexión exitosa!');
    
    // Probar consulta simple
    const result = await client.query('SELECT NOW() as tiempo_actual');
    console.log('⏰ Tiempo actual:', result.rows[0].tiempo_actual);
    
    // Verificar si existen las tablas
    const tablas = await client.query(`
      SELECT table_name FROM information_schema.tables 
      WHERE table_schema = 'public' 
      ORDER BY table_name
    `);
    
    console.log('\n📋 Tablas disponibles:');
    tablas.rows.forEach(row => {
      console.log(`  - ${row.table_name}`);
    });
    
    // Verificar tabla admin_users específicamente
    try {
      const adminCheck = await client.query('SELECT COUNT(*) as count FROM admin_users');
      console.log(`\n👥 Usuarios admin: ${adminCheck.rows[0].count}`);
    } catch (error) {
      console.log('\n⚠️  Tabla admin_users no existe:', error.message);
    }
    
    client.release();
    await pool.end();
    
    console.log('\n🎉 Conexión y pruebas exitosas!');
    
  } catch (error) {
    console.error('❌ Error:', error.message);
    console.error('🔍 Código:', error.code);
    console.error('💡 Detalles:', error.detail || 'No hay detalles adicionales');
    
    if (error.code === 'ENOTFOUND') {
      console.log('\n💡 Sugerencias:');
      console.log('   1. Verifica que la URL del proyecto Supabase sea correcta');
      console.log('   2. Verifica tu conexión a internet');
      console.log('   3. El formato debe ser: postgresql://postgres:PASSWORD@db.PROYECTO.supabase.co:5432/postgres');
    }
    
    await pool.end();
  }
}

probarConexion();
