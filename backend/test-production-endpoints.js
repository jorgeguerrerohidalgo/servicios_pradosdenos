#!/usr/bin/env node

// Script para probar los endpoints después de la corrección
const https = require('https');
const http = require('http');

const BASE_URL = 'https://servicios-prados-de-nos.onrender.com';

// Lista de endpoints a probar
const endpoints = [
    { path: '/api/eventos/tipos/all', method: 'GET' },
    { path: '/api/eventos', method: 'GET' },
    { path: '/api/documentos_comunitarios/tipos', method: 'GET' },
    { path: '/api/documentos_comunitarios', method: 'GET' },
    { path: '/api/auth/check', method: 'GET' },
    { path: '/api/admin/stats', method: 'GET' },
    { path: '/api/plazas', method: 'GET' }
];

console.log('🔍 Probando endpoints en producción...');
console.log('🌐 Base URL:', BASE_URL);
console.log('📝 Endpoints a probar:', endpoints.length);

async function testEndpoint(endpoint) {
    return new Promise((resolve) => {
        const url = `${BASE_URL}${endpoint.path}`;
        const options = {
            method: endpoint.method,
            headers: {
                'User-Agent': 'Node.js Test Script',
                'Accept': 'application/json'
            }
        };
        
        console.log(`\n🔄 Probando: ${endpoint.method} ${endpoint.path}`);
        
        const req = https.request(url, options, (res) => {
            let data = '';
            
            res.on('data', (chunk) => {
                data += chunk;
            });
            
            res.on('end', () => {
                const status = res.statusCode;
                const isSuccess = status >= 200 && status < 300;
                const icon = isSuccess ? '✅' : '❌';
                
                console.log(`${icon} Status: ${status}`);
                
                if (data) {
                    try {
                        const jsonData = JSON.parse(data);
                        console.log(`📄 Response: ${JSON.stringify(jsonData, null, 2).substring(0, 200)}${data.length > 200 ? '...' : ''}`);
                    } catch (e) {
                        console.log(`📄 Response (text): ${data.substring(0, 200)}${data.length > 200 ? '...' : ''}`);
                    }
                }
                
                resolve({ endpoint, status, data, isSuccess });
            });
        });
        
        req.on('error', (error) => {
            console.log(`❌ Error: ${error.message}`);
            resolve({ endpoint, status: 'ERROR', error: error.message, isSuccess: false });
        });
        
        req.setTimeout(10000, () => {
            console.log(`⏱️ Timeout: ${endpoint.path}`);
            req.destroy();
            resolve({ endpoint, status: 'TIMEOUT', isSuccess: false });
        });
        
        req.end();
    });
}

async function runTests() {
    console.log('\n🚀 Iniciando pruebas...\n');
    
    const results = [];
    
    for (const endpoint of endpoints) {
        const result = await testEndpoint(endpoint);
        results.push(result);
        
        // Pausa entre requests
        await new Promise(resolve => setTimeout(resolve, 1000));
    }
    
    console.log('\n📊 RESUMEN DE RESULTADOS:');
    console.log('==========================');
    
    const successful = results.filter(r => r.isSuccess).length;
    const failed = results.filter(r => !r.isSuccess).length;
    
    console.log(`✅ Exitosos: ${successful}`);
    console.log(`❌ Fallidos: ${failed}`);
    console.log(`📈 Tasa de éxito: ${Math.round(successful / results.length * 100)}%`);
    
    console.log('\n📋 DETALLE:');
    results.forEach(result => {
        const icon = result.isSuccess ? '✅' : '❌';
        console.log(`${icon} ${result.endpoint.method} ${result.endpoint.path} - ${result.status}`);
    });
    
    if (failed > 0) {
        console.log('\n🔧 RECOMENDACIONES:');
        console.log('1. Verificar que el servidor se haya reiniciado después de los cambios');
        console.log('2. Revisar los logs del servidor para errores específicos');
        console.log('3. Verificar que las rutas estén configuradas en el orden correcto');
    }
}

runTests().catch(console.error);
