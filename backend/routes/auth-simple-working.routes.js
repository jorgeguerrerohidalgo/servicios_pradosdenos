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
        
        // Test de conexión a DB antes de hacer queries
        try {
            console.log('🔍 Testing database connection...');
            const testResult = await db.query('SELECT 1 as test');
            console.log('✅ Database connection OK:', testResult?.[0]?.test === 1);
            console.log('🔍 Test result type:', typeof testResult, 'length:', testResult?.length);
        } catch (testError) {
            console.error('❌ Database connection failed:', testError.message);
            throw new Error(`Database connection failed: ${testError.message}`);
        }
        
        // Buscar en admin_users primero
        let result;
        let userType = 'admin';
        let passwordField = 'password_hash';
        
        try {
            console.log('🔍 Executing admin_users query...');
            const rows = await db.query('SELECT * FROM admin_users WHERE email = $1', [loginField]);
            console.log('🔍 Admin_users query successful - rows type:', typeof rows, 'length:', rows?.length);
            console.log('🔍 Admin_users result count:', rows?.length || 0);
            
            // La función db.query ya devuelve rows directamente, no un objeto result
            result = { rows: rows || [] };
            
            // Filtrar por activo después de obtener resultados
            if (result.rows && result.rows.length > 0) {
                const filteredRows = result.rows.filter(row => {
                    const isActive = row.activo === true || row.activo === 'true' || row.activo === 1;
                    console.log(`🔍 User ${row.email} - activo: ${row.activo} (${typeof row.activo}) - isActive: ${isActive}`);
                    return isActive;
                });
                result.rows = filteredRows;
                console.log('🔍 Admin_users active users count:', result.rows.length);
            }
        } catch (dbError) {
            console.error('❌ Database error in admin_users query:', dbError.message);
            throw new Error(`Database error: ${dbError.message}`);
        }
        
        if (!result || !result.rows || result.rows.length === 0) {
            // Buscar en guardias
            console.log('🔍 User not found in admin_users, trying guardias...');
            try {
                console.log('🔍 Executing guardias query...');
                const rows = await db.query('SELECT * FROM guardias WHERE email = $1', [loginField]);
                userType = 'guardia';
                passwordField = 'password';
                console.log('🔍 Guardias query successful - rows type:', typeof rows, 'length:', rows?.length);
                console.log('🔍 Guardias result count:', rows?.length || 0);
                
                // La función db.query ya devuelve rows directamente
                result = { rows: rows || [] };
                
                // Filtrar por activo después de obtener resultados
                if (result.rows && result.rows.length > 0) {
                    const filteredRows = result.rows.filter(row => {
                        const isActive = row.activo === true || row.activo === 'true' || row.activo === 1;
                        console.log(`🔍 Guardia ${row.email} - activo: ${row.activo} (${typeof row.activo}) - isActive: ${isActive}`);
                        return isActive;
                    });
                    result.rows = filteredRows;
                    console.log('🔍 Guardias active users count:', result.rows.length);
                }
            } catch (dbError) {
                console.error('❌ Database error in guardias query:', dbError.message);
                throw new Error(`Database error: ${dbError.message}`);
            }
        }
        
        if (!result || !result.rows || result.rows.length === 0) {
            console.log('❌ User not found in any table for:', loginField);
            console.log('🔍 Final result status:', { 
                hasResult: !!result, 
                hasRows: !!(result && result.rows), 
                rowCount: result?.rows?.length || 0 
            });
            return res.status(401).json({ error: 'Credenciales inválidas' });
        }
        
        const user = result.rows[0];
        console.log('✅ User found:', { 
            id: user.id, 
            email: user.email, 
            type: userType,
            activo: user.activo,
            activoType: typeof user.activo
        });
        
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

// Ruta temporal para debugging - ELIMINAR EN PRODUCCIÓN
router.get('/debug-users/:email', async (req, res) => {
    try {
        const email = req.params.email;
        console.log('🔍 DEBUG: Searching for email pattern:', email);
        
        // Buscar exacto en admin_users
        const adminExact = await db.query('SELECT id, email, activo FROM admin_users WHERE email = $1', [email]);
        
        // Buscar exacto en guardias  
        const guardiaExact = await db.query('SELECT id, email, activo FROM guardias WHERE email = $1', [email]);
        
        // Buscar similares en admin_users
        const adminSimilar = await db.query('SELECT id, email, activo FROM admin_users WHERE email ILIKE $1', [`%${email.split('@')[0]}%`]);
        
        // Buscar similares en guardias
        const guardiaSimilar = await db.query('SELECT id, email, activo FROM guardias WHERE email ILIKE $1', [`%${email.split('@')[0]}%`]);
        
        // Contar totales
        const adminTotal = await db.query('SELECT COUNT(*) as count FROM admin_users');
        const guardiaTotal = await db.query('SELECT COUNT(*) as count FROM guardias');
        
        res.json({
            searchEmail: email,
            exactMatches: {
                admin_users: adminExact || [],
                guardias: guardiaExact || []
            },
            similarMatches: {
                admin_users: adminSimilar || [],
                guardias: guardiaSimilar || []
            },
            totals: {
                admin_users: adminTotal?.[0]?.count || 0,
                guardias: guardiaTotal?.[0]?.count || 0
            }
        });
    } catch (error) {
        console.error('Debug error:', error);
        res.status(500).json({ error: error.message });
    }
});

// Ruta para probar login paso a paso
router.post('/test-login', async (req, res) => {
    try {
        const { email, password } = req.body;
        console.log('🧪 TEST LOGIN - Email:', email);
        
        if (!email || !password) {
            return res.status(400).json({ error: 'Email y contraseña requeridos' });
        }
        
        // Step 1: Buscar usuario
        const rows = await db.query('SELECT * FROM admin_users WHERE email = $1', [email]);
        console.log('🧪 Step 1 - Query result:', rows?.length || 0);
        
        if (!rows || rows.length === 0) {
            return res.json({
                step: 1,
                success: false,
                message: 'Usuario no encontrado',
                email: email
            });
        }
        
        const user = rows[0];
        console.log('🧪 Step 2 - User found:', { 
            id: user.id, 
            email: user.email, 
            activo: user.activo,
            activoType: typeof user.activo 
        });
        
        // Step 2: Verificar activo
        const isActive = user.activo === true || user.activo === 'true' || user.activo === 1;
        console.log('🧪 Step 3 - Active check:', isActive);
        
        if (!isActive) {
            return res.json({
                step: 2,
                success: false,
                message: 'Usuario inactivo',
                activo: user.activo,
                activoType: typeof user.activo
            });
        }
        
        // Step 3: Verificar password
        const storedHash = user.password_hash;
        console.log('🧪 Step 4 - Has password hash:', !!storedHash);
        
        if (!storedHash) {
            return res.json({
                step: 3,
                success: false,
                message: 'No hay hash de contraseña almacenado'
            });
        }
        
        const passwordMatch = await bcrypt.compare(password, storedHash);
        console.log('🧪 Step 5 - Password match:', passwordMatch);
        
        return res.json({
            step: 4,
            success: passwordMatch,
            message: passwordMatch ? 'Login exitoso' : 'Contraseña incorrecta',
            userDetails: {
                id: user.id,
                email: user.email,
                activo: user.activo,
                activoType: typeof user.activo,
                hasPassword: !!storedHash,
                passwordMatch: passwordMatch
            }
        });
        
    } catch (error) {
        console.error('🧪 Test login error:', error);
        return res.status(500).json({ error: error.message });
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
