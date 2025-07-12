# 🗄️ Scripts de Base de Datos

Esta carpeta contiene todos los scripts SQL necesarios para la gestión de la base de datos PostgreSQL.

## 📋 Scripts Disponibles

### Scripts Principales
- `database-postgresql.sql` - Script inicial de creación de base de datos
- `database-postgresql-fixed.sql` - Versión corregida del script principal
- `database-production.sql` - Script optimizado para producción
- `security-logs-table.sql` - Tabla para logs de seguridad

### Scripts de Migración
- `migration-fix-schema.sql` - Corrección de esquema de base de datos
- `update-passwords.sql` - Actualización masiva de contraseñas

### Scripts de Mantenimiento
- `fix-duplicates.sql` - Corrección de registros duplicados
- `checkin-plaza-extend.sql` - Extensión de funcionalidad de plazas

## 🚀 Cómo Ejecutar

1. **Instalación inicial**: Ejecutar `database-postgresql.sql`
2. **Correcciones**: Aplicar `database-postgresql-fixed.sql` si es necesario
3. **Producción**: Usar `database-production.sql` para entornos de producción
4. **Mantenimiento**: Ejecutar scripts de mantenimiento según sea necesario

## ⚠️ Precauciones

- Siempre hacer backup antes de ejecutar scripts
- Probar en ambiente de desarrollo primero
- Verificar la estructura de datos antes de migrar
