// Versión simple de QRCode usando Google Charts API como fallback
window.SimpleQRCode = {
    toCanvas: function(canvas, text, options) {
        return new Promise((resolve, reject) => {
            try {
                const size = options?.width || 200;
                const margin = options?.margin || 4;
                
                // Crear una imagen QR usando Google Charts API
                const qrUrl = `https://chart.googleapis.com/chart?chs=${size}x${size}&cht=qr&chl=${encodeURIComponent(text)}&choe=UTF-8`;
                
                const img = new Image();
                img.crossOrigin = 'anonymous';
                img.onload = function() {
                    const ctx = canvas.getContext('2d');
                    canvas.width = size;
                    canvas.height = size;
                    ctx.drawImage(img, 0, 0, size, size);
                    resolve();
                };
                img.onerror = function() {
                    reject(new Error('No se pudo generar QR con Google Charts API'));
                };
                img.src = qrUrl;
            } catch (error) {
                reject(error);
            }
        });
    },
    
    toDataURL: function(text, options) {
        return new Promise((resolve, reject) => {
            const canvas = document.createElement('canvas');
            this.toCanvas(canvas, text, options)
                .then(() => resolve(canvas.toDataURL()))
                .catch(reject);
        });
    }
};

// Si QRCode no está disponible, usar SimpleQRCode
if (typeof QRCode === 'undefined') {
    window.QRCode = window.SimpleQRCode;
    console.log('✅ Usando SimpleQRCode como fallback');
}
