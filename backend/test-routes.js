// Test script para verificar rutas de documentos y eventos
const express = require('express');

console.log('🧪 Probando imports de rutas...');

try {
    console.log('📦 Importando documentos.routes...');
    const documentosRoutes = require('./routes/documentos.routes');
    console.log('✅ documentos.routes importado correctamente');
    
    console.log('📦 Importando eventos.routes...');
    const eventosRoutes = require('./routes/eventos.routes');
    console.log('✅ eventos.routes importado correctamente');
    
    console.log('📦 Importando middleware auth...');
    const auth = require('./middleware/auth');
    console.log('✅ middleware auth importado correctamente');
    
    console.log('🎉 Todas las rutas están bien configuradas!');
    
} catch (error) {
    console.error('❌ Error en import:', error.message);
    console.error('❌ Stack:', error.stack);
}
