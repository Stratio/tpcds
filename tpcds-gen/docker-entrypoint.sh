#!/bin/bash -xe
 YARN_MODE=${YARN_MODE:=false}
 NAMENODE_MODE=${NAMENODE_MODE:=true}
 NAMENODE_HOST=${NAMENODE_HOST:=`hostname -f`}
 HOST="hostname -f"
 if [[ "$(hostname -f)" =~ \. ]]; then
    HOST="$(hostname -f)"
 else
    HOST="$(hostname -i)"
 fi
 /usr/sbin/sshd -e
 mkdir -p /tmp/data/hdfs
 chmod -R 775 /tmp/data/hdfs
 mkdir -p /tmp/data/hdfs/namenode
 mkdir -p /tmp/data/hdfs/datanode
 if [[ ${NAMENODE_MODE} == "true" ]]; then
     echo "<configuration> <property> <name>hadoop.tmp.dir</name> <value>/tmp</value> </property> <property> <name>fs.defaultFS</name> <value>hdfs://$HOST:9000</value> </property> </configuration>" > /opt/sds/hadoop/conf/core-site.xml
 else
     echo "<configuration> <property> <name>hadoop.tmp.dir</name> <value>/tmp</value> </property> <property> <name>fs.defaultFS</name> <value>hdfs://$NAMENODE_HOST:9000</value> </property> </configuration>" > /opt/sds/hadoop/conf/core-site.xml
 fi

 echo "<configuration> <property> <name>dfs.namenode.name.dir</name> <value>/tmp/data/hdfs/namenode</value> </property> <property> <name>dfs.datanode.name.dir</name> <value>/tmp/data/hdfs/datanode</value> </property> <property><name>dfs.permissions.enabled</name><value>false</value></property><property> <name>dfs.replication</name> <value>1</value> </property> </configuration>" > /opt/sds/hadoop/conf/hdfs-site.xml

 if [[ ${NAMENODE_MODE} == "true" ]]; then

     echo "#slave nodes" > /etc/sds/hadoop/slaves
     echo $HOST >> /etc/sds/hadoop/slaves

     nohup /opt/sds/hadoop/bin/hdfs namenode -format > /var/log/sds/hadoop-hdfs/namenode.log &
     sleep 10
     nohup /opt/sds/hadoop/sbin/hadoop-daemon.sh --config /opt/sds/hadoop/conf start namenode > /var/log/sds/hadoop-hdfs/hdfs-namenode.log &
     sleep 10
 fi

 nohup /opt/sds/hadoop/sbin/hadoop-daemon.sh --config /opt/sds/hadoop/conf start datanode > /var/log/sds/hadoop-hdfs/hdfs-datanode.log &
 sleep 10

 if [[ ${YARN_MODE} == "true" ]]; then
     echo "<configuration> <property> <name>yarn.resourcemanager.hostname</name> <value>"$HOST"</value> </property> </configuration>" > /opt/sds/hadoop/conf/yarn-site.xml
     if [[ ${NAMENODE_MODE} == "true" ]]; then
         echo "<configuration> <property> <name>yarn.resourcemanager.hostname</name> <value>"$HOST"</value> </property> </configuration>" > /opt/sds/hadoop/conf/yarn-site.xml
         sleep 10
         nohup /opt/sds/hadoop/sbin/yarn-daemon.sh --config /opt/sds/hadoop/conf start resourcemanager > /var/log/sds/hadoop-hdfs/yarn-resourcemanager.log &
     else
         echo "<configuration> <property> <name>yarn.resourcemanager.hostname</name> <value>"$NAMENODE_HOST"</value> </property> </configuration>" > /opt/sds/hadoop/conf/yarn-site.xml
     fi
     sleep 10
     nohup /opt/sds/hadoop/sbin/yarn-daemon.sh --config /opt/sds/hadoop/conf start nodemanager > /var/log/sds/hadoop-hdfs/yarn-nodemanager.log &
 fi

 source /tpcds-entrypoint.sh

 tail -f /var/log/sds/hadoop-hdfs/* 
