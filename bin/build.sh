#!/usr/bin/env bash

VERSION="0.0.0-dev"

LDFLAGS="-X main.version=$VERSION"

echo "LOG: $(date) -- ldflags: $LDFLAGS"

pushd klaeff-service
  go build -o gen/klaeff-service -ldflags="$LDFLAGS" ./...
popd