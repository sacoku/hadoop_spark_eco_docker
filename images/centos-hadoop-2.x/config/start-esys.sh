#!/bin/sh

/sbin/sshd; /lib/rstudio-server/bin/rserver
/usr/local/zeppelin/bin/zeppelin-daemon.sh start

