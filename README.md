[![Deploy to GitHub Pages](https://github.com/sklevenz/klaeff/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/sklevenz/klaeff/actions/workflows/build-and-test.yml)

# klaeff

This repository is just for fun. It creates a Go program that exposes some simple REST APIs. All around there is support for Docker, Kubernetes, versioning on Github, etc.

## Commands

| **COMMAND**                 | **DESCRIPTION**                                                                            |
|-----------------------------|--------------------------------------------------------------------------------------------|
| ./bin/build.sh              | Builds the go program.                                                                      |
| ./bin/clean.sh              | Deletes and re-creates gen directories, calls mod tidy, fmt, vet and clean for go program. |
| ./bin/createCluster.sh      | Creates a K8S kind cluster.                                                                |
| ./bin/curl.sh               | Simplified curl to call klaeff-service. Host, port and endpoints has some defaults.        |
| ./bin/currentVesion.sh      | Determines the latest release version from github.                                         |
| ./bin/deleteCluster.sh      | Deletes the K8S kind cluster.                                                              |
| ./bin/deleteRelease.sh      | Deletes a released version from github.                                                    |
| ./bin/release.sh            | Releases a new version on github.                                                          |
| ./bin/releaseDockerImage.sh | Releases a new docker image and uploads it to docker hub.                                  |
| ./bin/run.sh                | Run the go program.                                                                        |
| ./bin/test.sh               | Test the go program.                                                                       |

