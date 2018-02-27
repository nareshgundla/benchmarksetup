#!/usr/bin/env bash
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd $SCRIPTPATH
## ===================================================
## Inputs Required
## ===================================================

MASTER_HOSTNAME=localhost.localdomain.com
SLAVES=(
"localhost.localdomain.com:x.x.x.x:password"
)

CLUSTER_ID=cluster_1

## ===================================================
## Variables
## ===================================================
JAVA_URL="http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz"
MAVEN_URL="http://apache.mesi.com.ar/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz"
HADOOP_SRC_URL="http://apache.claz.org/hadoop/common/hadoop-2.9.0/hadoop-2.9.0-src.tar.gz"
MAVEN_URL="http://apache.mesi.com.ar/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz"
DERBY_URL="http://archive.apache.org/dist/db/derby/db-derby-10.10.2.0/db-derby-10.10.2.0-bin.tar.gz"
SPARK_SRC_URL="http://apache.claz.org/spark/spark-1.6.3/spark-1.6.3.tgz"
SPARK_DIST_URL="http://apache.claz.org/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.7.tgz"
HADOOP_DIST_URL="http://apache.claz.org/hadoop/common/hadoop-2.9.0/hadoop-2.9.0.tar.gz"

JAVA_TAR_FILE=jdk-8u161-linux-x64.tar.gz
HADOOP_SRC_TAR_FILE=hadoop-2.9.0-src.tar.gz
HADOOP_TAR_FILE=hadoop-2.9.0.tar.gz
MAVEN_TAR_FILE=apache-maven-3.5.2-bin.tar.gz
HIVE_TAR_FILE=apache-hive-1.2.2-bin.tar.gz
DERBY_TAR_FILE=db-derby-10.10.2.0-bin.tar.gz
SPARK_SRC_TAR_FILE=spark-1.6.3.tgz
SPARK_DIST_TAR_FILE=spark-2.2.0-bin-hadoop2.7.tgz
HADOOP_BUILD=false
HiBench_GIT=HiBench
HiBench_ZipFile=HiBench.zip

## ===================================================
## Generated Tar file names
## ===================================================
SPARKPhive_TAR_FILE=spark-1.6.3-bin-hadoop2.6_with_Phive.tgz
SPARK_HOS_TAR_FILE=spark-1.6.3-bin-hadoop2.6_without_hive.tgz

## ===================================================
## function definitions
## ===================================================
showHelp(){
echo "Usage: `basename $0` default [options]"
echo "Defaults: "
echo "1. Dowload Java 				   	; version: $JAVA_TAR_FILE"
echo "2. Download Maven					; version: $MAVEN_DIR"
echo "3. Downloads Hadoop distribution 			; version: $HADOOP_TAR_FILE"
echo "4. Downloads Spark & Custom build	for hive	; version: $SPARKPhive_TAR_FILE & $SPARK_HOS_TAR_FILE"
echo "5. Downloads and build hive for spark 1.6.3		; version: $HIVE_TAR_FILE"
echo "6. Download apache derby tar				; version: $DERBY_TAR_FILE"
echo
echo "options:"
echo -e "-h \t build hadoop with native code"

}

validateDownload(){
echo "Validating for All Requried Downloads for ansible"

}

if [[ ($# -eq 0) || ("default" != "$1") || ("$#" -gt 1 && "$2" != "-h")  ]]
then
	showHelp
	exit 1;
elif [[ $# -gt 1 && $2 -eq "-h" ]]
then
	HADOOP_BUILD=true
fi

################# Required Software for this package to run #################
# 1 Git with proxy setup if there is any proxy
command -v git >/dev/null 2>&1 || { echo "I require git but it's not installed. Aborting." >&2; exit 1;}
echo "Found `git --version`"
echo "current directory: --- `pwd`"


mkdir -p package_dir
cd package_dir

# Configure maven with proxy using .m2/settings.xml file

#############################################################################
################# Install Required software and packages ####################
# Requred to Download tar files
yum install -y wget 

################# JAVA Download #############################################
if [ ! -f $JAVA_TAR_FILE ]; 
then
	echo "Downloading JAVA tar file"
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" $JAVA_URL
fi

################# Maven and Java Setup for Build ############################
if [ ! -f $MAVEN_TAR_FILE ];
then
	echo "Downloading MAVEN tar file"
	wget $MAVEN_URL
fi
MAVEN_DIR=$(tar -tzf $MAVEN_TAR_FILE |head -1|cut -f1 -d"/")
JAVA_EXTRACT_FOLDER=$(tar -tzf $JAVA_TAR_FILE |head -1|cut -f1 -d"/")
if [ ! -d $MAVEN_DIR ]; 
then
	echo "Extracting Maven"
	tar -zxf $MAVEN_TAR_FILE
fi
if [ ! -d $JAVA_EXTRACT_FOLDER ];
then
	echo "Extracting Java"
	tar -zxf $JAVA_TAR_FILE
fi
echo "Setting JAVA and MAVEN for Build"
export JAVA_HOME=`pwd`/$JAVA_EXTRACT_FOLDER
export JRE_HOME=$JAVA_HOME/jre
export PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/jre/bin
unset M2_HOME
export M3_HOME=`pwd`/$MAVEN_DIR
export MAVEN_OPTS="-Xmx2g"
export PATH=$PATH:$M2

echo $JAVA_HOME
mvn -version

################# Build and Create Tar package for HADOOP ###################
# Download hadoop source package
if [[ ! -f $HADOOP_TAR_FILE && $HADOOP_BUILD = true ]]; 
then
	echo "Hadoop tar not found, Selected to build with native code lib's"
	if [ ! -f $HADOOP_SRC_TAR_FILE ]; 
	then
		wget $HADOOP_SRC_URL
	fi
	# Required tools to build hadoop native library ---https://wiki.apache.org/hadoop/HowToContribute#Build_Tools
	yum groupinstall "Development Tools" -y
	yum -y install lzo-devel  zlib-devel  gcc gcc-c++ autoconf automake libtool openssl-devel fuse-devel cmake

	command -v protoc>/dev/null 2>&1 || 
	{
	 	echo "I require ProtocolBuffer 2.5.+ but it's not installed. Installing.....";
		echo " Following Steps to build and install ProtocolBuffere"
		wget https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz 
		tar -zxf protobuf-2.5.0.tar.gz
		cd protobuf-2.5.0
		./configure && make && make install
		echo "protoc version installed"
	}
	echo "protoc version found"
	protoc --version
	tar -zxf $HADOOP_SRC_TAR_FILE
	cd hadoop-2.9.0-src
	mvn package -Pdist,native -DskipTests -Dtar
	cd ..
	cp hadoop-2.9.0-src/hadoop-dist/target/hadoop-2.9.0.tar.gz .
elif [[ ! -f $HADOOP_TAR_FILE &&  $HADOOP_BUILD = false  ]];
then
	echo "Hadoop Tar file not found. Downloading Hadoop distribution from Apache releases"
	wget $HADOOP_DIST_URL
fi

################# Build and Create tar package for SPARK with hive and without hive #################
# --https://cwiki.apache.org/confluence/display/Hive/Hive+on+Spark%3A+Getting+Started
if [ ! -f $SPARKPhive_TAR_FILE ];
then
	if [ ! -f $SPARK_SRC_TAR_FILE ];
	then
		wget $SPARK_SRC_URL
	fi
	tar -zxf $SPARK_SRC_TAR_FILE
	cd spark-1.6.3
	./build/mvn -Pyarn -Phadoop-2.6 -Dhadoop.version=2.9.0 -DskipTests clean package
	./make-distribution.sh --name "hadoop2.6_without_Phive" --tgz "-Pyarn,hadoop-provided,hadoop-2.6,parquet-provided"
	./make-distribution.sh --name hadoop2.6_with_Phive  --tgz -Pyarn -Phadoop-2.6  -Phive -Phive-thriftserver  -DskipTests
	cp spark-1.6.3-bin-hadoop2.6*.tgz ../
	cp dist/lib/spark-1.6.3-yarn-shuffle.jar ../
	cd ..
	
fi

if [ ! -f $SPARK_DIST_TAR_FILE ];
then
	wget $SPARK_DIST_URL
fi
################# Apply spark patch to make it compatible with spark 1.6.x #################
# At this time the stable hive version available in 1.x is 1.2.2

if [ ! -f $HIVE_TAR_FILE ];
then
	if [ ! -f HIVE-11473.3-spark.patch ];
	then
		wget https://issues.apache.org/jira/secure/attachment/12762632/HIVE-11473.3-spark.patch
		sed -i 1,30d HIVE-11473.3-spark.patch
	fi
	if [ ! -d hive ];
	then
		git clone https://github.com/apache/hive.git
		cd hive
		git checkout tags/rel/release-1.2.2
		sed -i 's/<spark.version>.*/<spark.version>1.6.3<\/spark.version>/' pom.xml
		yum -y install patch
		patch -p 1  < ../HIVE-11473.3-spark.patch
		cd ..
	fi
	cd hive
	mvn clean package -DskipTests -Pdist -Phadoop-2
	cd ..
	cp hive/packaging/target/apache-hive-1.2.2-bin.tar.gz .
fi

################# Download Apache Derby to use as a metastore for Hive #################
if [ ! -f $DERBY_TAR_FILE ];
then 
	wget $DERBY_URL
fi

if [ ! -d $HiBench_GIT ];
then
	git clone https://github.com/intel-hadoop/HiBench.git
fi

if [ ! -f $HiBench_ZipFile ];
then
	cd $HiBench_GIT
	mvn -Dspark=1.6 -Dscala=2.10 clean package
	cd ..
	zip -r $HiBench_ZipFile HiBench
fi


## ===================================================
## Derived Variables for ansible
## ===================================================
HADOOP_COUNT=${#SLAVES[@]}
HADOOP_NODES_COUNT=$(( $HADOOP_COUNT > 1 ? $HADOOP_COUNT-1 : 1))
HADOOP_HDFS_REPLICATION=$(( $HADOOP_NODES_COUNT > 3 ? 3 : 1))


JAVA_EXTRACT_FOLDER=$(tar -tzf $JAVA_TAR_FILE |head -1|cut -f1 -d"/")
HADOOP_EXTRACT_FOLDER=$(tar -tzf $HADOOP_TAR_FILE |head -1|cut -f1 -d"/")
HIVE_EXTRACT_FOLDER=$(tar -tzf $HIVE_TAR_FILE |head -1|cut -f1 -d"/")
DERBY_EXTRACT_FOLDER=$(tar -tzf $DERBY_TAR_FILE |head -1|cut -f1 -d"/")
SPARK_DIST_EXTRACT_FOLDER=$(tar -tzf $SPARK_DIST_TAR_FILE |head -1|cut -f1 -d"/")
SPARK_EXTRACT_FOLDER_Phive=$(tar -tzf $SPARKPhive_TAR_FILE |head -1|cut -f1 -d"/")
SPARK_EXTRACT_FOLDER_WITHOUT_Phive=$(tar -tzf $SPARK_HOS_TAR_FILE |head -1|cut -f1 -d"/")
SPARK_EXTRACT_FOLDER=$(tar -tzf $SPARK_DIST_TAR_FILE |head -1|cut -f1 -d"/")
SPARK_YARN_SHUFFLE=spark-1.6.3-yarn-shuffle.jar
HIVE_VERSION_PREFIX=1
#####################################################################################################################################
################# Setting up Cluster for Hive on Spark (yarn) #######################################################################

yum install epel-release -y
yum install ansible -y

echo "current directory: --- `pwd`"

cat>../../hadoop_variable.yml<<EOF
# java_install role params
#Zip Files Location
FILES_PATH: `pwd`
USER: root
GROUP: root
JAVA_INSTALL_LOC: /usr/local/bin
JAVA_INSTALL_FILE: "{{FILES_PATH}}/$JAVA_TAR_FILE"
JAVA_FOLDER: $JAVA_EXTRACT_FOLDER

# hadoop_install role params ( need java_install role params also)
HADOOP_USER: root
HADOOP_GROUP: root
HADOOP_INSTALL_LOC: /usr/local/bin
#Should be the Full Hostname with domain name
HADOOP_MASTER: $MASTER_HOSTNAME
#HADOOP_NODES_COUNT: $HADOOP_NODES_COUNT
#HADOOP_HDFS_REPLICATION: $HADOOP_HDFS_REPLICATION

HADOOP_HDFS_NAME_PREFIX: /data/dataa
#For Namenode directory prefix
HDFS_PREFIX: hdfs
HDFS_DATA_DIR_SUFFIX: /hadoop/hdfs
YARN_DATA_DIR_SUFFIX: /hadoop/nm-local-dir

HADOOP_INSTALL_FILE: "{{FILES_PATH}}/$HADOOP_TAR_FILE"
HADOOP_FOLDER: $HADOOP_EXTRACT_FOLDER
SPARK_YARN_SHUFFLE: "{{FILES_PATH}}/$SPARK_YARN_SHUFFLE"

YARN_MEM_RESOURCE_PERCENTATION: 0.92
CORES_FOR_OS: 3
YARN_LOG_ENABLE: false
YARN_LOG_SECONDS: 7200
YARN_DISK_PERCENTAGE_UTILIZATION: 100
REMOTE_HADOOP_SRC: no

#hiveonspark role params
#BigBench Install (hive,spark) install all necessary software
#hive, spark_with hive and spark withou hive, derby,
BENCHMARK_USER: "{{HADOOP_USER}}"
BIGBENCH_INSTALL_LOC: "/{{HADOOP_USER}}"

HIVE_REMOTE_SRC: no
SPARK_WITHOUTHIVE_SRC: no
SPARK_WITH_HIVE_SRC: no
DERBY_REMOTE_SRC: no

#Hive version
HIVE_INSTALL_FILE: "{{FILES_PATH}}/$HIVE_TAR_FILE"
HIVE_FOLDER: $HIVE_EXTRACT_FOLDER
HIVE_VERSION_PREFIX: $HIVE_VERSION_PREFIX
#SPARK CUSTOM BUILD FOR HIVE ON SPARK
SPARK_WITHOUT_HIVE_INSTALL_FILE: "{{FILES_PATH}}/$SPARK_HOS_TAR_FILE"
SPARK_WITHOUT_HIVE_FOLDER: $SPARK_EXTRACT_FOLDER_WITHOUT_Phive

SPARK_WITH_HIVE_INSTALL_FILE: "{{FILES_PATH}}/$SPARKPhive_TAR_FILE"
SPARK_WITH_HIVE_FOLDER: $SPARK_EXTRACT_FOLDER_Phive

#DERBY VERSION
DERBY_INSTALL_FILE: "{{FILES_PATH}}/$DERBY_TAR_FILE"
DERBY_FOLDER: $DERBY_EXTRACT_FOLDER

#BIGbench directories with tunings zip
BIGBENCH_FILE: "{{FILES_PATH}}/TPCx-BB_v1.2.zip"
BIGBENCH_FOLDER: TPCx-BB_v1.2
BIG_BENCH_ENGINE: hive

#SPARK EXECUTOR MEMORY SETTINGS
SPARK_DRIVER_MEM: 10g
SPARK_EXECUTOR_MEM: 26g
SPARK_EXECUTOR_CORES: 8
SPARK_YARN_EXECUTOR_MEM_OVERHEAD_MB: 4096
BIGBENCH_USE_NR_HUGEPAGES: "NO"
SPARK_DYNAMIC_EXECUTION: "YES"

#HiBench role params
HIBENCH_INSTALL_FILE: "{{FILES_PATH}}/$HiBench_ZipFile"
HIBENCH_FOLDER: HiBench
HIBENCH_INSTALL_LOC: "/{{HADOOP_USER}}"
SPARK_SRC: no
SPARK_INSTALL_FILE: "{{FILES_PATH}}/$SPARK_DIST_TAR_FILE"
SPARK_FOLDER: $SPARK_EXTRACT_FOLDER
EOF

cat>../../cluster_benchmark.yml<<EOF
---
- name: Hadoop Installation
  vars_files:
    - hadoop_variable.yml
  hosts: $CLUSTER_ID
  remote_user: root
  roles:
    - { role:  hadoop, tags: hadoop }
    - { role: ssh_configure, tags: ssh_configure }

- name: Setup Master Node for hive on spark and bigBench
  vars_files:
    - hadoop_variable.yml
  hosts: $MASTER_HOSTNAME
  remote_user: root
  roles:
    - { role: hiveonspark }
  tags:
    - master_bigBench


- name: Setup Master Node for HiBench
  vars_files:
    - hadoop_variable.yml
  hosts: $MASTER_HOSTNAME
  remote_user: root
  roles:
    - { role: hibench_install, when: ansible_distribution == "CentOS" and ansible_fqdn == HADOOP_MASTER, tags: hibench }
  tags:
    - master_hibench

EOF

exec 3<> ../../cluster-hosts
echo [$CLUSTER_ID] >&3
for host in "${SLAVES[@]}"; do
host_name=${host%%:*}
ip_cred=${host#*:}
host_ip=${ip_cred%%:*}
host_password=${ip_cred#*:}
echo "$host_name        ansible_host=$host_ip   ansible_connection=ssh ansible_user=root ansible_ssh_pass=$host_password" >&3
done
exec 3>&-
