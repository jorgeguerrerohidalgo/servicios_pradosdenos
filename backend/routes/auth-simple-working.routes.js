const express = require('express');
const router = express.Router();
const db = require('../utils/db');
const bcrypt = require('bcrypt');

router.post('/login', async (req, res) => {
    try {
        console.log('🔍 LOGIN REQUEST - Email:', req.body.email);
        
        const { email, username, password } = req.body;
        const loginField = email || username;
        
        if (!loginField || !password) {
            console.log('❌ Missing credentials');
            return res.status(400).json({ error: 'Email y contraseña son requeridos' });
        }
        
        console.log('🔍 Searching for user:', loginField);
        
        // Buscar en admin_users primero
        let result = await db.query('SELECT * FROM admin_users WHERE email = $1 AND activo = true', [loginField]);
        let userType = 'admin';
        let passwordField = 'password_hash';
        console.log('🔍 Admin_users result count:', result.rows.length);
        
        if (result.rows.length === 0) {
            // Buscar en guardias
            console.log('🔍 User not found in admin_users, trying guardias...');
            result = await db.query('SELECT * FROM guardias WHERE email = $1 AND activo = true', [loginField]);
            userType = 'guardia';
            passwordField = 'password';
            console.log('🔍 Guardias result count:', result.rows.length);
        }
        
        if (result.rows.length === 0) {
            console.log('❌ User not found in any table for:', loginField);
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }
        
        const user = result.rows[0];
        console.log('✅ User found:', { id: user.id, email: user.email, type: userType });
        
        // Verificar contraseña
        const storedPassword = user[passwordField];
        console.log('🔍 Password check - hasStoredPassword:', !!storedPassword);
        let passwordMatch = false;
        
        if (storedPassword) {
            // Intentar bcrypt primero
            try {
                passwordMatch = await bcrypt.compare(password, storedPassword);
                console.log('🔍 Bcrypt result:', passwordMatch);
                if (!passwordMatch) {
                    // Si bcrypt falla, intentar comparación directa
                    passwordMatch = (storedPassword === password);
                    console.log('🔍 Direct comparison result:', passwordMatch);
                }
            } catch (error) {
                console.log('🔍 Bcrypt failed, trying direct comparison...', error.message);
                // Si bcrypt falla, usar comparación directa
                passwordMatch = (storedPassword === password);
                console.log('🔍 Direct comparison result:', passwordMatch);
            }
        } else {
            console.log('❌ No stored password found');
        }
        
        if (!passwordMatch) {
            console.log('❌ Password mismatch');
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }
        
        console.log('✅ Password match - creating session');
        
        // Crear sesión
        const userName = user.nombre || user.email;
        
        req.session.guardia = {
            id: user.id,
            nombre: userName,
            email: user.email,
            tipo: userType,
            loginTime: new Date().toISOString()
        };
        
        console.log('✅ Session created successfully');
        
        return res.json({
            message: 'Login exitoso',
            guardia: {
                id: user.id,
                nombre: userName,
                email: user.email,
                tipo: userType
            }
        });
        
    } catch (error) {
        console.error('❌ LOGIN ERROR:', error);
        return res.status(500).json({
            error: 'Error interno del servidor',
            details: error.message,
            timestamp: new Date().toISOString()
        });
    }
});

// Ruta para verificar sesión
router.get('/check', (req, res) => {
    try {
        if (req.session && req.session.guardia) {
            res.json({
                isAuthenticated: true,
                guardia: req.session.guardia
            });
        } else {
            res.json({
                isAuthenticated: false
            });
        }
    } catch (error) {
        console.error('❌ CHECK ERROR:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

// Ruta para logout
router.post('/logout', (req, res) => {
    try {
        req.session.destroy((err) => {
            if (err) {
                console.error('❌ LOGOUT ERROR:', err);
                return res.status(500).json({ error: 'Error al cerrar sesión' });
            }
            res.json({ message: 'Sesión cerrada exitosamente' });
        });
    } catch (error) {
        console.error('❌ LOGOUT ERROR:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

module.exports = router;
