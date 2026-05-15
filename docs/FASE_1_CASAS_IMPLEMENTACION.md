# FASE 1: Módulo CASAS - Implementación Completa ✅

## 📋 Resumen de Implementación

Se ha completado la **Fase 1: Módulo CASAS** del sistema de gestión residencial para Los Prados de Nos.

### Archivos Creados

1. **Migración SQL**
   - `scripts/database/001_create_casas.sql`
   - Tabla `casas` con todos los campos requeridos
   - Vista `v_casas_completo` para consultas optimizadas
   - Trigger para actualizar `updated_at` automáticamente
   - Índices para rendimiento óptimo

2. **Backend API**
   - `backend/routes/casas.routes.js`
   - Endpoints CRUD completos (`GET`, `POST`, `PUT`, `DELETE`)
   - Validaciones robustas
   - Middleware de autenticación (`requireAuthAdmin`)

### Archivos Modificados

1. **backend/server.js**
   - Importación de rutas de casas
   - Montaje de rutas en `/api/casas`

2. **public/admin-panel.html**
   - Nav-link "Casas" en sidebar
   - Sección completa con tabla y filtros
   - Modal para crear/editar casas
   - Funciones JavaScript: `loadCasas()`, `showCasaForm()`, `saveCasa()`, `deleteCasa()`

---

## 🚀 Pasos de Verificación

### 1. Ejecutar Migración SQL

**Opción A: Usando cliente PostgreSQL (psql)**
```bash
psql -U postgres -d nombre_base_datos -f scripts/database/001_create_casas.sql
```

**Opción B: Usando cliente GUI (pgAdmin, DBeaver, etc.)**
- Abrir `scripts/database/001_create_casas.sql`
- Ejecutar el script completo en la base de datos

**Verificar tabla creada:**
```sql
-- Verificar estructura
\d casas

-- Verificar vista
SELECT * FROM v_casas_completo LIMIT 5;

-- Verificar índices
SELECT tablename, indexname FROM pg_indexes WHERE tablename = 'casas';
```

### 2. Iniciar Servidor

```bash
cd backend
npm install   # Si es primera vez
npm run dev   # Modo desarrollo con nodemon
# o
npm start     # Modo producción
```

**Verificar salida del servidor:**
```
Server running on port 3000
Database connection: PostgreSQL
Routes mounted:
  - /api/auth
  - /api/checkin
  - /api/admin
  - /api/eventos
  - /api/documentos
  - /api/casas  ✅ (NUEVO)
```

### 3. Probar Endpoints API

**A. Verificar autenticación (necesario antes de probar)**
```bash
# Login como admin
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "jorgeguerrerohidalgo@gmail.com",
    "password": "tu_password"
  }'
```

**B. Listar casas (requiere sesión activa)**
```bash
curl http://localhost:3000/api/casas \
  -H "Cookie: checkin.sid=TU_SESSION_ID" \
  --cookie-jar cookies.txt
```

**C. Crear casa de prueba**
```bash
curl -X POST http://localhost:3000/api/casas \
  -H "Content-Type: application/json" \
  -H "Cookie: checkin.sid=TU_SESSION_ID" \
  -d '{
    "numero_casa": "001-TEST",
    "direccion": "Calle Test #123",
    "plaza_id": 1,
    "monto_cuota_social": 25000,
    "monto_junta_vecinos": 5000,
    "metros_cuadrados": 120.5,
    "observaciones": "Casa de prueba"
  }'
```

**Respuesta esperada:**
```json
{
  "success": true,
  "message": "Casa creada exitosamente",
  "data": {
    "id": 1,
    "numero_casa": "001-TEST",
    "direccion": "Calle Test #123",
    "plaza_id": 1,
    "monto_cuota_social": 25000,
    "monto_junta_vecinos": 5000,
    "monto_total_mensual": 30000,
    "metros_cuadrados": 120.5,
    "observaciones": "Casa de prueba",
    "activo": true,
    "created_at": "2026-05-14T...",
    "updated_at": "2026-05-14T..."
  }
}
```

### 4. Probar Interfaz Web

1. **Acceder al panel de administración:**
   - URL: `http://localhost:3000/admin-panel.html`
   - Login como admin

2. **Verificar navegación:**
   - En el sidebar, debe aparecer el link "Casas" con ícono 🏠
   - Click en "Casas" → debe mostrar sección completa

3. **Verificar funcionalidades:**
   - ✅ **Filtros**: Cambiar filtro por plaza y estado
   - ✅ **Crear**: Click en "Nueva Casa" → Modal se abre
   - ✅ **Formulario**: Llenar todos los campos
   - ✅ **Cálculo automático**: Montos se suman en "Total Mensual"
   - ✅ **Guardar**: Submit → Casa aparece en tabla
   - ✅ **Editar**: Click en ícono editar → Modal pre-lleno
   - ✅ **Eliminar**: Click en ícono eliminar → Confirmación → Soft delete

### 5. Verificar Validaciones

**A. Validación: Número de casa duplicado**
```bash
# Intentar crear otra casa con mismo número
curl -X POST http://localhost:3000/api/casas \
  -H "Content-Type: application/json" \
  -H "Cookie: checkin.sid=TU_SESSION_ID" \
  -d '{
    "numero_casa": "001-TEST",
    "direccion": "Otra direccion",
    "plaza_id": 2,
    "monto_cuota_social": 20000,
    "monto_junta_vecinos": 5000
  }'
```
**Esperado:** Error 400 con mensaje "Ya existe una casa con este número"

**B. Validación: Plaza inexistente**
```bash
curl -X POST http://localhost:3000/api/casas \
  -H "Content-Type: application/json" \
  -H "Cookie: checkin.sid=TU_SESSION_ID" \
  -d '{
    "numero_casa": "999",
    "direccion": "Test",
    "plaza_id": 9999,
    "monto_cuota_social": 10000,
    "monto_junta_vecinos": 5000
  }'
```
**Esperado:** Error 400 con mensaje "La plaza especificada no existe"

**C. Validación: Montos negativos**
```bash
curl -X POST http://localhost:3000/api/casas \
  -H "Content-Type: application/json" \
  -H "Cookie: checkin.sid=TU_SESSION_ID" \
  -d '{
    "numero_casa": "888",
    "direccion": "Test",
    "plaza_id": 1,
    "monto_cuota_social": -5000,
    "monto_junta_vecinos": 5000
  }'
```
**Esperado:** Error 400 con mensaje "Los montos deben ser valores positivos"

---

## 🔍 Checklist de Verificación Completa

### Base de Datos
- [ ] Tabla `casas` creada con todos los campos
- [ ] Índices creados correctamente
- [ ] Vista `v_casas_completo` funcional
- [ ] Trigger `update_casas_updated_at` funciona
- [ ] Constraints de validación activos

### Backend API
- [ ] GET `/api/casas` retorna array de casas
- [ ] GET `/api/casas/:id` retorna casa específica
- [ ] GET `/api/casas/simple` retorna lista simplificada
- [ ] POST `/api/casas` crea nueva casa
- [ ] PUT `/api/casas/:id` actualiza casa existente
- [ ] DELETE `/api/casas/:id` realiza soft delete
- [ ] Validación de campos requeridos funciona
- [ ] Validación de duplicados funciona
- [ ] Validación de montos funciona
- [ ] Middleware de autenticación activo

### Frontend
- [ ] Nav-link "Casas" visible en sidebar
- [ ] Sección de casas se muestra al hacer click
- [ ] Tabla muestra todas las casas correctamente
- [ ] Filtros por plaza funcionan
- [ ] Filtros por estado funcionan
- [ ] Modal de crear casa se abre
- [ ] Modal de editar casa pre-llena datos
- [ ] Cálculo automático de total funciona
- [ ] Guardar nueva casa funciona
- [ ] Actualizar casa funciona
- [ ] Eliminar casa funciona (con confirmación)
- [ ] SweetAlert2 muestra notificaciones correctas

### Integración
- [ ] Contador de casas en dashboard actualizado
- [ ] Relación con tabla `plazas` funcional
- [ ] Preparado para fase 2 (residentes con FK a casas)
- [ ] No hay errores 404 o 500 en consola

---

## 📊 Consultas SQL Útiles

### Ver todas las casas con su plaza
```sql
SELECT * FROM v_casas_completo WHERE activo = true;
```

### Casas por plaza
```sql
SELECT p.nombre as plaza, COUNT(c.id) as total_casas
FROM plazas p
LEFT JOIN casas c ON p.id = c.plaza_id AND c.activo = true
GROUP BY p.nombre
ORDER BY total_casas DESC;
```

### Montos totales mensuales
```sql
SELECT 
  SUM(monto_cuota_social) as total_cuota_social,
  SUM(monto_junta_vecinos) as total_junta_vecinos,
  SUM(monto_cuota_social + monto_junta_vecinos) as total_mensual,
  COUNT(*) as total_casas
FROM casas 
WHERE activo = true;
```

### Casas con montos mayores al promedio
```sql
SELECT numero_casa, direccion, 
       (monto_cuota_social + monto_junta_vecinos) as total_mensual
FROM casas
WHERE (monto_cuota_social + monto_junta_vecinos) > (
  SELECT AVG(monto_cuota_social + monto_junta_vecinos) FROM casas WHERE activo = true
)
AND activo = true
ORDER BY total_mensual DESC;
```

---

## 🐛 Troubleshooting

### Error: "Cannot read property 'pool' of undefined"
**Causa:** Problema con importación de db.js
**Solución:** Verificar que `backend/utils/db.js` existe y exporta `pool` correctamente

### Error: "ECONNREFUSED" al conectar a base de datos
**Causa:** PostgreSQL no está corriendo o credenciales incorrectas
**Solución:** 
- Verificar PostgreSQL activo: `sudo systemctl status postgresql`
- Verificar `.env` con credenciales correctas
- Verificar `DATABASE_URL` en variables de entorno

### Error: "Session not found" al probar endpoints
**Causa:** Cookie de sesión no se está enviando
**Solución:**
- Usar `--cookie-jar` y `--cookie` en curl
- En Postman/Insomnia, habilitar cookies
- En navegador, primero hacer login

### Modal no se abre
**Causa:** Bootstrap 5 no cargado correctamente
**Solución:**
- Verificar en consola del navegador errores de JS
- Verificar que Bootstrap CDN esté accesible
- Limpiar caché del navegador

---

## 🎯 Próximos Pasos

Con la Fase 1 completada, el sistema ahora puede:
- ✅ Registrar casas del condominio
- ✅ Asociar casas a plazas existentes
- ✅ Configurar montos de cuota mensual por casa
- ✅ Gestionar casas desde panel de administración

**Preparado para Fase 2: Módulo RESIDENTES**
- La tabla `casas` está lista para recibir FK desde tabla `residentes`
- El campo `total_residentes` en la vista ya está preparado
- El endpoint `GET /api/casas/:id/estadisticas` ya consulta residentes (retorna 0 si no existe la tabla aún)

---

## 📝 Notas Técnicas

- **Soft Delete**: Las casas no se eliminan físicamente, solo se marcan como `activo = false`
- **Zona Horaria**: Todos los timestamps usan `America/Santiago`
- **Seguridad**: Todas las rutas requieren autenticación de administrador
- **Performance**: Índices compuestos optimizan queries frecuentes
- **Validación**: Client-side (JS) + Server-side (Node) + Database-side (Constraints)

---

**Fecha de implementación:** 14 de mayo de 2026  
**Desarrollador:** Sistema IA Assistant  
**Estado:** ✅ COMPLETADO Y LISTO PARA PRUEBAS
