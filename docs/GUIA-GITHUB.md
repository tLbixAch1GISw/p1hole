# 📖 Guía: Cómo subir este repositorio a GitHub (para principiantes)

## Paso 1 — Crear cuenta en GitHub (si no tienes una)
1. Ve a https://github.com
2. Haz clic en **Sign up**
3. Elige un nombre de usuario, correo y contraseña
4. Verifica tu correo electrónico

---

## Paso 2 — Crear el repositorio en GitHub
1. Inicia sesión en https://github.com
2. Haz clic en el botón verde **New** (o el ícono **+** arriba a la derecha → *New repository*)
3. Rellena los campos:
   - **Repository name:** `pihole-blocklists`
   - **Description:** `Listas de bloqueo para Pi-hole — Malware, Adulto, Gambling, Crypto, Ads`
   - Selecciona **Public** (para que Pi-hole pueda acceder a los archivos desde internet)
   - ❌ NO marques "Initialize this repository" — lo haremos nosotros
4. Haz clic en **Create repository**

---

## Paso 3 — Instalar Git en tu computadora
### Windows:
- Descarga **Git for Windows**: https://git-scm.com/download/win
- Instala con opciones predeterminadas

### macOS:
```bash
# Abre Terminal y escribe:
xcode-select --install
```

### Linux / Raspberry Pi:
```bash
sudo apt install git -y
```

---

## Paso 4 — Configurar Git (solo la primera vez)
Abre una terminal (o Git Bash en Windows) y escribe:

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

---

## Paso 5 — Subir los archivos a GitHub

### Opción A — Desde tu computadora (si descargaste el ZIP)

```bash
# 1. Descomprime el ZIP descargado, luego entra a la carpeta:
cd pihole-blocklists

# 2. Inicia el repositorio Git local
git init

# 3. Agrega todos los archivos
git add .

# 4. Primer commit (guarda los cambios)
git commit -m "Primer commit: listas de bloqueo Pi-hole"

# 5. Conecta con tu repositorio de GitHub
#    ⚠️ Cambia TU_USUARIO por tu nombre de usuario de GitHub
git remote add origin https://github.com/TU_USUARIO/pihole-blocklists.git

# 6. Sube los archivos
git branch -M main
git push -u origin main
```

GitHub te pedirá tu **usuario** y una **contraseña** (que ahora es un Token).

### ¿Cómo crear el Token de GitHub?
1. Ve a: https://github.com/settings/tokens
2. Clic en **Generate new token (classic)**
3. Dale un nombre: `pihole-token`
4. Marca el permiso: **repo** (acceso completo)
5. Clic en **Generate token**
6. ⚠️ **Copia el token en ese momento** — no lo verás de nuevo
7. Úsalo como contraseña cuando Git te la pida

---

### Opción B — Subir directo desde el navegador (más fácil para novatos)
1. Ve a tu repositorio en GitHub
2. Haz clic en **Add file** → **Upload files**
3. Arrastra todos los archivos y carpetas del ZIP descomprimido
4. Abajo escribe: `Primer commit: listas Pi-hole`
5. Clic en **Commit changes**

---

## Paso 6 — Obtener las URLs raw para Pi-hole

Una vez subido, tus archivos tendrán URLs con este formato:
```
https://raw.githubusercontent.com/TU_USUARIO/pihole-blocklists/main/lists/adlists.txt
```

Puedes usar cualquier archivo de la carpeta `lists/` directamente en Pi-hole → Adlists.

---

## ✅ ¡Listo!
Tu repositorio está en GitHub y Pi-hole puede acceder a tus listas.  
Para actualizar en el futuro, simplemente edita los archivos y haz un nuevo commit.
