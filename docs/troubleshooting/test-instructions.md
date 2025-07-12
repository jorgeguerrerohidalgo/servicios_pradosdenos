# 🚀 INSTRUCCIONES PASO A PASO

## 📋 **PASOS PARA PROBAR EL LOGIN CORREGIDO:**

### 1. **Abrir Terminal/CMD en la carpeta backend**
```bash
cd d:\00.DESARROLLO\REPOS\servicios_pradosdenos\backend
```

### 2. **Iniciar el servidor**
```bash
npm start
```
**o**
```bash
node server.js
```

### 3. **Verificar que el servidor inicie correctamente**
Deberías ver:
- `🔍 Verificando tabla security_logs...`
- `Server running on port 3000`
- `Connected to database`

### 4. **Probar el login**
- Abrir navegador en: `http://localhost:3000/guardia-login.html`
- Ingresar credenciales de guardia
- Presionar "Iniciar Sesión"

### 5. **Verificar funcionamiento**
- ✅ Debería redireccionar a `guardia-checkin.html`
- ✅ NO debería volver al login automáticamente
- ✅ Revisar consola del navegador (F12) para logs detallados

## 🔧 **SI SIGUE FALLANDO:**

### Verificar logs del servidor:
- Ver mensajes de error en terminal
- Verificar si la tabla `security_logs` se creó correctamente

### Verificar logs del navegador:
- Abrir DevTools (F12)
- Ir a la pestaña "Console"
- Buscar mensajes de error o de login

### Verificar base de datos:
- Confirmar que la tabla `security_logs` existe
- Verificar credenciales de guardia en la tabla `users`

## 📞 **REPORTAR RESULTADO:**
Una vez probado, reportar:
- ✅ ¿Funciona el login?
- ✅ ¿Se mantiene la sesión?
- ✅ ¿Hay errores en consola?
- ✅ ¿Qué mensajes aparecen en el servidor?
