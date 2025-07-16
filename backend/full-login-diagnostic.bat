@echo off
echo 🚀 Preparando corrección completa para login...
echo.

cd /d "d:\00.DESARROLLO\REPOS\servicios_pradosdenos\backend"

echo 📊 Paso 1: Diagnosticar base de datos
echo ================================
node diagnostic-database.js
echo.

echo 📊 Paso 2: Configurar usuarios correctos
echo =======================================
node setup-correct-users.js
echo.

echo 📊 Paso 3: Simular login localmente
echo ==================================
node simulate-login.js
echo.

echo 📊 Paso 4: Probar credenciales en producción
echo ==========================================
node test-specific-credentials.js
echo.

echo ✅ Diagnóstico completo terminado
echo.
echo 🔧 Si los usuarios fueron creados correctamente,
echo    puedes hacer deploy con:
echo    1. git add .
echo    2. git commit -m "Fix: Configurar usuarios correctos para login"
echo    3. git push origin main
echo.

pause
