# Plan de Monitoreo

## Herramientas utilizadas
- Prometheus
- Grafana
- Docker Compose
- Endpoint `/metrics` implementado en la aplicación Java

## Métricas implementadas
- `helpets_http_requests_total`: total de peticiones HTTP recibidas.
- `helpets_http_errors_total`: total de errores HTTP.
- `helpets_http_request_duration_avg_ms`: duración promedio de las peticiones.
- `helpets_app_uptime_seconds`: tiempo activo de la aplicación.
- `helpets_db_status`: estado de conexión a base de datos.
- `helpets_jvm_memory_used_bytes`: memoria usada por la JVM.

## Evidencias
- Prometheus conectado al target `helpets-app`.
- Dashboard de Grafana mostrando métricas de la aplicación.
- Captura del dashboard `Helpets - Monitoreo`.