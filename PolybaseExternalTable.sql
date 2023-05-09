exec sp_configure @configname = 'polybase enabled', @configvalue = 1;

RECONFIGURE;

USE [CSV_Demo];
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'password';  

CREATE DATABASE SCOPED CREDENTIAL blob_storage   
WITH IDENTITY = '<user_name>', Secret = '<password>';  

CREATE EXTERNAL DATA SOURCE Blob_CSV
WITH
(
 LOCATION = 'abs://<container>@<storage_account>.blob.core.windows.net'
,CREDENTIAL = blob_storage 
);

CREATE EXTERNAL FILE FORMAT csv_ff
WITH
(   FORMAT_TYPE = DELIMITEDTEXT
,   FORMAT_OPTIONS  (    FIELD_TERMINATOR = ','
                    ,    STRING_DELIMITER = '"'
                    ,    FIRST_ROW = 2 )
);

CREATE EXTERNAL TABLE extCall_Center_csv
(
            cc_call_center_sk         integer             NOT NULL  ,
            cc_call_center_id         char(16)            NOT NULL  ,
            cc_rec_start_date         date                          ,
            cc_rec_end_date           date                          ,
            cc_closed_date_sk         integer                       ,
            cc_open_date_sk           integer                       ,
            cc_name                   varchar(50)                   ,
            cc_class                  varchar(50)                   ,
            cc_employees              integer                       ,
            cc_sq_ft                  integer                       ,
            cc_hours                  char(20)                      ,
            cc_manager                varchar(40)                   ,
            cc_mkt_id                 integer                       ,
            cc_mkt_class              char(50)                      ,
            cc_mkt_desc               varchar(100)                  ,
            cc_market_manager         varchar(MAX)                  ,
            cc_division               varchar(50)                   ,
            cc_division_name          varchar(50)                   ,
            cc_company                varchar(60)                   ,
            cc_company_name           char(50)                      ,
            cc_street_number          char(10)                      ,
            cc_street_name            varchar(60)                   ,
            cc_street_type            char(15)                      ,
            cc_suite_number           char(10)                      ,
            cc_city                   varchar(60)                   ,
            cc_county                 varchar(30)                   ,
            cc_state                  char(20)                      ,
            cc_zip                    char(20)                      ,
            cc_country                varchar(MAX)                  ,
            cc_gmt_offset             decimal(5,2)                  ,
            cc_tax_percentage         decimal(5,2) 
)
WITH
(
    LOCATION = '/2022/call_center.csv',
    DATA_SOURCE = Blob_CSV
    ,FILE_FORMAT = csv_ff
)
GO