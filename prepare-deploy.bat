@echo off
rem Script de despliegue para Render (Windows)

echo 🚀 Preparando despliegue para Render...
echo.

echo 📋 Verificando archivos críticos...

rem Verificar archivos críticos
if exist "backend\server-production.js" (
    echo   ✅ backend\server-production.js
) else (
    echo   ❌ backend\server-production.js - FALTA
    pause
    exit /b 1
)

if exist "backend\package.json" (
    echo   ✅ backend\package.json
) else (
    echo   ❌ backend\package.json - FALTA
    pause
    exit /b 1
)

if exist "render.yaml" (
    echo   ✅ render.yaml
) else (
    echo   ❌ render.yaml - FALTA
    pause
    exit /b 1
)

if exist ".env.production" (
    echo   ✅ .env.production
) else (
    echo   ❌ .env.production - FALTA
    pause
    exit /b 1
)

echo.
echo 🔍 Verificando configuración...

findstr /c:"aws-0-us-east-2.pooler.supabase.com" render.yaml >nul
if %errorlevel% equ 0 (
    echo   ✅ URL de Supabase configurada
) else (
    echo   ❌ URL de Supabase no configurada
    pause
    exit /b 1
)

echo.
echo 📦 Verificando dependencias...
cd backend

call npm list >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Dependencias instaladas
) else (
    echo   ⚠️  Instalando dependencias...
    call npm install
)

echo.
echo 🧪 Probando servidor de producción...

rem Crear archivo de instrucciones para Render
cd ..
(
    echo # 🚀 Instrucciones de Despliegue en Render
    echo.
    echo ## 1. Configuración en Render Dashboard
    echo.
    echo ### Variables de Entorno Requeridas:
    echo ```
    echo NODE_ENV=production
    echo DATABASE_URL=postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres
    echo SESSION_SECRET=your_very_secure_session_secret
    echo JWT_SECRET=your_very_secure_jwt_secret
    echo FRONTEND_URL=https://servicios-prados-de-nos.onrender.com
    echo RENDER_EXTERNAL_URL=https://servicios-prados-de-nos.onrender.com
    echo TZ=America/Santiago
    echo LOG_LEVEL=info
    echo ```
    echo.
    echo ### Comandos de Build y Start:
    echo ```
    echo Build Command: cd backend ^&^& npm install
    echo Start Command: cd backend ^&^& node server-production.js
    echo ```
    echo.
    echo ## 2. Configuración del Servicio
    echo.
    echo - **Tipo**: Web Service
    echo - **Ambiente**: Node
    echo - **Plan**: Free
    echo - **Región**: Oregon
    echo - **Auto-Deploy**: Activado
    echo - **Branch**: main
    echo.
    echo ## 3. Health Check
    echo.
    echo - **Path**: `/health`
    echo - **Timeout**: 30 segundos
    echo.
    echo ## 4. Verificación Post-Deploy
    echo.
    echo Después del despliegue, verifica:
    echo.
    echo 1. **Health Check**: `https://servicios-prados-de-nos.onrender.com/health`
    echo 2. **Login Admin**: `https://servicios-prados-de-nos.onrender.com/admin-login.html`
    echo 3. **Login Guardia**: `https://servicios-prados-de-nos.onrender.com/guardia-login.html`
    echo.
    echo ### Credenciales de Prueba:
    echo - Admin: `admin@pradosdenos.cl` / `admin123`
    echo - Guardia: `guardia@pradosdenos.cl` / `guardia123`
    echo.
    echo ## 5. Solución de Problemas
    echo.
    echo Si hay errores 500:
    echo.
    echo 1. Verificar logs en Render Dashboard
    echo 2. Comprobar que DATABASE_URL esté correcta
    echo 3. Verificar que las tablas estén creadas en Supabase
    echo 4. Ejecutar diagnóstico: `node diagnose-production.js`
    echo.
    echo ## 6. Archivos Importantes
    echo.
    echo - `backend/server-production.js` - Servidor optimizado para producción
    echo - `render.yaml` - Configuración de Render
    echo - `.env.production` - Variables de entorno de ejemplo
    echo.
    echo ## 7. Comandos Útiles
    echo.
    echo ```bash
    echo # Probar conexión local
    echo node backend/diagnose-production.js
    echo.
    echo # Probar servidor de producción local
    echo cd backend ^&^& node server-production.js
    echo ```
) > RENDER_DEPLOY_INSTRUCTIONS.md

echo 📋 Instrucciones creadas en RENDER_DEPLOY_INSTRUCTIONS.md
echo.
echo 🎉 Preparación completada!
echo ===========================================
echo.
echo 📋 Próximos pasos:
echo 1. Hacer push a GitHub
echo 2. Configurar variables de entorno en Render Dashboard
echo 3. Activar auto-deploy desde main branch
echo 4. Verificar despliegue en https://servicios-prados-de-nos.onrender.com/health
echo.
echo 📖 Lee RENDER_DEPLOY_INSTRUCTIONS.md para detalles completos
echo.
echo ⚠️  IMPORTANTE: Configura las variables de entorno en Render Dashboard
echo.
pause
