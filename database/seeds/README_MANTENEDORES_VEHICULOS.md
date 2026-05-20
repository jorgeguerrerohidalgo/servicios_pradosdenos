# Mantenedores de Vehículos - Implementación

## 📋 Resumen

Esta funcionalidad implementa **mantenedores normalizados** para Tipos, Marcas y Modelos de vehículos registrados en Chile, reemplazando los campos de texto libre anteriores y mejorando significativamente la calidad de datos.

### Beneficios
- ✅ **Prevención de errores ortográficos**: Dropdowns en lugar de texto libre
- ✅ **Normalización de datos**: Nombres consistentes de marcas y modelos
- ✅ **Cascada inteligente**: Tipo → Marca → Modelo con filtrado automático
- ✅ **Compatibilidad retroactiva**: Campos legacy mantenidos para registros antiguos
- ✅ **Datos reales del mercado chileno**: 45+ marcas, 12 tipos, 180+ modelos populares

---

## 🗄️ Estructura de Base de Datos

### Nuevas Tablas

#### 1. `tipo_vehiculo`
```sql
CREATE TABLE tipo_vehiculo (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    icono VARCHAR(50),  -- Clase Font Awesome (fa-car, fa-motorcycle, etc.)
    orden INTEGER DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Datos incluidos:** Automóvil, Camioneta, SUV, Station Wagon, Motocicleta, Furgón, Van, Camión, Bus, Deportivo, Todo Terreno, Cuatrimoto

#### 2. `marca_vehiculo`
```sql
CREATE TABLE marca_vehiculo (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    pais_origen VARCHAR(50),
    logo_url VARCHAR(255),  -- Opcional para futura expansión
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Datos incluidos:** 45+ marcas del mercado chileno (Toyota, Chevrolet, Nissan, Hyundai, Kia, Suzuki, Ford, Mazda, Peugeot, Mitsubishi, Honda, Volkswagen, BMW, Mercedes-Benz, etc.)

#### 3. `modelo_vehiculo`
```sql
CREATE TABLE modelo_vehiculo (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    marca_id INTEGER NOT NULL REFERENCES marca_vehiculo(id),
    tipo_vehiculo_id INTEGER REFERENCES tipo_vehiculo(id),
    anio_inicio INTEGER,  -- Año de inicio de producción
    anio_fin INTEGER,     -- NULL si aún se produce
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(nombre, marca_id)
);
```

**Datos incluidos:** 180+ modelos populares organizados por marca (Corolla, Yaris, Hilux para Toyota; Spark, Cruze, Tracker para Chevrolet; etc.)

#### 4. Modificación tabla `vehiculos`
```sql
ALTER TABLE vehiculos 
ADD COLUMN tipo_vehiculo_id INTEGER REFERENCES tipo_vehiculo(id),
ADD COLUMN marca_id INTEGER REFERENCES marca_vehiculo(id),
ADD COLUMN modelo_id INTEGER REFERENCES modelo_vehiculo(id);
```

**Compatibilidad:** Los campos legacy `tipo`, `marca`, `modelo` (TEXT) se mantienen para registros antiguos. Nuevos registros usan las FKs.

---

## 🚀 Instalación y Ejecución

### Requisitos Previos

- Node.js 18+ instalado
- Archivo `backend/.env` configurado con credenciales de Supabase
- Variable `DATABASE_URL` apuntando a tu base de datos Supabase

### Opción 1: Script Automatizado (Recomendado) ✅

```bash
# Desde la raíz del proyecto
node install-vehicle-maintainers.js
```

Este script:
- ✅ Conecta a Supabase usando las credenciales de `backend/.env`
- ✅ Verifica que no existan tablas duplicadas
- ✅ Aplica la migración 017 automáticamente
- ✅ Carga los 3 seeds en orden correcto
- ✅ Verifica la instalación y muestra resumen

### Opción 2: Panel de Supabase (Manual)

1. Abre [Supabase Dashboard](https://app.supabase.com)
2. Navega a **SQL Editor**
3. Ejecuta en orden:
   - `scripts/database/017_create_vehicle_maintainers.sql`
   - `database/seeds/seed_tipo_vehiculo.sql`
   - `database/seeds/seed_marca_vehiculo.sql`
   - `database/seeds/seed_modelo_vehiculo.sql`

### Opción 3: CLI de Supabase

```bash
# Si tienes Supabase CLI instalado
supabase db reset
supabase db execute -f scripts/database/017_create_vehicle_maintainers.sql
supabase db execute -f database/seeds/seed_tipo_vehiculo.sql
supabase db execute -f database/seeds/seed_marca_vehiculo.sql
supabase db execute -f database/seeds/seed_modelo_vehiculo.sql
```

### Verificar Instalación

Después de ejecutar cualquier opción:

```sql
-- Contar registros (ejecutar en SQL Editor de Supabase)
SELECT 
    (SELECT COUNT(*) FROM tipo_vehiculo) AS tipos,
    (SELECT COUNT(*) FROM marca_vehiculo) AS marcas,
    (SELECT COUNT(*) FROM modelo_vehiculo) AS modelos;

-- Debería retornar aproximadamente:
-- tipos: 12
-- marcas: 45
-- modelos: 180
```

---

## 🔌 API Endpoints (Públicos)

### GET `/api/vehiculos/tipos`
Obtiene todos los tipos de vehículos activos.

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "nombre": "Automóvil",
      "descripcion": "Vehículo de pasajeros tipo sedán, hatchback o citycar",
      "icono": "fa-car",
      "orden": 1
    },
    ...
  ],
  "count": 12
}
```

### GET `/api/vehiculos/marcas?tipo_id={id}`
Obtiene marcas activas, opcionalmente filtradas por tipo.

**Query Params:**
- `tipo_id` (opcional): Filtrar marcas que tengan modelos de ese tipo

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "nombre": "Toyota",
      "pais_origen": "Japón"
    },
    ...
  ],
  "count": 45,
  "filteredByTipo": false
}
```

### GET `/api/vehiculos/marcas/:id/modelos?tipo_id={id}`
Obtiene modelos de una marca específica.

**Path Params:**
- `id`: ID de la marca

**Query Params:**
- `tipo_id` (opcional): Filtrar modelos por tipo de vehículo

**Response:**
```json
{
  "success": true,
  "marca": {
    "nombre": "Toyota",
    "pais_origen": "Japón"
  },
  "data": [
    {
      "id": 1,
      "nombre": "Corolla",
      "anio_inicio": 1966,
      "anio_fin": null,
      "tipo_vehiculo": "Automóvil",
      "tipo_vehiculo_id": 1
    },
    ...
  ],
  "count": 12,
  "filteredByTipo": false
}
```

### GET `/api/vehiculos/modelos/:id`
Obtiene detalles completos de un modelo específico.

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "nombre": "Corolla",
    "marca": "Toyota",
    "marca_id": 1,
    "pais_origen": "Japón",
    "tipo_vehiculo": "Automóvil",
    "tipo_vehiculo_id": 1,
    "tipo_icono": "fa-car",
    "anio_inicio": 1966,
    "anio_fin": null
  }
}
```

### GET `/api/vehiculos/search-modelo?q={query}&marca_id={id}&tipo_id={id}`
Búsqueda de modelos por nombre (autocomplete).

**Query Params:**
- `q`: Término de búsqueda (mínimo 2 caracteres)
- `marca_id` (opcional): Filtrar por marca
- `tipo_id` (opcional): Filtrar por tipo

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "nombre": "Corolla",
      "marca": "Toyota",
      "marca_id": 1,
      "tipo_vehiculo": "Automóvil"
    },
    ...
  ],
  "count": 3
}
```

---

## 🎨 Frontend - Cascada de Dropdowns

### Flujo de Usuario

1. **Seleccionar Tipo** → Carga marcas que tengan modelos de ese tipo
2. **Seleccionar Marca** → Carga modelos de esa marca (filtrados por tipo si aplica)
3. **Seleccionar Modelo** → Formulario completo

### Implementación (admin-panel.html)

```javascript
// Función de inicialización (onopen modal)
async function showVehiculoForm(patente = null) {
    // ... código existente ...
    
    // Cargar tipos de vehículos
    const tiposResponse = await fetch('/api/vehiculos/tipos');
    const tiposData = await tiposResponse.json();
    if (tiposData.success) {
        document.getElementById('vehiculoTipoId').innerHTML = 
            '<option value="">Seleccionar tipo</option>' +
            tiposData.data.map(t => `<option value="${t.id}">${t.nombre}</option>`).join('');
    }
}

// Cascada: Tipo → Marca
async function onVehiculoTipoChange() {
    const tipoId = document.getElementById('vehiculoTipoId').value;
    const response = await fetch(`/api/vehiculos/marcas?tipo_id=${tipoId}`);
    const data = await response.json();
    
    document.getElementById('vehiculoMarcaId').innerHTML = 
        '<option value="">Seleccionar marca</option>' +
        data.data.map(m => `<option value="${m.id}">${m.nombre}</option>`).join('');
    document.getElementById('vehiculoMarcaId').disabled = false;
}

// Cascada: Marca → Modelo
async function onVehiculoMarcaChange() {
    const marcaId = document.getElementById('vehiculoMarcaId').value;
    const tipoId = document.getElementById('vehiculoTipoId').value;
    
    let url = `/api/vehiculos/marcas/${marcaId}/modelos`;
    if (tipoId) url += `?tipo_id=${tipoId}`;
    
    const response = await fetch(url);
    const data = await response.json();
    
    document.getElementById('vehiculoModeloId').innerHTML = 
        '<option value="">Seleccionar modelo</option>' +
        data.data.map(m => `<option value="${m.id}">${m.nombre}</option>`).join('');
    document.getElementById('vehiculoModeloId').disabled = false;
}
```

---

## 🔄 Compatibilidad Retroactiva

El sistema mantiene **100% de compatibilidad** con vehículos registrados anteriormente:

### Modo Dual de Almacenamiento

**Nuevos registros:**
```json
{
  "tipo_vehiculo_id": 1,
  "marca_id": 5,
  "modelo_id": 23,
  "tipo": "Automóvil",     // Copiado desde mantenedor
  "marca": "Toyota",        // Copiado desde mantenedor
  "modelo": "Corolla"       // Copiado desde mantenedor
}
```

**Registros legacy:**
```json
{
  "tipo_vehiculo_id": null,
  "marca_id": null,
  "modelo_id": null,
  "tipo": "automovil",      // Texto libre (legacy)
  "marca": "toyota",        // Texto libre (legacy)
  "modelo": "corolla"       // Texto libre (legacy)
}
```

### Validación Backend

```javascript
// Accepts both legacy and new format
const tieneTipo = tipo || tipo_vehiculo_id;
const tieneMarca = marca || marca_id;
const tieneModelo = modelo || modelo_id;

if (!tieneTipo || !tieneMarca || !tieneModelo) {
    return res.status(400).json({ message: 'Campos requeridos' });
}
```

---

## 📊 Datos del Mercado Chileno

### Marcas por País de Origen

| País | Cantidad | Ejemplos |
|------|----------|----------|
| 🇯🇵 Japón | 7 | Toyota, Nissan, Honda, Mazda, Suzuki, Mitsubishi, Subaru |
| 🇰🇷 Corea del Sur | 3 | Hyundai, Kia, SsangYong |
| 🇨🇳 China | 7 | Changan, Chery, Great Wall, Haval, JAC, MG, Geely, BYD |
| 🇺🇸 Estados Unidos | 8 | Chevrolet, Ford, Dodge, Jeep, Ram, GMC, Chrysler, Tesla |
| 🇩🇪 Alemania | 6 | Volkswagen, BMW, Mercedes-Benz, Audi, Porsche, Opel |
| 🇫🇷 Francia | 3 | Peugeot, Renault, Citroën |
| 🇮🇹 Italia | 1 | Fiat |
| 🇬🇧 Reino Unido | 3 | Jaguar, Land Rover, Mini |
| 🇸🇪 Suecia | 1 | Volvo |
| 🇨🇿 República Checa | 1 | Skoda |
| 🇪🇸 España | 1 | Seat |
| 🇮🇳 India | 1 | Mahindra |

**Total: 45 marcas**

### Top 10 Marcas Más Comunes en Chile

1. Toyota (12 modelos registrados)
2. Chevrolet (10 modelos)
3. Nissan (10 modelos)
4. Hyundai (10 modelos)
5. Kia (10 modelos)
6. Ford (10 modelos)
7. Suzuki (9 modelos)
8. Mazda (9 modelos)
9. Volkswagen (9 modelos)
10. Peugeot (8 modelos)

---

## ⚙️ Mantenimiento y Expansión

### Agregar un Nuevo Tipo

```sql
INSERT INTO tipo_vehiculo (nombre, descripcion, icono, orden, activo)
VALUES ('Scooter Eléctrico', 'Scooter eléctrico urbano', 'fa-bolt', 13, TRUE);
```

### Agregar una Nueva Marca

```sql
INSERT INTO marca_vehiculo (nombre, pais_origen, activo)
VALUES ('BYD', 'China', TRUE);
```

### Agregar Modelos a una Marca

```sql
-- Obtener ID de la marca
SELECT id FROM marca_vehiculo WHERE nombre = 'BYD';

-- Insertar modelos
INSERT INTO modelo_vehiculo (nombre, marca_id, tipo_vehiculo_id, anio_inicio, activo)
VALUES 
('Seal', 15, 1, 2022, TRUE),  -- Automóvil
('Tang', 15, 3, 2015, TRUE);  -- SUV
```

### Actualizar Datos Existentes

```sql
-- Migrar vehículos legacy a mantenedores normalizados
UPDATE vehiculos v
SET 
    tipo_vehiculo_id = tv.id,
    marca_id = m.id,
    modelo_id = mv.id
FROM tipo_vehiculo tv, marca_vehiculo m, modelo_vehiculo mv
WHERE 
    LOWER(v.tipo) = LOWER(tv.nombre)
    AND LOWER(v.marca) = LOWER(m.nombre)
    AND LOWER(v.modelo) = LOWER(mv.nombre)
    AND mv.marca_id = m.id
    AND v.tipo_vehiculo_id IS NULL;  -- Solo actualizar registros sin FKs
```

---

## 🐛 Solución de Problemas

### Error: "ID de tipo, marca o modelo inválido"

**Causa:** Se está intentando asignar un ID que no existe en los mantenedores.

**Solución:**
```sql
-- Verificar que el ID existe
SELECT * FROM tipo_vehiculo WHERE id = 99;
SELECT * FROM marca_vehiculo WHERE id = 99;
SELECT * FROM modelo_vehiculo WHERE id = 99;
```

### Dropdowns no se llenan en el frontend

**Verificar endpoints públicos:**
```bash
# Local
curl http://localhost:3000/api/vehiculos/tipos
curl http://localhost:3000/api/vehiculos/marcas
curl http://localhost:3000/api/vehiculos/marcas/1/modelos

# Producción (Render + Supabase)
curl https://tu-app.onrender.com/api/vehiculos/tipos
```

**Verificar que las rutas públicas están ANTES del middleware de autenticación** en `vehiculos.routes.js`:
```javascript
// CORRECTO: Rutas públicas PRIMERO
router.get('/tipos', async (req, res) => { ... });
router.get('/marcas', async (req, res) => { ... });

// LUEGO: Middleware de autenticación
router.use(requireAuth);

// DESPUÉS: Rutas protegidas
router.get('/', requirePermission('vehiculos.leer'), ...);
```

### Valores no se guardan

**Verificar que el backend acepta los nuevos campos:**
```javascript
const {
    tipo_vehiculo_id,  // ✅ Nuevo campo
    marca_id,          // ✅ Nuevo campo
    modelo_id,         // ✅ Nuevo campo
    tipo,              // ⚠️ Campo legacy (compatibilidad)
    marca,             // ⚠️ Campo legacy (compatibilidad)
    modelo             // ⚠️ Campo legacy (compatibilidad)
} = req.body;
```

---

## 📝 Notas Técnicas

1. **Endpoints públicos**: Los endpoints de mantenedores NO requieren autenticación para usarse en formularios de registro sin login

2. **Nombres normalizados**: Los nombres en `seed_modelo_vehiculo.sql` respetan mayúsculas/minúsculas oficiales (ej: "X-Trail", "CX-5")

3. **Años de producción**: Los campos `anio_inicio` y `anio_fin` son informativos, NO obligatorios. `anio_fin = NULL` indica que aún se produce

4. **Filtrado en cascada**: El filtrado por `tipo_id` en marcas/modelos es opcional pero mejora UX al reducir opciones irrelevantes

5. **Foreign Keys RESTRICT**: Las relaciones usan `ON DELETE RESTRICT` para prevenir eliminación accidental de datos referenciados

---

## ✅ Checklist de Implementación

- [x] Migración 017 creada con 3 tablas nuevas + ALTER TABLE vehiculos
- [x] Seeds creados con 12 tipos, 45 marcas, 180+ modelos
- [x] Endpoints API públicos implementados (5 rutas)
- [x] Frontend actualizado con dropdowns en cascada
- [x] Backend POST actualizado para soportar nuevos campos
- [x] Backend PUT actualizado para soportar nuevos campos
- [x] Compatibilidad retroactiva verificada (dual storage)
- [x] Documentación completa creada

---

## 🎯 Próximos Pasos (Opcional)

1. **Agregar imágenes/logos** de marcas en `marca_vehiculo.logo_url`
2. **Interfaz de administración** para mantenedores (CRUD de tipos/marcas/modelos)
3. **Importación masiva** desde CSV para expandir modelos
4. **Sincronización** con API externa de catálogo vehicular
5. **Reportes** de vehículos agrupados por marca/tipo
6. **Validación cruzada** de año del vehículo vs. producción del modelo

---

**Autor:** GitHub Copilot  
**Fecha:** Mayo 2026  
**Versión:** 1.0.0  
**Licencia:** MIT
