@echo off
echo 🚀 Testeando login en producción después del deploy...
echo.

cd /d "d:\00.DESARROLLO\REPOS\servicios_pradosdenos\backend"

node test-login-after-deploy.js

echo.
echo ✅ Test completado
echo.
pause
