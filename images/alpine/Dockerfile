FROM alpine
MAINTAINER Sunghyun Kim<sacoku@gmail.com>

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server

RUN apk --update add bash git wget ca-certificates sudo openssh rsync openjdk8 R python py-pip python-dev && \
  rm -rf /var/cache/apk/* && \
  rm -rf /opt  && \
  mkdir -p /opt 

RUN apk --update add gcc g++ automake automake libtool m4 R-dev && \
  rm -rf /var/cache/apk/*

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

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $JAVA_HOME/bin:$PATH
