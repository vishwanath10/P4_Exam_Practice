create table employees 
(
id int primary key,
name varchar(50),
authorizeduser varchar(50),
salary decimal (10,2)
);
GO

CREATE FUNCTION [dbo].[fnsecuritypredicate]
(
    @authorizeduser varchar(5)
)
RETURNS TABLE 
WITH SCHEMABINDING
AS
RETURN (SELECT 1 AccessGranted WHERE @authorizeduser = USER_NAME())

select [fnsecuritypredicate]('v')

create security policy emp_security_policy
add filter predicate [dbo].[fnsecuritypredicate](authorizeduser)
on dbo.employees
with (state = on);

create security policy policyname
add filter predicate functionname(columnname)
on tablename
with (state = on)


select * from dbo.employees

insert into dbo.employees values (1,'vishwanath', 'dbo', 190);

select sUSER_NAME()


CREATE USER TestUser WITHOUT LOGIN;

EXECUTE AS USER='TestUser'

SELECT sUSER_NAME()
REVERT
GRANT SELECT ON schema::dbo TO TestUser;

select * from dbo.employees
