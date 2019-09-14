#! /bin/bash

if [ ! -f env.sh ] ; then
	echo Create a file env.sh with RPI=ip_address
	exit 1
fi

source env.sh

# Run it
export RUST_BACKTRACE=1
ssh $RPI -C " cd ./tmp/rubus; ./rubus capture; ls -l  "
