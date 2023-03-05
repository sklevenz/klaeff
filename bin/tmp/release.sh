#!/usr/bin/env bash

set +x

MESSAGE="0"
VERSION="0"
DRAFT="false"
PRE="false"
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
		d) DRAFT="true" ;;
		p) PRE="true" ;;
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

# tag repository
git tag -a "v$VERSION" -m "$MESSAGE"
git push --tags

# build binaries
LDFLAGS="-X main.version=$VERSION"
pushd klaeff-service
  GOOS=windows GOARCH=amd64 go build -o gen/klaeff-service.exe -ldflags="$LDFLAGS" ./...
  GOOS=darwin GOARCH=amd64 go build -o "gen/klaeff-service-amd64-darwin" -ldflags="$LDFLAGS"  ./...
  GOOS=linux GOARCH=386 go build -o "gen/klaeff-service-386-linux" -ldflags="$LDFLAGS" ./...
  GOOS=linux GOARCH=amd64 go build -o "gen/klaeff-service-amd64-linux" -ldflags="$LDFLAGS" ./...
popd

API_JSON=$(printf '{"tag_name": "v%s","target_commitish": "%s","name": "v%s","body": "%s","draft": %s,"prerelease": %s}' "$VERSION" "$BRANCH" "$VERSION" "$MESSAGE" "$DRAFT" "$PRE" )
echo "$API_JSON"
API_RESPONSE_STATUS=$(curl --data "$API_JSON" -H "Authorization: token $GITHUB_ACCESS_TOKEN" -s -i https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases)
echo "$API_RESPONSE_STATUS"
echo "============================================================"
set -x
API_RESPONSE_STATUS=$(curl --data-binary "@/Users/stephan/dev/github.com/sklevenz/klaeff/klaeff-service/gen/klaeff-service.zip" -H "Authorization: token $GITHUB_ACCESS_TOKEN" -s -i https://uploads.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/"v$VERSION"/assets?name=klaeff-service.zip)
echo "$API_RESPONSE_STATUS"
