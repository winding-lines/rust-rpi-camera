#! /usr/bin/env bash

set -e
CROSS=$( dirname "${BASH_SOURCE[0]}" )
source $CROSS/env.sh

# Copy the file
ssh $RPI -C " mkdir -p tmp/$PROJECT "
scp $PROJECT_DIR/target/arm-unknown-linux-gnueabihf/release/$PROJECT $RPI:tmp/$PROJECT/.

