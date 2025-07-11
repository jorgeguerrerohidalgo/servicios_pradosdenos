const http = require('http');
const fs = require('fs');
const path = require('path');

const port = 3001;

// Tipos MIME
const mimeTypes = {
  '.html': 'text/html',
  '.css': 'text/css',
  '.js': 'application/javascript',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon'
};

const server = http.createServer((req, res) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  
  // Obtener el path del archivo
  let filePath = path.join(__dirname, 'public', req.url);
  
  // Si es la raíz, servir index.html
  if (req.url === '/') {
    filePath = path.join(__dirname, 'public', 'index.html');
  }
  
  // Obtener extensión
  const ext = path.extname(filePath).toLowerCase();
  const contentType = mimeTypes[ext] || 'application/octet-stream';
  
  // Verificar si el archivo existe
  fs.access(filePath, fs.constants.F_OK, (err) => {
    if (err) {
      console.log(`Archivo no encontrado: ${filePath}`);
      res.writeHead(404, { 'Content-Type': 'text/html' });
      res.end(`
        <!DOCTYPE html>
        <html>
        <head><title>404 - No encontrado</title></head>
        <body>
          <h1>404 - Archivo no encontrado</h1>
          <p>El archivo <code>${req.url}</code> no existe.</p>
          <p><a href="/">Volver al inicio</a></p>
          <hr>
          <h2>Archivos disponibles:</h2>
          <ul>
            <li><a href="/debug-button-final.html">Debug Button Final</a></li>
            <li><a href="/test-button-click.html">Test Button Click</a></li>
            <li><a href="/guardia-checkin.html">Guardia Check-in Original</a></li>
          </ul>
        </body>
        </html>
      `);
      return;
    }
    
    // Leer y servir el archivo
    fs.readFile(filePath, (err, data) => {
      if (err) {
        console.error(`Error leyendo archivo: ${err.message}`);
        res.writeHead(500, { 'Content-Type': 'text/plain' });
        res.end('Error del servidor');
        return;
      }
      
      res.writeHead(200, { 'Content-Type': contentType });
      res.end(data);
    });
  });
});

server.listen(port, () => {
  console.log(`Servidor simple corriendo en http://localhost:${port}`);
  console.log(`Archivos disponibles:`);
  console.log(`  - http://localhost:${port}/debug-button-final.html`);
  console.log(`  - http://localhost:${port}/test-button-click.html`);
  console.log(`  - http://localhost:${port}/guardia-checkin.html`);
});
