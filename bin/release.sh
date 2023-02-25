#!/usr/bin/env bash

MESSAGE="0"
VERSION="0"
DRAFT="false"
PRE="false"
BRANCH="main"
GITHUB_ACCESS_TOKEN=$GITHUB_COM_TOKEN
REPO_OWNER=$GITHUB_COM_USER

# get repon name and owner
REPO_REMOTE=$(git config --get remote.origin.url)

if [ -z $REPO_REMOTE ]; then
	echo "Not a git repository"
	exit 1
fi

REPO_NAME=$(basename -s .git $REPO_REMOTE)

# get args
while getopts v:m:b:draft:pre: option
do
  echo option=$option, OPTARG=$OPTARG
	case "${option}"
		in
		v) VERSION="$OPTARG" ;;
		m) MESSAGE="$OPTARG" ;;
		b) BRANCH="$OPTARG" ;;
		d) DRAFT="true" echo D;;
		p) PRE="true" echo P;;
	esac
done
if [ $VERSION == "0" ]; then
	echo "Usage: git-release -v <version> [-b <branch>] [-m <message>] [-draft] [-pre]"
	# exit 1
fi
echo VERSION=$VERSION
echo MESSAGE=$MESSAGE
echo BRANCH=$BRANCH
echo DRAFT=$DRAFT
echo PRE=$PRE

# set default message
if [ "$MESSAGE" == "0" ]; then
	MESSAGE=$(printf "Release of version %s" $VERSION)
fi

API_JSON=$(printf '{"tag_name": "v%s","target_commitish": "%s","name": "v%s","body": "%s","draft": %s,"prerelease": %s}' "$VERSION" "$BRANCH" "$VERSION" "$MESSAGE" "$DRAFT" "$PRE" )

echo api_json="$API_JSON"

# API_RESPONSE_STATUS=$(curl --data "$API_JSON" -H "Authorization: token $GITHUB_ACCESS_TOKEN" -s -i https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases)
echo "$API_RESPONSE_STATUS"
