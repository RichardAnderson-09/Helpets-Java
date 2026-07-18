# Plan de Testing

## Objetivo
Validar que los módulos principales de Helpets funcionen correctamente.

## Tipos de prueba
- Pruebas unitarias: Encriptador, modelos y validaciones.
- Pruebas funcionales: login, mascotas, adopciones, donaciones, compras e inventario.
- Pruebas de integración: conexión Java + MySQL + Docker.

## Herramientas
- JUnit 5
- Maven Surefire
- JaCoCo
- Docker con imagen Maven + Java 17

## Evidencia
- Comando: docker run --rm -v "$(pwd -W)://app" -w //app maven:3.9-eclipse-temurin-17 mvn clean test jacoco:report
- Reporte: target/site/jacoco/index.html

