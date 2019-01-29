# Quick and Fast installation of Hadoop,Spark and Hive on Spark setup for benchmarking

This projects help you in building hadoop,hive and spark for hive on spark setup and installs Apache Hadoop on all the nodes.


## Getting Started
 * Configure cluster information
 * Builds/Downloads Apache Hadoop,Spark,Hive distributions
 * Ansible Configuration for installing Hadoop
 * Starting Hadoop Services
 * Running Benchmarks
	 * HiBench
	 * BigBench


### Prerequisites
Below Softwares are required for setup.
 * Git software and proxy configuration for git (if any)
 * Maven proxy configured (if any)
 * Currently this project supports Centos OS only

### Configure you cluster information in file hadoop_software/HOS_setup.sh
 * MASTER_HOSTNAME: configure master-node hostname with full domain
 * SLAVES=(
 	Configure all the nodes information here in the format
	hostname:ipaddress:Password for root user
 )
 ```
 file:hadoop_software/HOS_setup.sh
MASTER_HOSTNAME=localhost.domain.com
SLAVES=(
"localhost.domain.com:x.x.x.x:password"
"slave1.domain.com:x.x.x.x:password"
"slave2.domain.com:x.x.x.x:password"
)
 ```

### Build/Download Apache Hadoop,Spark,Hive distributions
 * Run the script : This script will download and builds all requried packages (sudo permisions are requried)
	./hadoop_software/HOS_setup.sh default [options]
```
./hadoop_software/HOS_setup.sh default
```
 * The above script also installs ansible and generates all required files for the setup.

### Ansible Configuration for installing Hadoop
 * Run ansible command to install packages on to the cluster.
 * ansible-playbook cluster_benchmark.yml [options]
 ```
 ansible-playbook cluster_benchmark.yml
 ```

### Starting Hadoop Services
 * Follow the steps provide in the generated scripts with exact paths according to your clusters (Start_Benchmark_HiBench.txt or Start_Benchmark_BigBench.txt)
 	 * Step 1:
	 	 * Set Environment varialbes
		 * Format hdfs and start hdfs,yarn and yarn history server
		 * Next steps depends on the benchmark you want to run.
```
$HADOOP_HOME/bin/hdfs namenode -format
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver
```
### Running Benchmarks
 * HiBench
 * BigBench: Download BigBench(TPCX-BB) from http://www.tpc.org/tpc_documents_current_versions/current_specifications.asp
```
Versions used in the script:
Hadoop version: 2.9.0
JAVA version: Oracle jdk8_161

Hive on Spark:
Spark: 1.6.3
Hive: 1.2.2
Derby: 10.10.2

For HiBench:
spark: 2.2.0

```


Capacity Planning:
Cluster Capacity on Hdfs Data Size and Growth Projection

Cluster Size:
  Hdfs Space per Node = (Raw Disk space - 20% for non dfs storage)/ 3 (RF)
  Cluster Nodes = Total HDFS space / HDFS space per node

  4 to 6 GB per core
  1/1.5 per disks per core
  1 to 3 TB SATA disks space per core

  NN:  2GB(default) + 1GB per 100TB of disk storage

  HDFS storage growth and current capacity utilization

Hardware Selection:
    Master Nodes:

    Compute Nodes:


Reference: https://www.slideshare.net/vgogate/hadoop-configuration-performance-tuning


Hadoop Configuration:

