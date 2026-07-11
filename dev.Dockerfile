# ==========================================
# Etapa 1: Construcción (Builder)
# ==========================================
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copiamos el pom.xml y la carpeta src de tu proyecto local
COPY pom.xml .
COPY src ./src

# Maven compila el proyecto y genera el .war
RUN mvn clean package -DskipTests

# ==========================================
# Etapa 2: Producción (Servidor Tomcat)
# ==========================================
FROM tomcat:10.1-jdk17

RUN rm -rf /usr/local/tomcat/webapps/* 

# Copiamos el .war generado en la Etapa 1 hacia la carpeta webapps de Tomcat
COPY --from=builder /app/target/helpetsWeb-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war 

EXPOSE 8080
CMD ["catalina.sh", "run"]