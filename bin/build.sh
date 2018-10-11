#!/bin/sh

HOME_DIR=/root/EcoSystem

function help()
{
	echo "build.sh [master | slave]"
    exit 4
}

case $1 in
  "slave")
    echo "create slave images..."
    docker build -t metabuild/alpine                                \
                              $HOME_DIR/images/alpine            && \
    docker build -t metabuild/alpine-hadoop:2.x                     \
                              $HOME_DIR/images/alpine-hadoop-2.x
    ;;
  "master")
    echo "create master images..."
    docker build -t metabuild/centos:7.5.1804                       \
                              $HOME_DIR/images/centos            && \
    docker build -t metabuild/centos-hadoop:2.x                     \
                              $HOME_DIR/images/centos-hadoop-2.x 
    ;;
  *)
	 help
     ;;
esac
