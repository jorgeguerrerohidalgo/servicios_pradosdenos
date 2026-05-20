const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

async function runMigrations() {
    console.log('üîÑ Ejecutando migraciones...');
ECHO est† desactivado.
    const client = new Client({
        connectionString: process.env.DATABASE_URL,
        ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
    });
ECHO est† desactivado.
    try {
        await client.connect();
        console.log('‚úÖ Conectado a la base de datos');
ECHO est† desactivado.
        // Leer script de configuraci√≥n completa
        const sqlScript = fs.readFileSync(path.join(__dirname, '..', 'supabase_complete_setup.sql'), 'utf8');
ECHO est† desactivado.
        // Ejecutar script
        await client.query(sqlScript);
        console.log('‚úÖ Migraciones ejecutadas correctamente');
ECHO est† desactivado.
        // Verificar tablas
        const result = await client.query(`
            SELECT table_name
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name IN ('plazas', 'plaza_tokens', 'guardias', 'admin_users', 'checkins', 'security_logs', 'eventos', 'documentos')
            ORDER BY table_name
        `);
ECHO est† desactivado.
        console.log('\nüìã Tablas verificadas:');
        result.rows.forEach(row => {
            console.log(`  ‚úÖ ${row.table_name}`);
        });
ECHO est† desactivado.
    } catch (error) {
        console.error('‚ùå Error ejecutando migraciones:', error.message);
        process.exit(1);
    } finally {
        await client.end();
    }
}

runMigrations();
