/**
 * TAREAS PROGRAMADAS (CRON JOBS)
 * Automatización de procesos periódicos
 * Autor: Sistema
 * Fecha: 19/05/2026
 */

const cron = require('node-cron');
const { pool } = require('./utils/db');

/**
 * Actualizar estados de pagos vencidos
 * Se ejecuta diariamente a las 00:01 AM
 * Cambia pagos 'pendientes' a 'vencidos' si ya pasó la fecha de vencimiento
 */
const actualizarEstadosPagos = cron.schedule('1 0 * * *', async () => {
    try {
        console.log('\n🔄 [CRON] Iniciando actualización automática de estados de pagos...');
        console.log('📅 Fecha/Hora:', new Date().toLocaleString('es-CL', { timeZone: 'America/Santiago' }));
        
        const result = await pool.query('SELECT * FROM actualizar_estados_pagos()');
        
        const { actualizados, mensaje } = result.rows[0];
        
        console.log(`✅ [CRON] ${mensaje}`);
        console.log(`📊 Pagos actualizados a vencido: ${actualizados}`);
        console.log('─'.repeat(60) + '\n');
        
    } catch (error) {
        console.error('❌ [CRON ERROR] Error al actualizar estados de pagos:', error.message);
        console.error('Stack:', error.stack);
    }
}, {
    scheduled: true,
    timezone: 'America/Santiago'
});

/**
 * Inicializar todas las tareas programadas
 */
function initCronJobs() {
    console.log('\n' + '='.repeat(60));
    console.log('⏰ TAREAS PROGRAMADAS INICIADAS');
    console.log('='.repeat(60));
    console.log('✅ Actualización de estados de pagos: Diaria a las 00:01 AM (Santiago)');
    console.log('='.repeat(60) + '\n');
    
    // Ejecutar inmediatamente al iniciar (para pruebas en desarrollo)
    if (process.env.NODE_ENV === 'development') {
        console.log('🔧 [DEV MODE] Ejecutando actualización inicial de estados...\n');
        pool.query('SELECT * FROM actualizar_estados_pagos()')
            .then(result => {
                const { actualizados, mensaje } = result.rows[0];
                console.log(`✅ [INICIAL] ${mensaje}`);
                console.log(`📊 Pagos actualizados: ${actualizados}\n`);
            })
            .catch(error => {
                console.error('❌ [INICIAL ERROR]', error.message);
            });
    }
}

/**
 * Detener todas las tareas programadas
 */
function stopCronJobs() {
    console.log('⏹️  Deteniendo tareas programadas...');
    actualizarEstadosPagos.stop();
}

module.exports = {
    initCronJobs,
    stopCronJobs,
    actualizarEstadosPagos
};
