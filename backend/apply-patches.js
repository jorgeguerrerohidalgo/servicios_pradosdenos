// Parche para corregir todos los problemas con .rows en los archivos de rutas
const fs = require('fs');

// Función para aplicar parche a un archivo
function patchFile(filePath, patches) {
    console.log(`Aplicando parche a ${filePath}...`);
    let content = fs.readFileSync(filePath, 'utf8');
    
    patches.forEach(patch => {
        if (content.includes(patch.search)) {
            content = content.replace(new RegExp(patch.search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g'), patch.replace);
            console.log(`✅ Reemplazado: ${patch.search} -> ${patch.replace}`);
        } else {
            console.log(`⚠️  No encontrado: ${patch.search}`);
        }
    });
    
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`✅ Parche aplicado a ${filePath}`);
}

// Parches para eventos.routes.js
const eventosPatches = [
    { search: 'result.rows[0]', replace: 'result[0]' },
    { search: 'result.rows.length', replace: 'result.length' },
    { search: 'data: result.rows', replace: 'data: result' }
];

// Parches para documentos_comunitarios.routes.js
const documentosPatches = [
    { search: 'result.rows[0]', replace: 'result[0]' },
    { search: 'result.rows.length', replace: 'result.length' },
    { search: 'data: result.rows', replace: 'data: result' }
];

try {
    patchFile('./routes/eventos.routes.js', eventosPatches);
    patchFile('./routes/documentos_comunitarios.routes.js', documentosPatches);
    console.log('🎉 Todos los parches aplicados correctamente');
} catch (error) {
    console.error('❌ Error aplicando parches:', error.message);
}
