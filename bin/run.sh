#!/usr/bin/env bash

DOCKER=0

usage() {	
  echo "usage: $0 [-d] [-h]"
  exit 1;
  }

while getopts :dh option
do
	case "${option}"
		in
    d) DOCKER=1 ;;
    h) usage ;;
	esac
done

if [ "$DOCKER" -eq "1" ]; then
  echo "LOG: $(date) -- Run as docker container ..."
  docker build -t klaeff-service ./docker
  docker run -p 8080:8080 -it klaeff-service
else
  echo"LOG: $(date) -- Run as go programm ..."
  pushd klaeff-service
    go run klaeff.go
  popd
fi