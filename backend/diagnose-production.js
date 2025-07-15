// Script de diagnóstico para producción en Render
require('dotenv').config();

const { Client } = require('pg');

async function diagnosticProduction() {
    console.log('🔍 DIAGNÓSTICO DE PRODUCCIÓN - RENDER');
    console.log('====================================');
    
    console.log('📋 Variables de entorno:');
    console.log(`   NODE_ENV: ${process.env.NODE_ENV}`);
    console.log(`   PORT: ${process.env.PORT}`);
    console.log(`   DATABASE_URL: ${process.env.DATABASE_URL ? 'Configurado' : 'No configurado'}`);
    console.log(`   SESSION_SECRET: ${process.env.SESSION_SECRET ? 'Configurado' : 'No configurado'}`);
    console.log(`   TZ: ${process.env.TZ}`);
    console.log(`   Fecha actual: ${new Date().toISOString()}`);
    console.log(`   Uptime: ${process.uptime()} segundos`);
    
    // Test de conexión a base de datos
    console.log('\n🔗 Probando conexión a Supabase...');
    
    if (!process.env.DATABASE_URL) {
        console.error('❌ DATABASE_URL no está configurado');
        return false;
    }
    
    const client = new Client({
        connectionString: process.env.DATABASE_URL,
        ssl: { rejectUnauthorized: false },
        connectionTimeoutMillis: 10000,
        query_timeout: 15000
    });
    
    try {
        await client.connect();
        console.log('✅ Conexión a Supabase exitosa');
        
        // Test básico
        const timeResult = await client.query('SELECT NOW() as current_time, version() as version');
        console.log(`⏰ Tiempo servidor: ${timeResult.rows[0].current_time}`);
        console.log(`📊 Versión PostgreSQL: ${timeResult.rows[0].version.substring(0, 50)}...`);
        
        // Verificar tablas críticas
        const tablesResult = await client.query(`
            SELECT table_name, 
                   (SELECT COUNT(*) FROM information_schema.columns 
                    WHERE table_name = t.table_name AND table_schema = 'public') as columns
            FROM information_schema.tables t
            WHERE table_schema = 'public' 
            AND table_name IN ('security_logs', 'admin_users', 'guardias', 'plazas', 'checkins')
            ORDER BY table_name
        `);
        
        console.log('\n📋 Tablas críticas:');
        tablesResult.rows.forEach(row => {
            console.log(`  ✅ ${row.table_name} (${row.columns} columnas)`);
        });
        
        if (tablesResult.rows.length < 5) {
            console.log('⚠️  Faltan tablas críticas');
        }
        
        // Verificar usuarios
        const adminCount = await client.query('SELECT COUNT(*) as count FROM admin_users');
        const guardiaCount = await client.query('SELECT COUNT(*) as count FROM guardias');
        
        console.log('\n👥 Usuarios en sistema:');
        console.log(`  👤 Administradores: ${adminCount.rows[0].count}`);
        console.log(`  🛡️  Guardias: ${guardiaCount.rows[0].count}`);
        
        // Verificar usuario de prueba
        const testAdmin = await client.query(`
            SELECT id, email, nombre 
            FROM admin_users 
            WHERE email = 'admin@pradosdenos.cl' 
            LIMIT 1
        `);
        
        if (testAdmin.rows.length > 0) {
            console.log(`  ✅ Usuario admin de prueba existe (ID: ${testAdmin.rows[0].id})`);
        } else {
            console.log('  ❌ Usuario admin de prueba NO existe');
        }
        
        // Verificar logs recientes
        const logsResult = await client.query(`
            SELECT event_type, COUNT(*) as count
            FROM security_logs 
            WHERE created_at > NOW() - INTERVAL '1 hour'
            GROUP BY event_type
            ORDER BY count DESC
        `);
        
        console.log('\n🔒 Logs última hora:');
        if (logsResult.rows.length > 0) {
            logsResult.rows.forEach(row => {
                console.log(`  ${row.event_type}: ${row.count}`);
            });
        } else {
            console.log('  Sin logs recientes');
        }
        
        return true;
        
    } catch (error) {
        console.error('❌ Error de conexión:', error.message);
        console.error('   Código:', error.code);
        console.error('   Detalles:', error.detail || 'N/A');
        return false;
        
    } finally {
        try {
            await client.end();
        } catch (e) {
            // Ignorar errores de cierre
        }
    }
}

// Test de rutas críticas
async function testCriticalRoutes() {
    console.log('\n🧪 TEST DE RUTAS CRÍTICAS');
    console.log('=========================');
    
    const routes = [
        '/health',
        '/api/auth/check',
        '/login.html'
    ];
    
    for (const route of routes) {
        try {
            const response = await fetch(`http://localhost:${process.env.PORT || 3000}${route}`);
            console.log(`${response.ok ? '✅' : '❌'} ${route}: ${response.status}`);
        } catch (error) {
            console.log(`❌ ${route}: Error - ${error.message}`);
        }
    }
}

async function main() {
    const dbOk = await diagnosticProduction();
    
    if (dbOk) {
        console.log('\n🎉 Base de datos funcionando correctamente');
        
        // Solo hacer test de rutas si estamos en un servidor corriendo
        if (process.env.PORT) {
            await testCriticalRoutes();
        }
    } else {
        console.log('\n❌ Problemas con la base de datos');
    }
    
    console.log('\n📋 RESUMEN:');
    console.log('===========');
    console.log(`Base de datos: ${dbOk ? 'OK' : 'FAIL'}`);
    console.log(`Variables de entorno: ${process.env.DATABASE_URL ? 'OK' : 'FAIL'}`);
    console.log(`Servidor: ${process.env.PORT ? 'Configurado' : 'Local'}`);
    
    if (!dbOk) {
        console.log('\n🔧 POSIBLES SOLUCIONES:');
        console.log('1. Verificar que la URL de Supabase sea correcta');
        console.log('2. Confirmar que el proyecto de Supabase esté activo');
        console.log('3. Verificar que las tablas estén creadas');
        console.log('4. Ejecutar: node setup-test-users.js');
    }
}

main().catch(console.error);
