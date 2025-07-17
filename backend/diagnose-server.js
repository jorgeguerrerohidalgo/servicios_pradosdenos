const express = require('express');
const cors = require('cors');
const path = require('path');

console.log('🔍 Diagnóstico completo del servidor...\n');

// Verificar archivos
console.log('📁 Verificando archivos de rutas:');
const fs = require('fs');

const routeFiles = [
    'routes/eventos.routes.js',
    'routes/documentos_comunitarios.routes.js',
    'routes/init.routes.js',
    'routes/auth-debug-fixed.routes.js'
];

routeFiles.forEach(file => {
    const fullPath = path.join(__dirname, file);
    const exists = fs.existsSync(fullPath);
    console.log(`${exists ? '✅' : '❌'} ${file} - ${exists ? 'Existe' : 'No existe'}`);
});

console.log('\n🔧 Probando importación de rutas:');

try {
    const eventosRoutes = require('./routes/eventos.routes');
    console.log('✅ eventos.routes.js importado correctamente');
    
    const documentosRoutes = require('./routes/documentos_comunitarios.routes');
    console.log('✅ documentos_comunitarios.routes.js importado correctamente');
    
    const initRoutes = require('./routes/init.routes');
    console.log('✅ init.routes.js importado correctamente');
    
    const authRoutes = require('./routes/auth-debug-fixed.routes');
    console.log('✅ auth-debug-fixed.routes.js importado correctamente');
    
    console.log('\n🚀 Creando servidor de prueba...');
    
    const app = express();
    app.use(cors());
    app.use(express.json());
    
    // Configurar rutas en el orden correcto
    app.use('/api/auth', authRoutes);
    app.use('/api/eventos', eventosRoutes);
    app.use('/api/documentos_comunitarios', documentosRoutes);
    app.use('/api/init', initRoutes);
    
    // Ruta de prueba
    app.get('/test-routes', (req, res) => {
        res.json({
            message: 'Rutas configuradas correctamente',
            routes: [
                'GET /api/eventos/tipos/all',
                'GET /api/eventos',
                'GET /api/documentos_comunitarios/tipos',
                'GET /api/documentos_comunitarios',
                'POST /api/init/init-eventos-documentos'
            ]
        });
    });
    
    const PORT = 3001; // Puerto diferente para evitar conflictos
    
    app.listen(PORT, () => {
        console.log(`✅ Servidor de diagnóstico corriendo en puerto ${PORT}`);
        console.log(`🌐 Prueba las rutas en: http://localhost:${PORT}/test-routes`);
        console.log('\n📝 Rutas configuradas:');
        console.log('- GET /api/eventos/tipos/all');
        console.log('- GET /api/eventos');
        console.log('- GET /api/documentos_comunitarios/tipos');
        console.log('- GET /api/documentos_comunitarios');
        console.log('- POST /api/init/init-eventos-documentos');
        console.log('\n⚠️  Presiona Ctrl+C para detener el servidor de diagnóstico');
    });
    
} catch (error) {
    console.error('❌ Error al importar rutas:', error.message);
    console.error('\n🔍 Detalles del error:');
    console.error(error.stack);
}
