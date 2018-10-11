FROM metabuild/alpine
MAINTAINER Sunghyun Kim<sacoku@gmail.com>

USER root

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
ENV HADOOP_STREAMING=/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-$HADOOP_VERSION.jar
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV LD_LIBRARY_PATH=/usr/local/hadoop/lib/native/:$LD_LIBRARY_PATH
ENV HADOOP_SSH_OPTS="-p 10022"

# SSH PORT CHANGED
RUN sed -i /etc/ssh/sshd_config -r -e 's/^#Port 22/Port 10022/g'

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
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/init.sh ~/init.sh

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/init.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh

# MAKE NAME/DATA NODE DIRECTORY
# RUN mkdir -p /data/hdfs/namenode && \
#    mkdir -p /data/hdfs/datanode

# format namenode
#RUN /usr/local/hadoop/bin/hdfs namenode -format

RUN apk --update add freetype-dev && \
    pip install py4j && \
    pip install matplotlib

COPY pkg/* /root/

RUN R -e "install.packages('/root/rmr2_3.3.1.tar.gz')" && \
    R -e "install.packages('/root/plyrmr_0.6.0.tar.gz')" && \
    R -e "install.packages('/root/rhdfs_1.0.8.tar.gz')" && \
    rm -f /root/plyrmr_0.6.0.tar.gz && \
    rm -f /root/rhdfs_1.0.8.tar.gz && \
    rm -f /root/rmr2_3.3.1.tar.gz

RUN R -e "install.packages('sparklyr', repos='https://cran.seoul.go.kr')"

CMD [ "sh", "-c", "/usr/sbin/sshd; bash"]
