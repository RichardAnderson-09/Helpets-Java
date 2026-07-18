# Plan de Despliegue

## Herramientas
- Maven
- Docker
- Docker Compose
- Tomcat 10.1
- MySQL 8.4

## Flujo
1. Configurar variables en .env.
2. Construir WAR con Maven.
3. Levantar servicios con Docker Compose.
4. Validar acceso a la aplicación.
5. Revisar logs del contenedor web.

## Comandos
mvn clean package
docker compose up --build -d
docker compose logs -f web