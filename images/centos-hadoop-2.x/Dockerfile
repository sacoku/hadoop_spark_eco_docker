FROM metabuild/centos:7.5.1804
MAINTAINER Sunghyun Kim<sacoku@gmail.com>

#USER root

ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib -Djava.library.path=$HADOOP_HOME/lib/native"
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"
ENV HADOOP_VERSION=2.7.6
ENV HADOOP_CMD=/usr/local/hadoop/bin/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HADOOP_STREAMING=$HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-$HADOOP_VERSION.jar
ENV SPARK_HOME=/usr/local/spark
ENV LD_LIBRARY_PATH=/usr/local/hadoop/lib/native/:$LD_LIBRARY_PATH
ENV HADOOP_SSH_OPTS="-p 10022"

# ADD USER ACCOUNT
RUN useradd hadoop && \
    echo game7904 | passwd hadoop --stdin

# SSH PORT CHANGED
RUN sed -i /etc/ssh/sshd_config -r -e 's/^#Port 22/Port 10022/g'

# R - JAVA INSTALL & CONFIG
RUN R CMD javareconf -e && \
    R CMD javareconf && \
    R -e "install.packages('rJava', repos='https://cran.seoul.go.kr')"

# install hadoop
RUN wget http://mirror.apache-kr.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    tar -xzvf hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION /usr/local && \
    rm hadoop-$HADOOP_VERSION.tar.gz && \
    ln -s /usr/local/hadoop-$HADOOP_VERSION /usr/local/hadoop

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/start-esys.sh ~/start-esys.sh && \
    mv /tmp/init.sh ~/init.sh

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/start-esys.sh && \
    chmod +x ~/init.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh

# MAKE NAME/DATA NODE DIRECTORY
# RUN mkdir -p /data/hdfs/namenode && \
#    mkdir -p /data/hdfs/datanode

# format namenode
# RUN /usr/local/hadoop/bin/hdfs namenode -format

RUN wget http://apache.tt.co.kr/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz && \
    tar -xvzf spark-2.2.1-bin-hadoop2.7.tgz && \
    mv spark-2.2.1-bin-hadoop2.7 /usr/local && \
    rm spark-2.2.1-bin-hadoop2.7.tgz && \
    ln -s /usr/local/spark-2.2.1-bin-hadoop2.7 /usr/local/spark

RUN mv /usr/local/spark/conf/log4j.properties.template /usr/local/spark/conf/log4j.properties && \
    mv /tmp/spark-defaults.conf $SPARK_HOME/conf && \
    mv /usr/local/spark/conf/spark-env.sh.template /usr/local/spark/conf/spark-env.sh

RUN wget https://archive.apache.org/dist/zeppelin/zeppelin-0.7.3/zeppelin-0.7.3-bin-all.tgz && \
    tar -xzvf zeppelin-0.7.3-bin-all.tgz && \
    mv zeppelin-0.7.3-bin-all /usr/local && \
    rm zeppelin-0.7.3-bin-all.tgz && \
    ln -s /usr/local/zeppelin-0.7.3-bin-all /usr/local/zeppelin

RUN mv /tmp/zeppelin-env.sh /usr/local/zeppelin/conf && \
    mv /tmp/zeppelin-site.xml /usr/local/zeppelin/conf

RUN pip install py4j && \
    pip install  matplotlib

COPY pkg/* /root/

RUN R -e "install.packages('/root/rmr2_3.3.1.tar.gz')" && \
    R -e "install.packages('/root/plyrmr_0.6.0.tar.gz')" && \
    R -e "install.packages('/root/rhdfs_1.0.8.tar.gz')" && \
    rm -f /root/plyrmr_0.6.0.tar.gz && \
    rm -f /root/rhdfs_1.0.8.tar.gz && \
    rm -f /root/rmr2_3.3.1.tar.gz

RUN R -e "install.packages('sparklyr', repos='https://cran.seoul.go.kr')"

RUN wget https://cran.r-project.org/src/contrib/RCassandra_0.1-3.tar.gz && \
    R -e "install.packages('RCassandra_0.1-3.tar.gz')" && \
    rm -f RCassandra_0.1-3.tar.gz

CMD [ "sh", "-c", "/sbin/sshd; ~/start-esys.sh; bash" ]

# Hdfs ports
# EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
# EXPOSE 10020 19888
#Yarn ports
# EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
# EXPOSE 49707 2122
