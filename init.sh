#!/bin/bash

# Colores y estilo
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # Sin color

# --- El toque especial: ASCII Art ---
echo -e "${CYAN}"
echo "    __    __      _                            "
echo "   / /   / /___ _/ /__  ___________ ________  "
echo "  / / /| / / __  / / _ \/ ___/ __  / ___/ _ \ "
echo " / / |/ / / /_/ / /  __/ /__/ /_/ / /  /  __/ "
echo "/_/|__/ /\__,_/_/\___/\___/\__,_/_/   \___/  "
echo "      /_/                                    "
echo -e "       ☠️  ¡BIENVENIDO AL LABORATORIO WALLACER! ☠️${NC}"
echo ""

# --- Tu automatización original ---
echo "Iniciando configuración del laboratorio..."

# 1. Crear directorios
mkdir -p db_data sql

# 2. Asignar permisos
sudo chown -R $USER:$USER ./db_data
chmod -R 755 ./db_data

# 3. Verificar .env
if [ ! -f .env ]; then
    echo "Creando archivo .env desde ejemplo..."
    cp .env.example .env
fi

# 4. Levantar Docker
echo "Levantando servicios..."
docker compose up -d --wait

echo -e "${CYAN}--- Laboratorio Wallacer listo y funcionando ---${NC}"
