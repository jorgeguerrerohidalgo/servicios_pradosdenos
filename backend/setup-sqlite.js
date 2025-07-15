const sqlite3 = require('sqlite3').verbose();
const path = require('path');
const bcrypt = require('bcrypt');

// Crear/abrir base de datos SQLite
const dbPath = path.join(__dirname, 'local_db.sqlite');
const db = new sqlite3.Database(dbPath);

// Función para ejecutar queries con Promise
function runQuery(sql, params = []) {
  return new Promise((resolve, reject) => {
    db.run(sql, params, function(err) {
      if (err) reject(err);
      else resolve({ lastID: this.lastID, changes: this.changes });
    });
  });
}

function getQuery(sql, params = []) {
  return new Promise((resolve, reject) => {
    db.get(sql, params, (err, row) => {
      if (err) reject(err);
      else resolve(row);
    });
  });
}

function allQuery(sql, params = []) {
  return new Promise((resolve, reject) => {
    db.all(sql, params, (err, rows) => {
      if (err) reject(err);
      else resolve(rows);
    });
  });
}

async function initializeSQLite() {
  console.log('🛠️  Configurando base de datos SQLite local...\n');
  
  try {
    // Crear tablas
    console.log('1. Creando tabla admin_users...');
    await runQuery(`
      CREATE TABLE IF NOT EXISTS admin_users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        nombre TEXT NOT NULL,
        activo BOOLEAN DEFAULT 1,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
    
    console.log('2. Creando tabla guardias...');
    await runQuery(`
      CREATE TABLE IF NOT EXISTS guardias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        telefono TEXT,
        password TEXT NOT NULL,
        validation_code TEXT,
        activo BOOLEAN DEFAULT 1,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        last_login DATETIME
      )
    `);
    
    console.log('3. Creando tabla plazas...');
    await runQuery(`
      CREATE TABLE IF NOT EXISTS plazas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        activa BOOLEAN DEFAULT 1,
        token TEXT UNIQUE,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
    
    console.log('4. Creando tabla checkins...');
    await runQuery(`
      CREATE TABLE IF NOT EXISTS checkins (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        guardia_id INTEGER,
        plaza_id INTEGER,
        fecha_checkin DATETIME DEFAULT CURRENT_TIMESTAMP,
        observaciones TEXT,
        FOREIGN KEY (guardia_id) REFERENCES guardias(id),
        FOREIGN KEY (plaza_id) REFERENCES plazas(id)
      )
    `);
    
    console.log('5. Creando tabla eventos...');
    await runQuery(`
      CREATE TABLE IF NOT EXISTS eventos (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        descripcion TEXT,
        fecha_evento DATETIME NOT NULL,
        ubicacion TEXT,
        tipo TEXT DEFAULT 'general',
        activo BOOLEAN DEFAULT 1,
        created_by TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (created_by) REFERENCES admin_users(id)
      )
    `);
    
    console.log('6. Creando tabla documentos...');
    await runQuery(`
      CREATE TABLE IF NOT EXISTS documentos (
        id TEXT PRIMARY KEY,
        titulo TEXT NOT NULL,
        descripcion TEXT,
        archivo_nombre TEXT NOT NULL,
        archivo_ruta TEXT NOT NULL,
        archivo_tamaño INTEGER,
        tipo TEXT DEFAULT 'general',
        activo BOOLEAN DEFAULT 1,
        created_by TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (created_by) REFERENCES admin_users(id)
      )
    `);
    
    // Crear usuario admin por defecto
    console.log('7. Creando usuario admin por defecto...');
    const adminExists = await getQuery('SELECT * FROM admin_users WHERE email = ?', ['admin@pradosdenos.cl']);
    
    if (!adminExists) {
      const { v4: uuidv4 } = require('uuid');
      const hashedPassword = await bcrypt.hash('admin123', 10);
      
      await runQuery(`
        INSERT INTO admin_users (id, email, password, nombre, activo)
        VALUES (?, ?, ?, ?, 1)
      `, [uuidv4(), 'admin@pradosdenos.cl', hashedPassword, 'Administrador']);
      
      console.log('✅ Usuario admin creado');
    } else {
      console.log('✅ Usuario admin ya existe');
    }
    
    // Crear plazas por defecto
    console.log('8. Creando plazas por defecto...');
    const plazasCount = await getQuery('SELECT COUNT(*) as count FROM plazas');
    
    if (plazasCount.count === 0) {
      const { v4: uuidv4 } = require('uuid');
      const plazasDefault = [
        { nombre: 'Plaza Principal', descripcion: 'Plaza de acceso principal del conjunto' },
        { nombre: 'Plaza Norte', descripcion: 'Plaza sector norte' },
        { nombre: 'Plaza Sur', descripcion: 'Plaza sector sur' },
        { nombre: 'Plaza Este', descripcion: 'Plaza sector este' },
        { nombre: 'Plaza Oeste', descripcion: 'Plaza sector oeste' }
      ];
      
      for (const plaza of plazasDefault) {
        await runQuery(`
          INSERT INTO plazas (nombre, descripcion, token)
          VALUES (?, ?, ?)
        `, [plaza.nombre, plaza.descripcion, uuidv4()]);
      }
      
      console.log('✅ Plazas por defecto creadas');
    } else {
      console.log('✅ Plazas ya existen');
    }
    
    console.log('\n🎉 Base de datos SQLite configurada correctamente!');
    console.log('📍 Ubicación:', dbPath);
    console.log('🔗 Accede a la administración en: http://localhost:3000/admin-login.html');
    console.log('📧 Email: admin@pradosdenos.cl');
    console.log('🔑 Password: admin123');
    
  } catch (error) {
    console.error('❌ Error configurando SQLite:', error);
  } finally {
    db.close();
  }
}

// Ejecutar inicialización
initializeSQLite().then(() => {
  console.log('\n✅ Configuración SQLite completada');
  process.exit(0);
}).catch((error) => {
  console.error('❌ Error fatal:', error);
  process.exit(1);
});
