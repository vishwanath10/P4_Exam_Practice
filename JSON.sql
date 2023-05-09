DECLARE @MyJSON as NVARCHAR(MAX) ='
	{
	"info":
	{
		"name":"EmployeePayHistory",
		"object_id":2099048,
		"schema_id":5,
		"parent_object_id":0,
		"address":{
		"town":"Mumbai",
		"country":"UK"
		}
		,"tags":["Sports", "Water Polo"]
	}
	}
'

select JSON_QUERY(@MyJSON,'$.info.tags') 

SELECT Name, TOwn, COuntry, Tag
FROM   OPENJSON(@MyJSON) 
WITH
(
	 Name NVARCHAR(255) '$.info.name'
	,Town NVARCHAR(255) '$.info.address.town'
	,Country NVARCHAR(255) '$.info.address.country'
	,Tags NVARCHAR(MAX) '$.info.tags' AS JSOn
)
OUTER APPLY OPENJSON(Tags) 
WITH 
(
Tag NVARCHAR(255) '$'
)

SELECT BusinessEntityID, (SELECT 
       BusinessEntityID As Id,  
       FirstName, LastName,  
       Title As 'Info.Title',  
       MiddleName As 'Info.MiddleName'  
   FROM Person.Person as Per 
   WHERe Per.BusinessEntityID = Per1.BusinessEntityID
   FOR JSON PATH, ROOT('info')) as [JSON]
FROM Person.Person as Per1
WHERE BusinessEntityID < 100


SELECT * FROM Person.Person 



DECLARE @info NVARCHAR(100)='{"name":"John","skills":["C#","SQL"]}'

PRINT @info

-- Update name  

SET @info=JSON_MODIFY(@info,'$.name','Mike')

PRINT @info

-- Insert surname  

SET @info=JSON_MODIFY(@info,'$.surname','Smith')

PRINT @info

-- Set name NULL 

SET @info=JSON_MODIFY(@info,'strict $.name',NULL)

PRINT @info

-- Delete name  

SET @info=JSON_MODIFY(@info,'$.name',NULL)

PRINT @info

-- Add skill  

SET @info=JSON_MODIFY(@info,'append $.skills','Azure')

PRINT @info


DECLARE @json NVARCHAR(MAX);

SET @json = N'[
  {"id": 2, "info": {"name": "John", "surname": "Smith"}, "age": 25},
  {"id": 5, "info": {"name": "Jane", "surname": "Smith", "skills": ["SQL", "C#", "Azure"]}, "dob": "2005-11-04T12:00:00"}
]';

SELECT id,
    firstName,
    lastName,
    age,
    dateOfBirth,
    skill
FROM OPENJSON(@json) WITH (
    id INT 'strict $.id',
    firstName NVARCHAR(50) '$.info.name',
    lastName NVARCHAR(50) '$.info.surname',
    age INT,
    dateOfBirth DATETIME2 '$.dob',
    skills NVARCHAR(MAX) '$.info.skills' AS JSON
    )
OUTER APPLY OPENJSON(skills) WITH (skill NVARCHAR(8) '$');