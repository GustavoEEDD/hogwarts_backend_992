# ETAPA 1: Construcción (Build)
FROM maven:3.9-eclipse-temurin-23 AS build
WORKDIR /app

# Copiamos el pom.xml y descargamos dependencias (para aprovechar la caché de Docker)
COPY pom.xml .

# Copiamos el código fuente y empaquetamos el proyecto (saltando tests para agilizar)
COPY src ./src
RUN mvn clean package

# ETAPA 2: Ejecución (Runtime)
FROM eclipse-temurin:23-jre AS exec
WORKDIR /app

# Copiamos solo el .jar generado en la etapa anterior
# Nota: Asegúrate de que el nombre del jar coincida con el de tu pom.xml
COPY --from=build /app/target/*.jar app.jar

# Exponemos el puerto de la aplicación
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
