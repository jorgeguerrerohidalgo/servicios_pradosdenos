require('dotenv').config();

const { Pool } = require('pg');

const pool = new Pool({
    connectionString: process.env.DATABASE_URL || 'postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres',
    ssl: { rejectUnauthorized: false }
});

async function createAdminUser() {
    const client = await pool.connect();
    
    try {
        console.log('🔍 Creando usuario admin...');
        
        const adminEmail = 'jorgeguerrerohidalgo@gmail.com';
        const adminPassword = 'madneo710';
        
        // Eliminar admin existente si existe
        const deleteResult = await client.query('DELETE FROM admin_users WHERE email = $1', [adminEmail]);
        console.log(`🗑️ Eliminados ${deleteResult.rowCount} registros admin existentes`);
        
        // Crear admin con todos los campos requeridos
        const adminResult = await client.query(`
            INSERT INTO admin_users (nombre, apellido_paterno, apellido_materno, run, email, password_hash, activo) 
            VALUES ($1, $2, $3, $4, $5, $6, $7) 
            RETURNING id, nombre, apellido_paterno, email, activo
        `, ['Jorge', 'Guerrero', 'Hidalgo', '12345678-9', adminEmail, adminPassword, true]);
        
        console.log('✅ Admin creado exitosamente:', adminResult.rows[0]);
        
        // Verificar que se creó correctamente
        const verifyResult = await client.query('SELECT * FROM admin_users WHERE email = $1', [adminEmail]);
        console.log('✅ Verificación:', {
            id: verifyResult.rows[0].id,
            nombre: verifyResult.rows[0].nombre,
            apellido_paterno: verifyResult.rows[0].apellido_paterno,
            email: verifyResult.rows[0].email,
            run: verifyResult.rows[0].run,
            activo: verifyResult.rows[0].activo,
            password_hash: verifyResult.rows[0].password_hash
        });
        
        console.log('\n🎯 Credenciales admin configuradas:');
        console.log(`Email: ${adminEmail}`);
        console.log(`Password: ${adminPassword}`);
        
    } catch (error) {
        console.error('❌ Error creando admin:', error);
    } finally {
        client.release();
        await pool.end();
    }
}

createAdminUser();
