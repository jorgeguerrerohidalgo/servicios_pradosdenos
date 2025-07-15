#!/bin/bash

# Instalar dependencias
echo "Instalando dependencias..."
npm install

# Ir al directorio backend e instalar sus dependencias
cd backend
npm install

# Verificar que server.js existe
if [ ! -f "server.js" ]; then
    echo "❌ Error: server.js no encontrado en backend/"
    exit 1
fi

echo "✅ Build completado exitosamente"
