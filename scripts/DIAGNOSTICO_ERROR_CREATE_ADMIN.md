## Diagnóstico: Error 500 al crear administrador

### Estado actual
- ✅ GET /api/admin/admins funciona (retorna 3 admins)
- ❌ POST /api/admin/admins da error 500
- Commit deployed: 9615142
- Frontend correcto

### Pasos para diagnosticar

#### 1. Verificar logs de Render
```
https://dashboard.render.com/web/[TU_SERVICE_ID]/logs
```

Buscar líneas que contengan:
- "Error creando administrador"
- "POST /api/admin/admins"
- Stack traces con PostgreSQL

#### 2. Probar endpoint manualmente con curl

**Desde terminal local (con tu sesión):**
```bash
# Obtener cookie de sesión desde el navegador
# F12 → Application → Cookies → connect.sid

curl -X POST https://servicios-prados-de-nos.onrender.com/api/admin/admins \
  -H "Content-Type: application/json" \
  -H "Cookie: connect.sid=TU_SESSION_COOKIE" \
  -d '{
    "nombre": "Test",
    "apellido_paterno": "Usuario",
    "apellido_materno": "Prueba",
    "email": "test@example.com",
    "telefono": "123456789",
    "password": "test1234"
  }' \
  -v
```

#### 3. Verificar deployment en Render

**Revisar que el commit más reciente es 9615142:**
```
Render Dashboard → Commits
```

Si no es el último, hacer manual deploy:
```
Render Dashboard → Manual Deploy → Deploy latest commit
```

#### 4. Errores comunes a verificar

**A. Columna faltante en la base de datos**
```sql
-- Ejecutar en Supabase SQL Editor
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'admin_users'
ORDER BY ordinal_position;
```

**B. Constraint violado**
```sql
-- Ver constraints
SELECT constraint_name, constraint_type 
FROM information_schema.table_constraints 
WHERE table_name = 'admin_users';
```

**C. Trigger problemático**
```sql
-- Ver triggers
SELECT trigger_name, event_manipulation, event_object_table
FROM information_schema.triggers
WHERE event_object_table = 'admin_users';
```

#### 5. Solución temporal: Crear admin directamente en base de datos

```sql
-- Ejecutar en Supabase SQL Editor
INSERT INTO admin_users (
  nombre, 
  apellido_paterno, 
  apellido_materno, 
  email, 
  telefono, 
  password_hash, 
  activo
) VALUES (
  'Test',
  'Usuario',
  'Prueba',
  'test@example.com',
  '123456789',
  '$2b$10$abcdefghijklmnopqrstuv',  -- Hash ficticio, cambiar por uno real
  true
);
```

### Próximo paso

**Por favor ejecuta esto en la consola del navegador (F12):**

```javascript
// Diagnóstico completo del error
async function diagnosisCreateAdmin() {
  try {
    const testData = {
      nombre: "Test" + Date.now(),
      apellido_paterno: "Usuario",
      apellido_materno: "Prueba",
      email: "test" + Date.now() + "@example.com",
      telefono: "123456789",
      password: "test1234"
    };
    
    console.log('📝 Enviando datos:', testData);
    
    const response = await fetch('/api/admin/admins', {
      method: 'POST',
      credentials: 'include',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(testData)
    });
    
    console.log('📊 Status:', response.status);
    console.log('📊 OK:', response.ok);
    console.log('📊 Headers:', [...response.headers]);
    
    const text = await response.text();
    console.log('📊 Response body (raw):', text);
    
    try {
      const json = JSON.parse(text);
      console.log('📊 Response body (parsed):', json);
    } catch {
      console.log('⚠️ Response no es JSON válido');
    }
    
  } catch (error) {
    console.error('❌ Error en request:', error);
  }
}

diagnosisCreateAdmin();
```

Este script te mostrará el mensaje de error exacto del servidor.
