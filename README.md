# 🏢 Portal de Vecinos - Los Prados de Nos

Portal comunitario integral para la gestión de check-in, eventos, documentos y mascotas de la comunidad Los Prados de Nos.

## 🎯 Versión Actual: v1.1 ✅

**Estado**: En Producción | **Última actualización**: Mayo 2026

## 🚀 Características Principales

### 🔐 Sistema de Check-in
- Registro de entrada y salida de guardias
- Códigos QR para plazas
- Control de acceso vehicular y peatonal
- Validación de placas y documentos

### � Sistema RBAC (Control de Acceso Basado en Roles)
- **5 Roles predefinidos**: Super Usuario, Administrador, Delegado de Plaza, Supervisor, Guardia
- **Gestión granular de permisos**: Control por módulo y acción (ver, crear, editar, eliminar)
- **Módulos Visibles**: Configuración personalizada de acceso por rol
- **Jerarquía de roles**: Niveles de prioridad con control de permisos heredables
- **Seguridad avanzada**: Middleware de autenticación y autorización en todas las rutas
- **Panel de administración**: Gestión visual de roles y permisos con checkboxes editables

### 🐾 Galería Pública de Mascotas
- **Acceso público**: Sin autenticación para emergencias (mascotas perdidas/encontradas)
- **Información completa**: Fotos, nombre, tipo, raza, género, color, edad, vacunas
- **Ubicación pública**: Plaza y dirección (sin revelar número de casa por privacidad)
- **Filtros avanzados**: Por tipo de mascota, plaza y búsqueda por nombre
- **Diseño responsive**: Galería de tarjetas adaptable a móviles y tablets
- **Modal de detalles**: Información completa con foto ampliada
- **Integración con Supabase**: Almacenamiento de fotos en la nube

### 📅 Gestión de Eventos
- Visualización de eventos comunitarios
- Filtros avanzados por tipo, fecha y ubicación
- Modales de detalle con información completa
- Sistema de inscripciones

### 📄 Centro de Documentos
- Repositorio de documentos oficiales
- Filtros por tipo y fecha de publicación
- Enlaces de descarga y visualización
- Gestión de versiones

### 🛡️ Panel de Administración
- Gestión de usuarios y roles con RBAC
- Asignación de permisos por módulo
- Consulta de rondas de seguridad
- Sistema de autenticación seguro
- Rate limiting y logs de seguridad

## 📁 Estructura del Proyecto

```
servicios_pradosdenos/
├── backend/                 # Servidor Node.js/Express
│   ├── controllers/         # Controladores de rutas
│   ├── middleware/          # Middleware de seguridad
│   ├── models/             # Modelos de datos
│   ├── routes/             # Definición de rutas
│   ├── utils/              # Utilidades y conexión DB
│   └── server.js           # Servidor principal
├── public/                 # Archivos estáticos (HTML, CSS, JS)
├── docs/                   # Documentación del proyecto
│   ├── deployment/         # Guías de despliegue
│   ├── development/        # Documentación de desarrollo
│   └── troubleshooting/    # Solución de problemas
├── scripts/                # Scripts de utilidad
│   ├── database/           # Scripts SQL
│   └── utilities/          # Scripts de Node.js
└── testing/                # Archivos de prueba y debugging
    ├── debug/              # Scripts de debugging
    ├── html/               # Páginas de testing
    └── old-versions/       # Versiones anteriores
```

## 🔧 Instalación y Configuración

### Prerrequisitos
- Node.js >= 14.0.0
- PostgreSQL >= 12.0
- npm o yarn

### Instalación
1. Clonar el repositorio
2. Instalar dependencias: `npm install`
3. Configurar variables de entorno (ver `.env.example`)
4. Ejecutar scripts de base de datos (ver `scripts/database/`)
5. Iniciar el servidor: `npm start`

## 🆕 Últimas Actualizaciones

### Sistema RBAC y Galería de Mascotas (Mayo 2026) 🎉
- ✅ **RBAC completo implementado**:
  - Control de acceso basado en roles (5 roles predefinidos)
  - Gestión granular de permisos por módulo y acción
  - Middleware de autenticación y autorización
  - Panel visual de gestión de roles y permisos
  - Configuración de "Módulos Visibles" por rol
  - Sistema de jerarquía de roles con niveles de prioridad
  
- ✅ **Galería Pública de Mascotas**:
  - Endpoint público `/mascotas.html` sin autenticación
  - Backend `/api/mascotas/publico` optimizado con JOINs
  - Filtros por tipo, plaza y búsqueda por nombre
  - Diseño responsive con Bootstrap 5
  - Modal de detalles con información completa
  - Protección de privacidad (muestra plaza y dirección, no número de casa)
  - Integración con Supabase Storage para fotos
  - Estados de vacunación (al día, vencida, sin información)

- ✅ **Correcciones de seguridad y UX**:
  - Roles no críticos (Delegado, Supervisor, Guardia) ahora editables
  - Manejo de valores NULL en queries PostgreSQL
  - Logging detallado para debugging en producción
  - Validación de strings vacíos con trim()

### ReorgVecinos (Público)
- Ver galería de mascotas: `/mascotas.html` (sin login requerido)
- Ver eventos comunitarios: `/eventos.html`
- Ver documentos: `/documentos.html`

### Para Guardias
- Acceder a `/guardia-login.html`
- Realizar check-in desde `/guardia-checkin.html`

### Para Administradores
- Acceder a `/admin-login.html`
- Panel de administración: `/admin-panel.html`
- Gestión de roles y permisos (pestaña "Roles y Permisos")
- Configuración de módulos visibles (pestaña "Módulos Visibles")re 2024)
- ✅ **Enlaces reparados**: Diagnóstico y Verificación funcionando correctamente
- ✅ **Páginas robustas**: Manejo de errores mejorado en herramientas de diagnóstico
- ✅ **Múltiples versiones**: Soporte para versiones simple y original de diagnósticos

### Solución de Tokens QR (Diciembre 2024)
- 🔧 **Problema identificado**: Tokens QR inconsistentes en producción
- ✅ **Script de corrección**: Generado script automático para corregir tokens
- ✅ **Páginas restauradas**: `setup-tokens.html` y `generar-tokens.html` disponibles
- 🔧 **Pendiente**: Aplicar correcciones en base de datos de producción

#### Problema de Tokens QR
**Estado**: En solución
**Descripción**: Plaza Avellino tenía token incorrecto (`qr-plaza-castellon-2025`)
**Solución**: Script SQL y JS generados en `scripts/utilities/corregir-tokens-qr.js`
**Documentación**: Ver `docs/troubleshooting/solucion-tokens-qr.md`

## 🌐 Uso

### Para Guardias
- Acceder a `/guardia-login.html`
- Realizar check-in desde `/guardia-checkin.html`

##**RBAC (Role-Based Access Control)**: Control de acceso granular por roles y permisos
- **Middleware de autorización**: Validación de permisos en cada endpoint
- **Jerarquía de roles**: Sistema de niveles de prioridad
- Autenticación basada en sesiones con JWT
- Rate limiting para prevenir ataques
- Validación de entrada de datos
- Logs de seguridad detallados
- Headers de seguridad (helmet.js)
- Protección CSRF
- Separación de endpoints públicos y privados
El sistema incluye:
- Autenticación basada en sesiones
- Rate limiting para prevenir ataques
- Validación de entrada de datos
- Logs de seguridad
- Headers de seguridad (helmet.js)
- Protección CSRF

## 📖 Documentación

Consultar la carpeta `/docs` para:
- Guías de despliegue
- Documentación de desarrollo
- Solución de problemas

## 🧪 Testing

Los archivos de testing están en `/testing`:
- Scripts de debugging
- Páginas de prueba
- Versiones de desarrollo

## 📄 Licencia

Este proyecto es de uso interno para Servicios Prados de Nos.
