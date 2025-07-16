@echo off
echo 🚀 Iniciando servidor de produccion...
echo.

cd /d "d:\00.DESARROLLO\REPOS\servicios_pradosdenos\backend"

echo ⚙️ Configurando variables de entorno...
set NODE_ENV=production
set DATABASE_URL=postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres

echo 📦 Usando archivo: server-production.js
echo.

node server-production.js

pause
