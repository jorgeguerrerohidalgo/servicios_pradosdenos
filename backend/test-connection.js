const { Client } = require('pg');
require('dotenv').config();

async function testConnection() {
    console.log('🔍 Probando conexión a la base de datos...');
    console.log('==========================================');
    
    const client = new Client({
        connectionString: process.env.DATABASE_URL,
        ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
    });
    
    try {
        // Conectar
        await client.connect();
        console.log('✅ Conexión exitosa a la base de datos');
        
        // Verificar zona horaria
        const timezoneResult = await client.query('SHOW timezone;');
        console.log(`⏰ Zona horaria: ${timezoneResult.rows[0].TimeZone}`);
        
        // Verificar tablas principales
        const tablesResult = await client.query(`
            SELECT table_name, 
                   (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name AND table_schema = 'public') as column_count
            FROM information_schema.tables t
            WHERE table_schema = 'public' 
            AND table_name IN ('plazas', 'plaza_tokens', 'guardias', 'admin_users', 'checkins', 'security_logs', 'eventos', 'documentos', 'categorias_documentos')
            ORDER BY table_name
        `);
        
        console.log('\n📋 Tablas verificadas:');
        if (tablesResult.rows.length === 0) {
            console.log('❌ No se encontraron las tablas principales');
            console.log('   Ejecuta: npm run migrate');
        } else {
            tablesResult.rows.forEach(row => {
                console.log(`  ✅ ${row.table_name} (${row.column_count} columnas)`);
            });
        }
        
        // Verificar datos de prueba
        const adminResult = await client.query("SELECT COUNT(*) as count FROM admin_users WHERE email = 'admin@pradosdenos.cl'");
        const guardiaResult = await client.query("SELECT COUNT(*) as count FROM guardias WHERE email = 'guardia@pradosdenos.cl'");
        const plazasResult = await client.query("SELECT COUNT(*) as count FROM plazas");
        
        console.log('\n👥 Usuarios de prueba:');
        console.log(`  ${adminResult.rows[0].count > 0 ? '✅' : '❌'} Admin (admin@pradosdenos.cl)`);
        console.log(`  ${guardiaResult.rows[0].count > 0 ? '✅' : '❌'} Guardia (guardia@pradosdenos.cl)`);
        
        console.log('\n🏢 Datos del sistema:');
        console.log(`  📍 Plazas: ${plazasResult.rows[0].count}`);
        
        // Verificar últimos checkins
        const checkinsResult = await client.query(`
            SELECT COUNT(*) as count, 
                   MAX(fecha) as ultimo_checkin 
            FROM checkins 
            WHERE fecha > NOW() - INTERVAL '7 days'
        `);
        
        console.log(`  📝 Check-ins (últimos 7 días): ${checkinsResult.rows[0].count}`);
        if (checkinsResult.rows[0].ultimo_checkin) {
            console.log(`  🕐 Último check-in: ${checkinsResult.rows[0].ultimo_checkin}`);
        }
        
        // Verificar logs de seguridad
        const securityLogsResult = await client.query(`
            SELECT COUNT(*) as count, 
                   COUNT(DISTINCT event_type) as tipos_eventos
            FROM security_logs 
            WHERE created_at > NOW() - INTERVAL '24 hours'
        `);
        
        console.log(`  🔒 Logs de seguridad (últimas 24h): ${securityLogsResult.rows[0].count}`);
        console.log(`  📊 Tipos de eventos: ${securityLogsResult.rows[0].tipos_eventos}`);
        
        // Verificar índices importantes
        const indexesResult = await client.query(`
            SELECT tablename, indexname
            FROM pg_indexes 
            WHERE schemaname = 'public' 
            AND tablename IN ('security_logs', 'checkins', 'guardias', 'admin_users')
            ORDER BY tablename, indexname
        `);
        
        console.log('\n🔍 Índices de rendimiento:');
        let currentTable = '';
        indexesResult.rows.forEach(row => {
            if (row.tablename !== currentTable) {
                currentTable = row.tablename;
                console.log(`  📊 ${row.tablename}:`);
            }
            console.log(`    - ${row.indexname}`);
        });
        
        // Test de autenticación
        console.log('\n🔐 Probando autenticación...');
        
        const adminAuth = await client.query(`
            SELECT id, nombre, email, password_hash 
            FROM admin_users 
            WHERE email = 'admin@pradosdenos.cl'
        `);
        
        const guardiaAuth = await client.query(`
            SELECT id, nombre, email, password 
            FROM guardias 
            WHERE email = 'guardia@pradosdenos.cl'
        `);
        
        if (adminAuth.rows.length > 0) {
            console.log('  ✅ Usuario admin encontrado');
            console.log(`     ID: ${adminAuth.rows[0].id}`);
            console.log(`     Nombre: ${adminAuth.rows[0].nombre}`);
            console.log(`     Hash: ${adminAuth.rows[0].password_hash ? 'Configurado' : 'No configurado'}`);
        } else {
            console.log('  ❌ Usuario admin no encontrado');
        }
        
        if (guardiaAuth.rows.length > 0) {
            console.log('  ✅ Usuario guardia encontrado');
            console.log(`     ID: ${guardiaAuth.rows[0].id}`);
            console.log(`     Nombre: ${guardiaAuth.rows[0].nombre}`);
            console.log(`     Hash: ${guardiaAuth.rows[0].password ? 'Configurado' : 'No configurado'}`);
        } else {
            console.log('  ❌ Usuario guardia no encontrado');
        }
        
        // Resumen final
        console.log('\n📊 RESUMEN DEL SISTEMA:');
        console.log('==========================================');
        
        const allTablesExist = tablesResult.rows.length >= 8;
        const usersExist = adminResult.rows[0].count > 0 && guardiaResult.rows[0].count > 0;
        const dataExists = plazasResult.rows[0].count > 0;
        
        if (allTablesExist && usersExist && dataExists) {
            console.log('🎉 SISTEMA COMPLETAMENTE FUNCIONAL');
            console.log('   ✅ Todas las tablas creadas');
            console.log('   ✅ Usuarios de prueba configurados');
            console.log('   ✅ Datos iniciales cargados');
            console.log('');
            console.log('🚀 El sistema está listo para usar:');
            console.log('   - Admin: http://localhost:3000/admin-login.html');
            console.log('   - Guardia: http://localhost:3000/guardia-login.html');
            console.log('   - Credenciales: admin@pradosdenos.cl / admin123');
            console.log('   - Credenciales: guardia@pradosdenos.cl / guardia123');
        } else {
            console.log('⚠️  SISTEMA PARCIALMENTE CONFIGURADO');
            if (!allTablesExist) console.log('   ❌ Faltan tablas - ejecuta: npm run migrate');
            if (!usersExist) console.log('   ❌ Faltan usuarios - ejecuta: npm run setup-users');
            if (!dataExists) console.log('   ❌ Faltan datos - ejecuta: npm run migrate');
        }
        
    } catch (error) {
        console.error('❌ Error de conexión:', error.message);
        console.log('\n🔧 Posibles soluciones:');
        console.log('   1. Verifica que la URL de Supabase sea correcta');
        console.log('   2. Confirma que las credenciales sean válidas');
        console.log('   3. Verifica que el proyecto de Supabase esté activo');
        console.log('   4. Revisa el archivo .env');
        
        if (error.code === '3D000') {
            console.log('   5. La base de datos no existe - créala en Supabase');
        }
        
        process.exit(1);
    } finally {
        await client.end();
    }
}

// Ejecutar solo si se llama directamente
if (require.main === module) {
    testConnection();
}

module.exports = { testConnection };
