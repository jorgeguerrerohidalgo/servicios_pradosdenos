const https = require('https');
const querystring = require('querystring');

async function testCompleteFlow() {
    console.log('🔍 PRUEBA COMPLETA DEL SISTEMA');
    console.log('='.repeat(50));
    
    // Función helper para requests
    function makeRequest(options, postData = null) {
        return new Promise((resolve, reject) => {
            const req = https.request(options, (res) => {
                let data = '';
                res.on('data', chunk => data += chunk);
                res.on('end', () => {
                    resolve({
                        statusCode: res.statusCode,
                        headers: res.headers,
                        data: data
                    });
                });
            });
            
            req.on('error', reject);
            req.setTimeout(15000, () => {
                req.abort();
                reject(new Error('Request timeout'));
            });
            
            if (postData) {
                req.write(postData);
            }
            
            req.end();
        });
    }
    
    try {
        // 1. Verificar health check
        console.log('1️⃣ Verificando health check...');
        const healthResponse = await makeRequest({
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/health',
            method: 'GET'
        });
        
        console.log(`Health: ${healthResponse.statusCode}`);
        if (healthResponse.statusCode === 200) {
            console.log('✅ Servidor funcionando');
        } else {
            console.log('❌ Servidor con problemas');
        }
        
        // 2. Probar rutas públicas
        console.log('\n2️⃣ Probando rutas públicas...');
        
        // Probar /api/plazas
        const plazasResponse = await makeRequest({
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/api/plazas',
            method: 'GET',
            headers: {
                'Accept': 'application/json'
            }
        });
        
        console.log(`/api/plazas: ${plazasResponse.statusCode}`);
        if (plazasResponse.statusCode === 200) {
            console.log('✅ Plazas disponibles');
            try {
                const plazasData = JSON.parse(plazasResponse.data);
                console.log(`📊 ${plazasData.plazas ? plazasData.plazas.length : 0} plazas encontradas`);
            } catch (e) {
                console.log('⚠️  Respuesta no es JSON válido');
            }
        } else {
            console.log('❌ Error en plazas');
            console.log(`Respuesta: ${plazasResponse.data.substring(0, 100)}...`);
        }
        
        // Probar /api/checkins/public
        const checkinsResponse = await makeRequest({
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/api/checkins/public?periodo=hoy',
            method: 'GET',
            headers: {
                'Accept': 'application/json'
            }
        });
        
        console.log(`/api/checkins/public: ${checkinsResponse.statusCode}`);
        if (checkinsResponse.statusCode === 200) {
            console.log('✅ Checkins públicos disponibles');
            try {
                const checkinsData = JSON.parse(checkinsResponse.data);
                console.log(`📊 ${checkinsData.checkins ? checkinsData.checkins.length : 0} checkins encontrados`);
            } catch (e) {
                console.log('⚠️  Respuesta no es JSON válido');
            }
        } else {
            console.log('❌ Error en checkins públicos');
            console.log(`Respuesta: ${checkinsResponse.data.substring(0, 100)}...`);
        }
        
        // 3. Probar login y verificar sesión
        console.log('\n3️⃣ Probando login con admin...');
        
        const loginData = querystring.stringify({
            email: 'admin@admin.com',
            password: 'admin123'
        });
        
        const loginResponse = await makeRequest({
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/api/auth/login',
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Content-Length': Buffer.byteLength(loginData),
                'Accept': 'application/json'
            }
        }, loginData);
        
        console.log(`Login: ${loginResponse.statusCode}`);
        if (loginResponse.statusCode === 200) {
            console.log('✅ Login exitoso');
            
            // Obtener cookies
            const cookies = loginResponse.headers['set-cookie'];
            let cookieHeader = '';
            if (cookies) {
                cookieHeader = cookies.map(cookie => cookie.split(';')[0]).join('; ');
                console.log(`🍪 Cookies: ${cookieHeader}`);
            }
            
            // Verificar sesión
            console.log('\n4️⃣ Verificando persistencia de sesión...');
            const checkResponse = await makeRequest({
                hostname: 'servicios-prados-de-nos.onrender.com',
                port: 443,
                path: '/api/auth/check',
                method: 'GET',
                headers: {
                    'Cookie': cookieHeader,
                    'Accept': 'application/json'
                }
            });
            
            console.log(`Session Check: ${checkResponse.statusCode}`);
            if (checkResponse.statusCode === 200) {
                try {
                    const sessionData = JSON.parse(checkResponse.data);
                    if (sessionData.isAuthenticated) {
                        console.log('✅ Sesión persistente');
                        console.log(`👤 Usuario: ${sessionData.guardia.nombre}`);
                    } else {
                        console.log('❌ Sesión no persistente');
                    }
                } catch (e) {
                    console.log('⚠️  Error parseando respuesta de sesión');
                }
            } else {
                console.log('❌ Error verificando sesión');
            }
            
        } else {
            console.log('❌ Error en login');
            console.log(`Respuesta: ${loginResponse.data.substring(0, 100)}...`);
        }
        
        console.log('\n🏁 PRUEBA COMPLETADA');
        console.log('='.repeat(50));
        
    } catch (error) {
        console.error('❌ Error en prueba:', error.message);
    }
}

// Ejecutar prueba
testCompleteFlow();
