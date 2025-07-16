const express = require('express');
const router = express.Router();
const db = require('../utils/db');
const bcrypt = require('bcrypt');

// Ruta de login que maneja tanto bcrypt como texto plano
router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        
        console.log('🔍 LOGIN ATTEMPT:', { 
            email, 
            hasPassword: !!password,
            passwordLength: password ? password.length : 0,
            timestamp: new Date().toISOString()
        });
        
        if (!email || !password) {
            console.log('❌ MISSING CREDENTIALS:', { email: !!email, password: !!password });
            return res.status(400).json({ error: 'Email y contraseña son requeridos' });
        }
        
        console.log('🔍 SEARCHING FOR USER:', email);
        
        // Buscar en guardias
        let user = await db.query('SELECT * FROM guardias WHERE email = $1 AND activo = true', [email]);
        let userType = 'guardia';
        
        console.log('🔍 GUARDIAS SEARCH RESULT:', { found: user.length > 0, count: user.length });
        
        // Si no se encuentra, buscar en admin_users
        if (user.length === 0) {
            user = await db.query('SELECT *, password_hash as password FROM admin_users WHERE email = $1', [email]);
            userType = 'admin';
            console.log('🔍 ADMIN_USERS SEARCH RESULT:', { found: user.length > 0, count: user.length });
        }
        
        if (user.length === 0) {
            console.log('❌ USER NOT FOUND:', email);
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }
        
        const foundUser = user[0];
        console.log('✅ USER FOUND:', { 
            id: foundUser.id, 
            email: foundUser.email, 
            type: userType,
            hasPassword: !!foundUser.password
        });
        
        // Verificar contraseña - manejar tanto bcrypt como texto plano
        let passwordMatch = false;
        
        if (foundUser.password) {
            // Primero intentar comparación directa (texto plano)
            if (foundUser.password === password) {
                passwordMatch = true;
                console.log('✅ PASSWORD MATCH (plain text)');
            } else {
                // Intentar comparación con bcrypt
                try {
                    passwordMatch = await bcrypt.compare(password, foundUser.password);
                    if (passwordMatch) {
                        console.log('✅ PASSWORD MATCH (bcrypt)');
                    } else {
                        console.log('❌ PASSWORD MISMATCH (both plain and bcrypt failed)');
                    }
                } catch (bcryptError) {
                    console.log('❌ BCRYPT ERROR:', bcryptError.message);
                    console.log('🔍 Trying plain text comparison as fallback');
                    // Ya intentamos texto plano arriba, así que no coincide
                }
            }
        } else {
            console.log('❌ NO PASSWORD FOUND IN DATABASE');
        }
        
        if (passwordMatch) {
            // Crear sesión
            const userName = userType === 'guardia' ? foundUser.nombre : `${foundUser.nombre} ${foundUser.apellido_paterno}`;
            
            req.session.guardia = {
                id: foundUser.id,
                nombre: userName,
                email: foundUser.email,
                tipo: userType,
                loginTime: new Date().toISOString(),
                ip: req.ip
            };
            
            console.log('✅ LOGIN SUCCESS:', { userId: foundUser.id, type: userType });
            
            return res.json({ 
                message: 'Login exitoso',
                guardia: {
                    id: foundUser.id,
                    nombre: userName,
                    email: foundUser.email,
                    tipo: userType
                }
            });
        } else {
            console.log('❌ PASSWORD MISMATCH for user:', foundUser.id);
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }
        
    } catch (error) {
        console.error('❌ LOGIN ERROR:', error);
        console.error('❌ ERROR STACK:', error.stack);
        res.status(500).json({ 
            error: 'Error interno del servidor',
            timestamp: new Date().toISOString(),
            details: error.message
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
