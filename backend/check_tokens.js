require('dotenv').config();
const { query } = require('./utils/db');

async function checkPlazasTokens() {
  try {
    console.log('=== VERIFICANDO PLAZAS Y TOKENS ===');
    
    // Verificar plazas
    const plazas = await query('SELECT COUNT(*) as total FROM plazas WHERE activo = TRUE');
    console.log('Plazas activas:', plazas[0].total);
    
    // Verificar tokens
    const tokens = await query('SELECT COUNT(*) as total FROM plaza_tokens');
    console.log('Tokens en plaza_tokens:', tokens[0].total);
    
    // Verificar plazas sin token
    const plazasSinToken = await query(`
      SELECT p.id, p.nombre
      FROM plazas p
      LEFT JOIN plaza_tokens pt ON p.id = pt.plaza_id
      WHERE p.activo = TRUE AND pt.token IS NULL
    `);
    console.log('Plazas sin token:', plazasSinToken.length);
    
    if (plazasSinToken.length > 0) {
      console.log('Plazas que necesitan token:');
      plazasSinToken.forEach(plaza => {
        console.log(`- ID: ${plaza.id}, Nombre: ${plaza.nombre}`);
      });
    }
    
    // Verificar query que usa la API
    const apiResult = await query(`
      SELECT p.id, p.nombre, p.direccion, p.descripcion, p.activo,
             pt.token
      FROM plazas p
      LEFT JOIN plaza_tokens pt ON p.id = pt.plaza_id
      WHERE p.activo = TRUE
      ORDER BY p.nombre ASC
    `);
    
    console.log('\n=== RESULTADO DE LA API ===');
    console.log('Total plazas devueltas:', apiResult.length);
    
    const conToken = apiResult.filter(p => p.token);
    const sinToken = apiResult.filter(p => !p.token);
    
    console.log('Plazas con token:', conToken.length);
    console.log('Plazas sin token:', sinToken.length);
    
    if (sinToken.length > 0) {
      console.log('\nPlazas sin token:');
      sinToken.forEach(plaza => {
        console.log(`- ID: ${plaza.id}, Nombre: ${plaza.nombre}`);
      });
    }
    
    process.exit(0);
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
}

checkPlazasTokens();
