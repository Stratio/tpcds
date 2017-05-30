#!/bin/bash -xe

echo "Ingesting data with Spark-Submit"

export TPCDS_DATA_LOCATION=hdfs://$HOST:9000/$TPCDS_PATH

echo " >>> TPCDS_DATA_LOCATION=$TPCDS_DATA_LOCATION"

/spark-1.6.1-bin-hadoop2.6/bin/spark-submit --master local[*] --driver-memory 1g --class edu.brown.cs.systems.tpcds.spark.SparkTPCDSDataGenerator /tpcds/target/spark-workloadgen-4.0-jar-with-dependencies.jar

echo "Data ingested in HDFS"

