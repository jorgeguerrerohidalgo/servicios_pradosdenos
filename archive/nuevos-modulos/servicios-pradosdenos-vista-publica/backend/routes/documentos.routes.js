import express from 'express';
import supabase from '../supabase/client.js';
const router = express.Router();

router.post('/', async (req, res) => {
  const { nombre, descripcion, tipo_documento_id, link_drive, fecha_publicacion, visible, subido_por } = req.body;

  const { error } = await supabase.from('documentos_comunitarios').insert({
    nombre, descripcion, tipo_documento_id, link_drive,
    fecha_publicacion, visible, subido_por
  });

  if (error) return res.status(500).json({ error: error.message });
  res.json({ message: 'Documento registrado correctamente' });
});

export default router;
router.get('/', async (req, res) => {
  const { data, error } = await supabase
    .from('documentos_comunitarios')
    .select('*')
    .eq('visible', true)
    .order('fecha_publicacion', { ascending: false });

  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
});