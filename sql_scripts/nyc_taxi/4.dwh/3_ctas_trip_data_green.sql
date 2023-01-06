CREATE SCHEMA staging
GO

IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'parquet_file_format') 
	CREATE EXTERNAL FILE FORMAT parquet_file_format 
	WITH ( FORMAT_TYPE = PARQUET)
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'nyc_taxi_data_src') 
	CREATE EXTERNAL DATA SOURCE nyc_taxi_data_src
	WITH (
		LOCATION = 'abfss://nyc-taxi-data@synapseprojectdl1.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE staging.ext_trip_data_green (
	  year int,
    month int,
    borough varchar(15),
    trip_date date,
    trip_day varchar(10),
    trip_day_weekend_ind char(1),
    fare_amount float,
    card_trip_count int,
    cash_trip_count int,
    street_hail_trip_count int,
    dispatch_trip_count int,
    trip_distance float,
    trip_duration int
    	)
	WITH (
	LOCATION = 'gold/trip_data_green',
	DATA_SOURCE = nyc_taxi_data_src,
	FILE_FORMAT = parquet_file_format
	)
GO


SELECT TOP 100 * FROM staging.ext_trip_data_green
GO

CREATE SCHEMA dwh
GO

CREATE TABLE dwh.trip_data_green
WITH   
  (   
    CLUSTERED COLUMNSTORE INDEX,  
    DISTRIBUTION = ROUND_ROBIN  
  )  
AS SELECT * FROM staging.ext_trip_data_green
GO

SELECT * FROM dwh.trip_data_green;