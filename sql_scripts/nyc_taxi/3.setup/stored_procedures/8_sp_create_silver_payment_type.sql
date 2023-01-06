USE nyc_taxi_ldw
GO


CREATE OR ALTER PROCEDURE silver.sp_silver_payment_type3
AS
BEGIN

    IF OBJECT_ID('silver.payment_type3') IS NOT NULL
        DROP EXTERNAL TABLE silver.payment_type3;

    CREATE EXTERNAL TABLE silver.payment_type3
        WITH
        (
            DATA_SOURCE = nyc_taxi_src,
            LOCATION = 'silver/payment_type',
            FILE_FORMAT = parquet_file_format
        )
    AS
    SELECT payment_type, description
    FROM OPENROWSET(
        BULK 'raw_data/payment_type.json',
        DATA_SOURCE = 'nyc_taxi_src',
        FORMAT = 'CSV',
        FIELDTERMINATOR = '0x0b',
        FIELDQUOTE = '0x0b'
    )
    WITH
    (
        jsonDoc NVARCHAR(MAX)
    ) AS payment_type
    CROSS APPLY OPENJSON(jsonDoc)
    WITH(
        payment_type SMALLINT,
        description VARCHAR(20) '$.payment_type_desc'
    );


END;
