# Instrucciones: Ejecutar Migraciones RBAC en Supabase

## 📋 Resumen

Este documento contiene las instrucciones para ejecutar las **3 migraciones del sistema RBAC** en tu base de datos Supabase.

---

## 🎯 Objetivo

Implementar el sistema de **Roles y Permisos** (RBAC) con:
- **5 roles**: Super Admin, Administrador, Delegado, Supervisor, Guardia
- **~70 permisos granulares** (módulo.acción)
- **Asignación automática de roles** a usuarios existentes

---

## 📂 Archivos Creados

1. **`012_create_rbac_tables.sql`** - Crea 5 tablas nuevas + modifica tablas existentes
2. **`013_seed_roles_permissions.sql`** - Inserta roles base y permisos
3. **`014_migrate_existing_users.sql`** - Asigna roles a usuarios actuales
4. **`EJECUTAR_MIGRACIONES_RBAC.sql`** - ✅ **Script consolidado** (ejecutar este)

---

## 🚀 Pasos para Ejecutar

### Opción A: Script Consolidado (Recomendado)

1. **Abrir Supabase Dashboard**
   - Ve a: https://supabase.com/dashboard/project/[TU_PROYECTO]/sql/new
   - O navega: Dashboard → SQL Editor → New Query

2. **Copiar script completo**
   - Abre el archivo: `scripts/database/EJECUTAR_MIGRACIONES_RBAC.sql`
   - Selecciona TODO el contenido (Ctrl+A)
   - Copia (Ctrl+C)

3. **Pegar en SQL Editor**
   - Pega el script en el editor de Supabase
   - Nombre sugerido: "RBAC Migration - Complete"

4. **Ejecutar**
   - Click en botón **"Run"** (o F5)
   - Espera a que termine (debería tomar ~5-10 segundos)

5. **Verificar resultados**
   - Revisa la salida en la consola
   - Deberías ver:
     ```
     ✅ Migración 012 completada: Tablas RBAC creadas
     ✅ Migración 013 completada: Roles y permisos insertados
     ✅ Migración 014 completada: Roles asignados a usuarios existentes
     🎉 TODAS LAS MIGRACIONES COMPLETADAS
     ```
   - Al final verás 2 tablas:
     * Resumen de roles (con cantidad de usuarios y permisos)
     * Listado de usuarios con sus roles asignados

---

### Opción B: Ejecución Individual (Si hay problemas)

Si el script consolidado falla, ejecuta las migraciones una por una:

#### 1. Primera migración (Tablas)
```bash
Archivo: scripts/database/012_create_rbac_tables.sql
Copiar → Pegar en SQL Editor → Run
```

#### 2. Segunda migración (Seed)
```bash
Archivo: scripts/database/013_seed_roles_permissions.sql
Copiar → Pegar en SQL Editor → Run
```

#### 3. Tercera migración (Usuarios)
```bash
Archivo: scripts/database/014_migrate_existing_users.sql
Copiar → Pegar en SQL Editor → Run
```

---

## ✅ Verificación Post-Migración

### 1. Verificar tablas creadas

Ejecuta este query en SQL Editor:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_name IN ('roles', 'permissions', 'role_permissions', 'user_roles', 'permission_audit')
  AND table_schema = 'public';
```

**Resultado esperado:** 5 filas (las 5 tablas nuevas)

---

### 2. Verificar roles insertados

```sql
SELECT codigo, nombre, nivel_prioridad, es_sistema 
FROM roles 
WHERE activo = TRUE 
ORDER BY nivel_prioridad DESC;
```

**Resultado esperado:**
| codigo | nombre | nivel_prioridad | es_sistema |
|--------|--------|-----------------|------------|
| super_admin | Super Usuario | 100 | true |
| administrador | Administrador | 80 | true |
| delegado | Delegado de Plaza | 60 | true |
| supervisor | Supervisor | 40 | true |
| guardia | Guardia | 20 | true |

---

### 3. Verificar permisos creados

```sql
SELECT modulo, COUNT(*) as total_permisos 
FROM permissions 
WHERE activo = TRUE 
GROUP BY modulo 
ORDER BY modulo;
```

**Resultado esperado:** ~14-15 módulos con 4-5 permisos cada uno

---

### 4. Verificar usuarios con roles

```sql
SELECT 
  u.nombre,
  u.email,
  r.nombre as rol,
  ur.scope_type,
  ur.scope_id
FROM admin_users u
INNER JOIN user_roles ur ON u.id = ur.user_id
INNER JOIN roles r ON ur.role_id = r.id
WHERE ur.activo = TRUE
ORDER BY r.nivel_prioridad DESC;
```

**Resultado esperado:**
- El primer admin_user debe tener rol `Super Usuario`
- Los demás admin_users deben tener rol `Administrador`
- Si hay guardias migrados, deben tener rol `Guardia`

---

### 5. Ver permisos de un rol específico

```sql
SELECT p.codigo, p.descripcion 
FROM permissions p
INNER JOIN role_permissions rp ON p.id = rp.permission_id
INNER JOIN roles r ON rp.role_id = r.id
WHERE r.codigo = 'super_admin'  -- Cambiar por: 'administrador', 'delegado', etc.
ORDER BY p.codigo;
```

**Resultado esperado para super_admin:** Solo 1 permiso (`*.*` - wildcard total)

---

## 🔍 Troubleshooting (Solución de Problemas)

### Error: "relation already exists"

**Causa:** Las tablas ya fueron creadas anteriormente.

**Solución:** El script usa `CREATE TABLE IF NOT EXISTS`, así que esto es solo una advertencia. Continúa normal.

---

### Error: "duplicate key value violates unique constraint"

**Causa:** Los roles/permisos ya fueron insertados.

**Solución:** El script usa `ON CONFLICT DO NOTHING`, esto es normal. Los datos existentes se mantienen.

---

### Error: "column already exists"

**Causa:** Las columnas en `admin_users` o `guardias` ya fueron agregadas.

**Solución:** El script usa `ADD COLUMN IF NOT EXISTS`, es solo advertencia.

---

### No aparecen usuarios con roles

**Posibles causas:**
1. No hay usuarios en `admin_users` con `activo = TRUE`
2. Los emails en `guardias` están vacíos o duplicados

**Solución:**
```sql
-- Ver usuarios activos
SELECT id, nombre, email, activo FROM admin_users;

-- Asignar rol manualmente
INSERT INTO user_roles (user_id, role_id, asignado_por, activo)
SELECT 
  1,  -- ID del usuario
  (SELECT id FROM roles WHERE codigo = 'super_admin'),
  1,  -- ID del que asigna
  TRUE
ON CONFLICT DO NOTHING;
```

---

## 📊 Estructura Creada

### Tablas Nuevas (5)

1. **`roles`** - Roles del sistema (super_admin, administrador, etc.)
2. **`permissions`** - Permisos granulares (guardias.crear, pagos.editar, etc.)
3. **`role_permissions`** - N:M entre roles y permisos
4. **`user_roles`** - N:M entre usuarios y roles (con scoping)
5. **`permission_audit`** - Auditoría de cambios

### Columnas Agregadas

- **`admin_users`**:
  - `ultimo_cambio_permisos` (TIMESTAMP)
  - `permisos_custom` (JSONB)

- **`guardias`**:
  - `plaza_id` (INTEGER REFERENCES plazas)

---

## 🎯 Siguiente Paso

Después de verificar que las migraciones ejecutaron correctamente:

1. ✅ Confirma que ves usuarios con roles asignados
2. ✅ Confirma que cada rol tiene sus permisos
3. ➡️ Informa al agente para continuar con **Fase 3** (Actualizar rutas backend)

---

## 📞 Soporte

Si encuentras errores:
1. Copia el mensaje de error completo
2. Copia la query de verificación que falló
3. Comparte con el agente para diagnóstico

---

**Fecha:** 19/05/2026  
**Sistema:** RBAC (Role-Based Access Control)  
**Base de datos:** Supabase PostgreSQL
