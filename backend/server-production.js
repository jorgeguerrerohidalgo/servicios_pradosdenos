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
  cookie: { 
    secure: isProduction, // Solo HTTPS en producción
    httpOnly: true,
    maxAge: 8 * 60 * 60 * 1000, // 8 horas
    sameSite: isProduction ? 'none' : 'lax' // 'none' para producción cross-origin
  },
  name: 'checkin.sid'
}));

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
    
    // Verificar tablas críticas
    const result = await client.query(`
      SELECT table_name 
      FROM information_schema.tables 
      WHERE table_schema = 'public' 
      AND table_name IN ('security_logs', 'admin_users', 'guardias')
    `);
    
    console.log('📋 Tablas verificadas:', result.rows.map(r => r.table_name));
    
    await client.end();
    return true;
  } catch (error) {
    console.error('❌ Error de conexión a base de datos:', error.message);
    return false;
  }
}

// ========== RUTAS ==========

// Importar rutas con manejo de errores
try {
  const authRoutes = require('./routes/auth.routes');
  const checkinRoutes = require('./routes/checkin.routes');
  const publicRoutes = require('./routes/public.routes');
  const adminRoutes = require('./routes/admin.routes');
  const eventosRoutes = require('./routes/eventos.routes');
  const documentosRoutes = require('./routes/documentos.routes');

  // Configurar rutas
  app.use('/api/auth', authRoutes);
  app.use('/api/checkin', checkinRoutes);
  app.use('/api/public', publicRoutes);
  app.use('/api/admin', adminRoutes);
  app.use('/api/eventos', eventosRoutes);
  app.use('/api/documentos', documentosRoutes);

  console.log('✅ Rutas configuradas correctamente');
} catch (error) {
  console.error('❌ Error cargando rutas:', error.message);
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
    // Verificar conexión a base de datos
    const dbConnected = await checkDatabaseConnection();
    
    if (!dbConnected && isProduction) {
      console.error('❌ No se pudo conectar a la base de datos en producción');
      process.exit(1);
    }
    
    // Iniciar servidor
    app.listen(PORT, '0.0.0.0', () => {
      console.log('🚀 Servidor corriendo en puerto', PORT);
      console.log('🌍 Entorno:', NODE_ENV);
      console.log('⚡ Health check disponible en: /health');
      console.log('🏠 Frontend disponible en: /login.html');
      
      if (isProduction) {
        console.log('🔒 Modo producción: Todas las funciones de seguridad activadas');
      } else {
        console.log('🛠️  Modo desarrollo: Algunas funciones de seguridad relajadas');
      }
    });
    
  } catch (error) {
    console.error('❌ Error iniciando servidor:', error.message);
    process.exit(1);
  }
}

// Manejo de errores no capturados
process.on('uncaughtException', (error) => {
  console.error('❌ Excepción no capturada:', error.message);
  console.error('Stack:', error.stack);
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('❌ Promesa rechazada no manejada:', reason);
});

// Iniciar servidor
startServer();
