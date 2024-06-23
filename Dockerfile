FROM ubuntu:latest AS build

RUN apt-get update && apt-get install -y openjdk-21-jdk maven

# Defina o diretório de trabalho no contêiner
WORKDIR /app

# Copie o arquivo pom.xml e as dependências primeiro para o cache
COPY teste/codigo/roteiro01/roteiro01/pom.xml /app/

# Baixe as dependências do Maven
RUN mvn dependency:go-offline

# Copie todo o código fonte para o diretório de trabalho
COPY teste/codigo/roteiro01/roteiro01 /app

# Execute o comando de build do Maven
RUN mvn clean install -DskipTests

FROM openjdk:21-jdk-slim

EXPOSE 8080

# Copie o JAR do build anterior
COPY --from=build /app/target/roteiro01-0.0.1-SNAPSHOT.jar /app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]
