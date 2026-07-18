# HELPETS - Sistema de Gestion para Refugio de Animales

HELPETS es una aplicacion web desarrollada en Java con Jakarta EE, JSP, Servlets, Maven, MySQL y Docker. El sistema permite gestionar las operaciones principales de un refugio de animales: mascotas, adopciones, donaciones, compras, inventario, usuarios, voluntarios y procesos veterinarios.

El proyecto aplica una arquitectura MVC, separando vistas JSP, controladores Servlet, modelos de dominio y una capa DAO para el acceso a datos.

## Tecnologias Utilizadas

- Java 17
- Jakarta EE
- JSP y Servlets
- Maven
- MySQL 8.4
- Docker y Docker Compose
- Apache Tomcat
- JUnit 5
- JaCoCo
- OWASP Dependency Check
- Prometheus
- Grafana
- Logback
- Apache POI
- Apache Commons Lang

## Modulos Principales

- Gestion de mascotas.
- Catalogo de mascotas disponibles.
- Solicitudes de adopcion.
- Gestion de donaciones.
- Registro de compras.
- Control de inventario.
- Gestion de usuarios.
- Gestion de voluntarios.
- Modulo veterinario.
- Dashboard administrativo.
- Login y control de sesion.
- Endpoint de metricas para monitoreo.

## Estructura Del Proyecto

```text
Helpets-Java/
|-- bd/
|   |-- Base_de_datos.sql
|   `-- backup.sql
|-- docs/
|   |-- 01-testing.md
|   |-- 02-pruebas-seguridad.md
|   |-- 03-despliegue.md
|   |-- 04-monitoreo.md
|   `-- 05-mantenimiento.md
|-- monitoring/
|   `-- prometheus.yml
|-- src/
|   |-- main/
|   |   |-- java/com/helpets/
|   |   |   |-- config/
|   |   |   |-- controlador/
|   |   |   |-- dao/
|   |   |   `-- modelo/
|   |   |-- resources/
|   |   `-- webapp/
|   `-- test/
|       `-- java/com/helpets/
|-- Dockerfile
|-- docker-compose.yml
|-- dev.Dockerfile
|-- dev.docker-compose.yml
|-- pom.xml
`-- README.md
```

## Configuracion Del Entorno

El proyecto utiliza variables de entorno para evitar exponer credenciales en el codigo fuente.

Crea un archivo `.env` tomando como referencia `.env.example`:

```env
MYSQL_DATABASE=helpets_db
MYSQL_ROOT_PASSWORD=cambia_esto
MYSQL_PORT=3306
APP_PORT=8080

DB_URL=jdbc:mysql://db:3306/helpets_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
DB_USER=root
DB_PASSWORD=cambia_esto
NVD_API_KEY=tu_api_key_nvd
```

No subas el archivo `.env` al repositorio.

## Ejecucion Con Docker

Para levantar la aplicacion en modo produccion:

```bash
docker compose up --build
```

Para levantar el entorno de desarrollo con monitoreo:

```bash
docker compose -f dev.docker-compose.yml up --build
```

Para verificar los contenedores activos:

```bash
docker ps
```

La aplicacion queda disponible en el puerto configurado en `APP_PORT`.

Ejemplo:

```text
http://localhost:8080
```

## Construccion Del Proyecto

El proyecto se construye con Maven y genera un archivo WAR desplegable en Tomcat.

Comando usando Docker:

```bash
docker run --rm -v "$(pwd -W)://app" -w //app maven:3.9-eclipse-temurin-17 mvn clean package -DskipTests
```

Archivo generado:

```text
target/helpetsWeb-1.0-SNAPSHOT.war
```

## Pruebas De Software

Se integraron pruebas automatizadas con JUnit 5 y Maven Surefire.

Clases probadas:

- `Encriptador`
- `Mascota`
- `Producto`
- `Usuario`

Comando de ejecucion:

```bash
docker run --rm -v "$(pwd -W)://app" -w //app maven:3.9-eclipse-temurin-17 mvn clean test
```

Resultado esperado:

```text
Tests run: 5
Failures: 0
Errors: 0
Skipped: 0
BUILD SUCCESS
```

## Cobertura Con JaCoCo

Se configuro JaCoCo para generar reportes de cobertura de codigo.

Comando:

```bash
docker run --rm -v "$(pwd -W)://app" -w //app maven:3.9-eclipse-temurin-17 mvn clean test jacoco:report
```

Reporte generado:

```text
target/site/jacoco/index.html
```

La cobertura inicial se concentra en clases unitarias independientes. Como mejora futura, se recomienda ampliar pruebas de integracion para DAOs, Servlets y flujos completos del sistema.

## Pruebas De Seguridad

Se ejecuto OWASP Dependency Check para analizar vulnerabilidades conocidas en dependencias Maven.

Comando usado:

```bash
docker run --rm -v "$(pwd -W)://app" -w //app -e NVD_API_KEY="$NVD_API_KEY" maven:3.9-eclipse-temurin-17 mvn org.owasp:dependency-check-maven:12.2.2:check -DnvdApiKeyEnvironmentVariable=NVD_API_KEY -DnvdApiDelay=6000 -Dformat=HTML -DfailBuildOnCVSS=11
```

Reporte generado:

```text
target/dependency-check-report.html
```

Buenas practicas aplicadas:

- Uso de `PreparedStatement` para reducir el riesgo de inyeccion SQL.
- Credenciales gestionadas mediante variables de entorno.
- Validacion de campos vacios en el login.
- Hash de contrasenas con SHA-256.
- Timeout de sesion configurado en `web.xml`.

Observacion de mejora:

- Migrar el hash de contrasenas a BCrypt con salt.
- Actualizar dependencias vulnerables detectadas por OWASP Dependency Check.
- Repetir el analisis de seguridad antes de cada despliegue.

## Monitoreo

El entorno de desarrollo incluye monitoreo con Prometheus y Grafana.

Flujo de monitoreo:

```text
Helpets Java -> /metrics -> Prometheus -> Grafana
```

Metricas expuestas por la aplicacion:

- `helpets_app_uptime_seconds`
- `helpets_jvm_memory_used_bytes`
- `helpets_db_status`
- `helpets_http_requests_total`
- `helpets_http_errors_total`
- `helpets_http_request_duration_avg_ms`

URLs del entorno de monitoreo:

```text
Metricas: http://localhost:APP_PORT/metrics
Prometheus: http://localhost:9090
Grafana: http://localhost:3000
```

Credenciales iniciales de Grafana:

```text
Usuario: admin
Contrasena: admin
```

Para validar que Prometheus esta leyendo la aplicacion:

```text
http://localhost:9090/targets
```

El target `helpets-app` debe aparecer en estado `UP`.

## Mantenimiento

El proyecto incluye un plan de mantenimiento documentado en `docs/05-mantenimiento.md`.

Actividades propuestas:

- Backups periodicos de MySQL.
- Limpieza de backups antiguos.
- Revision de logs.
- Revision de vulnerabilidades.
- Actualizacion de dependencias.
- Ejecucion de pruebas antes del despliegue.
- Verificacion de contenedores con `docker ps`.

Comandos utiles:

```bash
docker compose logs web
docker compose logs
docker ps
```

Cron jobs propuestos para un servidor Linux:

```bash
0 2 * * * /ruta-del-proyecto/scripts/backup-db.sh
0 3 * * 0 /ruta-del-proyecto/scripts/cleanup-backups.sh
```

## Documentacion Academica

La evidencia del proyecto se encuentra organizada en la carpeta `docs`:

- `01-testing.md`: pruebas unitarias y cobertura JaCoCo.
- `02-pruebas-seguridad.md`: OWASP Dependency Check y revision manual de buenas practicas.
- `03-despliegue.md`: despliegue con Maven, Docker, Tomcat y MySQL.
- `04-monitoreo.md`: Prometheus, Grafana y metricas de la aplicacion.
- `05-mantenimiento.md`: backups, cron jobs, logs y actualizacion de dependencias.

## Estado Del Proyecto

El proyecto cuenta con:

- Aplicacion web funcional.
- Construccion con Maven.
- Despliegue con Docker y Tomcat.
- Base de datos MySQL dockerizada.
- Pruebas unitarias con JUnit.
- Cobertura con JaCoCo.
- Analisis de seguridad con OWASP Dependency Check.
- Monitoreo con Prometheus y Grafana.
- Plan de mantenimiento documentado.

## Autor

Richard Anderson De la Cruz Campos

Proyecto desarrollado para el curso Integrador I: Sistemas Software.
