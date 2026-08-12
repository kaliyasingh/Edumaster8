# --- Build Stage ---
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Dependency caching for faster build
COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests

# --- Run Stage ---
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=build /app/target/*.war app.war

# Render PORT configuration
EXPOSE 10000

# Optimization flags for Render Free Tier RAM (512MB limit)
ENTRYPOINT ["java", \
    "-Xmx256m", \
    "-Xms128m", \
    "-XX:MaxMetaspaceSize=160m", \
    "-XX:+UseSerialGC", \
    "-Dserver.port=${PORT:-10000}", \
    "-Dspring.devtools.restart.enabled=false", \
    "-jar", "app.war"]