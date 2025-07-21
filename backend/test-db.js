const db = require('./utils/db');

async function testConnection() {
    try {
        console.log('Testing database connection...');
        const result = await db.query('SELECT 1 as test');
        console.log('✅ Database connection OK');
        console.log('Test result:', result.rows);
        
        // Test simple query
        const adminCount = await db.query('SELECT COUNT(*) as count FROM admin_users');
        console.log('Admin users count:', adminCount.rows[0].count);
        
        const guardiaCount = await db.query('SELECT COUNT(*) as count FROM guardias');
        console.log('Guardias count:', guardiaCount.rows[0].count);
        
        process.exit(0);
    } catch (error) {
        console.error('❌ Database error:', error.message);
        process.exit(1);
    }
}

testConnection();
