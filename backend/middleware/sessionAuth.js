// Middleware de autenticación por sesiones
const requireAuth = (req, res, next) => {
  console.log('🔍 Verificando autenticación por sesión...');
  
  if (!req.session || !req.session.guardia) {
    console.log('❌ No hay sesión activa');
    return res.status(401).json({ 
      success: false, 
      message: 'No autenticado - sesión requerida',
      authenticated: false
    });
  }
  
  // Verificar que la sesión no haya expirado
  const loginTime = req.session.guardia.loginTime;
  if (loginTime) {
    const sessionAge = Date.now() - new Date(loginTime).getTime();
    const maxSessionAge = 8 * 60 * 60 * 1000; // 8 horas
    
    if (sessionAge > maxSessionAge) {
      console.log('⏰ Sesión expirada');
      req.session.destroy();
      return res.status(401).json({ 
        success: false, 
        message: 'Sesión expirada',
        authenticated: false
      });
    }
  }
  
  console.log('✅ Sesión válida para:', req.session.guardia.email);
  req.user = req.session.guardia; // Para compatibilidad
  next();
};

// Middleware para verificar que el usuario es administrador
const requireAdmin = (req, res, next) => {
  console.log('🔍 Verificando permisos de administrador...');
  
  if (!req.session || !req.session.guardia) {
    console.log('❌ No hay sesión activa para verificar admin');
    return res.status(401).json({ 
      success: false, 
      message: 'No autenticado',
      authenticated: false
    });
  }
  
  if (req.session.guardia.tipo !== 'admin') {
    console.log('❌ Usuario no es administrador:', req.session.guardia.tipo);
    return res.status(403).json({ 
      success: false, 
      message: 'Acceso denegado - se requieren permisos de administrador' 
    });
  }
  
  console.log('✅ Usuario administrador verificado:', req.session.guardia.email);
  req.user = req.session.guardia; // Para compatibilidad
  next();
};

// Middleware combinado: autenticación + admin
const requireAuthAdmin = [requireAuth, requireAdmin];

module.exports = {
  requireAuth,
  requireAdmin,
  requireAuthAdmin
};
