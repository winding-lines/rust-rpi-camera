#! /usr/bin/env bash

PROJECT=cameru
RPI=pi@your_rpi_IP

if [ -z $BASH ] ; then
  echo Please run with bash
  exit 8
fi

# Location of the rust code
CROSS=$( dirname "${BASH_SOURCE[0]}" )
PROJECT_DIR=$(dirname "$CROSS")/$PROJECT
PROJECT_DIR=$(cd $PROJECT_DIR ; pwd)

if [ ! -f $PROJECT_DIR/Cargo.toml ] ; then
  echo Cannot find a cargo project under $PROJECT_DIR
  exit 7
fi



