#!/bin/bash
# 1. Ir a la carpeta raíz del proyecto
cd /home/jose/proyecto_mysql

# 2. Cargar las variables del archivo .env
# Usamos 'export' para que las variables sean accesibles por el comando de Docker
set -a
source .env
set +a

# 3. Definir variables de respaldo
BACKUP_DIR="/home/jose/proyecto_mysql/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FILENAME="$BACKUP_DIR/backup_$TIMESTAMP.sql"

# Asegurar que la carpeta existe
mkdir -p $BACKUP_DIR

# 4. Ejecutar el backup
# Nota: La contraseña va pegada al -p, sin espacios.
docker compose exec -T db mysqldump -u$DB_USER -p$DB_PASS $DB_NAME > "$FILENAME"

# 5. Limpieza
find "$BACKUP_DIR" -type f -name "*.sql" -mtime +7 -delete

echo "Backup finalizado: $FILENAME"
