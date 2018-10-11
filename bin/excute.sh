#!/bin/sh

# the default node number is 2
N=${1:-3}


# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 4040-4045:4040-4045 \
                -p 8020:8020 \
                -p 8030-8035:8030-8035 \
                -p 8088:8088 \
                -p 8787:8787 \
                -p 8888:8888 \
                -p 9000-9001:9000-9001 \
                -p 9980-9985-9980-9985 \
                -p 10020:10020 \
                -p 14000:14000 \
                -p 50070-50075:50070-50075 \
                -p 50090:50090 \
                --name hadoop-master \
                --hostname hadoop-master \
                metabuild/centos-hadoop:2.x &> /dev/null

SSH_KEY=`docker exec hadoop-master cat /root/.ssh/authorized_keys`

# start hadoop slave container
i=1
while [ $i -lt $((N+1)) ]
do
        sudo docker rm -f hadoop-slave$i &> /dev/null
        echo "start hadoop-slave$i container..."
        sudo docker run -itd \
                        --net=hadoop \
                        --name hadoop-slave$i \
                        --hostname hadoop-slave$i \
                        metabuild/alpine-hadoop:2.x &> /dev/null
        docker exec hadoop-slave$i bash -c "echo '$SSH_KEY' >> /root/.ssh/authorized_keys"
        i=$(( $i + 1 ))
done

# get into hadoop master container
sudo docker exec -it hadoop-master bash

