#!/usr/bin/env node

// Script para actualizar todas las páginas QR con la librería mejorada
const fs = require('fs');
const path = require('path');

console.log('🔧 ACTUALIZACIÓN DE LIBRERÍAS QR');
console.log('===============================');

const publicDir = path.join(__dirname, '..', '..', 'public');
const testingDir = path.join(__dirname, '..', 'html');

// Archivos a actualizar
const filesToUpdate = [
    path.join(publicDir, 'qr-plazas.html'),
    path.join(publicDir, 'setup-tokens.html'),
    path.join(publicDir, 'generar-tokens.html'),
    path.join(testingDir, 'qr-plazas.html'),
    path.join(testingDir, 'setup-tokens.html'),
    path.join(testingDir, 'generar-tokens.html')
];

console.log('\n📋 Archivos a actualizar:');
filesToUpdate.forEach(file => {
    const exists = fs.existsSync(file);
    console.log(`${exists ? '✅' : '❌'} ${file}`);
});

// Función para actualizar un archivo
function updateFile(filePath) {
    try {
        if (!fs.existsSync(filePath)) {
            console.log(`⚠️  Archivo no encontrado: ${filePath}`);
            return false;
        }
        
        let content = fs.readFileSync(filePath, 'utf8');
        let updated = false;
        
        // Reemplazar referencia a la librería anterior
        if (content.includes('simple-qr-generator.js')) {
            content = content.replace(
                'simple-qr-generator.js',
                'simple-qr-generator-fixed.js'
            );
            updated = true;
        }
        
        // Actualizar comentarios
        if (content.includes('Implementación propia de QR que NO depende de CDNs externos')) {
            content = content.replace(
                'Implementación propia de QR que NO depende de CDNs externos',
                'Implementación mejorada de QR con múltiples métodos de respaldo'
            );
            updated = true;
        }
        
        // Agregar verificación de librería si no existe
        if (content.includes('QRCode.toCanvas') && !content.includes('typeof QRCode')) {
            const verification = `
                    // Verificar que QRCode esté disponible
                    if (typeof QRCode === 'undefined') {
                        throw new Error('Librería QRCode no disponible - verificar simple-qr-generator-fixed.js');
                    }
                    
                    console.log('🔍 Usando librería QR mejorada');
                    `;
            
            content = content.replace(
                'await QRCode.toCanvas',
                verification + '\n                    await QRCode.toCanvas'
            );
            updated = true;
        }
        
        if (updated) {
            fs.writeFileSync(filePath, content, 'utf8');
            console.log(`✅ Actualizado: ${path.basename(filePath)}`);
            return true;
        } else {
            console.log(`ℹ️  No requiere actualización: ${path.basename(filePath)}`);
            return false;
        }
        
    } catch (error) {
        console.error(`❌ Error actualizando ${filePath}: ${error.message}`);
        return false;
    }
}

// Función para copiar librería mejorada si no existe
function copyLibraryIfNeeded() {
    const sourceLib = path.join(__dirname, '..', '..', 'public', 'simple-qr-generator-fixed.js');
    const targetLib = path.join(testingDir, 'simple-qr-generator-fixed.js');
    
    if (fs.existsSync(sourceLib)) {
        if (!fs.existsSync(targetLib)) {
            fs.copyFileSync(sourceLib, targetLib);
            console.log('✅ Librería copiada a testing/html/');
        } else {
            console.log('ℹ️  Librería ya existe en testing/html/');
        }
    } else {
        console.log('⚠️  Librería fuente no encontrada');
    }
}

// Función para crear página de verificación
function createVerificationPage() {
    const verificationContent = `<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verificación QR - Los Prados de Nos</title>
    <script src="simple-qr-generator-fixed.js"></script>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; }
        h1 { color: #2c3e50; text-align: center; }
        .status { padding: 15px; border-radius: 5px; margin: 10px 0; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        .qr-test { text-align: center; margin: 20px 0; }
        canvas { border: 1px solid #ddd; border-radius: 5px; }
        button { background: #3498db; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; }
        button:hover { background: #2980b9; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 Verificación de QR</h1>
        
        <div id="libraryStatus" class="status"></div>
        
        <div class="qr-test">
            <button onclick="testQR()">🧪 Probar Generación QR</button>
            <div id="qrResult"></div>
        </div>
        
        <div>
            <h3>📋 Información del Sistema</h3>
            <div id="systemInfo"></div>
        </div>
    </div>

    <script>
        function checkLibrary() {
            const statusDiv = document.getElementById('libraryStatus');
            const systemDiv = document.getElementById('systemInfo');
            
            if (typeof QRCode !== 'undefined') {
                statusDiv.className = 'status success';
                statusDiv.textContent = '✅ Librería QR cargada correctamente';
                
                systemDiv.innerHTML = 
                    '<strong>Librería:</strong> QRCode (mejorada)<br>' +
                    '<strong>Métodos:</strong> ' + Object.keys(QRCode).join(', ') + '<br>' +
                    '<strong>Fecha:</strong> ' + new Date().toLocaleString();
            } else {
                statusDiv.className = 'status error';
                statusDiv.textContent = '❌ Error: Librería QR no disponible';
                
                systemDiv.innerHTML = '<strong>Error:</strong> simple-qr-generator-fixed.js no cargado';
            }
        }
        
        async function testQR() {
            const resultDiv = document.getElementById('qrResult');
            
            try {
                const canvas = document.createElement('canvas');
                await QRCode.toCanvas(canvas, 'qr-plaza-verificacion-2025', { width: 150 });
                
                resultDiv.innerHTML = '<h4>✅ QR Generado Exitosamente</h4>';
                resultDiv.appendChild(canvas);
                
            } catch (error) {
                resultDiv.innerHTML = '<h4>❌ Error: ' + error.message + '</h4>';
            }
        }
        
        window.addEventListener('load', checkLibrary);
    </script>
</body>
</html>`;
    
    const verificationPath = path.join(publicDir, 'verificacion-qr.html');
    fs.writeFileSync(verificationPath, verificationContent, 'utf8');
    console.log('✅ Página de verificación creada: verificacion-qr.html');
}

// Ejecutar actualizaciones
console.log('\n🔄 Iniciando actualizaciones...');

// Copiar librería si es necesario
copyLibraryIfNeeded();

// Actualizar archivos
let updatedCount = 0;
filesToUpdate.forEach(file => {
    if (updateFile(file)) {
        updatedCount++;
    }
});

// Crear página de verificación
createVerificationPage();

console.log('\n📊 RESUMEN DE ACTUALIZACIONES:');
console.log(`✅ Archivos actualizados: ${updatedCount}`);
console.log(`📁 Archivos procesados: ${filesToUpdate.length}`);
console.log(`🔧 Librería mejorada: simple-qr-generator-fixed.js`);
console.log(`🌐 Página de verificación: verificacion-qr.html`);

console.log('\n🎯 PRÓXIMOS PASOS:');
console.log('1. Abrir verificacion-qr.html para confirmar que funciona');
console.log('2. Probar qr-plazas.html con la librería mejorada');
console.log('3. Verificar que los QR se generen completamente');
console.log('4. Aplicar correcciones de tokens si es necesario');

console.log('\n✅ Actualización completada!');
