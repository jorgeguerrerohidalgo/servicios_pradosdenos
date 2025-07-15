import express from 'express';
import supabase from '../supabase/client.js';
const router = express.Router();

router.post('/', async (req, res) => {
  const { titulo, descripcion, fecha_inicio, fecha_fin, tipo_evento_id, ubicacion, visible, creado_por } = req.body;

  const link_google_cal = `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${encodeURIComponent(titulo)}&dates=${fecha_inicio.replace(/[-:]/g, '').split('.')[0]}/${fecha_fin.replace(/[-:]/g, '').split('.')[0]}&details=${encodeURIComponent(descripcion)}&location=${encodeURIComponent(ubicacion)}`;

  const { error } = await supabase.from('eventos_vecinales').insert({
    titulo, descripcion, fecha_inicio, fecha_fin, tipo_evento_id,
    ubicacion, visible, creado_por, link_google_cal
  });

  if (error) return res.status(500).json({ error: error.message });
  res.json({ message: 'Evento creado correctamente' });
});

export default router;