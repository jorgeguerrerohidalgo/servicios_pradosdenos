# 🏘️ Portal de Servicios Los Prados de Nos

[![Versión](https://img.shields.io/badge/versión-2.0.1-blue.svg)](CHANGELOG.md)
[![Estado](https://img.shields.io/badge/estado-producción-success.svg)](#)
[![Node](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen.svg)](https://nodejs.org)
[![PostgreSQL](https://img.shields.io/badge/postgresql-%3E%3D12.0-blue.svg)](https://www.postgresql.org)
[![License](https://img.shields.io/badge/license-Propietaria-red.svg)](#)

**Portal comunitario integral** para la gestión de residentes, eventos, documentos, control de acceso y servicios del condominio Los Prados de Nos.

---

## 📑 Tabla de Contenidos

- [Características](#-características-principales)
- [Stack Tecnológico](#-stack-tecnológico)
- [Instalación Rápida](#-instalación-rápida)
- [Módulos](#-módulos-y-funcionalidades)
- [API Endpoints](#-api-endpoints)
- [Base de Datos](#️-base-de-datos)
- [Deployment](#-deployment)
- [Seguridad](#-seguridad)
- [Documentación](#-documentación)
- [Licencia](#-licencia)

---

## 🎯 Características Principales

### 🔐 Sistema RBAC Completo
- 5 roles predefinidos con jerarquía (super_admin → administrador → delegado → supervisor → guardia)
- 40+ permisos granulares por módulo
- Soporte wildcards (`*.*`, `modulo.*`)
- Scoping: global, por plaza, por casa
- UI de gestión visual con auditoría completa

### 🛡️ Check-in de Seguridad con QR
- Tokens QR únicos por plaza (19 plazas)
- Validación código 6 dígitos
- Registro geolocalizado (IP, User-Agent)
- Historial completo por guardia/plaza

### 🏘️ Gestión Residencial
- **Casas**: 19 plazas, cuotas diferenciadas
- **Residentes**: RUN chileno validado, edad automática
- **Mascotas**: Galería pública (SIN auth), control vacunas, alertas

### 💰 Sistema Financiero
- Pagos cuota social y junta de vecinos
- Generación automática por período
- Cálculo morosidad en tiempo real
- Bloqueo vehicular por 3+ meses deuda

### 🚗 Control de Acceso Vehicular
- Registro entradas/salidas automático
- Validación morosidad en tiempo real
- Bloqueo automático para morosos
- Historial y estadísticas de tráfico

### 📅 Eventos Comunitarios
- 8 tipos de eventos predefinidos
- Inscripción/cancelación asistencia
- Integración Google Calendar + reuniones virtuales
- Portal público sin autenticación

### 📄 Centro de Documentos
- 7 tipos documentos (actas, reglamentos, circulares...)
- Integración Google Drive
- Auditoría de descargas
- Portal público con filtros avanzados

### 📊 Panel de Administración
- Dashboard estadísticas en tiempo real
- Gestión guardias, plazas, administradores
- Reportes y análisis actividad
- Generación tokens QR

---

## 🛠️ Stack Tecnológico

| Categoría | Tecnologías |
|-----------|-------------|
| **Backend** | Node.js 18+, Express.js 4.18 |
| **Base de Datos** | PostgreSQL 12+ / Supabase |
| **Autenticación** | JWT + Express-session |
| **Seguridad** | bcrypt, helmet, express-rate-limit |
| **Frontend** | HTML5, CSS3, Bootstrap 5.3, JavaScript ES6+ vanilla |
| **Iconos** | Font Awesome 6.0 |
| **Deployment** | Render.com, Docker |

---

## ⚡ Instalación Rápida

### Requisitos
- Node.js ≥ 18.0.0
- PostgreSQL ≥ 12.0 o cuenta Supabase
- npm ≥ 8.0.0

### Pasos

```bash
# 1. Clonar repositorio
git clone https://github.com/yourusername/servicios_pradosdenos.git
cd servicios_pradosdenos

# 2. Instalar dependencias
npm install

# 3. Configurar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales

# 4. Ejecutar migraciones
# Ver database/migrations/ y scripts/database/README.md
psql $DATABASE_URL -f database/migrations/000_schema_production.sql

# 5. Iniciar servidor
npm run dev      # Desarrollo (nodemon)
npm start        # Producción
```

### Variables de Entorno Esenciales

```env
DATABASE_URL=postgresql://usuario:password@localhost:5432/pradosdenos
JWT_SECRET=tu_secreto_super_seguro_cambiar_en_produccion
JWT_ALGORITHM=HS256
JWT_EXPIRATION=24h
PORT=3000
NODE_ENV=production
```

⚠️ **IMPORTANTE**: Rotar credenciales de `.env.example` antes de producción. Actualmente contienen passwords de ejemplo.

### 🚗 Instalación Opcional: Mantenedores de Vehículos (Nuevo)

Si deseas usar **dropdowns normalizados** para Tipo/Marca/Modelo de vehículos (recomendado para evitar errores de ortografía):

```bash
# Ejecutar script de instalación (conecta a Supabase automáticamente)
node install-vehicle-maintainers.js
```

Esto carga:
- 12 tipos de vehículos (Automóvil, Camioneta, SUV, etc.)
- 45 marcas del mercado chileno (Toyota, Chevrolet, Nissan, etc.)
- 180+ modelos populares por marca

**Beneficios:**
- ✅ Datos normalizados (adiós a "toyota" vs "Toyota")
- ✅ Dropdowns en cascada Tipo → Marca → Modelo
- ✅ 100% compatible con registros legacy (campos texto libre)

📖 **Documentación completa**: `database/seeds/README_MANTENEDORES_VEHICULOS.md`

---

## 🧩 Módulos y Funcionalidades

### 1. 🔐 Autenticación y RBAC
- Login/logout para guardias y administradores
- Sistema Role-Based Access Control
- 5 roles: super_admin, administrador, delegado, supervisor, guardia
- Middleware `requirePermission(permission)`
- Auditoría completa de cambios

### 2. 🛡️ Check-in de Seguridad
- QR tokens únicos (formato: `qr-plaza-{nombre}-2025`)
- Validación con código guardia
- Registro rondas con timestamp
- Historial por guardia y plaza

### 3. 🏘️ Gestión Residencial
- **Casas**: CRUD, cuotas, plazas (19 total)
- **Residentes**: CRUD, RUN validado, edad automática
- **Mascotas**: CRUD, galería pública, vacunas, fotos

### 4. 💰 Pagos y Morosidad
- Cuota social y junta de vecinos
- Estados: pendiente, pagado, vencido, anulado
- Generación automática mensual
- Cálculo morosidad (3+ meses)
- Reportes por plaza/período

### 5. 🚗 Vehículos y Control de Acceso
- CRUD vehículos (patente, marca, modelo)
- **NUEVO**: Mantenedores normalizados Tipo/Marca/Modelo (45 marcas, 180+ modelos chilenos)
- **NUEVO**: Dropdowns en cascada con datos del mercado automotriz
- Registro automático entrada/salida
- Validación morosidad en tiempo real
- Bloqueo acceso (meses_moroso ≥ 3)
- Historial completo con 100% compatibilidad legacy

### 6. 📅 Eventos Comunitarios
- 8 tipos: Reunión Ord/Extr, Capacitación, Actividad, Mantenimiento, Emergencia, Elecciones
- Inscripción/cancelación
- Links Google Calendar + reuniones virtuales
- Portal público

### 7. 📄 Documentos Comunitarios
- 7 tipos: Acta, Reglamento, Circular, Presupuesto, Contrato, Manual, Legal
- Google Drive integration
- Auditoría descargas (quién, cuándo)
- Portal público con filtros

### 8. 📊 Panel de Administración
- Dashboard: estadísticas en tiempo real
- Gestión: guardias, plazas, admins, roles
- Reportes: check-ins, morosidad, actividad
- Herramientas: generación tokens QR, duplicados

---

## 📡 API Endpoints

Documentación completa en [`docs/api/`](docs/api/README.md)

### Endpoints Principales

| Módulo | Endpoints | Documentación |
|--------|-----------|---------------|
| **Autenticación** | `/api/auth/*` | [Ver docs](docs/api/README.md) |
| **Check-in** | `/api/checkin/*` | [Ver docs](docs/api/README.md) |
| **Admin** | `/api/admin/*` | [Ver docs](docs/api/README.md) |
| **Casas** | `/api/casas/*` | [Ver docs](docs/api/README.md) |
| **Residentes** | `/api/residentes/*` | [Ver docs](docs/api/README.md) |
| **Mascotas** | `/api/mascotas/*` | [Ver docs](docs/api/README.md) |
| **Pagos** | `/api/pagos/*` | [Ver docs](docs/api/README.md) |
| **Vehículos** | `/api/vehiculos/*` | [Ver docs](docs/api/README.md) |
| **Acceso** | `/api/acceso/*` | [Ver docs](docs/api/README.md) |
| **Eventos** | `/api/eventos/*` | [Ver docs](docs/api/README.md) |
| **Documentos** | `/api/documentos/*` | [Ver docs](docs/api/README.md) |
| **Roles** | `/api/roles/*` | [Ver docs](docs/api/README.md) |

### Endpoints Públicos (Sin Auth)
- `GET /api/mascotas/publico` - Galería mascotas
- `GET /api/eventos/` - Lista eventos
- `GET /api/documentos/` - Lista documentos
- `GET /api/admin/plazas/activas` - Plazas activas

---

## 🗄️ Base de Datos

### Schema Principal

**20+ tablas organizadas**:

| Categoría | Tablas |
|-----------|--------|
| **Core** | plazas, plaza_tokens, guardias, admin_users, checkins |
| **Residencial** | casas, residentes, mascotas |
| **Financiero** | pagos |
| **Vehicular** | vehiculos, control_acceso |
| **Comunidad** | eventos_vecinales, tipo_evento, inscripciones_eventos |
| **Documentos** | documentos_comunitarios, tipo_documento, descargas_documentos |
| **RBAC** | roles, permissions, role_permissions, user_roles, permission_audit |
| **Seguridad** | security_logs |

### Vistas Principales
- `v_casas_completo` - Casas + plaza
- `v_residentes_completo` - Residentes + casa + edad
- `v_mascotas_completo` - Mascotas + dueño + casa + vacunas
- `v_pagos_completo` - Pagos + casa + morosidad
- `v_vehiculos_completo` - Vehículos + casa + acceso

### Migraciones

**16 migraciones numeradas** en `database/migrations/` y `scripts/database/`:

```
000-016_*.sql
```

**Orden de ejecución**: Ver `scripts/database/README.md`

**Schemas disponibles**:
- `000_schema_production.sql` - Schema completo para producción
- `000_supabase_initial.sql` - Setup inicial Supabase

---

## 🚀 Deployment

### Render.com (Recomendado)

1. **Conectar repositorio** GitHub a Render
2. **Configurar servicio**:
   - Tipo: Web Service
   - Build Command: `npm install`
   - Start Command: `npm start`
3. **Variables de entorno**: Configurar desde panel Render
4. **Base de datos**: Provisionar PostgreSQL managed o usar Supabase

Ver [`render.yaml`](render.yaml) para configuración automatizada.

### Docker

```bash
# Build
docker build -t servicios-pradosdenos .

# Run
docker run -p 3000:3000 \
  -e DATABASE_URL="postgresql://..." \
  -e JWT_SECRET="..." \
  servicios-pradosdenos
```

Ver [`Dockerfile`](Dockerfile) para detalles.

### Manual (VPS/Servidor)

```bash
# En servidor
git clone ...
cd servicios_pradosdenos
npm install --production
cp .env.example .env
# Configurar .env
npm start
```

**Process Manager** recomendado: PM2

```bash
npm install -g pm2
pm2 start server.js --name servicios-pradosdenos
pm2 save
pm2 startup
```

---

## ��️ Seguridad

### Características Implementadas

✅ **Autenticación y Autorización**
- JWT + Express-session
- Hashing bcrypt (salt rounds: 10)
- RBAC con 40+ permisos granulares
- Middleware `requireAuth` y `requirePermission`

✅ **Protección HTTP**
- Helmet.js (headers seguridad)
- CORS configurado
- Rate limiting (5 intentos login/15 min)
- Express validator (sanitización inputs)

✅ **Base de Datos**
- Prepared statements (prevención SQL injection)
- 31 funciones con `SET search_path` (migración 016)
- Validación RUN chileno en DB
- Triggers automáticos

✅ **Auditoría**
- `security_logs` table (eventos de seguridad)
- `permission_audit` (cambios de permisos)
- `descargas_documentos` (tracking descargas)
- Logging de IPs y User-Agents

### ⚠️ Pendientes de Seguridad

- [ ] Rotar credenciales de `render.yaml` y `.env.example` (actualmente passwords de ejemplo visibles)
- [ ] Implementar HTTPS en producción
- [ ] Configurar `secure: true` en cookies de sesión
- [ ] Implementar 2FA para super_admin
- [ ] Agregar Content Security Policy (CSP)
- [ ] Rate limiting global (no solo login)

---

## 🧪 Testing

### Estado Actual
**No hay suite de tests automatizados**. Testing manual mediante scripts en `archive/testing/`.

### Scripts de Testing Disponibles
- `archive/testing/test-*.js` - Tests manuales de endpoints
- `testing/debug/diagnostico-qr-simple.html` - Debug QR
- `testing/debug/qr-plazas-funcional.html` - Verificación tokens

### Roadmap Testing
- [ ] Jest + Supertest para API testing
- [ ] Tests unitarios de funciones SQL
- [ ] Tests de integración RBAC
- [ ] E2E con Playwright/Cypress
- [ ] Coverage report (objetivo: 80%+)

---

## 📚 Documentación

### Estructura Docs

```
docs/
├── api/                    # Documentación API endpoints
├── database/               # Schema y ER diagrams
├── deployment/             # Guías de despliegue
├── development/            # Setup desarrollo
└── troubleshooting/        # Solución de problemas
```

### Documentos Clave
- [`CHANGELOG.md`](CHANGELOG.md) - Historial completo de cambios
- [`docs/api/README.md`](docs/api/README.md) - Documentación API
- [`scripts/database/README.md`](scripts/database/README.md) - Migraciones DB
- [`README_INSTALACION.md`](README_INSTALACION.md) - Instalación detallada

---

## 🤝 Contribución

Este es un proyecto privado/propietario. Contribuciones limitadas a equipo interno.

### Workflow
1. Crear branch: `git checkout -b feature/nueva-funcionalidad`
2. Commit: `git commit -m "feat: descripción"`
3. Push: `git push origin feature/nueva-funcionalidad`
4. Pull Request con descripción detallada

### Convenciones Commit
- `feat:` - Nueva funcionalidad
- `fix:` - Corrección de bug
- `docs:` - Cambios en documentación
- `refactor:` - Refactorización sin cambio funcional
- `chore:` - Tareas de mantenimiento
- `security:` - Mejoras de seguridad

---

## 📄 Licencia

**Propietaria** - Uso interno Servicios Prados de Nos.  
Prohibida la distribución o uso comercial sin autorización.

---

## 📞 Contacto y Soporte

**Maintainer**: [Tu Nombre]  
**Email**: contacto@pradosdenos.cl (placeholder)  
**Issues**: [GitHub Issues](https://github.com/yourusername/servicios_pradosdenos/issues)

---

## 🎉 Agradecimientos

Desarrollado para la comunidad de residentes del condominio Los Prados de Nos.

**Versión 1.2.1** - Mayo 2026  
Copyright © 2026 Servicios Prados de Nos
# �️ Portal de Servicios Los Prados de Nos

[![Versión](https://img.shields.io/badge/versión-1.2.1-blue.svg)](https://github.com/yourusername/servicios_pradosdenos/releases)
[![Estado](https://img.shields.io/badge/estado-producción-success.svg)](https://servicios-pradosdenos.render.com)
[![Node](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen.svg)](https://nodejs.org)
[![PostgreSQL](https://img.shields.io/badge/postgresql-%3E%3D12.0-blue.svg)](https://www.postgresql.org)
[![License](https://img.shields.io/badge/license-Propietaria-red.svg)](#)

**Portal comunitario integral para la gestión de residentes, eventos, documentos, control de acceso y servicios comunitarios del condominio Los Prados de Nos.**

🌐 **Demo**: [servicios-pradosdenos.render.com](https://servicios-pradosdenos.render.com) (placeholder)  
📚 **Documentación API**: [docs/api/](docs/api/)  
📝 **Changelog**: [CHANGELOG.md](CHANGELOG.md)

---

## 📑 Tabla de Contenidos

- [Características Principales](#-características-principales)
- [Stack Tecnológico](#-stack-tecnológico)
- [Requisitos del Sistema](#-requisitos-del-sistema)
- [Instalación Rápida](#-instalación-rápida)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Módulos y Funcionalidades](#-módulos-y-funcionalidades)
- [API Endpoints](#-api-endpoints)
- [Base de Datos](#️-base-de-datos)
- [Deployment](#-deployment)
- [Seguridad](#-seguridad)
- [Testing](#-testing)
- [Contribución](#-contribución)
- [Licencia](#-licencia)

---

## 🎯 Características Principales

### 🔐 Sistema RBAC (Role-Based Access Control)
- **5 roles predefinidos**: super_admin, administrador, delegado, supervisor, guardia
- **40+ permisos granulares** por módulo (crear, leer, editar, eliminar)
- **Soporte de wildcards**: `*.*` (acceso total), `modulo.*` (módulo completo)
- **Scoping de permisos**: global, por plaza, por casa
- **UI de gestión completa**: Panel visual con matriz de permisos
- **Auditoría**: Historial completo de cambios (quién, qué, cuándo, por qué)

### 🛡️ Check-in de Seguridad con QR
- **Tokens QR únicos** por plaza (19 plazas configuradas)
- **Validación con código** de 6 dígitos por guardia
- **Registro de rondas** con timestamp, IP y User-Agent
- **Historial completo** de check-ins por plaza y guardia

### 🏘️ Gestión Residencial Completa
- **Casas**: Gestión de 19 plazas con cuotas diferenciadas
- **Residentes**: CRUD con RUN chileno validado, edad automática
- **Mascotas**: 
  * Galería pública (SIN autenticación) para emergencias
  * Control de vacunas con alertas
  * Fotos y certificados

### 💰 Sistema Financiero
- **Pagos**: Cuota social y junta de vecinos por período
- **Morosidad**: Cálculo automático y alertas
- **Control de acceso**: Bloqueo vehicular por 3+ meses morosos
- **Reportes**: Estadísticas por plaza y período

### 🚗 Control de Acceso Vehicular
- **Registro automático** de entradas/salidas
- **Validación de morosidad** en tiempo real
- **Bloqueo automático** para casas con deuda
- **Historial y estadísticas** de tráfico

### 📅 Eventos Comunitarios
- **8 tipos de eventos** predefinidos
- **Inscripción y cancelación** de asistencia
- **Integración con Google Calendar** y reuniones virtuales
- **Portal público** para consulta sin autenticación

### 📄 Centro de Documentos
- **7 tipos de documentos** (actas, reglamentos, circulares, etc.)
- **Integración con Google Drive**
- **Auditoría de descargas** (quién, cuándo)
- **Portal público** con filtros avanzados

### 📊 Panel de Administración
- **Dashboard** con estadísticas en tiempo real
- **Gestión completa** de guardias, plazas, administradores
- **Reportes y análisis** de actividad
- **Generación de tokens** QR

---

## 🛠️ Stack Tecnológico

### Backend
- **Runtime**: Node.js 18+
- **Framework**: Express.js 4.18
- **Base de Datos**: PostgreSQL 12+ / Supabase
- **Autenticación**: JWT + Express-session
- **Seguridad**: bcrypt, helmet, express-rate-limit
- **ORM**: pg (node-postgres)

### Frontend
- **HTML5** / **CSS3** / **JavaScript ES6+** vanilla
- **UI Framework**: Bootstrap 5.3.0
- **Iconos**: Font Awesome 6.0.0
- **Diseño**: Glassmorphism, gradientes CSS

### DevOps
- **Deployment**: Render.com
- **Containerización**: Docker
- **CI/CD**: GitHub Actions (configurar)
- **Logs**: Winston (implementar)

---

## 📋 Requisitos del Sistema

### Obligatorios
- **Node.js** ≥ 18.0.0
- **npm** ≥ 8.0.0
- **PostgreSQL** ≥ 12.0 o cuenta Supabase
- **Sistema operativo**: Linux / macOS / Windows WSL2

### Opcionales
- **Docker** 20.10+ (para deployment containerizado)
- **Git** 2.30+ (para control de versiones)

---

## ⚡ Instalación Rápida

```bash
# 1. Clonar el repositorio
git clone https://github.com/yourusername/servicios_pradosdenos.git
cd servicios_pradosdenos

# 2. Instalar dependencias
npm install

# 3. Configurar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales

# 4. Ejecutar migraciones de base de datos
# Ver scripts/database/README.md para orden de ejecución
psql $DATABASE_URL -f scripts/database/000_schema_production.sql

# 5. Iniciar en desarrollo
npm run dev

# 6. Iniciar en producción
npm start
```

### Variables de Entorno Requeridas

```env
# Base de datos
DATABASE_URL=postgresql://usuario:password@localhost:5432/pradosdenos

# JWT
JWT_SECRET=tu_secreto_super_seguro_cambiar_en_produccion
JWT_ALGORITHM=HS256
JWT_EXPIRATION=24h

# Supabase (opcional, si usas Supabase)
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_KEY=tu_anon_key

# Servidor
PORT=3000
NODE_ENV=production

# Email (opcional, para notificaciones)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=tu-email@gmail.com
SMTP_PASS=tu-app-password
```

⚠️ **IMPORTANTE**: Rotar credenciales en `.env.example` antes de deployment a producción. Actualmente contienen passwords de ejemplo.

---

## 📁 Estructura del Proyecto

```
servicios_pradosdenos/
├── backend/                      # Servidor Node.js/Express
│   ├── routes/                   # Definición de rutas
│   │   ├── auth.routes.js        # Autenticación
│   │   ├── admin.routes.js       # Panel admin
│   │   ├── checkin.routes.js     # Check-in guardias
│   │   ├── casas.routes.js       # Gestión casas
│   │   ├── residentes.routes.js  # Gestión residentes
│   │   ├── mascotas.routes.js    # Gestión mascotas
│   │   ├── pagos.routes.js       # Gestión pagos
│   │   ├── vehiculos.routes.js   # Gestión vehículos
│   │   ├── acceso.routes.js      # Control de acceso
│   │   ├── eventos.routes.js     # Eventos comunitarios
│   │   ├── documentos.routes.js  # Documentos
│   │   └── roles.routes.js       # RBAC
│   ├── middleware/               # Middleware personalizado
│   │   ├── auth.middleware.js    # Autenticación
│   │   └── rbac.middleware.js    # Autorización RBAC
│   ├── utils/                    # Utilidades
│   │   └── db.js                 # Conexión PostgreSQL
│   ├── server.js                 # Servidor principal (desarrollo)
│   └── server-production.js      # Servidor optimizado (producción)
├── public/                       # Frontend (archivos estáticos)
│   ├── css/                      # Hojas de estilo
│   ├── js/                       # JavaScript
│   │   └── rbac-helper.js        # Helper RBAC frontend
│   ├── index.html                # Landing page
│   ├── checkin.html              # Check-in guardias
│   ├── admin-panel.html          # Panel administración
│   ├── eventos.html              # Portal eventos
│   ├── documentos.html           # Portal documentos
│   └── mascotas-galeria.html     # Galería pública mascotas
├── database/                     # Schema y migraciones
│   ├── migrations/               # Migraciones versionadas
│   │   ├── 000_schema_production.sql  # Schema principal
│   │   ├── 001-016_*.sql         # Migraciones numeradas
│   └── seeds/                    # Datos iniciales
│       └── admin_user_seed.sql   # Crear admin inicial
├── docs/                         # Documentación
│   ├── api/                      # Documentación de endpoints
│   ├── database/                 # Schema y ER diagrams
│   ├── deployment/               # Guías de deploy
│   ├── development/              # Guías de desarrollo
│   └── troubleshooting/          # Solución de problemas
├── scripts/                      # Scripts de utilidad
│   ├── database/                 # Migraciones SQL
│   └── utilities/                # Scripts Node.js
├── testing/                      # Testing y debugging
│   └── debug/                    # Herramientas de debug QR
├── archive/                      # Archivos archivados
│   ├── diagnostics/              # Scripts de diagnóstico
│   ├── testing/                  # Tests antiguos
│   └── deployment-scripts/       # Scripts deploy obsoletos
├── .env.example                  # Template variables entorno
├── .gitignore                    # Archivos ignorados por Git
├── Dockerfile                    # Configuración Docker
├── render.yaml                   # Configuración Render.com
├── package.json                  # Dependencias npm
├── README.md                     # Este archivo
└── CHANGELOG.md                  # Historial de cambios
```

---

## 🧩 Módulos y Funcionalidades

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
