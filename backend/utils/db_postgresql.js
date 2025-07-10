const { Pool } = require('pg');

// Configuración de conexión PostgreSQL (Supabase)
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

// Función para probar la conexión
const testConnection = async () => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT 1 as test');
    client.release();
    console.log('✅ Base de datos PostgreSQL conectada exitosamente');
    return true;
  } catch (error) {
    console.error('❌ Error conectando a la base de datos:', error.message);
    return false;
  }
};

// Probar conexión al inicializar
testConnection();

// Función para mantener compatibilidad con código MySQL existente
const query = (sql, params, callback) => {
  // Si no hay callback, es una llamada async
  if (typeof params === 'function') {
    callback = params;
    params = [];
  }
  
  // Convertir ? de MySQL a $1, $2, etc. de PostgreSQL
  let paramIndex = 1;
  const pgSql = sql.replace(/\?/g, () => `$${paramIndex++}`);
  
  if (callback) {
    pool.query(pgSql, params, (error, results) => {
      if (error) {
        callback(error, null);
      } else {
        callback(null, results.rows);
      }
    });
  } else {
    return new Promise((resolve, reject) => {
      pool.query(pgSql, params, (error, results) => {
        if (error) {
          reject(error);
        } else {
          resolve(results.rows);
        }
      });
    });
  }
};

module.exports = {
  pool,
  query,
  testConnection
};
