CREATE TABLE EMP
(EMPNO INT NOT NULL,
ENAME VARCHAR(20),
JOB VARCHAR(10),
MGR INT,
JOINDATE DATETIME,
SALARY DECIMAL(7, 2),
COMMISIION DECIMAL(7, 2),
DNO INT)
 
INSERT INTO EMP VALUES 
(7369, 'SMITH', 'CLERK', 7902, '02-MAR-1970', 8000, NULL, 2),
(7499, 'ALLEN', 'SALESMAN', 7698, '20-MAR-1971', 1600, 3000, 3),
(7521, 'WARD', 'SALESMAN', 7698, '07-FEB-1983', 1250, 5000, 3),
(7566, 'JONES', 'MANAGER', 7839, '02-JUN-1961', 2975, 50000, 2),
(7654, 'MARTIN', 'SALESMAN', 7698, '28-FEB-1971', 1250, 14000, 3),
(7698, 'BLAKE', 'MANAGER', 7839, '01-JAN-1988', 2850, 12000, 3),
(7782, 'CLARK', 'MANAGER', 7839, '09-APR-1971', 2450, 13000, 1),
(7788, 'SCOTT', 'ANALYST', 7566, '09-DEC-1982', 3000, 1200, 2),
(7839, 'KING', 'PRESIDENT', NULL, '17-JUL-1971', 5000, 1456, 1),
(7844, 'TURNER', 'SALESMAN', 7698, '08-AUG-1971', 1500, 0, 3),
(7876, 'ADAMS', 'CLERK', 7788, '12-MAR-1973', 1100, 0, 2),
(7900, 'JAMES', 'CLERK', 7698, '03-NOV-1971', 950, 0, 3),
(7902, 'FORD', 'ANALYST', 7566, '04-MAR-1961', 3000, 0, 2),
(7934, 'MILLER', 'CLERK', 7782, '21-JAN-1972', 1300, 0, 1)

-- =========================================
-- Create Graph Node Template
-- =========================================
USE SQLChallenges
GO

IF OBJECT_ID('dbo.EmpNode', 'U') IS NOT NULL
  DROP TABLE dbo.EmpNode
GO

CREATE TABLE dbo.EmpNode
(
    ID int NOT NULL IDENTITY(1,1),
	EmpNo INT NOT NULL,
    EmpName char(10) NULL,
    Mgr datetime NULL,

    -- Unique index on $node_id is required.
    -- If no user-defined index is specified, a default index is created.
    INDEX ix_graphid UNIQUE ($node_id)
)
AS NODE
GO


INSERT INTO EmpNode(EMPNO,EmpName,MGR) select empno,ename,MGR from emp

SELECT * FROM EmpNode

CREATE TABLE empReportsTo(Deptno int) AS EDGE

INSERT INTO empReportsTo  VALUES ((SELECT $node_id FROM EmpNode WHERE ID = 1), 
       (SELECT $node_id FROM EmpNode WHERE id = 13),20);

INSERT INTO empReportsTo 
SELECT e.$node_id, m.$node_id ,e.dno
FROM dbo.EmpNode e 
inner JOIN dbo.EmpNode m 
ON e.empno = m.mgr;

SELECT * FROM EmpNode

SELECT * FROM empReportsTo

SELECT 
E.EMPNO,E.ENAME,E.MGR,E1.EMPNO,E1.ENAME,E1.MGR, e2.empno, e.ename,e.mgr
FROM 
    empnode e, empnode e1, empReportsTo m, empReportsTo m1, empnode e2
WHERE 
    MATCH(e-(m)->e1-(m1)->e2)	
and e.ENAME='SMITH'

SELECT 
E.EMPNO,E.ENAME,E.MGR,E1.EMPNO,E1.ENAME,E1.MGR, e2.empno, e.ename,e.mgr
FROM 
    empnode e, empnode e1, empReportsTo m, empReportsTo m1, empnode e2
WHERE 
    MATCH(e<-(m)-e1<-(m1)-e2)	
and e.ENAME='SMITH'




CREATE TABLE dbo.EmpNode(
ID Int Identity(1,1),
EMPNO NUMERIC(4) NOT NULL,
ENAME VARCHAR(10),
MGR NUMERIC(4),
DNO INT
) AS NODE;

INSERT INTO EmpNode(EMPNO,ENAME,MGR,DNO) select empno,ename,MGR,dno from emp

CREATE TABLE empReportsTo(Deptno int) AS EDGE

