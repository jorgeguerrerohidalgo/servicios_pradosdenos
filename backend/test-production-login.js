const axios = require('axios');

// Configuración
const BASE_URL = 'https://servicios-prados-de-nos.onrender.com';
const LOGIN_DATA = {
  email: 'juan.perez@pradosdenos.com',
  password: 'password123'
};

async function testLogin() {
  try {
    console.log('🔍 Testeando login en producción...');
    console.log('🌐 URL:', `${BASE_URL}/api/auth/login`);
    console.log('📝 Data:', LOGIN_DATA);
    
    const response = await axios.post(`${BASE_URL}/api/auth/login`, LOGIN_DATA, {
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      },
      timeout: 10000
    });
    
    console.log('✅ Status:', response.status);
    console.log('📦 Response:', response.data);
    
  } catch (error) {
    console.error('❌ Error:', error.message);
    if (error.response) {
      console.error('❌ Status:', error.response.status);
      console.error('❌ Data:', error.response.data);
      console.error('❌ Headers:', error.response.headers);
    }
  }
}

async function testHealth() {
  try {
    console.log('🔍 Testeando health check...');
    const response = await axios.get(`${BASE_URL}/health`);
    console.log('✅ Health Status:', response.status);
    console.log('📦 Health Data:', response.data);
  } catch (error) {
    console.error('❌ Health Error:', error.message);
  }
}

async function runTests() {
  await testHealth();
  console.log('\n' + '='.repeat(50) + '\n');
  await testLogin();
}

runTests();
