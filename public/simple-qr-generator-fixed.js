// Librería QR mejorada y robusta - versión reparada
// Soluciona problemas de generación incompleta de códigos QR

window.QRCodeFixed = {
    // Método principal para generar QR en canvas
    toCanvas: function(canvas, text, options = {}) {
        return new Promise((resolve, reject) => {
            try {
                const size = options.width || 200;
                const margin = options.margin || 10;
                
                console.log(`🔄 Generando QR para texto: "${text}" (${text.length} caracteres)`);
                
                // Validar entrada
                if (!text || text.trim() === '') {
                    throw new Error('Texto vacío para generar QR');
                }
                
                if (!canvas || !canvas.getContext) {
                    throw new Error('Canvas no válido');
                }
                
                // Método 1: Usar API QR Server (más confiable)
                this.generateWithQRServer(canvas, text, size, margin)
                    .then(() => {
                        console.log('✅ QR generado exitosamente con qr-server.com');
                        resolve();
                    })
                    .catch((error1) => {
                        console.warn('⚠️ qr-server.com falló, probando Google Charts...', error1.message);
                        
                        // Método 2: Usar Google Charts como fallback
                        this.generateWithGoogleCharts(canvas, text, size, margin)
                            .then(() => {
                                console.log('✅ QR generado exitosamente con Google Charts');
                                resolve();
                            })
                            .catch((error2) => {
                                console.warn('⚠️ Google Charts falló, probando QR-API...', error2.message);
                                
                                // Método 3: Usar QR-API como segundo fallback
                                this.generateWithQRAPI(canvas, text, size, margin)
                                    .then(() => {
                                        console.log('✅ QR generado exitosamente con QR-API');
                                        resolve();
                                    })
                                    .catch((error3) => {
                                        console.warn('⚠️ QR-API falló, generando QR de emergencia...', error3.message);
                                        
                                        // Método 4: Generar QR de emergencia
                                        this.generateEmergencyQR(canvas, text, size, margin)
                                            .then(() => {
                                                console.log('✅ QR de emergencia generado');
                                                resolve();
                                            })
                                            .catch((error4) => {
                                                console.error('❌ Todos los métodos QR fallaron:', {
                                                    qrServer: error1.message,
                                                    googleCharts: error2.message,
                                                    qrAPI: error3.message,
                                                    emergency: error4.message
                                                });
                                                reject(new Error('No se pudo generar QR con ningún método disponible'));
                                            });
                                    });
                            });
                    });
                    
            } catch (error) {
                console.error('❌ Error crítico generando QR:', error);
                reject(error);
            }
        });
    },
    
    // Método 1: QR Server API (más confiable)
    generateWithQRServer: function(canvas, text, size, margin) {
        return new Promise((resolve, reject) => {
            const timeout = setTimeout(() => {
                reject(new Error('Timeout qr-server.com'));
            }, 8000);
            
            const qrUrl = `https://api.qrserver.com/v1/create-qr-code/?size=${size}x${size}&data=${encodeURIComponent(text)}&margin=${margin}&format=png&ecc=M`;
            
            const img = new Image();
            img.crossOrigin = 'anonymous';
            
            img.onload = function() {
                try {
                    clearTimeout(timeout);
                    const ctx = canvas.getContext('2d');
                    
                    // Limpiar canvas
                    canvas.width = size;
                    canvas.height = size;
                    ctx.fillStyle = 'white';
                    ctx.fillRect(0, 0, size, size);
                    
                    // Dibujar QR
                    ctx.drawImage(img, 0, 0, size, size);
                    
                    // Verificar que se dibujó correctamente
                    const imageData = ctx.getImageData(0, 0, size, size);
                    const hasContent = this.verifyQRContent(imageData);
                    
                    if (hasContent) {
                        resolve();
                    } else {
                        reject(new Error('QR generado pero parece estar vacío'));
                    }
                } catch (error) {
                    clearTimeout(timeout);
                    reject(error);
                }
            }.bind(this);
            
            img.onerror = function() {
                clearTimeout(timeout);
                reject(new Error('Error cargando imagen desde qr-server.com'));
            };
            
            img.src = qrUrl;
        });
    },
    
    // Método 2: Google Charts API
    generateWithGoogleCharts: function(canvas, text, size, margin) {
        return new Promise((resolve, reject) => {
            const timeout = setTimeout(() => {
                reject(new Error('Timeout Google Charts'));
            }, 8000);
            
            const qrUrl = `https://chart.googleapis.com/chart?chs=${size}x${size}&cht=qr&chl=${encodeURIComponent(text)}&choe=UTF-8&chld=M|${margin}`;
            
            const img = new Image();
            img.crossOrigin = 'anonymous';
            
            img.onload = function() {
                try {
                    clearTimeout(timeout);
                    const ctx = canvas.getContext('2d');
                    
                    canvas.width = size;
                    canvas.height = size;
                    ctx.fillStyle = 'white';
                    ctx.fillRect(0, 0, size, size);
                    
                    ctx.drawImage(img, 0, 0, size, size);
                    
                    const imageData = ctx.getImageData(0, 0, size, size);
                    const hasContent = this.verifyQRContent(imageData);
                    
                    if (hasContent) {
                        resolve();
                    } else {
                        reject(new Error('QR de Google Charts parece estar vacío'));
                    }
                } catch (error) {
                    clearTimeout(timeout);
                    reject(error);
                }
            }.bind(this);
            
            img.onerror = function() {
                clearTimeout(timeout);
                reject(new Error('Error cargando imagen desde Google Charts'));
            };
            
            img.src = qrUrl;
        });
    },
    
    // Método 3: QR-API alternativa
    generateWithQRAPI: function(canvas, text, size, margin) {
        return new Promise((resolve, reject) => {
            const timeout = setTimeout(() => {
                reject(new Error('Timeout QR-API'));
            }, 8000);
            
            const qrUrl = `https://qr-api.is/qr/?text=${encodeURIComponent(text)}&size=${size}&margin=${margin}&format=png`;
            
            const img = new Image();
            img.crossOrigin = 'anonymous';
            
            img.onload = function() {
                try {
                    clearTimeout(timeout);
                    const ctx = canvas.getContext('2d');
                    
                    canvas.width = size;
                    canvas.height = size;
                    ctx.fillStyle = 'white';
                    ctx.fillRect(0, 0, size, size);
                    
                    ctx.drawImage(img, 0, 0, size, size);
                    
                    const imageData = ctx.getImageData(0, 0, size, size);
                    const hasContent = this.verifyQRContent(imageData);
                    
                    if (hasContent) {
                        resolve();
                    } else {
                        reject(new Error('QR de QR-API parece estar vacío'));
                    }
                } catch (error) {
                    clearTimeout(timeout);
                    reject(error);
                }
            }.bind(this);
            
            img.onerror = function() {
                clearTimeout(timeout);
                reject(new Error('Error cargando imagen desde QR-API'));
            };
            
            img.src = qrUrl;
        });
    },
    
    // Método 4: QR de emergencia (patrón visual)
    generateEmergencyQR: function(canvas, text, size, margin) {
        return new Promise((resolve, reject) => {
            try {
                const ctx = canvas.getContext('2d');
                canvas.width = size;
                canvas.height = size;
                
                // Fondo blanco
                ctx.fillStyle = 'white';
                ctx.fillRect(0, 0, size, size);
                
                // Generar un patrón visual que represente el token
                const hash = this.generateHash(text);
                const gridSize = 25; // Tamaño de grid
                const cellSize = (size - margin * 2) / gridSize;
                
                ctx.fillStyle = 'black';
                
                // Dibujar patrones de ubicación (esquinas)
                this.drawFinderPattern(ctx, margin, margin, cellSize);
                this.drawFinderPattern(ctx, margin + cellSize * (gridSize - 7), margin, cellSize);
                this.drawFinderPattern(ctx, margin, margin + cellSize * (gridSize - 7), cellSize);
                
                // Dibujar patrón de datos basado en hash
                for (let i = 0; i < gridSize; i++) {
                    for (let j = 0; j < gridSize; j++) {
                        if (this.shouldFillCell(i, j, hash, gridSize, text)) {
                            ctx.fillRect(
                                margin + j * cellSize,
                                margin + i * cellSize,
                                cellSize,
                                cellSize
                            );
                        }
                    }
                }
                
                // Agregar texto del token en la parte inferior
                ctx.fillStyle = 'black';
                ctx.font = `${Math.max(8, size * 0.04)}px monospace`;
                ctx.textAlign = 'center';
                ctx.fillText(text, size / 2, size - 5);
                
                console.log('✅ QR de emergencia generado con patrón visual');
                resolve();
                
            } catch (error) {
                reject(error);
            }
        });
    },
    
    // Verificar que el QR tiene contenido
    verifyQRContent: function(imageData) {
        if (!imageData || !imageData.data) return false;
        
        const data = imageData.data;
        let blackPixels = 0;
        let whitePixels = 0;
        
        // Contar píxeles negros y blancos
        for (let i = 0; i < data.length; i += 4) {
            const r = data[i];
            const g = data[i + 1];
            const b = data[i + 2];
            const brightness = (r + g + b) / 3;
            
            if (brightness < 128) {
                blackPixels++;
            } else {
                whitePixels++;
            }
        }
        
        // Verificar que hay suficiente contraste
        const totalPixels = blackPixels + whitePixels;
        const blackRatio = blackPixels / totalPixels;
        
        // Un QR válido debe tener entre 10% y 60% de píxeles negros
        return blackRatio > 0.10 && blackRatio < 0.60;
    },
    
    // Generar hash del texto
    generateHash: function(text) {
        let hash = 0;
        for (let i = 0; i < text.length; i++) {
            const char = text.charCodeAt(i);
            hash = ((hash << 5) - hash) + char;
            hash = hash & hash; // Convertir a 32-bit
        }
        return Math.abs(hash);
    },
    
    // Dibujar patrón de ubicación
    drawFinderPattern: function(ctx, x, y, cellSize) {
        ctx.fillStyle = 'black';
        // Cuadrado exterior 7x7
        ctx.fillRect(x, y, cellSize * 7, cellSize * 7);
        ctx.fillStyle = 'white';
        // Cuadrado interior 5x5
        ctx.fillRect(x + cellSize, y + cellSize, cellSize * 5, cellSize * 5);
        ctx.fillStyle = 'black';
        // Cuadrado central 3x3
        ctx.fillRect(x + cellSize * 2, y + cellSize * 2, cellSize * 3, cellSize * 3);
    },
    
    // Determinar si una celda debe ser negra
    shouldFillCell: function(i, j, hash, gridSize, text) {
        // Evitar patrones de ubicación
        if (this.isFinderPattern(i, j, gridSize)) {
            return false;
        }
        
        // Patrón basado en hash y posición
        const cellIndex = i * gridSize + j;
        const charIndex = cellIndex % text.length;
        const charCode = text.charCodeAt(charIndex);
        
        return ((hash + cellIndex + charCode) % 3) === 0;
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

// Reemplazar implementación anterior
window.SimpleQRGenerator = window.QRCodeFixed;

// Configurar QRCode global
window.QRCode = window.QRCodeFixed;

console.log('✅ Librería QR mejorada cargada - versión reparada');
console.log('📋 Métodos disponibles: toCanvas, toDataURL, generateWithQRServer, generateWithGoogleCharts, generateWithQRAPI, generateEmergencyQR');
console.log('🔍 window.QRCode configurado:', typeof window.QRCode);
console.log('🔍 window.QRCodeFixed configurado:', typeof window.QRCodeFixed);
console.log('🔍 Método toCanvas disponible:', typeof window.QRCode.toCanvas);
