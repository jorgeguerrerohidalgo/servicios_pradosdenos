# Solución: No veo la UI de Gestión de Roles

## ❌ Problema

Después de implementar el sistema RBAC, el menú "Gestión de Roles" no aparece en el panel de administración.

---

## ✅ Soluciones (en orden de probabilidad)

### Solución 1: Re-login necesario (MÁS COMÚN) ⭐

**Causa:** Los permisos se cargan en la sesión durante el login. Si ejecutaste las migraciones RBAC mientras estabas logueado, tu sesión antigua no tiene los permisos nuevos.

**Pasos:**
1. **Cerrar sesión** en el panel de administración
2. **Volver a iniciar sesión** con tus credenciales
3. Verificar que ahora aparece "Gestión de Roles" en el menú lateral

**Por qué funciona:** El sistema carga los permisos frescos desde la base de datos cada vez que inicias sesión.

---

### Solución 2: Verificar permisos del usuario

**Causa:** Tu usuario no tiene el rol o permiso necesario para ver la sección.

**Requisito:** Necesitas el permiso `roles.leer` o el wildcard `*.*` (Super Admin)

**Cómo verificar:**

1. **Ejecutar en Supabase SQL Editor:**
   ```sql
   -- Ver qué rol tienes asignado
   SELECT 
     u.nombre,
     u.email,
     r.nombre as rol,
     r.nivel_prioridad
   FROM admin_users u
   INNER JOIN user_roles ur ON u.id = ur.user_id
   INNER JOIN roles r ON ur.role_id = r.id
   WHERE u.email = 'TU_EMAIL@example.com'  -- Cambia esto
     AND ur.activo = TRUE;
   ```

2. **O usar el script completo de verificación:**
   - Abrir: `scripts/verify-rbac-session.sql`
   - Copiar TODO el contenido
   - Pegar en Supabase SQL Editor
   - Ejecutar (Run)
   - Revisar la sección: **"USUARIOS CON ACCESO A UI DE ROLES"**

**Soluciones si no tienes permisos:**

**Opción A: Promover a Super Admin (si eres Jorge)**
```sql
-- Ejecutar en Supabase
DELETE FROM user_roles
WHERE user_id = (SELECT id FROM admin_users WHERE email = 'TU_EMAIL@example.com');

INSERT INTO user_roles (user_id, role_id, scope_type, scope_id, asignado_por, asignado_en, activo)
SELECT 
  u.id, r.id, NULL, NULL, u.id, NOW(), TRUE
FROM admin_users u, roles r
WHERE u.email = 'TU_EMAIL@example.com'
  AND r.codigo = 'super_admin';
```

**Opción B: Solicitar que otro Super Admin te asigne el permiso**
- Pedir a otro usuario con rol Super Admin que use la UI de roles
- Asignar rol "Administrador" o superior

---

### Solución 3: Limpiar caché del navegador

**Causa:** El navegador está sirviendo archivos antiguos de admin-panel.html o rbac-helper.js

**Pasos:**
1. Abrir el panel de administración
2. Presionar **Ctrl + Shift + R** (Windows/Linux) o **Cmd + Shift + R** (Mac)
3. O usar herramientas de desarrollador: **Ctrl + Shift + Delete** → Limpiar caché
4. Recargar la página completamente

---

### Solución 4: Verificar deployment (Render)

**Causa:** El deployment no tiene los últimos cambios con la UI de roles

**Verificar:**
1. Ir a: https://dashboard.render.com
2. Buscar tu servicio
3. Verificar que el último deploy sea exitoso
4. Commit esperado: `33364dc - hotfix: Corregir imports de database en RBAC`

**Si el deploy falló:**
- Revisar logs en Render
- El hotfix de database imports debería estar aplicado
- Si no, hacer redeploy manual

**Forzar redeploy:**
```bash
# En tu máquina local
git commit --allow-empty -m "trigger: Force redeploy"
git push origin feature/fase-4-5-testing
```

---

### Solución 5: Verificar errores de JavaScript

**Causa:** Algún error de JavaScript está impidiendo que el menú se renderice

**Pasos:**
1. Abrir panel de administración
2. Presionar **F12** para abrir DevTools
3. Ir a la pestaña **Console**
4. Buscar errores en rojo (especialmente relacionados con RBAC)

**Errores comunes:**
- `Cannot find module '../config/database'` → Necesitas el hotfix aplicado
- `ReferenceError: showSection is not defined` → Problema de carga de scripts
- `Failed to fetch` en `/api/auth/check` → Problema de sesión

**Solución según error:**
- Si hay errores de module: Verificar que el deployment tenga commit `33364dc`
- Si hay errores de fetch: Cerrar sesión y volver a entrar
- Si no hay errores: Problema de permisos (ver Solución 2)

---

## 🔍 Diagnóstico Automatizado

**Script SQL completo para diagnosticar:** `scripts/verify-rbac-session.sql`

**Qué verifica:**
1. ✅ Usuarios con roles activos
2. ✅ Permisos del módulo 'roles'
3. ✅ Usuarios con acceso a UI de roles
4. ✅ Estado de sesiones (último login vs último cambio de permisos)
5. ✅ Permisos disponibles
6. ✅ Auditoría de cambios recientes

**Cómo ejecutar:**
```bash
# 1. Abrir Supabase SQL Editor
# 2. Copiar contenido de scripts/verify-rbac-session.sql
# 3. Pegar en el editor
# 4. Click en "Run"
# 5. Revisar los 6 resultados
```

---

## 📊 Checklist de Verificación

Marca cada punto que hayas verificado:

- [ ] Cerré sesión y volví a iniciar sesión
- [ ] Mi usuario tiene rol "Super Usuario" o "Administrador"
- [ ] Limpié el caché del navegador (Ctrl + Shift + R)
- [ ] El deployment en Render es exitoso (commit `33364dc`)
- [ ] No hay errores en la consola del navegador (F12 → Console)
- [ ] Ejecuté `verify-rbac-session.sql` en Supabase
- [ ] Verifiqué que tengo el permiso `roles.leer`

---

## 🎯 Verificación Final

Si después de aplicar las soluciones el menú aparece, verifica que funciona:

1. **Ver el menú:** Debe aparecer "Gestión de Roles" con icono de candado
2. **Hacer click:** Debe mostrar la sección con 4 tabs
3. **Tab 1 (Usuarios y Roles):** Debe cargar la tabla de usuarios
4. **Tab 2 (Matriz de Permisos):** Debe mostrar la grid de roles × permisos
5. **Tab 3 (Auditoría):** Debe mostrar historial de cambios
6. **Tab 4 (Roles Personalizados):** Debe listar roles del sistema

**Si alguna funciona pero otras no:**
- Revisar errores en consola (F12)
- Verificar que las migraciones se ejecutaron completamente
- Contactar con soporte técnico

---

## 📞 Soporte Adicional

Si ninguna solución funciona, recopilar:

1. **Screenshot** del menú lateral (sin "Gestión de Roles")
2. **Consola del navegador** (F12 → Console) con errores
3. **Resultado** de ejecutar `verify-rbac-session.sql`
4. **Email del usuario** con el que inicias sesión
5. **URL** del panel de administración

---

## ✅ Causa más probable

**90% de los casos:** Solo necesitas **cerrar sesión y volver a entrar** 🔄

El sistema RBAC funciona correctamente, solo necesita que tu sesión se refresque con los permisos nuevos.
