# Installing Java on all the nodes.

Run ansible role:
```
ansible-playbook playbook.yml -tags java
```

sample playbook.yml
```
- name: Install Java 
  hosts: cluster_name or Hostname
  var_files:
    - hadoop_variable.yml
  roles:
    - { role: java_install, tags: java }
   
```
Sample hadoop_variable.yml
```
USER: root
GROUP: root
JAVA_INSTALL_LOC: /usr/local
JAVA_INSTALL_FILE: jdk-8u131-linux-x64.tar.gz
JAVA_FOLDER: jdk1.8.0_131
```

Custom Configuration:
USER,GROUP configs values are used to assign user:group permission to java_installed folder
JAVA_INSTALL_LOC: copies and extract the java tar file in the specified location
JAVA_INSTALL_FILE: java_tar_file name
JAVA_FOLDER: extracted java folder name