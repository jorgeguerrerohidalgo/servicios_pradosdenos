const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const db = require('../utils/db');

// Ruta de login simplificada para debugging
router.post('/login', async (req, res) => {
    const { email, password } = req.body;
    
    try {
        console.log('🔍 LOGIN ATTEMPT:', { email, hasPassword: !!password });
        
        if (!email || !password) {
            return res.status(400).json({ error: 'Email y contraseña son requeridos' });
        }
        
        // Buscar en guardias
        let user = await db.query('SELECT * FROM guardias WHERE email = $1 AND activo = true', [email]);
        let userType = 'guardia';
        
        // Si no se encuentra, buscar en admin_users
        if (user.length === 0) {
            user = await db.query('SELECT *, password_hash as password FROM admin_users WHERE email = $1', [email]);
            userType = 'admin';
        }
        
        if (user.length === 0) {
            console.log('❌ USER NOT FOUND:', email);
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }
        
        const foundUser = user[0];
        console.log('✅ USER FOUND:', { id: foundUser.id, email: foundUser.email, type: userType });
        
        if (!foundUser.password) {
            console.log('❌ NO PASSWORD SET for user:', foundUser.id);
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }
        
        // Verificar contraseña
        let isValidPassword = false;
        
        if (foundUser.password.startsWith('$2b$')) {
            isValidPassword = await bcrypt.compare(password, foundUser.password);
        } else {
            isValidPassword = password === foundUser.password;
            
            // Hash automático si es texto plano
            if (isValidPassword) {
                const hashedPassword = await bcrypt.hash(password, 12);
                if (userType === 'guardia') {
                    await db.query('UPDATE guardias SET password = $1 WHERE id = $2', [hashedPassword, foundUser.id]);
                } else {
                    await db.query('UPDATE admin_users SET password_hash = $1 WHERE id = $2', [hashedPassword, foundUser.id]);
                }
                console.log('🔒 Password migrated for user:', foundUser.id);
            }
        }
        
        if (!isValidPassword) {
            console.log('❌ INVALID PASSWORD for user:', foundUser.id);
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }
        
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
        
        res.json({ 
            message: 'Login exitoso',
            guardia: {
                id: foundUser.id,
                nombre: userName,
                email: foundUser.email,
                tipo: userType
            }
        });
        
    } catch (error) {
        console.error('❌ LOGIN ERROR:', error);
        res.status(500).json({ error: 'Error interno del servidor' });
    }
});

module.exports = router;
