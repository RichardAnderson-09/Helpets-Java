# ETAPA 1: Entorno de construcción con Maven
FROM maven:3.9-eclipse-temurin-17 AS constructor
WORKDIR /app

# Copiamos los archivos necesarios para compilar
COPY pom.xml .
COPY src ./src

# Compilamos el proyecto omitiendo los tests para evitar bloqueos por conexión a BD
RUN mvn clean package -DskipTests

# ETAPA 2: Entorno de producción con Tomcat
FROM tomcat:10.1-jdk17

# Limpiamos las apps por defecto
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiamos el .war desde la ETAPA 1 hacia Tomcat
COPY --from=constructor /app/target/helpetsWeb-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]