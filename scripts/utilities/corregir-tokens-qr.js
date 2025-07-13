// Script para corregir tokens QR de plazas
// Este script genera tokens únicos y consistentes para cada plaza

const fs = require('fs');
const path = require('path');

// Función para generar token basado en el nombre de la plaza
function generarToken(nombrePlaza) {
    // Normalizar el nombre: quitar acentos, espacios, convertir a minúsculas
    const nombreNormalizado = nombrePlaza
        .toLowerCase()
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "") // Quitar acentos
        .replace(/[^a-z0-9\s]/g, "") // Solo letras, números y espacios
        .replace(/\s+/g, "-") // Reemplazar espacios con guiones
        .replace(/-+/g, "-") // Evitar guiones múltiples
        .replace(/^-|-$/g, ""); // Quitar guiones al inicio y final
    
    // Agregar prefijo y año para hacer el token único
    const año = new Date().getFullYear();
    return `qr-plaza-${nombreNormalizado}-${año}`;
}

// Mapeo de plazas conocidas con sus tokens corregidos
const plazasConTokensCorrectos = [
    { nombre: "Plaza Avellino", token: "qr-plaza-avellino-2025" },
    { nombre: "Plaza Castellón", token: "qr-plaza-castellon-2025" },
    { nombre: "Plaza Los Álamos", token: "qr-plaza-los-alamos-2025" },
    { nombre: "Plaza Central", token: "qr-plaza-central-2025" },
    { nombre: "Plaza Norte", token: "qr-plaza-norte-2025" },
    { nombre: "Plaza Sur", token: "qr-plaza-sur-2025" },
    { nombre: "Plaza Este", token: "qr-plaza-este-2025" },
    { nombre: "Plaza Oeste", token: "qr-plaza-oeste-2025" },
];

// Generar SQL para actualizar los tokens
function generarSQLDeActualizacion() {
    let sql = "-- Script para corregir tokens QR de plazas\n";
    sql += "-- Generado automáticamente el " + new Date().toLocaleString() + "\n\n";
    
    sql += "BEGIN;\n\n";
    
    for (const plaza of plazasConTokensCorrectos) {
        sql += `-- Actualizar token para ${plaza.nombre}\n`;
        sql += `UPDATE plazas SET token = '${plaza.token}' WHERE nombre = '${plaza.nombre}';\n\n`;
    }
    
    sql += "-- Verificar los cambios\n";
    sql += "SELECT id, nombre, token FROM plazas ORDER BY nombre;\n\n";
    
    sql += "COMMIT;\n";
    
    return sql;
}

// Generar JavaScript para verificar tokens
function generarScriptVerificacion() {
    let js = "// Script de verificación de tokens QR\n";
    js += "// Ejecutar en la consola del navegador en qr-plazas.html\n\n";
    
    js += "async function verificarTokens() {\n";
    js += "    try {\n";
    js += "        const response = await fetch('/api/plazas');\n";
    js += "        const plazas = await response.json();\n";
    js += "        \n";
    js += "        console.log('=== VERIFICACIÓN DE TOKENS QR ===');\n";
    js += "        console.log('Total de plazas:', plazas.length);\n";
    js += "        console.log('');\n";
    js += "        \n";
    js += "        const tokensEsperados = {\n";
    
    for (const plaza of plazasConTokensCorrectos) {
        js += `            '${plaza.nombre}': '${plaza.token}',\n`;
    }
    
    js += "        };\n";
    js += "        \n";
    js += "        let errores = 0;\n";
    js += "        \n";
    js += "        for (const plaza of plazas) {\n";
    js += "            const tokenEsperado = tokensEsperados[plaza.nombre];\n";
    js += "            const tokenActual = plaza.token;\n";
    js += "            \n";
    js += "            if (tokenEsperado) {\n";
    js += "                if (tokenActual === tokenEsperado) {\n";
    js += "                    console.log(`✅ ${plaza.nombre}: Token correcto (${tokenActual})`);\n";
    js += "                } else {\n";
    js += "                    console.error(`❌ ${plaza.nombre}:`);\n";
    js += "                    console.error(`   Esperado: ${tokenEsperado}`);\n";
    js += "                    console.error(`   Actual:   ${tokenActual}`);\n";
    js += "                    errores++;\n";
    js += "                }\n";
    js += "            } else {\n";
    js += "                console.warn(`⚠️ ${plaza.nombre}: Plaza no reconocida, token actual: ${tokenActual}`);\n";
    js += "            }\n";
    js += "        }\n";
    js += "        \n";
    js += "        console.log('');\n";
    js += "        console.log(`=== RESUMEN ===`);\n";
    js += "        console.log(`Errores encontrados: ${errores}`);\n";
    js += "        \n";
    js += "        if (errores > 0) {\n";
    js += "            console.log('🔧 Para corregir los tokens, ejecute el script SQL de actualización.');\n";
    js += "        } else {\n";
    js += "            console.log('🎉 Todos los tokens están correctos!');\n";
    js += "        }\n";
    js += "        \n";
    js += "    } catch (error) {\n";
    js += "        console.error('Error verificando tokens:', error);\n";
    js += "    }\n";
    js += "}\n\n";
    js += "// Ejecutar verificación\n";
    js += "verificarTokens();\n";
    
    return js;
}

// Mostrar información sobre el problema y las soluciones
console.log("🔧 CORRECCIÓN DE TOKENS QR DE PLAZAS");
console.log("=====================================");
console.log("");
console.log("Problema identificado:");
console.log("- Los códigos QR no coinciden con los tokens reales de las plazas");
console.log("- Plaza Avellino tiene token 'qr-plaza-castellon-2025' (incorrecto)");
console.log("");
console.log("Solución propuesta:");
console.log("1. Generar tokens consistentes basados en nombres de plazas");
console.log("2. Actualizar base de datos con tokens corregidos");
console.log("3. Verificar que QR-plazas.html use los tokens correctos");
console.log("");

// Generar archivos de corrección
const sqlScript = generarSQLDeActualizacion();
const jsScript = generarScriptVerificacion();

// Guardar archivos
const outputDir = './scripts/database/';
const sqlFile = path.join(outputDir, 'corregir-tokens-plazas.sql');
const jsFile = path.join('./testing/debug/', 'verificar-tokens-qr.js');

try {
    fs.writeFileSync(sqlFile, sqlScript, 'utf8');
    console.log(`✅ Script SQL generado: ${sqlFile}`);
} catch (error) {
    console.log(`📝 Script SQL (copiar manualmente):`);
    console.log(sqlScript);
}

try {
    fs.writeFileSync(jsFile, jsScript, 'utf8');
    console.log(`✅ Script JS generado: ${jsFile}`);
} catch (error) {
    console.log(`📝 Script JS (copiar manualmente):`);
    console.log(jsScript);
}

console.log("");
console.log("📋 PASOS PARA CORREGIR:");
console.log("1. Ejecutar el script SQL en la base de datos");
console.log("2. Ejecutar el script JS en la consola del navegador");
console.log("3. Verificar que los QR se generen correctamente");
console.log("");
console.log("📁 Archivos de páginas copiados a /public/:");
console.log("- setup-tokens.html");
console.log("- generar-tokens.html");
