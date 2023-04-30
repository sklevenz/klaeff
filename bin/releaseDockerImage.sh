#!/usr/bin/env bash

VERSION="0"
DRAFT=""

while getopts v:dp option
do
	case "${option}"
		in
		v) VERSION="$OPTARG" ;;
	esac
done

# usage
if [ $VERSION == "0" ]; then
	echo "Usage: $0 -v <version> [-dev]"
	exit 1
fi

# build and push a release image
docker build --build-arg VERSION=$VERSION -t sklevenz/klaeff-service:$VERSION ./docker
docker build --build-arg VERSION=$VERSION -t sklevenz/klaeff-service:latest ./docker

docker push sklevenz/klaeff-service:$VERSION
docker push sklevenz/klaeff-service:latest