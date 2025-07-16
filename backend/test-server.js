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

// Ruta de prueba
app.get('/test', (req, res) => {
  res.json({ message: 'Servidor de prueba funcionando', timestamp: new Date().toISOString() });
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
