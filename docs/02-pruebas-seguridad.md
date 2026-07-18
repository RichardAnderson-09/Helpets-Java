# Reporte de Pruebas de Seguridad

## Herramientas
- OWASP Dependency Check
- Revisión manual de SQL Injection
- Revisión de manejo de sesiones
- Revisión de variables de entorno

## Observaciones levantadas
- Uso correcto de PreparedStatement en DAO.
- Credenciales separadas mediante variables de entorno.
- Se recomienda reforzar cabeceras HTTP.
- Se recomienda migrar SHA-256 simple a BCrypt en una versión futura.

## Evidencia
- Comando: mvn org.owasp:dependency-check-maven:check
- Reporte: target/dependency-check-report.html