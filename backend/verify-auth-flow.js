const https = require('https');
const querystring = require('querystring');

async function verifyAuthFlow() {
    console.log('🔍 VERIFICANDO FLUJO DE AUTENTICACIÓN');
    console.log('='.repeat(50));
    
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
        console.log('1️⃣ Probando login de ADMIN...');
        const adminLoginData = querystring.stringify({
            username: 'admin',
            password: 'admin123'
        });
        
        const adminLoginResponse = await makeRequest({
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/api/auth/login',
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Content-Length': Buffer.byteLength(adminLoginData)
            }
        }, adminLoginData);
        
        console.log(`Admin Login Status: ${adminLoginResponse.statusCode}`);
        
        if (adminLoginResponse.statusCode === 200) {
            const adminData = JSON.parse(adminLoginResponse.data);
            console.log('✅ Admin login exitoso');
            console.log(`👤 Nombre: ${adminData.guardia.nombre}`);
            console.log(`🔐 Tipo: ${adminData.guardia.tipo}`);
            console.log(`📧 Email: ${adminData.guardia.email}`);
            
            // Obtener cookies de admin
            const adminCookies = adminLoginResponse.headers['set-cookie'];
            let adminCookieHeader = '';
            if (adminCookies) {
                adminCookieHeader = adminCookies.map(c => c.split(';')[0]).join('; ');
            }
            
            // Verificar sesión de admin
            const adminCheckResponse = await makeRequest({
                hostname: 'servicios-prados-de-nos.onrender.com',
                port: 443,
                path: '/api/auth/check',
                method: 'GET',
                headers: { 'Cookie': adminCookieHeader }
            });
            
            console.log(`Admin Check Status: ${adminCheckResponse.statusCode}`);
            if (adminCheckResponse.statusCode === 200) {
                const adminCheckData = JSON.parse(adminCheckResponse.data);
                console.log(`✅ Admin sesión: ${adminCheckData.isAuthenticated}`);
                console.log(`🔐 Admin tipo: ${adminCheckData.guardia.tipo}`);
            }
        } else {
            console.log('❌ Admin login falló');
            console.log(`Response: ${adminLoginResponse.data}`);
        }
        
        console.log('\n2️⃣ Probando login de GUARDIA...');
        const guardiaLoginData = querystring.stringify({
            username: 'juan.perez@pradosdenos.com',
            password: 'password123'
        });
        
        const guardiaLoginResponse = await makeRequest({
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/api/auth/login',
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Content-Length': Buffer.byteLength(guardiaLoginData)
            }
        }, guardiaLoginData);
        
        console.log(`Guardia Login Status: ${guardiaLoginResponse.statusCode}`);
        
        if (guardiaLoginResponse.statusCode === 200) {
            const guardiaData = JSON.parse(guardiaLoginResponse.data);
            console.log('✅ Guardia login exitoso');
            console.log(`👤 Nombre: ${guardiaData.guardia.nombre}`);
            console.log(`🔐 Tipo: ${guardiaData.guardia.tipo}`);
            console.log(`📧 Email: ${guardiaData.guardia.email}`);
            
            // Obtener cookies de guardia
            const guardiaCookies = guardiaLoginResponse.headers['set-cookie'];
            let guardiaCookieHeader = '';
            if (guardiaCookies) {
                guardiaCookieHeader = guardiaCookies.map(c => c.split(';')[0]).join('; ');
            }
            
            // Verificar sesión de guardia
            const guardiaCheckResponse = await makeRequest({
                hostname: 'servicios-prados-de-nos.onrender.com',
                port: 443,
                path: '/api/auth/check',
                method: 'GET',
                headers: { 'Cookie': guardiaCookieHeader }
            });
            
            console.log(`Guardia Check Status: ${guardiaCheckResponse.statusCode}`);
            if (guardiaCheckResponse.statusCode === 200) {
                const guardiaCheckData = JSON.parse(guardiaCheckResponse.data);
                console.log(`✅ Guardia sesión: ${guardiaCheckData.isAuthenticated}`);
                console.log(`🔐 Guardia tipo: ${guardiaCheckData.guardia.tipo}`);
            }
        } else {
            console.log('❌ Guardia login falló');
            console.log(`Response: ${guardiaLoginResponse.data}`);
        }
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

verifyAuthFlow();
