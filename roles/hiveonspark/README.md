# Installation of Hive, Spark and hive on spark, enable spark dynamic execution setup for BigBench.
This role performs below steps
 * Installs Apache Hive
 * Installs Custom Apache Spark build without hive
 * Installs Custom Apache Spark build with hive
 * Installs Derby Database
 * Creates directory for bigbench and copies BigBench scripts
 * Creates Hive metastore directory
 * Copies Hive,Spark,BigBench configuration files and set the environment values accordingly
 * Copies Spark jars to Hive Lib folder
 
## Getting Started
 * Configuration : All Variable Need to be Configured in hadoop_variable.yml file approporiate to you cluster
 * Running Ansible role
```
ansible-playbook playbook.yml -tags hiveonspark

Sample playbook.yml

- name: set up hive on spark on master node
  hosts: master (full name with domain name)
  vars_files:
    - hadoop_variable.yml
  roles:
    - { role: hiveonspark, tags: hiveonspark}
```      

Assumption/ pre-requisties
 * Assumes you have already ran the hadoop role on all the machines.

After Running the play book please follow the steps mentioned in the file Start_Benchmark_BigBench.txt
#Follow below steps to make cluster ready for running BigBench
```
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
``` 