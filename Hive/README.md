#   Hive
    SCHEMA ON READ
##  Configuration:
```
    $HIVE_HOME/conf/hive-site.xml
```
##  Usage :
    Hive Shell:
```
    hive
```
    Non Interactive
```
    hive -f file.q
    hive -e 'inline queries'
    hive -S  -e [to supress standard error messages]
    hive --config [custome-config-folder-path]
```

##  FEW USEFUL COMMANDS:
```
    SHOW TABLES;
    SHOW FUNCTIONS;
    DESCRIBE FUNCTION length;
    SET -v [To list all the properties in the system]
```

##  Metastore:
    Hive Stores data in /user/hive/warehouse/table_name
    Default:
     Hive creates metastore_db in relative to location from which hive command has ran
     the metastore is runs in the same process as the Hive service and contains an embedded derby database instance for single session

    The Metastore is the central repository of hive metadata
    Divided into
        service
        backing store for the data
### Tables:
    PARTITIONS  : PARTITIONED BY ();
        BUCKETS : CLUSTERED BY (COL) INTO N BUCKETS
            Advantages: while joining COLUMNS --> MAP-SIDE JOIN
                        SAMPLING of data

#### Data Managed By Hive:
```
    CREATE TABLE table_name (COL_NAME COL_TYPE);
    LOAD DATA INPATH '/path/to/file.txt' INTO TABLE table_name;
    # moves file to warehouse directory and creates metadata in metastore
    DROP TABLE table_name
    # file and metadata is deleted
```
#### Data Not Managed By Hive:
    EXTERNAL TABLES:
```
    CREATE EXTERNAL TABLE table_name (COL_NAME COL_TYPE);
    LOCATION '/external/path/for/table_name';
    LOAD DATA INPATH '/path/to/file.txt' INTO TABLE table_name;
```
#### Default table definition transfered by hive to

    CREATE TABLE ...
    ROW FORMAT DELIMITED
        FIELDS TERMINATED BY '^A'
        COLECTION ITEMS TERMINATED BY '^B'
        MAP KEYS TERMINATED BY '^C'
        LINES TERMINATED BY '\n'
    STORED AS TEXTFILE;
   # Internally hive uses SerDe --> LazySimpleSerDe for this delimited format

####    Indexes
    compact
    bitmap

####    Not Supported Operations
    delete and update
    corelated sub queries

####    Hive Complex Data Types:

 ARRAY
 MAP
 STRUCT

## Storage Formats:
    row format  -> rows and fields in a particular row
        defined by a SerDE: defaults to delimited text with one row per line and fields by ^A
    file format  ->


## Retrieving Data:

 ORDER BY --> SETs number of reducers to 1 --> inefficcient
 SORT BY --> produces a sorted file per reducer
 DISTRIBUTE BY --> All rows for a given column end up in same reducer
 CLUSTER BY -> short hand for specifying both sort by and distribute by -->if columns are same

 #Streaming : using external script files to perform operations:
    TRANSFORM
        Register the external script using ADD
        TRANSFORM(INPUT) USING 'script_file' AS OUTPUT
          INPUT --> script_file --> OUTPUT
    MAP
    REDUCE

##  Hive Tunings::
    Priority of picking hive values:
    SET
    command line -hiveconf
    hive-site.xml
    hive-default.xml
    hadoop-site --- conf files
    hadoop-default --- conf files

```
SET hive.enforce.bucketing;

```

##  Log Files:

/tmp/$USER/hive.log
Mode Settings:
    conf/hive-log4j.properties
Per Session:
    hive -hiveconf hive.root.logger=DEBUG,console

##  Hive as server as service:
    hive --service hiveserver


