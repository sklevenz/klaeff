FROM ubuntu:latest

ARG VERSION=$VERSION

WORKDIR /usr/local/bin

RUN echo "version=$VERSION"

RUN apt-get -y update; apt-get -y install wget
RUN wget https://github.com/sklevenz/klaeff/releases/download/$VERSION/klaeff-service-arm64-linux-$VERSION 
RUN chmod +x ./klaeff-service-arm64-linux-$VERSION
RUN ln ./klaeff-service-arm64-linux-$VERSION klaeff-service

CMD ["app"]