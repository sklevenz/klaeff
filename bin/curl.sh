#!/usr/bin/env bash

HOST="localhost"
PORT="8080"
ENDPOINT=""

while getopts vh:p:e: option
do
	case "${option}"
		in
        h) HOST="$OPTARG" ;;
        p) PORT="$OPTARG" ;;
		e) ENDPOINT="$OPTARG" ;;
		v) ENDPOINT="version" ;;
	esac
done

echo "LOG: $(date) -- http://$HOST:$PORT/$ENDPOINT"
curl -isS http://$HOST:$PORT/$ENDPOINT

