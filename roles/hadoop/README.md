# Installation of Apache Hadoop using ansible role

<<<<<<< HEAD
This roles helps in installing Apache Hadoop on all the client and master nodes,
creates required  directories for both Hdfs and Yarn and 
configures the tunings based on the cluster size
=======
This roles helps in installing Apache Hadoop on all the client nodes and creates required  directories for both Hdfs and Yarn and configure the tunings based on the cluster size
>>>>>>> 536ed5ec2b51f3141212e59b5be517163eeee903


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
 
 Sample playbook.yml file:
 - name: Setup Hadoop
<<<<<<< HEAD
   vars_files: hadoop_variable.yml
   hosts: cluster-hosts
>>>>>>> 536ed5ec2b51f3141212e59b5be517163eeee903
   remote_user:root
   roles:
   - { role: hadoop, tags:hadoop }
 ```

## Assumptions
 * Assumes all External Drives are formatted in ext4 format.
 * ignores boot drive for HDFS/YARN directoires if node contains any external drives.
 
 Note: HADOOP_MASTER: node name should be with domain name

## Configuration
<<<<<<< HEAD
Default Hadoop Tunings are set in defaults/main.yml
 * Hadoop Name Node and Secondary Name node heap size 
 ```
	HADOOP_HDFS_NN_SN_HEAPSIZE_MB: 1024
 ```
 * Yarn Memory Allocation Percentage:
```
	YARN_MEM_RESOURCE_PERCENTATION: 0.92
 ```
 * Cores reserverd for Operative system and other services (if you are running any other services then allocate more vcores below)
```
	CORES_FOR_OS: 3   
```
 * Yarn Disk allocation percentage for application temporary Storage.
```
	YARN_DISK_PERCENTAGE_UTILIZATION: 90
```
 * Yarn Node Manager Heap Size (10GB will be sufficient for upto 100TB Dataset)
```
	YARN_NODEMANAGER_HEAPSIZE_MB: 10240
```
 * If you have already copied the Hadoop tar file to the destination then "yes"
```
	REMOTE_HADOOP_SRC: no
```
 * To enable Spark Dynamic Execution {possible values yes,no}
```
	SPARK_DYNAMIC_EXECUTION: no
```
 * To Enable/Aadd -XX:+UseLargePages flag to JVM params for hadoop services {possible values yes,no}
```
	USE_NR_HUGEPAGES: no 
```
 * To Save Yarn container logs for debugging then enable below flag  {possible values true,false}
```
	YARN_LOG_ENABLE: false
```
=======

Default Hadoop Tunings are set in defaults/main.yml
Hadoop Name Node and Secondary Name node heap size 
	HADOOP_HDFS_NN_SN_HEAPSIZE_MB: 1024
Yarn Memory Allocation Percentage:
	YARN_MEM_RESOURCE_PERCENTATION: 0.92
Cores reserverd for Operative system and other services (if you are running any other services then allocate more vcores below)
	CORES_FOR_OS: 3   
Yarn Disk allocation percentage for application temporary Storage.
	YARN_DISK_PERCENTAGE_UTILIZATION: 90
Yarn Node Manager Heap Size (10GB will be sufficient for upto 100TB Dataset)
	YARN_NODEMANAGER_HEAPSIZE_MB: 10240
If you have already copied the Hadoop tar file to the destination then "yes"
	REMOTE_HADOOP_SRC: no  {yes,no}-possible values
To enable Spark Dynamic Execution then yes else no
	SPARK_DYNAMIC_EXECUTION: no
To Enable/Aadd -XX:+UseLargePages flag to JVM params for hadoop services {possible values yes,no}
	USE_NR_HUGEPAGES: no 
To Save Yarn container logs for debugging then enable below flag  {possible values true,false}
	YARN_LOG_ENABLE: false
>>>>>>> 536ed5ec2b51f3141212e59b5be517163eeee903
