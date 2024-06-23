FROM maven:3.8.6-openjdk-11-slim AS build

COPY . /app
WORKDIR /app

RUN mvn clean install

FROM openjdk:11-jre-slim

COPY --from=build /app/target/*.jar /app/app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
