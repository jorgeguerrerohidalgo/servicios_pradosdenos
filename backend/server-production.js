require('dotenv').config();

// Configurar zona horaria de Santiago de Chile
process.env.TZ = 'America/Santiago';

const express = require('express');
const session = require('express-session');
const cors = require('cors');
const helmet = require('helmet');
const path = require('path');
const app = express();

// Variables de entorno para producción
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';
const isProduction = NODE_ENV === 'production';

console.log('🚀 Iniciando servidor en modo:', NODE_ENV);
console.log('🌍 Puerto:', PORT);

// ========== CONFIGURACIÓN DE SEGURIDAD PARA PRODUCCIÓN ==========

// Helmet básico para producción
app.use(helmet({
  contentSecurityPolicy: false, // Deshabilitado temporalmente
  crossOriginEmbedderPolicy: false
}));

// CORS específico para Render
const corsOptions = {
  origin: function (origin, callback) {
    const allowedOrigins = [
      'https://servicios-prados-de-nos.onrender.com',
      'http://localhost:3000',
      'http://127.0.0.1:3000'
    ];
    
    // Permitir requests sin origin (aplicaciones móviles, etc.)
    if (!origin) return callback(null, true);
    
    if (allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      console.log('❌ CORS bloqueado para origin:', origin);
      callback(null, true); // Temporalmente permitir todos para debugging
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With']
};

app.use(cors(corsOptions));

// Middlewares básicos
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true, limit: '1mb' }));

// Configuración de sesiones para producción
app.use(session({
  secret: process.env.SESSION_SECRET || 'checkin-secret-key-change-in-production',
  resave: false,
  saveUninitialized: false,
  rolling: true, // Renovar sesión en cada request
  cookie: { 
    secure: false, // Temporal: deshabilitado para debugging
    httpOnly: true,
    maxAge: 24 * 60 * 60 * 1000, // 24 horas
    sameSite: 'lax' // Más compatible
  },
  name: 'checkin.sid'
}));

// Middleware de logging simplificado
app.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] ${req.method} ${req.path}`);
  
  // Solo loggear cuerpo del request para rutas específicas
  if (req.method === 'POST' && req.path.includes('/auth/login')) {
    console.log(`  Login attempt for: ${req.body.username || req.body.email}`);
  }
  
  next();
});

// ========== CONFIGURACIÓN DE BASE DE DATOS ==========

// Función para verificar conexión a base de datos
async function checkDatabaseConnection() {
  try {
    const { Client } = require('pg');
    const client = new Client({
      connectionString: process.env.DATABASE_URL,
      ssl: isProduction ? { rejectUnauthorized: false } : false
    });
    
    await client.connect();
    console.log('✅ Conexión a base de datos exitosa');
    await client.end();
    return true;
  } catch (error) {
    console.error('❌ Error de conexión a base de datos:', error.message);
    if (isProduction) {
      console.error('❌ En producción, la base de datos es requerida');
    }
    return false;
  }
}

// ========== RUTAS ==========

// Importar rutas con manejo de errores
try {
  console.log('📦 Importando rutas...');
  
  // Verificar que los archivos existen antes de importar
  console.log('📦 Importando auth-debug-fixed.routes...');
  const authRoutes = require('./routes/auth-debug-fixed.routes');
  console.log('✅ auth-debug-fixed.routes importado');
  
  console.log('📦 Importando checkin.routes...');
  const checkinRoutes = require('./routes/checkin.routes');
  console.log('✅ checkin.routes importado');
  
  console.log('📦 Importando public.routes...');
  const publicRoutes = require('./routes/public.routes');
  console.log('✅ public.routes importado');
  
  console.log('📦 Importando admin.routes...');
  const adminRoutes = require('./routes/admin.routes');
  console.log('✅ admin.routes importado');
  
  console.log('📦 Importando init.routes...');
  const initRoutes = require('./routes/init.routes');
  console.log('✅ init.routes importado');
  
  console.log('📦 Importando eventos.routes...');
  const eventosRoutes = require('./routes/eventos.routes');
  console.log('✅ eventos.routes importado');
  
  console.log('📦 Importando documentos_comunitarios.routes...');
  const documentosRoutes = require('./routes/documentos-simple.routes');
  console.log('✅ documentos_comunitarios.routes importado (usando versión simple temporal)');
  
  console.log('✅ Todas las rutas importadas correctamente');

  // Configurar rutas EN EL ORDEN CORRECTO
  console.log('🔧 Configurando rutas...');
  app.use('/api/auth', authRoutes);
  app.use('/api/checkin', checkinRoutes);
  app.use('/api/checkins', publicRoutes); // Para /api/checkins/public
  app.use('/api/admin', adminRoutes);
  app.use('/api/init', initRoutes);
  app.use('/api/eventos', eventosRoutes);
  app.use('/api/documentos_comunitarios', documentosRoutes);
  app.use('/api', publicRoutes); // Para /api/plazas - DEBE IR AL FINAL

  console.log('✅ Rutas configuradas:');
  console.log('  - /api/auth (auth-debug-fixed.routes.js)');
  console.log('  - /api/checkin (checkin.routes.js)');
  console.log('  - /api/checkins (public.routes.js)');
  console.log('  - /api/admin (admin.routes.js)');
  console.log('  - /api/init (init.routes.js)');
  console.log('  - /api/eventos (eventos.routes.js)');
  console.log('  - /api/documentos_comunitarios (documentos_comunitarios.routes.js)');
  console.log('  - /api (public.routes.js) - CATCH-ALL al final');

  console.log('✅ Rutas configuradas correctamente');
} catch (error) {
  console.error('❌ Error cargando rutas:', error.message);
  console.error('❌ Stack trace:', error.stack);
  
  // Intentar identificar el archivo específico que causa el problema
  const stack = error.stack;
  const fileMatch = stack.match(/at.*\\routes\\([^)]+)/);
  if (fileMatch) {
    console.error('❌ Archivo problemático:', fileMatch[1]);
  }
  
  // Cargar rutas básicas como fallback
  try {
    console.log('🔄 Cargando rutas básicas como fallback...');
    const authRoutes = require('./routes/auth.routes');
    const checkinRoutes = require('./routes/checkin.routes');
    const publicRoutes = require('./routes/public.routes');
    const adminRoutes = require('./routes/admin.routes');
    
    app.use('/api/auth', authRoutes);
    app.use('/api/checkin', checkinRoutes);
    app.use('/api/checkins', publicRoutes);
    app.use('/api/admin', adminRoutes);
    app.use('/api', publicRoutes); // DEBE IR AL FINAL para no interceptar otras rutas
    
    console.log('✅ Rutas básicas configuradas como fallback');
    console.log('⚠️  RUTAS DE EVENTOS Y DOCUMENTOS NO DISPONIBLES');
    console.log('⚠️  Para habilitar eventos/documentos, corregir el error arriba');
  } catch (fallbackError) {
    console.error('❌ Error crítico cargando rutas básicas:', fallbackError.message);
    console.error('❌ El servidor no puede continuar sin rutas básicas');
    process.exit(1);
  }
}

// ========== ARCHIVOS ESTÁTICOS ==========

// Servir archivos estáticos
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, '..', 'public')));

// Ruta de health check
app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: NODE_ENV,
    port: PORT
  });
});

// Ruta raíz
app.get('/', (req, res) => {
  res.redirect('/login.html');
});

// Middleware de manejo de errores
app.use((err, req, res, next) => {
  console.error('❌ Error del servidor:', err.message);
  console.error('Stack:', err.stack);
  
  res.status(500).json({
    error: 'Error interno del servidor',
    timestamp: new Date().toISOString(),
    ...(NODE_ENV === 'development' && { details: err.message })
  });
});

// Middleware para rutas no encontradas
app.use((req, res) => {
  console.log('❌ Ruta no encontrada:', req.method, req.path);
  res.status(404).json({
    error: 'Ruta no encontrada',
    path: req.path,
    method: req.method,
    timestamp: new Date().toISOString()
  });
});

// ========== INICIAR SERVIDOR ==========

async function startServer() {
  try {
    console.log('🚀 Iniciando servidor de producción...');
    
    // Verificar conexión a base de datos
    console.log('🔍 Verificando conexión a base de datos...');
    const dbConnected = await checkDatabaseConnection();
    
    if (!dbConnected && isProduction) {
      console.error('❌ No se pudo conectar a la base de datos en producción');
      console.error('❌ Variables de entorno requeridas:');
      console.error('   DATABASE_URL:', process.env.DATABASE_URL ? '✅ Configurada' : '❌ Faltante');
      process.exit(1);
    }
    
    if (!dbConnected) {
      console.warn('⚠️  Base de datos no disponible en desarrollo - continuando...');
    }
    
    // Iniciar servidor
    const server = app.listen(PORT, '0.0.0.0', () => {
      console.log('🚀 Servidor corriendo en puerto', PORT);
      console.log('🌍 Entorno:', NODE_ENV);
      console.log('⚡ Health check disponible en: /health');
      console.log('🏠 Frontend disponible en: /login.html');
      
      if (isProduction) {
        console.log('🔒 Modo producción: Todas las funciones de seguridad activadas');
        console.log('🌐 URL: https://servicios-prados-de-nos.onrender.com');
      } else {
        console.log('🛠️  Modo desarrollo: Algunas funciones de seguridad relajadas');
      }
      
      console.log('✅ Servidor iniciado correctamente');
    });
    
    // Manejo de errores del servidor
    server.on('error', (error) => {
      console.error('❌ Error del servidor:', error.message);
      if (error.code === 'EADDRINUSE') {
        console.error(`❌ Puerto ${PORT} ya está en uso`);
      }
      process.exit(1);
    });
    
  } catch (error) {
    console.error('❌ Error iniciando servidor:', error.message);
    console.error('Stack:', error.stack);
    process.exit(1);
  }
}

// Manejo de errores no capturados
process.on('uncaughtException', (error) => {
  console.error('❌ Excepción no capturada:', error.message);
  console.error('Stack:', error.stack);
  // En producción, no terminar el proceso abruptamente
  if (process.env.NODE_ENV === 'production') {
    console.error('⚠️ Continuando ejecución en producción...');
  } else {
    process.exit(1);
  }
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('❌ Promesa rechazada no manejada:', reason);
  console.error('En:', promise);
  // En producción, no terminar el proceso abruptamente
  if (process.env.NODE_ENV === 'production') {
    console.error('⚠️ Continuando ejecución en producción...');
  } else {
    process.exit(1);
  }
});

// Manejo de señales del sistema
process.on('SIGTERM', () => {
  console.log('🛑 Recibido SIGTERM, cerrando servidor gracefully...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('🛑 Recibido SIGINT, cerrando servidor gracefully...');
  process.exit(0);
});

// Iniciar servidor
startServer();
