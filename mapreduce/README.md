Hadoop Installation
    Download Java, hadoop tar file
```
    tar -xzf name.zip
```
    cp folders to /usr/local

    Set environment variables:
```
export JAVA_HOME=/usr/local/java
export PATH=$PATH:$JAVA_HOME/bin
export HADOOP_INSTALL=/usr/local/hadoop
export PATH=$PATH:$HADOOP_INSTALL/bin
export PATH=$PATH:$HADOOP_INSTALL/sbin
export HADOOP_MAPRED_HOME=$HADOOP_INSTALL
export HADOOP_COMMON_HOME=$HADOOP_INSTALL
export HADOOP_HDFS_HOME=$HADOOP_INSTALL
export YARN_HOME=$HADOOP_INSTALL
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_INSTALL/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_INSTALL/lib"
```

Create SSH Keys between client and server:
```
ssh-keygen -t rsa -P ""
cat $home/.sshd/id_rsa.pub >> $home/.ssh/authorized_keys
```

Hadoop Configurations: hadoop_home/etc/hadoop

    hadoop-env.sh
    core-site.xml
    yarn-site.xml
    mapred-site.xml
    hdfs-site.xml

URL for tracking:

    NameNode: 50070
    ResourceManager : 8088

Adding new nodes to existing cluster:
```
$hadoop_home/sbin/hadoop-daemon.sh start datanode
$hadoop_home/sbin/yarn-daemon.sh start nodemanager
```

HDFS Commands: https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html
```
hadoop fs -ls /
hadoop fs -mkdir /input
hadoop fs -copyFromLocal locapPath /input
hadoop fs -put localpath /input2
```
    Run balancer:
```
    hdfs balancer -threshold 5[percentage differ among data nodes]
    hdfs dfsadmin -safemode [enter|leave|get]
```
    NameNode:
        FSImage
        EditLogs
     Decommissioning a data node:
     On Name ndoe:
        hdfs-site.xml -> dfs.hosts.exclude -> filepath[ which contains data node for exclusion]
```
        hdfs dfsadmin -refreshNodes
```

Benchmarking:
```
hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.7.0-tests.jar
hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.7.0-tests.jar TestDFSIO -write -nrFiles 2 -fileSize 1GB -resFile /tmp/TestDFSIOwrite.txt
hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.7.0-tests.jar TestDFSIO -read -nrFiles 2 -fileSize 1GB -resFile /tmp/TestDFSIOread.txt
hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.7.0-tests.jar nnbench -operation create_write
hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.7.0-tests.jar mrbench
hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.7.0-tests.jar TestDFSIO -clean
```