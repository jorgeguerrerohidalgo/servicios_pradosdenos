require('dotenv').config();
const { query } = require('./utils/db');

async function probarAutenticacion() {
  console.log('🔍 Probando sistema de autenticación...\n');
  
  try {
    // Probar conexión a la base de datos
    console.log('1. Probando conexión a la base de datos...');
    const testQuery = await query('SELECT NOW() as tiempo');
    console.log('✅ Conexión exitosa:', testQuery[0].tiempo);
    
    // Verificar tabla admin_users
    console.log('2. Verificando tabla admin_users...');
    const admins = await query('SELECT id, email, nombre, activo FROM admin_users LIMIT 5');
    console.log(`✅ Tabla admin_users: ${admins.length} registros`);
    admins.forEach(admin => {
      console.log(`   - ${admin.email} (${admin.nombre}) - ${admin.activo ? 'Activo' : 'Inactivo'}`);
    });
    
    // Verificar tabla guardias
    console.log('3. Verificando tabla guardias...');
    const guardias = await query('SELECT id, email, nombre, activo FROM guardias LIMIT 5');
    console.log(`✅ Tabla guardias: ${guardias.length} registros`);
    guardias.forEach(guardia => {
      console.log(`   - ${guardia.email} (${guardia.nombre}) - ${guardia.activo ? 'Activo' : 'Inactivo'}`);
    });
    
    // Verificar tabla plazas
    console.log('4. Verificando tabla plazas...');
    const plazas = await query('SELECT id, nombre, activa FROM plazas LIMIT 5');
    console.log(`✅ Tabla plazas: ${plazas.length} registros`);
    plazas.forEach(plaza => {
      console.log(`   - ${plaza.nombre} - ${plaza.activa ? 'Activa' : 'Inactiva'}`);
    });
    
    console.log('\n🎉 Sistema de autenticación listo!');
    console.log('\n📋 Puedes probar con:');
    console.log('🔗 Admin: http://localhost:3000/admin-login.html');
    console.log('🔗 Guardia: http://localhost:3000/guardia-login.html');
    
  } catch (error) {
    console.error('❌ Error en prueba de autenticación:', error);
    console.error('🔍 Detalles:', error.message);
    
    if (error.message.includes('relation') && error.message.includes('does not exist')) {
      console.log('\n💡 Parece que las tablas no existen. Ejecuta:');
      console.log('   node crear-tablas-basicas.js');
    }
  }
}

probarAutenticacion().then(() => {
  console.log('\n✅ Prueba completada');
  process.exit(0);
}).catch((error) => {
  console.error('❌ Error fatal:', error);
  process.exit(1);
});
