const { Pool } = require('pg');

// Configuración de conexión PostgreSQL (Supabase)
let poolConfig;

if (process.env.DATABASE_URL) {
  // Usar DATABASE_URL si está disponible
  poolConfig = {
    connectionString: process.env.DATABASE_URL,
    ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
    connectionTimeoutMillis: 10000,
    idleTimeoutMillis: 30000,
    max: 10
  };
} else {
  // Usar variables separadas como fallback
  poolConfig = {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT || 5432,
    ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
    connectionTimeoutMillis: 10000,
    idleTimeoutMillis: 30000,
    max: 10
  };
}

const pool = new Pool(poolConfig);

// Función para probar la conexión
const testConnection = async () => {
  try {
    console.log('🔌 Intentando conectar a la base de datos...');
    console.log('📍 URL de conexión:', process.env.DATABASE_URL ? 'Configurada' : 'NO CONFIGURADA');
    
    const client = await pool.connect();
    const result = await client.query('SELECT 1 as test');
    client.release();
    console.log('✅ Base de datos PostgreSQL conectada exitosamente');
    return true;
  } catch (error) {
    console.error('❌ Error conectando a la base de datos:', error.message);
    console.error('🔍 Tipo de error:', error.code || 'UNKNOWN');
    
    // Sugerencias específicas según el tipo de error
    if (error.code === 'ENOTFOUND') {
      console.error('💡 Verifica que la URL de la base de datos sea correcta');
    } else if (error.code === 'ENETUNREACH') {
      console.error('💡 Problema de conectividad de red. Verifica SSL y la URL de conexión');
    } else if (error.code === 'ECONNREFUSED') {
      console.error('💡 La base de datos rechazó la conexión. Verifica credenciales');
    }
    
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
