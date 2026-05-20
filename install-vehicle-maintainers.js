/**
 * Script de Instalación - Mantenedores de Vehículos (Supabase)
 * ==============================================================
 * Este script ejecuta la migración 017 y carga los seeds
 * usando la conexión PostgreSQL de Supabase configurada en .env
 * 
 * Uso: node install-vehicle-maintainers.js
 */

require('dotenv').config({ path: './backend/.env' });
const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

// Configurar pool de conexión usando DATABASE_URL o variables individuales
const poolConfig = process.env.DATABASE_URL 
    ? { connectionString: process.env.DATABASE_URL }
    : {
        host: process.env.DB_HOST,
        port: process.env.DB_PORT || 5432,
        database: process.env.DB_NAME,
        user: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        ssl: process.env.DB_SSL === 'true' ? {
            rejectUnauthorized: process.env.DB_SSL_REJECT_UNAUTHORIZED !== 'false'
        } : false
    };

const pool = new Pool(poolConfig);

// Colores para consola
const colors = {
    reset: '\x1b[0m',
    green: '\x1b[32m',
    red: '\x1b[31m',
    yellow: '\x1b[33m',
    cyan: '\x1b[36m',
    bold: '\x1b[1m'
};

const log = {
    info: (msg) => console.log(`${colors.cyan}ℹ${colors.reset} ${msg}`),
    success: (msg) => console.log(`${colors.green}✓${colors.reset} ${msg}`),
    error: (msg) => console.log(`${colors.red}✗${colors.reset} ${msg}`),
    warn: (msg) => console.log(`${colors.yellow}⚠${colors.reset} ${msg}`),
    title: (msg) => console.log(`\n${colors.bold}${colors.cyan}${msg}${colors.reset}\n`)
};

/**
 * Ejecutar un archivo SQL
 */
async function executeSQLFile(filePath, description) {
    try {
        const sql = fs.readFileSync(filePath, 'utf8');
        await pool.query(sql);
        log.success(description);
        return true;
    } catch (error) {
        log.error(`${description} - ${error.message}`);
        return false;
    }
}

/**
 * Verificar conexión a Supabase
 */
async function verifyConnection() {
    try {
        const result = await pool.query('SELECT version()');
        log.success('Conexión a Supabase establecida');
        log.info(`PostgreSQL: ${result.rows[0].version.split(',')[0]}`);
        return true;
    } catch (error) {
        log.error('No se pudo conectar a Supabase');
        log.error(error.message);
        console.log('\nVerifica que:');
        console.log('1. El archivo backend/.env existe y tiene DATABASE_URL correcto');
        console.log('2. Las credenciales de Supabase son válidas');
        console.log('3. Tu IP está permitida en Supabase (desactiva RLS temporalmente si es necesario)');
        return false;
    }
}

/**
 * Verificar si las tablas ya existen
 */
async function checkExistingTables() {
    try {
        const result = await pool.query(`
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public' 
            AND table_name IN ('tipo_vehiculo', 'marca_vehiculo', 'modelo_vehiculo')
            ORDER BY table_name
        `);
        
        if (result.rows.length > 0) {
            log.warn(`Ya existen ${result.rows.length} tabla(s): ${result.rows.map(r => r.table_name).join(', ')}`);
            return true;
        }
        return false;
    } catch (error) {
        log.error(`Error al verificar tablas: ${error.message}`);
        return false;
    }
}

/**
 * Verificar datos cargados
 */
async function verifyData() {
    try {
        const result = await pool.query(`
            SELECT 
                (SELECT COUNT(*) FROM tipo_vehiculo WHERE activo = TRUE) AS tipos,
                (SELECT COUNT(*) FROM marca_vehiculo WHERE activo = TRUE) AS marcas,
                (SELECT COUNT(*) FROM modelo_vehiculo WHERE activo = TRUE) AS modelos
        `);
        
        const { tipos, marcas, modelos } = result.rows[0];
        
        console.log('\n' + '='.repeat(50));
        console.log('📊 RESUMEN DE DATOS CARGADOS');
        console.log('='.repeat(50));
        console.log(`Tipos de vehículos:  ${colors.green}${tipos}${colors.reset} registros`);
        console.log(`Marcas vehiculares:  ${colors.green}${marcas}${colors.reset} registros`);
        console.log(`Modelos por marca:   ${colors.green}${modelos}${colors.reset} registros`);
        console.log('='.repeat(50) + '\n');
        
        return tipos > 0 && marcas > 0 && modelos > 0;
    } catch (error) {
        log.error(`Error al verificar datos: ${error.message}`);
        return false;
    }
}

/**
 * Proceso principal de instalación
 */
async function main() {
    console.log('');
    log.title('========================================');
    log.title(' INSTALACIÓN MANTENEDORES DE VEHÍCULOS');
    log.title('========================================');
    
    try {
        // Paso 1: Verificar conexión
        log.info('[1/5] Verificando conexión a Supabase...');
        const connected = await verifyConnection();
        if (!connected) {
            process.exit(1);
        }
        console.log('');
        
        // Paso 2: Verificar si ya existe
        log.info('[2/5] Verificando estado de la base de datos...');
        const exists = await checkExistingTables();
        if (exists) {
            console.log('');
            log.warn('Las tablas ya existen. ¿Deseas continuar de todas formas?');
            log.warn('Esto ejecutará ON CONFLICT DO NOTHING para evitar duplicados.');
            console.log('');
        }
        
        // Paso 3: Aplicar migración
        log.info('[3/5] Aplicando migración 017 (tablas de mantenedores)...');
        const migrationPath = path.join(__dirname, 'scripts', 'database', '017_create_vehicle_maintainers.sql');
        
        if (!fs.existsSync(migrationPath)) {
            log.error(`No se encontró el archivo: ${migrationPath}`);
            process.exit(1);
        }
        
        const migrationOk = await executeSQLFile(
            migrationPath,
            'Tablas creadas: tipo_vehiculo, marca_vehiculo, modelo_vehiculo'
        );
        
        if (!migrationOk) {
            log.error('Fallo al aplicar migración. Abortando...');
            process.exit(1);
        }
        console.log('');
        
        // Paso 4: Cargar seeds
        log.info('[4/5] Cargando datos iniciales (seeds)...');
        
        const seeds = [
            { 
                file: path.join(__dirname, 'database', 'seeds', 'seed_tipo_vehiculo.sql'),
                desc: '  → Tipos de vehículos (12 registros)'
            },
            { 
                file: path.join(__dirname, 'database', 'seeds', 'seed_marca_vehiculo.sql'),
                desc: '  → Marcas vehiculares (45 registros)'
            },
            { 
                file: path.join(__dirname, 'database', 'seeds', 'seed_modelo_vehiculo.sql'),
                desc: '  → Modelos por marca (180+ registros)'
            }
        ];
        
        for (const seed of seeds) {
            if (!fs.existsSync(seed.file)) {
                log.error(`No se encontró el archivo: ${seed.file}`);
                process.exit(1);
            }
            
            const seedOk = await executeSQLFile(seed.file, seed.desc);
            if (!seedOk) {
                log.error('Fallo al cargar seed. Abortando...');
                process.exit(1);
            }
        }
        console.log('');
        
        // Paso 5: Verificar instalación
        log.info('[5/5] Verificando instalación...');
        const verified = await verifyData();
        
        if (verified) {
            console.log('');
            log.title('========================================');
            log.title(' ✅ INSTALACIÓN COMPLETADA EXITOSAMENTE');
            log.title('========================================');
            console.log('');
            log.success('La funcionalidad de mantenedores está lista para usar');
            log.info('Los dropdowns en cascada funcionarán automáticamente en el formulario');
            log.info('');
            log.warn('IMPORTANTE: Reinicia el servidor Node.js para aplicar cambios en rutas');
            console.log('');
            log.info('Documentación: database/seeds/README_MANTENEDORES_VEHICULOS.md');
            console.log('');
        } else {
            log.warn('Instalación completada pero con advertencias. Verifica los datos manualmente.');
        }
        
    } catch (error) {
        console.error('');
        log.error('Error fatal durante la instalación:');
        console.error(error);
        process.exit(1);
    } finally {
        await pool.end();
    }
}

// Ejecutar instalación
main().catch(error => {
    console.error('Error no capturado:', error);
    process.exit(1);
});
