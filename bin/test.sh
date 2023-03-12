#!/usr/bin/env bash

pushd klaeff-service
  go test ./...
  ERROR=$?
popd

exit $ERROR
