#!/bin/bash
set -x
set -e

# pre build
docker pull cargo.caicloud.io/caicloud/golang
docker tag cargo.caicloud.io/caicloud/golang golang

# git clone https://github.com/zoumo/go_test.git $PWD/go_test
docker run --rm -v $PWD:/go/src/github.com/zoumo/go_test -w /go/src/github.com/zoumo/go_test golang sh build.sh

# build
docker build -t integration $PWD

# integration
docker run --rm integration

# publish

# docker rmi cargo.caicloud.io/caicloud/golang
# docker rmi golang

echo done

