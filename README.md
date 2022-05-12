# Project docker-clang-format

[![Docker](https://badgen.net/badge/icon/docker?icon=docker&label)](https://https://docker.com/)
![GitHub](https://img.shields.io/github/license/tiagosarmentosantos/docker-clang-format)

[![Continuous Integration](https://github.com/tiagosarmentosantos/docker-clang-format/actions/workflows/continuous_integration.yml/badge.svg?branch=main)](https://github.com/tiagosarmentosantos/docker-clang-format/actions/workflows/continuous_integration.yml)
![Release Date](https://img.shields.io/github/release-date/tiagosarmento/docker-clang-format)
![Release Version](https://img.shields.io/github/release-date/tiagosarmento/docker-clang-format)

This container wraps the latest version of clang-format tool, and its intended to be used across multiple systems.
See clang-format documentation [here](https://clang.llvm.org/docs/ClangFormatStyleOptions.html)

## Get the docker container
The docker container is available in github container registry, it can be obtained as follows:
* Pull image from the command line:
```shell
$ docker pull ghcr.io/tiagosarmentosantos/docker-clang-format:<version>
```
* Use as base image in a Dockerfile:
```shell
FROM ghcr.io/tiagosarmentosantos/docker-clang-format:<version>
```

## Development notes for docker clang-format

To build container do:
```shell
$ docker build . --file Dockerfile --no-cache --tag ghcr.io/tiagosarmentosantos/docker-clang-format:<version>
```

To run container do:
```shell
# To run container in attached mode:
$ docker run --rm -it -v ${PWD}:/workdir --workdir /workdir --user "$(id -u):$(id -g)" --entrypoint /bin/sh ghcr.io/tiagosarmentosantos/docker-clang-format:<version>

# To run container in detached mode:
$ docker run --rm -v ${PWD}:/workdir --workdir /workdir ghcr.io/tiagosarmentosantos/docker-clang-format:<version> <clang-format options>
```

Practical examples:
```shell
# Get clang-format version
$ docker run --rm -v ${PWD}:/workdir --workdir /workdir ghcr.io/tiagosarmentosantos/docker-clang-format:1.0.0 --version

# Dump clang-format help
$ docker run --rm -v ${PWD}:/workdir --workdir /workdir ghcr.io/tiagosarmentosantos/docker-clang-format:1.0.0 --help

# This command would format file.c in place, taking as configuration input a .clang-format file
$ docker run --rm -v ${PWD}:/workdir --workdir /workdir ghcr.io/tiagosarmentosantos/docker-clang-format:1.0.0 -i -style=file --verbose file.c
```


