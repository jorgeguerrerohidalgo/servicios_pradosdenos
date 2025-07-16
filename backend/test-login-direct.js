const https = require('https');

const testLogin = (email, password) => {
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
};

async function runLoginTest() {
  console.log('🔍 Testeando login en producción...');
  
  try {
    const result = await testLogin('juan.perez@pradosdenos.com', 'password123');
    
    console.log('📊 Resultado del login:');
    console.log('  Status:', result.statusCode);
    console.log('  Headers:', JSON.stringify(result.headers, null, 2));
    console.log('  Body:', result.body);
    
    if (result.statusCode === 200) {
      console.log('✅ Login exitoso!');
    } else {
      console.log('❌ Login falló');
      
      // Intentar parsear el error
      try {
        const errorData = JSON.parse(result.body);
        console.log('📋 Error parseado:', errorData);
      } catch (e) {
        console.log('❌ No se pudo parsear el error');
      }
    }
    
  } catch (error) {
    console.error('❌ Error en la prueba:', error.message);
  }
}

runLoginTest();
