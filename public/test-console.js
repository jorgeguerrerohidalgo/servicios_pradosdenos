// Script de prueba para guardia-checkin.html
// Copia y pega este código en la consola del navegador

console.log('=== SCRIPT DE PRUEBA GUARDIA-CHECKIN ===');

// Función para probar la validación paso a paso
function testValidationFlow() {
    console.log('1. Verificando userValidationCode...');
    console.log('userValidationCode:', userValidationCode);
    console.log('Tipo:', typeof userValidationCode);
    
    if (!userValidationCode) {
        console.error('ERROR: userValidationCode es null o undefined');
        return;
    }
    
    console.log('2. Simulando escaneo QR...');
    scannedToken = 'TEST_TOKEN_123';
    showValidationSection();
    
    console.log('3. Verificando elementos del DOM...');
    const input = document.getElementById('validationCodeInput');
    const feedback = document.getElementById('codeValidationFeedback');
    const confirmBtn = document.getElementById('confirmCheckinBtn');
    
    console.log('Input existe:', !!input);
    console.log('Feedback existe:', !!feedback);
    console.log('Botón existe:', !!confirmBtn);
    console.log('Botón deshabilitado:', confirmBtn.disabled);
    
    console.log('4. Probando ingreso de código...');
    input.value = userValidationCode;
    console.log('Código ingresado:', input.value);
    
    console.log('5. Disparando evento input...');
    input.dispatchEvent(new Event('input'));
    
    console.log('6. Verificando estado después del evento...');
    console.log('Botón deshabilitado:', confirmBtn.disabled);
    console.log('Feedback text:', feedback.textContent);
    console.log('Feedback className:', feedback.className);
    
    if (confirmBtn.disabled) {
        console.error('ERROR: El botón sigue deshabilitado');
    } else {
        console.log('SUCCESS: El botón está habilitado');
    }
}

// Función para probar manualmente
function testManualInput(testCode) {
    const input = document.getElementById('validationCodeInput');
    const feedback = document.getElementById('codeValidationFeedback');
    const confirmBtn = document.getElementById('confirmCheckinBtn');
    
    console.log('Probando código:', testCode);
    input.value = testCode;
    input.dispatchEvent(new Event('input'));
    
    console.log('Resultado:');
    console.log('- Botón deshabilitado:', confirmBtn.disabled);
    console.log('- Feedback:', feedback.textContent);
    
    return !confirmBtn.disabled;
}

// Función para verificar event listeners
function checkEventListeners() {
    const input = document.getElementById('validationCodeInput');
    console.log('Verificando event listeners...');
    console.log('oninput:', input.oninput);
    console.log('onkeypress:', input.onkeypress);
    
    if (!input.oninput) {
        console.error('ERROR: No hay event listener oninput');
    } else {
        console.log('SUCCESS: Event listener oninput existe');
    }
}

console.log('Funciones disponibles:');
console.log('- testValidationFlow(): Prueba el flujo completo');
console.log('- testManualInput(code): Prueba un código específico');
console.log('- checkEventListeners(): Verifica los event listeners');
console.log('');
console.log('Ejemplo de uso:');
console.log('testValidationFlow();');
console.log('testManualInput("ABC123");');
console.log('checkEventListeners();');
