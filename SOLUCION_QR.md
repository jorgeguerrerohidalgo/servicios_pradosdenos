# Solución para Error de Generación de Códigos QR

## Problema
La página `qr-plazas.html` muestra "Error generando QR" porque algunas plazas no tienen tokens QR asignados.

## Problema SQL Identificado
Error: `column "creado_en" of relation "plaza_tokens" does not exist`
- **Causa:** El SQL usaba `creado_en` pero la columna se llama `created_at`
- **Solución:** Corregir el SQL en ambos endpoints

## Solución Rápida

### ✅ Corrección SQL Aplicada
Se corrigió el SQL en:
- `backend/routes/public.routes.js` - Endpoint `/api/generate-tokens-temp`
- `backend/routes/admin.routes.js` - Endpoint `/api/admin/generate-tokens`

### Opción 1: Página de Configuración Inicial (Recomendada)
1. Abrir: `http://localhost:3000/setup-tokens.html`
2. Hacer clic en "Generar Tokens QR"
3. Esperar a que se complete el proceso
4. Ir a `qr-plazas.html` para generar los códigos QR

### Opción 2: Verificar Corrección SQL
1. Abrir: `http://localhost:3000/test-sql-fix.html`
2. Hacer clic en "Probar Generación de Tokens"
3. Verificar que no hay errores SQL

### Opción 3: Página de Administración
1. Abrir: `http://localhost:3000/generar-tokens.html`
2. Hacer clic en "Generar Tokens Faltantes"
3. Ir a `qr-plazas.html` para generar los códigos QR

## Estado Actual
Según el reporte del usuario:
- **Total plazas:** 22
- **Plazas con token:** 19
- **Plazas sin token:** 3

### Plazas que necesitan tokens:
- Plaza Barcelona (ID: 20)
- Plaza Parque Union Norte (ID: 21)
- Plaza Parque Union Sur (ID: 22)

## Endpoint Temporal
Se creó un endpoint temporal `/api/generate-tokens-temp` que:
- ✅ No requiere autenticación
- ✅ Genera tokens únicos para plazas sin token
- ✅ Proporciona feedback detallado
- ✅ **SQL CORREGIDO** - Usa `created_at` en lugar de `creado_en`
- ⚠️ Debe ser removido en producción por seguridad

## Flujo Completo
1. **Generar Tokens** → `setup-tokens.html`
2. **Generar QR** → `qr-plazas.html`
3. **Imprimir QR** → Botones de impresión individual o masiva
4. **Instalar QR** → Pegar códigos QR en las plazas físicas

## Archivos Modificados
- `backend/routes/public.routes.js` - Endpoint temporal (SQL corregido)
- `backend/routes/admin.routes.js` - Endpoint admin (SQL corregido)
- `public/setup-tokens.html` - Página de configuración inicial
- `public/generar-tokens.html` - Página de administración mejorada
- `public/qr-plazas.html` - Mejores mensajes de error y navegación
- `public/test-sql-fix.html` - Página de verificación SQL

## Nota de Seguridad
El endpoint `/api/generate-tokens-temp` es temporal y debe ser removido una vez completada la configuración inicial del sistema.
