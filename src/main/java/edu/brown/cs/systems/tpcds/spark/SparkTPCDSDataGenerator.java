package edu.brown.cs.systems.tpcds.spark;

import org.apache.spark.SparkConf;
import org.apache.spark.SparkContext;
import org.apache.spark.sql.SQLContext;

import com.databricks.spark.sql.perf.tpcds.Tables;

public class SparkTPCDSDataGenerator {

	/** Generate data using the default dataset settings */
	public static void generateData() {
		generateData(TPCDSSettings.createWithDefaults());
	}

	/**
	 * Generate data using some default dataset settings, overridding the
	 * specified values
	 */
	public static void generateData(String location, String format, int scaleFactor) {
		TPCDSSettings settings = TPCDSSettings.createWithDefaults();
		settings.dataLocation = location;
		settings.dataFormat = format;
		settings.scaleFactor = scaleFactor;
		generateData(settings);
	}

	/** Generate data using the specified dataset settings */
	public static void generateData(TPCDSSettings settings) {
		SparkConf conf = new SparkConf().setAppName("TPC-DS generateData");
		SparkContext sc = new SparkContext(conf);
		SQLContext sqlContext = new SQLContext(sc);
		Tables tables = new Tables(sqlContext, settings.scaleFactor, settings.numPartitions);
		tables.genData(settings.dataLocation, settings.dataFormat, settings.overwrite, settings.partitionTables,
				settings.useDoubleForDecimal, settings.clusterByPartitionColumns,
				settings.filterOutNullPartitionValues, "", settings.usePartitionColumns);

		sc.stop();
	}

	public static void main(String[] args) {
		TPCDSSettings settings = TPCDSSettings.createWithDefaults();
		System.out.println("Creating TPC-DS data using spark, with default settings:");
		System.out.println(settings);
		generateData(settings);
	}

}
