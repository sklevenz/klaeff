#!/usr/bin/env bash

DOCKER=0

usage() {	
  echo "usage: $0 [-d] [-h] [-l]"
  exit 1;
  }

while getopts :dhl option
do
	case "${option}"
		in
    l) DOCKER=2 ;;
    d) DOCKER=1 ;;
    h) usage ;;
	esac
done

if [ "$DOCKER" == "1" ]; then
  echo "LOG: $(date) -- Run as docker container ..."
  docker build -t klaeff-service-runner ./klaeff-service
  docker run --rm -p 8080:8080 -it klaeff-service-runner
elif [ "$DOCKER" == "2" ]; then
  docker run --rm -p 8080:8080 -it sklevenz/klaeff-service:latest klaeff-service
else
  echo "LOG: $(date) -- Run as go programm ..."
  pushd klaeff-service
    go run klaeff.go
  popd
fi