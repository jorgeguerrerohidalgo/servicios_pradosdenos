require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
    connectionString: process.env.DATABASE_URL || 'postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres',
    ssl: { rejectUnauthorized: false }
});

async function diagnosticDatabase() {
    const client = await pool.connect();
    
    try {
        console.log('🔍 Diagnóstico completo de la base de datos...\n');
        
        // 1. Verificar conexión
        const timeResult = await client.query('SELECT NOW() as current_time');
        console.log('✅ Conexión exitosa:', timeResult.rows[0].current_time);
        
        // 2. Verificar existencia de tablas
        const tablesResult = await client.query(`
            SELECT table_name, table_schema 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name IN ('guardias', 'admin_users')
            ORDER BY table_name
        `);
        
        console.log('\n📋 Tablas encontradas:');
        tablesResult.rows.forEach(row => {
            console.log(`  - ${row.table_name}`);
        });
        
        // 3. Verificar estructura de tabla guardias
        if (tablesResult.rows.some(r => r.table_name === 'guardias')) {
            const guardiasColumns = await client.query(`
                SELECT column_name, data_type, is_nullable
                FROM information_schema.columns 
                WHERE table_name = 'guardias' 
                AND table_schema = 'public'
                ORDER BY ordinal_position
            `);
            
            console.log('\n👮 Estructura tabla guardias:');
            guardiasColumns.rows.forEach(col => {
                console.log(`  - ${col.column_name}: ${col.data_type} (${col.is_nullable === 'YES' ? 'nullable' : 'not null'})`);
            });
            
            // Contar registros
            const guardiaCount = await client.query('SELECT COUNT(*) FROM guardias');
            console.log(`\n📊 Registros en guardias: ${guardiaCount.rows[0].count}`);
            
            // Mostrar algunos registros
            const guardiasSample = await client.query('SELECT id, nombre, email, activo FROM guardias LIMIT 3');
            console.log('\n👀 Muestra de guardias:');
            guardiasSample.rows.forEach(g => {
                console.log(`  - ID: ${g.id}, Nombre: ${g.nombre}, Email: ${g.email}, Activo: ${g.activo}`);
            });
        }
        
        // 4. Verificar estructura de tabla admin_users
        if (tablesResult.rows.some(r => r.table_name === 'admin_users')) {
            const adminColumns = await client.query(`
                SELECT column_name, data_type, is_nullable
                FROM information_schema.columns 
                WHERE table_name = 'admin_users' 
                AND table_schema = 'public'
                ORDER BY ordinal_position
            `);
            
            console.log('\n👨‍💼 Estructura tabla admin_users:');
            adminColumns.rows.forEach(col => {
                console.log(`  - ${col.column_name}: ${col.data_type} (${col.is_nullable === 'YES' ? 'nullable' : 'not null'})`);
            });
            
            // Contar registros
            const adminCount = await client.query('SELECT COUNT(*) FROM admin_users');
            console.log(`\n📊 Registros en admin_users: ${adminCount.rows[0].count}`);
            
            // Mostrar algunos registros
            const adminSample = await client.query('SELECT id, nombre, apellido_paterno, email FROM admin_users LIMIT 3');
            console.log('\n👀 Muestra de admin_users:');
            adminSample.rows.forEach(a => {
                console.log(`  - ID: ${a.id}, Nombre: ${a.nombre} ${a.apellido_paterno}, Email: ${a.email}`);
            });
        }
        
        // 5. Buscar usuarios específicos
        console.log('\n🔍 Buscando usuarios específicos...');
        
        const specificGuardia = await client.query('SELECT * FROM guardias WHERE email = $1', ['juan.perez@pradosdenos.com']);
        if (specificGuardia.rows.length > 0) {
            console.log('✅ Guardia encontrado:', specificGuardia.rows[0]);
        } else {
            console.log('❌ Guardia juan.perez@pradosdenos.com NO encontrado');
        }
        
        const specificAdmin = await client.query('SELECT * FROM admin_users WHERE email = $1', ['jorgeguerrerohidalgo@gmail.com']);
        if (specificAdmin.rows.length > 0) {
            console.log('✅ Admin encontrado:', specificAdmin.rows[0]);
        } else {
            console.log('❌ Admin jorgeguerrerohidalgo@gmail.com NO encontrado');
        }
        
    } catch (error) {
        console.error('❌ Error en diagnóstico:', error);
        console.error('Stack:', error.stack);
    } finally {
        client.release();
        await pool.end();
    }
}

diagnosticDatabase();
