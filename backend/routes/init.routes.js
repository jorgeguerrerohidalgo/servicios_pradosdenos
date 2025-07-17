const express = require('express');
const router = express.Router();
const db = require('../utils/db');

// Ruta para inicializar las tablas de eventos y documentos
router.post('/init-eventos-documentos', async (req, res) => {
    try {
        console.log('🔄 Iniciando creación de tablas de eventos y documentos...');
        
        // Script SQL para crear las tablas
        const createTablesSQL = `
            -- Crear extensión para UUID si no existe
            CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
            
            -- Crear tabla tipo_evento si no existe
            CREATE TABLE IF NOT EXISTS tipo_evento (
                id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                nombre VARCHAR(100) NOT NULL UNIQUE,
                descripcion TEXT,
                icono VARCHAR(50) DEFAULT 'calendar',
                color VARCHAR(7) DEFAULT '#007bff',
                activo BOOLEAN DEFAULT true,
                orden INTEGER DEFAULT 0,
                created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
                updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
            );

            -- Crear tabla eventos_vecinales si no existe
            CREATE TABLE IF NOT EXISTS eventos_vecinales (
                id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                titulo VARCHAR(200) NOT NULL,
                descripcion TEXT,
                ubicacion VARCHAR(200),
                fecha_inicio TIMESTAMP WITH TIME ZONE NOT NULL,
                fecha_fin TIMESTAMP WITH TIME ZONE NOT NULL,
                tipo_evento_id UUID NOT NULL REFERENCES tipo_evento(id),
                link_google_cal TEXT,
                link_reunion TEXT,
                visible BOOLEAN DEFAULT true,
                destacado BOOLEAN DEFAULT false,
                max_participantes INTEGER CHECK (max_participantes > 0 OR max_participantes IS NULL),
                requiere_inscripcion BOOLEAN DEFAULT false,
                creado_por INTEGER NOT NULL,
                modificado_por INTEGER,
                created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
                updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
            );

            -- Crear tabla tipo_documento si no existe
            CREATE TABLE IF NOT EXISTS tipo_documento (
                id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                nombre VARCHAR(100) NOT NULL UNIQUE,
                descripcion TEXT,
                icono VARCHAR(50) DEFAULT 'file',
                color VARCHAR(7) DEFAULT '#28a745',
                activo BOOLEAN DEFAULT true,
                orden INTEGER DEFAULT 0,
                created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
                updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
            );

            -- Crear tabla documentos_comunitarios si no existe
            CREATE TABLE IF NOT EXISTS documentos_comunitarios (
                id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                nombre VARCHAR(200) NOT NULL,
                descripcion TEXT,
                tipo_documento_id UUID NOT NULL REFERENCES tipo_documento(id),
                link_drive TEXT NOT NULL,
                nombre_archivo VARCHAR(200),
                tamaño_archivo BIGINT CHECK (tamaño_archivo > 0 OR tamaño_archivo IS NULL),
                fecha_publicacion TIMESTAMP WITH TIME ZONE NOT NULL,
                fecha_vencimiento TIMESTAMP WITH TIME ZONE,
                visible BOOLEAN DEFAULT true,
                destacado BOOLEAN DEFAULT false,
                requiere_autenticacion BOOLEAN DEFAULT false,
                subido_por INTEGER NOT NULL,
                modificado_por INTEGER,
                created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
                updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
            );

            -- Crear índices para mejorar rendimiento
            CREATE INDEX IF NOT EXISTS idx_eventos_fecha_inicio ON eventos_vecinales(fecha_inicio);
            CREATE INDEX IF NOT EXISTS idx_eventos_visible ON eventos_vecinales(visible);
            CREATE INDEX IF NOT EXISTS idx_documentos_fecha_publicacion ON documentos_comunitarios(fecha_publicacion);
            CREATE INDEX IF NOT EXISTS idx_documentos_visible ON documentos_comunitarios(visible);
        `;

        // Ejecutar el script de creación de tablas
        await db.query(createTablesSQL);
        
        // Insertar tipos de evento por defecto
        const insertTiposEventoSQL = `
            INSERT INTO tipo_evento (nombre, descripcion, color, icono) VALUES
            ('Reunión de Directorio', 'Reuniones oficiales del directorio', '#007bff', 'users'),
            ('Asamblea General', 'Asambleas generales de propietarios', '#28a745', 'bullhorn'),
            ('Actividad Social', 'Eventos sociales y recreativos', '#ffc107', 'glass-cheers'),
            ('Mantenimiento', 'Trabajos de mantenimiento programados', '#dc3545', 'tools'),
            ('Emergencia', 'Situaciones de emergencia', '#6c757d', 'exclamation-triangle'),
            ('Capacitación', 'Charlas y capacitaciones', '#6f42c1', 'chalkboard-teacher')
            ON CONFLICT (nombre) DO NOTHING;
        `;

        await db.query(insertTiposEventoSQL);
        
        // Insertar tipos de documento por defecto
        const insertTiposDocumentoSQL = `
            INSERT INTO tipo_documento (nombre, descripcion, color, icono) VALUES
            ('Acta de Reunión', 'Actas oficiales de reuniones', '#007bff', 'file-alt'),
            ('Reglamento', 'Reglamentos y normativas', '#28a745', 'book'),
            ('Comunicado', 'Comunicados oficiales', '#ffc107', 'bullhorn'),
            ('Informe Financiero', 'Estados financieros y reportes', '#17a2b8', 'chart-line'),
            ('Documento Legal', 'Documentos legales y contratos', '#6f42c1', 'balance-scale'),
            ('Manual', 'Manuales y guías', '#fd7e14', 'book')
            ON CONFLICT (nombre) DO NOTHING;
        `;
        
        await db.query(insertTiposDocumentoSQL);
        
        console.log('✅ Tablas de eventos y documentos creadas exitosamente');
        
        res.json({
            success: true,
            message: 'Tablas de eventos y documentos inicializadas correctamente',
            tables_created: [
                'tipo_evento',
                'eventos_vecinales', 
                'tipo_documento',
                'documentos_comunitarios'
            ]
        });
    } catch (error) {
        console.error('❌ Error creando tablas:', error);
        res.status(500).json({
            success: false,
            error: 'Error al crear las tablas',
            details: error.message
        });
    }
});

module.exports = router;
