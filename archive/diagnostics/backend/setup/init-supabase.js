require('dotenv').config();
const { Pool } = require('pg');

async function inicializarSupabase() {
  console.log('🚀 Inicializando tablas en Supabase...\n');
  
  const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: { rejectUnauthorized: false }
  });
  
  try {
    const client = await pool.connect();
    console.log('✅ Conectado a Supabase');
    
    // Crear extensión UUID si no existe
    console.log('🔧 Configurando extensión UUID...');
    await client.query('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"');
    
    // Crear tabla admin_users
    console.log('📋 Creando tabla admin_users...');
    await client.query(`
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
    console.log('👮 Creando tabla guardias...');
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
    
    // Crear tabla plazas
    console.log('🏛️ Creando tabla plazas...');
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
    
    // Crear tabla checkins
    console.log('✅ Creando tabla checkins...');
    await client.query(`
      CREATE TABLE IF NOT EXISTS checkins (
        id SERIAL PRIMARY KEY,
        guardia_id INTEGER REFERENCES guardias(id),
        plaza_id INTEGER REFERENCES plazas(id),
        fecha_checkin TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        observaciones TEXT
      )
    `);
    
    // Crear tabla eventos
    console.log('📅 Creando tabla eventos...');
    await client.query(`
      CREATE TABLE IF NOT EXISTS eventos (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        titulo VARCHAR(255) NOT NULL,
        descripcion TEXT,
        fecha_evento TIMESTAMP WITH TIME ZONE NOT NULL,
        ubicacion VARCHAR(255),
        tipo VARCHAR(50) DEFAULT 'general',
        activo BOOLEAN DEFAULT true,
        created_by UUID REFERENCES admin_users(id),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      )
    `);
    
    // Crear tabla documentos
    console.log('📄 Creando tabla documentos...');
    await client.query(`
      CREATE TABLE IF NOT EXISTS documentos (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
        titulo VARCHAR(255) NOT NULL,
        descripcion TEXT,
        archivo_nombre VARCHAR(255) NOT NULL,
        archivo_ruta VARCHAR(500) NOT NULL,
        archivo_tamaño INTEGER,
        tipo VARCHAR(50) DEFAULT 'general',
        activo BOOLEAN DEFAULT true,
        created_by UUID REFERENCES admin_users(id),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      )
    `);
    
    // Crear usuario admin por defecto
    console.log('👤 Creando usuario admin por defecto...');
    const adminExists = await client.query('SELECT id FROM admin_users WHERE email = $1', ['admin@pradosdenos.cl']);
    
    if (adminExists.rows.length === 0) {
      const bcrypt = require('bcrypt');
      const hashedPassword = await bcrypt.hash('admin123', 10);
      
      await client.query(`
        INSERT INTO admin_users (email, password, nombre, activo)
        VALUES ($1, $2, $3, true)
      `, ['admin@pradosdenos.cl', hashedPassword, 'Administrador']);
      
      console.log('✅ Usuario admin creado');
    } else {
      console.log('✅ Usuario admin ya existe');
    }
    
    // Crear plazas por defecto
    console.log('🏛️ Creando plazas por defecto...');
    const plazasCount = await client.query('SELECT COUNT(*) as count FROM plazas');
    
    if (parseInt(plazasCount.rows[0].count) === 0) {
      const { v4: uuidv4 } = require('uuid');
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
        `, [plaza.nombre, plaza.descripcion, uuidv4()]);
      }
      
      console.log('✅ Plazas por defecto creadas');
    } else {
      console.log('✅ Plazas ya existen');
    }
    
    client.release();
    await pool.end();
    
    console.log('\n🎉 Supabase inicializado correctamente!');
    console.log('🔗 Puedes acceder a la administración con:');
    console.log('📧 Email: admin@pradosdenos.cl');
    console.log('🔑 Password: admin123');
    
  } catch (error) {
    console.error('❌ Error inicializando Supabase:', error.message);
    console.error('🔍 Código:', error.code);
    
    if (error.code === 'ENOTFOUND') {
      console.log('\n💡 La URL de Supabase parece estar incorrecta.');
      console.log('Verifica que el proyecto esté activo y la URL sea correcta.');
    }
    
    await pool.end();
  }
}

inicializarSupabase();
