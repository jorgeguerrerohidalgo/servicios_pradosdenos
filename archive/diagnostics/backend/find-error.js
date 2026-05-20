#!/usr/bin/env node

// Script simplificado para encontrar el error exacto en server-production.js
console.log('🔍 Diagnóstico simplificado - reproduciendo el error...');

try {
    console.log('📦 Importando dependencias básicas...');
    const express = require('express');
    console.log('✅ Express importado');
    
    console.log('📦 Importando rutas básicas...');
    const authRoutes = require('./routes/auth-debug-fixed.routes');
    console.log('✅ auth-debug-fixed.routes importado');
    
    const checkinRoutes = require('./routes/checkin.routes');
    console.log('✅ checkin.routes importado');
    
    const publicRoutes = require('./routes/public.routes');
    console.log('✅ public.routes importado');
    
    const adminRoutes = require('./routes/admin.routes');
    console.log('✅ admin.routes importado');
    
    const initRoutes = require('./routes/init.routes');
    console.log('✅ init.routes importado');
    
    console.log('📦 Importando rutas problemáticas...');
    
    // Aquí es donde probablemente falla
    const eventosRoutes = require('./routes/eventos.routes');
    console.log('✅ eventos.routes importado');
    
    const documentosRoutes = require('./routes/documentos_comunitarios.routes');
    console.log('✅ documentos_comunitarios.routes importado');
    
    console.log('🎉 Todas las rutas importadas exitosamente - el problema no está en las importaciones');
    
} catch (error) {
    console.error('❌ ERROR ENCONTRADO:', error.message);
    console.error('❌ Línea:', error.stack.split('\n')[1]);
    console.error('❌ Stack completo:', error.stack);
    
    // Intentar identificar el archivo específico
    const stack = error.stack;
    const match = stack.match(/at.*\\routes\\([^)]+)/);
    if (match) {
        console.error('❌ Archivo problemático:', match[1]);
    }
}
