@echo off
echo 🚀 Preparando deploy con correcciones...
echo.

cd /d "d:\00.DESARROLLO\REPOS\servicios_pradosdenos"

echo ⚙️ Verificando archivos críticos...
if exist "backend\routes\auth-debug.routes.js" (
    echo ✅ auth-debug.routes.js encontrado
) else (
    echo ❌ auth-debug.routes.js NO encontrado
    pause
    exit /b 1
)

if exist "backend\routes\eventos.routes.js" (
    echo ✅ eventos.routes.js encontrado
) else (
    echo ❌ eventos.routes.js NO encontrado
    pause
    exit /b 1
)

if exist "backend\routes\documentos_new.routes.js" (
    echo ✅ documentos_new.routes.js encontrado
) else (
    echo ❌ documentos_new.routes.js NO encontrado
    pause
    exit /b 1
)

if exist "backend\server-production.js" (
    echo ✅ server-production.js encontrado
) else (
    echo ❌ server-production.js NO encontrado
    pause
    exit /b 1
)

echo.
echo 📦 Archivos verificados correctamente
echo.

echo 🔧 Comandos para deploy manual:
echo.
echo 1. git add .
echo 2. git commit -m "Fix: Corregir errores 500 en login y paginación eventos"
echo 3. git push origin main
echo.
echo 🌐 URL de producción: https://servicios-prados-de-nos.onrender.com
echo.

pause
