// Script de diagnóstico para qr-plazas.html
console.log('=== DIAGNÓSTICO QR PLAZAS ===');

// 1. Verificar QRCode
console.log('1. Verificando QRCode library...');
if (typeof QRCode !== 'undefined') {
    console.log('✅ QRCode disponible');
} else {
    console.log('❌ QRCode NO disponible');
}

// 2. Verificar API
console.log('2. Verificando API de plazas...');
fetch('/api/plazas')
    .then(response => {
        console.log('Response status:', response.status);
        return response.json();
    })
    .then(data => {
        console.log('✅ API responde:', data);
        if (data.plazas && data.plazas.length > 0) {
            console.log(`✅ ${data.plazas.length} plazas encontradas`);
        } else {
            console.log('⚠️ No se encontraron plazas');
        }
    })
    .catch(error => {
        console.log('❌ Error en API:', error);
    });

// 3. Verificar elementos DOM
console.log('3. Verificando elementos DOM...');
const elementos = [
    'plazaSelect',
    'customText',
    'qrSize',
    'qrColor',
    'qrForm',
    'generateAllBtn',
    'qrResult',
    'qrcode',
    'alertContainer',
    'allQRContainer'
];

elementos.forEach(id => {
    const elemento = document.getElementById(id);
    if (elemento) {
        console.log(`✅ Elemento ${id} encontrado`);
    } else {
        console.log(`❌ Elemento ${id} NO encontrado`);
    }
});

// 4. Verificar funciones
console.log('4. Verificando funciones...');
const funciones = [
    'debug',
    'loadPlazas',
    'generateSingleQR',
    'generateQRCode',
    'generateAllQRs',
    'showAlert'
];

funciones.forEach(func => {
    if (typeof window[func] === 'function') {
        console.log(`✅ Función ${func} disponible`);
    } else {
        console.log(`❌ Función ${func} NO disponible`);
    }
});

console.log('=== FIN DIAGNÓSTICO ===');
