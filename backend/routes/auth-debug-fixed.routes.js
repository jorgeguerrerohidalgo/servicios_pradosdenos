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
            timestamp: new Date().toISOString(),
            ip: req.ip,
            userAgent: req.get('User-Agent')
        });
        
        if (!email || !password) {
            console.log('❌ MISSING CREDENTIALS:', { email: !!email, password: !!password });
            return res.status(400).json({ error: 'Email y contraseña son requeridos' });
        }
        
        console.log('🔍 SEARCHING FOR USER:', email);
        console.log('🔍 DATABASE URL configured:', !!process.env.DATABASE_URL);
        
        // Buscar en guardias
        console.log('🔍 Step 1: Searching in guardias table...');
        let user = await db.query('SELECT * FROM guardias WHERE email = $1 AND activo = true', [email]);
        let userType = 'guardia';
        
        console.log('🔍 GUARDIAS SEARCH RESULT:', { 
            found: user.length > 0, 
            count: user.length,
            query: 'SELECT * FROM guardias WHERE email = $1 AND activo = true',
            params: [email]
        });
        
        // Si no se encuentra, buscar en admin_users
        if (user.length === 0) {
            console.log('🔍 Step 2: Searching in admin_users table...');
            user = await db.query('SELECT *, password_hash as password FROM admin_users WHERE email = $1 AND activo = true', [email]);
            userType = 'admin';
            console.log('🔍 ADMIN_USERS SEARCH RESULT:', { 
                found: user.length > 0, 
                count: user.length,
                query: 'SELECT *, password_hash as password FROM admin_users WHERE email = $1 AND activo = true',
                params: [email]
            });
        }
        
        if (user.length === 0) {
            console.log('❌ USER NOT FOUND:', email);
            console.log('🔍 Attempted tables: guardias, admin_users');
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }
        
        const foundUser = user[0];
        console.log('✅ USER FOUND:', { 
            id: foundUser.id, 
            email: foundUser.email, 
            type: userType,
            hasPassword: !!foundUser.password,
            passwordInDB: foundUser.password ? `${foundUser.password.substring(0, 10)}...` : 'null'
        });
        
        // Verificar contraseña - manejar tanto bcrypt como texto plano
        console.log('🔍 Step 3: Verifying password...');
        let passwordMatch = false;
        
        if (foundUser.password) {
            // Primero intentar comparación directa (texto plano)
            console.log('🔍 Trying plain text comparison...');
            if (foundUser.password === password) {
                passwordMatch = true;
                console.log('✅ PASSWORD MATCH (plain text)');
            } else {
                // Intentar comparación con bcrypt
                console.log('🔍 Trying bcrypt comparison...');
                try {
                    passwordMatch = await bcrypt.compare(password, foundUser.password);
                    if (passwordMatch) {
                        console.log('✅ PASSWORD MATCH (bcrypt)');
                    } else {
                        console.log('❌ PASSWORD MISMATCH (both plain and bcrypt failed)');
                        console.log('🔍 Expected (first 10 chars):', foundUser.password.substring(0, 10));
                        console.log('🔍 Received:', password);
                    }
                } catch (bcryptError) {
                    console.log('❌ BCRYPT ERROR:', bcryptError.message);
                    console.log('🔍 Falling back to already tried plain text comparison');
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
            
            console.log('✅ LOGIN SUCCESS:', { 
                userId: foundUser.id, 
                type: userType,
                sessionCreated: !!req.session.guardia
            });
            
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
        console.error('❌ LOGIN ERROR:', error.message);
        console.error('❌ ERROR TYPE:', error.constructor.name);
        console.error('❌ ERROR CODE:', error.code);
        console.error('❌ ERROR STACK:', error.stack);
        
        // Detalles adicionales para debugging
        console.error('🔍 Environment variables:');
        console.error('  - NODE_ENV:', process.env.NODE_ENV);
        console.error('  - DATABASE_URL configured:', !!process.env.DATABASE_URL);
        console.error('  - SESSION_SECRET configured:', !!process.env.SESSION_SECRET);
        
        res.status(500).json({ 
            error: 'Error interno del servidor',
            timestamp: new Date().toISOString(),
            details: error.message,
            code: error.code
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
