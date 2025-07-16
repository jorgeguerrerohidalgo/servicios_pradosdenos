const https = require('https');
const querystring = require('querystring');

async function testLoginSession() {
    console.log('🔐 Testeando persistencia de sesión...');
    
    // Función para hacer request con cookies
    function makeRequest(options, postData) {
        return new Promise((resolve, reject) => {
            const req = https.request(options, (res) => {
                let responseData = '';
                
                res.on('data', (chunk) => {
                    responseData += chunk;
                });
                
                res.on('end', () => {
                    resolve({
                        statusCode: res.statusCode,
                        headers: res.headers,
                        data: responseData
                    });
                });
            });
            
            req.on('error', reject);
            
            if (postData) {
                req.write(postData);
            }
            
            req.end();
        });
    }
    
    try {
        // 1. Hacer login
        console.log('1️⃣ Haciendo login...');
        const loginData = querystring.stringify({
            username: 'admin',
            password: 'admin123'
        });
        
        const loginOptions = {
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/api/auth/login',
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Content-Length': Buffer.byteLength(loginData),
                'Accept': 'application/json'
            }
        };
        
        const loginResponse = await makeRequest(loginOptions, loginData);
        console.log('Login Status:', loginResponse.statusCode);
        console.log('Login Response:', loginResponse.data);
        
        // Extraer cookies
        const cookies = loginResponse.headers['set-cookie'];
        let cookieHeader = '';
        if (cookies) {
            cookieHeader = cookies.map(cookie => cookie.split(';')[0]).join('; ');
            console.log('Cookies recibidas:', cookieHeader);
        }
        
        // 2. Verificar sesión inmediatamente después del login
        console.log('\n2️⃣ Verificando sesión inmediatamente...');
        const checkOptions = {
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/api/auth/check',
            method: 'GET',
            headers: {
                'Cookie': cookieHeader,
                'Accept': 'application/json'
            }
        };
        
        const checkResponse = await makeRequest(checkOptions);
        console.log('Check Status:', checkResponse.statusCode);
        console.log('Check Response:', checkResponse.data);
        
        // 3. Esperar 2 segundos y verificar de nuevo
        console.log('\n3️⃣ Esperando 2 segundos...');
        await new Promise(resolve => setTimeout(resolve, 2000));
        
        const checkResponse2 = await makeRequest(checkOptions);
        console.log('Check Status (después de 2s):', checkResponse2.statusCode);
        console.log('Check Response (después de 2s):', checkResponse2.data);
        
        // 4. Hacer una consulta que requiere autenticación
        console.log('\n4️⃣ Probando ruta protegida...');
        const protectedOptions = {
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/api/plazas',
            method: 'GET',
            headers: {
                'Cookie': cookieHeader,
                'Accept': 'application/json'
            }
        };
        
        const protectedResponse = await makeRequest(protectedOptions);
        console.log('Protected Route Status:', protectedResponse.statusCode);
        console.log('Protected Route Response:', protectedResponse.data.substring(0, 200) + '...');
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

testLoginSession();
