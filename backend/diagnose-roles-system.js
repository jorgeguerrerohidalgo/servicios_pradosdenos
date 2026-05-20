const { pool } = require('./db');

async function diagnoseRoles() {
    console.log('🔍 Diagnosticando roles del sistema...\n');
    
    try {
        const result = await pool.query(`
            SELECT 
                id,
                nombre,
                es_sistema,
                nivel_prioridad,
                editable,
                eliminable
            FROM roles 
            ORDER BY nivel_prioridad DESC
        `);

        console.log('📋 ROLES EN LA BASE DE DATOS:');
        console.log('='  .repeat(80));
        
        result.rows.forEach(rol => {
            const sistema = rol.es_sistema ? '🔒 SÍ' : '✏️ NO';
            const editable = rol.editable ? '✅' : '❌';
            const eliminable = rol.eliminable ? '✅' : '❌';
            
            console.log(`ID: ${rol.id}`);
            console.log(`  Nombre: ${rol.nombre}`);
            console.log(`  Es Sistema: ${sistema}`);
            console.log(`  Nivel: ${rol.nivel_prioridad}`);
            console.log(`  Editable: ${editable}`);
            console.log(`  Eliminable: ${eliminable}`);
            console.log('  ' + '-'.repeat(78));
        });

        console.log('\n📊 RESUMEN:');
        const totalRoles = result.rows.length;
        const rolesSistema = result.rows.filter(r => r.es_sistema).length;
        const rolesEditables = result.rows.filter(r => !r.es_sistema).length;

        console.log(`  Total roles: ${totalRoles}`);
        console.log(`  Roles del sistema (🔒 deshabilitados en UI): ${rolesSistema}`);
        console.log(`  Roles editables (✏️ habilitados en UI): ${rolesEditables}`);

        if (rolesEditables === 0) {
            console.log('\n⚠️ PROBLEMA DETECTADO:');
            console.log('   TODOS los roles tienen es_sistema=true');
            console.log('   Esto deshabilita TODOS los checkboxes en "Módulos Visibles"');
            console.log('\n💡 SOLUCIÓN:');
            console.log('   Ejecuta: UPDATE roles SET es_sistema = false WHERE nombre IN (\'Delegado de Plaza\', \'Supervisor\', \'Guardia\');');
        }

        process.exit(0);
    } catch (error) {
        console.error('❌ Error:', error.message);
        process.exit(1);
    }
}

diagnoseRoles();
