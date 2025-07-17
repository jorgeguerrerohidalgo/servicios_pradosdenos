const express = require('express');
const cors = require('cors');
const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Rutas temporales simplificadas para pruebas
const eventosSimple = require('./routes/eventos-simple.routes.js');
const documentosSimple = require('./routes/documentos-simple.routes.js');

app.use('/api/eventos', eventosSimple);
app.use('/api/documentos_comunitarios', documentosSimple);

// Ruta de prueba
app.get('/test', (req, res) => {
    res.json({
        message: 'Servidor temporal funcionando',
        endpoints: [
            '/api/eventos',
            '/api/documentos_comunitarios'
        ]
    });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Servidor temporal en puerto ${PORT}`);
    console.log('📝 Endpoints disponibles:');
    console.log('  - GET /test');
    console.log('  - GET /api/eventos');
    console.log('  - GET /api/documentos_comunitarios');
});
