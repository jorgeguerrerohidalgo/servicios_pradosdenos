/**
 * SCRIPT DE PRUEBA RBAC
 * Prueba el sistema de permisos con diferentes usuarios
 * Ejecutar: node backend/test-rbac.js
 */

const { query } = require('./utils/db');
const { getUserPermissions, getUserRoles, hasPermission } = require('./utils/permissions');

async function testRBAC() {
  console.log('\n🧪 ===============================================');
  console.log('   PRUEBA DEL SISTEMA RBAC');
  console.log('================================================\n');

  try {
    // 1. Obtener usuarios del sistema
    console.log('📋 1. Obteniendo usuarios del sistema...\n');
    const users = await query(`
      SELECT u.id, u.nombre, u.email, 
             r.codigo as rol_codigo, 
             r.nombre as rol_nombre,
             r.nivel_prioridad
      FROM admin_users u
      INNER JOIN user_roles ur ON u.id = ur.user_id
      INNER JOIN roles r ON ur.role_id = r.id
      WHERE u.activo = TRUE AND ur.activo = TRUE
      ORDER BY r.nivel_prioridad DESC, u.nombre
    `);

    if (users.length === 0) {
      console.log('❌ No se encontraron usuarios con roles asignados');
      console.log('   Ejecuta primero las migraciones RBAC\n');
      return;
    }

    console.log(`✅ Se encontraron ${users.length} usuarios con roles:\n`);
    users.forEach(u => {
      console.log(`   • ${u.nombre} (${u.email})`);
      console.log(`     Rol: ${u.rol_nombre} (prioridad: ${u.nivel_prioridad})\n`);
    });

    // 2. Probar permisos de cada usuario
    console.log('🔐 2. Probando permisos de usuarios...\n');

    for (const user of users) {
      console.log(`━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`);
      console.log(`👤 Usuario: ${user.nombre} - ${user.rol_nombre}`);
      console.log(`━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n`);

      // Obtener permisos
      const permissions = await getUserPermissions(user.id);
      const roles = await getUserRoles(user.id);

      console.log(`📦 Roles asignados: ${roles.length}`);
      roles.forEach(role => {
        const scopeText = role.scope_type 
          ? `Alcance: ${role.scope_type} (${role.scope_id})` 
          : 'Alcance: Global';
        console.log(`   • ${role.nombre} - ${scopeText}`);
      });

      console.log(`\n🔑 Permisos cargados: ${permissions.length}`);
      if (permissions.length <= 5) {
        permissions.forEach(p => console.log(`   • ${p}`));
      } else if (permissions.includes('*.*')) {
        console.log('   • *.* (ACCESO TOTAL)');
      } else {
        console.log(`   Primeros 5 permisos:`);
        permissions.slice(0, 5).forEach(p => console.log(`   • ${p}`));
        console.log(`   ... y ${permissions.length - 5} más`);
      }

      // Probar permisos específicos
      console.log('\n🧪 Pruebas de permisos específicos:');
      
      const tests = [
        { perm: 'guardias.crear', desc: 'Crear guardias' },
        { perm: 'guardias.eliminar', desc: 'Eliminar guardias' },
        { perm: 'plazas.editar', desc: 'Editar plazas' },
        { perm: 'casas.crear', desc: 'Crear casas' },
        { perm: 'residentes.eliminar', desc: 'Eliminar residentes' },
        { perm: 'pagos.crear', desc: 'Crear pagos' },
        { perm: 'vehiculos.editar', desc: 'Editar vehículos' },
        { perm: 'acceso.crear', desc: 'Registrar acceso' },
        { perm: 'documentos.eliminar', desc: 'Eliminar documentos' },
        { perm: 'eventos.crear', desc: 'Crear eventos' },
        { perm: 'reportes.leer', desc: 'Ver reportes' },
        { perm: 'tokens.crear', desc: 'Generar tokens' },
        { perm: 'roles.editar', desc: 'Gestionar roles' }
      ];

      const results = {
        permitido: [],
        denegado: []
      };

      tests.forEach(test => {
        const allowed = hasPermission(permissions, test.perm);
        if (allowed) {
          results.permitido.push(test.desc);
        } else {
          results.denegado.push(test.desc);
        }
      });

      if (results.permitido.length > 0) {
        console.log(`\n   ✅ Permitidos (${results.permitido.length}):`);
        results.permitido.forEach(desc => console.log(`      • ${desc}`));
      }

      if (results.denegado.length > 0) {
        console.log(`\n   ❌ Denegados (${results.denegado.length}):`);
        results.denegado.forEach(desc => console.log(`      • ${desc}`));
      }

      console.log('\n');
    }

    // 3. Resumen final
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('📊 RESUMEN DEL SISTEMA RBAC');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

    // Contar roles
    const rolesCount = await query(`
      SELECT r.nombre, r.nivel_prioridad, COUNT(ur.user_id) as usuarios
      FROM roles r
      LEFT JOIN user_roles ur ON r.id = ur.role_id AND ur.activo = TRUE
      GROUP BY r.id, r.nombre, r.nivel_prioridad
      ORDER BY r.nivel_prioridad DESC
    `);

    console.log('🎭 Distribución de Roles:\n');
    rolesCount.forEach(r => {
      console.log(`   ${r.nombre.padEnd(20)} | ${r.usuarios} usuario(s) | Prioridad: ${r.nivel_prioridad}`);
    });

    // Contar permisos
    const permCount = await query('SELECT COUNT(*) as total FROM permissions WHERE activo = TRUE');
    console.log(`\n🔑 Total de Permisos: ${permCount[0].total}`);

    // Auditoría reciente
    const auditRecent = await query(`
      SELECT COUNT(*) as total 
      FROM permission_audit 
      WHERE created_at > NOW() - INTERVAL '1 day'
    `);
    console.log(`📝 Cambios en últimas 24h: ${auditRecent[0].total}`);

    console.log('\n✅ Prueba del sistema RBAC completada exitosamente\n');

  } catch (error) {
    console.error('\n❌ Error ejecutando prueba RBAC:', error.message);
    console.error('Stack:', error.stack);
  } finally {
    process.exit(0);
  }
}

// Ejecutar prueba
testRBAC();
