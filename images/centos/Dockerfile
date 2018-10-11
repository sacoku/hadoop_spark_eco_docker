FROM centos:7.5.1804
MAINTAINER Sunghyun Kim<sacoku@gmail.com>

RUN yum install -y wget java-1.8.0-openjdk curl openssh rsync openssh-server which bash net-tools git python-devel

RUN yum install -y epel-release
RUN yum install -y R
RUN wget https://download2.rstudio.org/rstudio-server-rhel-1.1.453-x86_64.rpm && \
    yum install -y rstudio-server-rhel-1.1.453-x86_64.rpm && \
    rm rstudio-server-rhel-1.1.453-x86_64.rpm

RUN yum install -y python-pip
RUN pip install --upgrade pip

RUN R -e "install.packages(c('Rcpp','RJSONIO','digest','functional','reshape2','stringr','plyr','caTools'), repos='https://cran.seoul.go.kr')" && \
    R -e "install.packages(c('dplyr','R.methodsS3','Hmisc','memoise','lazyeval','rjson'), repos='https://cran.seoul.go.kr')"

# set ssh-server configuration
RUN \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -A

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.171-8.b10.el7_5.x86_64/jre
ENV PATH $JAVA_HOME/bin:$PATH
