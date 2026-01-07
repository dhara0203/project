/*create database db1;*/
use db1;

drop table if exists EMP_LOG;
drop table if exists STUDENT;
drop table if exists EMP;
drop table if exists DEPT;
CREATE TABLE dept(
    deptno INT NOT NULL PRIMARY KEY,
    dname  VARCHAR(14),
    loc    VARCHAR(50)
);
CREATE TABLE student (
    rno   INT NOT NULL PRIMARY KEY,
    sname VARCHAR(14),
    city  VARCHAR(20),
    state VARCHAR(20)
);

CREATE TABLE emp_log (
    emp_id     INT NOT NULL,
    log_date   DATE,
    new_salary INT(10),
    action     VARCHAR(20)
);

CREATE TABLE emp (
    empno    INT(4) NOT NULL PRIMARY KEY,
    ename    VARCHAR(10),
    job      VARCHAR(9),
    mgr      INT(4),
    hiredate DATE,
    sal      DECIMAL(7,2),
    comm     DECIMAL(7,2),
    deptno   INT(2)
);
ALTER TABLE emp
ADD CONSTRAINT fk_emp_dept
FOREIGN KEY (deptno) REFERENCES dept(deptno);

INSERT INTO dept VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO dept VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO dept VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO dept VALUES (40, 'OPERATIONS', 'BOSTON');

INSERT INTO emp VALUES (7369, 'SMITH',  'CLERK',    7902, '1980-12-17',  800.00,  NULL, 20);
INSERT INTO emp VALUES (7499, 'ALLEN',  'SALESMAN', 7698, '1981-02-20', 1600.00, 300.00, 30);
INSERT INTO emp VALUES (7521, 'WARD',   'SALESMAN', 7698, '1981-02-22', 1250.00, 500.00, 30);
INSERT INTO emp VALUES (7566, 'JONES',  'MANAGER',  7839, '1981-04-02', 2975.00, NULL, 20);
INSERT INTO emp VALUES (7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250.00, 1400.00, 30);
INSERT INTO emp VALUES (7698, 'BLAKE',  'MANAGER',  7839, '1981-05-01', 2850.00, NULL, 30);
INSERT INTO emp VALUES (7782, 'CLARK',  'MANAGER',  7839, '1981-06-09', 2450.00, NULL, 10);
INSERT INTO emp VALUES (7788, 'SCOTT',  'ANALYST',  7566, '1987-06-11', 3000.00, NULL, 20);
INSERT INTO emp VALUES (7839, 'KING',   'PRESIDENT',NULL, '1981-11-17', 5000.00, NULL, 10);
INSERT INTO emp VALUES (7844, 'TURNER', 'SALESMAN', 7698, '1981-08-09', 1500.00, 0.00, 30);
INSERT INTO emp VALUES (7876, 'ADAMS',  'CLERK',    7788, '1987-07-13', 1100.00, NULL, 20);
INSERT INTO emp VALUES (7900, 'JAMES',  'CLERK',    7698, '1981-03-12',  950.00, NULL, 30);
INSERT INTO emp VALUES (7902, 'FORD',   'ANALYST',  7566, '1981-03-12', 3000.00, NULL, 20);
INSERT INTO emp VALUES (7934, 'MILLER', 'CLERK',    7782, '1982-01-23', 1300.00, NULL, 10);

select * from dept;
select * from emp;

/*1. Select unique job from EMP table.*/
SELECT DISTINCT job FROM emp;

/*2. List the details of the emps in asc order of the Dptnos and desc of Jobs?*/
SELECT * FROM emp
ORDER BY deptno ASC, job DESC;

/*3. Display all the unique job groups in the descending order?*/
SELECT DISTINCT job FROM emp
ORDER BY job DESC;

/*4. List the emps who joined before 1981.*/
SELECT * FROM emp
WHERE hiredate < '1981-01-01';

/*5. List the Empno, Ename, Sal, Daily sal of all emps in the asc order of
Annsal.*/
SELECT empno,
       ename,
       sal,
       sal / 30 AS daily_sal
FROM emp
ORDER BY sal * 12 ASC;

/*6. List the Empno, Ename, Sal, Exp of all emps working for Mgr 7369.*/
SELECT empno,
       ename,
       sal,
       TIMESTAMPDIFF(YEAR, hiredate, CURDATE()) AS exp
FROM emp
WHERE mgr = 7369;


/*7. Display all the details of the emps who’s Comm. Is more than their Sal?*/
SELECT *
FROM emp
WHERE comm > sal;

/*8. List the emps who are either ‘CLERK’ or ‘ANALYST’ in the Desc order.*/
SELECT *
FROM emp
WHERE job IN ('CLERK', 'ANALYST')
ORDER BY job DESC;

/*9. List the emps Who Annual sal ranging from 22000 and 45000.*/
SELECT *
FROM emp
WHERE sal * 12 BETWEEN 22000 AND 45000;

/*10. List the Enames those are starting with ‘S’ and with five characters.*/
SELECT ename
FROM emp
WHERE ename LIKE 'S____';

/*11. List the emps whose Empno not starting with digit78.*/
SELECT *
FROM emp
WHERE empno NOT LIKE '78%';

/*12. List all the Clerks of Deptno 20.*/
SELECT *
FROM emp
WHERE job = 'CLERK' AND deptno = 20;

/*13. List the Emps who are senior to their own MGRS.*/
SELECT e.*
FROM emp e
JOIN emp m ON e.mgr = m.empno
WHERE e.hiredate < m.hiredate;

/*14. List the Emps of Deptno 20 who’s Jobs are same as Deptno10.*/
SELECT *
FROM emp
WHERE deptno = 20
AND job IN (SELECT job FROM emp WHERE deptno = 10);

/*15. List the Emps who’s Sal is same as FORD or SMITH in desc order of Sal.*/
SELECT *
FROM emp
WHERE sal IN (SELECT sal FROM emp WHERE ename IN ('FORD','SMITH'))
ORDER BY sal DESC;

/*16. List the emps whose jobs same as SMITH or ALLEN.*/
SELECT *
FROM emp
WHERE job IN (SELECT job FROM emp WHERE ename IN ('SMITH','ALLEN'));

/*17. Any jobs of deptno 10 those that are not found in deptno 20.*/
SELECT DISTINCT job
FROM emp
WHERE deptno = 10
AND job NOT IN (SELECT job FROM emp WHERE deptno = 20);

/*18. Find the highest sal of EMP table.*/
SELECT MAX(sal) AS highest_salary
FROM emp;

/*19. Find details of highest paid employee.*/
SELECT *
FROM emp
WHERE sal = (SELECT MAX(sal) FROM emp);

/*20. Find the total sal given to the MGR.*/
SELECT SUM(sal) AS total_mgr_salary
FROM emp
WHERE job = 'MANAGER';

/*21. List the emps whose names contains ‘A’.*/
SELECT *
FROM emp
WHERE ename LIKE '%A%';

/*22. Find all the emps who earn the minimum Salary for each job wise in
ascending order.*/
SELECT *
FROM emp e
WHERE sal = (
    SELECT MIN(sal)
    FROM emp
    WHERE job = e.job
)
ORDER BY sal ASC;

/*23. List the emps whose sal greater than Blake’s sal.*/
SELECT *
FROM emp
WHERE sal > (SELECT sal FROM emp WHERE ename = 'BLAKE');

/*24. Create view v1 to select ename, job, dname, loc whose deptno are
same.*/
CREATE VIEW view_1 AS
SELECT e.ename, e.job, d.dname, d.loc
FROM emp e
JOIN dept d ON e.deptno = d.deptno;

select * from view_1;

/*25. Create a procedure with dno as input parameter to fetch ename and
dname.*/
DELIMITER //

CREATE PROCEDURE get_emp_dept(IN dno INT)
BEGIN
    SELECT e.ename, d.dname
    FROM emp e
    JOIN dept d ON e.deptno = d.deptno
    WHERE e.deptno = dno;
END //

DELIMITER ;

call get_emp_dept(30);

/*26. Add column Pin with bigint data type in table student.*/
ALTER TABLE student
ADD pin BIGINT;

select * from student;

/*27. Modify the student table to change the sname length from 14 to 40.
Create trigger to insert data in emp_log table whenever any update of sal
in EMP table. You can set action as ‘New Salary’.*/
ALTER TABLE student
MODIFY sname VARCHAR(40);

DELIMITER //

CREATE TRIGGER trg_emp_sal_update
AFTER UPDATE ON emp
FOR EACH ROW
BEGIN
    -- Only insert if salary is changed
    IF OLD.sal <> NEW.sal THEN
        INSERT INTO emp_log(emp_id, log_date, new_salary, action)
        VALUES (NEW.empno, CURDATE(), NEW.sal, 'New Salary');
    END IF;
END //

DELIMITER ;

-- Update salary of an employee
UPDATE emp
SET sal = 3500
WHERE empno = 7566;

-- Check the emp_log table
SELECT * FROM emp_log;
