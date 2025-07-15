@echo off
echo 🚀 Ejecutando despliegue a GitHub para Render...
echo.

REM Cambiar al directorio del proyecto
cd /d D:\00.DESARROLLO\REPOS\servicios_pradosdenos

REM Verificar que estamos en el directorio correcto
if not exist "backend\server-production.js" (
    echo ❌ Error: No se encuentra server-production.js
    echo Verifica que estés en el directorio correcto
    pause
    exit /b 1
)

echo 📋 Agregando archivos al repositorio...
git add .

echo 📝 Creando commit...
git commit -m "🚀 Fix: Servidor de producción optimizado para Render

- Nuevo server-production.js optimizado para producción
- Configuración de CORS específica para Render
- URL de Supabase corregida (Transaction pooler IPv4)
- Variables de entorno configuradas en render.yaml
- Manejo de errores mejorado con logging detallado
- Scripts de diagnóstico y preparación de despliegue
- Usuarios de prueba creados correctamente
- Documentación completa de despliegue

Soluciona errores 500 en:
- /api/auth/login
- /api/eventos
- /api/documentos

Credenciales de prueba:
- Admin: admin@pradosdenos.cl / admin123
- Guardia: guardia@pradosdenos.cl / guardia123"

if %errorlevel% neq 0 (
    echo ❌ Error en el commit
    pause
    exit /b 1
)

echo 🚀 Haciendo push a GitHub...
git push origin main

if %errorlevel% neq 0 (
    echo ❌ Error en el push
    pause
    exit /b 1
)

echo.
echo ✅ Despliegue completado exitosamente!
echo.
echo 📋 Próximos pasos:
echo 1. Ve a tu dashboard de Render: https://dashboard.render.com
echo 2. Busca el servicio "servicios-prados-de-nos"
echo 3. Verifica que el auto-deploy se haya activado
echo 4. Configura las variables de entorno si no están:
echo    - NODE_ENV=production
echo    - DATABASE_URL=postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres
echo    - SESSION_SECRET=your_very_secure_session_secret
echo    - JWT_SECRET=your_very_secure_jwt_secret
echo    - FRONTEND_URL=https://servicios-prados-de-nos.onrender.com
echo    - RENDER_EXTERNAL_URL=https://servicios-prados-de-nos.onrender.com
echo    - TZ=America/Santiago
echo.
echo 🔍 Para verificar el despliegue:
echo https://servicios-prados-de-nos.onrender.com/health
echo.
echo 🧪 Para probar el login:
echo https://servicios-prados-de-nos.onrender.com/admin-login.html
echo Credenciales: admin@pradosdenos.cl / admin123
echo.
pause
