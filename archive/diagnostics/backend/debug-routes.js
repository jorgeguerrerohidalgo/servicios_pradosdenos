#!/usr/bin/env node

console.log('🔍 Diagnóstico de rutas - buscando error de sintaxis...');

const routes = [
    './routes/auth-debug-fixed.routes.js',
    './routes/eventos.routes.js',
    './routes/documentos_comunitarios.routes.js',
    './routes/init.routes.js',
    './routes/checkin.routes.js',
    './routes/public.routes.js',
    './routes/admin.routes.js'
];

for (const route of routes) {
    try {
        console.log(`\n🔄 Probando: ${route}`);
        const routeModule = require(route);
        console.log(`✅ ${route} - Sintaxis OK`);
        
        // Verificar que es un router válido
        if (routeModule && typeof routeModule === 'function') {
            console.log(`✅ ${route} - Es un router válido`);
        } else {
            console.log(`⚠️ ${route} - No es un router válido:`, typeof routeModule);
        }
        
    } catch (error) {
        console.log(`❌ ${route} - ERROR:`, error.message);
        console.log(`❌ Stack:`, error.stack);
        break; // Detener en el primer error
    }
}

console.log('\n🔍 Probando importación completa como en server-production.js...');

try {
    const authRoutes = require('./routes/auth-debug-fixed.routes');
    const checkinRoutes = require('./routes/checkin.routes');
    const publicRoutes = require('./routes/public.routes');
    const adminRoutes = require('./routes/admin.routes');
    const initRoutes = require('./routes/init.routes');
    
    console.log('✅ Rutas básicas importadas correctamente');
    
    // Ahora probar las rutas problemáticas
    const eventosRoutes = require('./routes/eventos.routes');
    const documentosRoutes = require('./routes/documentos_comunitarios.routes');
    
    console.log('✅ Rutas de eventos y documentos importadas correctamente');
    console.log('✅ Todas las rutas se pueden importar sin errores');
    
} catch (error) {
    console.error('❌ Error en importación completa:', error.message);
    console.error('❌ Stack completo:', error.stack);
}
