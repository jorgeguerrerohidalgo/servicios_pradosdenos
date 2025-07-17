#!/bin/bash

# Script de inicio para producción en Render
echo "🚀 Iniciando Portal de Servicios - Los Prados de Nos"
echo "📅 Fecha: $(date)"
echo "🌍 Entorno: $NODE_ENV"
echo "🔧 Puerto: $PORT"

# Verificar variables de entorno críticas
if [ -z "$DATABASE_URL" ]; then
    echo "❌ ERROR: DATABASE_URL no está configurada"
    exit 1
fi

if [ -z "$SESSION_SECRET" ]; then
    echo "⚠️  WARNING: SESSION_SECRET no está configurada, usando default"
    export SESSION_SECRET="checkin-secret-key-change-in-production"
fi

# Establecer zona horaria
export TZ="America/Santiago"

# Verificar que el archivo del servidor existe
if [ ! -f "backend/server-production.js" ]; then
    echo "❌ ERROR: backend/server-production.js no encontrado"
    exit 1
fi

# Cambiar al directorio backend
cd backend

# Verificar que las dependencias están instaladas
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependencias..."
    npm install
fi

# Iniciar servidor
echo "🚀 Iniciando servidor..."
exec node server-production.js
