// Script para corregir TODAS las referencias .rows en documentos_comunitarios.routes.js
const fs = require('fs');

const filePath = './routes/documentos_comunitarios.routes.js';
let content = fs.readFileSync(filePath, 'utf8');

// Reemplazos exactos
const replacements = [
    ['result.rows[0]', 'result[0]'],
    ['result.rows.length', 'result.length'],
    ['data: result.rows', 'data: result'],
    ['tableCheck.rows[0]', 'tableCheck[0]']
];

console.log('Aplicando correcciones a documentos_comunitarios.routes.js...');

replacements.forEach(([search, replace]) => {
    const before = content.split(search).length - 1;
    content = content.split(search).join(replace);
    const after = content.split(search).length - 1;
    console.log(`${search} -> ${replace}: ${before - after} reemplazos`);
});

fs.writeFileSync(filePath, content, 'utf8');
console.log('✅ Correcciones aplicadas exitosamente');

// Verificar que no queden referencias .rows
const remainingRows = content.split('.rows').length - 1;
console.log(`Referencias .rows restantes: ${remainingRows}`);
