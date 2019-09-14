#! /usr/bin/env bash

# Your docker id or a random identifier, this is used to namespace your local images.
DOCKER_ID=windinglines19

CROSS=$( dirname "${BASH_SOURCE[0]}" )
if [ ! -f $CROSS/env.sh ] ; then
  echo Copy $CROSS/env-sample.sh as $CROSS/env.sh and edit accordingly
  exit 7
fi
source $CROSS/env.sh

# The version of rust we want to use
# RUST_VERSION=1.36.1
# DOCKER_IMAGE=ragnaroek/rust-raspberry:$RUST_VERSION

DOCKER_IMAGE=$DOCKER_ID/im-$PROJECT

# Check to see if we have built our own image
docker image inspect $DOCKER_IMAGE > /dev/null

if [ $? -eq 1 ] ; then
	docker build -t $DOCKER_IMAGE $CROSS
fi



# Registry
CARGO=$HOME/.cargo/registry

#####
# Setup dependencies
# https://github.com/Ragnaroek/rust-on-raspberry-docker#platform-dependencies-optional
###
DEPS=`pwd`/rpi-deps

[ -d $DEPS ] || mkdir $DEPS

CROSS_ARCH=armhf
# The following is for armv8, not tested.
# CROSS_ARCH=arm64

OPENSSL="openssl_1.1.1c-1_$CROSS_ARCH.deb libssl-dev_1.1.1c-1_$CROSS_ARCH.deb"
for i in $OPENSSL ; do
  if [ ! -f $DEPS/$i ] ; then
    curl -o $DEPS/$i http://ftp.debian.org/debian/pool/main/o/openssl/$i
  fi
done

LIBCURL=libcurl4-openssl-dev_7.64.0-4_$CROSS_ARCH.deb
if [ ! -f $DEPS/$LIBCURL ] ; then
  curl -o $DEPS/$LIBCURL http://ftp.debian.org/debian/pool/main/c/curl/$LIBCURL
fi

# Note: this is not enabled right now.
# https://github.com/pytorch/pytorch/issues/13130#issuecomment-438921174
###
### if [ ! -f $DEPS/libtorch.native.zip ] ; then
###   curl -o $DEPS/libtorch.native.zip https://download.pytorch.org/libtorch/cpu/libtorch-shared-with-deps-1.2.0.zip
### fi

#####
# Pull and build
####

# docker pull $DOCKER_IMAGE

# Use a container name and manage them to reduce proliferation of exited containers.
CONTAINER_NAME="rpi-$PROJECT"

if [ ".$1" = ".run"  ] ; then
  docker run -it --entrypoint /bin/bash \
    --volume $PROJECT_DIR:/home/cross/project \
    --volume $CARGO:/home/cross/.cargo/registry \
    --volume $DEPS:/home/cross/deb-deps \
    $DOCKER_IMAGE
else
  # Check to see if the container exists and restart.
  # You need to delete the container to recreate its image.

  if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ] ; then
    docker start -ai $CONTAINER_NAME
  else
    docker run --name $CONTAINER_NAME \
      --volume $PROJECT_DIR:/home/cross/project \
      --volume $CARGO:/home/cross/.cargo/registry \
      --volume $DEPS:/home/cross/deb-deps \
      $DOCKER_IMAGE \
      build --release
  fi
fi

