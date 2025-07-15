import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import eventosRoutes from './routes/eventos.routes.js';
import documentosRoutes from './routes/documentos.routes.js';

dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

app.use('/api/eventos', eventosRoutes);
app.use('/api/documentos', documentosRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
});