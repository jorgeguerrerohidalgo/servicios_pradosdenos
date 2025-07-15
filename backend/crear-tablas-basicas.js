require('dotenv').config();
const { query } = require('./utils/db');
const bcrypt = require('bcrypt');

async function crearTablasBasicas() {
  console.log('🚀 Creando tablas básicas para el sistema de autenticación...\n');
  
  try {
    // Crear extensión UUID si no existe
    console.log('1. Configurando extensión UUID...');
    await query('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"');
    
    // Crear tabla admin_users
    console.log('2. Creando tabla admin_users...');
    await query(`
      CREATE TABLE IF NOT EXISTS admin_users (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        email VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        nombre VARCHAR(255) NOT NULL,
        activo BOOLEAN DEFAULT true,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      )
    `);
    
    // Crear tabla guardias
    console.log('3. Creando tabla guardias...');
    await query(`
      CREATE TABLE IF NOT EXISTS guardias (
        id SERIAL PRIMARY KEY,
        nombre VARCHAR(255) NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        telefono VARCHAR(20),
        password VARCHAR(255) NOT NULL,
        validation_code VARCHAR(10),
        activo BOOLEAN DEFAULT true,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        last_login TIMESTAMP WITH TIME ZONE
      )
    `);
    
    // Crear tabla plazas
    console.log('4. Creando tabla plazas...');
    await query(`
      CREATE TABLE IF NOT EXISTS plazas (
        id SERIAL PRIMARY KEY,
        nombre VARCHAR(255) NOT NULL,
        descripcion TEXT,
        activa BOOLEAN DEFAULT true,
        token VARCHAR(255) UNIQUE,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      )
    `);
    
    // Crear tabla checkins
    console.log('5. Creando tabla checkins...');
    await query(`
      CREATE TABLE IF NOT EXISTS checkins (
        id SERIAL PRIMARY KEY,
        guardia_id INTEGER REFERENCES guardias(id),
        plaza_id INTEGER REFERENCES plazas(id),
        fecha_checkin TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        observaciones TEXT
      )
    `);
    
    // Verificar si existe usuario admin
    console.log('6. Verificando usuario administrador...');
    const adminExists = await query('SELECT id FROM admin_users WHERE email = $1', ['admin@pradosdenos.cl']);
    
    if (adminExists.length === 0) {
      console.log('7. Creando usuario administrador por defecto...');
      const hashedPassword = await bcrypt.hash('admin123', 12);
      
      await query(`
        INSERT INTO admin_users (email, password, nombre, activo)
        VALUES ($1, $2, $3, true)
      `, ['admin@pradosdenos.cl', hashedPassword, 'Administrador']);
      
      console.log('✅ Usuario admin creado');
    } else {
      console.log('✅ Usuario admin ya existe');
    }
    
    // Verificar si existen plazas
    console.log('8. Verificando plazas...');
    const plazasCount = await query('SELECT COUNT(*) as count FROM plazas');
    
    if (parseInt(plazasCount[0].count) === 0) {
      console.log('9. Creando plazas por defecto...');
      const { v4: uuidv4 } = require('uuid');
      
      const plazasDefault = [
        { nombre: 'Plaza Principal', descripcion: 'Plaza de acceso principal del conjunto' },
        { nombre: 'Plaza Norte', descripcion: 'Plaza sector norte' },
        { nombre: 'Plaza Sur', descripcion: 'Plaza sector sur' },
        { nombre: 'Plaza Este', descripcion: 'Plaza sector este' },
        { nombre: 'Plaza Oeste', descripcion: 'Plaza sector oeste' }
      ];
      
      for (const plaza of plazasDefault) {
        await query(`
          INSERT INTO plazas (nombre, descripcion, token)
          VALUES ($1, $2, $3)
        `, [plaza.nombre, plaza.descripcion, uuidv4()]);
      }
      
      console.log('✅ Plazas creadas');
    } else {
      console.log('✅ Plazas ya existen');
    }
    
    // Crear un guardia de prueba
    console.log('10. Verificando guardia de prueba...');
    const guardiaExists = await query('SELECT id FROM guardias WHERE email = $1', ['guardia@pradosdenos.cl']);
    
    if (guardiaExists.length === 0) {
      console.log('11. Creando guardia de prueba...');
      const hashedPassword = await bcrypt.hash('guardia123', 12);
      
      await query(`
        INSERT INTO guardias (nombre, email, telefono, password, validation_code, activo)
        VALUES ($1, $2, $3, $4, $5, true)
      `, ['Guardia de Prueba', 'guardia@pradosdenos.cl', '+56912345678', hashedPassword, '1234']);
      
      console.log('✅ Guardia de prueba creado');
    } else {
      console.log('✅ Guardia de prueba ya existe');
    }
    
    console.log('\n🎉 Tablas básicas creadas exitosamente!');
    console.log('\n📋 Credenciales de prueba:');
    console.log('👤 Administrador:');
    console.log('   Email: admin@pradosdenos.cl');
    console.log('   Password: admin123');
    console.log('👮 Guardia:');
    console.log('   Email: guardia@pradosdenos.cl');
    console.log('   Password: guardia123');
    
  } catch (error) {
    console.error('❌ Error creando tablas básicas:', error);
    console.error('🔍 Detalles:', error.message);
  }
}

// Ejecutar creación de tablas
crearTablasBasicas().then(() => {
  console.log('\n✅ Inicialización completada');
  process.exit(0);
}).catch((error) => {
  console.error('❌ Error fatal:', error);
  process.exit(1);
});
