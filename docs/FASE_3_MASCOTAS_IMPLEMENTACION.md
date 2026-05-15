# FASE 3: Implementación del Módulo de Mascotas

## ✅ Estado: COMPLETADA
**Fecha de implementación:** Enero 2025  
**Desarrollador:** AI Assistant

---

## 📋 Descripción General

Módulo para gestionar mascotas particulares (con dueño residente) y mascotas comunitarias del condominio, con control de vacunas, información de raza, edad, y trazabilidad completa.

---

## 🗂️ Archivos Creados/Modificados

### 1. Migration SQL
**Archivo:** `scripts/database/003_create_mascotas.sql`

#### Estructura de la Tabla `mascotas`
```sql
CREATE TABLE IF NOT EXISTS mascotas (
    id SERIAL PRIMARY KEY,
    casa_id INTEGER NOT NULL,
    residente_id INTEGER,  -- NULL para mascotas comunitarias
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('perro', 'gato', 'otro')),
    raza VARCHAR(100),
    fecha_nacimiento DATE,
    genero VARCHAR(10) CHECK (genero IN ('macho', 'hembra', 'desconocido')),
    color VARCHAR(50),
    certificado_vacunas BOOLEAN DEFAULT FALSE,
    fecha_ultima_vacuna DATE,
    observaciones TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_casa FOREIGN KEY (casa_id) 
        REFERENCES casas(id) ON DELETE CASCADE,
    CONSTRAINT fk_residente FOREIGN KEY (residente_id) 
        REFERENCES residentes(id) ON DELETE SET NULL
);
```

**Características clave:**
- **Mascotas Particulares:** `residente_id` NOT NULL → pertenece a un residente específico
- **Mascotas Comunitarias:** `residente_id` IS NULL → mascota sin dueño particular
- **CASCADE en casa_id:** Si se elimina la casa, se eliminan sus mascotas
- **SET NULL en residente_id:** Si se elimina el residente, mascota pasa a ser comunitaria

#### Funciones Especiales

**`get_estadisticas_mascotas()`**
Retorna estadísticas generales:
- Total de mascotas
- Mascotas particulares vs comunitarias
- Distribución por tipo (perros, gatos, otros)
- Certificados de vacunas (con/sin)
- Promedio de edad

**`get_mascotas_por_casa(p_casa_id INTEGER)`**
Lista todas las mascotas de una casa específica con información del dueño.

**`get_mascotas_vacunas_vencidas()`**
Retorna mascotas con vacunas vencidas (más de 1 año) o sin registro de vacunación.

#### Vista `v_mascotas_completo`
```sql
CREATE OR REPLACE VIEW v_mascotas_completo AS
SELECT 
    m.id,
    m.casa_id,
    c.numero_casa,
    c.direccion as casa_direccion,
    c.plaza_id,
    p.nombre as plaza_nombre,
    m.residente_id,
    CASE 
        WHEN m.residente_id IS NULL THEN 'COMUNITARIA'
        ELSE CONCAT(r.nombre, ' ', r.apellido_paterno, ' ', COALESCE(r.apellido_materno, ''))
    END as dueno_nombre,
    r.run as dueno_run,
    r.telefono as dueno_telefono,
    m.nombre as mascota_nombre,
    m.tipo,
    m.raza,
    m.fecha_nacimiento,
    CASE 
        WHEN m.fecha_nacimiento IS NOT NULL THEN 
            EXTRACT(YEAR FROM AGE(CURRENT_DATE, m.fecha_nacimiento))::INTEGER
        ELSE NULL
    END as edad_anos,
    m.genero,
    m.color,
    m.certificado_vacunas,
    m.fecha_ultima_vacuna,
    CASE 
        WHEN m.fecha_ultima_vacuna IS NOT NULL THEN
            CURRENT_DATE - m.fecha_ultima_vacuna
        ELSE NULL
    END as dias_desde_vacuna,
    m.observaciones,
    m.activo,
    m.created_at,
    m.updated_at
FROM mascotas m
LEFT JOIN casas c ON m.casa_id = c.id
LEFT JOIN plazas p ON c.plaza_id = p.id
LEFT JOIN residentes r ON m.residente_id = r.id;
```

### 2. Backend API
**Archivo:** `backend/routes/mascotas.routes.js`

#### Endpoints Implementados

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/mascotas` | Lista todas las mascotas con filtros |
| GET | `/api/mascotas/simple` | Lista simplificada para dropdowns |
| GET | `/api/mascotas/casa/:casa_id` | Mascotas de una casa específica |
| GET | `/api/mascotas/estadisticas/general` | Estadísticas generales |
| GET | `/api/mascotas/vacunas/vencidas` | Mascotas con vacunas vencidas |
| POST | `/api/mascotas` | Crear nueva mascota |
| PUT | `/api/mascotas/:id` | Actualizar mascota existente |
| DELETE | `/api/mascotas/:id` | Soft delete de mascota |

#### Validaciones Implementadas
- **Casa ID:** Verificación de existencia y estado activo
- **Residente ID:** Validación de pertenencia a la casa especificada
- **Tipo:** Solo valores permitidos: 'perro', 'gato', 'otro'
- **Género:** Solo valores permitidos: 'macho', 'hembra', 'desconocido'
- **Fechas:** Validación de que no sean futuras

#### Filtros Disponibles en GET `/api/mascotas`
- `casa_id`: Filtrar por casa
- `tipo`: Filtrar por tipo (perro/gato/otro)
- `certificado_vacunas`: Filtrar por estado de vacunas
- `activo`: Filtrar por estado activo/inactivo
- `search`: Búsqueda general (nombre, dueño, raza, casa)

### 3. Integración en Server
**Archivo:** `backend/server.js`

```javascript
const mascotasRoutes = require('./routes/mascotas.routes');
app.use('/api/mascotas', mascotasRoutes);
```

### 4. Frontend (Admin Panel)
**Archivo:** `public/admin-panel.html`

#### Componentes Agregados

**1. Nav-link en Sidebar**
```html
<a class="nav-link" href="#" onclick="showSection('mascotas')">
    <i class="fas fa-paw me-2"></i> Mascotas
</a>
```

**2. Sección de Mascotas**
- Tabla con columnas: Nombre, Tipo, Raza, Casa, Dueño, Edad, Vacunas, Estado, Acciones
- Filtros: Por casa, Por tipo, Por certificado vacunas, Por estado, Búsqueda general
- Botón "Nueva Mascota"
- Iconos dinámicos (perro 🐕, gato 🐈, otro 🐾)

**3. Modal de Crear/Editar**
Campos del formulario:
- Casa (obligatorio) - Dropdown que actualiza residentes disponibles
- Dueño (opcional) - Dropdown de residentes de la casa seleccionada
  - Si se deja vacío → Mascota Comunitaria
- Nombre (obligatorio)
- Tipo (obligatorio) - Dropdown: Perro/Gato/Otro
- Raza (opcional)
- Fecha de Nacimiento (opcional) - Date picker
- Género (opcional) - Dropdown: Macho/Hembra/Desconocido
- Color (opcional)
- Última Vacuna (opcional) - Date picker
- Certificado de Vacunas (checkbox)
- Observaciones (textarea)

**4. Funciones JavaScript**
- `loadMascotas()`: Carga mascotas con filtros aplicados
- `renderMascotasTable(mascotas)`: Renderiza tabla con datos e iconos dinámicos
- `showMascotaForm(mascotaId)`: Abre modal para crear/editar
- `loadResidentesPorCasa()`: Carga residentes cuando se cambia la casa
- `saveMascota()`: Guarda mascota (POST/PUT) con validación de comunitaria
- `deleteMascota(mascotaId, nombreMascota)`: Soft delete con confirmación

---

## 🔐 Características de Seguridad

1. **Middleware de Autenticación:** Todas las rutas requieren `requireAuthAdmin`
2. **Validación de Relaciones:** 
   - Casa debe existir y estar activa
   - Residente debe pertenecer a la casa especificada
   - Tipo y género restringidos a valores permitidos
3. **Soft Delete:** Las mascotas se marcan como `activo=false`
4. **Protección CASCADE/SET NULL:**
   - Eliminar casa → elimina mascotas asociadas
   - Eliminar residente → mascota pasa a ser comunitaria (no se pierde)

---

## 📊 Relaciones de Base de Datos

```
plazas (1) -----> (N) casas (1) ----+-----> (N) mascotas
                                    |
                                    +-----> (N) residentes (1) -----> (0..N) mascotas
```

**Comportamiento:**
- Al eliminar una `casa`: Se eliminan todas sus `mascotas` (CASCADE)
- Al eliminar un `residente`: Sus mascotas pasan a ser comunitarias (SET NULL)
- Una mascota DEBE pertenecer a una casa
- Una mascota PUEDE tener o no un dueño residente

---

## 🐾 Tipos de Mascotas

### Mascotas Particulares
- Tienen `residente_id` NOT NULL
- Pertenecen a un residente específico
- Se muestra nombre del dueño en la tabla
- Contacto del dueño disponible (teléfono, email)

### Mascotas Comunitarias
- Tienen `residente_id` IS NULL
- No pertenecen a ningún residente particular
- Se muestran con badge "Comunitaria"
- Responsabilidad de toda la comunidad

---

## 🧪 Verificación de Implementación

### 1. Ejecutar Migraciones
```bash
# Opción 1: Supabase SQL Editor (RECOMENDADO)
1. Ir a https://app.supabase.com/project/ixttdxkelassioemefbo/sql/new
2. Copiar contenido de scripts/database/003_create_mascotas.sql
3. Ejecutar

# Opción 2: psql
psql "postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres" -f scripts/database/003_create_mascotas.sql
```

### 2. Verificar Tablas
```sql
-- Verificar que la tabla existe
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' AND table_name = 'mascotas';

-- Verificar estructura
\d mascotas

-- Verificar vista
SELECT * FROM v_mascotas_completo LIMIT 5;

-- Probar función de estadísticas
SELECT * FROM get_estadisticas_mascotas();
```

### 3. Probar Backend
```bash
# Iniciar servidor
cd backend
node server.js

# Probar endpoint
curl -X GET http://localhost:3000/api/mascotas \
  -H "Cookie: connect.sid=<session-cookie>"
```

### 4. Probar Frontend
1. Ir a `http://localhost:3000/admin-panel.html`
2. Click en "Mascotas" en el sidebar
3. Click en "Nueva Mascota"
4. Llenar formulario:
   - Casa: Seleccionar una existente
   - Dueño: Dejar vacío (comunitaria) o seleccionar residente
   - Nombre: `Max`
   - Tipo: `Perro`
   - Raza: `Golden Retriever`
   - Fecha Nacimiento: `2020-01-01`
   - Certificado Vacunas: Marcar checkbox
5. Click en "Guardar Mascota"
6. Verificar que aparece en la tabla con ícono 🐕

### 5. Probar Mascotas Comunitarias
1. Crear nueva mascota
2. Seleccionar casa pero NO seleccionar dueño
3. Guardar
4. Verificar que aparece con badge "Comunitaria"

---

## 🚀 Próximos Pasos

### FASE 4: Módulo de Pagos
- **Dependencia:** Requiere `casas.id`
- **Características:**
  - Registro de pagos mensuales de cuota social
  - Registro de pagos de junta de vecinos
  - Estados: pendiente, pagado, vencido
  - Control de morosidad
  - Historial de pagos por casa
  - Generación de resúmenes por período

### FASE 5: Módulo de Vehículos + Control de Acceso
- **Dependencia:** Requiere `casas.id`, `residentes.id`, `pagos` (Fase 4)
- **Características:**
  - Registro de vehículos por casa/residente
  - Patentes, marca, modelo, color
  - Control de acceso basado en estado de pago
  - Registro de entradas/salidas
  - Bloqueo automático por morosidad
  - Integración con sistema de guardias

---

## 📝 Notas Técnicas

### Diferenciación de Mascotas
La columna `residente_id` determina el tipo:
```sql
-- Mascota particular
INSERT INTO mascotas (casa_id, residente_id, nombre, tipo) 
VALUES (1, 5, 'Max', 'perro');  -- residente_id = 5

-- Mascota comunitaria
INSERT INTO mascotas (casa_id, residente_id, nombre, tipo) 
VALUES (1, NULL, 'Firulais', 'perro');  -- residente_id = NULL
```

### Cálculo de Edad
```sql
EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento))::INTEGER
```

### Validación de Vacunas
Una vacuna se considera vencida si:
- `fecha_ultima_vacuna IS NULL` (nunca se ha vacunado)
- `(CURRENT_DATE - fecha_ultima_vacuna) > 365` (más de 1 año)

### Iconos Dinámicos en Frontend
```javascript
const tipoIcono = mascota.tipo === 'perro' ? 'fa-dog' : 
                 mascota.tipo === 'gato' ? 'fa-cat' : 'fa-paw';
```

---

## ✅ Checklist de Implementación

- [x] Migration SQL creada (`003_create_mascotas.sql`)
- [x] Vista `v_mascotas_completo` creada
- [x] Función `get_estadisticas_mascotas` creada
- [x] Función `get_mascotas_por_casa` creada
- [x] Función `get_mascotas_vacunas_vencidas` creada
- [x] Backend API implementada (`mascotas.routes.js`)
- [x] Rutas montadas en `server.js`
- [x] Nav-link agregado al sidebar
- [x] Sección de mascotas agregada al HTML
- [x] Modal de crear/editar implementado
- [x] Función `loadResidentesPorCasa()` para carga dinámica
- [x] Funciones JavaScript implementadas
- [x] Validación de mascotas comunitarias (residente_id NULL)
- [x] Iconos dinámicos por tipo de mascota
- [x] Integración con módulo de Casas (dropdown)
- [x] Integración con módulo de Residentes (dropdown por casa)
- [ ] **PENDIENTE:** Ejecutar migraciones en Supabase

---

## 🐛 Troubleshooting

### Error: "violates foreign key constraint 'fk_casa'"
**Causa:** La casa especificada no existe  
**Solución:** Verificar que la casa exista y esté activa

### Error: "violates foreign key constraint 'fk_residente'"
**Causa:** El residente especificado no existe o no pertenece a la casa  
**Solución:** Verificar que el residente pertenezca a la casa seleccionada

### Error: "new row for relation 'mascotas' violates check constraint 'mascotas_tipo_check'"
**Causa:** Tipo no es 'perro', 'gato' o 'otro'  
**Solución:** Verificar que el tipo sea uno de los valores permitidos

### Modal no carga residentes
**Causa:** Casa no seleccionada o función `loadResidentesPorCasa()` no se ejecuta  
**Solución:** Verificar que el evento `onchange` del dropdown de casa esté funcionando

### Vacunas no se marcan como vencidas
**Causa:** Función `get_mascotas_vacunas_vencidas()` no ejecutada  
**Solución:** Verificar que la función esté creada en la base de datos

---

## 📊 Casos de Uso

### Caso 1: Registrar mascota particular
1. Admin selecciona "Mascotas" → "Nueva Mascota"
2. Selecciona Casa #15
3. Selecciona Dueño "Juan Pérez"
4. Ingresa Nombre "Max", Tipo "Perro", Raza "Golden Retriever"
5. Marca certificado de vacunas
6. Guarda
**Resultado:** Mascota registrada con dueño específico

### Caso 2: Registrar mascota comunitaria
1. Admin selecciona "Mascotas" → "Nueva Mascota"
2. Selecciona Casa #20
3. **NO selecciona dueño** (deja dropdown en "Mascota Comunitaria")
4. Ingresa Nombre "Firulais", Tipo "Perro"
5. Guarda
**Resultado:** Mascota registrada sin dueño particular (comunitaria)

### Caso 3: Residente se muda y elimina su cuenta
1. Admin elimina residente ID 5
2. Sus 2 mascotas (Max y Luna) automáticamente pasan a `residente_id = NULL`
3. Mascotas ahora aparecen como "COMUNITARIA"
**Resultado:** Mascotas no se pierden, se preservan como comunitarias

### Caso 4: Consultar vacunas vencidas
1. Admin accede a `GET /api/mascotas/vacunas/vencidas`
2. Sistema retorna lista de mascotas sin vacunar o con vacunas > 1 año
3. Se puede generar reporte o contactar a dueños
**Resultado:** Control proactivo de vacunación

---

## 📞 Contacto

Para dudas o problemas con la implementación, revisar:
- `backend/routes/mascotas.routes.js` - Lógica de backend
- `public/admin-panel.html` - Funciones `loadMascotas()`, `saveMascota()`, `loadResidentesPorCasa()`, etc.
- `scripts/database/003_create_mascotas.sql` - Estructura de BD

---

**Documento generado automáticamente por AI Assistant**  
**Última actualización:** Enero 2025
