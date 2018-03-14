# Pre-requists for this role:
 * There should not be any drive which is mounted using docker
 * This role identifies the boot drive as /boot mounted drive and ignores to format and mount

# This role does the below tasks
 * Creates Partition Information
 * Formating Drive using ext4 format 
 * Mounts the formated drives to the path /data/data[a-z] mapped to /dev/sd[a-z]
 
 
# Example use
```
--
- name: Format and mount the drives
  hosts: cluster_name
  roles:
    - role: format
```

If there is any error with any of the drive on the node then please do the steps manually becuase there might be an issue with the drive
* for example consider the error is with drive /dev/sdb
```
 parted /dev/sdb mklabel gpt yes unit TB mkpart primary 0% 100% print
 mkdfs.ext4 /dev/sdb -F
 mkdir /data/datab
 mount /dev/sdb /data/datab
```
add the mount info to /etc/fstab
```
/dev/sdb	/data/datab	ext4	defaults,noatime	0	0
```