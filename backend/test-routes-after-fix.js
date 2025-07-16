const https = require('https');

function testRoute(path, name) {
    return new Promise((resolve, reject) => {
        const options = {
            hostname: 'servicios-prados-de-nos.onrender.com',
            port: 443,
            path: path,
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
            }
        };
        
        const req = https.request(options, (res) => {
            let responseData = '';
            
            res.on('data', (chunk) => {
                responseData += chunk;
            });
            
            res.on('end', () => {
                console.log(`\n=== ${name} ===`);
                console.log(`🌐 URL: https://servicios-prados-de-nos.onrender.com${path}`);
                console.log(`📊 Status: ${res.statusCode}`);
                
                if (res.statusCode === 200) {
                    console.log('✅ RUTA FUNCIONA');
                    try {
                        const parsed = JSON.parse(responseData);
                        console.log('📦 Respuesta:', typeof parsed === 'object' ? `${Object.keys(parsed).length} propiedades` : 'Datos válidos');
                    } catch (e) {
                        console.log('📦 Respuesta: Texto válido');
                    }
                } else if (res.statusCode === 404) {
                    console.log('❌ RUTA NO ENCONTRADA (404)');
                } else {
                    console.log(`❌ ERROR (${res.statusCode})`);
                }
                
                console.log(`📄 Respuesta (primeros 200 chars): ${responseData.substring(0, 200)}...`);
                resolve(res.statusCode);
            });
        });
        
        req.on('error', (error) => {
            console.error(`❌ Error en ${name}:`, error.message);
            reject(error);
        });
        
        req.setTimeout(10000, () => {
            req.abort();
            reject(new Error('Timeout'));
        });
        
        req.end();
    });
}

async function testAllRoutes() {
    console.log('🚀 Testeando rutas después de las correcciones...');
    console.log('⏰ Timestamp:', new Date().toISOString());
    
    const routes = [
        { path: '/api/plazas', name: 'PLAZAS' },
        { path: '/api/checkins/public?periodo=hoy', name: 'CHECKINS PUBLIC HOY' },
        { path: '/api/checkins/public?periodo=mes', name: 'CHECKINS PUBLIC MES' },
        { path: '/health', name: 'HEALTH CHECK' }
    ];
    
    for (const route of routes) {
        try {
            await testRoute(route.path, route.name);
            await new Promise(resolve => setTimeout(resolve, 500)); // Esperar entre requests
        } catch (error) {
            console.error(`❌ Error en ${route.name}:`, error.message);
        }
    }
    
    console.log('\n🏁 Test de rutas completado');
}

testAllRoutes();
