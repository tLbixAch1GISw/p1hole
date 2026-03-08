# 🛡️ Pi-hole Blocklists

Repositorio personal de listas de bloqueo para Pi-hole, organizado por categorías.  
Todas las listas apuntan a sus **fuentes originales** — siempre estarán actualizadas.

---

## 📋 Categorías incluidas

| Categoría | Descripción |
|---|---|
| 🦠 Malware / Phishing | Dominios maliciosos, exploits, phishing activo |
| 🔞 Contenido Adulto | Sitios NSFW y pornografía |
| 🎰 Gambling | Casinos online y apuestas |
| ⛏️ Cryptomining | Scripts de minería en el navegador |
| 📢 Publicidad / Tracking | Anuncios, rastreadores y telemetría |

---

## 🚀 Instalación rápida

### Opción A — Script automático (recomendado)
Ejecuta esto en tu Raspberry Pi / servidor Pi-hole:

```bash
# 1. Descarga el script
curl -O https://raw.githubusercontent.com/TU_USUARIO/pihole-blocklists/main/scripts/import.sh

# 2. Dale permisos
chmod +x import.sh

# 3. Ejecútalo (requiere sudo)
sudo bash import.sh
```

### Opción B — Importar manualmente desde Pi-hole
1. Ve a **Pi-hole Admin** → **Adlists**
2. Copia cada URL del archivo `lists/adlists.txt`
3. Pégalas una por una y haz clic en **Add**
4. Ve a **Tools → Update Gravity** para activarlas

---

## 📁 Estructura del repositorio

```
pihole-blocklists/
│
├── README.md               ← Este archivo
├── lists/
│   ├── adlists.txt         ← Todas las URLs de listas (una por línea)
│   ├── malware.txt         ← Solo URLs de malware/phishing
│   ├── adult.txt           ← Solo URLs de contenido adulto
│   ├── gambling.txt        ← Solo URLs de gambling
│   ├── cryptomining.txt    ← Solo URLs de cryptomining
│   └── ads-tracking.txt    ← Solo URLs de publicidad/tracking
│
├── scripts/
│   ├── import.sh           ← Importa todo a Pi-hole automáticamente
│   └── update.sh           ← Fuerza actualización de gravity
│
└── whitelist/
    └── whitelist.txt       ← Dominios que NUNCA deben bloquearse
```

---

## 🔄 ¿Con qué frecuencia se actualizan las listas?

Pi-hole actualiza las listas automáticamente. Por defecto lo hace **una vez por semana**.  
Para cambiarlo a diario, edita el cron:

```bash
sudo crontab -e
# Agrega esta línea para actualizar todos los días a las 3:00 AM:
0 3 * * * pihole -g
```

---

## ✅ Whitelist recomendada

Algunos dominios legítimos pueden ser bloqueados por error.  
Revisa el archivo `whitelist/whitelist.txt` y ajusta según tus necesidades.

---

## 📊 Fuentes de las listas

| Fuente | Web oficial |
|---|---|
| Hagezi DNS Blocklists | https://github.com/hagezi/dns-blocklists |
| StevenBlack Hosts | https://github.com/StevenBlack/hosts |
| URLHaus (abuse.ch) | https://urlhaus.abuse.ch |
| Phishing Army | https://phishing.army |
| ZeroDot1 CoinBlocker | https://gitlab.com/ZeroDot1/CoinBlockerLists |
| Sinfonietta | https://github.com/Sinfonietta/hostfiles |
| Firebog | https://firebog.net |

---

*Mantén Pi-hole actualizado: `pihole -up`*
