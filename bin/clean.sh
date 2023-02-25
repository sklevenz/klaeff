#!/usr/bin/env bash

pushd klaeff-service
  go mod tidy
  go fmt ./...
  go vet ./...
popd