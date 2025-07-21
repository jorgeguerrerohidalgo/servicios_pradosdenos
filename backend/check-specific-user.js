const db = require('./utils/db');
const bcrypt = require('bcrypt');

async function checkSpecificUser() {
    const email = 'jorgeguerrerohidalgo@gmail.com';
    const password = 'madneo710';
    
    try {
        console.log('=== VERIFICANDO USUARIO ESPECÍFICO ===');
        console.log('Email:', email);
        console.log('Password:', password);
        
        // Buscar en admin_users
        console.log('\n--- Buscando en admin_users ---');
        const adminResult = await db.query('SELECT * FROM admin_users WHERE email = $1', [email]);
        console.log('Resultados en admin_users:', adminResult.rows.length);
        
        if (adminResult.rows.length > 0) {
            const user = adminResult.rows[0];
            console.log('Usuario encontrado en admin_users:');
            console.log('- ID:', user.id);
            console.log('- Email:', user.email);
            console.log('- Activo:', user.activo);
            console.log('- Nombre:', user.nombre);
            console.log('- Password_hash existe:', !!user.password_hash);
            console.log('- Password_hash length:', user.password_hash ? user.password_hash.length : 0);
            
            if (user.password_hash) {
                // Probar bcrypt
                try {
                    const bcryptMatch = await bcrypt.compare(password, user.password_hash);
                    console.log('- Bcrypt match:', bcryptMatch);
                } catch (bcryptError) {
                    console.log('- Bcrypt error:', bcryptError.message);
                }
                
                // Probar comparación directa
                const directMatch = (user.password_hash === password);
                console.log('- Direct match:', directMatch);
            }
        }
        
        // Buscar en guardias
        console.log('\n--- Buscando en guardias ---');
        const guardiaResult = await db.query('SELECT * FROM guardias WHERE email = $1', [email]);
        console.log('Resultados en guardias:', guardiaResult.rows.length);
        
        if (guardiaResult.rows.length > 0) {
            const user = guardiaResult.rows[0];
            console.log('Usuario encontrado en guardias:');
            console.log('- ID:', user.id);
            console.log('- Email:', user.email);
            console.log('- Activo:', user.activo);
            console.log('- Nombre:', user.nombre);
            console.log('- Password existe:', !!user.password);
            console.log('- Password length:', user.password ? user.password.length : 0);
            
            if (user.password) {
                // Probar bcrypt
                try {
                    const bcryptMatch = await bcrypt.compare(password, user.password);
                    console.log('- Bcrypt match:', bcryptMatch);
                } catch (bcryptError) {
                    console.log('- Bcrypt error:', bcryptError.message);
                }
                
                // Probar comparación directa
                const directMatch = (user.password === password);
                console.log('- Direct match:', directMatch);
            }
        }
        
        if (adminResult.rows.length === 0 && guardiaResult.rows.length === 0) {
            console.log('\n❌ Usuario no encontrado en ninguna tabla');
            
            // Buscar emails similares
            console.log('\n--- Buscando emails similares ---');
            const similarEmails = await db.query('SELECT email FROM admin_users WHERE email ILIKE $1 UNION SELECT email FROM guardias WHERE email ILIKE $1', [`%${email.split('@')[0]}%`]);
            console.log('Emails similares encontrados:', similarEmails.rows);
        }
        
        process.exit(0);
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

checkSpecificUser();
