# 🏗️ Instalación - Los Prados de Nos

## Requisitos Previos

- Node.js 16+ instalado
- Cuenta en Supabase
- Proyecto de Supabase creado

## Pasos de Instalación

### 1. Configurar Supabase

1. Ve a https://supabase.com
2. Crea un nuevo proyecto
3. Ve a Settings > Database
4. Copia la URL de conexión PostgreSQL

### 2. Configurar Variables de Entorno

Edita el archivo `backend\.env`:

```env
DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT_ID].supabase.co:5432/postgres
SESSION_SECRET=tu_secreto_super_seguro_aqui
```

### 3. Ejecutar Migraciones

```cmd
cd backend
npm run migrate
```

### 4. Configurar Usuarios de Prueba

```cmd
npm run setup-users
```

### 5. Iniciar el Servidor

```cmd
npm start
# o para desarrollo:
npm run dev
```

## Credenciales de Prueba

- **Admin**: admin@pradosdenos.cl / admin123
- **Guardia**: guardia@pradosdenos.cl / guardia123

## URLs del Sistema

- Admin: http://localhost:3000/admin-login.html
- Guardia: http://localhost:3000/guardia-login.html
- Portal: http://localhost:3000/login.html

## Comandos Útiles

```cmd
# Ejecutar migraciones
npm run migrate

# Configurar usuarios de prueba
npm run setup-users

# Probar conexión a la base de datos
npm run test

# Iniciar en modo desarrollo
npm run dev
```

## Soporte

Para problemas o consultas, contacta al equipo de desarrollo.
