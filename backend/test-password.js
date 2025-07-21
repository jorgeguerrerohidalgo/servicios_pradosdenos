const bcrypt = require('bcrypt');

async function testPassword() {
    const password = 'madneo710';
    const hash = '$2b$12$A77lpJIUOs4Q0uzsndec/ueLMSdsY3MOrj1p4v5p2iimp2rkM2I2.';
    
    console.log('Testing password:', password);
    console.log('Against hash:', hash);
    
    try {
        const result = await bcrypt.compare(password, hash);
        console.log('Bcrypt result:', result);
        
        // También probar comparación directa
        const directResult = (hash === password);
        console.log('Direct comparison result:', directResult);
        
        if (result) {
            console.log('✅ Password matches!');
        } else {
            console.log('❌ Password does not match');
        }
    } catch (error) {
        console.error('Error:', error.message);
    }
}

testPassword();
