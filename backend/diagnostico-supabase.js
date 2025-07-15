require('dotenv').config();
const { Pool } = require('pg');

async function diagnosticarSupabase() {
  console.log('🔍 Diagnóstico de conexión a Supabase...\n');
  
  // Mostrar configuración
  console.log('📋 Configuración actual:');
  console.log('DATABASE_URL:', process.env.DATABASE_URL ? 'Configurada' : 'NO CONFIGURADA');
  console.log('NODE_ENV:', process.env.NODE_ENV);
  console.log('PORT:', process.env.PORT);
  console.log('');
  
  if (!process.env.DATABASE_URL) {
    console.log('❌ ERROR: DATABASE_URL no está configurada');
    console.log('💡 Verifica que el archivo .env tenga la línea DATABASE_URL descomentada');
    return;
  }
  
  // Parsear URL para verificar componentes
  try {
    const url = new URL(process.env.DATABASE_URL);
    console.log('🔍 Análisis de URL:');
    console.log('Host:', url.hostname);
    console.log('Puerto:', url.port);
    console.log('Base de datos:', url.pathname.substring(1));
    console.log('Usuario:', url.username);
    console.log('SSL:', url.searchParams.get('sslmode') || 'default');
    console.log('');
  } catch (error) {
    console.log('❌ Error parseando URL:', error.message);
    return;
  }
  
  // Probar conexión con diferentes configuraciones
  const configuraciones = [
    {
      nombre: 'Configuración original',
      config: {
        connectionString: process.env.DATABASE_URL,
        ssl: { rejectUnauthorized: false }
      }
    },
    {
      nombre: 'Sin SSL',
      config: {
        connectionString: process.env.DATABASE_URL.replace('?sslmode=require', ''),
        ssl: false
      }
    },
    {
      nombre: 'SSL requerido',
      config: {
        connectionString: process.env.DATABASE_URL,
        ssl: { rejectUnauthorized: false, requestCert: true }
      }
    }
  ];
  
  for (const config of configuraciones) {
    console.log(`🔧 Probando: ${config.nombre}`);
    
    const pool = new Pool(config.config);
    
    try {
      const client = await pool.connect();
      await client.query('SELECT 1');
      client.release();
      await pool.end();
      
      console.log('✅ ÉXITO: Conexión establecida correctamente');
      console.log(`💡 Usar esta configuración: ${config.nombre}`);
      
      // Probar consultas específicas
      console.log('\n🔍 Probando consultas específicas...');
      const testPool = new Pool(config.config);
      const testClient = await testPool.connect();
      
      try {
        // Verificar tablas existentes
        const tablas = await testClient.query(`
          SELECT table_name FROM information_schema.tables 
          WHERE table_schema = 'public' 
          ORDER BY table_name
        `);
        console.log('📋 Tablas encontradas:', tablas.rows.map(r => r.table_name).join(', '));
        
        // Verificar tabla admin_users
        const adminCheck = await testClient.query(`
          SELECT COUNT(*) as count FROM admin_users
        `);
        console.log('👥 Usuarios admin:', adminCheck.rows[0].count);
        
        testClient.release();
        await testPool.end();
        
      } catch (queryError) {
        console.log('⚠️  Error en consultas específicas:', queryError.message);
        testClient.release();
        await testPool.end();
      }
      
      return;
      
    } catch (error) {
      console.log(`❌ Error: ${error.message}`);
      console.log(`🔍 Código: ${error.code}`);
      await pool.end();
    }
    
    console.log('');
  }
  
  console.log('❌ Ninguna configuración funcionó');
  console.log('💡 Sugerencias:');
  console.log('   1. Verifica que la URL de Supabase esté correcta');
  console.log('   2. Verifica que el proyecto de Supabase esté activo');
  console.log('   3. Verifica tu conexión a internet');
  console.log('   4. Verifica que el usuario y contraseña sean correctos');
}

// Ejecutar diagnóstico
diagnosticarSupabase().then(() => {
  console.log('\n✅ Diagnóstico completado');
  process.exit(0);
}).catch((error) => {
  console.error('❌ Error durante el diagnóstico:', error);
  process.exit(1);
});
