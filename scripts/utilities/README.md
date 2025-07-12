# 🛠️ Utilidades y Scripts de Desarrollo

Esta carpeta contiene scripts de utilidad para el desarrollo y mantenimiento del proyecto.

## 📋 Scripts Disponibles

### Verificación de Datos
- `check-data.js` - Verificación de integridad de datos
- `check-tokens.js` - Validación de tokens de autenticación

### Generación de Datos
- `generate-hash.js` - Generación de hashes para contraseñas

### Corrección de Problemas
- `fix-duplicates-direct.js` - Corrección directa de duplicados
- `fix-duplicates-script.js` - Script avanzado de corrección
- `fix-duplicates.bat` - Script batch para Windows

### Utilidades de Desarrollo
- `simple-server.js` - Servidor simple para pruebas
- `start-debug-server.bat` - Inicio rápido del servidor en modo debug

## 🚀 Cómo Usar

### Scripts de Node.js
```bash
node scripts/utilities/check-data.js
node scripts/utilities/generate-hash.js
```

### Scripts Batch (Windows)
```cmd
scripts\utilities\fix-duplicates.bat
scripts\utilities\start-debug-server.bat
```

## ⚠️ Notas Importantes

- Los scripts de corrección pueden modificar datos
- Siempre hacer backup antes de ejecutar scripts de corrección
- Verificar configuración de base de datos antes de ejecutar
