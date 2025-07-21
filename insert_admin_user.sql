-- Insertar usuario de prueba en admin_users
-- EJECUTAR ESTE SCRIPT EN SUPABASE SQL EDITOR

INSERT INTO admin_users 
(nombre, apellido_paterno, apellido_materno, email, password_hash, activo, plaza_id, created_at, updated_at) 
VALUES 
(
    'Jorge',
    'Guerrero', 
    'Hidalgo',
    'jorgeguerrerohidalgo@gmail.com',
    '$2b$12$A77lpJIUOs4Q0uzsndec/ueLMSdsY3MOrj1p4v5p2iimp2rkM2I2.',
    true,
    1,
    NOW(),
    NOW()
)
ON CONFLICT (email) 
DO UPDATE SET 
    password_hash = EXCLUDED.password_hash,
    activo = EXCLUDED.activo,
    updated_at = NOW();

-- Verificar que se insertó correctamente
SELECT id, nombre, apellido_paterno, email, activo, created_at 
FROM admin_users 
WHERE email = 'jorgeguerrerohidalgo@gmail.com';
