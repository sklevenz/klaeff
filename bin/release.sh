#!/usr/bin/env bash

set +x

MESSAGE="0"
VERSION="0"
DRAFT="false"
PRE="false"
BRANCH="main"
REPO_REMOTE=$(git config --get remote.origin.url)
REPO_NAME=$(basename -s .git $REPO_REMOTE)

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

check if repository is clean
if [[ ! -z $(git status -s) ]]; then
	echo "Error: repository is dirty"
	exit 1
fi

MESSAGE=$(printf "Release of version %s" $VERSION)
echo "LOG: $(date) -- $MESSAGE"

echo "LOG: $(date) -- tag repository: $VERSION"
# tag repository
git tag -a "$VERSION" -m "$MESSAGE"
git push --tags

# build binaries
echo "LOG: $(date) -- build binaries"
LDFLAGS="-X main.version=$VERSION"
pushd klaeff-service
  GOOS=windows GOARCH=amd64 go build -o "gen/klaeff-service-$VERSION.exe" -ldflags="$LDFLAGS" ./...
  GOOS=darwin GOARCH=amd64 go build -o "gen/klaeff-service-amd64-darwin-$VERSION" -ldflags="$LDFLAGS"  ./...
  GOOS=linux GOARCH=386 go build -o "gen/klaeff-service-386-linux-$VERSION" -ldflags="$LDFLAGS" ./...
  GOOS=linux GOARCH=amd64 go build -o "gen/klaeff-service-amd64-linux-$VERSION" -ldflags="$LDFLAGS" ./...
popd

echo "LOG: $(date) -- ============================================================"
echo "LOG: $(date) -- create github release"
API_JSON=$(printf '{"tag_name": "%s","target_commitish": "%s","name": "%s","body": "%s","draft": %s,"prerelease": %s}' "$VERSION" "$BRANCH" "$VERSION" "$MESSAGE" "$DRAFT" "$PRE" )
echo "LOG: $(date) -- $API_JSON"
RESPONSE=$(curl --data "$API_JSON" -H "Authorization: token $GITHUB_COM_TOKEN" https://api.github.com/repos/$GITHUB_COM_USER/$REPO_NAME/releases)
echo "LOG: $(date) -- $RESPONSE"

ID=$(echo $RESPONSE | jq '.id')
echo "LOG: $(date) -- $ID"

echo "LOG: $(date) -- ============================================================"
echo "LOG: $(date) -- upload binaries"

RESPONSE=$(curl --data-binary "@./klaeff-service/gen/klaeff-service-amd64-linux-$VERSION" -H "Content-Type: application/octet-stream" \-H "Authorization: token $GITHUB_COM_TOKEN" -s -i "https://uploads.github.com/repos/$GITHUB_COM_USER/$REPO_NAME/releases/$ID/assets?name=klaeff-service-amd64-linux-$VERSION")
RESPONSE=$(curl --data-binary "@./klaeff-service/gen/klaeff-service-386-linux-$VERSION" -H "Content-Type: application/octet-stream" \-H "Authorization: token $GITHUB_COM_TOKEN" -s -i "https://uploads.github.com/repos/$GITHUB_COM_USER/$REPO_NAME/releases/$ID/assets?name=klaeff-service-386-linux-$VERSION")
RESPONSE=$(curl --data-binary "@./klaeff-service/gen/klaeff-service-amd64-darwin-$VERSION" -H "Content-Type: application/octet-stream" \-H "Authorization: token $GITHUB_COM_TOKEN" -s -i "https://uploads.github.com/repos/$GITHUB_COM_USER/$REPO_NAME/releases/$ID/assets?name=klaeff-service-amd64-darwin-$VERSION")
RESPONSE=$(curl --data-binary "@./klaeff-service/gen/klaeff-service-$VERSION.exe" -H "Content-Type: application/octet-stream" \-H "Authorization: token $GITHUB_COM_TOKEN" -s -i "https://uploads.github.com/repos/$GITHUB_COM_USER/$REPO_NAME/releases/$ID/assets?name=klaeff-service-$VERSION.exe")
