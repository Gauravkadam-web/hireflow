# ══════════════════════════════════════════════════════════════════
# HireFlow — Dockerfile
# Multi-stage build: Maven builds the WAR, Tomcat 11 serves it
# ══════════════════════════════════════════════════════════════════

# ── Stage 1: Build ────────────────────────────────────────────────
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy pom first so Maven can cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -q

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests -q

# ── Stage 2: Run ──────────────────────────────────────────────────
FROM tomcat:11.0-jdk21

# Remove Tomcat's default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR as ROOT.war so it serves at /
COPY --from=build /app/target/hireflow.war /usr/local/tomcat/webapps/ROOT.war

# Create uploads directory inside the container
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/uploads/resumes

# Expose Tomcat's default port
EXPOSE 8080

# Start Tomcat
ENTRYPOINT ["catalina.sh", "run"]
