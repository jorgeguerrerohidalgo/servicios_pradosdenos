const express = require('express');
const app = express();
const db = require('./utils/db');

app.use(express.json());

// Endpoint de prueba simple para eventos
app.get('/test-eventos', async (req, res) => {
    try {
        console.log('Probando consulta de eventos...');
        const result = await db.query('SELECT COUNT(*) FROM eventos_vecinales WHERE visible = true');
        console.log('Resultado:', result);
        res.json({ success: true, result });
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

// Endpoint de prueba simple para documentos
app.get('/test-documentos', async (req, res) => {
    try {
        console.log('Probando consulta de documentos...');
        const result = await db.query('SELECT COUNT(*) FROM documentos_comunitarios');
        console.log('Resultado:', result);
        res.json({ success: true, result });
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
    console.log(`Servidor de prueba ejecutándose en puerto ${PORT}`);
});
