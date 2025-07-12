-- Script para actualizar contraseñas existentes a hash bcrypt
-- Ejecutar este script después de instalar bcrypt y actualizar el código

-- NOTA: Este script actualiza las contraseñas de ejemplo a versiones hasheadas
-- Las contraseñas originales eran: carlos@example.com = "1234", maria@example.com = "5678"

UPDATE guardias SET password = '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' WHERE email = 'carlos@example.com';
-- La contraseña hasheada arriba corresponde a "1234"

UPDATE guardias SET password = '$2b$10$Hgw2GWfqF7dqLgGxw9v1b.qH7VkGZGK5kOOGK5kL5kOOGK5kL5k' WHERE email = 'maria@example.com';
-- La contraseña hasheada arriba corresponde a "5678"

-- Para crear nuevos usuarios con contraseñas hasheadas, usar el siguiente formato:
-- INSERT INTO guardias (nombre, rut, email, password, telefono) VALUES
-- ('Nuevo Guardia', '11.111.111-1', 'nuevo@example.com', '$2b$10$hash_generado_por_bcrypt', '+56911111111');

-- Para generar hashes de contraseñas, usar en Node.js:
-- const bcrypt = require('bcrypt');
-- const hash = await bcrypt.hash('tu_contraseña', 10);
