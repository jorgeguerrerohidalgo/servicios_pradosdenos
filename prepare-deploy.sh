#!/bin/bash

# Script de despliegue para Render
echo "🚀 Preparando despliegue para Render..."

# Verificar archivos críticos
echo "📋 Verificando archivos críticos..."

critical_files=(
    "backend/server-production.js"
    "backend/package.json"
    "render.yaml"
    ".env.production"
)

for file in "${critical_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file - FALTA"
        exit 1
    fi
done

# Verificar configuración de base de datos
echo "🔍 Verificando configuración..."

if grep -q "aws-0-us-east-2.pooler.supabase.com" render.yaml; then
    echo "  ✅ URL de Supabase configurada"
else
    echo "  ❌ URL de Supabase no configurada"
    exit 1
fi

# Verificar dependencias
echo "📦 Verificando dependencias..."
cd backend
if npm list > /dev/null 2>&1; then
    echo "  ✅ Dependencias instaladas"
else
    echo "  ⚠️  Instalando dependencias..."
    npm install
fi

# Test de servidor de producción
echo "🧪 Probando servidor de producción..."
timeout 10s node server-production.js > /dev/null 2>&1 &
SERVER_PID=$!

sleep 3

if kill -0 $SERVER_PID 2>/dev/null; then
    echo "  ✅ Servidor de producción inicia correctamente"
    kill $SERVER_PID
else
    echo "  ❌ Servidor de producción tiene problemas"
    exit 1
fi

cd ..

# Crear archivo de instrucciones para Render
cat > RENDER_DEPLOY_INSTRUCTIONS.md << 'EOF'
# 🚀 Instrucciones de Despliegue en Render

## 1. Configuración en Render Dashboard

### Variables de Entorno Requeridas:
```
NODE_ENV=production
DATABASE_URL=postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres
SESSION_SECRET=your_very_secure_session_secret
JWT_SECRET=your_very_secure_jwt_secret
FRONTEND_URL=https://servicios-prados-de-nos.onrender.com
RENDER_EXTERNAL_URL=https://servicios-prados-de-nos.onrender.com
TZ=America/Santiago
LOG_LEVEL=info
```

### Comandos de Build y Start:
```
Build Command: cd backend && npm install
Start Command: cd backend && node server-production.js
```

## 2. Configuración del Servicio

- **Tipo**: Web Service
- **Ambiente**: Node
- **Plan**: Free
- **Región**: Oregon
- **Auto-Deploy**: Activado
- **Branch**: main

## 3. Health Check

- **Path**: `/health`
- **Timeout**: 30 segundos

## 4. Verificación Post-Deploy

Después del despliegue, verifica:

1. **Health Check**: `https://servicios-prados-de-nos.onrender.com/health`
2. **Login Admin**: `https://servicios-prados-de-nos.onrender.com/admin-login.html`
3. **Login Guardia**: `https://servicios-prados-de-nos.onrender.com/guardia-login.html`

### Credenciales de Prueba:
- Admin: `admin@pradosdenos.cl` / `admin123`
- Guardia: `guardia@pradosdenos.cl` / `guardia123`

## 5. Solución de Problemas

Si hay errores 500:

1. Verificar logs en Render Dashboard
2. Comprobar que DATABASE_URL esté correcta
3. Verificar que las tablas estén creadas en Supabase
4. Ejecutar diagnóstico: `node diagnose-production.js`

## 6. Logs Útiles

```bash
# Ver logs en tiempo real
render logs --tail

# Verificar estado del servicio
render ps

# Restart manual
render restart
```

## 7. Estructura de Archivos Desplegados

```
/
├── backend/
│   ├── server-production.js  (Servidor principal)
│   ├── package.json
│   ├── routes/
│   └── middleware/
├── public/
│   ├── admin-login.html
│   ├── guardia-login.html
│   └── otros archivos estáticos
└── render.yaml  (Configuración de Render)
```

## 8. Monitoreo

- **Uptime**: Render monitorea automáticamente
- **Logs**: Disponibles en Dashboard
- **Métricas**: CPU, memoria, requests

EOF

echo "📋 Instrucciones creadas en RENDER_DEPLOY_INSTRUCTIONS.md"

echo ""
echo "🎉 Preparación completada!"
echo "==========================================="
echo ""
echo "📋 Próximos pasos:"
echo "1. Hacer push a GitHub"
echo "2. Configurar variables de entorno en Render"
echo "3. Activar auto-deploy"
echo "4. Verificar despliegue"
echo ""
echo "📖 Lee RENDER_DEPLOY_INSTRUCTIONS.md para detalles completos"
