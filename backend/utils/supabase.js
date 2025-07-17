const { createClient } = require('@supabase/supabase-js');

// Configuración de Supabase
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Error: Variables de entorno SUPABASE_URL y SUPABASE_ANON_KEY son requeridas');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

// Función para probar la conexión
const testSupabaseConnection = async () => {
  try {
    console.log('🔌 Intentando conectar a Supabase...');
    const { data, error } = await supabase.from('plazas').select('count').single();
    if (error) throw error;
    console.log('✅ Supabase conectado exitosamente');
    return true;
  } catch (error) {
    console.error('❌ Error conectando a Supabase:', error.message);
    return false;
  }
};

module.exports = { supabase, testSupabaseConnection };
