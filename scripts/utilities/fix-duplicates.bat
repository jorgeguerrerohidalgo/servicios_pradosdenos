@echo off
echo === CORRECCIÓN DE DUPLICADOS ===
echo.

echo 1. Verificando duplicados...
curl -s -X GET "http://localhost:3000/api/admin/check-duplicates" -H "Content-Type: application/json" 
echo.
echo.

echo 2. Presiona cualquier tecla para continuar con la corrección...
pause > nul

echo 3. Corrigiendo duplicados...
curl -s -X POST "http://localhost:3000/api/admin/fix-duplicates" -H "Content-Type: application/json"
echo.
echo.

echo 4. Verificación final...
curl -s -X GET "http://localhost:3000/api/admin/check-duplicates" -H "Content-Type: application/json"
echo.
echo.

echo === CORRECCIÓN COMPLETADA ===
pause
