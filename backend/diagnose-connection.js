const { Client } = require('pg');
require('dotenv').config();

async function diagnosticConnection() {
    console.log('🔍 DIAGNÓSTICO COMPLETO DE CONEXIÓN');
    console.log('=====================================');
    
    console.log('📋 Variables de entorno:');
    console.log(`   NODE_ENV: ${process.env.NODE_ENV}`);
    console.log(`   DATABASE_URL: ${process.env.DATABASE_URL ? 'Configurado' : 'No configurado'}`);
    console.log(`   URL (parcial): ${process.env.DATABASE_URL ? process.env.DATABASE_URL.substring(0, 50) + '...' : 'N/A'}`);
    
    if (!process.env.DATABASE_URL) {
        console.log('❌ DATABASE_URL no está configurado');
        return false;
    }
    
    console.log('\n🔗 Intentando conexión...');
    
    const client = new Client({
        connectionString: process.env.DATABASE_URL,
        ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
        connectionTimeoutMillis: 5000,
        query_timeout: 10000,
        statement_timeout: 10000
    });
    
    try {
        await client.connect();
        console.log('✅ Conexión exitosa');
        
        // Test básico
        const result = await client.query('SELECT NOW() as current_time, current_database() as database');
        console.log(`⏰ Tiempo actual: ${result.rows[0].current_time}`);
        console.log(`📊 Base de datos: ${result.rows[0].database}`);
        
        // Verificar tablas
        const tables = await client.query(`
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            ORDER BY table_name
        `);
        
        console.log(`\n📋 Tablas encontradas (${tables.rows.length}):`,);
        tables.rows.forEach(row => {
            console.log(`  - ${row.table_name}`);
        });
        
        return true;
        
    } catch (error) {
        console.log('❌ Error de conexión:', error.message);
        console.log('🔧 Detalles del error:');
        console.log(`   Código: ${error.code}`);
        console.log(`   Host: ${error.address || 'N/A'}`);
        console.log(`   Puerto: ${error.port || 'N/A'}`);
        
        return false;
    } finally {
        try {
            await client.end();
        } catch (e) {
            // Ignorar errores de cierre
        }
    }
}

async function createLocalFallback() {
    console.log('\n🔄 Creando configuración local de respaldo...');
    
    // Crear archivo de configuración local
    const localConfig = `
# Configuración local de respaldo
NODE_ENV=development
PORT=3000

# Base de datos local SQLite (respaldo)
DATABASE_URL=sqlite:./checkin_local.db

# Configuración de sesiones
SESSION_SECRET=local_dev_secret_12345

# Configuración de tokens
JWT_SECRET=local_dev_jwt_secret_12345

# Configuración de fechas
TIMEZONE=America/Santiago

# Configuración de logging
LOG_LEVEL=debug
`;
    
    require('fs').writeFileSync('.env.local', localConfig);
    console.log('✅ Archivo .env.local creado');
    
    // Crear script de base de datos local
    const localDbScript = `
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

function createLocalDatabase() {
    console.log('📱 Creando base de datos local...');
    
    const db = new sqlite3.Database('./checkin_local.db');
    
    db.serialize(() => {
        // Crear tablas básicas
        db.run(\`
            CREATE TABLE IF NOT EXISTS plazas (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nombre TEXT NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        \`);
        
        db.run(\`
            CREATE TABLE IF NOT EXISTS guardias (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nombre TEXT NOT NULL,
                rut TEXT NOT NULL UNIQUE,
                email TEXT NOT NULL UNIQUE,
                password TEXT NOT NULL,
                activo BOOLEAN DEFAULT 1,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                last_login DATETIME
            )
        \`);
        
        db.run(\`
            CREATE TABLE IF NOT EXISTS admin_users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nombre TEXT NOT NULL,
                apellido_paterno TEXT NOT NULL,
                apellido_materno TEXT NOT NULL,
                run TEXT NOT NULL UNIQUE,
                email TEXT NOT NULL UNIQUE,
                fecha_nacimiento DATE NOT NULL,
                direccion TEXT NOT NULL,
                plaza_id INTEGER NOT NULL,
                password_hash TEXT NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (plaza_id) REFERENCES plazas(id)
            )
        \`);
        
        db.run(\`
            CREATE TABLE IF NOT EXISTS security_logs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                ip_address TEXT NOT NULL,
                event_type TEXT NOT NULL,
                details TEXT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        \`);
        
        db.run(\`
            CREATE TABLE IF NOT EXISTS checkins (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                guardia_id INTEGER NOT NULL,
                plaza_id INTEGER NOT NULL,
                fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (guardia_id) REFERENCES guardias(id),
                FOREIGN KEY (plaza_id) REFERENCES plazas(id)
            )
        \`);
        
        // Insertar datos de prueba
        db.run("INSERT OR IGNORE INTO plazas (nombre) VALUES ('Plaza Norte')");
        db.run("INSERT OR IGNORE INTO plazas (nombre) VALUES ('Plaza Sur')");
        
        db.run(\`
            INSERT OR IGNORE INTO admin_users 
            (nombre, apellido_paterno, apellido_materno, run, email, fecha_nacimiento, direccion, plaza_id, password_hash)
            VALUES 
            ('Admin', 'Sistema', 'Local', '11.111.111-1', 'admin@pradosdenos.cl', '1990-01-01', 'Local', 1, '$2b$12$LQv3c1yqBwlVHpfqRQ0Q0.JHjmxrZJzNhPVqUgTfCOdXYRqvgG.Be')
        \`);
        
        db.run(\`
            INSERT OR IGNORE INTO guardias 
            (nombre, rut, email, password)
            VALUES 
            ('Guardia Local', '22.222.222-2', 'guardia@pradosdenos.cl', '$2b$12$LQv3c1yqBwlVHpfqRQ0Q0.JHjmxrZJzNhPVqUgTfCOdXYRqvgG.Be')
        \`);
        
        console.log('✅ Base de datos local creada con datos de prueba');
        console.log('👤 Admin: admin@pradosdenos.cl / admin123');
        console.log('🛡️  Guardia: guardia@pradosdenos.cl / guardia123');
    });
    
    db.close();
}

createLocalDatabase();
`;
    
    require('fs').writeFileSync('create-local-db.js', localDbScript);
    console.log('✅ Script de base de datos local creado');
}

async function main() {
    const connected = await diagnosticConnection();
    
    if (!connected) {
        console.log('\n💡 RECOMENDACIONES:');
        console.log('1. Verifica que tu proyecto de Supabase esté activo');
        console.log('2. Confirma que la URL de conexión sea correcta');
        console.log('3. Revisa que las credenciales sean válidas');
        console.log('4. Considera usar la configuración local temporal');
        
        await createLocalFallback();
        
        console.log('\n🔄 Para usar la configuración local:');
        console.log('1. Copia .env.local a .env');
        console.log('2. Ejecuta: npm install sqlite3');
        console.log('3. Ejecuta: node create-local-db.js');
        console.log('4. Inicia el servidor: npm start');
    }
}

main();
