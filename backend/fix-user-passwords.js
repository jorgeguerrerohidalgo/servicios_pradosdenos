require('dotenv').config();
const bcrypt = require('bcrypt');

// Configuración de la base de datos
const poolConfig = {
    connectionString: process.env.DATABASE_URL || 'postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres',
    ssl: { rejectUnauthorized: false }
};

const { Pool } = require('pg');
const pool = new Pool(poolConfig);

async function fixUserPasswords() {
    const client = await pool.connect();
    
    try {
        console.log('🔍 Verificando y corrigiendo contraseñas...');
        
        // Verificar usuario específico
        const email = 'juan.perez@pradosdenos.com';
        const plainPassword = 'password123';
        
        console.log(`\n🔍 Buscando usuario: ${email}`);
        
        // Buscar en guardias
        const guardiaResult = await client.query('SELECT * FROM guardias WHERE email = $1', [email]);
        
        if (guardiaResult.rows.length > 0) {
            const guardia = guardiaResult.rows[0];
            console.log('👮 Usuario encontrado en guardias:', {
                id: guardia.id,
                nombre: guardia.nombre,
                email: guardia.email,
                activo: guardia.activo,
                currentPassword: guardia.password
            });
            
            // Actualizar con contraseña en texto plano (temporal para debugging)
            await client.query(
                'UPDATE guardias SET password = $1 WHERE id = $2',
                [plainPassword, guardia.id]
            );
            
            console.log('✅ Contraseña actualizada a texto plano para debugging');
        } else {
            console.log('❌ Usuario no encontrado en guardias');
        }
        
        // Buscar en admin_users
        const adminResult = await client.query('SELECT * FROM admin_users WHERE email = $1', [email]);
        
        if (adminResult.rows.length > 0) {
            const admin = adminResult.rows[0];
            console.log('👨‍💼 Usuario encontrado en admin_users:', {
                id: admin.id,
                nombre: admin.nombre,
                email: admin.email,
                currentPasswordHash: admin.password_hash
            });
            
            // Actualizar con contraseña en texto plano (temporal para debugging)
            await client.query(
                'UPDATE admin_users SET password_hash = $1 WHERE id = $2',
                [plainPassword, admin.id]
            );
            
            console.log('✅ Contraseña actualizada a texto plano para debugging');
        } else {
            console.log('❌ Usuario no encontrado en admin_users');
        }
        
        // Crear usuario si no existe
        if (guardiaResult.rows.length === 0 && adminResult.rows.length === 0) {
            console.log('🆕 Creando usuario de prueba...');
            
            await client.query(`
                INSERT INTO guardias (nombre, email, password, activo) 
                VALUES ($1, $2, $3, $4)
            `, ['Juan Pérez', email, plainPassword, true]);
            
            console.log('✅ Usuario creado en guardias');
        }
        
        // Verificar que el usuario existe después de la actualización
        const verification = await client.query('SELECT * FROM guardias WHERE email = $1', [email]);
        if (verification.rows.length > 0) {
            console.log('✅ Verificación final:', {
                id: verification.rows[0].id,
                email: verification.rows[0].email,
                password: verification.rows[0].password,
                activo: verification.rows[0].activo
            });
        }
        
    } catch (error) {
        console.error('❌ Error:', error);
    } finally {
        client.release();
        await pool.end();
    }
}

fixUserPasswords();
