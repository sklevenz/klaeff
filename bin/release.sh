#!/usr/bin/env bash

usage() {
	echo "Usage: $0 <version>"
	exit 1
}

if [ "$1" == "" ]; then
	usage
fi

rm -rf gen
mkdir gen
rm -rf klaeff-service/gen
mkdir klaeff-service/gen

VERSION="$1"
MESSAGE=$(printf "Release of version %s" $VERSION)
BRANCH="main"
REPO_REMOTE=$(git config --get remote.origin.url)
REPO_NAME=$(basename -s .git $REPO_REMOTE)

check if repository is clean
if [[ ! -z $(git status -s) ]]; then
	echo "LOG: $(date) -- Error: repository is dirty"
	exit 1
fi

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
  GOOS=linux GOARCH=arm64 go build -o "gen/klaeff-service-arm64-linux-$VERSION" -ldflags="$LDFLAGS" ./...
popd

echo "LOG: $(date) -- ============================================================"
echo "LOG: $(date) -- create github release"
API_JSON=$(printf '{"tag_name": "%s","target_commitish": "%s","name": "%s","body": "%s","draft": %s,"prerelease": %s}' "$VERSION" "$BRANCH" "$VERSION" "$MESSAGE" "falseT" "false" )
echo "LOG: $(date) -- api-json: $API_JSON"
RESPONSE=$(curl -s --data "$API_JSON" -H "Authorization: token $GITHUB_COM_TOKEN" https://api.github.com/repos/$GITHUB_COM_USER/$REPO_NAME/releases)

ID=$(echo $RESPONSE | jq -r '.id')
echo "LOG: $(date) -- Release id: $ID"

echo "LOG: $(date) -- ============================================================"
echo "LOG: $(date) -- upload binaries"

RESPONSE=$(curl --data-binary "@./klaeff-service/gen/klaeff-service-arm64-linux-$VERSION" -H "Content-Type: application/octet-stream" \-H "Authorization: token $GITHUB_COM_TOKEN" -s "https://uploads.github.com/repos/$GITHUB_COM_USER/$REPO_NAME/releases/$ID/assets?name=klaeff-service-arm64-linux-$VERSION")
NAME=$(echo "$RESPONSE" | jq -r .name)
echo "LOG: $(date) -- name: $NAME"

RESPONSE=$(curl --data-binary "@./klaeff-service/gen/klaeff-service-386-linux-$VERSION" -H "Content-Type: application/octet-stream" \-H "Authorization: token $GITHUB_COM_TOKEN" -s "https://uploads.github.com/repos/$GITHUB_COM_USER/$REPO_NAME/releases/$ID/assets?name=klaeff-service-386-linux-$VERSION")
NAME=$(echo "$RESPONSE" | jq -r .name)
echo "LOG: $(date) -- name: $NAME"

RESPONSE=$(curl --data-binary "@./klaeff-service/gen/klaeff-service-amd64-darwin-$VERSION" -H "Content-Type: application/octet-stream" \-H "Authorization: token $GITHUB_COM_TOKEN" -s "https://uploads.github.com/repos/$GITHUB_COM_USER/$REPO_NAME/releases/$ID/assets?name=klaeff-service-amd64-darwin-$VERSION")
NAME=$(echo "$RESPONSE" | jq -r .name)
echo "LOG: $(date) -- name: $NAME"

RESPONSE=$(curl --data-binary "@./klaeff-service/gen/klaeff-service-$VERSION.exe" -H "Content-Type: application/octet-stream" \-H "Authorization: token $GITHUB_COM_TOKEN" -s "https://uploads.github.com/repos/$GITHUB_COM_USER/$REPO_NAME/releases/$ID/assets?name=klaeff-service-$VERSION.exe")
NAME=$(echo "$RESPONSE" | jq -r .name)
echo "LOG: $(date) -- name: $NAME"

# build and push a release image
docker build --build-arg VERSION=$VERSION -t sklevenz/klaeff-service:$VERSION ./docker
docker build --build-arg VERSION=$VERSION -t sklevenz/klaeff-service:latest ./docker

docker push sklevenz/klaeff-service:$VERSION
docker push sklevenz/klaeff-service:latest