const jwt = require('jsonwebtoken');
const db = require('../utils/db');

/**
 * Middleware de autenticación JWT
 */
const authMiddleware = async (req, res, next) => {
    try {
        const token = req.header('Authorization')?.replace('Bearer ', '');
        
        if (!token) {
            return res.status(401).json({ 
                success: false, 
                message: 'Token de acceso requerido' 
            });
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        
        // Verificar que el usuario existe y está activo
        const userResult = await db.query(`
            SELECT id, nombre, email, rol, activo, token_version
            FROM usuarios 
            WHERE id = $1 AND activo = TRUE
        `, [decoded.userId]);

        if (userResult.rows.length === 0) {
            return res.status(401).json({ 
                success: false, 
                message: 'Usuario no encontrado o inactivo' 
            });
        }

        const user = userResult.rows[0];

        // Verificar versión del token para invalidar tokens antiguos
        if (decoded.tokenVersion !== user.token_version) {
            return res.status(401).json({ 
                success: false, 
                message: 'Token inválido' 
            });
        }

        req.user = user;
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

        console.error('Error en authMiddleware:', error);
        return res.status(500).json({ 
            success: false, 
            message: 'Error interno del servidor' 
        });
    }
};

/**
 * Middleware para requerir roles específicos
 */
const requireRole = (requiredRole) => {
    return (req, res, next) => {
        if (!req.user) {
            return res.status(401).json({ 
                success: false, 
                message: 'Usuario no autenticado' 
            });
        }

        // Verificar rol específico
        if (req.user.rol !== requiredRole) {
            return res.status(403).json({ 
                success: false, 
                message: 'Permisos insuficientes' 
            });
        }

        next();
    };
};

/**
 * Middleware para verificar múltiples roles
 */
const requireAnyRole = (allowedRoles) => {
    return (req, res, next) => {
        if (!req.user) {
            return res.status(401).json({ 
                success: false, 
                message: 'Usuario no autenticado' 
            });
        }

        if (!allowedRoles.includes(req.user.rol)) {
            return res.status(403).json({ 
                success: false, 
                message: 'Permisos insuficientes' 
            });
        }

        next();
    };
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

        const resourceOwnerId = req.params[ownerIdParam];
        
        if (req.user.rol === 'admin' || req.user.id === resourceOwnerId) {
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
    authMiddleware,
    requireRole,
    requireAnyRole,
    requireAdminOrOwner
};
