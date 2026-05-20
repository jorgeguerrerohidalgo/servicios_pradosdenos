require('dotenv').config();
const { query } = require('./utils/db');

async function generateMissingTokens() {
  try {
    console.log('=== GENERANDO TOKENS FALTANTES ===');
    
    // Obtener plazas sin token
    const plazasSinToken = await query(`
      SELECT p.id, p.nombre
      FROM plazas p
      LEFT JOIN plaza_tokens pt ON p.id = pt.plaza_id
      WHERE p.activo = TRUE AND pt.token IS NULL
    `);
    
    console.log(`Plazas sin token encontradas: ${plazasSinToken.length}`);
    
    if (plazasSinToken.length === 0) {
      console.log('Todas las plazas ya tienen tokens asignados.');
      process.exit(0);
    }
    
    // Generar tokens para cada plaza
    for (const plaza of plazasSinToken) {
      const token = `qr-plaza-${plaza.id}-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
      
      try {
        await query(`
          INSERT INTO plaza_tokens (plaza_id, token, creado_en)
          VALUES ($1, $2, NOW())
        `, [plaza.id, token]);
        
        console.log(`✓ Token generado para ${plaza.nombre}: ${token}`);
      } catch (error) {
        console.error(`✗ Error generando token para ${plaza.nombre}:`, error.message);
      }
    }
    
    console.log('\n=== VERIFICACIÓN FINAL ===');
    
    // Verificar que todas las plazas tengan token
    const verificacion = await query(`
      SELECT p.id, p.nombre, pt.token
      FROM plazas p
      LEFT JOIN plaza_tokens pt ON p.id = pt.plaza_id
      WHERE p.activo = TRUE
      ORDER BY p.nombre ASC
    `);
    
    const conToken = verificacion.filter(p => p.token);
    const sinToken = verificacion.filter(p => !p.token);
    
    console.log(`Total plazas: ${verificacion.length}`);
    console.log(`Plazas con token: ${conToken.length}`);
    console.log(`Plazas sin token: ${sinToken.length}`);
    
    if (sinToken.length > 0) {
      console.log('\nPlazas que aún no tienen token:');
      sinToken.forEach(plaza => {
        console.log(`- ${plaza.nombre} (ID: ${plaza.id})`);
      });
    } else {
      console.log('\n✅ Todas las plazas tienen tokens asignados');
    }
    
    process.exit(0);
    
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
}

generateMissingTokens();
