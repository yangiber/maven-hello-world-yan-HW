FROM maven:3.6.3-openjdk-14-slim AS build
RUN mkdir -p /workspace/myapp
WORKDIR /workspace/myapp
COPY myapp/pom.xml /workspace/myapp
COPY myapp /workspace/myapp
RUN mvn build-helper:parse-version versions:set -DnewVersion=\${parsedVersion.majorVersion}.\${parsedVersion.minorVersion}.\${parsedVersion.nextIncrementalVersion} versions:commit
RUN mvn -B package --file pom.xml -DskipTests

FROM openjdk:17-slim
COPY --from=build /workspace/myapp/target/*.jar app.jar
EXPOSE 6379
ENTRYPOINT ["java","-jar","app.jar"]