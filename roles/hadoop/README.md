# Installation of Apache Hadoop using ansible role

This roles helps in installing Apache Hadoop on all the client and master nodes,
creates required  directories for both Hdfs and Yarn and 
configures the tunings based on the cluster size


## Getting Started
 * Validate your cluster information(optional)
```
ansible-playbook playbook.yml --tags config_check

for every node it prints the config used:
    - "HDFS NAME DIR"
    - "HDFS CHKPT DIR"
    - "DRIVES LIST"
    - "HDFS DATA DIR"
    - "YARN DATA DIR"
    - "HDFS DATA DIR SUFFIX:"
    - "Slaves::"
    - " NUMBER OF NODES : "
    - "REPLICATION FACTOR : "
```
 * Run the Ansible Role
 ```
 ansible-playbook playbook.yml --tags hadoop
```
Sample playbook.yml file:
```
- name: Setup Hadoop
  vars_files: hadoop_variable.yml
  hosts: cluster-hosts
  remote_user:root
  roles:
    - { role: hadoop, tags:hadoop }
 ```
Sample hadoop_variable.yml
```
USER: root
GROUP: root
JAVA_INSTALL_LOC: /usr/local
JAVA_INSTALL_FILE: jdk-8u131-linux-x64.tar.gz
JAVA_FOLDER: jdk1.8.0_131

HADOOP_USER: root
HADOOP_GROUP: root
HADOOP_INSTALL_LOC: /usr/local/bin
HADOOP_MASTER: localhost.localdomain.com
CLUSTER_SIZE: "{{(ansible_play_batch | length)|int}}"
HADOOP_NODES_COUNT: "{% if  CLUSTER_SIZE| version_compare('1',operator='eq') %}{{1|int}}{%elif CLUSTER_SIZE| version_compare('1',operator='gt') %}{{CLUSTER_SIZE|int-1}}{%endif%}"
HADOOP_HDFS_REPLICATION: "{% if HADOOP_NODES_COUNT|version_compare('3',operator='le')%}{{1|int}}{%else%}{{3|int}}{%endif%}"

#Configure below value to a drive on Namenode
HADOOP_HDFS_NAME_PREFIX: /data/datab

HADOOP_INSTALL_FILE: hadoop-2.8.1.tar.gz
HADOOP_FOLDER: hadoop-2.8.1
SPARK_YARN_SHUFFLE: spark-2.2.0-yarn-shuffle.jar
```
## Assumptions
 * Assumes all External Drives are formatted in ext4 format.
 * ignores boot drive for HDFS/YARN directoires if node contains any external drives.
 
 Note: HADOOP_MASTER: node name should be with domain name

## Configuration
Default Hadoop Tunings are set in defaults/main.yml and if you want to customize any setting then edit hadoop-variable.yml
 * Hadoop Name Node and Secondary Name node heap size 
 sets HADOOP_NAMENODE_OPTS,HADOOP_DATANODE_OPTS
 ```
	HADOOP_HDFS_NN_SN_HEAPSIZE_MB: 1024
 ```
 * Yarn Memory Allocation Percentage:
 sets yarn.nodemanager.resource.memory-mb,yarn.scheduler.maximum-allocation-mb
```
	YARN_MEM_RESOURCE_PERCENTATION: 0.92
 ```
 * Cores reserverd for Operative system and other services (if you are running any other services then allocate more vcores below)
 sets yarn.scheduler.maximum-allocation-vcores, yarn.nodemanager.resource.cpu-vcores
```
	CORES_FOR_OS: 3   
```
 * Yarn Disk allocation percentage for application temporary Storage.
 sets yarn.nodemanager.disk-health-checker.max-disk-utilization-per-disk-percentage
```
	YARN_DISK_PERCENTAGE_UTILIZATION: 90
```
 * Yarn Node Manager Heap Size (10GB will be sufficient for upto 100TB Dataset)
 sets YARN_NODEMANAGER_HEAPSIZE
```
	YARN_NODEMANAGER_HEAPSIZE_MB: 10240
```
 * If you have already copied the Hadoop tar file to the destination then value is "yes"
```
	REMOTE_HADOOP_SRC: no
```
 * To enable Spark Dynamic Execution {possible values yes,no}
```
	SPARK_DYNAMIC_EXECUTION: no
to enable spark dynamic execution then configure appropriate jar file and copy the jar file to hadoop_software/package_dir
SPARK_YARN_SHUFFLE: spark-2.2.0-yarn-shuffle.jar
```
 * To Enable/Aadd -XX:+UseLargePages flag to JVM params for hadoop services {possible values yes,no}
```
	USE_NR_HUGEPAGES: no 
```
 * To Save Yarn container logs for debugging then enable below flag  {possible values true,false}
```
	YARN_LOG_ENABLE: false
```