const { query } = require('./utils/db.js');

async function createTestCheckins() {
    try {
        console.log('🔧 Creando datos de prueba para checkins...');

        // Verificar si ya hay checkins
        const existingCheckins = await query('SELECT COUNT(*) as total FROM checkins');
        console.log('Checkins existentes:', existingCheckins[0].total);

        if (parseInt(existingCheckins[0].total) > 0) {
            console.log('✅ Ya hay checkins en la base de datos');
            return;
        }

        // Obtener plazas y guardias
        const plazas = await query('SELECT id, nombre FROM plazas WHERE activo = true LIMIT 3');
        const guardias = await query('SELECT id, nombre FROM guardias WHERE activo = true LIMIT 3');

        console.log('Plazas disponibles:', plazas.length);
        console.log('Guardias disponibles:', guardias.length);

        if (plazas.length === 0 || guardias.length === 0) {
            console.log('❌ No hay plazas o guardias activos');
            return;
        }

        // Crear checkins de los últimos 7 días
        const today = new Date();
        const testCheckins = [];

        for (let i = 0; i < 7; i++) {
            const fecha = new Date(today);
            fecha.setDate(today.getDate() - i);
            
            // 2-4 checkins por día
            const checkinsPerDay = Math.floor(Math.random() * 3) + 2;
            
            for (let j = 0; j < checkinsPerDay; j++) {
                const plazaIndex = Math.floor(Math.random() * plazas.length);
                const guardiaIndex = Math.floor(Math.random() * guardias.length);
                
                // Hora aleatoria entre 8:00 y 18:00
                const hora = Math.floor(Math.random() * 10) + 8;
                const minuto = Math.floor(Math.random() * 60);
                
                fecha.setHours(hora, minuto, 0, 0);
                
                testCheckins.push({
                    plaza_id: plazas[plazaIndex].id,
                    guardia_id: guardias[guardiaIndex].id,
                    fecha: fecha.toISOString()
                });
            }
        }

        // Insertar checkins
        for (const checkin of testCheckins) {
            await query(
                'INSERT INTO checkins (plaza_id, guardia_id, fecha) VALUES ($1, $2, $3)',
                [checkin.plaza_id, checkin.guardia_id, checkin.fecha]
            );
        }

        console.log(`✅ Se crearon ${testCheckins.length} checkins de prueba`);

        // Verificar resultado
        const finalCount = await query('SELECT COUNT(*) as total FROM checkins');
        console.log('Total checkins después de la inserción:', finalCount[0].total);

    } catch (error) {
        console.error('❌ Error creando datos de prueba:', error);
    }
}

createTestCheckins();
