require('dotenv').config();
const express = require('express');
const session = require('express-session');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = 3001; // Puerto diferente para no interferir

// Configuración básica
app.use(cors({ credentials: true }));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Configuración de sesiones
app.use(session({
  secret: 'test-secret',
  resave: false,
  saveUninitialized: false,
  cookie: { 
    secure: false,
    httpOnly: true,
    maxAge: 8 * 60 * 60 * 1000
  }
}));

// Importar rutas
const authRoutes = require('./routes/auth-debug.routes');
app.use('/api/auth', authRoutes);

// Servir archivos estáticos
app.use(express.static(path.join(__dirname, '../public')));

// Logging middleware
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  if (req.body && Object.keys(req.body).length > 0) {
    console.log('Body:', req.body);
  }
  next();
});

const express = require('express');
const app = express();
const cors = require('cors');

// Middleware básico
app.use(cors());
app.use(express.json());

// Probar importación de rutas
console.log('🔄 Cargando rutas...');

try {
    const initRoutes = require('./routes/init.routes.js');
    console.log('✅ init.routes.js cargado correctamente');
    app.use('/api/init', initRoutes);
} catch (error) {
    console.error('❌ Error cargando init.routes.js:', error.message);
    process.exit(1);
}

try {
    const eventosRoutes = require('./routes/eventos.routes.js');
    console.log('✅ eventos.routes.js cargado correctamente');
    app.use('/api/eventos', eventosRoutes);
} catch (error) {
    console.error('❌ Error cargando eventos.routes.js:', error.message);
    process.exit(1);
}

try {
    const documentosRoutes = require('./routes/documentos_comunitarios.routes.js');
    console.log('✅ documentos_comunitarios.routes.js cargado correctamente');
    app.use('/api/documentos_comunitarios', documentosRoutes);
} catch (error) {
    console.error('❌ Error cargando documentos_comunitarios.routes.js:', error.message);
    process.exit(1);
}

// Endpoint de prueba
app.get('/test', (req, res) => {
    res.json({ 
        message: 'Servidor funcionando correctamente',
        routes: [
            '/api/init',
            '/api/eventos',
            '/api/documentos_comunitarios'
        ]
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Servidor de prueba ejecutándose en puerto ${PORT}`);
    console.log('🔗 Endpoints disponibles:');
    console.log('   - GET /test');
    console.log('   - POST /api/init/init-eventos-documentos');
    console.log('   - GET /api/eventos');
    console.log('   - GET /api/documentos_comunitarios');
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`🚀 Servidor de prueba ejecutándose en http://localhost:${PORT}`);
  console.log(`📋 Rutas disponibles:`);
  console.log(`  - GET  /test`);
  console.log(`  - POST /api/auth/login`);
  console.log(`  - GET  /api/auth/check`);
  console.log(`  - POST /api/auth/logout`);
  console.log(`\n🔍 Para probar login:`);
  console.log(`curl -X POST http://localhost:${PORT}/api/auth/login \\`);
  console.log(`  -H "Content-Type: application/json" \\`);
  console.log(`  -d '{"email":"juan.perez@pradosdenos.com","password":"password123"}'`);
});

// Manejo de errores
app.use((error, req, res, next) => {
  console.error('❌ Error:', error);
  res.status(500).json({ error: 'Error interno del servidor' });
});
