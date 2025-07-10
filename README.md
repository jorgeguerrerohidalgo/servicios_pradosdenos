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
- **Check-in de guardias** con doble validación (QR + código)
- **Registro de rondas** con fecha/hora precisa
- **Consulta en tiempo real** del historial de seguridad
- **Vista adaptativa** (tabla en desktop, cards en móvil)

### 👨‍💼 Administración
- **Panel administrativo** separado del portal público
- **Gestión de guardias** y personal de seguridad
- **Gestión de plazas** del conjunto
- **Autenticación segura** con sesiones

## Deployment en Render

### 🚀 Deploy Rápido
1. Fork este repositorio
2. Conectar con Render
3. Configurar base de datos externa (PlanetScale recomendado)
4. Configurar variables de entorno
5. Deploy automático con `render.yaml`

**Ver guía completa:** [DEPLOY_RENDER.md](./DEPLOY_RENDER.md)

### Variables de Entorno Requeridas
```bash
NODE_ENV=production
SESSION_SECRET=tu_clave_muy_segura
DB_HOST=tu_host_de_bd
DB_USER=tu_usuario
DB_PASSWORD=tu_password
DB_NAME=checkin_plaza
DB_SSL=true
```

## Instalación Local

### 1. Configurar la base de datos
```sql
-- Ejecutar el archivo SQL para crear la estructura
SOURCE checkin_plaza_extend.sql;
```

### 2. Configurar el backend
```bash
cd backend
npm install
```

### 3. Configurar variables de entorno
```bash
# Copiar el archivo de ejemplo
cp .env.example .env

# Editar .env con tus credenciales de base de datos
```

### 4. Actualizar contraseñas a hash (opcional)
```sql
-- Si tienes datos existentes, ejecutar:
SOURCE update_passwords.sql;
```

### 5. Iniciar el servidor
```bash
npm start
```

## Estructura del Proyecto

```
servicios_pradosdenos/
├── README.md
├── checkin_plaza_extend.sql     # Estructura de base de datos
├── update_passwords.sql         # Script para actualizar contraseñas
├── backend/
│   ├── package.json
│   ├── server.js               # Servidor principal
│   ├── .env.example           # Plantilla de variables de entorno
│   ├── utils/
│   │   └── db.js              # Configuración de base de datos
│   └── routes/
│       ├── auth.routes.js     # Autenticación de guardias
│       └── checkin.routes.js  # Gestión de check-ins
└── public/
    ├── login.html             # Página de login
    └── checkin.html           # Página de check-in con QR
```

## API Endpoints

### Autenticación
- `POST /api/auth/login` - Login de guardia
- `GET /api/auth/logout` - Cerrar sesión
- `GET /api/auth/check` - Verificar autenticación

### Check-ins
- `POST /api/checkin` - Registrar check-in
- `GET /api/checkin/history` - Obtener historial de check-ins

## Credenciales de Prueba

- **Email:** carlos@example.com, **Contraseña:** 1234
- **Email:** maria@example.com, **Contraseña:** 5678

## Tokens QR de Prueba

- Plaza Norte: `qr-token-norte-123`
- Plaza Sur: `qr-token-sur-456` 
- Plaza Central: `qr-token-central-789`

## Seguridad Implementada

- Contraseñas hasheadas con bcrypt
- Validación de entrada en todas las rutas
- Prevención de check-ins duplicados
- Manejo seguro de sesiones
- Logs de errores para debugging

## Tecnologías Utilizadas

- **Backend:** Node.js, Express.js, MySQL2, bcrypt
- **Frontend:** HTML5, JavaScript vanilla, html5-qrcode
- **Base de datos:** MySQL

## Próximas Mejoras

- [ ] Panel de administración
- [ ] Reportes de check-ins
- [ ] Notificaciones push
- [ ] API para aplicación móvil