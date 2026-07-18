# Plan de Mantenimiento

## Actividades
- Backups diarios de MySQL.
- Revisión semanal de logs.
- Actualización mensual de dependencias Maven.
- Validación de vulnerabilidades con OWASP Dependency Check.
- Limpieza de backups antiguos.

## Cron sugerido
0 2 * * * /ruta/scripts/backup-db.sh
0 3 * * 0 /ruta/scripts/cleanup-backups.sh