
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

function createLocalDatabase() {
    console.log('📱 Creando base de datos local...');
    
    const db = new sqlite3.Database('./checkin_local.db');
    
    db.serialize(() => {
        // Crear tablas básicas
        db.run(`
            CREATE TABLE IF NOT EXISTS plazas (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nombre TEXT NOT NULL,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        `);
        
        db.run(`
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
        `);
        
        db.run(`
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
        `);
        
        db.run(`
            CREATE TABLE IF NOT EXISTS security_logs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                ip_address TEXT NOT NULL,
                event_type TEXT NOT NULL,
                details TEXT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        `);
        
        db.run(`
            CREATE TABLE IF NOT EXISTS checkins (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                guardia_id INTEGER NOT NULL,
                plaza_id INTEGER NOT NULL,
                fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (guardia_id) REFERENCES guardias(id),
                FOREIGN KEY (plaza_id) REFERENCES plazas(id)
            )
        `);
        
        // Insertar datos de prueba
        db.run("INSERT OR IGNORE INTO plazas (nombre) VALUES ('Plaza Norte')");
        db.run("INSERT OR IGNORE INTO plazas (nombre) VALUES ('Plaza Sur')");
        
        db.run(`
            INSERT OR IGNORE INTO admin_users 
            (nombre, apellido_paterno, apellido_materno, run, email, fecha_nacimiento, direccion, plaza_id, password_hash)
            VALUES 
            ('Admin', 'Sistema', 'Local', '11.111.111-1', 'admin@pradosdenos.cl', '1990-01-01', 'Local', 1, '$2b$12$LQv3c1yqBwlVHpfqRQ0Q0.JHjmxrZJzNhPVqUgTfCOdXYRqvgG.Be')
        `);
        
        db.run(`
            INSERT OR IGNORE INTO guardias 
            (nombre, rut, email, password)
            VALUES 
            ('Guardia Local', '22.222.222-2', 'guardia@pradosdenos.cl', '$2b$12$LQv3c1yqBwlVHpfqRQ0Q0.JHjmxrZJzNhPVqUgTfCOdXYRqvgG.Be')
        `);
        
        console.log('✅ Base de datos local creada con datos de prueba');
        console.log('👤 Admin: admin@pradosdenos.cl / admin123');
        console.log('🛡️  Guardia: guardia@pradosdenos.cl / guardia123');
    });
    
    db.close();
}

createLocalDatabase();
