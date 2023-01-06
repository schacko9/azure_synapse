USE nyc_taxi_discovery;

-----------------------------------------------------
-- Check for duplicates in the Taxi Zone data
-----------------------------------------------------

-- Check Location ID for duplicates (Should return nothing, otherwise duplicates exist)
SELECT
    location_id,
    COUNT(1) AS number_of_records
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@synapseprojectdl1.dfs.core.windows.net/raw_data/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH (
        location_id SMALLINT 1,
        borough VARCHAR(15) 2,
        zone VARCHAR(50) 3,
        service_zone VARCHAR(15) 4
    )AS [result]
GROUP BY location_id
HAVING COUNT(1) > 1;


-- Check Borough (Duplicates is fine)
SELECT
    borough,
    COUNT(1) AS number_of_records
FROM
    OPENROWSET(
        BULK 'abfss://nyc-taxi-data@synapseprojectdl1.dfs.core.windows.net/raw_data/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) 
    WITH (
        location_id SMALLINT 1,
        borough VARCHAR(15) 2,
        zone VARCHAR(50) 3,
        service_zone VARCHAR(15) 4
    )AS [result]
GROUP BY borough
HAVING COUNT(1) > 1
ORDER BY number_of_records DESC;
