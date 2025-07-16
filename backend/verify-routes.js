// Script simple para verificar rutas
const express = require('express');
const path = require('path');

console.log('🔍 Verificando rutas...');

try {
  // Verificar que los archivos de rutas existen
  const authRoutes = require('./routes/auth-debug.routes');
  const eventosRoutes = require('./routes/eventos.routes');
  const documentosRoutes = require('./routes/documentos_new.routes');
  
  console.log('✅ auth-debug.routes.js - OK');
  console.log('✅ eventos.routes.js - OK');
  console.log('✅ documentos_new.routes.js - OK');
  
  // Verificar estructura básica
  console.log('🔍 Verificando estructura de rutas...');
  
  const app = express();
  app.use('/api/auth', authRoutes);
  app.use('/api/eventos', eventosRoutes);
  app.use('/api/documentos', documentosRoutes);
  
  console.log('✅ Todas las rutas se cargaron correctamente');
  
} catch (error) {
  console.error('❌ Error cargando rutas:', error.message);
  console.error('Stack:', error.stack);
}
