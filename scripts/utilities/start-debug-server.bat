@echo off
cd /d "d:\00.DESARROLLO\REPOS\servicios_pradosdenos"
echo Iniciando servidor simple para debugging...
echo.
echo Archivos disponibles:
echo   - http://localhost:3001/debug-button-final.html
echo   - http://localhost:3001/test-button-click.html
echo   - http://localhost:3001/guardia-checkin.html
echo.
echo Presiona Ctrl+C para detener el servidor
echo.
node simple-server.js
pause
