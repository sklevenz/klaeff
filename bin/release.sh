#!/usr/bin/env bash

set +x

MESSAGE="0"
VERSION="0"
DRAFT="0"
PRE="0"
BRANCH="main"
REPO_OWNER=$GITHUB_COM_USER
GITHUB_ACCESS_TOKEN=$GITHUB_COM_TOKEN
REPO_REMOTE=$(git config --get remote.origin.url)
REPO_NAME=$(basename -s .git $REPO_REMOTE)
MESSAGE=$(printf "Release of version %s" $VERSION)

while getopts v:dp option
do
	case "${option}"
		in
		v) VERSION="$OPTARG" ;;
		d) DRAFT="1" ;;
		p) PRE="1" ;;
	esac
done

# usage
if [ $VERSION == "0" ]; then
	echo "Usage: $0 -v <version> [-draft] [-pre]"
	echo "  -d : draft release"
	echo "  -p : pre release"
	exit 1
fi

# check if repository is clean
if [[ ! -z $(git status -s) ]]; then
	echo "Error: repository is dirty"
	exit 1
fi

API_JSON=$(printf '{"tag_name": "v%s","target_commitish": "%s","name": "v%s","body": "%s","draft": %s,"prerelease": %s}' "$VERSION" "$BRANCH" "$VERSION" "$MESSAGE" "$DRAFT" "$PRE" )

echo api_json="$API_JSON"

API_RESPONSE_STATUS=$(curl --data "$API_JSON" -H "Authorization: token $GITHUB_ACCESS_TOKEN" -s -i https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases)
echo "$API_RESPONSE_STATUS"
