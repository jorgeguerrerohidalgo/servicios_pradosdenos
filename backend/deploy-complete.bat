@echo off
echo 🚀 Deploy completo con server-production.js
echo.

cd /d "d:\00.DESARROLLO\REPOS\servicios_pradosdenos"

echo 📊 Paso 1: Verificar dependencias
echo =================================
cd backend
node check-dependencies.js
echo.

echo 📊 Paso 2: Verificar archivos críticos
echo ======================================
if exist "routes\auth-debug-fixed.routes.js" (
    echo ✅ auth-debug-fixed.routes.js - OK
) else (
    echo ❌ auth-debug-fixed.routes.js - FALTA
)

if exist "server-production.js" (
    echo ✅ server-production.js - OK
) else (
    echo ❌ server-production.js - FALTA
)

echo.

echo 📊 Paso 3: Verificar package.json
echo ================================
findstr "server-production.js" package.json
echo.

echo 📊 Paso 4: Git status
echo ====================
cd ..
git status
echo.

echo 📊 Paso 5: Hacer deploy
echo ======================
git add .
git commit -m "Fix: Deploy con server-production.js y auth-debug-fixed.routes.js"
git push origin main
echo.

echo ✅ Deploy completado
echo.
echo 🌐 Verifica en: https://servicios-prados-de-nos.onrender.com
echo.

pause
