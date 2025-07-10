# Credenciales de Desarrollo

## Administradores del Sistema

### Jorge Guerrero Hidalgo (Administrador Principal)
- **Email**: jorgeguerrerohidalgo@gmail.com
- **Contraseña**: madneo710
- **RUN**: 15.468.127-2
- **Plaza**: Plaza La Coruña (ID: 1)

### Supervisor de Seguridad
- **Email**: supervisor@pradosdenos.com
- **Contraseña**: TBD (hash temporal)
- **RUN**: 11.111.222-3
- **Plaza**: Plaza Valencia (ID: 2)

## Guardias de Seguridad

### Carlos Mendoza Torres
- **Email**: carlos.mendoza@pradosdenos.com
- **Contraseña**: password (hash: $2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi)
- **RUT**: 18.543.210-9
- **Teléfono**: +56912345678

### María Elena Soto
- **Email**: maria.soto@pradosdenos.com
- **Contraseña**: TBD
- **RUT**: 16.789.432-1
- **Teléfono**: +56987654321

### Juan Carlos Ramirez
- **Email**: juan.ramirez@pradosdenos.com
- **Contraseña**: TBD
- **RUT**: 19.234.567-8
- **Teléfono**: +56976543210

### Patricia Morales Vega
- **Email**: patricia.morales@pradosdenos.com
- **Contraseña**: TBD
- **RUT**: 17.654.321-0
- **Teléfono**: +56965432109

## URLs del Sistema

### Producción
- **Portal Principal**: https://servicios-prados-de-nos.onrender.com
- **Login Administrativo**: https://servicios-prados-de-nos.onrender.com/admin-login.html
- **Check-in Guardias**: https://servicios-prados-de-nos.onrender.com/checkin.html
- **Consulta Pública**: https://servicios-prados-de-nos.onrender.com/consulta.html

### APIs
- **Consulta Rondas**: GET /api/public/rondas/{plaza_id}
- **Login Admin**: POST /api/admin/login
- **Login Guardias**: POST /api/auth/login
- **Check-in**: POST /api/checkin

## Notas de Seguridad

⚠️ **IMPORTANTE**: Estas credenciales son solo para desarrollo. En producción:
1. Cambiar todas las contraseñas
2. Usar variables de entorno para credentials
3. Implementar 2FA para administradores
4. Rotar contraseñas periódicamente

## Base de Datos

- **Zona Horaria**: America/Santiago
- **19 Plazas** configuradas con tokens QR únicos
- **Check-ins de ejemplo** de los últimos 3 días
