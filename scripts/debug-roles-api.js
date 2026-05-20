/**
 * Debug script para verificar funcionamiento de endpoints de roles
 * Ejecutar en el servidor para ver errores específicos
 */

const { pool } = require('../backend/utils/db');

async function testUsuariosConRoles() {
  console.log('🔍 Probando query de usuarios-con-roles...\n');
  
  try {
    const query = `
      SELECT 
        u.id as user_id,
        u.nombre,
        u.email,
        u.activo as usuario_activo,
        json_agg(
          json_build_object(
            'role_id', r.id,
            'role_codigo', r.codigo,
            'role_nombre', r.nombre,
            'nivel_prioridad', r.nivel_prioridad,
            'scope_type', ur.scope_type,
            'scope_id', ur.scope_id,
            'plaza_nombre', p.nombre,
            'asignado_en', ur.asignado_en,
            'activo', ur.activo
          ) ORDER BY r.nivel_prioridad DESC
        ) as roles
      FROM admin_users u
      LEFT JOIN user_roles ur ON u.id = ur.user_id AND ur.activo = TRUE
      LEFT JOIN roles r ON ur.role_id = r.id
      LEFT JOIN plazas p ON ur.scope_id = p.id AND ur.scope_type = 'plaza'
      WHERE u.activo = TRUE
      GROUP BY u.id, u.nombre, u.email, u.activo
      ORDER BY u.nombre
    `;
    
    console.log('📝 Ejecutando query...');
    const result = await pool.query(query);
    
    console.log(`✅ Query exitosa: ${result.rows.length} usuarios encontrados\n`);
    console.log('🔍 Resultados:');
    console.log(JSON.stringify(result.rows, null, 2));
    
  } catch (error) {
    console.error('❌ Error en query:');
    console.error('Mensaje:', error.message);
    console.error('Código:', error.code);
    console.error('Detalle:', error.detail);
    console.error('Stack:', error.stack);
  }
}

async function testPermisos() {
  console.log('\n🔍 Probando query de permisos...\n');
  
  try {
    const query = `
      SELECT 
        id,
        codigo,
        modulo,
        accion,
        descripcion,
        activo
      FROM permissions
      WHERE activo = TRUE
      ORDER BY modulo, accion
    `;
    
    console.log('📝 Ejecutando query...');
    const result = await pool.query(query);
    
    console.log(`✅ Query exitosa: ${result.rows.length} permisos encontrados\n`);
    console.log('🔍 Primeros 5 resultados:');
    console.log(JSON.stringify(result.rows.slice(0, 5), null, 2));
    
  } catch (error) {
    console.error('❌ Error en query:');
    console.error('Mensaje:', error.message);
    console.error('Código:', error.code);
    console.error('Detalle:', error.detail);
  }
}

async function checkTables() {
  console.log('\n🔍 Verificando existencia de tablas...\n');
  
  const tables = ['admin_users', 'user_roles', 'roles', 'permissions', 'plazas'];
  
  for (const table of tables) {
    try {
      const result = await pool.query(`
        SELECT COUNT(*) as count
        FROM ${table}
      `);
      console.log(`✅ ${table}: ${result.rows[0].count} registros`);
    } catch (error) {
      console.error(`❌ ${table}: Error - ${error.message}`);
    }
  }
}

async function main() {
  console.log('========================================');
  console.log('DEBUG: Endpoints de Roles');
  console.log('========================================\n');
  
  await checkTables();
  await testPermisos();
  await testUsuariosConRoles();
  
  console.log('\n========================================');
  console.log('Diagnóstico completado');
  console.log('========================================\n');
  
  process.exit(0);
}

main().catch(error => {
  console.error('❌ Error fatal:', error);
  process.exit(1);
});
