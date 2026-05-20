# Changelog - Portal de Servicios Los Prados de Nos

Todas las mejoras y cambios importantes del proyecto están documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Versionado Semántico](https://semver.org/lang/es/).

---

## [1.2.1] - 2026-05-20

### 🔖 Checkpoint
- **Versión de seguridad** creada antes de reorganización completa del repositorio
- Todas las funcionalidades operativas
- Punto de recuperación para rollback si es necesario

---

## [1.2.0] - 2026-05-19

### ✨ Sistema RBAC Completo

#### Roles y Permisos
- Sistema Role-Based Access Control implementado en backend y frontend
- 5 roles por defecto: super_admin, administrador, delegado, supervisor, guardia
- 40+ permisos granulares por módulo (crear, leer, editar, eliminar)
- Soporte de wildcards: `*.*` (acceso total), `modulo.*` (módulo completo)
- Scoping de permisos: global, por plaza, por casa

#### UI de Gestión de Roles
- Panel de administración de roles y permisos con 4 tabs
- Matriz de permisos visualizada
- Sistema de auditoría completo
- Creación de roles personalizados

#### RBAC Frontend
- `rbac-helper.js` con verificación de permisos
- Filtrado automático de menú según permisos
- Ocultación de botones por permiso
- Funciones: `hasPermission()`, `hasRole()`, `hasMinLevel()`

### 🔧 Backend Actualizado
- 10 archivos de rutas refactorizados con permisos granulares
- Middleware `requirePermission(permission)` implementado
- Logging automático de acciones denegadas

### 🗃️ Base de Datos
- 5 nuevas tablas RBAC: roles, permissions, role_permissions, user_roles, permission_audit
- Migración 014: Estructura RBAC
- Migración 015: Fix seguridad Supabase
- Migración 016: Fix 31 funciones vulnerables a search_path injection

### 🔒 Seguridad
- Control de acceso granular por permiso
- Auditoría completa (quién, qué, cuándo, por qué)
- Fix de vulnerabilidades SQL search_path

---

## [1.1.0] - 2026-04-15

### ✨ Control de Acceso Vehicular
- Registro de entradas/salidas de vehículos
- Validación automática de morosidad (3+ meses)
- Bloqueo automático de acceso para morosos
- Historial y estadísticas

### ✨ Módulo de Pagos
- Gestión de cuota social y junta de vecinos
- Generación automática por período
- Cálculo de morosidad
- Reportes por plaza

### 🗃️ Base de Datos
- Nuevas tablas: vehiculos, control_acceso, pagos
- Vistas: v_vehiculos_completo, v_pagos_completo
- Funciones: verificar_acceso_vehiculo(), actualizar_estado_pagos_vencidos()

---

## [1.0.0] - 2026-01-29

### ✨ Lanzamiento Inicial

#### Portal de Check-in para Guardias
- Sistema QR con tokens únicos por plaza  
- Validación con código de 6 dígitos
- Registro de rondas con geolocalización

#### Módulo de Eventos Comunitarios
- CRUD completo con 8 tipos de eventos
- Inscripción y cancelación
- Integración con Google Calendar

#### Centro de Documentos
- Repositorio con 7 tipos de documentos
- Integración con Google Drive
- Auditoría de descargas

#### Módulo Residencial
- **Casas**: 19 plazas del condominio
- **Residentes**: RUN chileno validado, edad automática
- **Mascotas**: Galería pública para emergencias, control de vacunas

#### Panel de Administración
- Dashboard con estadísticas
- Gestión de guardias, plazas, administradores  
- Generación de tokens QR

### 🔧 Stack Tecnológico
- **Backend**: Node.js 18+, Express.js 4.18, PostgreSQL/Supabase
- **Frontend**: Bootstrap 5.3.0, Font Awesome 6.0, JavaScript ES6+ vanilla
- **Seguridad**: JWT, bcrypt, helmet, rate-limit

### 📱 Páginas (10 total)
- Públicas: index, eventos, documentos, mascotas-galería
- Autenticación: login guardias, admin-login
- Restringidas: checkin, admin-panel

### 🗃️ Base de Datos Core
- 15+ tablas principales
- 50+ endpoints API  
- 19 plazas configuradas

### 🌐 Compatibilidad
- Chrome 90+, Firefox 88+, Safari 14+, Edge 90+
- Responsive 320px - 1920px+

---

## Tipos de Cambios

- **✨ Características** - Nuevas funcionalidades
- **🔧 Cambios** - Modificaciones existentes
- **🐛 Correcciones** - Bug fixes
- **🔒 Seguridad** - Mejoras de seguridad
- **🗃️ Base de Datos** - Schema/migraciones
- **📚 Documentación** - Docs
- **🎨 Diseño** - Visual/UX
