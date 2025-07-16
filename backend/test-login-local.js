// Script para testear el login localmente
const http = require('http');

const testData = {
  email: 'juan.perez@pradosdenos.com',
  password: 'password123'
};

const postData = JSON.stringify(testData);

const options = {
  hostname: 'localhost',
  port: 3000,
  path: '/api/auth/login',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(postData)
  }
};

console.log('🔍 Testeando login con:', testData);
console.log('📡 Enviando request a:', `http://${options.hostname}:${options.port}${options.path}`);

const req = http.request(options, (res) => {
  console.log('🌐 Status:', res.statusCode);
  console.log('📋 Headers:', res.headers);
  
  let data = '';
  res.on('data', (chunk) => {
    data += chunk;
  });
  
  res.on('end', () => {
    console.log('📦 Response:', data);
    try {
      const parsed = JSON.parse(data);
      console.log('✅ Parsed response:', parsed);
    } catch (error) {
      console.log('❌ Error parsing JSON:', error.message);
    }
  });
});

req.on('error', (error) => {
  console.error('❌ Request error:', error.message);
});

req.write(postData);
req.end();
