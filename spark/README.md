# Spark Cheat Sheet:

Logging::
    Logger.getLogger("org").setLevel(Level.ERROR)
RDD
    Entry Point
    val conf = new SparkConf().setAppName("appname").setMaster("local[?]")
    val sc = new SparkContext(conf)

    Reading Data:
        sc.textFile("path")
        sc.parallelize(obj)
       rdd.persist(StorageLevel.MEMORY_ONLY)

    Accumulators:
        sc.longAccumulator
            add(int)
    BroadCast:
        sc.broadcast(obj)
            value.[obj operations]
 Transformations:
    flatMap(line => [operations on line])   # 1 -> N outputs
    take(n)
    filter( line => [operation which returns boolean)
    map(line => [operation which returns one item])  # 1->1
    intersection(rdd)
    union(rdd)
    sample()

    # pair RDDS (key,value)
    combineByKey(1,2,3) multiple combiners based on key
    reduceByKey()
    groupByKey
    sortBy(line => [provide col on which sort should be performed)
    sortByKey()

    #joins
    join(otherRdd)
    leftOuterJoin(otherRdd)
    rightOuterJoin(otherRdd)
    fullOuterJoin(otherRdd)


 Actions:
    countByValue()
    reduce( (x,y) => [operation which returns one value] )  # find sum
    count()
    collect()

    collectAsMap()  # after groupByKey
    mapValues()


 Saving Data:
    saveAsTextFile("path")
Data Sets:
    Entry Poing:
        val session = SparkSession.builder().appName("appName").master("local[1]").getOrCreate()

    Reading:
        session.read.option("key","value").csv("filePath")
            "header": "true" , "inferSchema": true

    rdd to DS:
        rdd.toDS()

    DS:
        show(count)
        printSchema()
        rdd # to rdds

        select(".. col names"
        filter(ds.col("") ?cond value)
        orderBy(ds.col("").)
                ds.col("")
                            .===("")
                            > | <
                            .desc
                            .divide
                            .cast
                            .multiply
         groupBy()
         avg()


Spark Sql Tunings:
cache()
    spark.sql.codegen  [true, false]
    spark.sql.inMemoryColumnarStorage.batchSize  [numeric] default:1000
