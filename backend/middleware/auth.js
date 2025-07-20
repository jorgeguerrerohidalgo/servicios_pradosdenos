const jwt = require('jsonwebtoken');
const db = require('../utils/db');

/**
 * Middleware de autenticación JWT para admin_users
 */
const authenticateToken = async (req, res, next) => {
    try {
        const token = req.header('Authorization')?.replace('Bearer ', '');
        
        if (!token) {
            return res.status(401).json({ 
                success: false, 
                message: 'Token de acceso requerido' 
            });
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        
        // Verificar que el admin existe y está activo
        const adminResult = await db.query(`
            SELECT id, nombre, apellido_paterno, apellido_materno, email, activo, plaza_id
            FROM admin_users 
            WHERE id = $1 AND activo = TRUE
        `, [decoded.userId]);

        if (adminResult.rows.length === 0) {
            return res.status(401).json({ 
                success: false, 
                message: 'Usuario administrativo no encontrado o inactivo' 
            });
        }

        const admin = adminResult.rows[0];
        req.user = admin;
        next();

    } catch (error) {
        if (error.name === 'JsonWebTokenError') {
            return res.status(401).json({ 
                success: false, 
                message: 'Token inválido' 
            });
        }
        
        if (error.name === 'TokenExpiredError') {
            return res.status(401).json({ 
                success: false, 
                message: 'Token expirado' 
            });
        }

        console.error('Error en authenticateToken:', error);
        return res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
};

/**
 * Middleware para requerir usuario admin
 */
const requireAdmin = (req, res, next) => {
    if (!req.user) {
        return res.status(401).json({ 
            success: false, 
            message: 'Usuario no autenticado' 
        });
    }

    // Todos los usuarios en admin_users son admins por defecto
    // Si en el futuro se añade un campo rol, se puede verificar aquí
    next();
};

/**
 * Middleware para verificar si el usuario es admin o es el propietario del recurso
 */
const requireAdminOrOwner = (ownerIdParam = 'userId') => {
    return (req, res, next) => {
        if (!req.user) {
            return res.status(401).json({ 
                success: false, 
                message: 'Usuario no autenticado' 
            });
        }

        const resourceOwnerId = parseInt(req.params[ownerIdParam]);
        
        // Si es el mismo usuario o es admin (todos en admin_users son admin)
        if (req.user.id === resourceOwnerId) {
            next();
        } else {
            return res.status(403).json({ 
                success: false, 
                message: 'Permisos insuficientes' 
            });
        }
    };
};

module.exports = {
    authenticateToken,
    requireAdmin,
    requireAdminOrOwner,
    // Legacy exports para compatibilidad
    authMiddleware: authenticateToken
};
