// Librería QR Simple - Versión Debug
console.log('🔄 Iniciando carga de librería QR debug...');

window.QRCodeSimple = {
    toCanvas: function(canvas, text, options = {}) {
        console.log('🔄 QRCodeSimple.toCanvas llamado con:', text);
        
        return new Promise((resolve, reject) => {
            try {
                const size = options.width || 200;
                const margin = options.margin || 2;
                
                // Usar QR Server API directamente
                const qrUrl = `https://api.qrserver.com/v1/create-qr-code/?size=${size}x${size}&data=${encodeURIComponent(text)}&margin=${margin}&format=png`;
                console.log('🌐 URL QR:', qrUrl);
                
                const img = new Image();
                img.crossOrigin = 'anonymous';
                
                img.onload = function() {
                    console.log('✅ Imagen QR cargada correctamente');
                    try {
                        const ctx = canvas.getContext('2d');
                        canvas.width = size;
                        canvas.height = size;
                        
                        // Limpiar canvas
                        ctx.fillStyle = 'white';
                        ctx.fillRect(0, 0, size, size);
                        
                        // Dibujar QR
                        ctx.drawImage(img, 0, 0, size, size);
                        console.log('✅ QR dibujado en canvas');
                        resolve();
                    } catch (error) {
                        console.error('❌ Error dibujando en canvas:', error);
                        reject(error);
                    }
                };
                
                img.onerror = function() {
                    console.error('❌ Error cargando imagen QR');
                    reject(new Error('Error cargando imagen QR desde API'));
                };
                
                console.log('🔄 Iniciando carga de imagen...');
                img.src = qrUrl;
                
            } catch (error) {
                console.error('❌ Error en toCanvas:', error);
                reject(error);
            }
        });
    }
};

// Configurar como QRCode global
window.QRCode = window.QRCodeSimple;

console.log('✅ QRCodeSimple configurado');
console.log('✅ window.QRCode disponible:', typeof window.QRCode);
console.log('✅ Método toCanvas disponible:', typeof window.QRCode.toCanvas);
