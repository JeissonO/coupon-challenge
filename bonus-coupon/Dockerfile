FROM openjdk:11.0.9.1-jre-buster
RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/America/Bogota /etc/localtime && echo "America/Bogota" > /etc/timezone
COPY target/bonus-coupon-0.0.1-SNAPSHOT.jar app.jar
ENV API_ENDPOINT=${API_ENDPOINT}
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]

# Create the docker image
# docker build -t coupon .
# Run the container
# docker run -d -p 8080:8080 --name coupon -e API_ENDPOINT=$API_ENDPOINT coupon:latest
# docker run -it -p 8080:8080 --name coupon -e API_ENDPOINT=$API_ENDPOINT coupon:latest