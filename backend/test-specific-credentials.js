const https = require('https');

const testCredentials = [
    {
        name: 'Admin',
        email: 'jorgeguerrerohidalgo@gmail.com',
        password: 'madneo710'
    },
    {
        name: 'Guardia',
        email: 'juan.perez@pradosdenos.com',
        password: 'prueba123'
    }
];

function testLogin(email, password) {
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
                'X-Requested-With': 'XMLHttpRequest',
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
            }
        };
        
        const req = https.request(options, (res) => {
            let responseData = '';
            
            res.on('data', (chunk) => {
                responseData += chunk;
            });
            
            res.on('end', () => {
                resolve({
                    statusCode: res.statusCode,
                    headers: res.headers,
                    body: responseData
                });
            });
        });
        
        req.on('error', (error) => {
            reject(error);
        });
        
        req.write(data);
        req.end();
    });
}

async function testAllCredentials() {
    console.log('🔍 Testeando credenciales específicas en producción...\n');
    
    for (const cred of testCredentials) {
        console.log(`🔐 Probando ${cred.name}: ${cred.email}`);
        
        try {
            const result = await testLogin(cred.email, cred.password);
            
            console.log(`📊 Status: ${result.statusCode}`);
            console.log(`📦 Body: ${result.body}`);
            
            if (result.statusCode === 200) {
                console.log('✅ Login exitoso!');
                try {
                    const parsed = JSON.parse(result.body);
                    console.log('👤 Usuario:', parsed.guardia);
                } catch (e) {
                    console.log('❌ Error parseando respuesta exitosa');
                }
            } else if (result.statusCode === 401) {
                console.log('❌ Credenciales inválidas');
            } else if (result.statusCode === 500) {
                console.log('❌ Error interno del servidor');
                try {
                    const parsed = JSON.parse(result.body);
                    console.log('🔍 Detalles del error:', parsed);
                } catch (e) {
                    console.log('❌ Error parseando respuesta de error');
                }
            } else {
                console.log(`❌ Status inesperado: ${result.statusCode}`);
            }
            
        } catch (error) {
            console.error(`❌ Error en petición: ${error.message}`);
        }
        
        console.log('\n' + '='.repeat(50) + '\n');
    }
}

testAllCredentials();
