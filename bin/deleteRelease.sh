#!/usr/bin/env bash

REPO_REMOTE=$(git config --get remote.origin.url)
REPO_NAME=$(basename -s .git $REPO_REMOTE)
REPO_OWNER=$GITHUB_COM_USER

JSON_RESPONSE=$(curl -H "Authorization: token $GITHUB_COM_TOKEN" -H "Accept: application/vnd.github+json" -s https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/tags/$1)

ID=$(echo "$JSON_RESPONSE" | jq -r .id)
echo "LOG: $(date) -- Release id: $ID"

git fetch --tags
git tag -d "$1"
git push --delete origin "$1"
git fetch --tags

RESPONSE=$(curl -s -H "Authorization: Bearer $GITHUB_COM_TOKEN" "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/$ID")

ASSET1_URL=$(echo "$RESPONSE" | jq -r .assets[0].url)
ASSET2_URL=$(echo "$RESPONSE" | jq -r .assets[1].url)
ASSET3_URL=$(echo "$RESPONSE" | jq -r .assets[2].url)
ASSET4_URL=$(echo "$RESPONSE" | jq -r .assets[3].url)

RESPONSE2=$(curl -s -H "Authorization: Bearer $GITHUB_COM_TOKEN" -X DELETE $ASSET1_URL)
echo "LOG: $(date) -- ASSET1_URL=$ASSET1_URL"
RESPONSE2=$(curl -s -H "Authorization: Bearer $GITHUB_COM_TOKEN" -X DELETE $ASSET2_URL)
echo "LOG: $(date) -- ASSET2_URL=$ASSET2_URL"
RESPONSE2=$(curl -s -H "Authorization: Bearer $GITHUB_COM_TOKEN" -X DELETE $ASSET3_URL)
echo "LOG: $(date) -- ASSET3_URL=$ASSET3_URL"
RESPONSE2=$(curl -s -H "Authorization: Bearer $GITHUB_COM_TOKEN" -X DELETE $ASSET4_URL)
echo "LOG: $(date) -- ASSET4_URL=$ASSET4_URL"
