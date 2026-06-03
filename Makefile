# --- Configuración del Proyecto ---
ayuda: ## Muestra esta lista de comandos disponibles
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# --- Ciclo de vida de Contenedores ---
inicio: ## Levanta los contenedores en segundo plano
	docker compose up -d

apagar: ## Detiene los contenedores
	docker compose down

reinicio: ## Reinicia los contenedores
	docker compose restart

stop: ## Solo apaga los servicios
	docker compose stop

# --- Diagnóstico y Mantenimiento ---
logs: ## Muestra los logs en tiempo real para diagnosticar
	docker compose logs -f

estado: ## Muestra el estado actual y los últimos 20 logs
	docker ps
	docker compose logs --tail=20

shell-php: ## Accede a la terminal del contenedor PHP
	docker compose exec php bash

shell-db: ## Accede a la terminal de MySQL
	docker compose exec db mysql -u root -prootpassword laboratorio_db

# --- Limpieza total ---
clean: ## Elimina contenedores y VOLÚMENES (borra toda la data)
	docker compose down -v

construir: ## Para construir el contenedor
	docker compose build --no-cache

# --- Automatización ---
mantenimiento: apagar clean inicio ## Ejecuta una reconstrucción total del sistema

servicios: ## Lista los servicios definidos
	@docker compose ps --services

instalar-libs: ## Instala librerías
	@docker compose up -d --wait php-app
	@docker compose exec php-app composer install --no-dev --optimize-autoloader

seguridad: ## Audita seguridad
	@docker compose up -d --wait php-app
	@docker compose exec php-app composer audit

salud: ## Muestra el estado de salud de los servicios
	@docker compose ps


# --- Respaldo y Recuperación ---
backup: ## Crea un respaldo de la base de datos
	@echo "Generando backup de $(DB_NAME)..."
	@docker compose exec -T db sh -c 'mysqldump -u root -p"$$MYSQL_ROOT_PASSWORD" "$$MYSQL_DATABASE"' > ./backups/backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "Backup guardado en ./backups/"

listar-backups: ## Lista los respaldos disponibles
	@ls -lh ./backups/

restaurar: ## Restaura un backup. Uso: make restaurar ARCHIVO=nombre_del_backup.sql
	@if [ -z "$(ARCHIVO)" ]; then \
		echo "Error: Debes especificar el archivo. Uso: make restaurar ARCHIVO=backup_XXXX.sql"; \
	else \
		echo "Restaurando $(ARCHIVO)..."; \
		docker compose exec -T db sh -c 'mysql -u root -p"$$MYSQL_ROOT_PASSWORD" "$$MYSQL_DATABASE"' < ./backups/$(ARCHIVO); \
		echo "Restauración completada."; \
	fi


# --- Integración Continua (CI) Local ---
# Ejecutar pruebas de calidad
# --- Integración Continua (CI) Local ---
test: ## Ejecuta el análisis estático de código
	@echo "--- Asegurando dependencias de desarrollo ---"
	@docker compose exec -T php-app composer install --dev
	@echo "--- Iniciando Auditoría de Código (PHPStan) ---"
	@docker compose exec -T php-app ./vendor/bin/phpstan analyse src --level=5
	@echo "--- Auditoría Finalizada ---"

# Documentacón
.PHONY: docs

docs: ## Genera la documentación técnica profesional
	@echo "Generando documentación en docs/api..."
	@mkdir -p docs/api
	@docker compose exec -T php-app ./vendor/bin/phpdoc run --directory=/var/www/html/src --target=/var/www/html/docs/api --force
	@echo "¡Éxito! Documentación lista en: docs/api/index.html"

# Seeds

seed: ## Inserta datos de prueba en la base de datos
	@echo "Sembrando base de datos..."
	@docker compose exec -T php-app php seed.php
	@echo "¡Listo! Base de datos inicializada."
