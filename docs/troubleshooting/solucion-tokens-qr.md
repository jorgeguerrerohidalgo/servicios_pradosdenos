# Solución para Tokens QR Inconsistentes

## Problema Identificado

En la página de producción `https://servicios-prados-de-nos.onrender.com/qr-plazas.html`, se detectaron las siguientes inconsistencias:

- **Plaza Avellino** tenía el token `qr-plaza-castellon-2025` (incorrecto)
- La página `setup-tokens.html` no estaba disponible en producción
- Los códigos QR no coincidían con los nombres reales de las plazas

## Solución Implementada

### 1. Archivos Copiados a Producción
Se copiaron las páginas faltantes desde `testing/html/` a `public/`:
- `setup-tokens.html` → `public/setup-tokens.html`
- `generar-tokens.html` → `public/generar-tokens.html`

### 2. Script de Corrección Generado
Se creó `scripts/utilities/corregir-tokens-qr.js` que genera:

#### Script SQL para Corregir Tokens
```sql
-- Script para corregir tokens QR de plazas
BEGIN;
UPDATE plazas SET token = 'qr-plaza-avellino-2025' WHERE nombre = 'Plaza Avellino';
UPDATE plazas SET token = 'qr-plaza-castellon-2025' WHERE nombre = 'Plaza Castellón';
UPDATE plazas SET token = 'qr-plaza-los-alamos-2025' WHERE nombre = 'Plaza Los Álamos';
UPDATE plazas SET token = 'qr-plaza-central-2025' WHERE nombre = 'Plaza Central';
UPDATE plazas SET token = 'qr-plaza-norte-2025' WHERE nombre = 'Plaza Norte';
UPDATE plazas SET token = 'qr-plaza-sur-2025' WHERE nombre = 'Plaza Sur';
UPDATE plazas SET token = 'qr-plaza-este-2025' WHERE nombre = 'Plaza Este';
UPDATE plazas SET token = 'qr-plaza-oeste-2025' WHERE nombre = 'Plaza Oeste';
COMMIT;
```

#### Script JavaScript para Verificación
```javascript
// Ejecutar en la consola del navegador en qr-plazas.html
async function verificarTokens() {
    try {
        const response = await fetch('/api/plazas');
        const plazas = await response.json();
        
        const tokensEsperados = {
            'Plaza Avellino': 'qr-plaza-avellino-2025',
            'Plaza Castellón': 'qr-plaza-castellon-2025',
            'Plaza Los Álamos': 'qr-plaza-los-alamos-2025',
            'Plaza Central': 'qr-plaza-central-2025',
            'Plaza Norte': 'qr-plaza-norte-2025',
            'Plaza Sur': 'qr-plaza-sur-2025',
            'Plaza Este': 'qr-plaza-este-2025',
            'Plaza Oeste': 'qr-plaza-oeste-2025',
        };
        
        let errores = 0;
        for (const plaza of plazas) {
            const tokenEsperado = tokensEsperados[plaza.nombre];
            const tokenActual = plaza.token;
            
            if (tokenEsperado) {
                if (tokenActual === tokenEsperado) {
                    console.log(`✅ ${plaza.nombre}: Token correcto (${tokenActual})`);
                } else {
                    console.error(`❌ ${plaza.nombre}:`);
                    console.error(`   Esperado: ${tokenEsperado}`);
                    console.error(`   Actual:   ${tokenActual}`);
                    errores++;
                }
            }
        }
        
        console.log(`\n=== RESUMEN ===`);
        console.log(`Errores encontrados: ${errores}`);
        
        if (errores > 0) {
            console.log('🔧 Para corregir los tokens, ejecute el script SQL de actualización.');
        } else {
            console.log('🎉 Todos los tokens están correctos!');
        }
    } catch (error) {
        console.error('Error verificando tokens:', error);
    }
}

verificarTokens();
```

## Pasos para Aplicar la Solución

### En Base de Datos
1. Acceder a la consola de base de datos de producción
2. Ejecutar el script SQL generado
3. Verificar que las actualizaciones se aplicaron correctamente

### En el Navegador
1. Abrir `https://servicios-prados-de-nos.onrender.com/qr-plazas.html`
2. Abrir la consola del navegador (F12)
3. Copiar y pegar el script JavaScript de verificación
4. Verificar que todos los tokens sean correctos

### Verificación Final
1. Confirmar que `setup-tokens.html` es accesible en producción
2. Verificar que los códigos QR se generen correctamente
3. Comprobar que cada plaza tiene su token correcto

## Tokens Correctos Esperados

| Plaza | Token Correcto |
|-------|----------------|
| Plaza Avellino | qr-plaza-avellino-2025 |
| Plaza Castellón | qr-plaza-castellon-2025 |
| Plaza Los Álamos | qr-plaza-los-alamos-2025 |
| Plaza Central | qr-plaza-central-2025 |
| Plaza Norte | qr-plaza-norte-2025 |
| Plaza Sur | qr-plaza-sur-2025 |
| Plaza Este | qr-plaza-este-2025 |
| Plaza Oeste | qr-plaza-oeste-2025 |

## Estado del Proyecto

- ✅ Archivos faltantes copiados a producción
- ✅ Script de corrección generado
- ✅ Scripts SQL y JavaScript listos para usar
- 🔧 **Pendiente**: Ejecutar script SQL en base de datos
- 🔧 **Pendiente**: Verificar tokens en producción

## Notas Importantes

- El script genera automáticamente los tokens basados en los nombres de las plazas
- Se mantiene la estructura `qr-plaza-{nombre}-2025` para consistencia
- Los nombres se normalizan eliminando espacios y caracteres especiales
- La verificación incluye manejo de errores robusto

## Archivos Relacionados

- `scripts/utilities/corregir-tokens-qr.js` - Script generador
- `public/setup-tokens.html` - Página de configuración
- `public/generar-tokens.html` - Página de generación
- `public/qr-plazas.html` - Página principal de QR
