require('dotenv').config();

// Configurar zona horaria de Santiago de Chile
process.env.TZ = 'America/Santiago';

const express = require('express');
const session = require('express-session');
const cors = require('cors');
const helmet = require('helmet');
const path = require('path');
const app = express();

// Importar middleware de seguridad
const { 
  apiLimiter, 
  securityHeaders, 
  cleanExpiredSessions 
} = require('./middleware/security');

// Importar middleware de seguridad mejorado
const { 
  corsOptions: enhancedCorsOptions, 
  helmetOptions, 
  validateInput,
  sanitizeInput,
  securityLogger,
  attackDetection
} = require('./middleware/security_enhanced');

// Importar setup de seguridad
const { setupSecurityTable } = require('./setup-security');

// Importar rutas
const authRoutes = require('./routes/auth-simple-working.routes');
const checkinRoutes = require('./routes/checkin.routes');
const publicRoutes = require('./routes/public.routes');
const adminRoutes = require('./routes/admin.routes');

// Importar nuevas rutas - EVENTOS Y DOCUMENTOS SIMPLIFICADOS
const eventosRoutes = require('./routes/eventos.routes');
const documentosRoutes = require('./routes/documentos.routes');
const initRoutes = require('./routes/init.routes');

// Importar rutas de módulos de gestión residencial
const casasRoutes = require('./routes/casas.routes');
const residentesRoutes = require('./routes/residentes.routes');
const mascotasRoutes = require('./routes/mascotas.routes');
const pagosRoutes = require('./routes/pagos.routes');
const vehiculosRoutes = require('./routes/vehiculos.routes');
const accesoRoutes = require('./routes/acceso.routes');
const vehiculosRoutes = require('./routes/vehiculos.routes');
const accesoRoutes = require('./routes/acceso.routes');

// Variables de entorno para producción
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';
const isProduction = NODE_ENV === 'production';

// ========== CONFIGURACIÓN DE SEGURIDAD ==========

// Helmet para headers de seguridad básicos
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: [
        "'self'", 
        "'unsafe-inline'", // Necesario para scripts inline
        "https://unpkg.com",
        "https://cdn.jsdelivr.net",
        "https://cdnjs.cloudflare.com"
      ],
      styleSrc: [
        "'self'", 
        "'unsafe-inline'", // Necesario para estilos inline
        "https://cdn.jsdelivr.net",
        "https://cdnjs.cloudflare.com"
      ],
      fontSrc: [
        "'self'",
        "https://cdnjs.cloudflare.com"
      ],
      imgSrc: ["'self'", "data:"],
      connectSrc: ["'self'"]
    }
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  }
}));

// Headers de seguridad personalizados
app.use(securityHeaders);

// Rate limiting general (temporalmente comentado para debugging)
// app.use('/api/', apiLimiter);

// Configuración de CORS mejorada
const corsOptions = {
  origin: function (origin, callback) {
    const allowedOrigins = isProduction 
      ? [
          process.env.FRONTEND_URL, 
          process.env.RENDER_EXTERNAL_URL,
          'https://servicios-prados-de-nos.onrender.com'
        ].filter(Boolean)
      : [
          'http://localhost:3000', 
          'http://127.0.0.1:3000',
          'http://localhost:5000'
        ];
    
    // Permitir requests sin origin (mobile apps, postman, etc.)
    if (!origin) return callback(null, true);
    
    if (allowedOrigins.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      console.log(`🚨 CORS: Origin bloqueado: ${origin}`);
      callback(new Error('Bloqueado por política CORS'));
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
  optionsSuccessStatus: 200 // Para soporte legacy IE11
};

// ========== MIDDLEWARES BÁSICOS ==========

// Usar CORS mejorado si está disponible, sino usar el existente
const corsConfig = enhancedCorsOptions || corsOptions;
app.use(cors(corsConfig));
app.use(express.json({ 
  limit: '1mb', // Reducido para seguridad
  strict: true
}));
app.use(express.urlencoded({ 
  extended: true, 
  limit: '1mb',
  parameterLimit: 20 // Limitar parámetros
}));

// Configuración de sesiones segura pero compatible
app.use(session({
  secret: process.env.SESSION_SECRET || 'checkin-secret-key-change-in-production',
  resave: false,
  saveUninitialized: false,
  rolling: false, // Deshabilitado temporalmente para evitar problemas
  cookie: { 
    secure: false, // Temporal: forzar false para debugging
    httpOnly: true,
    maxAge: 8 * 60 * 60 * 1000, // 8 horas
    sameSite: 'lax' // Más compatible que 'none'
  },
  name: 'checkin.sid'
  // Comentado temporalmente para evitar problemas de compatibilidad
  // genid: function(req) {
  //   const crypto = require('crypto');
  //   return crypto.randomBytes(32).toString('hex');
  // }
}));

// Middleware de limpieza automática (ejecutar cada hora)
let lastCleanup = Date.now();
app.use((req, res, next) => {
  const now = Date.now();
  if (now - lastCleanup > 60 * 60 * 1000) { // 1 hora
    cleanExpiredSessions(req, res, () => {});
    lastCleanup = now;
  }
  next();
});

// ========== LOGS Y MONITOREO ==========

// Advertencia sobre MemoryStore en producción
if (isProduction) {
  console.log('⚠️  SECURITY: Se está usando MemoryStore para sesiones en producción.');
  console.log('⚠️  SECURITY: Para producción real, considera usar connect-redis o similar.');
}

// Middleware de logging mejorado
app.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  const ip = req.ip || req.connection.remoteAddress;
  const userAgent = req.get('User-Agent') || 'Unknown';
  
  if (isProduction || process.env.LOG_REQUESTS === 'true') {
    console.log(`[${timestamp}] ${req.method} ${req.path} - IP: ${ip} - UA: ${userAgent.substring(0, 50)}`);
  }
  
  // Log de requests sospechosos
  const suspiciousPaths = ['/admin', '/.env', '/config', '/wp-admin', '/phpmyadmin'];
  if (suspiciousPaths.some(path => req.path.toLowerCase().includes(path))) {
    console.log(`🚨 SECURITY: Request sospechoso desde ${ip}: ${req.method} ${req.path}`);
  }
  
  next();
});

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
app.use('/api/checkins', publicRoutes); // Para /api/checkins/public
app.use('/api/admin', adminRoutes);
app.use('/api/eventos', eventosRoutes);
app.use('/api/documentos', documentosRoutes);
app.use('/api/init', initRoutes);

// Rutas de módulos de gestión residencial
app.use('/api/casas', casasRoutes);
app.use('/api/residentes', residentesRoutes);
app.use('/api/mascotas', mascotasRoutes);
app.use('/api/pagos', pagosRoutes);
app.use('/api/vehiculos', vehiculosRoutes);
app.use('/api/acceso', accesoRoutes);

app.use('/api', publicRoutes); // Esta debe ir al final para no interceptar otras rutas

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

// Rutas específicas para archivos HTML importantes
app.get('/qr_plazas.html', (req, res) => {
  const possiblePaths = [
    path.join(__dirname, 'public', 'qr_plazas.html'),
    path.join(__dirname, '../public', 'qr_plazas.html')
  ];
  
  for (const filePath of possiblePaths) {
    if (require('fs').existsSync(filePath)) {
      return res.sendFile(filePath);
    }
  }
  
  res.status(404).json({ 
    error: 'Archivo qr_plazas.html no encontrado',
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString()
  });
});

app.get('/generar_tokens.html', (req, res) => {
  const possiblePaths = [
    path.join(__dirname, 'public', 'generar_tokens.html'),
    path.join(__dirname, '../public', 'generar_tokens.html')
  ];
  
  for (const filePath of possiblePaths) {
    if (require('fs').existsSync(filePath)) {
      return res.sendFile(filePath);
    }
  }
  
  res.status(404).json({ 
    error: 'Archivo generar_tokens.html no encontrado',
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString()
  });
});

// Ruta por defecto para SPA (Single Page App)
app.get('*', (req, res) => {
  // Evitar que rutas de API sean capturadas aquí
  if (req.path.startsWith('/api/')) {
    return res.status(404).json({ 
      error: 'Ruta no encontrada',
      path: req.path,
      method: req.method,
      timestamp: new Date().toISOString()
    });
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
app.listen(PORT, '0.0.0.0', async () => {
  console.log(`🚀 Servidor corriendo en puerto ${PORT}`);
  console.log(`🌍 Entorno: ${NODE_ENV}`);
  console.log(`⚡ Health check disponible en: http://localhost:${PORT}/health`);
  
  if (isProduction) {
    console.log('🔒 Modo producción: Funciones de seguridad habilitadas');
  } else {
    console.log('🛠️  Modo desarrollo: Algunas funciones de seguridad deshabilitadas para debugging');
  }
  
  // Configurar tabla de security_logs automáticamente
  try {
    await setupSecurityTable();
  } catch (error) {
    console.log('⚠️  Sistema funcionará sin logs de seguridad avanzados');
  }
  
  // Debug: Verificar rutas de archivos (con manejo de errores)
  const publicPaths = [
    path.join(__dirname, 'public'),
    path.join(__dirname, '../public')
  ];
  
  publicPaths.forEach(publicPath => {
    const loginPath = path.join(publicPath, 'login.html');
    const dirExists = require('fs').existsSync(publicPath);
    const fileExists = require('fs').existsSync(loginPath);
    
    console.log(`📁 Directorio: ${publicPath} - Existe: ${dirExists}`);
    console.log(`📄 Login.html: ${loginPath} - Existe: ${fileExists}`);
    
    if (dirExists) {
      try {
        const contents = require('fs').readdirSync(publicPath);
        console.log(`📂 Contenido: ${contents.join(', ')}`);
      } catch (err) {
        console.log(`❌ Error leyendo directorio: ${err.message}`);
      }
    }
  });
  
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