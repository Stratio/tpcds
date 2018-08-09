#!/bin/bash -xe

echo " >>> Ingesting data with Spark-Submit"

export TPCDS_DATA_LOCATION=hdfs://$HOST:9000/$TPCDS_PATH

TPCDS_SPARK_MEM=${TPCDS_SPARK_MEM:=1g}

/spark-2.2.2-bin-hadoop2.7/bin/spark-submit --master local[*] --driver-memory $TPCDS_SPARK_MEM --class edu.brown.cs.systems.tpcds.spark.SparkTPCDSDataGenerator /tpcds/target/spark-workloadgen-5.0-jar-with-dependencies.jar

echo " >>> Data ingested in HDFS"

