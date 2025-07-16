require('dotenv').config();
const { Pool } = require('pg');

// Usar la misma configuración que en utils/db.js
const poolConfig = {
    connectionString: process.env.DATABASE_URL || 'postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres',
    ssl: { rejectUnauthorized: false },
    connectionTimeoutMillis: 10000,
    idleTimeoutMillis: 30000,
    max: 10
};

const pool = new Pool(poolConfig);

async function testConnection() {
    try {
        console.log('🔍 Testeando conexión a la base de datos...');
        console.log('🌐 Config:', {
            connectionString: poolConfig.connectionString.replace(/:[^:@]*@/, ':***@'),
            ssl: poolConfig.ssl,
            max: poolConfig.max
        });
        
        const client = await pool.connect();
        console.log('✅ Conexión exitosa');
        
        // Test simple
        const result = await client.query('SELECT NOW() as timestamp');
        console.log('⏰ Timestamp:', result.rows[0].timestamp);
        
        // Verificar tablas
        const tables = await client.query(`
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name IN ('guardias', 'admin_users')
        `);
        
        console.log('📋 Tablas encontradas:', tables.rows.map(r => r.table_name));
        
        // Contar registros
        const guardiaCount = await client.query('SELECT COUNT(*) FROM guardias');
        const adminCount = await client.query('SELECT COUNT(*) FROM admin_users');
        
        console.log('👮 Guardias en DB:', guardiaCount.rows[0].count);
        console.log('👨‍💼 Admins en DB:', adminCount.rows[0].count);
        
        client.release();
        
    } catch (error) {
        console.error('❌ Error de conexión:', error.message);
        console.error('❌ Stack:', error.stack);
    } finally {
        await pool.end();
    }
}

testConnection();
