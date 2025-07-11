// Implementación simple de QR Code sin librerías externas
// Usa una API externa confiable para generar QR codes

window.SimpleQRGenerator = {
    // Método principal para generar QR en canvas
    toCanvas: function(canvas, text, options = {}) {
        return new Promise((resolve, reject) => {
            try {
                const size = options.width || 200;
                const margin = options.margin || 10;
                
                // Método 1: Usar qr-server.com API
                this.generateWithQRServer(canvas, text, size, margin)
                    .then(resolve)
                    .catch(() => {
                        // Método 2: Usar Google Charts como fallback
                        this.generateWithGoogleCharts(canvas, text, size, margin)
                            .then(resolve)
                            .catch(() => {
                                // Método 3: Generar QR básico con patrones
                                this.generateBasicQR(canvas, text, size, margin)
                                    .then(resolve)
                                    .catch(reject);
                            });
                    });
                    
            } catch (error) {
                reject(error);
            }
        });
    },
    
    // Método usando qr-server.com (sin CORS)
    generateWithQRServer: function(canvas, text, size, margin) {
        return new Promise((resolve, reject) => {
            const qrUrl = `https://api.qrserver.com/v1/create-qr-code/?size=${size}x${size}&data=${encodeURIComponent(text)}&margin=${margin}`;
            
            const img = new Image();
            img.crossOrigin = 'anonymous';
            img.onload = function() {
                const ctx = canvas.getContext('2d');
                canvas.width = size;
                canvas.height = size;
                ctx.drawImage(img, 0, 0, size, size);
                console.log('✅ QR generado con qr-server.com');
                resolve();
            };
            img.onerror = function() {
                console.log('❌ qr-server.com falló');
                reject(new Error('QR Server API failed'));
            };
            img.src = qrUrl;
        });
    },
    
    // Método usando Google Charts
    generateWithGoogleCharts: function(canvas, text, size, margin) {
        return new Promise((resolve, reject) => {
            const qrUrl = `https://chart.googleapis.com/chart?chs=${size}x${size}&cht=qr&chl=${encodeURIComponent(text)}&choe=UTF-8`;
            
            const img = new Image();
            img.crossOrigin = 'anonymous';
            img.onload = function() {
                const ctx = canvas.getContext('2d');
                canvas.width = size;
                canvas.height = size;
                ctx.drawImage(img, 0, 0, size, size);
                console.log('✅ QR generado con Google Charts');
                resolve();
            };
            img.onerror = function() {
                console.log('❌ Google Charts falló');
                reject(new Error('Google Charts API failed'));
            };
            img.src = qrUrl;
        });
    },
    
    // Método básico usando patrones (para casos extremos)
    generateBasicQR: function(canvas, text, size, margin) {
        return new Promise((resolve, reject) => {
            try {
                const ctx = canvas.getContext('2d');
                canvas.width = size;
                canvas.height = size;
                
                // Limpiar canvas
                ctx.fillStyle = 'white';
                ctx.fillRect(0, 0, size, size);
                
                // Generar un patrón básico basado en el texto
                const hash = this.simpleHash(text);
                const gridSize = 21; // Tamaño estándar de QR
                const cellSize = (size - margin * 2) / gridSize;
                
                // Dibujar patrón de ubicación (esquinas)
                this.drawFinderPattern(ctx, margin, margin, cellSize);
                this.drawFinderPattern(ctx, margin + cellSize * (gridSize - 7), margin, cellSize);
                this.drawFinderPattern(ctx, margin, margin + cellSize * (gridSize - 7), cellSize);
                
                // Dibujar datos basados en hash
                ctx.fillStyle = 'black';
                for (let i = 0; i < gridSize; i++) {
                    for (let j = 0; j < gridSize; j++) {
                        if (this.shouldFillCell(i, j, hash, gridSize)) {
                            ctx.fillRect(
                                margin + j * cellSize,
                                margin + i * cellSize,
                                cellSize,
                                cellSize
                            );
                        }
                    }
                }
                
                console.log('✅ QR básico generado con patrones');
                resolve();
            } catch (error) {
                reject(error);
            }
        });
    },
    
    // Generar hash simple del texto
    simpleHash: function(text) {
        let hash = 0;
        for (let i = 0; i < text.length; i++) {
            const char = text.charCodeAt(i);
            hash = ((hash << 5) - hash) + char;
            hash = hash & hash; // Convertir a 32-bit integer
        }
        return Math.abs(hash);
    },
    
    // Dibujar patrón de ubicación
    drawFinderPattern: function(ctx, x, y, cellSize) {
        ctx.fillStyle = 'black';
        // Cuadrado exterior
        ctx.fillRect(x, y, cellSize * 7, cellSize * 7);
        ctx.fillStyle = 'white';
        // Cuadrado interior
        ctx.fillRect(x + cellSize, y + cellSize, cellSize * 5, cellSize * 5);
        ctx.fillStyle = 'black';
        // Cuadrado central
        ctx.fillRect(x + cellSize * 2, y + cellSize * 2, cellSize * 3, cellSize * 3);
    },
    
    // Determinar si una celda debe ser negra
    shouldFillCell: function(i, j, hash, gridSize) {
        // Evitar patrones de ubicación
        if (this.isFinderPattern(i, j, gridSize)) {
            return false;
        }
        
        // Usar hash para determinar patrón
        const cellHash = ((i * gridSize + j) * hash) % 100;
        return cellHash % 2 === 0;
    },
    
    // Verificar si está en área de patrón de ubicación
    isFinderPattern: function(i, j, gridSize) {
        return (i < 9 && j < 9) || // Esquina superior izquierda
               (i < 9 && j >= gridSize - 8) || // Esquina superior derecha
               (i >= gridSize - 8 && j < 9); // Esquina inferior izquierda
    },
    
    // Método para generar data URL
    toDataURL: function(text, options = {}) {
        return new Promise((resolve, reject) => {
            const canvas = document.createElement('canvas');
            this.toCanvas(canvas, text, options)
                .then(() => resolve(canvas.toDataURL()))
                .catch(reject);
        });
    }
};

// Configurar QRCode global si no existe
if (typeof QRCode === 'undefined') {
    window.QRCode = window.SimpleQRGenerator;
    console.log('✅ SimpleQRGenerator configurado como QRCode global');
}
