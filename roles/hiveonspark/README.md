You will need to run hiveonspark role along side java_install,hadoop roles 
Hive on spark role performs 
 1 Installs Apache Hive
 2 Installs Custom Apache Spark build without hive
 3 Installs Custom Apache Spark build with hive
 4 Installs Derby Database
 5 Creates and Install BigBench
 6 Creates Hive metastore directory
 7 Copies Hive,Spark,BigBench configuration files and set the environment values accordingly
 8 Copies Spark jars to Hive Lib folder
 
## All Variable Need to be Configured in variable.yml file approporiate to you cluster
```
- name: basic configuration
  hosts: master (full name with domain name)
  vars_files:
    - variable.yml
  roles:
    - role: hiveonspark
      

# After Running java_install, hadoop role on all machines then run hiveonspark on master node
#Below Steps are needed for Running BigBench
#On Master node:
  Set Environment variable in .bashrc file
  export JAVA_HOME=
  export PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/jre/bin
  export HADOOP_HOME=
  export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
  export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
  export HIVE_HOME=
  export PATH=$PATH:$HIVE_HOME/bin
  export HADOOP_CLIENT_OPTS="-Xmx4096m"
  export SPARK_DIST_CLASSPATH=$(hadoop classpath)

# source .bashrc file
#Format Hdfs (one time only)
hdfs namenode -format
#Check for slave file for verification $HADOOP_HOME/etc/hadoop/slaves
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
mr-jobhistory-daemon.sh start historyserver

#Validation
   hdfs dfsadmin -report 
# (check for the number of datanodes)
   yarn node -list 
#(check for number of nodes)
# http://master-node:8088/cluster --> Nodes --> Mem Avail and VCores Avail for each node
#Create Hdfs data directories
$HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/$USER
$HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/spark/applicationHistory
$HADOOP_HOME/bin/hdfs dfs -chmod g+w /user/spark/applicationHistory
$HADOOP_HOME/bin/hdfs dfs -mkdir -p /tmp
$HADOOP_HOME/bin/hdfs dfs -chmod g+w /tmp
$HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/hive/warehouse
$HADOOP_HOME/bin/hdfs dfs -chmod g+w /user/hive/warehouse

#Start Derby Server
nohup $Derby_Home/bin/startNetworkServer -h master_hostname &
#Initialize Hive Schema (one time only)
$HIVE_HOME/bin/schematool -dbType derby -initSchema  
#Start hive metastore
nohup $HIVE_HOME/bin/hive --service metastore &
$SPARK_WITH_HIVEHOME/sbin/start-historyserver.sh
#Spark History Server URL : http://master-node:18080/

#Run Benchmark 
$BIGBENCH_HOME/bin/bigBench runBenchmark -f 1[scalefactor] -s 2[NumberOfStreams] -m 80[NumberOfMapper@DataGen]

  