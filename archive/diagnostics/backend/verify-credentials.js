const db = require('./utils/db');

async function verificarCredenciales() {
    try {
        console.log('🔍 Verificando credenciales en la base de datos...');
        
        // Verificar tabla guardias
        const guardias = await db.query('SELECT id, nombre, email, password, activo FROM guardias LIMIT 5');
        console.log('👮 GUARDIAS encontrados:', guardias.length);
        guardias.forEach(g => {
            console.log(`  - ID: ${g.id}, Email: ${g.email}, Nombre: ${g.nombre}, Activo: ${g.activo}, HasPassword: ${!!g.password}`);
        });
        
        // Verificar tabla admin_users
        const admins = await db.query('SELECT id, nombre, apellido_paterno, email, password_hash FROM admin_users LIMIT 5');
        console.log('👨‍💼 ADMIN_USERS encontrados:', admins.length);
        admins.forEach(a => {
            console.log(`  - ID: ${a.id}, Email: ${a.email}, Nombre: ${a.nombre} ${a.apellido_paterno}, HasPassword: ${!!a.password_hash}`);
        });
        
        // Buscar específicamente el usuario que está intentando hacer login
        const email = 'juan.perez@pradosdenos.com';
        console.log(`\n🔍 Buscando específicamente: ${email}`);
        
        const guardiaSpecific = await db.query('SELECT * FROM guardias WHERE email = $1', [email]);
        console.log('👮 Guardia específico:', guardiaSpecific.length > 0 ? guardiaSpecific[0] : 'No encontrado');
        
        const adminSpecific = await db.query('SELECT * FROM admin_users WHERE email = $1', [email]);
        console.log('👨‍💼 Admin específico:', adminSpecific.length > 0 ? adminSpecific[0] : 'No encontrado');
        
    } catch (error) {
        console.error('❌ Error verificando credenciales:', error);
    }
}

verificarCredenciales();
