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
 * Configuration : All Variables Need to be Configured in hadoop_variable.yml file approporiate to your cluster
 * Running Ansible role
```
ansible-playbook playbook.yml -tags hiveonspark
```
Sample playbook.yml
```
- name: set up hive on spark on master node
  hosts: master (full name with domain name)
  vars_files:
    - hadoop_variable.yml
  roles:
    - { role: hiveonspark, tags: hiveonspark}
```      
Sample hadoop-variable.yml
```
#USER AND DIRECTORY CONFIG

HADOOP_MASTER: localhost
#Mention where to create hivedirectories on master node
HADOOP_HDFS_NAME_PREFIX: /data/dataa
BENCHMARK_USER: "{{HADOOP_USER}}"
BIGBENCH_INSTALL_LOC: "/{{BENCHMARK_USER}}"
#Hive version 
HIVE_INSTALL_FILE: apache-hive-3.0.0-SNAPSHOT-bin.tar.gz
HIVE_FOLDER: apache-hive-3.0.0-SNAPSHOT-bin
HIVE_VERSION_PREFIX: 3

#SPARK CUSTOM BUILD FOR HIVE ON SPARK
SPARK_WITHOUT_HIVE_INSTALL_FILE: spark-2.2.0-bin-hadoop27-without-hive.tgz
SPARK_WITHOUT_HIVE_FOLDER: spark-2.2.0-bin-hadoop28-without-hive

SPARK_WITH_HIVE_INSTALL_FILE: spark-2.2.0-bin-hadoop27_with_Phive.tgz
SPARK_WITH_HIVE_FOLDER: spark-2.2.0-bin-hadoop27_with_Phive

#DERBY VERSION
DERBY_INSTALL_FILE: db-derby-10.10.2.0-bin.zip
DERBY_FOLDER: db-derby-10.10.2.0-bin

#Downloaded BigBench tar file 
BIGBENCH_FILE: TPCx-BB_v1.2.zip
BIGBENCH_FOLDER: TPCx-BB_v1.2
BIG_BENCH_ENGINE: hive

#SPARK EXECUTOR MEMORY SETTINGS
SPARK_DRIVER_MEM: 10g
SPARK_EXECUTOR_MEM: 26g
SPARK_EXECUTOR_CORES: 8
SPARK_YARN_EXECUTOR_MEM_OVERHEAD_MB: 4096
BIGBENCH_USE_NR_HUGEPAGES: "yes"
REMOTE_BIGBENCH_SRC: no
```
Assumptions/ pre-requisties
 * Assumes you have already ran the hadoop role on all the machines.
 * Assumes you have already downloaded BigBench Tar file from http://www.tpc.org/tpc_documents_current_versions/current_specifications.asp and placed inside hadoop_software/package_dir

After Running the play book please follow the steps mentioned in the file BIGBENCH_INSTALL_LOC/Start_Benchmark_BigBench.txt according to your cluster paths.
 * Follow below steps to make your cluster ready for running BigBench
```
#On Master node/Slaves nodes:
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