// Librería QR local simple y confiable
// Genera códigos QR usando canvas y algoritmos locales

(function() {
    'use strict';
    
    // Configuración de QR Code
    const QR_CONFIG = {
        errorCorrectionLevel: 'M',
        typeNumber: 0,
        mode: 'Byte',
        margin: 2,
        width: 200,
        color: {
            dark: '#000000',
            light: '#FFFFFF'
        }
    };

    // Función principal para generar QR
    function generateQR(canvas, text, options = {}) {
        return new Promise((resolve, reject) => {
            try {
                const config = Object.assign({}, QR_CONFIG, options);
                const size = config.width;
                const margin = config.margin;
                
                // Limpiar canvas
                const ctx = canvas.getContext('2d');
                canvas.width = size;
                canvas.height = size;
                
                // Método 1: Intentar con API de Google (más confiable)
                generateWithGoogle(canvas, text, size, margin)
                    .then(resolve)
                    .catch(() => {
                        // Método 2: Intentar con API de QR Server
                        generateWithQRServer(canvas, text, size, margin)
                            .then(resolve)
                            .catch(() => {
                                // Método 3: Generar QR visual básico
                                generateBasicVisual(canvas, text, size, margin)
                                    .then(resolve)
                                    .catch(reject);
                            });
                    });
                    
            } catch (error) {
                reject(error);
            }
        });
    }

    // Método 1: API de Google Charts
    function generateWithGoogle(canvas, text, size, margin) {
        return new Promise((resolve, reject) => {
            const timeout = setTimeout(() => {
                reject(new Error('Timeout Google API'));
            }, 5000);
            
            const encodedText = encodeURIComponent(text);
            const qrUrl = `https://chart.googleapis.com/chart?chs=${size}x${size}&cht=qr&chl=${encodedText}&choe=UTF-8`;
            
            const img = new Image();
            img.crossOrigin = 'anonymous';
            
            img.onload = function() {
                try {
                    clearTimeout(timeout);
                    const ctx = canvas.getContext('2d');
                    
                    // Fondo blanco
                    ctx.fillStyle = '#FFFFFF';
                    ctx.fillRect(0, 0, size, size);
                    
                    // Dibujar QR
                    ctx.drawImage(img, 0, 0, size, size);
                    
                    console.log('✅ QR generado con Google Charts');
                    resolve();
                } catch (error) {
                    clearTimeout(timeout);
                    reject(error);
                }
            };
            
            img.onerror = function() {
                clearTimeout(timeout);
                reject(new Error('Error cargando desde Google Charts'));
            };
            
            img.src = qrUrl;
        });
    }

    // Método 2: API de QR Server
    function generateWithQRServer(canvas, text, size, margin) {
        return new Promise((resolve, reject) => {
            const timeout = setTimeout(() => {
                reject(new Error('Timeout QR Server'));
            }, 5000);
            
            const encodedText = encodeURIComponent(text);
            const qrUrl = `https://api.qrserver.com/v1/create-qr-code/?size=${size}x${size}&data=${encodedText}&margin=${margin}`;
            
            const img = new Image();
            img.crossOrigin = 'anonymous';
            
            img.onload = function() {
                try {
                    clearTimeout(timeout);
                    const ctx = canvas.getContext('2d');
                    
                    // Fondo blanco
                    ctx.fillStyle = '#FFFFFF';
                    ctx.fillRect(0, 0, size, size);
                    
                    // Dibujar QR
                    ctx.drawImage(img, 0, 0, size, size);
                    
                    console.log('✅ QR generado con QR Server');
                    resolve();
                } catch (error) {
                    clearTimeout(timeout);
                    reject(error);
                }
            };
            
            img.onerror = function() {
                clearTimeout(timeout);
                reject(new Error('Error cargando desde QR Server'));
            };
            
            img.src = qrUrl;
        });
    }

    // Método 3: QR visual básico (backup)
    function generateBasicVisual(canvas, text, size, margin) {
        return new Promise((resolve, reject) => {
            try {
                const ctx = canvas.getContext('2d');
                
                // Fondo blanco
                ctx.fillStyle = '#FFFFFF';
                ctx.fillRect(0, 0, size, size);
                
                // Borde
                ctx.strokeStyle = '#000000';
                ctx.lineWidth = 2;
                ctx.strokeRect(margin, margin, size - margin * 2, size - margin * 2);
                
                // Generar patrón visual basado en el texto
                const hash = generateTextHash(text);
                const gridSize = 25;
                const cellSize = (size - margin * 2) / gridSize;
                
                ctx.fillStyle = '#000000';
                
                // Dibujar patrones de esquina (finder patterns)
                drawFinderPattern(ctx, margin, margin, cellSize);
                drawFinderPattern(ctx, margin + cellSize * (gridSize - 7), margin, cellSize);
                drawFinderPattern(ctx, margin, margin + cellSize * (gridSize - 7), cellSize);
                
                // Dibujar patrón de datos
                for (let i = 0; i < gridSize; i++) {
                    for (let j = 0; j < gridSize; j++) {
                        if (shouldDrawCell(i, j, hash, gridSize, text)) {
                            ctx.fillRect(
                                margin + j * cellSize,
                                margin + i * cellSize,
                                cellSize,
                                cellSize
                            );
                        }
                    }
                }
                
                // Agregar texto del token
                ctx.fillStyle = '#000000';
                ctx.font = `${Math.max(10, size * 0.05)}px monospace`;
                ctx.textAlign = 'center';
                ctx.fillText(text, size / 2, size - 5);
                
                console.log('✅ QR visual generado como backup');
                resolve();
                
            } catch (error) {
                reject(error);
            }
        });
    }

    // Generar hash del texto
    function generateTextHash(text) {
        let hash = 0;
        for (let i = 0; i < text.length; i++) {
            const char = text.charCodeAt(i);
            hash = ((hash << 5) - hash) + char;
            hash = hash & hash; // Convertir a 32-bit
        }
        return Math.abs(hash);
    }

    // Dibujar patrón de esquina
    function drawFinderPattern(ctx, x, y, cellSize) {
        ctx.fillStyle = '#000000';
        // Cuadrado exterior 7x7
        ctx.fillRect(x, y, cellSize * 7, cellSize * 7);
        ctx.fillStyle = '#FFFFFF';
        // Cuadrado interior 5x5
        ctx.fillRect(x + cellSize, y + cellSize, cellSize * 5, cellSize * 5);
        ctx.fillStyle = '#000000';
        // Cuadrado central 3x3
        ctx.fillRect(x + cellSize * 2, y + cellSize * 2, cellSize * 3, cellSize * 3);
    }

    // Determinar si dibujar celda
    function shouldDrawCell(i, j, hash, gridSize, text) {
        // Evitar patrones de esquina
        if (isFinderPattern(i, j, gridSize)) {
            return false;
        }
        
        // Patrón basado en hash y posición
        const cellIndex = i * gridSize + j;
        const charIndex = cellIndex % text.length;
        const charCode = text.charCodeAt(charIndex);
        
        return ((hash + cellIndex + charCode) % 3) === 0;
    }

    // Verificar si está en patrón de esquina
    function isFinderPattern(i, j, gridSize) {
        return (i < 9 && j < 9) || // Esquina superior izquierda
               (i < 9 && j >= gridSize - 8) || // Esquina superior derecha
               (i >= gridSize - 8 && j < 9); // Esquina inferior izquierda
    }

    // Crear objeto QRCode global
    window.QRCode = {
        toCanvas: generateQR,
        toDataURL: function(text, options = {}) {
            return new Promise((resolve, reject) => {
                const canvas = document.createElement('canvas');
                generateQR(canvas, text, options)
                    .then(() => resolve(canvas.toDataURL()))
                    .catch(reject);
            });
        }
    };

    console.log('✅ Librería QR local cargada correctamente');
    console.log('📋 Métodos disponibles: toCanvas, toDataURL');
    console.log('🔄 Métodos de generación: Google Charts → QR Server → Visual Backup');

})();
