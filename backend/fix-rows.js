const fs = require('fs');
const path = require('path');

// Función para reemplazar todas las instancias de .rows en un archivo
function fixRowsReferences(filePath) {
    console.log(`Procesando archivo: ${filePath}`);
    
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Reemplazar todas las instancias de .rows
    content = content.replace(/\.rows\[/g, '[');
    content = content.replace(/\.rows\./g, '.');
    content = content.replace(/\.rows$/g, '');
    content = content.replace(/\.rows,/g, ',');
    content = content.replace(/\.rows;/g, ';');
    content = content.replace(/\.rows\)/g, ')');
    content = content.replace(/\.rows\s*\)/g, ')');
    
    // Casos específicos para .rows.map() y .rows.length
    content = content.replace(/result\.rows\.map\(/g, 'result.map(');
    content = content.replace(/result\.rows\.length/g, 'result.length');
    content = content.replace(/docsResult\.rows\.map\(/g, 'docsResult.map(');
    content = content.replace(/eventsResult\.rows\.map\(/g, 'eventsResult.map(');
    
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`✅ Archivo ${filePath} procesado correctamente`);
}

// Procesar los archivos
try {
    fixRowsReferences('./routes/eventos.routes.js');
    fixRowsReferences('./routes/documentos_comunitarios.routes.js');
    console.log('🎉 Todos los archivos procesados correctamente');
} catch (error) {
    console.error('❌ Error:', error.message);
}
