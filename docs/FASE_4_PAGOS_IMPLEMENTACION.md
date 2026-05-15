# FASE 4: Implementación del Módulo de Pagos

## ✅ Estado: COMPLETADA
**Fecha de implementación:** Mayo 2026  
**Desarrollador:** AI Assistant

---

## 📋 Descripción General

Módulo completo para gestionar pagos de cuota social y junta de vecinos, con generación automática de pagos por período, control de morosidad, y registro de comprobantes.

---

## 🗂️ Archivos Creados/Modificados

### 1. Migration SQL
**Archivo:** `scripts/database/004_create_pagos.sql`

#### Estructura de la Tabla `pagos`
```sql
CREATE TABLE IF NOT EXISTS pagos (
    id SERIAL PRIMARY KEY,
    casa_id INTEGER NOT NULL,
    periodo VARCHAR(7) NOT NULL, -- Formato: YYYY-MM
    tipo_pago VARCHAR(20) NOT NULL CHECK (tipo_pago IN ('cuota_social', 'junta_vecinos')),
    monto DECIMAL(10,2) NOT NULL CHECK (monto >= 0),
    estado VARCHAR(20) NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'pagado', 'vencido', 'anulado')),
    fecha_vencimiento DATE NOT NULL,
    fecha_pago TIMESTAMPTZ,
    metodo_pago VARCHAR(30) CHECK (metodo_pago IN ('efectivo', 'transferencia', 'cheque', 'tarjeta', 'webpay', 'otro')),
    numero_comprobante VARCHAR(100),
    observaciones TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_casa FOREIGN KEY (casa_id) REFERENCES casas(id) ON DELETE CASCADE
);
```

**Constraints únicos:**
- Un índice único impide que una casa tenga dos pagos del mismo tipo en el mismo período

**Triggers automáticos:**
- `update_pagos_updated_at`: Actualiza `updated_at` en cada modificación
- `actualizar_estado_pagos_vencidos`: Cambia automáticamente el estado a 'vencido' si `fecha_vencimiento < CURRENT_DATE`

#### Funciones Especiales

**`get_morosidad_casa(p_casa_id INTEGER)`**
Retorna información detallada de morosidad de una casa:
- Total de deuda pendiente
- Cantidad de pagos vencidos
- Meses de morosidad
- Estado de morosidad (al_dia, mora_leve, mora_moderada, mora_grave)

**`get_estadisticas_pagos_periodo(p_periodo VARCHAR)`**
Retorna estadísticas completas por período:
- Total de pagos y monto total
- Pagos pendientes/pagados/vencidos con montos
- Tasa de cumplimiento (% de pagos realizados)

**`get_historial_pagos_casa(p_casa_id INTEGER, p_limite INTEGER)`**
Lista histórico de pagos de una casa con límite configurable.

**`generar_pagos_periodo(p_periodo VARCHAR, p_fecha_vencimiento DATE)`**
**Función crítica:** Genera automáticamente pagos para TODAS las casas activas en un período:
- Lee los montos configurados en cada casa (cuota_social, junta_vecinos)
- Crea pagos solo si el monto > 0
- Detecta y salta pagos duplicados
- Retorna estadísticas de casas procesadas/pagos generados/pagos saltados

**`registrar_pago(p_pago_id INTEGER, p_metodo_pago VARCHAR, p_numero_comprobante VARCHAR, p_fecha_pago TIMESTAMPTZ)`**
Marca un pago como pagado y registra método + comprobante.

#### Vista `v_pagos_completo`
```sql
CREATE OR REPLACE VIEW v_pagos_completo AS
SELECT 
    p.id,
    p.casa_id,
    c.numero_casa,
    c.direccion as casa_direccion,
    c.plaza_id,
    pl.nombre as plaza_nombre,
    p.periodo,
    EXTRACT(YEAR FROM TO_DATE(p.periodo || '-01', 'YYYY-MM-DD'))::INTEGER as anio,
    EXTRACT(MONTH FROM TO_DATE(p.periodo || '-01', 'YYYY-MM-DD'))::INTEGER as mes,
    p.tipo_pago,
    p.monto,
    p.estado,
    p.fecha_vencimiento,
    CASE 
        WHEN p.estado = 'pendiente' AND p.fecha_vencimiento < CURRENT_DATE THEN 
            (CURRENT_DATE - p.fecha_vencimiento)::INTEGER
        ELSE 0
    END as dias_vencido,
    p.fecha_pago,
    p.metodo_pago,
    p.numero_comprobante,
    p.observaciones,
    p.activo,
    p.created_at,
    p.updated_at
FROM pagos p
INNER JOIN casas c ON p.casa_id = c.id
INNER JOIN plazas pl ON c.plaza_id = pl.id;
```

### 2. Backend API
**Archivo:** `backend/routes/pagos.routes.js`

#### Endpoints Implementados

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/api/pagos` | Lista todos los pagos con filtros |
| GET | `/api/pagos/casa/:casa_id` | Historial de pagos de una casa |
| GET | `/api/pagos/morosidad/:casa_id` | Información de morosidad de una casa |
| GET | `/api/pagos/estadisticas/periodo` | Estadísticas por período |
| GET | `/api/pagos/morosas` | Lista de casas con pagos vencidos |
| POST | `/api/pagos` | Crear pago manual |
| POST | `/api/pagos/generar-periodo` | Generar pagos automáticos para un período |
| PUT | `/api/pagos/:id` | Actualizar pago existente |
| PUT | `/api/pagos/:id/registrar` | Registrar/marcar pago como pagado |
| DELETE | `/api/pagos/:id` | Soft delete de pago |

#### Validaciones Implementadas
- **Período:** Formato `YYYY-MM` estricto (regex: `^\d{4}-(0[1-9]|1[0-2])$`)
- **Tipo de pago:** Solo `cuota_social` o `junta_vecinos`
- **Estado:** Solo `pendiente`, `pagado`, `vencido`, `anulado`
- **Método de pago:** Solo `efectivo`, `transferencia`, `cheque`, `tarjeta`, `webpay`, `otro`
- **Duplicados:** Impide crear pagos duplicados (mismo casa_id + periodo + tipo_pago)
- **Protección:** No se puede modificar/eliminar un pago ya pagado (excepto anularlo)

#### Filtros Disponibles en GET `/api/pagos`
- `casa_id`: Filtrar por casa
- `periodo`: Filtrar por período (YYYY-MM)
- `tipo_pago`: Filtrar por tipo (cuota_social/junta_vecinos)
- `estado`: Filtrar por estado (pendiente/pagado/vencido/anulado)
- `activo`: Filtrar por estado activo/inactivo

### 3. Integración en Server
**Archivo:** `backend/server.js`

```javascript
const pagosRoutes = require('./routes/pagos.routes');
app.use('/api/pagos', pagosRoutes);
```

### 4. Frontend (Admin Panel)
**Archivo:** `public/admin-panel.html`

#### Componentes Agregados

**1. Nav-link en Sidebar**
```html
<a class="nav-link" href="#" onclick="showSection('pagos')">
    <i class="fas fa-money-bill-wave me-2"></i> Pagos
</a>
```

**2. Sección de Pagos**
- Tabla con columnas: Casa, Período, Tipo, Monto, Estado, Vencimiento, Fecha Pago, Método, Acciones
- Filtros: Por casa, Por período (month input), Por tipo, Por estado
- Botón "Nuevo Pago Manual"
- Botón "Generar Pagos Automáticos"
- Botón "Ver Casas Morosas"
- Acciones por fila:
  - ✅ Registrar Pago (solo pendiente/vencido)
  - 🗑️ Eliminar (solo NO pagados)

**3. Modal de Pago Manual**
Campos del formulario:
- Casa (obligatorio) - Dropdown
- Período (obligatorio) - Month picker (formato YYYY-MM)
- Tipo (obligatorio) - Dropdown: Cuota Social / Junta Vecinos
- Monto (obligatorio) - Number input
- Vencimiento (obligatorio) - Date picker

**4. Modal de Generar Pagos Automáticos**
Campos del formulario:
- Período (obligatorio) - Month picker
- Fecha Vencimiento (opcional) - Si no se especifica, usa último día del mes
- Alerta informativa sobre qué se generará

Al ejecutar:
- Muestra confirmación con período
- Ejecuta generación masiva
- Muestra resumen: casas procesadas, pagos generados, pagos saltados

**5. Modal de Registrar Pago**
- Muestra información del pago (casa, período, tipo, monto)
- Método de Pago (obligatorio) - Dropdown
- Número de Comprobante (opcional)
- Fecha de Pago (opcional, por defecto fecha/hora actual)

**6. Modal de Casas Morosas**
- Tabla con: Casa, Pagos Vencidos, Deuda Total, Acciones
- Botón "Ver Pagos" que filtra la vista principal por esa casa

**7. Funciones JavaScript**
- `loadPagos()`: Carga pagos con filtros aplicados
- `renderPagosTable(pagos)`: Renderiza tabla con badges de estado y formateo de moneda
- `showPagoForm()`: Abre modal de crear pago manual
- `savePago()`: Guarda pago manual (POST)
- `showGenerarPagosForm()`: Abre modal de generación automática
- `generarPagosAutomaticos()`: Ejecuta generación masiva de pagos
- `showRegistrarPagoForm()`: Abre modal de registrar pago
- `confirmarRegistroPago()`: Marca pago como pagado (PUT /registrar)
- `showCasasMorosas()`: Abre modal con casas morosas
- `filterPagosByCasa()`: Filtra pagos por casa desde modal de morosas
- `deletePago()`: Soft delete con confirmación

---

## 🔐 Características de Seguridad

1. **Middleware de Autenticación:** Todas las rutas requieren `requireAuthAdmin`
2. **Validación de Período:** Regex estricto para evitar formatos inválidos
3. **Protección de Pagos Realizados:**
   - No se pueden modificar pagos con estado "pagado" (excepto anularlo)
   - No se pueden eliminar pagos con estado "pagado"
4. **Soft Delete:** Los pagos se marcan como `activo=false`
5. **Prevención de Duplicados:** Index único para evitar doble registro en mismo período/tipo
6. **Trigger Automático:** Estado se actualiza a "vencido" automáticamente al pasar fecha de vencimiento

---

## 📊 Relaciones de Base de Datos

```
plazas (1) -----> (N) casas (1) -----> (N) pagos
```

**Comportamiento:**
- Al eliminar una `casa`: Se eliminan automáticamente todos sus `pagos` (CASCADE)
- Constraints únicos evitan duplicar pagos en el mismo período

---

## 💰 Flujo de Trabajo Recomendado

### Caso de Uso 1: Generar Pagos Mensuales
1. Admin accede a "Pagos" → "Generar Pagos Automáticos"
2. Selecciona período (ej: 2026-06)
3. (Opcional) Define fecha de vencimiento personalizada
4. Confirma generación
5. Sistema crea automáticamente 2 pagos por casa (cuota social + junta vecinos) si tienen montos configurados
6. Muestra resumen de casas procesadas

### Caso de Uso 2: Registrar Pago Recibido
1. Admin ve lista de pagos pendientes/vencidos
2. Click en botón ✅ "Registrar Pago"
3. Selecciona método de pago (transferencia, efectivo, etc.)
4. Ingresa número de comprobante
5. Confirma
6. Pago cambia a estado "pagado" con fecha y método registrados

### Caso de Uso 3: Consultar Casas Morosas
1. Admin click en "Ver Casas Morosas"
2. Modal muestra lista ordenada por deuda
3. Click en "Ver Pagos" de una casa específica
4. Se filtra vista principal solo con pagos vencidos de esa casa

### Caso de Uso 4: Crear Pago Manual
1. Admin click en "Nuevo Pago Manual"
2. Selecciona casa, período, tipo, monto, vencimiento
3. Guarda
4. Útil para pagos extraordinarios o correcciones

---

## 🧪 Verificación de Implementación

### 1. Ejecutar Migraciones
```bash
# Opción 1: Supabase SQL Editor (RECOMENDADO)
1. Ir a https://app.supabase.com/project/ixttdxkelassioemefbo/sql/new
2. Copiar contenido de scripts/database/004_create_pagos.sql
3. Ejecutar

# Opción 2: psql
psql "postgresql://postgres.ixttdxkelassioemefbo:MacBookPro710@aws-0-us-east-2.pooler.supabase.com:6543/postgres" -f scripts/database/004_create_pagos.sql
```

### 2. Verificar Tablas
```sql
-- Verificar que la tabla existe
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' AND table_name = 'pagos';

-- Verificar estructura
\d pagos

-- Verificar vista
SELECT * FROM v_pagos_completo LIMIT 5;

-- Probar función de generación automática (modo prueba)
SELECT * FROM generar_pagos_periodo('2026-06', '2026-06-30');
```

### 3. Probar Backend
```bash
# Iniciar servidor
cd backend
node server.js

# Probar endpoint de generación
curl -X POST http://localhost:3000/api/pagos/generar-periodo \
  -H "Content-Type: application/json" \
  -H "Cookie: connect.sid=<session-cookie>" \
  -d '{"periodo":"2026-06","fecha_vencimiento":"2026-06-30"}'

# Probar endpoint de estadísticas
curl -X GET "http://localhost:3000/api/pagos/estadisticas/periodo?periodo=2026-06" \
  -H "Cookie: connect.sid=<session-cookie>"
```

### 4. Probar Frontend
1. Ir a `http://localhost:3000/admin-panel.html`
2. Click en "Pagos" en el sidebar
3. Click en "Generar Pagos Automáticos"
4. Seleccionar período "2026-06"
5. Confirmar generación
6. Verificar mensaje de éxito con resumen
7. Ver tabla poblada con pagos generados
8. Probar "Registrar Pago" en un pago pendiente
9. Probar "Ver Casas Morosas"

---

## 🚀 Próximos Pasos

### FASE 5: Módulo de Vehículos + Control de Acceso (FINAL)
- **Dependencia:** Requiere `casas.id`, `residentes.id` (opcional), y **`pagos` (Fase 4)**
- **Características:**
  - Registro de vehículos por casa/residente
  - Patente, marca, modelo, color, año
  - **Control de acceso basado en estado de pago** (integración crítica con Fase 4)
  - Bloqueo automático de vehículos si casa tiene pagos vencidos
  - Registro de entradas/salidas de vehículos
  - Vista para guardias con validación de estado de pago
  - Alertas de vehículos bloqueados por morosidad

---

## 📝 Notas Técnicas

### Formato de Período
El período se almacena en formato `YYYY-MM` (ej: `2026-05`)

**HTML Month Input → Backend:**
```javascript
// HTML: <input type="month"> retorna "2026-05"
// Backend espera: "2026-05"
// ✅ Compatible directo
```

### Estados de Pago
- **pendiente**: Pago creado pero no pagado, fecha de vencimiento no alcanzada
- **vencido**: Pago no pagado y fecha de vencimiento ya pasó (se actualiza automáticamente vía trigger)
- **pagado**: Pago realizado y registrado
- **anulado**: Pago cancelado/invalidado (único cambio permitido desde "pagado")

### Clasificación de Morosidad
```sql
CASE 
    WHEN pagos_vencidos = 0 THEN 'al_dia'
    WHEN pagos_vencidos <= 2 THEN 'mora_leve'
    WHEN pagos_vencidos <= 5 THEN 'mora_moderada'
    ELSE 'mora_grave'
END
```

### Formateo de Moneda en Frontend
```javascript
const montoFormateado = new Intl.NumberFormat('es-CL', { 
    style: 'currency', 
    currency: 'CLP' 
}).format(pago.monto);
// Output: "$50.000"
```

### Generación Automática de Pagos
La función `generar_pagos_periodo()` usa un loop sobre todas las casas activas:
- Lee `monto_cuota_social` y `monto_junta_vecinos` de cada casa
- Solo crea pago si `monto > 0`
- Usa `ON CONFLICT DO NOTHING` para saltear duplicados
- Retorna estadísticas completas de la operación

---

## ✅ Checklist de Implementación

- [x] Migration SQL creada (`004_create_pagos.sql`)
- [x] Vista `v_pagos_completo` creada
- [x] Función `get_morosidad_casa` creada
- [x] Función `get_estadisticas_pagos_periodo` creada
- [x] Función `get_historial_pagos_casa` creada
- [x] Función `generar_pagos_periodo` creada (CRÍTICA)
- [x] Función `registrar_pago` creada
- [x] Triggers `update_pagos_updated_at` y `actualizar_estado_pagos_vencidos` creados
- [x] Backend API implementada (`pagos.routes.js`)
- [x] Rutas montadas en `server.js`
- [x] Nav-link agregado al sidebar
- [x] Sección de pagos agregada al HTML
- [x] Modal de crear pago manual implementado
- [x] Modal de generar pagos automáticos implementado
- [x] Modal de registrar pago implementado
- [x] Modal de casas morosas implementado
- [x] Funciones JavaScript implementadas (10 funciones)
- [x] Validación de período YYYY-MM en frontend y backend
- [x] Formateo de moneda en pesos chilenos (CLP)
- [x] Integración con módulo de Casas (dropdown + montos)
- [ ] **PENDIENTE:** Ejecutar migraciones en Supabase
- [ ] **PENDIENTE:** Generar primeros pagos de prueba

---

## 🐛 Troubleshooting

### Error: "new row for relation 'pagos' violates check constraint 'pagos_periodo_check'"
**Causa:** Período no cumple con formato `YYYY-MM`  
**Solución:** Verificar que el período tenga exactamente el formato `2026-05` (4 dígitos año + guión + 2 dígitos mes)

### Error: "duplicate key value violates unique constraint 'idx_pagos_unico_periodo'"
**Causa:** Ya existe un pago del mismo tipo para esa casa en ese período  
**Solución:** Cambiar el período o usar el pago existente

### Error: "No se puede modificar un pago ya realizado"
**Causa:** Intentando modificar un pago con estado "pagado"  
**Solución:** Si necesita anular un pago pagado, actualizar solo el campo `estado` a 'anulado'

### Pagos no cambian a "vencido" automáticamente
**Causa:** Trigger `actualizar_estado_pagos_vencidos` no ejecutado o deshabilitado  
**Solución:** Verificar que el trigger esté activo en la base de datos

### Generación automática salta todas las casas
**Causa:** Las casas tienen `monto_cuota_social = 0` y `monto_junta_vecinos = 0`  
**Solución:** Configurar montos en el módulo de Casas primero

### Modal de registrar pago no se abre
**Causa:** Bootstrap no inicializado o parámetros incorrectos  
**Solución:** Verificar que los parámetros `(id, casa, periodo, tipo, monto)` se pasen correctamente

---

## 📞 Contacto

Para dudas o problemas con la implementación, revisar:
- `backend/routes/pagos.routes.js` - Lógica de backend
- `public/admin-panel.html` - Funciones `loadPagos()`, `savePago()`, `generarPagosAutomaticos()`, etc.
- `scripts/database/004_create_pagos.sql` - Estructura de BD y funciones SQL

---

**Documento generado automáticamente por AI Assistant**  
**Última actualización:** Mayo 2026
