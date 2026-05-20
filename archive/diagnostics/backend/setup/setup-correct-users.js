require('dotenv').config();

const { Pool } = require('pg');

const pool = new Pool({
    connectionString: process.env.DATABASE_URL || 'postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres',
    ssl: { rejectUnauthorized: false }
});

async function setupCorrectUsers() {
    const client = await pool.connect();
    
    try {
        console.log('🔍 Configurando usuarios con credenciales correctas...');
        
        // Credenciales específicas del usuario
        const adminEmail = 'jorgeguerrerohidalgo@gmail.com';
        const adminPassword = 'madneo710';
        const guardiaEmail = 'juan.perez@pradosdenos.com';
        const guardiaPassword = 'prueba123';
        
        // Eliminar usuarios existentes para evitar conflictos
        await client.query('DELETE FROM guardias WHERE email = $1', [guardiaEmail]);
        await client.query('DELETE FROM admin_users WHERE email = $1', [adminEmail]);
        
        console.log('🗑️ Usuarios existentes eliminados');
        
        // Crear guardia con credenciales correctas
        const guardiaResult = await client.query(`
            INSERT INTO guardias (nombre, email, password, activo) 
            VALUES ($1, $2, $3, $4) 
            RETURNING id, nombre, email, activo
        `, ['Juan Pérez', guardiaEmail, guardiaPassword, true]);
        
        console.log('✅ Guardia creado:', guardiaResult.rows[0]);
        
        // Crear admin con credenciales correctas
        const adminResult = await client.query(`
            INSERT INTO admin_users (nombre, apellido_paterno, apellido_materno, run, email, password_hash, activo) 
            VALUES ($1, $2, $3, $4, $5, $6, $7) 
            RETURNING id, nombre, apellido_paterno, email
        `, ['Jorge', 'Guerrero', 'Hidalgo', '12345678-9', adminEmail, adminPassword, true]);
        
        console.log('✅ Admin creado:', adminResult.rows[0]);
        
        console.log('\n🎯 Credenciales configuradas:');
        console.log(`Admin: ${adminEmail} / ${adminPassword}`);
        console.log(`Guardia: ${guardiaEmail} / ${guardiaPassword}`);
        
        // Verificar que los usuarios fueron creados correctamente
        const verifyGuardia = await client.query('SELECT * FROM guardias WHERE email = $1', [guardiaEmail]);
        const verifyAdmin = await client.query('SELECT * FROM admin_users WHERE email = $1', [adminEmail]);
        
        console.log('\n✅ Verificación:');
        console.log('Guardia en DB:', verifyGuardia.rows[0]);
        console.log('Admin en DB:', verifyAdmin.rows[0]);
        
    } catch (error) {
        console.error('❌ Error configurando usuarios:', error);
    } finally {
        client.release();
        await pool.end();
    }
}

setupCorrectUsers();
