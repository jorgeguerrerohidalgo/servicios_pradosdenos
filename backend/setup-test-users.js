const bcrypt = require('bcrypt');
const { Client } = require('pg');

async function setupTestUsers() {
    console.log('üë• Configurando usuarios de prueba...');
ECHO est† desactivado.
    const client = new Client({
        connectionString: process.env.DATABASE_URL,
        ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
    });
ECHO est† desactivado.
    try {
        await client.connect();
ECHO est† desactivado.
        // Hash de contrase√±as
        const adminPassword = await bcrypt.hash('admin123', 12);
        const guardiaPassword = await bcrypt.hash('guardia123', 12);
ECHO est† desactivado.
        // Insertar admin
        await client.query(`
            INSERT INTO admin_users (nombre, apellido_paterno, apellido_materno, run, email, fecha_nacimiento, direccion, plaza_id, password_hash)
            VALUES ('Admin', 'Sistema', 'Principal', '11.111.111-1', 'admin@pradosdenos.cl', '1990-01-01', 'Centro de Control', 1, $1)
            ON CONFLICT (email) DO UPDATE SET password_hash = $1
        `, [adminPassword]);
ECHO est† desactivado.
        // Insertar guardia
        await client.query(`
            INSERT INTO guardias (nombre, rut, email, password, telefono)
            VALUES ('Guardia', '22.222.222-2', 'guardia@pradosdenos.cl', $1, '+56912345678')
            ON CONFLICT (email) DO UPDATE SET password = $1
        `, [guardiaPassword]);
ECHO est† desactivado.
        console.log('‚úÖ Usuarios de prueba configurados:');
        console.log('  üë§ Admin: admin@pradosdenos.cl / admin123');
        console.log('  üõ°Ô∏è  Guardia: guardia@pradosdenos.cl / guardia123');
ECHO est† desactivado.
    } catch (error) {
        console.error('‚ùå Error configurando usuarios:', error.message);
        process.exit(1);
    } finally {
        await client.end();
    }
}

setupTestUsers();
