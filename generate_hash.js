const bcrypt = require('bcrypt');

async function generateHash() {
    const password = 'madneo710';
    const saltRounds = 10;
    
    try {
        const hash = await bcrypt.hash(password, saltRounds);
        console.log('Contraseña:', password);
        console.log('Hash generado:', hash);
        
        // Verificar que el hash funciona
        const isValid = await bcrypt.compare(password, hash);
        console.log('Verificación:', isValid ? '✅ Correcto' : '❌ Error');
        
    } catch (error) {
        console.error('Error:', error);
    }
}

generateHash();
