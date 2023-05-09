DROP TABLE IF EXISTS dbo.Employee
GO

CREATE TABLE dbo.Employee
(
    ID INT NOT NULL IDENTITY (1,1),
    FirstName NVARCHAR(255) NOT NULL,
	LastName  NVARCHAR(255) NOT NULL,
	Phone     INT NOT NULL,
	Constraint PK_Employee_ID PRIMARY KEY (ID),
	SysStartDate DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL,
	SysEndDate DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME(SysStartDate, SysEndDate)
)vhair
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory, DATA_CONSISTENCY_CHECK = ON));

ALTER TABLE dbo.Employee
SET (SYSTEM_VERSIONING = ON (HISTORY_RETENTION_PERIOD = 9 MONTHS));

CREATE PARTITION FUNCTION [fn_EmployeeHistory_By_SysEndDate] (datetime2(7))
AS RANGE LEFT FOR VALUES 
(
N'2023-04-30T23:59:59.999',
N'2023-05-31T23:59:59.999'
);

CREATE PARTITION SCHEME [sch_Partition_EmployeeHistory_By_SysEndDate]
AS PARTITION [fn_EmployeeHistory_By_SysEndDate]
TO ([PRIMARY], [PRIMARY], [PRIMARY]);

SELECT temporal_type, * FROM sys.tables 



INSERT INTO dbo.Employee (FirstName, LastName, Phone) VALUES 
 ('Atul', 'Kokam', 676665)
,('Sangram', 'Parte', 8764455)


UPDATE dbo.Employee
SET    Phone = 5434334
WHERE  ID = 2

SELECT * FROM dbo.Employee
SELECT * FROM dbo.EmployeeHistory

SELECT * 
FROM dbo.Employee FOR SYSTEM_TIME ALL
WHERE ID = 2
ORDER BY SysEndDate

SELECT * FROM dbo.Employee WHERE ID = 2
SELECT * FROM dbo.EmployeeHistory WHERE ID = 2

SELECT		* 
FROM		dbo.Employee FOR SYSTEM_TIME ALL
WHERE		ID = 2
ORDER BY	SysEndDate;

SELECT		* 
FROM		dbo.Employee FOR SYSTEM_TIME AS OF '2023-05-04 07:37:45.4547762'
WHERE		ID = 2
ORDER BY	SysEndDate;

SELECT		* 
FROM		dbo.Employee FOR SYSTEM_TIME FROM '2023-05-04 07:37:45.4547762' TO '2023-05-04 07:38:53.5345813'
WHERE		ID = 2
ORDER BY	SysEndDate;

SELECT		* 
FROM		dbo.Employee FOR SYSTEM_TIME BETWEEN '2023-05-04 07:37:45.4547762' AND '2023-05-04 07:38:53.5345813'
WHERE		ID = 2
ORDER BY	SysEndDate;

SELECT		* 
FROM		dbo.Employee 
FOR SYSTEM_TIME CONTAINED IN('2023-05-04', '9999-05-04')
WHERE		ID = 2
ORDER BY	SysEndDate;


DELETE FROM dbo.Employee WHERE ID = 2

SELECT * FROM SYS.periods


CREATE SCHEMA History;	

drop table if exists dbo.InsurancePolicy

CREATE TABLE dbo.InsurancePolicy
(
	ID INT NOT NULL
	,FirstName NVARCHAR(255)
	,LastName  NVARCHAR(255)
	,constraint pk_InsurancePolicy_ID PRIMARY KEY (ID)
);

ALTER TABLE dbo.InsurancePolicy ADD 
 ValidFrom DATETIME2 GENERATED ALWAYS AS ROW START CONSTRAINT Df_InsurancePolicy_ValidFrom DEFAULT SYSUTCDATETIME()
,ValidTo   DATETIME2 GENERATED ALWAYS AS ROW END CONSTRAINT Df_Insurance_Policy_ValidTo DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999')
,PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo);

alter taBLE dbo.InsurancePolicy
SET (SYSTEM_VERSIONING = ON ( HISTORY_TABLE = History.InsurancePolicy , DATA_CONSISTENCY_CHECK = ON, HISTORY_RETENTION_PERIOD = 2 MONTHS))

