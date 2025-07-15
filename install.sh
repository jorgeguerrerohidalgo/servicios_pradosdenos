#!/bin/bash

# Script de instalación y configuración para Los Prados de Nos
# Sistema de Check-in con Supabase

echo "🏗️  Configurando sistema Los Prados de Nos..."
echo "==========================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar mensajes
print_step() {
    echo -e "${BLUE}[PASO $1]${NC} $2"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar que estamos en el directorio correcto
if [ ! -f "backend/server.js" ]; then
    print_error "Error: No se encontró backend/server.js"
    print_error "Ejecuta este script desde el directorio raíz del proyecto"
    exit 1
fi

print_step "1" "Verificando dependencias..."

# Verificar Node.js
if ! command -v node &> /dev/null; then
    print_error "Node.js no está instalado. Instala Node.js y vuelve a intentar."
    exit 1
fi

# Verificar npm
if ! command -v npm &> /dev/null; then
    print_error "npm no está instalado. Instala npm y vuelve a intentar."
    exit 1
fi

print_success "Node.js y npm están instalados"

print_step "2" "Instalando dependencias del backend..."

cd backend
npm install

if [ $? -ne 0 ]; then
    print_error "Error instalando dependencias del backend"
    exit 1
fi

print_success "Dependencias del backend instaladas"

cd ..

print_step "3" "Configurando variables de entorno..."

# Crear archivo .env si no existe
if [ ! -f "backend/.env" ]; then
    cat > backend/.env << 'EOF'
# Variables de entorno para Los Prados de Nos
NODE_ENV=development
PORT=3000

# Base de datos Supabase
DATABASE_URL=postgresql://postgres:[TU_PASSWORD]@db.[TU_PROJECT_ID].supabase.co:5432/postgres

# Configuración de sesiones
SESSION_SECRET=tu_secreto_super_seguro_aqui_cambiar_en_produccion

# Configuración de seguridad
ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000

# Configuración de archivos
UPLOAD_DIR=uploads
MAX_FILE_SIZE=10485760

# Configuración de email (opcional)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=tu_email@gmail.com
EMAIL_PASS=tu_password_de_app

# Configuración de logs
LOG_LEVEL=info
LOG_FILE=logs/app.log
EOF

    print_warning "Archivo .env creado. DEBES configurar las variables de Supabase:"
    print_warning "  - DATABASE_URL: URL de conexión a tu base de datos Supabase"
    print_warning "  - SESSION_SECRET: Cambia por un secreto seguro"
    print_warning ""
    print_warning "Edita el archivo backend/.env antes de continuar."
else
    print_success "Archivo .env ya existe"
fi

print_step "4" "Creando directorios necesarios..."

# Crear directorios si no existen
mkdir -p backend/logs
mkdir -p backend/uploads
mkdir -p backend/uploads/documentos
mkdir -p backend/uploads/eventos

print_success "Directorios creados"

print_step "5" "Configurando scripts de utilidad..."

# Crear script para ejecutar migraciones
cat > backend/run-migrations.js << 'EOF'
const fs = require('fs');
const path = require('path');
const { Client } = require('pg');

async function runMigrations() {
    console.log('🔄 Ejecutando migraciones...');
    
    const client = new Client({
        connectionString: process.env.DATABASE_URL,
        ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
    });
    
    try {
        await client.connect();
        console.log('✅ Conectado a la base de datos');
        
        // Leer script de configuración completa
        const sqlScript = fs.readFileSync(path.join(__dirname, '..', 'supabase_complete_setup.sql'), 'utf8');
        
        // Ejecutar script
        await client.query(sqlScript);
        console.log('✅ Migraciones ejecutadas correctamente');
        
        // Verificar tablas
        const result = await client.query(`
            SELECT table_name
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name IN ('plazas', 'plaza_tokens', 'guardias', 'admin_users', 'checkins', 'security_logs', 'eventos', 'documentos')
            ORDER BY table_name
        `);
        
        console.log('\n📋 Tablas verificadas:');
        result.rows.forEach(row => {
            console.log(`  ✅ ${row.table_name}`);
        });
        
    } catch (error) {
        console.error('❌ Error ejecutando migraciones:', error.message);
        process.exit(1);
    } finally {
        await client.end();
    }
}

runMigrations();
EOF

print_success "Scripts de utilidad creados"

print_step "6" "Configurando credenciales de prueba..."

cat > backend/setup-test-users.js << 'EOF'
const bcrypt = require('bcrypt');
const { Client } = require('pg');

async function setupTestUsers() {
    console.log('👥 Configurando usuarios de prueba...');
    
    const client = new Client({
        connectionString: process.env.DATABASE_URL,
        ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
    });
    
    try {
        await client.connect();
        
        // Hash de contraseñas
        const adminPassword = await bcrypt.hash('admin123', 12);
        const guardiaPassword = await bcrypt.hash('guardia123', 12);
        
        // Insertar admin
        await client.query(`
            INSERT INTO admin_users (nombre, apellido_paterno, apellido_materno, run, email, fecha_nacimiento, direccion, plaza_id, password_hash)
            VALUES ('Admin', 'Sistema', 'Principal', '11.111.111-1', 'admin@pradosdenos.cl', '1990-01-01', 'Centro de Control', 1, $1)
            ON CONFLICT (email) DO UPDATE SET password_hash = $1
        `, [adminPassword]);
        
        // Insertar guardia
        await client.query(`
            INSERT INTO guardias (nombre, rut, email, password, telefono)
            VALUES ('Guardia', '22.222.222-2', 'guardia@pradosdenos.cl', $1, '+56912345678')
            ON CONFLICT (email) DO UPDATE SET password = $1
        `, [guardiaPassword]);
        
        console.log('✅ Usuarios de prueba configurados:');
        console.log('  👤 Admin: admin@pradosdenos.cl / admin123');
        console.log('  🛡️  Guardia: guardia@pradosdenos.cl / guardia123');
        
    } catch (error) {
        console.error('❌ Error configurando usuarios:', error.message);
        process.exit(1);
    } finally {
        await client.end();
    }
}

setupTestUsers();
EOF

print_success "Script de usuarios de prueba creado"

print_step "7" "Creando comandos de gestión..."

# Crear package.json scripts si no existen
if [ -f "backend/package.json" ]; then
    # Backup del package.json original
    cp backend/package.json backend/package.json.backup
    
    # Agregar scripts útiles
    node -e "
        const fs = require('fs');
        const pkg = JSON.parse(fs.readFileSync('backend/package.json', 'utf8'));
        
        pkg.scripts = pkg.scripts || {};
        pkg.scripts.start = 'node server.js';
        pkg.scripts.dev = 'nodemon server.js';
        pkg.scripts.migrate = 'node run-migrations.js';
        pkg.scripts['setup-users'] = 'node setup-test-users.js';
        pkg.scripts.test = 'node test-connection.js';
        
        fs.writeFileSync('backend/package.json', JSON.stringify(pkg, null, 2));
        console.log('✅ Scripts agregados al package.json');
    "
fi

print_step "8" "Generando documentación..."

cat > README_INSTALACION.md << 'EOF'
# 🏗️ Instalación - Los Prados de Nos

## Requisitos Previos

- Node.js 16+ instalado
- Cuenta en Supabase
- Proyecto de Supabase creado

## Pasos de Instalación

### 1. Configurar Supabase

1. Ve a https://supabase.com
2. Crea un nuevo proyecto
3. Ve a Settings > Database
4. Copia la URL de conexión PostgreSQL

### 2. Configurar Variables de Entorno

Edita el archivo `backend/.env`:

```env
DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT_ID].supabase.co:5432/postgres
SESSION_SECRET=tu_secreto_super_seguro_aqui
```

### 3. Ejecutar Migraciones

```bash
cd backend
npm run migrate
```

### 4. Configurar Usuarios de Prueba

```bash
npm run setup-users
```

### 5. Iniciar el Servidor

```bash
npm start
# o para desarrollo:
npm run dev
```

## Credenciales de Prueba

- **Admin**: admin@pradosdenos.cl / admin123
- **Guardia**: guardia@pradosdenos.cl / guardia123

## URLs del Sistema

- Admin: http://localhost:3000/admin-login.html
- Guardia: http://localhost:3000/guardia-login.html
- Portal: http://localhost:3000/login.html

## Comandos Útiles

```bash
# Ejecutar migraciones
npm run migrate

# Configurar usuarios de prueba
npm run setup-users

# Probar conexión a la base de datos
npm run test

# Iniciar en modo desarrollo
npm run dev
```

## Estructura de la Base de Datos

El sistema incluye las siguientes tablas:

- `plazas` - Plazas del complejo
- `plaza_tokens` - Tokens QR por plaza
- `guardias` - Guardias de seguridad
- `admin_users` - Usuarios administradores
- `checkins` - Registro de rondas
- `security_logs` - Logs de seguridad
- `eventos` - Eventos del complejo
- `documentos` - Documentos del sistema

## Solución de Problemas

### Error de Conexión a Base de Datos

1. Verifica que la URL de Supabase sea correcta
2. Confirma que las credenciales sean válidas
3. Verifica que el proyecto de Supabase esté activo

### Error "security_logs table doesn't exist"

1. Ejecuta las migraciones: `npm run migrate`
2. Verifica que la tabla se haya creado en Supabase

### Error de Autenticación

1. Ejecuta: `npm run setup-users`
2. Verifica que los usuarios estén creados en las tablas correspondientes

## Soporte

Para problemas o consultas, contacta al equipo de desarrollo.
EOF

print_success "Documentación generada"

print_step "9" "Verificación final..."

# Verificar archivos importantes
files_check=(
    "backend/server.js"
    "backend/package.json"
    "backend/.env"
    "backend/run-migrations.js"
    "backend/setup-test-users.js"
    "supabase_complete_setup.sql"
    "README_INSTALACION.md"
)

missing_files=()
for file in "${files_check[@]}"; do
    if [ ! -f "$file" ]; then
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -eq 0 ]; then
    print_success "Todos los archivos necesarios están presentes"
else
    print_warning "Archivos faltantes:"
    for file in "${missing_files[@]}"; do
        echo "  - $file"
    done
fi

echo ""
echo "🎉 Instalación completada!"
echo "==========================================="
echo ""
echo -e "${GREEN}Próximos pasos:${NC}"
echo "1. Configura tu base de datos Supabase en backend/.env"
echo "2. Ejecuta: cd backend && npm run migrate"
echo "3. Ejecuta: npm run setup-users"
echo "4. Ejecuta: npm start"
echo ""
echo -e "${BLUE}URLs del sistema:${NC}"
echo "  - Admin: http://localhost:3000/admin-login.html"
echo "  - Guardia: http://localhost:3000/guardia-login.html"
echo ""
echo -e "${YELLOW}Credenciales de prueba:${NC}"
echo "  - Admin: admin@pradosdenos.cl / admin123"
echo "  - Guardia: guardia@pradosdenos.cl / guardia123"
echo ""
echo "📖 Lee README_INSTALACION.md para más detalles"
