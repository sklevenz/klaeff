#!/usr/bin/env bash

REPO_REMOTE=$(git config --get remote.origin.url)
REPO_NAME=$(basename -s .git $REPO_REMOTE)
REPO_OWNER=$GITHUB_COM_USER

JSON_RESPONSE=$(curl -H "Authorization: token $GITHUB_COM_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/tags/$1)

ID=$(echo "$JSON_RESPONSE" | jq .id)

echo "JSON_RESPONSE=$JSON_RESPONSE"
echo "ID=$ID"

git fetch --tags
git tag -d "$1"
git push --delete origin "$1"
git fetch --tags

curl -is -L \
  -H "Authorization: Bearer $GITHUB_COM_TOKEN"\
  https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/$ID