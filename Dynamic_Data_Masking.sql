USE SQLChallenges
GO

DROP USER IF EXISTS MaskedTestuser;
CREATE USER MaskedTestuser WITHOUT LOGIN;

DROP TABLE IF EXISTS dbo.Employee;

CREATE TABLE dbo.Employee
(
    ID				INT NOT NULL IDENTITY(1,1),
    [Name]			NVARCHAR(255) 	MASKED WITH (FUNCTION = 'default()')	NOT NULL,
	Phone			BIGINT			MASKED WITH (FUNCTION = 'random(1,9)')	NOT NULL,  
	[State]			NVARCHAR(255)	MASKED WITH (FUNCTION = 'partial(2,"XXXX",2)') NOT NULL,		
	EmailId			NVARCHAR(255)   MASKED WITH (FUNCTION = 'email()')		NOT NULL,
	CreatedDate		DATETIME	    MASKED WITH (FUNCTION = 'default()') NOT NULL,
	DeptID			INT				NOT NULL
	CONSTRAINT  PK_Employee_ID PRIMARY KEY(ID)
);



INSERT INTO dbo.Employee ([Name], Phone, [State], EMailId, CreatedDate, DeptID) VALUES 
 ('Vishwanath', '9773458245', 'Maharashtra', 'vishwanath.d@noemail.com', GETDATE(), 1)
,('Dilip', '9831284844', 'Uttar Pradesh', 'dilip.d@noemail.com', GETDATE(), 2)
,('Priyanka', '3745645645', 'Goa', 'Priyanka.d@noemail.com', GETDATE(), 3)

ALTER TABLE dbo.Employee ALTER COLUMN DeptID ADD MASKED WITH (FUNCTION='default()');

SELECT * FROM dbo.Employee

GRANT SELECT ON dbo.Employee TO MaskedTestuser;
GRANT SELECT ON SCHEMA::dbo TO MaskedTestUser;

GRANT UNMASK ON dbo.Employee TO MaskedTestUser;

EXECUTE AS USER = 'MaskedTestuser';
SELECT * FROM dbo.Employee;

REVERT;

SELECT * FROM dbo.Employee;


IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'JohnSmith')
BEGIN
	DROP LOGIN [JohnSmith]
END

CREATE LOGIN JohnSmith WITH PASSWORD = N'Test@123', Default_database=[SQLChallenges], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;

IF EXISTS (SELECT 1 FROM sys.sysusers WHERE name = 'JohnSmith')
BEGIN
	DROP USER [JohnSmith]
END
GO

CREATE USER JohnSmith
FOR LOGIN JohnSmith
WITH DEFAULT_SCHEMA = dbo;

GRANT SELECT ON dbo.Employee TO JohnSmith;

GRANT SELECT ON SCHEMA::Data TO JohnSmith;



SELECT * FROM sys.masked_columns