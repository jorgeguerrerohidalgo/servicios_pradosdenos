# 🏢 Servicios Prados de Nos

Sistema de gestión de check-in para guardias de seguridad y administración de rondas.

## 🚀 Características Principales

- **Sistema de Check-in**: Registro de entrada y salida de guardias
- **Códigos QR**: Generación y validación de códigos QR para plazas
- **Panel de Administración**: Gestión de usuarios y consulta de rondas
- **Sistema de Autenticación**: Login seguro con roles diferenciados
- **Seguridad Avanzada**: Rate limiting, logs de seguridad, validaciones

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

### Reorganización del Proyecto (Diciembre 2024)
- ✅ **Estructura mejorada**: Archivos organizados siguiendo estándares de la industria
- ✅ **Documentación centralizada**: Nueva carpeta `docs/` con guías completas
- ✅ **Scripts organizados**: Separación clara entre scripts de BD y utilidades
- ✅ **Testing estructurado**: Archivos de prueba en carpeta dedicada

### Corrección de Enlaces y Páginas (Diciembre 2024)
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

### Para Administradores
- Acceder a `/admin-login.html`
- Consultar rondas desde `/admin-panel.html`

## 🔒 Seguridad

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
