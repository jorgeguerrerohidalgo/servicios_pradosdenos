# Portal de Servicios - Prados de Nos 🏡

Sistema completo de servicios digitales para el Conjunto Los Prados de Nos, con enfoque en la consulta pública de rondas de seguridad y administración interna.

## ✨ Características Principales

### 🌐 Portal Público
- **Portal de servicios principal** con diseño moderno glass-effect
- **Consulta pública de rondas** para que vecinos vean cuándo pasó seguridad
- **6 servicios planificados** con roadmap de desarrollo
- **Diseño responsive** optimizado para móviles y desktop
- **Zona horaria de Santiago de Chile** configurada automáticamente

### 🛡️ Sistema de Seguridad  
- **Check-in de guardias** con doble validación (QR + código único)
- **Códigos de validación únicos** por guardia para mayor seguridad
- **Registro de rondas** con fecha/hora precisa
- **Consulta en tiempo real** del historial de seguridad
- **Vista adaptativa** (tabla en desktop, cards en móvil)
- **Validación en tiempo real** del código de seguridad
- **Feedback visual inmediato** durante el proceso

### 👨‍💼 Administración Completa
- **Panel administrativo** separado del portal público
- **Gestión completa de guardias** con códigos de validación
- **Gestión de plazas** del conjunto con información detallada
- **Gestión de administradores** del sistema
- **Reportes y estadísticas** en tiempo real
- **Autenticación segura** con sesiones persistentes

## 🚀 Estado del Proyecto

### ✅ Funcionalidades Completadas
- ✅ Migración completa a PostgreSQL/Supabase
- ✅ Sistema de autenticación dual (guardias y administradores)
- ✅ Panel de administración con CRUD completo
- ✅ Check-in con QR + código de validación único
- ✅ Consulta pública de rondas optimizada
- ✅ Zona horaria de Santiago configurada
- ✅ APIs REST completas y documentadas
- ✅ Interfaz responsive y moderna
- ✅ Validación en tiempo real
- ✅ Feedback visual mejorado
- ✅ Configuración para producción en Render

### 🔄 Próximas Mejoras
- [ ] Notificaciones push para administradores
- [ ] Reportes PDF exportables
- [ ] API móvil para aplicación nativa
- [ ] Dashboard de métricas avanzadas
- [ ] Integración con sistemas de seguridad externos

## 🛠️ Tecnologías Utilizadas

### Backend
- **Node.js** - Runtime de JavaScript
- **Express.js** - Framework web
- **PostgreSQL** - Base de datos relacional
- **Supabase** - Base de datos en la nube
- **bcrypt** - Encriptación de contraseñas
- **express-session** - Manejo de sesiones

### Frontend
- **HTML5** - Estructura web moderna
- **CSS3** - Estilos y animaciones
- **JavaScript Vanilla** - Lógica del cliente
- **Bootstrap 5** - Framework CSS
- **FontAwesome** - Iconografía
- **html5-qrcode** - Escáner QR

### DevOps
- **Render** - Plataforma de despliegue
- **Git** - Control de versiones
- **dotenv** - Gestión de variables de entorno

## 🚀 Despliegue en Render

### Configuración Rápida
1. **Fork** este repositorio
2. **Conectar** con Render usando el archivo `render.yaml`
3. **Configurar** base de datos PostgreSQL (Supabase recomendado)
4. **Establecer** variables de entorno requeridas
5. **Deploy** automático

### Variables de Entorno Requeridas
```bash
NODE_ENV=production
SESSION_SECRET=tu_clave_muy_segura_aqui
DATABASE_URL=postgresql://user:password@host:5432/database
FRONTEND_URL=https://tu-dominio.onrender.com
RENDER_EXTERNAL_URL=https://tu-dominio.onrender.com
```

## 📦 Instalación Local

### Prerrequisitos
- Node.js 18 o superior
- PostgreSQL 12 o superior
- Git

### Pasos de Instalación

### Pasos de Instalación

#### 1. Clonar el repositorio
```bash
git clone https://github.com/tu-usuario/servicios_pradosdenos.git
cd servicios_pradosdenos
```

#### 2. Configurar la base de datos
```sql
-- Ejecutar el esquema completo
\i database_postgresql_fixed.sql
```

#### 3. Configurar el backend
```bash
cd backend
npm install
```

#### 4. Configurar variables de entorno
```bash
# Copiar el archivo de ejemplo
cp .env.example .env

# Editar .env con tus credenciales
# DATABASE_URL=postgresql://user:password@host:5432/database
```

#### 5. Iniciar el servidor
```bash
npm start
```

## 📁 Estructura del Proyecto

```
servicios_pradosdenos/
├── README.md
├── render.yaml                      # Configuración de Render
├── database_postgresql_fixed.sql    # Esquema de base de datos
├── backend/
│   ├── package.json
│   ├── server.js                   # Servidor principal
│   ├── .env.example               # Variables de entorno
│   ├── utils/
│   │   └── db.js                  # Configuración de BD
│   └── routes/
│       ├── auth.routes.js         # Autenticación
│       ├── checkin.routes.js      # Check-ins
│       ├── admin.routes.js        # Administración
│       └── public.routes.js       # APIs públicas
└── public/
    ├── index.html                 # Portal principal
    ├── consulta-rondas.html       # Consulta pública
    ├── guardia-login.html         # Login de guardias
    ├── guardia-checkin.html       # Check-in QR
    ├── admin-login.html           # Login de administradores
    ├── admin-panel.html           # Panel de administración
    ├── qr-plazas.html            # Códigos QR para imprimir
    └── diagnostico.html          # Herramientas de diagnóstico
```

## 🔧 API Endpoints

### Autenticación
- `POST /api/auth/login` - Login de guardia
- `POST /api/auth/admin/login` - Login de administrador
- `GET /api/auth/logout` - Cerrar sesión
- `GET /api/auth/check` - Verificar autenticación

### Check-ins
- `POST /api/checkin` - Registrar check-in (QR + código)
- `GET /api/checkin/history` - Historial de check-ins del guardia
- `GET /api/checkin/validation-code` - Obtener código de validación

### APIs Públicas
- `GET /api/plazas` - Listar todas las plazas
- `GET /api/checkins/public` - Consulta pública de rondas
- `GET /api/stats` - Estadísticas públicas

### Administración
- `GET /api/admin/guardias` - CRUD de guardias
- `GET /api/admin/plazas` - CRUD de plazas
- `GET /api/admin/administradores` - CRUD de administradores
- `GET /api/admin/reportes` - Reportes y estadísticas

## 🔐 Credenciales de Prueba

### Guardias
- **Email:** carlos@pradosdenos.cl, **Contraseña:** 1234
- **Email:** maria@pradosdenos.cl, **Contraseña:** 5678

### Administradores
- **Email:** admin@pradosdenos.cl, **Contraseña:** admin123

### Tokens QR de Prueba
- Plaza La Coruña: `qr-token-plaza-1`
- Plaza Valencia: `qr-token-plaza-2`
- Plaza Marbella: `qr-token-plaza-3`

## 🔒 Seguridad Implementada

- **Contraseñas hasheadas** con bcrypt
- **Validación de entrada** en todas las rutas
- **Prevención de check-ins duplicados**
- **Códigos de validación únicos** por guardia
- **Sesiones seguras** con cookies httpOnly
- **Zona horaria consistente** (Santiago de Chile)
- **Validación en tiempo real** del frontend
- **Logging de errores** para debugging