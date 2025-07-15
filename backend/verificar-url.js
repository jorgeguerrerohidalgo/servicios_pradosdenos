require('dotenv').config();

console.log('🔍 Verificando URL de Supabase...\n');

const url = process.env.DATABASE_URL;
console.log('URL actual:', url);
console.log('Longitud:', url ? url.length : 'NO DEFINIDA');

if (url) {
  console.log('\n🔍 Análisis de caracteres:');
  for (let i = 0; i < url.length; i++) {
    const char = url[i];
    const code = char.charCodeAt(0);
    if (code < 32 || code > 126) {
      console.log(`Carácter problemático en posición ${i}: ${char} (código: ${code})`);
    }
  }
  
  // Intentar parsear la URL
  try {
    const parsed = new URL(url);
    console.log('\n✅ URL parseada exitosamente:');
    console.log('Host:', parsed.hostname);
    console.log('Puerto:', parsed.port);
    console.log('Base de datos:', parsed.pathname);
    console.log('Usuario:', parsed.username);
    console.log('Parámetros:', parsed.searchParams.toString());
  } catch (error) {
    console.log('\n❌ Error parseando URL:', error.message);
    
    // Intentar limpiar la URL
    const cleanUrl = url.replace(/[^\x20-\x7E]/g, '');
    console.log('\n🧹 URL limpia:', cleanUrl);
    
    try {
      const parsed = new URL(cleanUrl);
      console.log('\n✅ URL limpia parseada exitosamente:');
      console.log('Host:', parsed.hostname);
      console.log('Puerto:', parsed.port);
      console.log('Base de datos:', parsed.pathname);
      console.log('Usuario:', parsed.username);
      console.log('Parámetros:', parsed.searchParams.toString());
    } catch (cleanError) {
      console.log('\n❌ Error parseando URL limpia:', cleanError.message);
    }
  }
}

// Sugerir formato correcto
console.log('\n💡 Formato correcto para Supabase:');
console.log('DATABASE_URL=postgresql://postgres:TU_PASSWORD@db.TU_PROYECTO.supabase.co:5432/postgres');
console.log('\nDonde:');
console.log('- TU_PASSWORD: Tu contraseña de base de datos');
console.log('- TU_PROYECTO: El ID único de tu proyecto Supabase');
console.log('- El nombre de la base de datos debe ser "postgres" (no "pradosdenos")');
