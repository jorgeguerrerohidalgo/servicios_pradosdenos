# 🔧 Herramientas de Diagnóstico y Verificación

## 📋 Acceso desde el Portal Principal

Desde el **home del sitio** (`/public/index.html`), en la parte inferior de la página encontrarás dos enlaces importantes:

### 🛠️ Diagnóstico
- **Ubicación**: Footer del portal principal
- **Enlace**: `../testing/debug/diagnostico.html`
- **Propósito**: Ejecutar pruebas completas del sistema
- **Funcionalidades**:
  - ✅ Test de conectividad del servidor
  - ✅ Verificación de base de datos
  - ✅ Test de autenticación
  - ✅ Verificación de guardias y plazas
  - ✅ Ejecutar migraciones de esquema

### 🔍 Verificación
- **Ubicación**: Footer del portal principal
- **Enlace**: `../testing/debug/verificacion-sistema.html`
- **Propósito**: Verificación rápida del estado del sistema
- **Funcionalidades**:
  - ✅ Salud del servidor
  - ✅ Conexión a base de datos
  - ✅ APIs públicas funcionando
  - ✅ Páginas principales accesibles
  - ✅ Zona horaria correcta

## 🌐 Navegación desde las Herramientas

### Desde Diagnóstico
Al estar en `/testing/debug/diagnostico.html`, tienes acceso a:
- **🔐 Panel de Administración** → `../../public/admin-login.html`
- **👮‍♂️ Login de Guardias** → `../../public/guardia-login.html`
- **🔍 Consulta Pública** → `../../public/consulta-rondas.html`
- **🔧 Migración de Esquema** → `../html/migrate-schema.html`

### Desde Verificación
El sistema de verificación es autónomo y se enfoca en pruebas de API.

## ⚠️ Notas Importantes

### Ubicación de Archivos
Los archivos de diagnóstico se movieron a la carpeta `/testing/debug/` como parte de la reorganización del proyecto:

```
testing/
├── debug/
│   ├── diagnostico.html          # ← Herramienta principal de diagnóstico
│   ├── verificacion-sistema.html # ← Verificación del sistema
│   ├── diagnostic-checkin.html   # ← Diagnóstico específico de check-in
│   └── debug-*.html              # ← Otras herramientas de debug
├── html/
│   └── migrate-schema.html       # ← Herramienta de migración
└── old-versions/
    └── ...                       # ← Versiones anteriores
```

### Acceso en Producción
- ⚠️ Estas herramientas están diseñadas para **desarrollo y testing**
- ⚠️ NO deben estar disponibles en el entorno de **producción**
- ⚠️ La carpeta `/testing/` debe estar excluida en despliegues

### Funcionalidad
- ✅ Los enlaces están **actualizados** para la nueva estructura
- ✅ Las rutas relativas funcionan **correctamente**
- ✅ La navegación entre herramientas es **fluida**

## 🚀 Cómo Usar

1. **Ir al portal principal**: `http://localhost:3000`
2. **Hacer scroll hasta abajo** al footer
3. **Hacer clic en "Diagnóstico"** o **"Verificación"**
4. **Ejecutar las pruebas** según sea necesario
5. **Navegar** usando los enlaces internos de las herramientas

---

**✅ Los enlaces han sido actualizados y funcionan correctamente con la nueva estructura del proyecto.**
