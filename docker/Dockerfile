FROM ubuntu:latest

WORKDIR /usr/src/app

COPY . . 

RUN apt-get -y update; apt-get -y install curl
RUN curl -Li https://github.com/sklevenz/klaeff/releases/download/0.0.0/klaeff-service-arm64-linux-0.0.0 > klaeff-service-arm64-linux-0.0.0
RUN chmod +x ./klaeff-service-arm64-linux-0.0.0
# RUN ./klaeff-service-arm64-linux-0.0.0
RUN ls -al
RUN echo "VERSION=$VERSION"

CMD ["app"]