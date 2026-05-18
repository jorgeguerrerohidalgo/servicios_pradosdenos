# 📸 Guía Completa: Almacenamiento de Fotos de Mascotas

## 🎯 Opción Recomendada: **Supabase Storage**

### ¿Por qué Supabase Storage?
- ✅ **Gratis**: 1 GB incluido en tu plan actual
- ✅ **Integrado**: Mismo proyecto que tu base de datos
- ✅ **CDN global**: URLs rápidas desde cualquier lugar
- ✅ **Seguro**: Control de acceso con políticas
- ✅ **Fácil**: API simple de usar

---

## 🚀 Configuración en 5 Pasos

### Paso 1: Crear Bucket en Supabase

1. Ir a **Supabase Dashboard** → Tu proyecto
2. Menú izquierdo → **Storage**
3. Clic en **"New Bucket"**
4. Configuración:
   ```
   Name: mascotas-fotos
   Public bucket: ✅ SÍ (para URLs públicas)
   File size limit: 3 MB
   Allowed MIME types: image/jpeg, image/png, image/webp, image/gif
   ```
5. Clic **"Create bucket"**

### Paso 2: Configurar Políticas de Seguridad

1. En **Storage** → Bucket **mascotas-fotos** → **Policies**
2. Copiar y ejecutar el script: `scripts/supabase/setup-storage-mascotas.sql`
3. O configurar manualmente:
   - **SELECT**: Permitir acceso público
   - **INSERT/UPDATE/DELETE**: Solo usuarios autenticados

### Paso 3: Obtener Credenciales

1. Ir a **Settings** → **API**
2. Copiar:
   - **Project URL**: `https://tu-proyecto.supabase.co`
   - **anon/public key**: `eyJhbGc...` (clave larga)
3. Actualizar en `public/js/mascota-photo-upload.js`:
   ```javascript
   const SUPABASE_URL = 'https://tu-proyecto.supabase.co';
   const SUPABASE_ANON_KEY = 'tu_anon_key_aqui';
   ```

### Paso 4: Agregar Script al HTML

En `public/admin-panel.html`, antes de `</body>`:

```html
<!-- Supabase JavaScript Client -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

<!-- Módulo de upload de fotos -->
<script src="js/mascota-photo-upload.js"></script>
```

### Paso 5: Integrar en el Formulario

Reemplazar el campo de foto en el modal de mascotas:

```html
<!-- Campo de foto mejorado -->
<div class="mb-3">
    <label for="mascotaFoto" class="form-label">Foto de la Mascota</label>
    
    <!-- Preview de la foto actual -->
    <div id="mascotaFotoPreview" class="mb-2" style="display: none;">
        <img id="mascotaFotoImg" src="" alt="Foto de mascota" 
             style="max-width: 200px; max-height: 200px; border-radius: 8px;">
        <button type="button" class="btn btn-sm btn-danger" onclick="removeMascotaFoto()">
            <i class="fas fa-trash"></i> Eliminar foto
        </button>
    </div>
    
    <!-- Input para subir nueva foto -->
    <input type="file" class="form-control" id="mascotaFotoFile" 
           accept="image/jpeg,image/png,image/webp,image/gif">
    
    <!-- Input oculto para guardar URL -->
    <input type="hidden" id="mascotaFoto" name="foto_url">
    
    <small class="text-muted">Formatos: JPG, PNG, WebP, GIF. Máximo: 3 MB</small>
</div>
```

Agregar funciones JavaScript:

```javascript
// Función para cargar foto al editar mascota
function showMascotaFotoPreview(photoURL) {
    if (photoURL) {
        document.getElementById('mascotaFotoImg').src = photoURL;
        document.getElementById('mascotaFotoPreview').style.display = 'block';
        document.getElementById('mascotaFoto').value = photoURL;
    } else {
        document.getElementById('mascotaFotoPreview').style.display = 'none';
    }
}

// Función para eliminar foto
function removeMascotaFoto() {
    document.getElementById('mascotaFotoPreview').style.display = 'none';
    document.getElementById('mascotaFoto').value = '';
    document.getElementById('mascotaFotoFile').value = '';
}

// Modificar saveMascota() para subir foto
async function saveMascota() {
    // ... código existente ...
    
    // Subir foto si se seleccionó un archivo
    const fileInput = document.getElementById('mascotaFotoFile');
    if (fileInput.files.length > 0) {
        try {
            const file = fileInput.files[0];
            const plazaId = document.getElementById('mascotaPlaza').value;
            const casaId = document.getElementById('mascotaCasa').value;
            
            // Si es edición, obtener ID de mascota
            const mascotaId = document.getElementById('mascotaId').value || 'temp_' + Date.now();
            
            // Subir foto (con reemplazo si existe una anterior)
            const oldPhotoURL = document.getElementById('mascotaFoto').value;
            const photoURL = await replaceMascotaPhoto(file, oldPhotoURL, mascotaId, casaId, plazaId);
            
            // Guardar URL en el objeto data
            data.foto_url = photoURL;
            
        } catch (error) {
            Swal.fire({
                icon: 'error',
                title: 'Error al subir foto',
                text: error.message
            });
            return; // No guardar si falla la foto
        }
    }
    
    // ... continuar con el guardado normal ...
}
```

---

## 📊 Comparación de Alternativas

| Servicio | Plan Gratuito | Pros | Contras |
|----------|---------------|------|---------|
| **Supabase Storage** ⭐ | 1 GB, 2 GB transferencia/mes | Ya lo tienes, CDN, seguro | Requiere configuración inicial |
| **Cloudinary** | 25 GB/mes, 25 créditos transform | Tier generoso, transformaciones | Requiere cuenta extra |
| **ImgBB** | Ilimitado | Simple, sin registro | Sin delete, URLs largas |
| **Imgur** | Ilimitado | Popular, API simple | ToS restrictivo para apps |

---

## 🔧 Otras Opciones (si prefieres)

### Opción 2: **Cloudinary** (muy generoso)

**Plan Free**: 25 GB/mes, 25 créditos de transformación

```bash
npm install cloudinary
```

```javascript
// Configuración
const cloudinary = require('cloudinary').v2;
cloudinary.config({
  cloud_name: 'tu_cloud_name',
  api_key: 'tu_api_key',
  api_secret: 'tu_api_secret'
});

// Upload
const result = await cloudinary.uploader.upload(file, {
  folder: 'mascotas',
  public_id: `mascota_${mascotaId}`,
  overwrite: true
});
// URL: result.secure_url
```

### Opción 3: **ImgBB** (súper simple, sin backend)

**Plan Free**: Ilimitado (con límites de rate)

```javascript
// Upload directo desde frontend
async function uploadToImgBB(file) {
    const apiKey = 'tu_imgbb_api_key'; // Obtener gratis en imgbb.com/api
    
    const formData = new FormData();
    formData.append('image', file);
    
    const response = await fetch(`https://api.imgbb.com/1/upload?key=${apiKey}`, {
        method: 'POST',
        body: formData
    });
    
    const data = await response.json();
    return data.data.url; // URL pública
}
```

---

## 💡 Recomendación Final

**Usa Supabase Storage** porque:
1. **Ya pagaste por él** (está incluido en tu plan)
2. **Profesional**: CDN, seguridad, escalable
3. **Todo en un lugar**: DB + Storage + Auth
4. **1 GB = ~1,000-2,000 fotos** de mascotas

Si algún día necesitas más:
- **Upgrade Supabase**: $25/mes → 100 GB
- **O migrar a Cloudinary**: Plan gratuito muy amplio

---

## 📝 Checklist de Implementación

- [ ] Crear bucket `mascotas-fotos` en Supabase
- [ ] Ejecutar script de políticas SQL
- [ ] Copiar credenciales (URL + anon key)
- [ ] Actualizar `mascota-photo-upload.js`
- [ ] Agregar script Supabase al HTML
- [ ] Modificar formulario de mascotas
- [ ] Probar subida de foto
- [ ] Probar edición con foto
- [ ] Probar eliminación de foto

**¿Necesitas ayuda con algún paso?** 🚀
