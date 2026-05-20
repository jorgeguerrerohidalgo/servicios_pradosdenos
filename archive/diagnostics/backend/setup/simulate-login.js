require('dotenv').config();
const { Pool } = require('pg');
const bcrypt = require('bcrypt');

const pool = new Pool({
    connectionString: process.env.DATABASE_URL || 'postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres',
    ssl: { rejectUnauthorized: false }
});

async function simulateLogin(email, password) {
    const client = await pool.connect();
    
    try {
        console.log(`🔍 Simulando login para: ${email}`);
        console.log(`🔐 Con contraseña: ${password}`);
        
        // Paso 1: Buscar en guardias
        console.log('\n1️⃣ Buscando en tabla guardias...');
        let user = await client.query('SELECT * FROM guardias WHERE email = $1 AND activo = true', [email]);
        let userType = 'guardia';
        
        console.log(`   Resultado: ${user.rows.length} registros encontrados`);
        
        // Paso 2: Si no se encuentra, buscar en admin_users
        if (user.rows.length === 0) {
            console.log('\n2️⃣ Buscando en tabla admin_users...');
            user = await client.query('SELECT *, password_hash as password FROM admin_users WHERE email = $1 AND activo = true', [email]);
            userType = 'admin';
            console.log(`   Resultado: ${user.rows.length} registros encontrados`);
        }
        
        // Paso 3: Verificar si se encontró el usuario
        if (user.rows.length === 0) {
            console.log('\n❌ Usuario NO encontrado');
            return { success: false, error: 'Usuario no encontrado' };
        }
        
        const foundUser = user.rows[0];
        console.log(`\n✅ Usuario encontrado:`);
        console.log(`   ID: ${foundUser.id}`);
        console.log(`   Nombre: ${foundUser.nombre}`);
        console.log(`   Email: ${foundUser.email}`);
        console.log(`   Tipo: ${userType}`);
        console.log(`   Contraseña en DB: ${foundUser.password}`);
        console.log(`   Contraseña proporcionada: ${password}`);
        
        // Paso 4: Verificar contraseña
        console.log('\n4️⃣ Verificando contraseña...');
        let passwordMatch = false;
        
        if (foundUser.password) {
            // Comparación directa (texto plano)
            if (foundUser.password === password) {
                passwordMatch = true;
                console.log('✅ Contraseña coincide (texto plano)');
            } else {
                // Comparación con bcrypt
                try {
                    passwordMatch = await bcrypt.compare(password, foundUser.password);
                    if (passwordMatch) {
                        console.log('✅ Contraseña coincide (bcrypt)');
                    } else {
                        console.log('❌ Contraseña NO coincide (ni texto plano ni bcrypt)');
                    }
                } catch (bcryptError) {
                    console.log('❌ Error en bcrypt:', bcryptError.message);
                }
            }
        } else {
            console.log('❌ No hay contraseña en la base de datos');
        }
        
        // Paso 5: Resultado final
        if (passwordMatch) {
            console.log('\n✅ LOGIN EXITOSO');
            const userName = userType === 'guardia' ? foundUser.nombre : `${foundUser.nombre} ${foundUser.apellido_paterno}`;
            return {
                success: true,
                user: {
                    id: foundUser.id,
                    nombre: userName,
                    email: foundUser.email,
                    tipo: userType
                }
            };
        } else {
            console.log('\n❌ LOGIN FALLIDO - Contraseña incorrecta');
            return { success: false, error: 'Contraseña incorrecta' };
        }
        
    } catch (error) {
        console.error('\n❌ ERROR EN SIMULACIÓN:', error.message);
        console.error('Stack:', error.stack);
        return { success: false, error: error.message };
    } finally {
        client.release();
    }
}

async function testBothUsers() {
    console.log('🚀 Simulando login para ambos usuarios...\n');
    
    // Test Admin
    console.log('=' .repeat(60));
    console.log('ADMIN LOGIN TEST');
    console.log('=' .repeat(60));
    const adminResult = await simulateLogin('jorgeguerrerohidalgo@gmail.com', 'madneo710');
    console.log('\n📊 Resultado Admin:', adminResult);
    
    // Test Guardia
    console.log('\n\n' + '=' .repeat(60));
    console.log('GUARDIA LOGIN TEST');
    console.log('=' .repeat(60));
    const guardiaResult = await simulateLogin('juan.perez@pradosdenos.com', 'prueba123');
    console.log('\n📊 Resultado Guardia:', guardiaResult);
    
    await pool.end();
}

testBothUsers();
