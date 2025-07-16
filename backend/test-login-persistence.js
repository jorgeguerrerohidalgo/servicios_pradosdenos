const https = require('https');
const querystring = require('querystring');

async function testLoginPersistence() {
    console.log('🔐 TEST DE PERSISTENCIA DE LOGIN');
    console.log('='.repeat(40));
    
    function makeRequest(options, postData = null) {
        return new Promise((resolve, reject) => {
            const req = https.request(options, (res) => {
                let data = '';
                res.on('data', chunk => data += chunk);
                res.on('end', () => resolve({
                    statusCode: res.statusCode,
                    headers: res.headers,
                    data: data
                }));
            });
            
            req.on('error', reject);
            req.setTimeout(8000, () => {
                req.abort();
                reject(new Error('Timeout'));
            });
            
            if (postData) req.write(postData);
            req.end();
        });
    }
    
    try {
        console.log('1️⃣ Login con username...');
        const loginData = querystring.stringify({
            username: 'admin',
            password: 'admin123'
        });
        
        const loginResponse = await makeRequest({
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/api/auth/login',
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Content-Length': Buffer.byteLength(loginData)
            }
        }, loginData);
        
        console.log(`Login Status: ${loginResponse.statusCode}`);
        
        if (loginResponse.statusCode === 200) {
            console.log('✅ Login exitoso');
            
            // Extraer cookies
            const cookies = loginResponse.headers['set-cookie'];
            let cookieHeader = '';
            if (cookies) {
                cookieHeader = cookies.map(c => c.split(';')[0]).join('; ');
                console.log('🍪 Cookie obtenida');
            }
            
            console.log('\n2️⃣ Verificando sesión...');
            const checkResponse = await makeRequest({
                hostname: 'servicios-prados-de-nos.onrender.com',
                port: 443,
                path: '/api/auth/check',
                method: 'GET',
                headers: { 'Cookie': cookieHeader }
            });
            
            console.log(`Check Status: ${checkResponse.statusCode}`);
            
            if (checkResponse.statusCode === 200) {
                const checkData = JSON.parse(checkResponse.data);
                if (checkData.isAuthenticated) {
                    console.log('✅ Sesión válida');
                    console.log(`👤 Usuario: ${checkData.guardia.nombre}`);
                    
                    console.log('\n3️⃣ Esperando 5 segundos...');
                    await new Promise(resolve => setTimeout(resolve, 5000));
                    
                    console.log('\n4️⃣ Verificando persistencia...');
                    const checkResponse2 = await makeRequest({
                        hostname: 'servicios-prados-de-nos.onrender.com',
                        port: 443,
                        path: '/api/auth/check',
                        method: 'GET',
                        headers: { 'Cookie': cookieHeader }
                    });
                    
                    console.log(`Check Status (después de 5s): ${checkResponse2.statusCode}`);
                    
                    if (checkResponse2.statusCode === 200) {
                        const checkData2 = JSON.parse(checkResponse2.data);
                        if (checkData2.isAuthenticated) {
                            console.log('✅ Sesión persistente - PROBLEMA RESUELTO');
                        } else {
                            console.log('❌ Sesión perdida - PROBLEMA PERSISTE');
                        }
                    } else {
                        console.log('❌ Error en verificación de persistencia');
                    }
                } else {
                    console.log('❌ Sesión no autenticada');
                }
            } else {
                console.log('❌ Error en check de sesión');
            }
        } else {
            console.log('❌ Login falló');
            console.log(`Response: ${loginResponse.data}`);
        }
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

testLoginPersistence();
