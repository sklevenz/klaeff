#!/usr/bin/env bash

VERSION="0"
DRAFT=""

while getopts v:dp option
do
	case "${option}"
		in
		v) VERSION="$OPTARG" ;;
		d) DRAFT="true" ;;
	esac
done

# usage
if [ $VERSION == "0" ]; then
	echo "Usage: $0 -v <version> [-dev]"
	echo "  -d : dev release"
	exit 1
fi