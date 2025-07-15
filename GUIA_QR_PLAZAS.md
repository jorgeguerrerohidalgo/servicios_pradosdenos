# 🔗 Guía de Vinculación QR-Plaza

## Cómo funciona el sistema de códigos QR para plazas

### 📋 Estructura del Sistema

El sistema ya está completamente configurado para vincular códigos QR únicos con cada plaza. Aquí te explico cómo funciona:

## 🗃️ Base de Datos

### 1. Tabla `plazas`
```sql
plazas:
- id (identificador único)
- nombre (ej: "Plaza La Coruña")
- direccion (ej: "Condominio Los Prados de Nos")
- descripcion (ej: "Plaza de vigilancia y seguridad")
- activo (TRUE/FALSE)
```

### 2. Tabla `plaza_tokens`
```sql
plaza_tokens:
- id (identificador único)
- plaza_id (referencia a plazas.id)
- token (código QR único, ej: "qr-plaza-la-coruna-2025")
```

### 3. Tabla `guardias`
```sql
guardias:
- id (identificador único)
- nombre (ej: "Carlos Mendoza Torres")
- email (ej: "carlos.mendoza@pradosdenos.com")
- validation_code (código personal, ej: "1001")
```

## 🔄 Flujo del Check-in

### Paso 1: Generación de QR
1. **Cada plaza tiene un token único**: `qr-plaza-la-coruna-2025`
2. **El QR contiene este token**: Cuando se escanea, devuelve el string del token
3. **El sistema busca la plaza**: Usa el token para identificar qué plaza es

### Paso 2: Proceso del Guardia
1. **Guardia escanea QR** → El escáner lee: `qr-plaza-la-coruna-2025`
2. **Sistema valida token** → Busca en `plaza_tokens` y encuentra `plaza_id = 1`
3. **Sistema muestra plaza** → "Plaza La Coruña"
4. **Guardia ingresa código** → Su código personal (ej: "1001")
5. **Sistema valida código** → Verifica que coincida con `guardias.validation_code`
6. **Check-in exitoso** → Registra en `checkins(guardia_id, plaza_id, fecha)`

## 📱 Implementación Práctica

### 1. Generar QR Físicos
Visita: `/qr-plazas.html`
- **Obtiene plazas desde la API**: `/api/plazas`
- **Genera QR con token único**: Cada plaza tiene su QR
- **Permite imprimir**: Individual o todos juntos
- **Permite descargar**: Archivos PNG individuales

### 2. Colocar QR en Plazas
```
📋 Instrucciones para instalar:
1. Imprimir QR de cada plaza
2. Plastificar para proteger del clima
3. Instalar en lugar visible en cada plaza
4. Incluir instrucciones para guardias
```

### 3. Capacitar Guardias
```
📋 Instrucciones para guardias:
1. Abrir la app de check-in
2. Escanear QR de la plaza
3. Verificar que aparezca el nombre correcto
4. Ingresar su código personal (4 dígitos)
5. Confirmar check-in
```

## 🔧 Configuración Técnica

### 1. Tokens QR Actuales
```javascript
Plaza 1: "qr-plaza-la-coruna-2025"
Plaza 2: "qr-plaza-valencia-2025"
Plaza 3: "qr-plaza-marbella-2025"
// ... y así sucesivamente
```

### 2. Códigos de Validación
```javascript
Guardia 1: "1001"
Guardia 2: "2002"
Guardia 3: "3003"
Guardia 4: "4004"
```

### 3. API Endpoints
```javascript
GET /api/plazas          → Obtener todas las plazas con tokens
GET /api/plazas/simple   → Obtener solo nombres (para dropdown)
POST /api/checkin        → Registrar check-in (token + código)
```

## 🚀 Alternativas de Vinculación

### Opción 1: Tokens Simples (Actual)
```
QR contiene: "qr-plaza-la-coruna-2025"
✅ Pros: Simple, seguro, funciona offline
❌ Contras: Requiere base de datos para resolver
```

### Opción 2: URLs Completas
```
QR contiene: "https://tu-dominio.com/checkin?plaza=1"
✅ Pros: Directo, no requiere resolución
❌ Contras: Más complejo, requiere conexión
```

### Opción 3: JSON Completo
```
QR contiene: {"plaza_id": 1, "nombre": "Plaza La Coruña"}
✅ Pros: Toda la info en el QR
❌ Contras: QR más complejo, difícil de leer
```

## 🎯 Recomendación

**El sistema actual (Opción 1) es la mejor opción porque:**

1. **Seguridad**: Los tokens son únicos y no revelan información sensible
2. **Simplicidad**: Fácil de generar, imprimir y mantener
3. **Flexibilidad**: Permite cambiar nombres de plazas sin cambiar QR
4. **Offline**: El guardia puede escanear sin conexión inicial
5. **Validación**: Sistema de doble validación (QR + código personal)

## 🔧 Mantenimiento

### Para Agregar Nueva Plaza:
1. Insertar en tabla `plazas`
2. Generar token único en `plaza_tokens`
3. Regenerar QR desde `/qr-plazas.html`
4. Imprimir e instalar

### Para Cambiar Token:
1. Actualizar `plaza_tokens.token`
2. Regenerar QR
3. Reemplazar QR físico

### Para Agregar Guardia:
1. Insertar en tabla `guardias`
2. Generar `validation_code` único
3. Capacitar al guardia con su código

## 🎉 Resultado Final

**Sistema completamente funcional con:**
- ✅ 19 plazas con tokens QR únicos
- ✅ 4 guardias con códigos de validación
- ✅ Página para generar QR físicos
- ✅ Sistema de check-in con doble validación
- ✅ Consulta pública de rondas
- ✅ Panel de administración completo

**¡El sistema está listo para usar!** 🚀
