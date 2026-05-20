/**
 * Test de creación de administrador
 * Para diagnosticar el error 500
 */

const bcrypt = require('bcrypt');
const { pool } = require('../backend/utils/db');

async function testCreateAdmin() {
  console.log('🧪 === TEST: Crear Administrador ===\n');
  
  const testData = {
    nombre: 'Test',
    apellido_paterno: 'Usuario',
    apellido_materno: 'Prueba',
    email: 'test' + Date.now() + '@example.com',
    telefono: '123456789',
    password: 'test1234'
  };
  
  console.log('📝 Datos de prueba:', testData);
  
  try {
    // 1. Verificar estructura de la tabla
    console.log('\n1️⃣ Verificando estructura de admin_users...');
    const structure = await pool.query(`
      SELECT column_name, data_type, is_nullable, column_default
      FROM information_schema.columns
      WHERE table_name = 'admin_users'
      ORDER BY ordinal_position
    `);
    console.log('Columnas disponibles:');
    structure.rows.forEach(col => {
      console.log(`  - ${col.column_name} (${col.data_type}) ${col.is_nullable === 'YES' ? 'NULL' : 'NOT NULL'} ${col.column_default || ''}`);
    });
    
    // 2. Hash de contraseña
    console.log('\n2️⃣ Generando hash de contraseña...');
    const hashedPassword = await bcrypt.hash(testData.password, 10);
    console.log('✅ Hash generado');
    
    // 3. Intentar INSERT
    console.log('\n3️⃣ Ejecutando INSERT...');
    const query = `
      INSERT INTO admin_users (nombre, apellido_paterno, apellido_materno, email, telefono, password_hash, activo) 
      VALUES ($1, $2, $3, $4, $5, $6, true) 
      RETURNING id, nombre, apellido_paterno, apellido_materno, email, telefono, activo, created_at
    `;
    
    const params = [
      testData.nombre,
      testData.apellido_paterno,
      testData.apellido_materno,
      testData.email,
      testData.telefono,
      hashedPassword
    ];
    
    console.log('Query:', query);
    console.log('Params:', params.slice(0, 5), '[PASSWORD_HASH]');
    
    const result = await pool.query(query, params);
    
    console.log('\n✅ ÉXITO - Administrador creado:');
    console.log(result.rows[0]);
    
    // 4. Limpiar datos de prueba
    console.log('\n4️⃣ Limpiando datos de prueba...');
    await pool.query('DELETE FROM admin_users WHERE id = $1', [result.rows[0].id]);
    console.log('✅ Usuario de prueba eliminado');
    
  } catch (error) {
    console.error('\n❌ ERROR:', error.message);
    console.error('Código:', error.code);
    console.error('Detalle:', error.detail);
    console.error('Hint:', error.hint);
    console.error('Stack:', error.stack);
  }
  
  process.exit(0);
}

testCreateAdmin();
