FROM node:12-alpine
ENV WORKDIR /usr/src/app/
WORKDIR $WORKDIR
COPY package*.json $WORKDIR
RUN npm install --production --no-cache

LABEL example="example"

FROM node:12-alpine
ENV USER node
ENV WORKDIR /home/$USER/app
WORKDIR $WORKDIR
COPY --from=0 /usr/src/app/node_modules node_modules
RUN chown $USER:$USER $WORKDIR
COPY --chown=node . $WORKDIR
# In production environment uncomment the next line
#RUN chown -R $USER:$USER /home/$USER && chmod -R g-s,o-rx /home/$USER && chmod -R o-wrx $WORKDIR
# Then all further actions including running the containers should be done under non-root user.
USER $USER
EXPOSE 4000
#######jacksonbind test
# Use a base Java image
FROM openjdk:8-jdk-alpine

# Set the working directory
WORKDIR /app

# Download Jackson Databind JAR
ADD https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.4.0/jackson-databind-2.4.0.jar /app/

# Set the classpath
ENV CLASSPATH=/app/jackson-databind-2.4.0.jar:$CLASSPATH

# Optionally, copy your Java application (e.g., Main.java)
COPY Main.java /app/

# Compile your Java application
RUN javac Main.java

# Define the entry point
CMD ["java", "Main"]
