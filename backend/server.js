require('dotenv').config();
const express = require('express');
const session = require('express-session');
const cors = require('cors');
const path = require('path');
const app = express();

// Importar rutas
const authRoutes = require('./routes/auth.routes');
const checkinRoutes = require('./routes/checkin.routes');

// Variables de entorno para producción
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';
const isProduction = NODE_ENV === 'production';

// Configuración de CORS para producción
const corsOptions = {
  origin: isProduction 
    ? [process.env.FRONTEND_URL, process.env.RENDER_EXTERNAL_URL] 
    : ['http://localhost:3000', 'http://127.0.0.1:3000'],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With']
};

// Middlewares
app.use(cors(corsOptions));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Configuración de sesiones para producción
app.use(session({
  secret: process.env.SESSION_SECRET || 'checkin-secret-key-change-in-production',
  resave: false,
  saveUninitialized: false,
  cookie: { 
    secure: isProduction, // true en producción con HTTPS
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000, // 24 horas
    sameSite: isProduction ? 'none' : 'lax'
  },
  name: 'checkin.sid'
}));

// Middleware de logging en producción
if (isProduction) {
  app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.path} - IP: ${req.ip}`);
    next();
  });
}

// Health check endpoint para Render
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: NODE_ENV
  });
});

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/checkin', checkinRoutes);

// Servir archivos estáticos desde public (primero local, luego padre)
const publicPaths = [
  path.join(__dirname, 'public'),     // backend/public (para Render)
  path.join(__dirname, '../public')   // public (para desarrollo local)
];

publicPaths.forEach(publicPath => {
  if (require('fs').existsSync(publicPath)) {
    app.use(express.static(publicPath));
    console.log(`📁 Sirviendo archivos estáticos desde: ${publicPath}`);
  }
});

// Ruta por defecto para SPA (Single Page App)
app.get('*', (req, res) => {
  // Evitar que rutas de API sean capturadas aquí
  if (req.path.startsWith('/api/')) {
    return res.status(404).json({ error: 'API endpoint no encontrado' });
  }
  
  // Buscar login.html en múltiples ubicaciones
  const possiblePaths = [
    path.join(__dirname, 'public', 'login.html'),
    path.join(__dirname, '../public', 'login.html')
  ];
  
  let filePath = null;
  for (const possiblePath of possiblePaths) {
    if (require('fs').existsSync(possiblePath)) {
      filePath = possiblePath;
      break;
    }
  }
  
  if (filePath) {
    res.sendFile(filePath);
  } else {
    res.status(404).json({ 
      error: 'Archivo login.html no encontrado',
      searched: possiblePaths 
    });
  }
});

// Manejo de errores global
app.use((err, req, res, next) => {
  console.error('Error no manejado:', err);
  res.status(500).json({ 
    error: isProduction ? 'Error interno del servidor' : err.message,
    timestamp: new Date().toISOString()
  });
});

// Iniciar servidor
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Servidor corriendo en puerto ${PORT}`);
  console.log(`🌍 Entorno: ${NODE_ENV}`);
  console.log(`⚡ Health check disponible en: http://localhost:${PORT}/health`);
  
  // Debug: Verificar rutas de archivos
  const publicPath = path.join(__dirname, '../public');
  const loginPath = path.join(publicPath, 'login.html');
  console.log(`📁 Directorio público: ${publicPath}`);
  console.log(`📄 Archivo login.html existe: ${require('fs').existsSync(loginPath)}`);
  console.log(`📂 Contenido directorio público:`, require('fs').readdirSync(publicPath).join(', '));
  
  if (!isProduction) {
    console.log(`🏠 Frontend disponible en: http://localhost:${PORT}/login.html`);
  }
});

// Manejo graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM recibido, cerrando servidor gracefully...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('SIGINT recibido, cerrando servidor gracefully...');
  process.exit(0);
});