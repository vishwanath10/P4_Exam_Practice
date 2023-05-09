select compatibility_level, * 
from   sys.databases 
where  name = DB_NAME();

ALTER DATABASE SQLChallenges 
SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = ON;

ALTER DATABASE SQLChallenges
ADD FILEGROUP SQLChallenges_FG_MOT CONTAINS MEMORY_OPTIMIZED_DATA;

ALTER DATABASE SQLChallenges
ADD FILE (name = 'SQLChallenges_FG_MOT', filename = 'D:\SQLChallenges')
TO FILEGROUP SQLChallenges_FG_MOT

USE SQLChallenges
GO

Create TABLE dbo.InMemoryExample
(
OrderID INTEGER NOT NULL IDENTITY (1,1) PRIMARY KEY NONCLUSTERED,
ItemNumber INT NOT NULL,
OrderDate  DATETIME NOT NULL
)
WITH (Memory_Optimized = ON, durability = schema_and_data);

SELECT SUSER_NAME();


ALTER DATABASE TSQLV3
SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = ON;

ALTER DATABASE TSQLV3
ADD FILEGROUP [TSQLV3_FG] CONTAINS MEMORY_OPTIMIZED_DATA;

ALTER DATABASE TSQLV3
ADD FILE (name = 'TSQLV3_MOD', filename = 'D:\TSQLV3_MOD_File')
TO FILEGROUP [TSQLV3_FG];

drop table if exists customer;

create table customer 
(
id					int identity (1,1) primary key
,firstname			nvarchar(255) not null
,lastname			nvarchar(255) not null
,amount				decimal(18,2) not null
,SysStartDate		datetime2 generated always as row start not null
,SysEndDate			datetime2 generated always as row end not null
,PERIOD for SYSTEM_TIME(SysStartDate, SysEndDate)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.CustomerHistory, DATA_CONSISTENCY_CHECK = ON, HISTORY_RETENTION_PERIOD = 90 Days))

ALTER TABLE customer
SET (SYSTEM_VERSIONING = OFF);

drop table if exists customer2;

create table customer2 
(
id					int identity (1,1) primary key nonclustered hash with (bucket_count=131072)
,firstname			nvarchar(255) not null
,lastname			nvarchar(255) not null
,amount				decimal(18,2) not null
,SysStartDate		datetime2 generated always as row start not null
,SysEndDate			datetime2 generated always as row end not null
,PERIOD for SYSTEM_TIME(SysStartDate, SysEndDate)
)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY= SCHEMA_AND_DATA, SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.CustomerHistory2, DATA_CONSISTENCY_CHECK = ON, HISTORY_RETENTION_PERIOD = 90 Days))

SELECT * FROM customer2

INC4986934

create procedure dbo.USP_InsertCustomer2 
WITH native_compilation, SCHEMABINDING, EXECUTE AS OWNER 
AS 
BEGIN ATOMIC 
with (transaction isolation level = snapshot, language = 'us_english')
SELECT id, firstname FROM dbo.customer2
END

create procedure dbo.usp_insertcustomerdata
with native_compilation, schemabinding, execute as owner
as 
begin atomic 
with (transaction isolation level = snapshot, language = 'us_english')
select id, firstname from dbo.customer2
end;

CREATE PROCEDURE [dbo].[spProductUpdate]
	    WITH NATIVE_COMPILATION ,
	         SCHEMABINDING,
	         EXECUTE AS OWNER
	AS
	   BEGIN ATOMIC WITH ( TRANSACTION ISOLATION LEVEL = SNAPSHOT,
	   LANGUAGE = N'us_english' )
	        UPDATE dbo.Product
	        SET Price = Price - ( Price * 0.10 );


CREATE PROCEDURE USP_InsertCustomer2
    @CustomerID INT,
    @CompanyName NVARCHAR(50),
    @ContactName NVARCHAR(50),
    @ContactTitle NVARCHAR(50),
    @Phone NVARCHAR(50)
WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC 
with (transaction isolation level = snapshot, language = 'us_english')
    INSERT INTO dbo.Customers
        (CustomerID, CompanyName, ContactName, ContactTitle, Phone)
    VALUES
        (@CustomerID, @CompanyName, @ContactName, @ContactTitle, @Phone);
    SELECT CustomerID, CompanyName, ContactName, ContactTitle, Phone
    FROM dbo.Customers
    WHERE CustomerID = @CustomerID;
END;
	

CREATE PROCEDURE dbo.native_sp
	with native_compilation,
	     schemabinding,
	     execute as owner
as
begin atomic
	with (transaction isolation level = snapshot,
	      language = N'us_english')

	DECLARE @i int = 1000000;

	WHILE @i > 0
	begin
		INSERT dbo.t1 values (@i, @i+1);
		SET @i -= 1;
	end
end;
GO