# 📡 Documentación de API Endpoints

Documentación completa de todos los endpoints API del Portal de Servicios Los Prados de Nos.

## Índice de Módulos

1. [Autenticación](autenticacion.md) - Login, logout, verificación de sesión
2. [Check-in](checkin.md) - Sistema de rondas de guardias con QR
3. [Administración](admin.md) - Panel administrativo (guardias, plazas, admins, estadísticas)
4. [Residencial](residencial.md) - Casas, residentes, mascotas
5. [Financiero](financiero.md) - Pagos y morosidad
6. [Vehículos](vehiculos.md) - Vehículos y control de acceso
7. [Eventos](eventos.md) - Sistema de eventos comunitarios
8. [Documentos](documentos.md) - Centro de documentos
9. [Roles y Permisos](roles.md) - Sistema RBAC completo

---

## Convenciones Generales

### Autenticación

La mayoría de endpoints requieren autenticación mediante sesión:

```javascript
// Headers requeridos
{
  "Cookie": "connect.sid=..."  // Session cookie automática
}
```

### Autorización RBAC

Endpoints protegidos requieren permisos específicos:

```javascript
// Middleware en backend
requirePermission('modulo.accion')

// Ejemplos
requirePermission('guardias.crear')      // Crear guardias
requirePermission('casas.*')             // Acceso completo a casas
requirePermission('*.*')                 // Super admin
```

### Formato de Respuestas

#### Éxito (200, 201)
```json
{
  "success": true,
  "data": { ... },
  "message": "Operación exitosa"
}
```

#### Error (400, 401, 403, 404, 500)
```json
{
  "success": false,
  "error": "Mensaje de error descriptivo"
}
```

### Códigos de Estado HTTP

| Código | Significado |
|--------|-------------|
| 200 | OK - Solicitud exitosa |
| 201 | Created - Recurso creado |
| 400 | Bad Request - Datos inválidos |
| 401 | Unauthorized - No autenticado |
| 403 | Forbidden - Sin permisos |
| 404 | Not Found - Recurso no encontrado |
| 500 | Internal Server Error - Error del servidor |

### Paginación

Algunos endpoints soportan paginación:

```
GET /api/residentes?page=1&limit=20
```

**Respuesta:**
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "totalPages": 8
  }
}
```

### Filtros

Endpoints de listado soportan filtros mediante query parameters:

```
GET /api/casas?plaza_id=5&activo=true
GET /api/residentes?search=juan&casa_id=10
```

---

## Endpoints por Categoría

### Públicos (Sin Autenticación)
- `GET /api/mascotas/publico` - Galería pública de mascotas
- `GET /api/eventos/` - Lista de eventos
- `GET /api/eventos/:id` - Detalle de evento
- `GET /api/documentos/` - Lista de documentos
- `GET /api/documentos/:id` - Detalle de documento
- `GET /api/admin/plazas/activas` - Plazas activas

### Autenticados (Requieren Login)
Todos los demás endpoints requieren autenticación válida.

### Por Permiso
Ver documentación específica de cada módulo para permisos requeridos.

---

## Rate Limiting

Endpoints de autenticación tienen rate limiting configurado:

- **Login**: Máximo 5 intentos cada 15 minutos por IP
- **Otros endpoints**: 100 requests por minuto por IP

Cuando se excede el límite:
```json
{
  "error": "Too many requests, please try again later."
}
```

---

## CORS

El servidor permite requests desde:
- `http://localhost:*`
- `https://tu-dominio.com` (configurar en producción)

Headers permitidos:
- `Content-Type`
- `Authorization`

Métodos permitidos:
- `GET`, `POST`, `PUT`, `DELETE`, `OPTIONS`

---

## WebSockets

WebSockets NO están implementados actualmente. Todas las actualizaciones se realizan mediante polling o recargas manuales.

**Próximamente** (roadmap):
- Notificaciones en tiempo real
- Actualización automática de dashboard
- Chat interno entre residentes

---

## Versionado de API

Actualmente: **v1** (implícito, sin versión en URL)

Próximas versiones usarán prefijo:
```
/api/v2/...
```

---

## Changelog de API

### v1.2.0 (Mayo 2026)
- ✨ Añadido: Sistema RBAC con 12 endpoints en `/api/roles/*`
- ✨ Añadido: `/api/mascotas/publico` para galería pública
- 🔧 Modificado: Todos los endpoints admin con permisos granulares
- 🔒 Seguridad: 31 funciones SQL protegidas contra search_path injection

### v1.1.0 (Abril 2026)
- ✨ Añadido: Módulo de control de acceso vehicular
- ✨ Añadido: Sistema de pagos y morosidad
- 🔧 Modificado: Endpoints de vehículos con validación de morosidad

### v1.0.0 (Enero 2026)
- 🎉 Lanzamiento inicial con 9 módulos principales
- 50+ endpoints implementados
