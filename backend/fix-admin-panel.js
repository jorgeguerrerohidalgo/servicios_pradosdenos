const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, '..', 'public', 'admin-panel.html');

// Leer el archivo
let content = fs.readFileSync(filePath, 'utf8');

console.log('🔍 Archivo original length:', content.length);

// Patrones a reemplazar
const replacements = [
    {
        // Patrón: const token = localStorage.getItem('adminToken'); if (!token) return;
        pattern: /const token = localStorage\.getItem\('adminToken'\);\s*if \(!token\) return;?\s*/g,
        replacement: '// Usando authenticatedFetch con sesiones\n                '
    },
    {
        // Patrón: headers: { 'Authorization': `Bearer ${token}` }
        pattern: /headers:\s*\{\s*'Authorization':\s*`Bearer \$\{token\}`\s*\}/g,
        replacement: 'headers: { /* usando authenticatedFetch */ }'
    },
    {
        // Patrón: await fetch(url, { headers: { 'Authorization': `Bearer ${token}` } })
        pattern: /await fetch\(([^,]+),\s*\{\s*headers:\s*\{\s*'Authorization':\s*`Bearer \$\{token\}`\s*\}\s*\}\)/g,
        replacement: 'await authenticatedFetch($1)'
    },
    {
        // Patrón: fetch(url, { method: 'POST', headers: { 'Authorization': `Bearer ${token}`, 'Content-Type': 'application/json' }, body: JSON.stringify(data) })
        pattern: /fetch\(([^,]+),\s*\{\s*method:\s*'([^']+)',\s*headers:\s*\{\s*'Authorization':\s*`Bearer \$\{token\}`,\s*'Content-Type':\s*'[^']+'\s*\},\s*body:\s*([^}]+)\s*\}\)/g,
        replacement: 'authenticatedFetch($1, { method: \'$2\', body: $3 })'
    }
];

// Aplicar reemplazos
let changeCount = 0;
replacements.forEach((repl, index) => {
    const before = content;
    content = content.replace(repl.pattern, repl.replacement);
    const matches = (before.match(repl.pattern) || []).length;
    if (matches > 0) {
        changeCount += matches;
        console.log(`✅ Patrón ${index + 1}: ${matches} reemplazos`);
    }
});

console.log(`🔧 Total de cambios realizados: ${changeCount}`);

// Escribir archivo actualizado
fs.writeFileSync(filePath, content, 'utf8');
console.log('✅ Archivo actualizado correctamente');

console.log('📝 Nuevo archivo length:', content.length);
