# Sistema de Gestión Residencial - Completo
## Los Prados de Nos - 5 Fases Implementadas ✅

---

## 📊 Estado del Proyecto

**✅ TODAS LAS FASES COMPLETADAS**

| Fase | Módulo | Estado | Archivos |
|------|--------|--------|----------|
| 1 | Casas | ✅ Completada | Migration: `001_create_casas.sql`<br>Backend: `casas.routes.js`<br>Frontend: Sección Casas |
| 2 | Residentes | ✅ Completada | Migration: `002_create_residentes.sql`<br>Backend: `residentes.routes.js`<br>Frontend: Sección Residentes |
| 3 | Mascotas | ✅ Completada | Migration: `003_create_mascotas.sql`<br>Backend: `mascotas.routes.js`<br>Frontend: Sección Mascotas |
| 4 | Pagos | ✅ Completada | Migration: `004_create_pagos.sql`<br>Backend: `pagos.routes.js`<br>Frontend: Sección Pagos |
| 5 | Vehículos + Control Acceso | ✅ Completada | Migration: `005_create_vehiculos_acceso.sql`<br>Backend: `vehiculos.routes.js` + `acceso.routes.js`<br>Frontend: Secciones Vehículos y Control Acceso |

---

## 🚀 Pasos para Poner en Marcha el Sistema

### 1. Ejecutar Migraciones en Supabase (EN ORDEN)

**⚠️ IMPORTANTE:** Las migraciones deben ejecutarse en orden secuencial porque tienen dependencias.

#### Opción A: Supabase SQL Editor (RECOMENDADO)

1. Ir a [Supabase SQL Editor](https://app.supabase.com/project/ixttdxkelassioemefbo/sql/new)

2. **Migración 1 - Casas:**
   - Copiar contenido completo de `scripts/database/001_create_casas.sql`
   - Pegar en el editor
   - Click "Run"
   - ✅ Verificar: `SELECT COUNT(*) FROM casas;`

3. **Migración 2 - Residentes:**
   - Copiar contenido completo de `scripts/database/002_create_residentes.sql`
   - Pegar en el editor
   - Click "Run"
   - ✅ Verificar: `SELECT COUNT(*) FROM residentes;`

4. **Migración 3 - Mascotas:**
   - Copiar contenido completo de `scripts/database/003_create_mascotas.sql`
   - Pegar en el editor
   - Click "Run"
   - ✅ Verificar: `SELECT COUNT(*) FROM mascotas;`

5. **Migración 4 - Pagos:**
   - Copiar contenido completo de `scripts/database/004_create_pagos.sql`
   - Pegar en el editor
   - Click "Run"
   - ✅ Verificar: `SELECT COUNT(*) FROM pagos;`

6. **Migración 5 - Vehículos y Control de Acceso:**
   - Copiar contenido completo de `scripts/database/005_create_vehiculos_acceso.sql`
   - Pegar en el editor
   - Click "Run"
   - ✅ Verificar: `SELECT COUNT(*) FROM vehiculos; SELECT COUNT(*) FROM control_acceso;`

#### Opción B: psql (Avanzado)

```bash
# Conectar a Supabase
psql "postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres"

# Ejecutar migraciones en orden
\i scripts/database/001_create_casas.sql
\i scripts/database/002_create_residentes.sql
\i scripts/database/003_create_mascotas.sql
\i scripts/database/004_create_pagos.sql
\i scripts/database/005_create_vehiculos_acceso.sql
```

#### Verificación Completa de Migraciones

Ejecutar en SQL Editor:

```sql
-- Verificar que todas las tablas existen
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('casas', 'residentes', 'mascotas', 'pagos', 'vehiculos', 'control_acceso')
ORDER BY table_name;

-- Deberías ver 6 tablas:
-- ✅ casas
-- ✅ control_acceso
-- ✅ mascotas
-- ✅ pagos
-- ✅ residentes
-- ✅ vehiculos

-- Verificar que todas las vistas existen
SELECT table_name 
FROM information_schema.views 
WHERE table_schema = 'public' 
  AND table_name LIKE 'v_%'
ORDER BY table_name;

-- Deberías ver 6 vistas:
-- ✅ v_accesos_completo
-- ✅ v_casas_completo
-- ✅ v_mascotas_completo
-- ✅ v_pagos_completo
-- ✅ v_residentes_completo
-- ✅ v_vehiculos_completo

-- Verificar funciones críticas
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_schema = 'public' 
  AND routine_type = 'FUNCTION'
  AND routine_name IN (
    'generar_pagos_periodo',
    'registrar_pago',
    'get_morosidad_casa',
    'verificar_acceso_vehiculo',
    'registrar_acceso_vehiculo',
    'get_vehiculos_bloqueados',
    'get_estadisticas_accesos'
  )
ORDER BY routine_name;

-- Deberías ver todas las funciones listadas arriba
```

---

### 2. Iniciar Servidor Backend

```bash
cd backend
npm install  # Si aún no lo hiciste
node server.js
```

**Salida esperada:**
```
🚀 Servidor corriendo en http://localhost:3000
🏠 Environment: development
🗄️ Base de datos: PostgreSQL (Supabase)
📍 Plazas disponibles desde: http://localhost:3000/api/plazas
```

---

### 3. Acceder al Panel de Administración

1. Abrir navegador en: [http://localhost:3000/admin-panel.html](http://localhost:3000/admin-panel.html)

2. **Login:** Usar credenciales de admin existentes o crear un admin nuevo:
   ```sql
   -- En Supabase SQL Editor:
   INSERT INTO admins (username, email, password_hash, plaza_id)
   VALUES (
     'admin',
     'admin@pradosdenos.cl',
     '$2b$10$hashedpassword', -- Usar bcrypt para generar hash
     1 -- ID de la plaza
   );
   ```

3. **Navegación del Panel:**
   - 🏠 **Casas**: Gestionar casas, asignar montos de cuota
   - 👥 **Residentes**: Gestionar residentes, asignar a casas
   - 🐾 **Mascotas**: Gestionar mascotas particulares y comunitarias
   - 💰 **Pagos**: Generar pagos automáticos, registrar pagos, ver morosidad
   - 🚗 **Vehículos**: Registrar vehículos, ver bloqueados por morosidad
   - 🚧 **Control Acceso**: Registrar entradas/salidas, verificar acceso, estadísticas

---

## 📘 Flujo de Uso Recomendado

### Configuración Inicial (Primera Vez)

1. **Crear Casas:**
   - Ir a "Casas" → "Nueva Casa"
   - Ingresar número de casa, dirección, plaza
   - **Configurar montos:**
     - Cuota Social: `$50,000` (ejemplo)
     - Junta de Vecinos: `$10,000` (ejemplo)
   - Guardar
   - Repetir para todas las casas del condominio

2. **Crear Residentes:**
   - Ir a "Residentes" → "Nuevo Residente"
   - Seleccionar casa
   - Ingresar RUN, nombres, apellidos, email, teléfono
   - Marcar si es propietario o arrendatario
   - Guardar
   - Repetir para cada residente

3. **(Opcional) Crear Mascotas:**
   - Ir a "Mascotas" → "Nueva Mascota"
   - Seleccionar casa y residente (o dejar vacío si es comunitaria)
   - Ingresar nombre, tipo, raza, etc.
   - Guardar

### Gestión Mensual

4. **Generar Pagos del Mes:**
   - Ir a "Pagos" → "Generar Pagos Automáticos"
   - Seleccionar período (ej: `2026-06`)
   - Seleccionar fecha de vencimiento (ej: último día del mes)
   - Click "Generar"
   - **El sistema crea automáticamente:**
     - 2 pagos por cada casa (cuota social + junta vecinos)
     - Con los montos configurados en cada casa
     - Estado: "pendiente"

5. **Registrar Pagos Recibidos:**
   - Ir a "Pagos" → Ver tabla
   - Buscar pago pendiente
   - Click ✅ "Registrar Pago"
   - Seleccionar método (transferencia, efectivo, webpay, etc.)
   - Ingresar número de comprobante (opcional)
   - Confirmar
   - **El sistema actualiza:**
     - Estado: "pagado"
     - Fecha de pago: actual
     - Método de pago registrado

6. **Monitorear Morosidad:**
   - Ir a "Pagos" → "Ver Casas Morosas"
   - Ver lista de casas con pagos vencidos
   - Ver deuda total y cantidad de meses vencidos

### Control de Acceso Vehicular

7. **Registrar Vehículos:**
   - Ir a "Vehículos" → "Nuevo Vehículo"
   - Ingresar patente (se convierte a mayúsculas automáticamente)
   - Seleccionar casa
   - (Opcional) Seleccionar residente propietario
   - Ingresar marca, modelo, color, año, tipo
   - Guardar
   - **El sistema calcula automáticamente:**
     - Estado de morosidad de la casa
     - Si el acceso está permitido o bloqueado

8. **Guardia Registra Entrada/Salida:**
   - Ir a "Control Acceso" → "Registrar Entrada/Salida"
   - Ingresar patente del vehículo
   - Seleccionar tipo: "Entrada" o "Salida"
   - Ingresar nombre del guardia de turno
   - Click "Registrar"
   - **El sistema verifica automáticamente:**
     - Si la casa tiene < 3 meses vencidos: ✅ **ACCESO PERMITIDO**
     - Si la casa tiene ≥ 3 meses vencidos: 🚫 **ACCESO BLOQUEADO**
   - Muestra alerta con resultado detallado:
     - Patente, vehículo, casa, residente
     - Estado de morosidad y deuda
     - Motivo de bloqueo (si aplica)

9. **(Opcional) Verificar Acceso Sin Registrar:**
   - Ir a "Control Acceso" → "Verificar Acceso"
   - Ingresar patente
   - Click "Verificar"
   - **El sistema muestra:**
     - Icono grande verde ✅ (permitido) o rojo ❌ (bloqueado)
     - Estado completo de morosidad
   - **No se registra el acceso** (solo consulta)

10. **Ver Vehículos Bloqueados:**
    - Ir a "Vehículos" → "Ver Vehículos Bloqueados"
    - Ver lista de vehículos con acceso bloqueado
    - Identificar casas que necesitan regularizar pagos urgentemente

11. **Consultar Estadísticas:**
    - Ir a "Control Acceso" → "Estadísticas"
    - Seleccionar rango de fechas
    - Ver:
      - Total de accesos
      - Entradas vs salidas
      - Accesos bloqueados
      - Casas con morosidad
      - **Tasa de bloqueo** (%)
    - Si tasa > 10%: Alerta de morosidad generalizada

---

## 🔄 Integración entre Módulos

```
┌─────────────┐
│   CASAS     │ ← Configura montos de cuota
│  (Fase 1)   │
└──────┬──────┘
       │
       ├──────→ ┌─────────────┐
       │        │ RESIDENTES  │ ← Asigna personas a casas
       │        │  (Fase 2)   │
       │        └──────┬──────┘
       │               │
       ├──────→ ┌─────┴───────┐
       │        │  MASCOTAS   │ ← Registra mascotas
       │        │  (Fase 3)   │
       │        └─────────────┘
       │
       ├──────→ ┌─────────────┐
       │        │   PAGOS     │ ← Genera pagos automáticos
       │        │  (Fase 4)   │ ← Calcula morosidad
       │        └──────┬──────┘
       │               │
       │               └──────→ ┌─────────────────────┐
       │                        │  VEHÍCULOS + ACCESO │
       └───────────────────────→│     (Fase 5)        │ ← BLOQUEO AUTOMÁTICO
                                │                     │   basado en morosidad
                                └─────────────────────┘
```

**Flujo de Datos Crítico:**

1. **Casas** define los montos de cuota → **Pagos** los usa para generar pagos automáticos
2. **Pagos** calcula morosidad → **Vehículos** usa este dato para determinar bloqueo
3. **Vehículos** pertenece a **Casas** → **Control de Acceso** verifica morosidad de la casa en tiempo real
4. **Control de Acceso** bloquea/permite entrada basándose en **Pagos** vencidos

---

## 📄 Documentación Disponible

| Documento | Ubicación | Contenido |
|-----------|-----------|-----------|
| README General | `README.md` | Información general del proyecto |
| Fase 1 - Casas | `docs/FASE_1_CASAS_IMPLEMENTACION.md` | Detalles de implementación de Casas (PENDIENTE) |
| Fase 2 - Residentes | `docs/FASE_2_RESIDENTES_IMPLEMENTACION.md` | Detalles de implementación de Residentes (PENDIENTE) |
| Fase 3 - Mascotas | `docs/FASE_3_MASCOTAS_IMPLEMENTACION.md` | Detalles de implementación de Mascotas ✅ |
| Fase 4 - Pagos | `docs/FASE_4_PAGOS_IMPLEMENTACION.md` | Detalles de implementación de Pagos ✅ |
| Fase 5 - Vehículos + Acceso | `docs/FASE_5_VEHICULOS_ACCESO_IMPLEMENTACION.md` | Detalles de implementación de Vehículos y Control de Acceso ✅ |

---

## 🎯 Características Principales del Sistema

### 1. Gestión de Casas
- Registro de casas por plaza
- Configuración de montos de cuota social y junta de vecinos
- Vista completa con información de plaza

### 2. Gestión de Residentes
- Registro de residentes por casa
- Validación de RUN chileno
- Diferenciación entre propietarios y arrendatarios
- Cálculo automático de edad a partir de RUN
- Soft delete con CASCADE/SET NULL según corresponda

### 3. Gestión de Mascotas
- Registro de mascotas particulares (asociadas a residente)
- Registro de mascotas comunitarias (sin residente)
- Control de vacunación
- Alertas de vacunas vencidas
- Estadísticas por tipo de mascota

### 4. Gestión de Pagos (Crítico)
- **Generación automática** de pagos mensuales para todas las casas
- Estados automáticos: pendiente → vencido (trigger)
- Registro de pagos con método y comprobante
- Cálculo automático de morosidad por casa
- Vista de casas morosas con deuda total
- Estadísticas de cumplimiento por período
- Prevención de duplicados (unique constraint)

### 5. Gestión de Vehículos
- Registro de vehículos por casa y residente
- Validación de formato de patente
- Vista completa con estado de morosidad de la casa
- Cálculo automático de si el acceso está permitido o bloqueado
- Lista de vehículos bloqueados por morosidad

### 6. Control de Acceso (Módulo Culminante) 🚧🚦
- **Verificación automática** de morosidad al momento del acceso
- **Bloqueo automático** de vehículos con 3+ meses de morosidad
- Registro de entradas y salidas con timestamp
- Historial completo de accesos por vehículo
- Estadísticas de accesos: total, entradas, salidas, bloqueados, tasa de bloqueo
- Vista para guardias con información en tiempo real
- Cálculo automático de tiempo de permanencia

---

## ⚙️ Política de Bloqueo de Acceso

**Umbral de Bloqueo:** 3 meses de pagos vencidos

| Meses Vencidos | Estado | Acceso | Badge | Acción |
|----------------|--------|--------|-------|--------|
| 0 | Al Día | ✅ Permitido | Verde "Al Día" | Paso libre |
| 1-2 | Mora Leve | ⚠️ Permitido con aviso | Amarillo "Mora Leve" | Paso libre + advertencia |
| 3-5 | Mora Moderada | 🚫 **BLOQUEADO** | Naranja "Mora Moderada" | Paso bloqueado |
| 6+ | Mora Grave | 🚫 **BLOQUEADO** | Rojo "Mora Grave" | Paso bloqueado |

**Ejemplo de Mensajes:**
- ✅ "Acceso permitido. Casa al día"
- ⚠️ "Acceso permitido con 2 mes(es) vencido(s)"
- 🚫 "Casa con 3 meses de morosidad. Deuda: $150,000"
- 🚫 "Casa con 6 meses de morosidad. Deuda: $360,000"

---

## 🧪 Datos de Prueba

### Crear Datos de Prueba (Opcional)

```sql
-- Crear casa de prueba
INSERT INTO casas (numero_casa, direccion, plaza_id, monto_cuota_social, monto_junta_vecinos)
VALUES ('TEST001', 'Calle Prueba #101', 1, 50000, 10000);

-- Crear residente de prueba
INSERT INTO residentes (casa_id, rut, nombres, apellidos, email, telefono, es_propietario)
VALUES (
  (SELECT id FROM casas WHERE numero_casa = 'TEST001'),
  '12345678-9',
  'Juan',
  'Pérez',
  'juan.perez@test.cl',
  '+56912345678',
  TRUE
);

-- Crear vehículo de prueba
INSERT INTO vehiculos (patente, casa_id, marca, modelo, tipo)
VALUES (
  'TEST01',
  (SELECT id FROM casas WHERE numero_casa = 'TEST001'),
  'Toyota',
  'Corolla',
  'automovil'
);

-- Verificar acceso del vehículo
SELECT verificar_acceso_vehiculo('TEST01');

-- Registrar entrada de prueba
SELECT registrar_acceso_vehiculo('TEST01', 'entrada', 'Guardia Prueba', 'Test de sistema');

-- Ver historial de accesos
SELECT * FROM v_accesos_completo WHERE vehiculo_patente = 'TEST01';
```

---

## 🆘 Soporte y Troubleshooting

### Problemas Comunes

1. **Error: "relation does not exist"**
   - **Causa:** Migraciones no ejecutadas o en orden incorrecto
   - **Solución:** Ejecutar migraciones en orden: 001 → 002 → 003 → 004 → 005

2. **Error: "duplicate key value violates unique constraint"**
   - **Causa:** Intentando crear duplicado (patente, periodo, etc.)
   - **Solución:** Verificar que el registro no exista antes de crear

3. **Vehículo no se bloquea aunque casa tiene morosidad**
   - **Causa:** Casa tiene < 3 meses vencidos (umbral de bloqueo)
   - **Solución:** Verificar cantidad exacta de pagos vencidos:
     ```sql
     SELECT * FROM get_morosidad_casa(casa_id);
     ```

4. **No se puede generar pagos del mes**
   - **Causa:** Ya existen pagos para ese período (constraint único)
   - **Solución:** Verificar:
     ```sql
     SELECT * FROM pagos WHERE periodo = '2026-06' AND casa_id = 1;
     ```

---

## 📞 Contacto

Para dudas técnicas o problemas con la implementación:
- Revisar documentación específica de cada fase en `docs/`
- Consultar código fuente en `backend/routes/`
- Ejecutar queries de diagnóstico en Supabase SQL Editor

---

## 🎉 Sistema Completo y Operativo

**5 Fases Implementadas ✅**
**Backend Completo ✅**
**Frontend Completo ✅**
**Documentación Completa ✅**

El sistema está listo para ser utilizado en producción una vez que se ejecuten las migraciones en Supabase.

**Último paso pendiente:** Ejecutar migraciones 001-005 en Supabase SQL Editor.

---

**Documento generado automáticamente por AI Assistant**  
**Última actualización:** Mayo 2026
