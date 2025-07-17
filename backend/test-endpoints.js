const express = require('express');
const cors = require('cors');
const path = require('path');
const session = require('express-session');

// Configuración de Express
const app = express();
app.use(express.json());
app.use(cors({
    origin: true,
    credentials: true
}));

// Configuración de sesiones
app.use(session({
    secret: 'dev-secret-key',
    resave: false,
    saveUninitialized: false,
    cookie: {
        secure: false,
        httpOnly: true,
        maxAge: 24 * 60 * 60 * 1000 // 24 horas
    }
}));

// Importar rutas
const authRoutes = require('./routes/auth.routes');
const eventosRoutes = require('./routes/eventos.routes');
const documentosRoutes = require('./routes/documentos_comunitarios.routes');
const initRoutes = require('./routes/init.routes');

// Usar las rutas
app.use('/api/auth', authRoutes);
app.use('/api/eventos', eventosRoutes);
app.use('/api/documentos_comunitarios', documentosRoutes);
app.use('/api/init', initRoutes);

// Middleware para servir archivos estáticos
app.use(express.static(path.join(__dirname, '..', 'public')));

// Ruta de prueba
app.get('/test', (req, res) => {
    res.json({
        success: true,
        message: 'Servidor funcionando correctamente',
        timestamp: new Date().toISOString(),
        endpoints: {
            auth: '/api/auth',
            eventos: '/api/eventos',
            documentos: '/api/documentos_comunitarios',
            init: '/api/init'
        }
    });
});

// Manejador de errores
app.use((err, req, res, next) => {
    console.error('Error:', err);
    res.status(500).json({
        success: false,
        error: 'Error interno del servidor',
        details: err.message
    });
});

// Manejador para rutas no encontradas
app.use((req, res) => {
    res.status(404).json({
        success: false,
        error: 'Ruta no encontrada',
        path: req.path
    });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Servidor de prueba ejecutándose en puerto ${PORT}`);
    console.log(`Prueba los endpoints en: http://localhost:${PORT}/test`);
    console.log('\nEndpoints disponibles:');
    console.log('- GET /test');
    console.log('- GET /api/eventos/tipos/all');
    console.log('- GET /api/eventos');
    console.log('- GET /api/documentos_comunitarios/tipos');
    console.log('- GET /api/documentos_comunitarios');
    console.log('- POST /api/init/database');
});
