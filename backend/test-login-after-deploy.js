const https = require('https');

function testLogin(email, password, userType) {
    return new Promise((resolve, reject) => {
        const data = JSON.stringify({ email, password });
        
        const options = {
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: '/api/auth/login',
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': Buffer.byteLength(data),
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                'Accept': 'application/json'
            }
        };
        
        const req = https.request(options, (res) => {
            let responseData = '';
            
            res.on('data', (chunk) => {
                responseData += chunk;
            });
            
            res.on('end', () => {
                console.log(`\n=== ${userType.toUpperCase()} LOGIN TEST ===`);
                console.log(`📧 Email: ${email}`);
                console.log(`🔐 Password: ${password}`);
                console.log(`📊 Status: ${res.statusCode}`);
                console.log(`📦 Response: ${responseData}`);
                
                if (res.statusCode === 200) {
                    console.log('✅ LOGIN EXITOSO!');
                    try {
                        const parsed = JSON.parse(responseData);
                        console.log('👤 Usuario logueado:', parsed.guardia);
                    } catch (e) {
                        console.log('❌ Error parseando respuesta exitosa');
                    }
                } else {
                    console.log('❌ LOGIN FALLIDO');
                    if (res.statusCode === 500) {
                        console.log('🔍 Error 500 - Revisar logs del servidor');
                    }
                }
                
                resolve(res.statusCode);
            });
        });
        
        req.on('error', (error) => {
            console.error(`❌ Error en petición ${userType}:`, error.message);
            reject(error);
        });
        
        // Timeout de 10 segundos
        req.setTimeout(10000, () => {
            req.abort();
            reject(new Error('Timeout'));
        });
        
        req.write(data);
        req.end();
    });
}

async function testBothLogins() {
    console.log('🚀 Testeando login después del deploy...');
    console.log('⏰ Timestamp:', new Date().toISOString());
    
    try {
        // Test Admin
        await testLogin('jorgeguerrerohidalgo@gmail.com', 'madneo710', 'admin');
        
        // Esperar un poco entre requests
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // Test Guardia
        await testLogin('juan.perez@pradosdenos.com', 'prueba123', 'guardia');
        
    } catch (error) {
        console.error('❌ Error general:', error.message);
    }
    
    console.log('\n🏁 Test completado');
}

testBothLogins();
