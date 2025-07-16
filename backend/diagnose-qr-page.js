const https = require('https');

async function testQRPage() {
    console.log('🔍 DIAGNÓSTICO DE PÁGINA QR');
    console.log('='.repeat(40));
    
    try {
        // 1. Verificar si la API de plazas funciona
        console.log('1️⃣ Verificando API de plazas...');
        const plazasResponse = await fetch('https://servicios-prados-de-nos.onrender.com/api/plazas');
        console.log(`Status: ${plazasResponse.status}`);
        
        if (plazasResponse.ok) {
            const plazasData = await plazasResponse.json();
            console.log(`✅ API funciona - ${plazasData.plazas ? plazasData.plazas.length : 0} plazas encontradas`);
            
            if (plazasData.plazas && plazasData.plazas.length > 0) {
                console.log('📋 Primeras 3 plazas:');
                plazasData.plazas.slice(0, 3).forEach((plaza, i) => {
                    console.log(`  ${i+1}. ${plaza.nombre} - ${plaza.direccion} - Token: ${plaza.token || plaza.id}`);
                });
            }
        } else {
            console.log('❌ Error en API de plazas');
        }
        
        // 2. Verificar si la página QR está accesible
        console.log('\n2️⃣ Verificando acceso a página QR...');
        const qrPageResponse = await fetch('https://servicios-prados-de-nos.onrender.com/qr-plazas.html');
        console.log(`Status: ${qrPageResponse.status}`);
        
        if (qrPageResponse.ok) {
            const pageContent = await qrPageResponse.text();
            console.log(`✅ Página accesible - ${pageContent.length} caracteres`);
            
            // Verificar si contiene las librerías necesarias
            if (pageContent.includes('qrcode.min.js')) {
                console.log('✅ Librería QRCode incluida');
            } else {
                console.log('❌ Librería QRCode NO encontrada');
            }
            
            if (pageContent.includes('bootstrap')) {
                console.log('✅ Bootstrap incluido');
            } else {
                console.log('❌ Bootstrap NO encontrado');
            }
        } else {
            console.log('❌ Error accediendo a página QR');
        }
        
        // 3. Verificar librerías externas
        console.log('\n3️⃣ Verificando librerías externas...');
        
        try {
            const qrLibResponse = await fetch('https://cdnjs.cloudflare.com/ajax/libs/qrcode/1.5.3/qrcode.min.js');
            console.log(`QRCode.js: ${qrLibResponse.status === 200 ? '✅ Disponible' : '❌ No disponible'}`);
        } catch (e) {
            console.log('❌ Error accediendo a QRCode.js');
        }
        
        try {
            const bootstrapResponse = await fetch('https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css');
            console.log(`Bootstrap CSS: ${bootstrapResponse.status === 200 ? '✅ Disponible' : '❌ No disponible'}`);
        } catch (e) {
            console.log('❌ Error accediendo a Bootstrap CSS');
        }
        
    } catch (error) {
        console.error('❌ Error en diagnóstico:', error.message);
    }
}

// Función fetch para Node.js
async function fetch(url) {
    return new Promise((resolve, reject) => {
        const https = require('https');
        const urlObj = new URL(url);
        
        const options = {
            hostname: urlObj.hostname,
            port: urlObj.port || 443,
            path: urlObj.pathname + urlObj.search,
            method: 'GET',
            headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
            }
        };
        
        const req = https.request(options, (res) => {
            let data = '';
            res.on('data', chunk => data += chunk);
            res.on('end', () => {
                resolve({
                    ok: res.statusCode >= 200 && res.statusCode < 300,
                    status: res.statusCode,
                    text: () => Promise.resolve(data),
                    json: () => Promise.resolve(JSON.parse(data))
                });
            });
        });
        
        req.on('error', reject);
        req.setTimeout(10000, () => {
            req.abort();
            reject(new Error('Timeout'));
        });
        req.end();
    });
}

testQRPage();
