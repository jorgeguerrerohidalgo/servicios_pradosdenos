const db = require('./utils/db');

async function checkUsers() {
    try {
        console.log('=== VERIFICANDO USUARIOS EN ADMIN_USERS ===');
        const adminUsers = await db.query('SELECT id, email, activo, password_hash FROM admin_users ORDER BY id');
        console.log('Admin users found:', adminUsers.rows.length);
        adminUsers.rows.forEach(user => {
            console.log(`- ID: ${user.id}, Email: ${user.email}, Activo: ${user.activo}, HasPassword: ${!!user.password_hash}`);
        });

        console.log('\n=== VERIFICANDO USUARIOS EN GUARDIAS ===');
        const guardias = await db.query('SELECT id, email, activo, password FROM guardias ORDER BY id LIMIT 5');
        console.log('Guardias found:', guardias.rows.length);
        guardias.rows.forEach(user => {
            console.log(`- ID: ${user.id}, Email: ${user.email}, Activo: ${user.activo}, HasPassword: ${!!user.password}`);
        });

        process.exit(0);
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

checkUsers();
