# 🚀 Guía de Deployment en Render

## Pasos para Deploy en Render

### 1. Preparar la Base de Datos

**Opción A: PlanetScale (Recomendado - MySQL)**
1. Crear cuenta en [PlanetScale](https://planetscale.com/)
2. Crear nueva base de datos
3. Obtener string de conexión
4. Ejecutar el script `database_production.sql`

**Opción B: Railway (MySQL/PostgreSQL)**
1. Crear cuenta en [Railway](https://railway.app/)
2. Agregar servicio MySQL
3. Obtener credenciales de conexión

**Opción C: FreeSQLDatabase (Solo para pruebas)**
1. Crear cuenta en [FreeSQLDatabase](https://www.freesqldatabase.com/)
2. Crear base de datos MySQL gratuita

### 2. Deploy en Render

#### Método A: Usando render.yaml (Recomendado)
1. Hacer fork del repositorio en GitHub
2. Conectar GitHub con Render
3. Seleccionar el repositorio
4. Render detectará automáticamente el archivo `render.yaml`
5. Configurar variables de entorno

#### Método B: Manual
1. En Render, crear nuevo "Web Service"
2. Conectar repositorio de GitHub
3. Configurar:
   - **Build Command:** `cd backend && npm install`
   - **Start Command:** `cd backend && npm start`
   - **Environment:** Node
   - **Node Version:** 18 o superior

### 3. Variables de Entorno en Render

```bash
# Requeridas
NODE_ENV=production
SESSION_SECRET=tu_clave_secreta_muy_segura_aqui

# Base de datos (ejemplo PlanetScale)
DB_HOST=aws.connect.psdb.cloud
DB_USER=tu_usuario
DB_PASSWORD=tu_password
DB_NAME=checkin_plaza
DB_PORT=3306
DB_SSL=true
DB_SSL_REJECT_UNAUTHORIZED=false

# URLs (Render las asigna automáticamente)
FRONTEND_URL=https://tu-app.onrender.com
RENDER_EXTERNAL_URL=https://tu-app.onrender.com
```

### 4. Configuración de la Base de Datos

```sql
-- Ejecutar en tu base de datos externa
SOURCE database_production.sql;
```

### 5. Verificación del Deploy

1. **Health Check:** `https://tu-app.onrender.com/health`
2. **Frontend:** `https://tu-app.onrender.com/login.html`
3. **API:** `https://tu-app.onrender.com/api/auth/check`

### 6. Credenciales de Prueba

- **Email:** carlos@example.com, **Password:** 1234
- **Email:** maria@example.com, **Password:** 5678

### 7. Tokens QR de Prueba

- Plaza Norte: `qr-token-norte-123`
- Plaza Sur: `qr-token-sur-456`
- Plaza Central: `qr-token-central-789`

## Solución de Problemas

### Error de Conexión a BD
1. Verificar variables de entorno
2. Comprobar whitelist de IPs en la BD
3. Verificar configuración SSL

### Error de CORS
1. Verificar `FRONTEND_URL` en variables de entorno
2. Comprobar configuración de dominios

### Errores de Build
1. Verificar versión de Node.js (>=18)
2. Comprobar que todas las dependencias estén en `package.json`

### Performance en Render Free Tier
- El servicio "duerme" después de 15 minutos de inactividad
- Primer request puede tardar 30-60 segundos
- Considerar upgrade a plan pago para producción

## Monitoreo

- **Logs:** Dashboard de Render
- **Health:** Endpoint `/health`
- **Métricas:** Panel de Render

## Próximos Pasos

1. Configurar dominio personalizado
2. Configurar SSL/TLS
3. Implementar CI/CD con GitHub Actions
4. Configurar monitoreo avanzado
5. Implementar backup automático de BD
