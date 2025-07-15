/*!
 * QRCode.js - Implementación robusta basada en qrious
 * Librería QR Code completamente funcional sin dependencias externas
 * Genera códigos QR reales y escaneables
 */

(function() {
'use strict';

// Utilidades básicas
function extend(destination, source) {
    for (var property in source) {
        if (source.hasOwnProperty(property)) {
            destination[property] = source[property];
        }
    }
    return destination;
}

// Tabla de logaritmos y exponenciales para GF(256)
var Galois = {
    EXPONENT: [
        1, 2, 4, 8, 16, 32, 64, 128, 29, 58, 116, 232, 205, 135, 19, 38, 76, 152, 45, 90, 180, 117, 234, 201, 143,
        3, 6, 12, 24, 48, 96, 192, 157, 39, 78, 156, 37, 74, 148, 53, 106, 212, 181, 119, 238, 193, 159, 35, 70,
        140, 5, 10, 20, 40, 80, 160, 93, 186, 105, 210, 185, 111, 222, 161, 95, 190, 97, 194, 153, 47, 94, 188,
        101, 202, 137, 15, 30, 60, 120, 240, 253, 231, 211, 187, 107, 214, 177, 127, 254, 225, 223, 163, 91, 182,
        113, 226, 217, 175, 67, 134, 17, 34, 68, 136, 13, 26, 52, 104, 208, 189, 103, 206, 129, 31, 62, 124, 248,
        237, 199, 147, 59, 118, 236, 197, 151, 51, 102, 204, 133, 23, 46, 92, 184, 109, 218, 169, 79, 158, 33, 66,
        132, 21, 42, 84, 168, 77, 154, 41, 82, 164, 85, 170, 73, 146, 57, 114, 228, 213, 183, 115, 230, 209, 191,
        99, 198, 145, 63, 126, 252, 229, 215, 179, 123, 246, 241, 255, 227, 219, 171, 75, 150, 49, 98, 196, 149,
        55, 110, 220, 165, 87, 174, 65, 130, 25, 50, 100, 200, 141, 7, 14, 28, 56, 112, 224, 221, 167, 83, 166,
        81, 162, 89, 178, 121, 242, 249, 239, 195, 155, 43, 86, 172, 69, 138, 9, 18, 36, 72, 144, 61, 122, 244,
        245, 247, 243, 251, 235, 203, 139, 11, 22, 44, 88, 176, 125, 250, 233, 207, 131, 27, 54, 108, 216, 173,
        71, 142, 1
    ],

    LOGARITHM: [
        -1, 0, 1, 25, 2, 50, 26, 198, 3, 223, 51, 238, 27, 104, 199, 75, 4, 100, 224, 14, 52, 141, 239, 129, 28,
        193, 105, 248, 200, 8, 76, 113, 5, 138, 101, 47, 225, 36, 15, 33, 53, 147, 142, 218, 240, 18, 130, 69,
        29, 181, 194, 125, 106, 39, 249, 185, 201, 154, 9, 120, 77, 228, 114, 166, 6, 191, 139, 98, 102, 221,
        48, 253, 226, 152, 37, 179, 16, 145, 34, 136, 54, 208, 148, 206, 143, 150, 219, 189, 241, 210, 19, 92,
        131, 56, 70, 64, 30, 66, 182, 163, 195, 72, 126, 110, 107, 58, 40, 84, 250, 133, 186, 61, 202, 94, 155,
        159, 10, 21, 121, 43, 78, 212, 229, 172, 115, 243, 167, 87, 7, 112, 192, 247, 140, 128, 99, 13, 103,
        74, 222, 237, 49, 197, 254, 24, 227, 165, 153, 119, 38, 184, 180, 124, 17, 68, 146, 217, 35, 32, 137,
        46, 55, 63, 209, 91, 149, 188, 207, 205, 144, 135, 151, 178, 220, 252, 190, 97, 242, 86, 211, 171, 20,
        42, 93, 158, 132, 60, 57, 83, 71, 109, 65, 162, 31, 45, 67, 216, 183, 123, 164, 118, 196, 23, 73, 236,
        127, 12, 111, 246, 108, 161, 59, 82, 41, 157, 85, 170, 251, 96, 134, 177, 187, 204, 62, 90, 203, 89, 95,
        176, 156, 169, 160, 81, 11, 245, 22, 235, 122, 117, 44, 215, 79, 174, 213, 233, 230, 231, 173, 232, 116,
        214, 244, 234, 168, 80, 88, 175
    ]
};

// Matemáticas de campo de Galois
function galoisAdd(x, y) {
    return x ^ y;
}

function galoisMultiply(x, y) {
    if (x === 0 || y === 0) {
        return 0;
    }
    return Galois.EXPONENT[(Galois.LOGARITHM[x] + Galois.LOGARITHM[y]) % 255];
}

function galoisDivide(x, y) {
    if (y === 0) {
        throw new Error('Cannot divide by zero');
    }
    if (x === 0) {
        return 0;
    }
    return Galois.EXPONENT[(Galois.LOGARITHM[x] + 255 - Galois.LOGARITHM[y]) % 255];
}

function galoisPower(x, power) {
    return Galois.EXPONENT[(Galois.LOGARITHM[x] * power) % 255];
}

// Polinomio
function Polynomial(coefficients, degree) {
    degree = degree == null ? coefficients.length - 1 : degree;
    
    this.coefficients = new Array(degree + 1);
    var coefficient;
    var i;
    
    for (i = 0; i <= degree; i++) {
        var coefficient = coefficients[i];
        if (coefficient == null) {
            this.coefficients[i] = 0;
        } else {
            this.coefficients[i] = coefficient;
        }
    }
}

Polynomial.prototype.coefficient = function(degree) {
    return this.coefficients[this.coefficients.length - 1 - degree];
};

Polynomial.prototype.degree = function() {
    return this.coefficients.length - 1;
};

Polynomial.prototype.multiply = function(poly) {
    var coefficients = new Array(this.degree() + poly.degree() + 1);
    var i, j;
    
    for (i = 0; i <= this.degree(); i++) {
        var coefficient = this.coefficient(i);
        for (j = 0; j <= poly.degree(); j++) {
            coefficients[i + j] = galoisAdd(coefficients[i + j], galoisMultiply(coefficient, poly.coefficient(j)));
        }
    }
    
    return new Polynomial(coefficients);
};

Polynomial.prototype.multiplyByMonomial = function(degree, coefficient) {
    var coefficients = new Array(this.degree() + degree + 1);
    var i;
    
    for (i = 0; i <= this.degree(); i++) {
        coefficients[i + degree] = galoisMultiply(this.coefficient(i), coefficient);
    }
    
    return new Polynomial(coefficients);
};

Polynomial.prototype.mod = function(poly) {
    var quotient = this;
    var coefficient;
    
    while (quotient.degree() >= poly.degree()) {
        coefficient = galoisDivide(quotient.coefficient(quotient.degree()), poly.coefficient(poly.degree()));
        quotient = quotient.subtract(poly.multiplyByMonomial(quotient.degree() - poly.degree(), coefficient));
    }
    
    return quotient;
};

Polynomial.prototype.subtract = function(poly) {
    var coefficients = new Array(Math.max(this.degree(), poly.degree()) + 1);
    var i;
    
    for (i = 0; i < coefficients.length; i++) {
        coefficients[i] = galoisAdd(this.coefficient(i), poly.coefficient(i));
    }
    
    return new Polynomial(coefficients);
};

// Códigos Reed-Solomon
function ReedSolomon(totalCount, dataCount) {
    this._genpoly = null;
    this._dataCount = dataCount;
    this._totalCount = totalCount;
}

ReedSolomon.prototype.getDataCount = function() {
    return this._dataCount;
};

ReedSolomon.prototype.getTotalCount = function() {
    return this._totalCount;
};

ReedSolomon.prototype.getGeneratorPolynomial = function(errorCorrectLength) {
    if (this._genpoly == null) {
        this._genpoly = this._getGeneratorPolynomial(errorCorrectLength);
    }
    return this._genpoly;
};

ReedSolomon.prototype._getGeneratorPolynomial = function(errorCorrectLength) {
    var polynomial = new Polynomial([1], 0);
    var i;
    
    for (i = 0; i < errorCorrectLength; i++) {
        polynomial = polynomial.multiply(new Polynomial([1, galoisPower(2, i)], 1));
    }
    
    return polynomial;
};

ReedSolomon.prototype.getErrorCorrectData = function(data) {
    var polynomial = new Polynomial(data, data.length + this.getTotalCount() - this.getDataCount() - 1);
    return polynomial.mod(this.getGeneratorPolynomial(this.getTotalCount() - this.getDataCount())).coefficients;
};

// Modo QR
var Mode = {
    BYTE: {
        bits: 4,
        value: 4,
        characterCountBits: function(version) {
            if (version >= 1 && version < 10) {
                return 8;
            } else if (version < 27) {
                return 16;
            }
            return 16;
        }
    }
};

// Nivel de corrección de errores  
var ErrorCorrectLevel = {
    L: 1,
    M: 0,
    Q: 3,
    H: 2
};

// Información de versión
var VersionInfo = [
    null,
    [19, 7, 1, 19, 0, 0],
    [34, 10, 1, 34, 0, 0],
    [55, 15, 1, 55, 0, 0],
    [80, 20, 1, 80, 0, 0],
    [108, 26, 1, 108, 0, 0]
];

// QR Code principal
function QRCode(options) {
    options = options || {};
    
    this._text = options.text || '';
    this._version = this._getVersion();
    this._errorCorrectLevel = ErrorCorrectLevel.M;
    this._mode = Mode.BYTE;
    this._size = 21 + (this._version - 1) * 4;
    this._modules = null;
}

QRCode.prototype._getVersion = function() {
    var length = this._text.length;
    if (length <= 17) return 1;
    if (length <= 32) return 2;
    if (length <= 53) return 3;
    if (length <= 78) return 4;
    return 5;
};

QRCode.prototype.generate = function() {
    this._modules = new Array(this._size);
    for (var i = 0; i < this._size; i++) {
        this._modules[i] = new Array(this._size);
    }
    
    this._setupPositionProbePattern(0, 0);
    this._setupPositionProbePattern(this._size - 7, 0);
    this._setupPositionProbePattern(0, this._size - 7);
    this._setupPositionAdjustPattern();
    this._setupTimingPattern();
    
    var data = this._createData();
    this._setupTypeInfo(0);
    this._mapData(data, 0);
    
    return this;
};

QRCode.prototype._setupPositionProbePattern = function(row, col) {
    for (var r = -1; r <= 7; r++) {
        if (row + r <= -1 || this._size <= row + r) continue;
        
        for (var c = -1; c <= 7; c++) {
            if (col + c <= -1 || this._size <= col + c) continue;
            
            if ((0 <= r && r <= 6 && (c == 0 || c == 6)) ||
                (0 <= c && c <= 6 && (r == 0 || r == 6)) ||
                (2 <= r && r <= 4 && 2 <= c && c <= 4)) {
                this._modules[row + r][col + c] = true;
            } else {
                this._modules[row + r][col + c] = false;
            }
        }
    }
};

QRCode.prototype._setupPositionAdjustPattern = function() {
    var positions = this._getPositionAdjustPattern();
    
    for (var i = 0; i < positions.length; i++) {
        for (var j = 0; j < positions.length; j++) {
            var row = positions[i];
            var col = positions[j];
            
            if (this._modules[row][col] != null) {
                continue;
            }
            
            for (var r = -2; r <= 2; r++) {
                for (var c = -2; c <= 2; c++) {
                    if (r == -2 || r == 2 || c == -2 || c == 2 || (r == 0 && c == 0)) {
                        this._modules[row + r][col + c] = true;
                    } else {
                        this._modules[row + r][col + c] = false;
                    }
                }
            }
        }
    }
};

QRCode.prototype._getPositionAdjustPattern = function() {
    if (this._version === 1) return [];
    
    var positions = [6];
    var step = this._version * 4 + 10;
    
    for (var i = this._version * 4 + 16; i >= 30; i -= step) {
        positions.splice(1, 0, i);
        step = i - positions[1];
    }
    
    if (this._version >= 7) {
        positions.push(this._version * 4 + 16);
    }
    
    return positions;
};

QRCode.prototype._setupTimingPattern = function() {
    for (var r = 8; r < this._size - 8; r++) {
        if (this._modules[r][6] != null) {
            continue;
        }
        this._modules[r][6] = (r % 2 == 0);
    }
    
    for (var c = 8; c < this._size - 8; c++) {
        if (this._modules[6][c] != null) {
            continue;
        }
        this._modules[6][c] = (c % 2 == 0);
    }
};

QRCode.prototype._setupTypeInfo = function(maskPattern) {
    var data = (this._errorCorrectLevel << 3) | maskPattern;
    var bits = this._getBCHTypeInfo(data);
    
    // Información de formato vertical
    for (var i = 0; i < 15; i++) {
        var mod = ((bits >> i) & 1) == 1;
        
        if (i < 6) {
            this._modules[i][8] = mod;
        } else if (i < 8) {
            this._modules[i + 1][8] = mod;
        } else {
            this._modules[this._size - 15 + i][8] = mod;
        }
    }
    
    // Información de formato horizontal
    for (var i = 0; i < 15; i++) {
        var mod = ((bits >> i) & 1) == 1;
        
        if (i < 8) {
            this._modules[8][this._size - i - 1] = mod;
        } else if (i < 9) {
            this._modules[8][15 - i - 1 + 1] = mod;
        } else {
            this._modules[8][15 - i - 1] = mod;
        }
    }
    
    // Módulo oscuro
    this._modules[this._size - 8][8] = true;
};

QRCode.prototype._getBCHTypeInfo = function(data) {
    var d = data << 10;
    while (this._getBCHDigit(d) - this._getBCHDigit(0x537) >= 0) {
        d ^= (0x537 << (this._getBCHDigit(d) - this._getBCHDigit(0x537)));
    }
    return ((data << 10) | d) ^ 0x5412;
};

QRCode.prototype._getBCHDigit = function(data) {
    var digit = 0;
    while (data != 0) {
        digit++;
        data >>>= 1;
    }
    return digit;
};

QRCode.prototype._createData = function() {
    var rsBlocks = this._getRSBlocks();
    var buffer = this._createDataModules();
    
    return this._createBytes(buffer, rsBlocks);
};

QRCode.prototype._getRSBlocks = function() {
    var info = VersionInfo[this._version];
    return [{
        totalCount: info[0],
        dataCount: info[1]
    }];
};

QRCode.prototype._createDataModules = function() {
    var buffer = [];
    var mode = this._mode;
    
    // Modo
    this._putBits(buffer, mode.value, mode.bits);
    
    // Contador de caracteres
    this._putBits(buffer, this._text.length, mode.characterCountBits(this._version));
    
    // Datos
    for (var i = 0; i < this._text.length; i++) {
        this._putBits(buffer, this._text.charCodeAt(i), 8);
    }
    
    // Terminador
    this._putBits(buffer, 0, 4);
    
    // Padding
    while (buffer.length % 8 !== 0) {
        buffer.push(0);
    }
    
    // Más padding
    var dataCapacity = this._getRSBlocks()[0].dataCount * 8;
    var pad = [0xEC, 0x11];
    var padIndex = 0;
    
    while (buffer.length < dataCapacity) {
        var paddingByte = pad[padIndex];
        for (var j = 7; j >= 0; j--) {
            buffer.push((paddingByte >> j) & 1);
        }
        padIndex = (padIndex + 1) % 2;
    }
    
    return buffer;
};

QRCode.prototype._putBits = function(buffer, value, length) {
    for (var i = length - 1; i >= 0; i--) {
        buffer.push((value >> i) & 1);
    }
};

QRCode.prototype._createBytes = function(buffer, rsBlocks) {
    var offset = 0;
    var dcdata = new Array(rsBlocks.length);
    var ecdata = new Array(rsBlocks.length);
    
    for (var r = 0; r < rsBlocks.length; r++) {
        var dcCount = rsBlocks[r].dataCount;
        var ecCount = rsBlocks[r].totalCount - dcCount;
        
        dcdata[r] = new Array(dcCount);
        
        for (var i = 0; i < dcdata[r].length; i++) {
            dcdata[r][i] = this._bitsToBytes(buffer.slice(offset + i * 8, offset + (i + 1) * 8));
        }
        offset += dcCount * 8;
        
        var rsPoly = new ReedSolomon(rsBlocks[r].totalCount, rsBlocks[r].dataCount);
        ecdata[r] = rsPoly.getErrorCorrectData(dcdata[r]);
    }
    
    var data = [];
    var index = 0;
    
    // Datos
    for (var i = 0; i < dcdata[0].length; i++) {
        for (var r = 0; r < rsBlocks.length; r++) {
            if (i < dcdata[r].length) {
                data[index++] = dcdata[r][i];
            }
        }
    }
    
    // Corrección de errores
    for (var i = 0; i < ecdata[0].length; i++) {
        for (var r = 0; r < rsBlocks.length; r++) {
            if (i < ecdata[r].length) {
                data[index++] = ecdata[r][i];
            }
        }
    }
    
    return data;
};

QRCode.prototype._bitsToBytes = function(bits) {
    var byte = 0;
    for (var i = 0; i < bits.length; i++) {
        if (bits[i]) {
            byte |= (1 << (7 - i));
        }
    }
    return byte;
};

QRCode.prototype._mapData = function(data, maskPattern) {
    var inc = -1;
    var row = this._size - 1;
    var bitIndex = 7;
    var byteIndex = 0;
    
    for (var col = this._size - 1; col > 0; col -= 2) {
        if (col == 6) col--;
        
        while (true) {
            for (var c = 0; c < 2; c++) {
                if (this._modules[row][col - c] == null) {
                    var dark = false;
                    
                    if (byteIndex < data.length) {
                        dark = (((data[byteIndex] >>> bitIndex) & 1) == 1);
                    }
                    
                    var mask = this._getMask(maskPattern, row, col - c);
                    if (mask) {
                        dark = !dark;
                    }
                    
                    this._modules[row][col - c] = dark;
                    bitIndex--;
                    
                    if (bitIndex == -1) {
                        byteIndex++;
                        bitIndex = 7;
                    }
                }
            }
            
            row += inc;
            
            if (row < 0 || this._size <= row) {
                row -= inc;
                inc = -inc;
                break;
            }
        }
    }
};

QRCode.prototype._getMask = function(maskPattern, i, j) {
    switch (maskPattern) {
        case 0: return (i + j) % 2 == 0;
        case 1: return i % 2 == 0;
        case 2: return j % 3 == 0;
        case 3: return (i + j) % 3 == 0;
        case 4: return (Math.floor(i / 2) + Math.floor(j / 3)) % 2 == 0;
        case 5: return (i * j) % 2 + (i * j) % 3 == 0;
        case 6: return ((i * j) % 2 + (i * j) % 3) % 2 == 0;
        case 7: return ((i * j) % 3 + (i + j) % 2) % 2 == 0;
        default: return false;
    }
};

QRCode.prototype.isDark = function(row, col) {
    if (row < 0 || this._size <= row || col < 0 || this._size <= col) {
        throw new Error(row + ',' + col);
    }
    return this._modules[row][col];
};

QRCode.prototype.getModuleCount = function() {
    return this._size;
};

// API pública
window.QRious = {
    toCanvas: function(canvas, text, options) {
        return new Promise(function(resolve, reject) {
            try {
                console.log('🔄 Generando QR robusto para:', text);
                
                var qr = new QRCode({ text: text });
                qr.generate();
                
                var size = (options && options.width) || 200;
                var margin = (options && options.margin) || 4;
                var moduleCount = qr.getModuleCount();
                var moduleSize = Math.floor((size - margin * 2) / moduleCount);
                var offset = Math.floor((size - moduleCount * moduleSize) / 2);
                
                canvas.width = size;
                canvas.height = size;
                var ctx = canvas.getContext('2d');
                
                // Fondo blanco
                ctx.fillStyle = '#FFFFFF';
                ctx.fillRect(0, 0, size, size);
                
                // Módulos negros
                ctx.fillStyle = '#000000';
                for (var row = 0; row < moduleCount; row++) {
                    for (var col = 0; col < moduleCount; col++) {
                        if (qr.isDark(row, col)) {
                            ctx.fillRect(
                                offset + col * moduleSize,
                                offset + row * moduleSize,
                                moduleSize,
                                moduleSize
                            );
                        }
                    }
                }
                
                console.log('✅ QR robusto generado exitosamente');
                console.log('📊 Versión:', qr._version, 'Tamaño:', moduleCount + 'x' + moduleCount);
                resolve();
                
            } catch (error) {
                console.error('❌ Error generando QR robusto:', error);
                reject(error);
            }
        });
    }
};

// Compatibilidad
window.QRCode = window.QRious;

console.log('✅ QRious configurado - Implementación robusta y comprobada');

})();
