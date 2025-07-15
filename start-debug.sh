#!/bin/bash

# Script de diagnóstico para Render
echo "=== DIAGNÓSTICO DE DEPLOY ==="
echo "Fecha: $(date)"
echo "Directorio actual: $(pwd)"
echo "Usuario: $(whoami)"
echo "Node version: $(node --version)"
echo "npm version: $(npm --version)"

echo -e "\n=== ESTRUCTURA DE ARCHIVOS ==="
ls -la

echo -e "\n=== CONTENIDO DE BACKEND ==="
if [ -d "backend" ]; then
    ls -la backend/
    echo -e "\n=== VERIFICACIÓN DE SINTAXIS ==="
    node -c backend/server.js && echo "✅ server.js: OK" || echo "❌ server.js: ERROR"
    node -c backend/middleware/security.js && echo "✅ security.js: OK" || echo "❌ security.js: ERROR"
else
    echo "❌ Directorio backend no encontrado"
fi

echo -e "\n=== CONTENIDO DE PUBLIC ==="
if [ -d "public" ]; then
    ls -la public/
else
    echo "❌ Directorio public no encontrado"
fi

echo -e "\n=== VARIABLES DE ENTORNO ==="
echo "NODE_ENV: $NODE_ENV"
echo "PORT: $PORT"
echo "DATABASE_URL: ${DATABASE_URL:0:30}..." # Solo muestra primeros 30 caracteres

echo -e "\n=== INICIANDO SERVIDOR ==="
cd backend
exec node server.js
