FROM openjdk:11.0.9.1-jre-buster
RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/America/Bogota /etc/localtime && echo "America/Bogota" > /etc/timezone
COPY target/bonus-coupon-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]