@echo off
echo 🚀 Creando usuario admin y probando ambos logins...
echo.

cd /d "d:\00.DESARROLLO\REPOS\servicios_pradosdenos\backend"

echo 📊 Paso 1: Crear usuario admin con RUN
echo =====================================
node create-admin-user.js
echo.

echo 📊 Paso 2: Simular login para ambos usuarios
echo ==========================================
node simulate-login.js
echo.

echo 📊 Paso 3: Probar credenciales en producción
echo ==========================================
node test-specific-credentials.js
echo.

echo ✅ Pruebas completadas
echo.
echo 🔧 Si ambos usuarios funcionan correctamente,
echo    puedes hacer deploy con:
echo    1. git add .
echo    2. git commit -m "Fix: Admin user con RUN requerido"
echo    3. git push origin main
echo.

pause
