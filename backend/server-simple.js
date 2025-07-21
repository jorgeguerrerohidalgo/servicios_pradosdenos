require('dotenv').config();
process.env.TZ = 'America/Santiago';

const express = require('express');
const session = require('express-session');
const cors = require('cors');
const helmet = require('helmet');
const path = require('path');
const app = express();

const PORT = process.env.PORT || 3000;

console.log('🚀 Iniciando servidor simplificado...');

// Seguridad básica
app.use(helmet({
  contentSecurityPolicy: false,
  crossOriginEmbedderPolicy: false
}));

// CORS
app.use(cors({
  origin: true,
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With']
}));

// Middleware básico
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Sesiones
app.use(session({
  secret: process.env.SESSION_SECRET || 'fallback-secret-key',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: false,
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000
  }
}));

// Servir archivos estáticos
app.use(express.static(path.join(__dirname, '..', 'public')));

// Rutas básicas
try {
  console.log('📦 Cargando rutas básicas...');
  
  const authRoutes = require('./routes/auth-simple-working.routes');
  const checkinRoutes = require('./routes/checkin.routes');
  const publicRoutes = require('./routes/public.routes');
  const adminRoutes = require('./routes/admin.routes');
  const initRoutes = require('./routes/init.routes');
  
  app.use('/api/auth', authRoutes);
  app.use('/api/checkin', checkinRoutes);
  app.use('/api/checkins', publicRoutes);
  app.use('/api/admin', adminRoutes);
  app.use('/api/init', initRoutes);
  
  console.log('✅ Rutas básicas cargadas');
} catch (error) {
  console.error('❌ Error cargando rutas básicas:', error.message);
}

// Rutas de eventos
try {
  console.log('📦 Cargando rutas de eventos...');
  const eventosRoutes = require('./routes/eventos.routes');
  app.use('/api/eventos', eventosRoutes);
  console.log('✅ Rutas de eventos cargadas');
} catch (error) {
  console.error('❌ Error cargando rutas de eventos:', error.message);
}

// Rutas de documentos
try {
  console.log('📦 Cargando rutas de documentos...');
  const documentosRoutes = require('./routes/documentos-simple.routes');
  app.use('/api/documentos_comunitarios', documentosRoutes);
  console.log('✅ Rutas de documentos cargadas');
} catch (error) {
  console.error('❌ Error cargando rutas de documentos:', error.message);
}

// Catch-all para rutas públicas
try {
  const publicRoutes = require('./routes/public.routes');
  app.use('/api', publicRoutes);
} catch (error) {
  console.error('❌ Error con catch-all:', error.message);
}

// Manejador de errores global
app.use((err, req, res, next) => {
  console.error('Error global:', err);
  res.status(500).json({
    success: false,
    error: 'Error interno del servidor'
  });
});

// Iniciar servidor
const server = app.listen(PORT, () => {
  console.log(`🚀 Servidor ejecutándose en puerto ${PORT}`);
  console.log(`🌐 Entorno: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🕒 Zona horaria: ${process.env.TZ}`);
});

// Manejo de errores del servidor
server.on('error', (error) => {
  console.error('❌ Error del servidor:', error);
  process.exit(1);
});

// Manejo de cierre graceful
process.on('SIGTERM', () => {
  console.log('🔄 Recibida señal SIGTERM, cerrando servidor...');
  server.close(() => {
    console.log('✅ Servidor cerrado correctamente');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('🔄 Recibida señal SIGINT, cerrando servidor...');
  server.close(() => {
    console.log('✅ Servidor cerrado correctamente');
    process.exit(0);
  });
});

module.exports = app;
