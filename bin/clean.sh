#!/usr/bin/env bash

pushd klaeff-service
  rm -rf gen

  go mod tidy
  go fmt ./...
  go vet ./...
  go clean
popd