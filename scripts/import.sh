#!/usr/bin/env bash
# ============================================================
# Pi-hole Blocklists — Script de importación automática
# Autor: Tu repositorio en GitHub
# Uso: sudo bash import.sh
# ============================================================

# ── Colores ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ── Base de datos Pi-hole ─────────────────────────────────────
DB="/etc/pihole/gravity.db"

# ── Banner ────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║        🛡️  Pi-hole Blocklists Importer               ║${NC}"
echo -e "${CYAN}║        Malware • Adulto • Gambling • Crypto • Ads    ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# ── Verificaciones previas ────────────────────────────────────
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ Este script debe ejecutarse como root (sudo bash import.sh)${NC}"
    exit 1
fi

if ! command -v pihole &>/dev/null; then
    echo -e "${RED}❌ Pi-hole no encontrado. ¿Está instalado correctamente?${NC}"
    exit 1
fi

if [ ! -f "$DB" ]; then
    echo -e "${RED}❌ Base de datos de Pi-hole no encontrada en: $DB${NC}"
    exit 1
fi

# ── Instalar sqlite3 si no está disponible ───────────────────
if ! command -v sqlite3 &>/dev/null; then
    echo -e "${YELLOW}⚠️  sqlite3 no encontrado. Instalando automáticamente...${NC}"
    apt-get update -qq && apt-get install -y sqlite3 -qq
    if ! command -v sqlite3 &>/dev/null; then
        echo -e "${RED}❌ No se pudo instalar sqlite3. Instálalo manualmente:${NC}"
        echo -e "   ${CYAN}sudo apt install sqlite3${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ sqlite3 instalado correctamente.${NC}"
fi

echo -e "${GREEN}✅ Pi-hole encontrado. Iniciando importación...${NC}"
echo ""

# ── Función para agregar lista ────────────────────────────────
add_list() {
    local URL="$1"
    local COMMENT="$2"
    local GROUP_ID="$3"   # Grupo por defecto = 0

    # Insertar en adlist si no existe
    sqlite3 "$DB" "INSERT OR IGNORE INTO adlist (address, enabled, comment) VALUES ('$URL', 1, '$COMMENT');"

    # Obtener ID de la lista recién insertada (o existente)
    local LIST_ID
    LIST_ID=$(sqlite3 "$DB" "SELECT id FROM adlist WHERE address='$URL';")

    # Asociar al grupo indicado
    sqlite3 "$DB" "INSERT OR IGNORE INTO adlist_by_group (adlist_id, group_id) VALUES ($LIST_ID, $GROUP_ID);" 2>/dev/null || true

    echo -e "   ${GREEN}✔${NC} $COMMENT"
}

# ── Crear grupos por categoría ────────────────────────────────
echo -e "${BLUE}📁 Creando grupos por categoría...${NC}"

create_group() {
    local NAME="$1"
    local DESC="$2"
    sqlite3 "$DB" "INSERT OR IGNORE INTO \"group\" (name, enabled, description) VALUES ('$NAME', 1, '$DESC');" 2>/dev/null || true
    sqlite3 "$DB" "SELECT id FROM \"group\" WHERE name='$NAME';"
}

GID_MALWARE=$(create_group   "Malware-Phishing"  "Dominios maliciosos y phishing")
GID_ADULT=$(create_group     "Adulto-NSFW"       "Contenido adulto y pornografía")
GID_GAMBLING=$(create_group  "Gambling"          "Casinos y apuestas online")
GID_CRYPTO=$(create_group    "Cryptomining"      "Scripts de minería en navegador")
GID_ADS=$(create_group       "Publicidad"        "Anuncios, rastreadores y telemetría")

echo -e "${GREEN}✅ Grupos creados.${NC}"
echo ""

# ── 🦠 MALWARE / PHISHING ─────────────────────────────────────
echo -e "${YELLOW}🦠 Importando: Malware / Phishing...${NC}"
add_list "https://urlhaus.abuse.ch/downloads/hostfile/" \
         "[Malware] URLHaus - abuse.ch" "$GID_MALWARE"

add_list "https://phishing.army/download/phishing_army_blocklist_extended.txt" \
         "[Malware] Phishing Army Extended" "$GID_MALWARE"

add_list "https://raw.githubusercontent.com/tweedge/emerging-threats-pihole/main/targets/malicious.txt" \
         "[Malware] Emerging Threats - malicious" "$GID_MALWARE"

add_list "https://raw.githubusercontent.com/mike-trewartha/Pi-hole-Talos-Threat-Blocklist/refs/heads/main/talos-threats.list" \
         "[Malware] Cisco Talos Threat Intel" "$GID_MALWARE"

add_list "https://osint.digitalside.it/Threat-Intel/lists/latestdomains.txt" \
         "[Malware] OSINT DigitalSide Threat Intel" "$GID_MALWARE"

add_list "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.txt" \
         "[Malware] Hagezi TIF - Threat Intelligence Feed" "$GID_MALWARE"

echo ""

# ── 🔞 CONTENIDO ADULTO ───────────────────────────────────────
echo -e "${YELLOW}🔞 Importando: Contenido Adulto (NSFW)...${NC}"
add_list "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/nsfw.txt" \
         "[Adulto] Hagezi NSFW" "$GID_ADULT"

add_list "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn/hosts" \
         "[Adulto] StevenBlack - Porn" "$GID_ADULT"

echo ""

# ── 🎰 GAMBLING / APUESTAS ────────────────────────────────────
echo -e "${YELLOW}🎰 Importando: Gambling / Apuestas...${NC}"
add_list "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/gambling.txt" \
         "[Gambling] Hagezi Gambling" "$GID_GAMBLING"

add_list "https://raw.githubusercontent.com/Sinfonietta/hostfiles/master/gambling-hosts" \
         "[Gambling] Sinfonietta" "$GID_GAMBLING"

echo ""

# ── ⛏️ CRYPTOMINING ───────────────────────────────────────────
echo -e "${YELLOW}⛏️  Importando: Cryptomining...${NC}"
add_list "https://zerodot1.gitlab.io/CoinBlockerLists/list.txt" \
         "[Crypto] ZeroDot1 CoinBlocker" "$GID_CRYPTO"

add_list "https://zerodot1.gitlab.io/CoinBlockerLists/list_browser.txt" \
         "[Crypto] ZeroDot1 CoinBlocker Browser" "$GID_CRYPTO"

echo ""

# ── 📢 PUBLICIDAD / TRACKING ──────────────────────────────────
echo -e "${YELLOW}📢 Importando: Publicidad / Tracking...${NC}"
add_list "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt" \
         "[Ads] Hagezi Pro - Ads + Tracking + Telemetria" "$GID_ADS"

add_list "https://v.firebog.net/hosts/Easylist.txt" \
         "[Ads] Firebog EasyList" "$GID_ADS"

add_list "https://v.firebog.net/hosts/Easyprivacy.txt" \
         "[Ads] Firebog EasyPrivacy" "$GID_ADS"

add_list "https://v.firebog.net/hosts/AdguardDNS.txt" \
         "[Ads] Firebog AdGuard DNS" "$GID_ADS"

add_list "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext" \
         "[Ads] Peter Lowe's Ad Server List" "$GID_ADS"

add_list "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" \
         "[Base] StevenBlack - Hosts (ads + malware)" "$GID_ADS"

echo ""

# ── Actualizar Gravity ────────────────────────────────────────
echo -e "${BLUE}🔄 Actualizando Pi-hole Gravity (esto puede tardar unos minutos)...${NC}"
pihole -g

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  ✅ ¡Importación completada exitosamente!            ║${NC}"
echo -e "${CYAN}║  Abre Pi-hole Admin → Adlists para verificar.        ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""
