# Dockerfile para deployment opcional
FROM node:18-alpine

# Crear directorio de trabajo
WORKDIR /app

# Copiar package.json
COPY backend/package*.json ./

# Instalar dependencias
RUN npm install --omit=dev

# Copiar código fuente
COPY backend/ .
COPY public/ ./public/

# Crear usuario no-root
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Cambiar ownership de archivos
RUN chown -R nextjs:nodejs /app
USER nextjs

# Exponer puerto
EXPOSE 3000

# Variables de entorno por defecto
ENV NODE_ENV=production
ENV PORT=3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "const http = require('http'); const options = { host: 'localhost', port: process.env.PORT || 3000, path: '/health', timeout: 2000 }; const req = http.request(options, (res) => { console.log(\`STATUS: \${res.statusCode}\`); process.exitCode = res.statusCode === 200 ? 0 : 1; }); req.on('error', () => { process.exitCode = 1; }); req.end();"

# Comando de inicio
CMD ["npm", "start"]
