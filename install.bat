@echo off
rem Script de instalación para Los Prados de Nos (Windows)
rem Sistema de Check-in con Supabase

echo.
echo 🏗️  Configurando sistema Los Prados de Nos...
echo ===========================================
echo.

rem Verificar que estamos en el directorio correcto
if not exist "backend\server.js" (
    echo ❌ Error: No se encontró backend\server.js
    echo Ejecuta este script desde el directorio raíz del proyecto
    pause
    exit /b 1
)

echo [PASO 1] Verificando dependencias...

rem Verificar Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Node.js no está instalado. Instala Node.js y vuelve a intentar.
    pause
    exit /b 1
)

rem Verificar npm
where npm >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ npm no está instalado. Instala npm y vuelve a intentar.
    pause
    exit /b 1
)

echo ✅ Node.js y npm están instalados
echo.

echo [PASO 2] Instalando dependencias del backend...

cd backend
call npm install

if %errorlevel% neq 0 (
    echo ❌ Error instalando dependencias del backend
    pause
    exit /b 1
)

echo ✅ Dependencias del backend instaladas
cd ..
echo.

echo [PASO 3] Configurando variables de entorno...

rem Crear archivo .env si no existe
if not exist "backend\.env" (
    (
        echo # Variables de entorno para Los Prados de Nos
        echo NODE_ENV=development
        echo PORT=3000
        echo.
        echo # Base de datos Supabase
        echo DATABASE_URL=postgresql://postgres:[TU_PASSWORD]@db.[TU_PROJECT_ID].supabase.co:5432/postgres
        echo.
        echo # Configuración de sesiones
        echo SESSION_SECRET=tu_secreto_super_seguro_aqui_cambiar_en_produccion
        echo.
        echo # Configuración de seguridad
        echo ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
        echo.
        echo # Configuración de archivos
        echo UPLOAD_DIR=uploads
        echo MAX_FILE_SIZE=10485760
        echo.
        echo # Configuración de email (opcional^)
        echo EMAIL_HOST=smtp.gmail.com
        echo EMAIL_PORT=587
        echo EMAIL_USER=tu_email@gmail.com
        echo EMAIL_PASS=tu_password_de_app
        echo.
        echo # Configuración de logs
        echo LOG_LEVEL=info
        echo LOG_FILE=logs/app.log
    ) > backend\.env

    echo ⚠️  Archivo .env creado. DEBES configurar las variables de Supabase:
    echo   - DATABASE_URL: URL de conexión a tu base de datos Supabase
    echo   - SESSION_SECRET: Cambia por un secreto seguro
    echo.
    echo Edita el archivo backend\.env antes de continuar.
) else (
    echo ✅ Archivo .env ya existe
)
echo.

echo [PASO 4] Creando directorios necesarios...

rem Crear directorios si no existen
if not exist "backend\logs" mkdir backend\logs
if not exist "backend\uploads" mkdir backend\uploads
if not exist "backend\uploads\documentos" mkdir backend\uploads\documentos
if not exist "backend\uploads\eventos" mkdir backend\uploads\eventos

echo ✅ Directorios creados
echo.

echo [PASO 5] Configurando scripts de utilidad...

rem Crear script para ejecutar migraciones
(
    echo const fs = require('fs'^);
    echo const path = require('path'^);
    echo const { Client } = require('pg'^);
    echo.
    echo async function runMigrations(^) {
    echo     console.log('🔄 Ejecutando migraciones...'^);
    echo     
    echo     const client = new Client({
    echo         connectionString: process.env.DATABASE_URL,
    echo         ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
    echo     }^);
    echo     
    echo     try {
    echo         await client.connect(^);
    echo         console.log('✅ Conectado a la base de datos'^);
    echo         
    echo         // Leer script de configuración completa
    echo         const sqlScript = fs.readFileSync(path.join(__dirname, '..', 'supabase_complete_setup.sql'^), 'utf8'^);
    echo         
    echo         // Ejecutar script
    echo         await client.query(sqlScript^);
    echo         console.log('✅ Migraciones ejecutadas correctamente'^);
    echo         
    echo         // Verificar tablas
    echo         const result = await client.query(`
    echo             SELECT table_name
    echo             FROM information_schema.tables 
    echo             WHERE table_schema = 'public' 
    echo             AND table_name IN ('plazas', 'plaza_tokens', 'guardias', 'admin_users', 'checkins', 'security_logs', 'eventos', 'documentos'^)
    echo             ORDER BY table_name
    echo         `^);
    echo         
    echo         console.log('\n📋 Tablas verificadas:'^);
    echo         result.rows.forEach(row =^> {
    echo             console.log(`  ✅ ${row.table_name}`^);
    echo         }^);
    echo         
    echo     } catch (error^) {
    echo         console.error('❌ Error ejecutando migraciones:', error.message^);
    echo         process.exit(1^);
    echo     } finally {
    echo         await client.end(^);
    echo     }
    echo }
    echo.
    echo runMigrations(^);
) > backend\run-migrations.js

echo ✅ Scripts de utilidad creados
echo.

echo [PASO 6] Configurando credenciales de prueba...

rem Crear script de usuarios de prueba
(
    echo const bcrypt = require('bcrypt'^);
    echo const { Client } = require('pg'^);
    echo.
    echo async function setupTestUsers(^) {
    echo     console.log('👥 Configurando usuarios de prueba...'^);
    echo     
    echo     const client = new Client({
    echo         connectionString: process.env.DATABASE_URL,
    echo         ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
    echo     }^);
    echo     
    echo     try {
    echo         await client.connect(^);
    echo         
    echo         // Hash de contraseñas
    echo         const adminPassword = await bcrypt.hash('admin123', 12^);
    echo         const guardiaPassword = await bcrypt.hash('guardia123', 12^);
    echo         
    echo         // Insertar admin
    echo         await client.query(`
    echo             INSERT INTO admin_users (nombre, apellido_paterno, apellido_materno, run, email, fecha_nacimiento, direccion, plaza_id, password_hash^)
    echo             VALUES ('Admin', 'Sistema', 'Principal', '11.111.111-1', 'admin@pradosdenos.cl', '1990-01-01', 'Centro de Control', 1, $1^)
    echo             ON CONFLICT (email^) DO UPDATE SET password_hash = $1
    echo         `, [adminPassword]^);
    echo         
    echo         // Insertar guardia
    echo         await client.query(`
    echo             INSERT INTO guardias (nombre, rut, email, password, telefono^)
    echo             VALUES ('Guardia', '22.222.222-2', 'guardia@pradosdenos.cl', $1, '+56912345678'^)
    echo             ON CONFLICT (email^) DO UPDATE SET password = $1
    echo         `, [guardiaPassword]^);
    echo         
    echo         console.log('✅ Usuarios de prueba configurados:'^);
    echo         console.log('  👤 Admin: admin@pradosdenos.cl / admin123'^);
    echo         console.log('  🛡️  Guardia: guardia@pradosdenos.cl / guardia123'^);
    echo         
    echo     } catch (error^) {
    echo         console.error('❌ Error configurando usuarios:', error.message^);
    echo         process.exit(1^);
    echo     } finally {
    echo         await client.end(^);
    echo     }
    echo }
    echo.
    echo setupTestUsers(^);
) > backend\setup-test-users.js

echo ✅ Script de usuarios de prueba creado
echo.

echo [PASO 7] Creando documentación...

rem Crear documentación
(
    echo # 🏗️ Instalación - Los Prados de Nos
    echo.
    echo ## Requisitos Previos
    echo.
    echo - Node.js 16+ instalado
    echo - Cuenta en Supabase
    echo - Proyecto de Supabase creado
    echo.
    echo ## Pasos de Instalación
    echo.
    echo ### 1. Configurar Supabase
    echo.
    echo 1. Ve a https://supabase.com
    echo 2. Crea un nuevo proyecto
    echo 3. Ve a Settings ^> Database
    echo 4. Copia la URL de conexión PostgreSQL
    echo.
    echo ### 2. Configurar Variables de Entorno
    echo.
    echo Edita el archivo `backend\.env`:
    echo.
    echo ```env
    echo DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT_ID].supabase.co:5432/postgres
    echo SESSION_SECRET=tu_secreto_super_seguro_aqui
    echo ```
    echo.
    echo ### 3. Ejecutar Migraciones
    echo.
    echo ```cmd
    echo cd backend
    echo npm run migrate
    echo ```
    echo.
    echo ### 4. Configurar Usuarios de Prueba
    echo.
    echo ```cmd
    echo npm run setup-users
    echo ```
    echo.
    echo ### 5. Iniciar el Servidor
    echo.
    echo ```cmd
    echo npm start
    echo # o para desarrollo:
    echo npm run dev
    echo ```
    echo.
    echo ## Credenciales de Prueba
    echo.
    echo - **Admin**: admin@pradosdenos.cl / admin123
    echo - **Guardia**: guardia@pradosdenos.cl / guardia123
    echo.
    echo ## URLs del Sistema
    echo.
    echo - Admin: http://localhost:3000/admin-login.html
    echo - Guardia: http://localhost:3000/guardia-login.html
    echo - Portal: http://localhost:3000/login.html
    echo.
    echo ## Comandos Útiles
    echo.
    echo ```cmd
    echo # Ejecutar migraciones
    echo npm run migrate
    echo.
    echo # Configurar usuarios de prueba
    echo npm run setup-users
    echo.
    echo # Probar conexión a la base de datos
    echo npm run test
    echo.
    echo # Iniciar en modo desarrollo
    echo npm run dev
    echo ```
    echo.
    echo ## Soporte
    echo.
    echo Para problemas o consultas, contacta al equipo de desarrollo.
) > README_INSTALACION.md

echo ✅ Documentación generada
echo.

echo [PASO 8] Verificación final...

rem Verificar archivos importantes
set "files_missing=false"
if not exist "backend\server.js" set "files_missing=true"
if not exist "backend\package.json" set "files_missing=true"
if not exist "backend\.env" set "files_missing=true"
if not exist "backend\run-migrations.js" set "files_missing=true"
if not exist "backend\setup-test-users.js" set "files_missing=true"
if not exist "supabase_complete_setup.sql" set "files_missing=true"
if not exist "README_INSTALACION.md" set "files_missing=true"

if "%files_missing%"=="false" (
    echo ✅ Todos los archivos necesarios están presentes
) else (
    echo ⚠️  Algunos archivos pueden faltar, revisa manualmente
)

echo.
echo 🎉 Instalación completada!
echo ===========================================
echo.
echo Próximos pasos:
echo 1. Configura tu base de datos Supabase en backend\.env
echo 2. Ejecuta: cd backend ^&^& npm run migrate
echo 3. Ejecuta: npm run setup-users
echo 4. Ejecuta: npm start
echo.
echo URLs del sistema:
echo   - Admin: http://localhost:3000/admin-login.html
echo   - Guardia: http://localhost:3000/guardia-login.html
echo.
echo Credenciales de prueba:
echo   - Admin: admin@pradosdenos.cl / admin123
echo   - Guardia: guardia@pradosdenos.cl / guardia123
echo.
echo 📖 Lee README_INSTALACION.md para más detalles
echo.
pause
