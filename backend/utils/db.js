const mysql = require('mysql2');

// Configuración de conexión con soporte para servicios de base de datos externos
const connectionConfig = {
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root', 
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'checkin_plaza',
  port: process.env.DB_PORT || 3306,
  
  // Configuraciones para servicios de BD externos (PlanetScale, Railway, etc.)
  ssl: process.env.DB_SSL === 'true' ? {
    rejectUnauthorized: process.env.DB_SSL_REJECT_UNAUTHORIZED !== 'false'
  } : false,
  
  // Pool de conexiones para mejor rendimiento en producción
  connectionLimit: parseInt(process.env.DB_CONNECTION_LIMIT) || 10,
  acquireTimeout: parseInt(process.env.DB_ACQUIRE_TIMEOUT) || 60000,
  timeout: parseInt(process.env.DB_TIMEOUT) || 60000,
  reconnect: true,
  
  // Configuraciones adicionales para estabilidad
  multipleStatements: false,
  timezone: process.env.DB_TIMEZONE || '+00:00',
  
  // Para Railway y otros servicios que requieren estas configuraciones
  charset: 'utf8mb4',
  supportBigNumbers: true,
  bigNumberStrings: true
};

// Crear pool de conexiones para mejor rendimiento
const pool = mysql.createPool(connectionConfig);

// Promisificar para usar async/await
const promisePool = pool.promise();

// Función para probar la conexión
const testConnection = async () => {
  try {
    const [rows] = await promisePool.execute('SELECT 1 as test');
    console.log('✅ Base de datos conectada exitosamente');
    return true;
  } catch (error) {
    console.error('❌ Error conectando a la base de datos:', error.message);
    
    // Información de debugging para desarrollo
    if (process.env.NODE_ENV !== 'production') {
      console.error('Configuración de DB:', {
        host: connectionConfig.host,
        user: connectionConfig.user,
        database: connectionConfig.database,
        port: connectionConfig.port,
        ssl: !!connectionConfig.ssl
      });
    }
    
    return false;
  }
};

// Probar conexión al inicializar
testConnection();

// Manejo de errores del pool
pool.on('connection', (connection) => {
  console.log(`Nueva conexión DB establecida como id ${connection.threadId}`);
});

pool.on('error', (err) => {
  console.error('Error en el pool de conexiones DB:', err);
  if (err.code === 'PROTOCOL_CONNECTION_LOST') {
    console.log('Intentando reconectar a la base de datos...');
  } else {
    throw err;
  }
});

// Función helper para queries simples
const query = (sql, params = []) => {
  return new Promise((resolve, reject) => {
    pool.execute(sql, params, (error, results) => {
      if (error) {
        reject(error);
      } else {
        resolve(results);
      }
    });
  });
};

// Exportar tanto el pool como métodos helper
module.exports = {
  pool,
  promisePool,
  query,
  testConnection,
  // Mantener compatibilidad con código existente
  ...pool
};