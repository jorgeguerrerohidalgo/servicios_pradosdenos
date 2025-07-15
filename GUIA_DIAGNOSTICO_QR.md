# 🔧 Herramientas de Diagnóstico QR - Guía de Uso

## Resumen del Problema
El sistema reporta que todos los tokens están creados correctamente, pero la generación de QR falla con "Error generando QR". Hemos creado herramientas específicas para diagnosticar este problema.

## 🛠️ Herramientas Disponibles

### 1. **debug-qr.html** - Herramienta Principal de Diagnóstico
**URL**: http://localhost:3000/debug-qr.html

**Funciones:**
- ✅ **Probar Librería QR**: Verifica si la librería QRCode está cargada correctamente
- ✅ **Probar QR Estático**: Genera un QR con texto simple para verificar funcionalidad básica
- ✅ **Cargar Datos de Plazas**: Obtiene datos de la API y analiza tokens detalladamente
- ✅ **Probar Tokens Individuales**: Prueba cada token individualmente para identificar problemas específicos
- ✅ **Generar Todos los QR**: Intenta generar todos los QR y muestra resultados

### 2. **qr-plazas.html** - Página Principal (Mejorada)
**URL**: http://localhost:3000/qr-plazas.html

**Mejoras agregadas:**
- 🔍 Debugging detallado en consola
- 📊 Análisis de tokens (tipo, longitud, caracteres especiales)
- 🚨 Mejor manejo de errores con información específica
- 🔗 Botón directo al diagnóstico QR

### 3. **setup-tokens.html** - Configuración de Tokens
**URL**: http://localhost:3000/setup-tokens.html

**Funciones:**
- ✅ Generación masiva de tokens para todas las plazas
- ✅ Verificación de estado de configuración
- 🔗 Enlaces rápidos a diagnóstico QR

## 🔍 Pasos para Diagnosticar el Problema

### Paso 1: Verificar Librería QR
1. Abrir http://localhost:3000/debug-qr.html
2. Hacer clic en "1. Probar Librería QR"
3. Verificar que la librería QRCode esté disponible

### Paso 2: Probar QR Básico
1. Hacer clic en "2. Probar QR Estático"
2. Si falla aquí, el problema es con la librería QRCode
3. Si funciona, el problema está en los datos de tokens

### Paso 3: Analizar Tokens
1. Hacer clic en "3. Cargar Datos de Plazas"
2. Revisar el log para ver detalles de cada token:
   - Tipo de dato
   - Longitud
   - Caracteres especiales
   - Formato válido

### Paso 4: Probar Tokens Individuales
1. Hacer clic en "4. Probar Tokens Individuales"
2. Identificar qué tokens específicos están causando problemas
3. Revisar el log para errores específicos

### Paso 5: Generar Todos los QR
1. Hacer clic en "5. Generar Todos los QR"
2. Ver el resultado final y estadísticas

## 🚨 Posibles Causas del Error

### 1. **Problema con la Librería QRCode**
- La librería no está cargando correctamente
- Versión incompatible
- Error de CDN

### 2. **Problema con los Datos de Tokens**
- Tokens contienen caracteres especiales
- Tokens son null o undefined
- Tokens tienen formato incorrecto
- Tokens son demasiado largos

### 3. **Problema con el DOM/Canvas**
- Error en la creación del canvas
- Problema con el navegador
- Limitaciones de memoria

### 4. **Problema con la API**
- Datos corruptos en la base de datos
- Encoding incorrecto
- Respuesta malformada

## 📊 Información que Buscar en el Log

Cuando ejecutes las herramientas, busca:

```
✅ Librería QRCode disponible
✅ QR estático generado correctamente
✅ Datos cargados: X plazas
📊 Detalles del token:
  - plaza: "Plaza X"
  - token: "abc123..."
  - tokenType: "string"
  - tokenLength: 36
  - hasSpecialChars: false
```

## 🔧 Soluciones Rápidas

### Si la librería QRCode no carga:
1. Verificar conexión a internet
2. Probar con otro CDN
3. Usar versión local de la librería

### Si los tokens tienen problemas:
1. Regenerar tokens desde setup-tokens.html
2. Verificar la base de datos
3. Revisar el endpoint /api/plazas

### Si el problema persiste:
1. Revisar la consola del navegador (F12)
2. Verificar la pestaña Network para errores de carga
3. Probar en otro navegador

## 📋 Próximos Pasos

1. **Ejecutar diagnóstico completo** usando debug-qr.html
2. **Identificar el problema específico** basado en los resultados
3. **Aplicar la solución correspondiente**
4. **Verificar que la generación de QR funcione** en qr-plazas.html

## 🔗 Enlaces Rápidos

- [Diagnóstico QR](http://localhost:3000/debug-qr.html)
- [QR Plazas](http://localhost:3000/qr-plazas.html)
- [Setup Tokens](http://localhost:3000/setup-tokens.html)
- [Panel Admin](http://localhost:3000/admin-panel.html)

---

**Nota**: Asegúrate de tener el servidor corriendo (`node backend/server.js`) y de configurar las variables de entorno de la base de datos si necesitas acceso completo a los datos.
