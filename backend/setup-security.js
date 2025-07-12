// Script para verificar y crear tabla de security_logs si es necesario
const { query } = require('./utils/db');

async function setupSecurityTable() {
  try {
    console.log('🔍 Verificando tabla security_logs...');
    
    // Verificar si la tabla existe
    const tableExists = await query(`
      SELECT EXISTS (
        SELECT FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'security_logs'
      );
    `);
    
    if (!tableExists[0].exists) {
      console.log('📋 Creando tabla security_logs...');
      
      // Crear tabla
      await query(`
        CREATE TABLE security_logs (
          id SERIAL PRIMARY KEY,
          ip_address INET NOT NULL,
          event_type VARCHAR(50) NOT NULL,
          details JSONB,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      `);
      
      // Crear índices
      await query('CREATE INDEX idx_security_logs_ip ON security_logs(ip_address);');
      await query('CREATE INDEX idx_security_logs_event_type ON security_logs(event_type);');
      await query('CREATE INDEX idx_security_logs_created_at ON security_logs(created_at);');
      
      console.log('✅ Tabla security_logs creada exitosamente');
    } else {
      console.log('✅ Tabla security_logs ya existe');
    }
    
    // Insertar un log de prueba
    await query(
      'INSERT INTO security_logs (ip_address, event_type, details) VALUES ($1, $2, $3)',
      ['127.0.0.1', 'SYSTEM_START', { message: 'Sistema iniciado', timestamp: new Date().toISOString() }]
    );
    
    console.log('✅ Tabla security_logs funcionando correctamente');
    
  } catch (error) {
    console.error('❌ Error configurando tabla security_logs:', error);
    console.log('⚠️  Sistema funcionará sin logs de seguridad');
  }
}

// Ejecutar solo si es llamado directamente
if (require.main === module) {
  setupSecurityTable()
    .then(() => process.exit(0))
    .catch(() => process.exit(1));
}

module.exports = { setupSecurityTable };
