# Stage 1: Build the application
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /workspace/app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

# THIS LINE FIXES THE WINDOWS ERROR:
RUN sed -i -e 's/\r$//' ./mvnw && chmod +x ./mvnw

RUN ./mvnw clean package -DskipTests

# Stage 2: Create the lightweight runtime image
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=builder /workspace/app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]