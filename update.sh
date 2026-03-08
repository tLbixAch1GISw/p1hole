#!/usr/bin/env bash
# ============================================================
# Fuerza la actualización de Pi-hole Gravity
# Uso: sudo bash update.sh
# ============================================================

if [ "$EUID" -ne 0 ]; then
    echo "❌ Ejecuta como root: sudo bash update.sh"
    exit 1
fi

echo "🔄 Actualizando Pi-hole Gravity..."
pihole -g
echo "✅ Gravity actualizado correctamente."
