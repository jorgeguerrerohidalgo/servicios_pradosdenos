// Script simple para verificar rutas
const express = require('express');
const path = require('path');

console.log('🔍 Verificando rutas...');

try {
  // Verificar que los archivos de rutas existen
  const authRoutes = require('./routes/auth-debug-fixed.routes');
  const eventosRoutes = require('./routes/eventos.routes');
  const documentosRoutes = require('./routes/documentos_comunitarios.routes');
  const initRoutes = require('./routes/init.routes');
  
  console.log('✅ auth-debug-fixed.routes.js - OK');
  console.log('✅ eventos.routes.js - OK');
  console.log('✅ documentos_comunitarios.routes.js - OK');
  console.log('✅ init.routes.js - OK');
  
  // Verificar estructura básica
  console.log('🔍 Verificando estructura de rutas...');
  
  const app = express();
  app.use('/api/auth', authRoutes);
  app.use('/api/eventos', eventosRoutes);
  app.use('/api/documentos_comunitarios', documentosRoutes);
  app.use('/api/init', initRoutes);
  
  console.log('✅ Todas las rutas se cargaron correctamente');
  
} catch (error) {
  console.error('❌ Error cargando rutas:', error.message);
  console.error('Stack:', error.stack);
}
