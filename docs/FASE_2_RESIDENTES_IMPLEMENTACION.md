# FASE 2: Implementación del Módulo de Residentes

## ✅ Estado: COMPLETADA
**Fecha de implementación:** Enero 2025  
**Desarrollador:** AI Assistant

---

## 📋 Descripción General

Módulo para gestionar a los residentes de las casas del condominio, con información personal, validación de RUN chileno, y relación CASCADE con casas.

---

## 🗂️ Archivos Creados/Modificados

### 1. Migration SQL
**Archivo:** `scripts/database/002_create_residentes.sql`

#### Estructura de la Tabla `residentes`
```sql
CREATE TABLE IF NOT EXISTS residentes (
    id SERIAL PRIMARY KEY,
    casa_id INTEGER NOT NULL,
    run VARCHAR(12) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100),
    fecha_nacimiento DATE NOT NULL,
    email VARCHAR(255),
    telefono VARCHAR(20),
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_casa FOREIGN KEY (casa_id) 
        REFERENCES casas(id) ON DELETE CASCADE,
    CONSTRAINT check_run_format CHECK (run ~ '^\d{7,8}-[\dkK]$'),
    CONSTRAINT check_email_format CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);
```

#### Funciones Especiales
- **`validar_rut_chileno(rut TEXT)`**: Valida formato de RUN (7-8 dígitos + guión + dígito verificador o K)
- **`get_estadisticas_residentes(p_casa_id INTEGER)`**: Retorna estadísticas de edad por casa (promedio, mínimo, máximo, total)

#### Vista `v_residentes_completo`
```sql
CREATE OR REPLACE VIEW v_residentes_completo AS
SELECT 
    r.id,
    r.casa_id,
    r.run,
    r.nombre,
    r.apellido_paterno,
    r.apellido_materno,
    r.fecha_nacimiento,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, r.fecha_nacimiento))::INTEGER AS edad,
    r.email,
    r.telefono,
    r.activo,
    r.created_at,
    r.updated_at,
    c.numero_casa,
    c.direccion AS direccion_casa,
    p.nombre AS nombre_plaza
FROM residentes r
INNER JOIN casas c ON r.casa_id = c.id
INNER JOIN plazas p ON c.plaza_id = p.id;
```

### 2. Backend API
**Archivo:** `backend/routes/residentes.routes.js`

#### Endpoints Implementados

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/residentes` | Lista todos los residentes con filtros |
| GET | `/api/residentes/simple` | Lista simplificada para dropdowns |
| GET | `/api/residentes/casa/:casa_id` | Residentes de una casa específica |
| GET | `/api/residentes/estadisticas/general` | Estadísticas generales de edad |
| POST | `/api/residentes` | Crear nuevo residente |
| PUT | `/api/residentes/:id` | Actualizar residente existente |
| DELETE | `/api/residentes/:id` | Soft delete de residente |

#### Validaciones Implementadas
- **RUN:** Formato `12345678-9` (7-8 dígitos + guión + dígito verificador)
- **Email:** Validación con regex estándar
- **Edad:** Cálculo automático desde fecha de nacimiento
- **Casa ID:** Validación de existencia de casa antes de crear/actualizar

### 3. Integración en Server
**Archivo:** `backend/server.js`

```javascript
const residentesRoutes = require('./routes/residentes.routes');
app.use('/api/residentes', residentesRoutes);
```

### 4. Frontend (Admin Panel)
**Archivo:** `public/admin-panel.html`

#### Componentes Agregados

**1. Nav-link en Sidebar**
```html
<a class="nav-link" href="#" onclick="showSection('residentes')">
    <i class="fas fa-users me-2"></i> Residentes
</a>
```

**2. Sección de Residentes**
- Tabla con columnas: RUN, Nombre Completo, Casa, Edad, Email, Teléfono, Estado, Acciones
- Filtros: Por casa, Por estado (activo/inactivo), Búsqueda general
- Botón "Nuevo Residente"

**3. Modal de Crear/Editar**
Campos del formulario:
- Casa (obligatorio) - Dropdown
- RUN (obligatorio) - Input con validación de formato
- Nombre (obligatorio)
- Apellido Paterno (obligatorio)
- Apellido Materno (opcional)
- Fecha de Nacimiento (obligatoria)
- Email (opcional)
- Teléfono (opcional)

**4. Funciones JavaScript**
- `loadResidentes()`: Carga residentes con filtros aplicados
- `renderResidentesTable(residentes)`: Renderiza tabla con datos
- `showResidenteForm(residenteId)`: Abre modal para crear/editar
- `saveResidente()`: Guarda residente (POST/PUT)
- `deleteResidente(residenteId, nombreCompleto)`: Soft delete con confirmación

---

## 🔐 Características de Seguridad

1. **Middleware de Autenticación:** Todas las rutas requieren `requireAuthAdmin`
2. **Validación de Entrada:** 
   - RUN con formato chileno estricto
   - Email con formato válido
   - Sanitización de datos en frontend
3. **CASCADE Delete:** Si se elimina una casa, se eliminan automáticamente sus residentes
4. **Soft Delete:** Los residentes se marcan como `activo=false` en lugar de eliminarse físicamente

---

## 📊 Relaciones de Base de Datos

```
plazas (1) -----> (N) casas (1) -----> (N) residentes
```

**Comportamiento:**
- Al eliminar una `casa`: Se eliminan todos sus `residentes` (CASCADE)
- Al eliminar una `plaza`: Se eliminan todas sus `casas` y sus `residentes` (CASCADE)

---

## 🧪 Verificación de Implementación

### 1. Ejecutar Migraciones
```bash
# Opción 1: Supabase SQL Editor (RECOMENDADO)
1. Ir a https://app.supabase.com/project/ixttdxkelassioemefbo/sql/new
2. Copiar contenido de scripts/database/002_create_residentes.sql
3. Ejecutar

# Opción 2: psql
psql "postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres" -f scripts/database/002_create_residentes.sql
```

### 2. Verificar Tablas
```sql
-- Verificar que la tabla existe
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' AND table_name = 'residentes';

-- Verificar estructura
\d residentes

-- Verificar vista
SELECT * FROM v_residentes_completo LIMIT 5;
```

### 3. Probar Backend
```bash
# Iniciar servidor
cd backend
node server.js

# Probar endpoint
curl -X GET http://localhost:3000/api/residentes \
  -H "Cookie: connect.sid=<session-cookie>"
```

### 4. Probar Frontend
1. Ir a `http://localhost:3000/admin-panel.html`
2. Click en "Residentes" en el sidebar
3. Click en "Nuevo Residente"
4. Llenar formulario con:
   - Casa: Seleccionar una existente
   - RUN: `12345678-9`
   - Nombre: `Juan`
   - Apellido Paterno: `Pérez`
   - Fecha Nacimiento: `1990-01-01`
5. Click en "Guardar Residente"
6. Verificar que aparece en la tabla

---

## 🚀 Próximos Pasos

### FASE 3: Módulo de Mascotas
- **Dependencia:** Requiere `residentes.id`
- **Características:**
  - Mascotas particulares (`residente_id NOT NULL`)
  - Mascotas comunitarias (`residente_id IS NULL`)
  - Tipos: perro, gato, otro
  - Razas, edad, certificados vacunas

### FASE 4: Módulo de Pagos
- **Dependencia:** Requiere `casas.id`
- **Características:**
  - Pagos de cuota social y junta de vecinos
  - Estados: pendiente, pagado, vencido
  - Control de morosidad
  - Integración con control de vehículos

### FASE 5: Módulo de Vehículos + Control de Acceso
- **Dependencia:** Requiere `casas.id` y `residentes.id` (opcional)
- **Características:**
  - Registro de vehículos por casa/residente
  - Control de acceso basado en estado de pago (Fase 4)
  - Registro de entradas/salidas

---

## 📝 Notas Técnicas

### Formato de RUN Chileno
- **Patrón:** `/^\d{7,8}-[\dkK]$/`
- **Ejemplos válidos:** `12345678-9`, `1234567-K`, `12345678-k`
- **Ejemplos inválidos:** `12.345.678-9`, `12345678`, `123456789`

### Cálculo de Edad
```sql
EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento))::INTEGER
```

### Zona Horaria
Todas las fechas se manejan en `America/Santiago` (configurado en `server.js`)

---

## ✅ Checklist de Implementación

- [x] Migration SQL creada (`002_create_residentes.sql`)
- [x] Vista `v_residentes_completo` creada
- [x] Función `validar_rut_chileno` creada
- [x] Función `get_estadisticas_residentes` creada
- [x] Backend API implementada (`residentes.routes.js`)
- [x] Rutas montadas en `server.js`
- [x] Nav-link agregado al sidebar
- [x] Sección de residentes agregada al HTML
- [x] Modal de crear/editar implementado
- [x] Funciones JavaScript implementadas
- [x] Validación de RUN en frontend
- [x] Integración con módulo de Casas (dropdown)
- [ ] **PENDIENTE:** Ejecutar migraciones en Supabase
- [ ] **PENDIENTE:** Sub-vista de residentes en sección Casas

---

## 🐛 Troubleshooting

### Error: "duplicate key value violates unique constraint 'residentes_run_key'"
**Causa:** El RUN ya está registrado  
**Solución:** Verificar que el RUN no exista en la tabla antes de insertar

### Error: "violates foreign key constraint 'fk_casa'"
**Causa:** La casa especificada no existe  
**Solución:** Ejecutar primero la migración `001_create_casas.sql`

### Error: "new row for relation 'residentes' violates check constraint 'check_run_format'"
**Causa:** RUN no cumple con el formato `12345678-9`  
**Solución:** Verificar que el RUN tenga 7-8 dígitos + guión + dígito verificador

### Modal no se abre
**Causa:** Bootstrap 5 no inicializado  
**Solución:** Verificar que Bootstrap JS esté cargado antes de las funciones JavaScript

---

## 📞 Contacto

Para dudas o problemas con la implementación, revisar:
- `backend/routes/residentes.routes.js` - Lógica de backend
- `public/admin-panel.html` - Funciones `loadResidentes()`, `saveResidente()`, etc.
- `scripts/database/002_create_residentes.sql` - Estructura de BD

---

**Documento generado automáticamente por AI Assistant**  
**Última actualización:** Enero 2025
