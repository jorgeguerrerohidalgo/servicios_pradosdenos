const https = require('https');
const querystring = require('querystring');

async function diagnosisSession() {
    console.log('🔍 DIAGNÓSTICO DE PERSISTENCIA DE SESIÓN');
    console.log('='.repeat(50));
    
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
            req.setTimeout(10000, () => {
                req.abort();
                reject(new Error('Timeout'));
            });
            
            if (postData) {
                req.write(postData);
            }
            
            req.end();
        });
    }
    
    try {
        // 1. Login con admin
        console.log('1️⃣ Haciendo login con admin...');
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
        
        console.log(`Status: ${loginResponse.statusCode}`);
        console.log(`Response: ${loginResponse.data}`);
        
        if (loginResponse.statusCode !== 200) {
            console.log('❌ Login falló');
            return;
        }
        
        // Analizar cookies
        const cookies = loginResponse.headers['set-cookie'];
        console.log('\n2️⃣ Analizando cookies...');
        console.log('Set-Cookie headers:', cookies);
        
        if (!cookies) {
            console.log('❌ No se recibieron cookies');
            return;
        }
        
        let cookieHeader = '';
        let sessionCookie = null;
        
        cookies.forEach(cookie => {
            console.log(`Cookie: ${cookie}`);
            if (cookie.includes('checkin.sid')) {
                sessionCookie = cookie;
                cookieHeader += cookie.split(';')[0] + '; ';
            }
        });
        
        console.log(`Session Cookie: ${sessionCookie}`);
        console.log(`Cookie Header: ${cookieHeader}`);
        
        // 3. Verificar sesión inmediatamente
        console.log('\n3️⃣ Verificando sesión inmediatamente...');
        const checkResponse1 = await makeRequest({
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/api/auth/check',
            method: 'GET',
            headers: {
                'Cookie': cookieHeader,
                'Accept': 'application/json'
            }
        });
        
        console.log(`Status: ${checkResponse1.statusCode}`);
        console.log(`Response: ${checkResponse1.data}`);
        
        // 4. Esperar 3 segundos y verificar de nuevo
        console.log('\n4️⃣ Esperando 3 segundos...');
        await new Promise(resolve => setTimeout(resolve, 3000));
        
        const checkResponse2 = await makeRequest({
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/api/auth/check',
            method: 'GET',
            headers: {
                'Cookie': cookieHeader,
                'Accept': 'application/json'
            }
        });
        
        console.log(`Status después de 3s: ${checkResponse2.statusCode}`);
        console.log(`Response después de 3s: ${checkResponse2.data}`);
        
        // 5. Hacer un request a una página que requiere autenticación
        console.log('\n5️⃣ Probando acceso a checkin.html...');
        const checkinResponse = await makeRequest({
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/checkin.html',
            method: 'GET',
            headers: {
                'Cookie': cookieHeader,
                'Accept': 'text/html'
            }
        });
        
        console.log(`Status checkin.html: ${checkinResponse.statusCode}`);
        console.log(`Response length: ${checkinResponse.data.length}`);
        
        // 6. Verificar headers de seguridad
        console.log('\n6️⃣ Headers de seguridad...');
        console.log('Headers del login:', Object.keys(loginResponse.headers));
        console.log('Headers del check:', Object.keys(checkResponse1.headers));
        
        // 7. Probar con username en lugar de email
        console.log('\n7️⃣ Probando login con username...');
        const loginData2 = querystring.stringify({
            username: 'admin',
            password: 'admin123'
        });
        
        const loginResponse2 = await makeRequest({
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/api/auth/login',
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Content-Length': Buffer.byteLength(loginData2),
                'Accept': 'application/json'
            }
        }, loginData2);
        
        console.log(`Status con username: ${loginResponse2.statusCode}`);
        console.log(`Response con username: ${loginResponse2.data}`);
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

diagnosisSession();
