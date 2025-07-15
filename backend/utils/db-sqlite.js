const sqlite3 = require('sqlite3').verbose();
const path = require('path');

// Configurar zona horaria de Santiago de Chile
process.env.TZ = 'America/Santiago';

// Usar SQLite como alternativa local
const dbPath = path.join(__dirname, 'local_db.sqlite');
const db = new sqlite3.Database(dbPath);

// Función para probar la conexión
const testConnection = async () => {
  try {
    console.log('🔌 Conectando a base de datos SQLite local...');
    console.log('📍 Ubicación:', dbPath);
    
    return new Promise((resolve, reject) => {
      db.get('SELECT 1 as test', (err, row) => {
        if (err) {
          console.error('❌ Error conectando a SQLite:', err.message);
          reject(err);
        } else {
          console.log('✅ Base de datos SQLite conectada exitosamente');
          resolve(true);
        }
      });
    });
  } catch (error) {
    console.error('❌ Error con SQLite:', error.message);
    return false;
  }
};

// Función para mantener compatibilidad con PostgreSQL
const query = (sql, params = [], callback) => {
  // Convertir sintaxis PostgreSQL a SQLite
  let sqliteQuery = sql;
  
  // Convertir $1, $2, etc. a ?
  let paramIndex = 1;
  sqliteQuery = sqliteQuery.replace(/\$\d+/g, '?');
  
  // Ajustar algunas funciones específicas de PostgreSQL
  sqliteQuery = sqliteQuery.replace(/NOW\(\)/g, 'CURRENT_TIMESTAMP');
  sqliteQuery = sqliteQuery.replace(/gen_random_uuid\(\)/g, '?');
  
  // Si tenemos gen_random_uuid en los parámetros, generar UUID
  if (sqliteQuery.includes('gen_random_uuid')) {
    const { v4: uuidv4 } = require('uuid');
    params.unshift(uuidv4());
  }
  
  // Si no hay callback, es una llamada async
  if (typeof params === 'function') {
    callback = params;
    params = [];
  }
  
  if (callback) {
    // Determinar si es SELECT o INSERT/UPDATE/DELETE
    const isSelect = sqliteQuery.trim().toUpperCase().startsWith('SELECT');
    
    if (isSelect) {
      db.all(sqliteQuery, params, (error, rows) => {
        if (error) {
          callback(error, null);
        } else {
          callback(null, rows);
        }
      });
    } else {
      db.run(sqliteQuery, params, function(error) {
        if (error) {
          callback(error, null);
        } else {
          callback(null, { 
            insertId: this.lastID, 
            affectedRows: this.changes,
            rows: []
          });
        }
      });
    }
  } else {
    return new Promise((resolve, reject) => {
      const isSelect = sqliteQuery.trim().toUpperCase().startsWith('SELECT');
      
      if (isSelect) {
        db.all(sqliteQuery, params, (error, rows) => {
          if (error) {
            reject(error);
          } else {
            resolve(rows);
          }
        });
      } else {
        db.run(sqliteQuery, params, function(error) {
          if (error) {
            reject(error);
          } else {
            resolve({ 
              insertId: this.lastID, 
              affectedRows: this.changes,
              rows: []
            });
          }
        });
      }
    });
  }
};

// Probar conexión al inicializar
testConnection();

module.exports = {
  db,
  query,
  testConnection
};
