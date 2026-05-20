# Changelog - Portal de Servicios Los Prados de Nos

Todas las mejoras y cambios importantes del proyecto están documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Versionado Semántico](https://semver.org/lang/es/).

---

## [2.0.1] - 2026-05-20

### ✨ Mantenedores Vehiculares Normalizados

#### Nueva Funcionalidad
- Sistema completo de mantenedores para Tipo/Marca/Modelo de vehículos
- Datos reales del mercado automotriz chileno precargados
- Dropdowns en cascada inteligente (Tipo → Marca → Modelo)
- 100% compatible con registros legacy (campos texto libre mantenidos)

#### Base de Datos
- **Migración 017**: Creación de 3 tablas nuevas
  - `tipo_vehiculo` (12 registros): Automóvil, Camioneta, SUV, Motocicleta, etc.
  - `marca_vehiculo` (45 registros): Marcas comercializadas en Chile
  - `modelo_vehiculo` (180+ registros): Modelos populares por marca
- FKs agregadas a tabla `vehiculos` (nullable para compatibilidad)
- Índices optimizados para consultas rápidas

#### API Endpoints (Públicos)
- `GET /api/vehiculos/tipos` - Listar tipos activos
- `GET /api/vehiculos/marcas?tipo_id={id}` - Listar marcas (filtrable)
- `GET /api/vehiculos/marcas/:id/modelos?tipo_id={id}` - Modelos por marca
- `GET /api/vehiculos/modelos/:id` - Detalles de modelo específico
- `GET /api/vehiculos/search-modelo?q={query}` - Búsqueda autocompletada

#### Frontend Mejorado
- Formulario con dropdowns en cascada en admin-panel.html
- Funciones `onVehiculoTipoChange()`, `onVehiculoMarcaChange()`
- UX mejorada con iconos Font Awesome por tipo de vehículo
- Validaciones de datos normalizados

#### Backend Actualizado
- Rutas POST/PUT de vehículos soportan campos legacy y nuevos mantenedores
- Validación dual: acepta IDs de mantenedores o texto libre
- Error handling mejorado para FKs inválidas

#### Seeds y Datos
- **seed_tipo_vehiculo.sql**: 12 tipos más comunes en Chile
- **seed_marca_vehiculo.sql**: 45 marcas organizadas por país de origen
- **seed_modelo_vehiculo.sql**: 180+ modelos (Toyota: 12, Chevrolet: 10, etc.)
- Datos basados en mercado real chileno (fuente: chileautos.cl)

#### Instalación
- Script automatizado: `install-vehicle-maintainers.js`
- Conecta a Supabase usando credenciales de `.env`
- Verificación automática de tablas existentes
- Resumen visual de datos cargados

#### Documentación
- **README_MANTENEDORES_VEHICULOS.md**: Guía técnica completa
  - Arquitectura y estructura de datos
  - 3 opciones de instalación (Node.js script, Panel Supabase, CLI)
  - Ejemplos de uso de API
  - Troubleshooting y FAQ
  - Guía de mantenimiento y expansión

### 🔧 Refactoring
- Archivo redundante `vehicleMaintainers.js` reemplazado por integración en `vehiculos.routes.js`
- Rutas públicas de mantenedores posicionadas ANTES de middleware de autenticación
- Scripts obsoletos de PostgreSQL local eliminados (.bat/.sh)

### 🎯 Beneficios
- ✅ Datos normalizados: Elimina errores de ortografía ("toyota" vs "Toyota")
- ✅ UX mejorada: Dropdowns más rápidos que escribir manualmente
- ✅ Calidad de datos: 100% consistencia en nombres de marcas/modelos
- ✅ Reportes precisos: Agrupaciones confiables por marca/tipo
- ✅ Escalabilidad: Fácil agregar nuevas marcas/modelos sin tocar código

---

## [2.0.0] - 2026-05-20

### 🗂️ Reorganización Completa del Repositorio

#### Estructura Profesional
- Creado directorio `archive/` con 7 subdirectorios organizados
- 166 archivos movidos a archive (scripts diagnóstico, testing, deployment)
- 20 archivos eliminados (corruptos, duplicados, históricos consolidados)
- Estructura limpia y profesional lista para producción

#### Documentación Mejorada
- **README.md**: Reescrito completo (350+ líneas)
  - Badges de versión y stack tecnológico
  - TOC navegable con 11 secciones
  - Tablas comparativas de tecnologías
  - Guías de deployment (Render/Docker/Manual)
  - Sección de seguridad y testing
- **CHANGELOG.md**: Consolidado de 12 archivos históricos
  - Formato Keep a Changelog
  - Historial completo v1.0.0 → v1.2.1
- **docs/api/README.md**: Documentación de API creada
  - Convenciones de endpoints
  - Formatos de respuesta
  - Rate limiting y CORS

#### Base de Datos Organizada
- SQL schemas movidos a `database/migrations/`
- Scripts de seed documentados en `database/seeds/`
- 4 variantes de schema base mantenidas
- 29 migraciones organizadas en `scripts/database/`

#### Archivado Inteligente
- `archive/diagnostics/backend/` - 35+ scripts de diagnóstico
- `archive/diagnostics/backend/setup/` - 23 scripts de setup
- `archive/diagnostics/frontend/` - 13 HTML de debug
- `archive/testing/` - 22 scripts de testing
- `archive/testing/qr/` - 18 archivos de debug QR
- `archive/testing/data/` - CSV y SQL de prueba
- `archive/deployment-scripts/` - 16 archivos .bat (Windows)
- `archive/nuevos-modulos/` - Carpeta duplicada completa

#### Configuración
- `.gitignore` actualizado con patrones proyecto-específicos
- Previene commit de archivos temporales y diagnósticos
- Protección contra re-agregar archivos archivados

#### Validación
- 0 errores de sintaxis tras reorganización
- 25 rutas backend verificadas intactas
- 17 páginas frontend HTML funcionando
- 29 migraciones SQL validadas

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
