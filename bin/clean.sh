#!/usr/bin/env bash

rm -rf gen
mkdir gen

pushd klaeff-service
  rm -rf gen
  mkdir gen

  go mod tidy
  go fmt ./...
  go vet ./...
  go clean
popd