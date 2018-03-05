Hadoop roles performs
 1 Install Hadoop on all Client Nodes
 2 Copies Hadoop_env tunings 
 3 Copies hadoop_conf file and set the master and slave node information accordingly
 4 Creates Hdfs and Yarn Data Directories
 5 Creates HDFS Namenode directories on the master node
 6 Copies spark-yarn-shuffle.jar to all nodes for enabling spark dynamic execution
 5 Calls java_install role.
 
 Note: HADOOP_MASTER: node name should be with domain name

```
- name: basic configuration
  hosts: All hosts
  vars_files:
    - variable.yml
  roles:
    - role: hadoop
      