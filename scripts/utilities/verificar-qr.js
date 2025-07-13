#!/usr/bin/env node

// Script de verificación rápida para códigos QR
const fs = require('fs');
const path = require('path');

console.log('🔍 VERIFICACIÓN RÁPIDA DE CÓDIGOS QR');
console.log('=====================================');

const projectRoot = path.join(__dirname, '..', '..');

// Archivos a verificar
const filesToCheck = [
    {
        path: path.join(projectRoot, 'public', 'qr-plazas.html'),
        name: 'Página Principal QR',
        shouldContain: [
            'https://cdnjs.cloudflare.com/ajax/libs/qrcode/1.5.3/qrcode.min.js',
            'QRCode.toCanvas',
            'errorCorrectionLevel'
        ]
    },
    {
        path: path.join(projectRoot, 'testing', 'debug', 'diagnostico-qr-simple.html'),
        name: 'Diagnóstico QR Simple',
        shouldContain: [
            'https://cdnjs.cloudflare.com/ajax/libs/qrcode/1.5.3/qrcode.min.js',
            'Diagnóstico QR Simple',
            'QRCode.toCanvas'
        ]
    },
    {
        path: path.join(projectRoot, 'testing', 'debug', 'qr-plazas-funcional.html'),
        name: 'QR Plazas Funcional',
        shouldContain: [
            'https://cdnjs.cloudflare.com/ajax/libs/qrcode/1.5.3/qrcode.min.js',
            'Versión Funcional',
            'QR 100% escaneables'
        ]
    }
];

// Verificar archivos
console.log('\n📋 Verificando archivos...');
let allGood = true;

filesToCheck.forEach(file => {
    const exists = fs.existsSync(file.path);
    
    if (!exists) {
        console.log(`❌ ${file.name}: Archivo no encontrado`);
        allGood = false;
        return;
    }
    
    const content = fs.readFileSync(file.path, 'utf8');
    const missingContent = file.shouldContain.filter(item => !content.includes(item));
    
    if (missingContent.length > 0) {
        console.log(`⚠️  ${file.name}: Falta contenido - ${missingContent.join(', ')}`);
        allGood = false;
    } else {
        console.log(`✅ ${file.name}: Correcto`);
    }
});

// Verificar que no use librerías antiguas
console.log('\n🔍 Verificando librerías antiguas...');
const oldLibraries = [
    'simple-qr-generator.js',
    'simple-qr-generator-fixed.js'
];

filesToCheck.forEach(file => {
    if (!fs.existsSync(file.path)) return;
    
    const content = fs.readFileSync(file.path, 'utf8');
    const foundOldLibs = oldLibraries.filter(lib => content.includes(lib));
    
    if (foundOldLibs.length > 0) {
        console.log(`⚠️  ${file.name}: Usa librerías antiguas - ${foundOldLibs.join(', ')}`);
        allGood = false;
    } else {
        console.log(`✅ ${file.name}: Sin librerías antiguas`);
    }
});

// Verificar documentación
console.log('\n📚 Verificando documentación...');
const docsToCheck = [
    path.join(projectRoot, 'docs', 'troubleshooting', 'guia-verificacion-qr.md'),
    path.join(projectRoot, 'docs', 'troubleshooting', 'solucion-qr-incompletos.md')
];

docsToCheck.forEach(docPath => {
    const exists = fs.existsSync(docPath);
    const docName = path.basename(docPath);
    
    if (exists) {
        console.log(`✅ ${docName}: Disponible`);
    } else {
        console.log(`❌ ${docName}: No encontrado`);
        allGood = false;
    }
});

// Generar reporte
console.log('\n📊 REPORTE DE VERIFICACIÓN:');
console.log('==========================');

if (allGood) {
    console.log('✅ TODOS LOS ARCHIVOS CORRECTOS');
    console.log('');
    console.log('🎯 PRÓXIMOS PASOS:');
    console.log('1. Abrir testing/debug/diagnostico-qr-simple.html');
    console.log('2. Hacer clic en "Generar QR de Prueba"');
    console.log('3. Verificar que aparezca un QR');
    console.log('4. Escanear el QR con tu teléfono');
    console.log('5. Verificar que muestre el token correcto');
    console.log('');
    console.log('📱 APPS RECOMENDADAS PARA ESCANEAR:');
    console.log('- Cámara nativa del teléfono');
    console.log('- QR Code Reader');
    console.log('- Google Lens');
    console.log('');
    console.log('🔗 PÁGINAS PARA PROBAR:');
    console.log('- testing/debug/diagnostico-qr-simple.html (diagnóstico)');
    console.log('- testing/debug/qr-plazas-funcional.html (versión funcional)');
    console.log('- public/qr-plazas.html (página principal)');
    
} else {
    console.log('❌ ALGUNOS ARCHIVOS NECESITAN CORRECCIÓN');
    console.log('');
    console.log('🔧 ACCIONES RECOMENDADAS:');
    console.log('1. Verificar que todos los archivos existan');
    console.log('2. Asegurarse de que usen QRCode.js externa');
    console.log('3. Eliminar referencias a librerías antiguas');
    console.log('4. Ejecutar este script nuevamente');
}

console.log('\n🎉 Verificación completada');

// Generar archivo de estado
const statusReport = {
    timestamp: new Date().toISOString(),
    allGood: allGood,
    filesChecked: filesToCheck.length,
    docsChecked: docsToCheck.length,
    recommendedActions: allGood ? [
        'Probar diagnóstico QR',
        'Escanear QR con teléfono',
        'Verificar tokens correctos'
    ] : [
        'Corregir archivos problemáticos',
        'Verificar librerías externas',
        'Ejecutar script nuevamente'
    ]
};

const statusPath = path.join(projectRoot, 'docs', 'troubleshooting', 'estado-qr.json');
fs.writeFileSync(statusPath, JSON.stringify(statusReport, null, 2));
console.log(`📄 Estado guardado en: ${statusPath}`);
