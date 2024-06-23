# Use a imagem oficial do Maven para construir o projeto
FROM maven:3.8.4-openjdk-17 AS build

# Defina o diretório de trabalho no contêiner
WORKDIR /app

# Copie o arquivo pom.xml e as dependências primeiro para o cache
COPY codigo/roteiro01/roteiro01/pom.xml /app/

# Baixe as dependências do Maven
RUN mvn dependency:go-offline

# Copie todo o código fonte para o diretório de trabalho
COPY codigo/roteiro01/roteiro01 /app

# Execute o comando de build do Maven
RUN mvn clean install -DskipTests

# Use uma imagem oficial do OpenJDK para rodar a aplicação
FROM openjdk:17-jdk-slim

# Copie o JAR do build anterior
COPY --from=build /app/target/roteiro01-0.0.1-SNAPSHOT.jar /app.jar

# Defina o comando de entrada
ENTRYPOINT ["java", "-jar", "/app.jar"]
