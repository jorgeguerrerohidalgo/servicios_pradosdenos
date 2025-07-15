const { query } = require('./backend/utils/db');

async function verificarYCorregirDuplicados() {
  console.log('=== VERIFICACIÓN Y CORRECCIÓN DE DUPLICADOS ===\n');
  
  try {
    // 1. Verificar duplicados actuales
    console.log('🔍 Verificando duplicados actuales...');
    const duplicados = await query(`
      SELECT nombre, COUNT(*) as cantidad, 
             array_agg(id ORDER BY id) as ids
      FROM plazas
      GROUP BY nombre
      HAVING COUNT(*) > 1
      ORDER BY cantidad DESC
    `);
    
    if (duplicados.length === 0) {
      console.log('✅ No hay plazas duplicadas');
      return;
    }
    
    console.log(`📋 Encontrados ${duplicados.length} grupos de duplicados:`);
    duplicados.forEach(d => {
      console.log(`  - ${d.nombre}: ${d.cantidad} ocurrencias (IDs: ${d.ids.join(', ')})`);
    });
    
    // 2. Mostrar detalles de los duplicados
    console.log('\n📊 Detalles de plazas duplicadas:');
    for (const dup of duplicados) {
      const detalles = await query(`
        SELECT id, nombre, direccion, activo, created_at
        FROM plazas
        WHERE nombre = $1
        ORDER BY id
      `, [dup.nombre]);
      
      console.log(`\n  ${dup.nombre}:`);
      detalles.forEach(p => {
        console.log(`    ID: ${p.id}, Dirección: ${p.direccion || 'N/A'}, Activo: ${p.activo}, Creado: ${p.created_at}`);
      });
    }
    
    // 3. Proceder con la corrección
    console.log('\n🛠️ Iniciando corrección (conservando el primer registro de cada duplicado)...');
    
    // Obtener IDs a eliminar (conservar el primero)
    const idsParaEliminar = await query(`
      SELECT p2.id, p2.nombre
      FROM plazas p1
      JOIN plazas p2 ON p1.nombre = p2.nombre AND p1.id < p2.id
      WHERE p1.nombre IN (
        SELECT nombre
        FROM plazas
        GROUP BY nombre
        HAVING COUNT(*) > 1
      )
      ORDER BY p2.nombre, p2.id
    `);
    
    if (idsParaEliminar.length === 0) {
      console.log('✅ No hay duplicados para eliminar');
      return;
    }
    
    console.log(`🗑️ Se eliminarán ${idsParaEliminar.length} plazas duplicadas:`);
    idsParaEliminar.forEach(p => {
      console.log(`  - ${p.nombre} (ID: ${p.id})`);
    });
    
    const idsArray = idsParaEliminar.map(p => p.id);
    
    // 4. Eliminar tokens de plazas duplicadas
    console.log('\n🔑 Eliminando tokens de plazas duplicadas...');
    const tokensResult = await query(`
      DELETE FROM plaza_tokens
      WHERE plaza_id = ANY($1::int[])
    `, [idsArray]);
    const tokensEliminados = tokensResult.rowCount || 0;
    console.log(`✅ Eliminados ${tokensEliminados} tokens`);
    
    // 5. Eliminar checkins de plazas duplicadas
    console.log('\n📝 Eliminando checkins de plazas duplicadas...');
    const checkinsResult = await query(`
      DELETE FROM checkins
      WHERE plaza_id = ANY($1::int[])
    `, [idsArray]);
    const checkinsEliminados = checkinsResult.rowCount || 0;
    console.log(`✅ Eliminados ${checkinsEliminados} checkins`);
    
    // 6. Actualizar referencias en admin_users
    console.log('\n👥 Actualizando referencias de administradores...');
    await query(`
      UPDATE admin_users
      SET plaza_id = NULL
      WHERE plaza_id = ANY($1::int[])
    `, [idsArray]);
    console.log('✅ Referencias actualizadas');
    
    // 7. Eliminar plazas duplicadas
    console.log('\n🗑️ Eliminando plazas duplicadas...');
    const plazasResult = await query(`
      DELETE FROM plazas
      WHERE id = ANY($1::int[])
    `, [idsArray]);
    const plazasEliminadas = plazasResult.rowCount || 0;
    console.log(`✅ Eliminadas ${plazasEliminadas} plazas duplicadas`);
    
    // 8. Verificación final
    console.log('\n🔍 Verificación final...');
    const duplicadosFinales = await query(`
      SELECT nombre, COUNT(*) as cantidad
      FROM plazas
      GROUP BY nombre
      HAVING COUNT(*) > 1
    `);
    
    if (duplicadosFinales.length === 0) {
      console.log('✅ ¡Corrección completada exitosamente! No hay más duplicados.');
    } else {
      console.log('⚠️ Aún quedan duplicados:');
      duplicadosFinales.forEach(d => {
        console.log(`  - ${d.nombre}: ${d.cantidad} ocurrencias`);
      });
    }
    
    // 9. Mostrar plazas finales
    console.log('\n📋 Plazas actuales en el sistema:');
    const plazasFinales = await query(`
      SELECT id, nombre, direccion, activo
      FROM plazas
      ORDER BY id
    `);
    
    plazasFinales.forEach(p => {
      console.log(`  ID: ${p.id}, Nombre: ${p.nombre}, Activo: ${p.activo}`);
    });
    
    console.log('\n=== RESUMEN ===');
    console.log(`✅ Plazas eliminadas: ${plazasEliminadas}`);
    console.log(`🔑 Tokens eliminados: ${tokensEliminados}`);
    console.log(`📝 Checkins eliminados: ${checkinsEliminados}`);
    console.log(`📊 Total de plazas restantes: ${plazasFinales.length}`);
    
  } catch (error) {
    console.error('❌ Error:', error);
    throw error;
  }
}

// Ejecutar verificación y corrección
verificarYCorregirDuplicados()
  .then(() => {
    console.log('\n🎉 Proceso completado exitosamente');
    process.exit(0);
  })
  .catch(error => {
    console.error('\n💥 Error en el proceso:', error);
    process.exit(1);
  });
