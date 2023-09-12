FROM maven:3.6.3-openjdk-14-slim AS build
RUN mkdir -p /workspace/myapp
WORKDIR /workspace/myapp
COPY myapp/pom.xml /workspace/myapp
COPY myapp /workspace/myapp
RUN mvn -B package --file myapp/pom.xml -DskipTests

FROM openjdk:17-slim
COPY --from=build /workspace/myapp/target/myapp-1.0.0.jar app.jar
EXPOSE 6379
ENTRYPOINT ["java","-jar","app.jar"]