const { Pool } = require('pg');
require('dotenv').config();

// Configuración de la base de datos
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

async function query(text, params) {
  try {
    const result = await pool.query(text, params);
    return result.rows;
  } catch (error) {
    console.error('Error en query:', error);
    throw error;
  }
}

async function fixDuplicates() {
  console.log('=== INICIANDO CORRECCIÓN DE DUPLICADOS ===');
  
  try {
    // Verificar duplicados actuales
    console.log('🔍 Verificando duplicados actuales...');
    const duplicados = await query(`
      SELECT nombre, COUNT(*) as cantidad
      FROM plazas
      GROUP BY nombre
      HAVING COUNT(*) > 1
      ORDER BY cantidad DESC
    `);
    
    if (duplicados.length === 0) {
      console.log('✅ No hay plazas duplicadas para corregir');
      return;
    }
    
    console.log('📋 Plazas duplicadas encontradas:');
    duplicados.forEach(d => {
      console.log(`  - ${d.nombre}: ${d.cantidad} ocurrencias`);
    });
    
    // Mostrar detalles de las plazas duplicadas
    console.log('\n🔍 Detalles de plazas duplicadas:');
    const detalles = await query(`
      SELECT id, nombre, direccion, descripcion, activo, created_at
      FROM plazas
      WHERE nombre IN (
        SELECT nombre
        FROM plazas
        GROUP BY nombre
        HAVING COUNT(*) > 1
      )
      ORDER BY nombre, id
    `);
    
    detalles.forEach(p => {
      console.log(`  ID: ${p.id}, Nombre: ${p.nombre}, Activo: ${p.activo}, Creado: ${p.created_at}`);
    });
    
    // Obtener IDs de plazas duplicadas (conservar la primera)
    console.log('\n🗑️ Identificando plazas a eliminar...');
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
    `);
    
    console.log(`📝 Se eliminarán ${idsParaEliminar.length} plazas duplicadas:`);
    idsParaEliminar.forEach(p => {
      console.log(`  - ID: ${p.id}, Nombre: ${p.nombre}`);
    });
    
    if (idsParaEliminar.length === 0) {
      console.log('✅ No hay plazas duplicadas para eliminar');
      return;
    }
    
    console.log('\n🛠️ Iniciando eliminación...');
    
    // Obtener arrays de IDs
    const idsArray = idsParaEliminar.map(row => row.id);
    
    // 1. Eliminar tokens de plazas duplicadas
    console.log('🔑 Eliminando tokens de plazas duplicadas...');
    const tokensResult = await query(`
      DELETE FROM plaza_tokens
      WHERE plaza_id = ANY($1::int[])
    `, [idsArray]);
    const tokensEliminados = tokensResult.rowCount || 0;
    console.log(`✅ Eliminados ${tokensEliminados} tokens`);
    
    // 2. Eliminar checkins asociados a plazas duplicadas
    console.log('📝 Eliminando checkins de plazas duplicadas...');
    const checkinsResult = await query(`
      DELETE FROM checkins
      WHERE plaza_id = ANY($1::int[])
    `, [idsArray]);
    const checkinsAfectados = checkinsResult.rowCount || 0;
    console.log(`✅ Eliminados ${checkinsAfectados} checkins`);
    
    // 3. Actualizar admin_users para quitar referencias a plazas duplicadas
    console.log('👥 Actualizando referencias de administradores...');
    await query(`
      UPDATE admin_users
      SET plaza_id = NULL
      WHERE plaza_id = ANY($1::int[])
    `, [idsArray]);
    console.log('✅ Referencias de administradores actualizadas');
    
    // 4. Finalmente, eliminar las plazas duplicadas
    console.log('🗑️ Eliminando plazas duplicadas...');
    const plazasResult = await query(`
      DELETE FROM plazas
      WHERE id = ANY($1::int[])
    `, [idsArray]);
    const plazasEliminadas = plazasResult.rowCount || 0;
    console.log(`✅ Eliminadas ${plazasEliminadas} plazas duplicadas`);
    
    // Verificación final
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
      console.log('⚠️ Aún hay duplicados:');
      duplicadosFinales.forEach(d => {
        console.log(`  - ${d.nombre}: ${d.cantidad} ocurrencias`);
      });
    }
    
    // Mostrar plazas finales
    console.log('\n📋 Plazas actuales:');
    const plazasFinales = await query(`
      SELECT id, nombre, direccion, activo
      FROM plazas
      ORDER BY id
    `);
    
    plazasFinales.forEach(p => {
      console.log(`  ID: ${p.id}, Nombre: ${p.nombre}, Activo: ${p.activo}`);
    });
    
    console.log('\n=== RESUMEN ===');
    console.log(`✅ Plazas duplicadas eliminadas: ${plazasEliminadas}`);
    console.log(`🔑 Tokens eliminados: ${tokensEliminados}`);
    console.log(`📝 Checkins afectados: ${checkinsAfectados}`);
    console.log(`📊 Total de plazas restantes: ${plazasFinales.length}`);
    
  } catch (error) {
    console.error('❌ Error durante la corrección:', error);
    throw error;
  }
}

// Ejecutar la corrección
fixDuplicates()
  .then(() => {
    console.log('\n🎉 Corrección completada exitosamente');
    process.exit(0);
  })
  .catch(error => {
    console.error('\n💥 Error en la corrección:', error);
    process.exit(1);
  });
