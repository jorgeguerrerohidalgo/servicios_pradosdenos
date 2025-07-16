// Verificar que bcrypt esté instalado y funcione
try {
    const bcrypt = require('bcrypt');
    console.log('✅ bcrypt importado correctamente');
    
    // Test básico
    const testPassword = 'test123';
    const hash = bcrypt.hashSync(testPassword, 10);
    const isMatch = bcrypt.compareSync(testPassword, hash);
    
    console.log('✅ bcrypt funciona correctamente');
    console.log('🔐 Hash generado:', hash);
    console.log('🔍 Verificación:', isMatch);
    
    // Verificar versión
    console.log('📦 bcrypt version:', require('bcrypt/package.json').version);
    
} catch (error) {
    console.error('❌ Error con bcrypt:', error.message);
    console.error('💡 Asegúrate de que bcrypt esté instalado: npm install bcrypt');
}

// Verificar dependencias críticas
const dependencies = ['express', 'pg', 'cors', 'express-session', 'helmet'];

dependencies.forEach(dep => {
    try {
        const pkg = require(dep);
        console.log(`✅ ${dep} - OK`);
    } catch (error) {
        console.error(`❌ ${dep} - FALTA`);
    }
});

console.log('\n🔍 Variables de entorno:');
console.log('NODE_ENV:', process.env.NODE_ENV);
console.log('DATABASE_URL configurado:', !!process.env.DATABASE_URL);
console.log('SESSION_SECRET configurado:', !!process.env.SESSION_SECRET);
console.log('PORT:', process.env.PORT || 3000);
