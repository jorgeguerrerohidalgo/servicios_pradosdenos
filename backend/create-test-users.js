require('dotenv').config();

const { Pool } = require('pg');

const pool = new Pool({
    connectionString: process.env.DATABASE_URL || 'postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres',
    ssl: { rejectUnauthorized: false }
});

async function createTestUsers() {
    const client = await pool.connect();
    
    try {
        console.log('🔍 Creando usuarios de prueba...');
        
        // Eliminar usuarios existentes para evitar conflictos
        await client.query('DELETE FROM guardias WHERE email = $1', ['juan.perez@pradosdenos.com']);
        await client.query('DELETE FROM admin_users WHERE email = $1', ['admin@pradosdenos.com']);
        
        // Crear guardia de prueba
        const guardiaResult = await client.query(`
            INSERT INTO guardias (nombre, email, password, activo) 
            VALUES ($1, $2, $3, $4) 
            RETURNING id, nombre, email, activo
        `, ['Juan Pérez', 'juan.perez@pradosdenos.com', 'password123', true]);
        
        console.log('✅ Guardia creado:', guardiaResult.rows[0]);
        
        // Crear admin de prueba
        const adminResult = await client.query(`
            INSERT INTO admin_users (nombre, apellido_paterno, apellido_materno, email, password_hash) 
            VALUES ($1, $2, $3, $4, $5) 
            RETURNING id, nombre, apellido_paterno, email
        `, ['Admin', 'Sistema', 'Prados', 'admin@pradosdenos.com', 'password123']);
        
        console.log('✅ Admin creado:', adminResult.rows[0]);
        
        console.log('\n🎯 Credenciales de prueba:');
        console.log('Guardia: juan.perez@pradosdenos.com / password123');
        console.log('Admin: admin@pradosdenos.com / password123');
        
    } catch (error) {
        console.error('❌ Error:', error);
    } finally {
        client.release();
        await pool.end();
    }
}

createTestUsers();
