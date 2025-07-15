require('dotenv').config();
const { Pool } = require('pg');

// Configuración de conexión simplificada
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

async function inicializarSistema() {
  console.log('🚀 Inicializando sistema de administración...\n');
  
  try {
    // 1. Probar conexión
    console.log('1. Probando conexión a la base de datos...');
    const client = await pool.connect();
    console.log('✅ Conexión exitosa');
    
    // 2. Verificar y crear tabla admin_users si no existe
    console.log('2. Verificando tabla admin_users...');
    await client.query(`
      CREATE TABLE IF NOT EXISTS admin_users (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        email VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        nombre VARCHAR(255) NOT NULL,
        activo BOOLEAN DEFAULT true,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      )
    `);
    console.log('✅ Tabla admin_users verificada');
    
    // 3. Verificar y crear tabla guardias si no existe
    console.log('3. Verificando tabla guardias...');
    await client.query(`
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
    console.log('✅ Tabla guardias verificada');
    
    // 4. Verificar y crear tabla plazas si no existe
    console.log('4. Verificando tabla plazas...');
    await client.query(`
      CREATE TABLE IF NOT EXISTS plazas (
        id SERIAL PRIMARY KEY,
        nombre VARCHAR(255) NOT NULL,
        descripcion TEXT,
        activa BOOLEAN DEFAULT true,
        token VARCHAR(255) UNIQUE,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      )
    `);
    console.log('✅ Tabla plazas verificada');
    
    // 5. Verificar usuario admin por defecto
    console.log('5. Verificando usuario admin por defecto...');
    const adminCheck = await client.query('SELECT * FROM admin_users WHERE email = $1', ['admin@pradosdenos.cl']);
    
    if (adminCheck.rows.length === 0) {
      console.log('⚠️  Creando usuario admin por defecto...');
      const bcrypt = require('bcrypt');
      const hashedPassword = await bcrypt.hash('admin123', 10);
      
      await client.query(`
        INSERT INTO admin_users (email, password, nombre, activo)
        VALUES ($1, $2, $3, true)
      `, ['admin@pradosdenos.cl', hashedPassword, 'Administrador']);
      
      console.log('✅ Usuario admin creado');
      console.log('📧 Email: admin@pradosdenos.cl');
      console.log('🔑 Password: admin123');
    } else {
      console.log('✅ Usuario admin ya existe');
    }
    
    // 6. Crear algunas plazas por defecto si no existen
    console.log('6. Verificando plazas por defecto...');
    const plazasCheck = await client.query('SELECT COUNT(*) as count FROM plazas');
    
    if (parseInt(plazasCheck.rows[0].count) === 0) {
      console.log('⚠️  Creando plazas por defecto...');
      const uuid = require('uuid');
      
      const plazasDefault = [
        { nombre: 'Plaza Principal', descripcion: 'Plaza de acceso principal del conjunto' },
        { nombre: 'Plaza Norte', descripcion: 'Plaza sector norte' },
        { nombre: 'Plaza Sur', descripcion: 'Plaza sector sur' },
        { nombre: 'Plaza Este', descripcion: 'Plaza sector este' },
        { nombre: 'Plaza Oeste', descripcion: 'Plaza sector oeste' }
      ];
      
      for (const plaza of plazasDefault) {
        await client.query(`
          INSERT INTO plazas (nombre, descripcion, token)
          VALUES ($1, $2, $3)
        `, [plaza.nombre, plaza.descripcion, uuid.v4()]);
      }
      
      console.log('✅ Plazas por defecto creadas');
    } else {
      console.log('✅ Plazas ya existen');
    }
    
    client.release();
    console.log('\n🎉 Sistema inicializado correctamente!');
    console.log('🔗 Accede a la administración en: http://localhost:3000/admin-login.html');
    console.log('📧 Email: admin@pradosdenos.cl');
    console.log('🔑 Password: admin123');
    
  } catch (error) {
    console.error('❌ Error durante la inicialización:', error);
    console.error('🔍 Detalles del error:', error.message);
    console.error('💡 Verifica que la variable DATABASE_URL esté configurada correctamente');
  } finally {
    await pool.end();
  }
}

// Ejecutar inicialización
inicializarSistema().then(() => {
  console.log('\n✅ Inicialización completada');
  process.exit(0);
}).catch((error) => {
  console.error('❌ Error fatal:', error);
  process.exit(1);
});
