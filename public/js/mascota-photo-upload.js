/**
 * MÓDULO: Upload de Fotos de Mascotas con Supabase Storage
 * Archivo: public/js/mascota-photo-upload.js
 * 
 * Funciones para subir, actualizar y eliminar fotos de mascotas
 * usando Supabase Storage
 */

// Configuración de Supabase (usar las variables del proyecto)
const SUPABASE_URL = 'TU_SUPABASE_URL'; // Ejemplo: https://abcdefgh.supabase.co
const SUPABASE_ANON_KEY = 'TU_SUPABASE_ANON_KEY';
const BUCKET_NAME = 'mascotas-fotos';

// Inicializar cliente de Supabase
const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

/**
 * Sube una foto de mascota a Supabase Storage
 * @param {File} file - Archivo de imagen desde input type="file"
 * @param {number} mascotaId - ID de la mascota
 * @param {number} casaId - ID de la casa
 * @param {number} plazaId - ID de la plaza
 * @returns {Promise<string>} - URL pública de la imagen subida
 */
async function uploadMascotaPhoto(file, mascotaId, casaId, plazaId) {
    try {
        // Validar tipo de archivo
        const allowedTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
        if (!allowedTypes.includes(file.type)) {
            throw new Error('Tipo de archivo no permitido. Use JPG, PNG, WebP o GIF.');
        }

        // Validar tamaño (3 MB máximo)
        const maxSize = 3 * 1024 * 1024; // 3 MB en bytes
        if (file.size > maxSize) {
            throw new Error('La imagen no debe superar 3 MB.');
        }

        // Generar nombre único para el archivo
        const timestamp = Date.now();
        const extension = file.name.split('.').pop();
        const fileName = `${plazaId}/${casaId}/${mascotaId}_${timestamp}.${extension}`;

        console.log('📤 Subiendo foto:', fileName);

        // Subir archivo a Supabase Storage
        const { data, error } = await supabaseClient.storage
            .from(BUCKET_NAME)
            .upload(fileName, file, {
                cacheControl: '3600',
                upsert: false
            });

        if (error) {
            console.error('Error al subir foto:', error);
            throw new Error(`Error al subir: ${error.message}`);
        }

        // Obtener URL pública
        const { data: urlData } = supabaseClient.storage
            .from(BUCKET_NAME)
            .getPublicUrl(fileName);

        const publicURL = urlData.publicUrl;
        console.log('✅ Foto subida:', publicURL);

        return publicURL;

    } catch (error) {
        console.error('Error en uploadMascotaPhoto:', error);
        throw error;
    }
}

/**
 * Elimina una foto de mascota de Supabase Storage
 * @param {string} photoURL - URL completa de la foto a eliminar
 * @returns {Promise<boolean>} - true si se eliminó correctamente
 */
async function deleteMascotaPhoto(photoURL) {
    try {
        if (!photoURL) return false;

        // Extraer el path del archivo desde la URL
        const urlParts = photoURL.split(`/storage/v1/object/public/${BUCKET_NAME}/`);
        if (urlParts.length < 2) {
            console.warn('URL no válida para eliminar');
            return false;
        }

        const filePath = urlParts[1];

        console.log('🗑️ Eliminando foto:', filePath);

        const { error } = await supabaseClient.storage
            .from(BUCKET_NAME)
            .remove([filePath]);

        if (error) {
            console.error('Error al eliminar foto:', error);
            return false;
        }

        console.log('✅ Foto eliminada');
        return true;

    } catch (error) {
        console.error('Error en deleteMascotaPhoto:', error);
        return false;
    }
}

/**
 * Reemplaza una foto existente
 * @param {File} newFile - Nueva imagen
 * @param {string} oldPhotoURL - URL de la foto anterior (para eliminarla)
 * @param {number} mascotaId - ID de la mascota
 * @param {number} casaId - ID de la casa
 * @param {number} plazaId - ID de la plaza
 * @returns {Promise<string>} - URL de la nueva imagen
 */
async function replaceMascotaPhoto(newFile, oldPhotoURL, mascotaId, casaId, plazaId) {
    try {
        // Subir nueva foto
        const newURL = await uploadMascotaPhoto(newFile, mascotaId, casaId, plazaId);

        // Eliminar foto anterior (opcional, no falla si no se puede eliminar)
        if (oldPhotoURL) {
            await deleteMascotaPhoto(oldPhotoURL).catch(err => 
                console.warn('No se pudo eliminar foto anterior:', err)
            );
        }

        return newURL;

    } catch (error) {
        console.error('Error en replaceMascotaPhoto:', error);
        throw error;
    }
}

/**
 * Redimensiona una imagen antes de subirla (opcional, para optimizar)
 * @param {File} file - Archivo original
 * @param {number} maxWidth - Ancho máximo
 * @param {number} maxHeight - Alto máximo
 * @returns {Promise<Blob>} - Imagen redimensionada
 */
async function resizeImage(file, maxWidth = 800, maxHeight = 800) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = (e) => {
            const img = new Image();
            img.onload = () => {
                const canvas = document.createElement('canvas');
                let width = img.width;
                let height = img.height;

                // Calcular nuevas dimensiones manteniendo proporción
                if (width > height) {
                    if (width > maxWidth) {
                        height *= maxWidth / width;
                        width = maxWidth;
                    }
                } else {
                    if (height > maxHeight) {
                        width *= maxHeight / height;
                        height = maxHeight;
                    }
                }

                canvas.width = width;
                canvas.height = height;
                const ctx = canvas.getContext('2d');
                ctx.drawImage(img, 0, 0, width, height);

                canvas.toBlob((blob) => {
                    resolve(blob);
                }, file.type, 0.85); // Calidad 85%
            };
            img.onerror = reject;
            img.src = e.target.result;
        };
        reader.onerror = reject;
        reader.readAsDataURL(file);
    });
}

// Exportar funciones (si usas módulos ES6)
// export { uploadMascotaPhoto, deleteMascotaPhoto, replaceMascotaPhoto, resizeImage };
