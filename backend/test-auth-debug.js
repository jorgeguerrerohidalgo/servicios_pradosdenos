require('dotenv').config();
const bcrypt = require('bcrypt');
const { Pool } = require('pg');

// Datos exactos del usuario según admin_users_rows.sql
const testUser = {
  id: 6,
  email: 'jorgeguerrerohidalgo@gmail.com',
  password: 'madneo710',
  storedHash: '$2b$12$A77lpJIUOs4Q0uzsndec/ueLMSdsY3MOrj1p4v5p2iimp2rkM2I2.',
  activo: 'true' // Como string
};

console.log('=== TESTING AUTENTICACIÓN ===');
console.log('Email:', testUser.email);
console.log('Password:', testUser.password);
console.log('Stored Hash:', testUser.storedHash);
console.log('Campo activo:', testUser.activo, '(tipo:', typeof testUser.activo, ')');

// Test 1: Verificar hash
console.log('\n--- Test 1: Verificación de Hash ---');
const hashValid = bcrypt.compareSync(testUser.password, testUser.storedHash);
console.log('Hash válido:', hashValid);

if (!hashValid) {
  console.log('❌ ERROR: El hash no coincide con la contraseña');
} else {
  console.log('✅ OK: Hash válido');
}

// Test 2: Generar nuevo hash para comparar
console.log('\n--- Test 2: Nuevo Hash para Comparar ---');
const newHash = bcrypt.hashSync(testUser.password, 12);
console.log('Nuevo hash:', newHash);
const newHashValid = bcrypt.compareSync(testUser.password, newHash);
console.log('Nuevo hash válido:', newHashValid);

// Test 3: Verificar campo activo
console.log('\n--- Test 3: Campo Activo ---');
const activoConditions = [
  testUser.activo === true,
  testUser.activo === 'true', 
  testUser.activo == true,
  Boolean(testUser.activo)
];
console.log('activo === true:', activoConditions[0]);
console.log('activo === "true":', activoConditions[1]);
console.log('activo == true:', activoConditions[2]);
console.log('Boolean(activo):', activoConditions[3]);

const isActive = testUser.activo === true || testUser.activo === 'true';
console.log('Usuario activo (condición OR):', isActive);

// Test 4: Simular query de base de datos
console.log('\n--- Test 4: Simulación Query DB ---');

const dbQuery = `
SELECT id, email, password_hash, activo 
FROM admin_users 
WHERE email = $1 AND (activo = TRUE OR activo = 'true')
`;

console.log('Query SQL:', dbQuery);
console.log('Parámetros:', [testUser.email]);

// Test 5: Conectar a DB real si es posible
if (process.env.DATABASE_URL) {
  console.log('\n--- Test 5: Verificación en Base de Datos Real ---');
  
  const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
  });

  pool.query(dbQuery, [testUser.email])
    .then(result => {
      console.log('Resultados encontrados:', result.rowCount);
      if (result.rows.length > 0) {
        const user = result.rows[0];
        console.log('Usuario encontrado:', {
          id: user.id,
          email: user.email,
          activo: user.activo,
          activo_type: typeof user.activo,
          hash_matches: bcrypt.compareSync(testUser.password, user.password_hash)
        });
      } else {
        console.log('❌ No se encontró usuario con el email');
      }
      
      pool.end();
    })
    .catch(err => {
      console.error('Error en query:', err.message);
      pool.end();
    });
} else {
  console.log('DATABASE_URL no configurada, saltando test de DB real');
}

console.log('\n=== FIN DE TESTS ===');
