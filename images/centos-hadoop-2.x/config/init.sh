#!/bin/sh

mkdir -p /data/hdfs/namenode
mkdir -p /data/hdfs/datanode

$HADOOP_HOME/bin/hdfs namenode -format
echo /tmp/host >> /etc/hosts
