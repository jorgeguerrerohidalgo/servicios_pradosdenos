const { query, testConnection } = require('./utils/db');

async function diagnosticarAdmin() {
  console.log('🔍 Iniciando diagnóstico de administración...\n');
  
  try {
    // 1. Probar conexión a la base de datos
    console.log('1. Probando conexión a la base de datos...');
    const conexionOK = await testConnection();
    if (!conexionOK) {
      console.log('❌ Error: No se puede conectar a la base de datos');
      return;
    }
    
    // 2. Verificar si existe la tabla admin_users
    console.log('2. Verificando tabla admin_users...');
    try {
      const adminUsers = await query('SELECT * FROM admin_users LIMIT 1');
      console.log('✅ Tabla admin_users existe');
      
      // Verificar si hay usuarios admin
      const adminCount = await query('SELECT COUNT(*) as count FROM admin_users');
      console.log(`📊 Total de usuarios admin: ${adminCount[0].count}`);
      
      if (adminCount[0].count === 0) {
        console.log('⚠️  No hay usuarios administradores creados');
      }
    } catch (error) {
      console.log('❌ Error: Tabla admin_users no existe o hay un problema');
      console.log('Error específico:', error.message);
    }
    
    // 3. Verificar si existe la tabla guardias
    console.log('3. Verificando tabla guardias...');
    try {
      const guardias = await query('SELECT * FROM guardias LIMIT 1');
      console.log('✅ Tabla guardias existe');
      
      // Verificar si hay guardias
      const guardiaCount = await query('SELECT COUNT(*) as count FROM guardias');
      console.log(`📊 Total de guardias: ${guardiaCount[0].count}`);
    } catch (error) {
      console.log('❌ Error: Tabla guardias no existe');
      console.log('Error específico:', error.message);
    }
    
    // 4. Verificar si existe la tabla plazas
    console.log('4. Verificando tabla plazas...');
    try {
      const plazas = await query('SELECT * FROM plazas LIMIT 1');
      console.log('✅ Tabla plazas existe');
      
      const plazaCount = await query('SELECT COUNT(*) as count FROM plazas');
      console.log(`📊 Total de plazas: ${plazaCount[0].count}`);
    } catch (error) {
      console.log('❌ Error: Tabla plazas no existe');
      console.log('Error específico:', error.message);
    }
    
    // 5. Verificar tablas de eventos y documentos
    console.log('5. Verificando tablas de eventos y documentos...');
    try {
      const eventos = await query('SELECT * FROM eventos LIMIT 1');
      console.log('✅ Tabla eventos existe');
      
      const documentos = await query('SELECT * FROM documentos LIMIT 1');
      console.log('✅ Tabla documentos existe');
    } catch (error) {
      console.log('❌ Error: Tablas de eventos/documentos no existen');
      console.log('Error específico:', error.message);
    }
    
    // 6. Verificar si hay un usuario admin por defecto
    console.log('6. Verificando usuario admin por defecto...');
    try {
      const adminDefault = await query('SELECT * FROM admin_users WHERE email = $1', ['admin@pradosdenos.cl']);
      if (adminDefault.length > 0) {
        console.log('✅ Usuario admin por defecto existe');
      } else {
        console.log('⚠️  No existe usuario admin por defecto');
        console.log('💡 Creando usuario admin por defecto...');
        
        const bcrypt = require('bcrypt');
        const hashedPassword = await bcrypt.hash('admin123', 10);
        
        await query(`
          INSERT INTO admin_users (id, email, password, nombre, activo, created_at)
          VALUES (gen_random_uuid(), $1, $2, $3, true, NOW())
        `, ['admin@pradosdenos.cl', hashedPassword, 'Administrador']);
        
        console.log('✅ Usuario admin por defecto creado');
        console.log('📧 Email: admin@pradosdenos.cl');
        console.log('🔑 Password: admin123');
      }
    } catch (error) {
      console.log('❌ Error creando usuario admin por defecto');
      console.log('Error específico:', error.message);
    }
    
    console.log('\n🎉 Diagnóstico completado!');
    
  } catch (error) {
    console.error('❌ Error durante el diagnóstico:', error);
  }
}

// Ejecutar diagnóstico
diagnosticarAdmin().then(() => {
  console.log('\n✅ Diagnóstico finalizado');
  process.exit(0);
}).catch((error) => {
  console.error('❌ Error fatal:', error);
  process.exit(1);
});
