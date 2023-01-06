USE nyc_taxi_ldw;

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'nyc_taxi_src')
    CREATE EXTERNAL DATA SOURCE nyc_taxi_src
    WITH
    (    LOCATION         = 'https://synapseprojectdl1.dfs.core.windows.net/nyc-taxi-data'
    );