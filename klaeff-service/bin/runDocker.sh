#!/usr/bin/env bash

docker build -t klaeff-service .
docker run -p 8080:8080 -it klaeff-service