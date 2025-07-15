const { Pool } = require('pg');

const url = 'postgresql://postgres:MacBookPro710@db.ixttdxkelassioemefbo.supabase.co:5432/postgres';

const pool = new Pool({
  connectionString: url,
  ssl: { rejectUnauthorized: false }
});

pool.connect()
  .then(client => {
    console.log('✅ Conectado a Supabase');
    return client.query('SELECT NOW()');
  })
  .then(result => {
    console.log('⏰ Tiempo:', result.rows[0].now);
    process.exit(0);
  })
  .catch(error => {
    console.error('❌ Error:', error.message);
    console.error('🔍 Código:', error.code);
    process.exit(1);
  });
