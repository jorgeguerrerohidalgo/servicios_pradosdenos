require('dotenv').config();
const { Pool } = require('pg');
const bcrypt = require('bcrypt');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

async function insertAdminUser() {
  try {
    console.log('🔌 Conectando a la base de datos...');
    
    // Hash de la contraseña
    const password = 'madneo710';
    const saltRounds = 12;
    const hashedPassword = await bcrypt.hash(password, saltRounds);
    
    console.log('🔐 Password hasheada:', hashedPassword);
    
    // Insertar usuario
    const insertQuery = `
      INSERT INTO admin_users 
      (nombre, apellido_paterno, apellido_materno, email, password_hash, activo, plaza_id, created_at, updated_at) 
      VALUES ($1, $2, $3, $4, $5, $6, $7, NOW(), NOW())
      ON CONFLICT (email) 
      DO UPDATE SET 
        password_hash = EXCLUDED.password_hash,
        activo = EXCLUDED.activo,
        updated_at = NOW()
      RETURNING id, email, activo;
    `;
    
    const values = [
      'Jorge',
      'Guerrero',
      'Hidalgo', 
      'jorgeguerrerohidalgo@gmail.com',
      hashedPassword,
      true,
      1
    ];
    
    console.log('📝 Insertando usuario...');
    const result = await pool.query(insertQuery, values);
    
    console.log('✅ Usuario insertado/actualizado:', result.rows[0]);
    
    // Verificar que se puede buscar
    const verifyQuery = 'SELECT id, nombre, email, activo FROM admin_users WHERE email = $1';
    const verifyResult = await pool.query(verifyQuery, ['jorgeguerrerohidalgo@gmail.com']);
    
    console.log('🔍 Verificación:', verifyResult.rows[0]);
    
    // Probar login
    console.log('🔑 Probando login...');
    const user = verifyResult.rows[0];
    const storedHash = (await pool.query('SELECT password_hash FROM admin_users WHERE email = $1', [user.email])).rows[0].password_hash;
    const passwordMatch = await bcrypt.compare(password, storedHash);
    
    console.log('🔐 Password match:', passwordMatch);
    console.log('📊 Detalles:', {
      userExists: !!user,
      userActive: user?.activo,
      activoType: typeof user?.activo,
      passwordCorrect: passwordMatch
    });
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await pool.end();
    console.log('🔌 Conexión cerrada');
  }
}

insertAdminUser();
