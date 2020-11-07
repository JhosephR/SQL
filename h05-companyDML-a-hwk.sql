-- File: companyDML-a-solution
-- SQL/DML HOMEWORK (on the COMPANY database)
/*
--
IMPORTANT SPECIFICATIONS
--
(A)
-- Download the script file company.sql and use it to create your COMPANY database.
-- Dowlnoad the file companyDBinstance.pdf; it is provided for your convenience when checking the results of your queries.
(B)
Implement the queries below by ***editing this file*** to include
your name and your SQL code in the indicated places.   
--
(C)
IMPORTANT:
-- Don't use views
-- Don't use inline queries in the FROM clause - see our class notes.
--
(D)
After you have written the SQL code in the appropriate places:
-- Run this file (from the command line in sqlplus).
-- Upload the spooled file (companyDML-b.txt) to BB.*/
-- Don't remove the SET ECHO command below.
--
SPOOL companyDML-a.txt
SET ECHO ON
-- ---------------------------------------------------------------
-- 
-- Name: < ***** Jhoseph Ruiz Fachin ***** >
--
-- ------------------------------------------------------------
-- NULL AND SUBSTRINGS -------------------------------
--
/*(10A)
Find the ssn and last name of every employee who doesn't have a  supervisor, or his last name contains at least two occurences of the letter 'a'. Sort the results by ssn.
*/
SELECT ssn, lname
FROM employee
WHERE lname LIKE '%a%a%' OR
    super_ssn IS NULL
ORDER BY ssn;
--
-- JOINING 3 TABLES ------------------------------
-- 
/*(11A)
For every employee who works more than 30 hours on any project: Find the ssn, lname, project number, project name, and numer of hours. Sort the results by ssn.
*/
SELECT e.ssn, e.lname, pnumber, pname, hours
FROM employee e, project p, works_on w
WHERE hours > 38 AND e.ssn = w.essn
    AND w.pno = p.pnumber
ORDER BY ssn;
--
-- JOINING 3 TABLES ---------------------------
--
/*(12A)
Write a query that consists of one block only.
--For every employee who works on a project that is not controlled by the department he works for: Find the employee's lname, the department he works for, the project number that he works on, and the number of the department that controls that project. Sort the results by lname.
*/
SELECT e.lname, e.dno, w.pno, p.dnum
FROM employee e, project p, works_on w
WHERE w.essn = e.ssn
    AND w.pno = p.pnumber
    AND p.dnum != e.dno
ORDER BY e.lname;
--
-- JOINING 4 TABLES -------------------------
--
/*(13A)
For every employee who works for more than 20 hours on any project that is located in the same location as his department: Find the ssn, lname, project number, project location, department number, and department location.Sort the results by lname
*/
SELECT e.ssn, e.lname, p.pnumber, p.plocation, d.dnumber, d.dlocation
FROM employee e, project p, dept_locations d, works_on w
WHERE w.hours > 20
    AND p.plocation = d.dlocation
    AND w.pno = p.pnumber
    AND w.essn = e.ssn
ORDER BY e.lname;
--
-- SELF JOIN -------------------------------------------
-- 
/*(14A)
Write a query that consists of one block only.
For every employee whose salary is less than 70% of his immediate supervisor's salary: Find his ssn, lname, salary; and his supervisor's ssn, lname, and salary. Sort the results by ssn.  
*/
SELECT e.ssn, e.lname, e.salary, e.super_ssn, e2.lname, e2.salary
FROM employee e, employee e2
WHERE e2.ssn = e.super_ssn
    AND e.salary < (e2.salary * 0.7)
ORDER BY e.ssn;
--
-- USING MORE THAN ONE RANGE VARIABLE ON ONE TABLE -------------------
--
/*(15A)
For projects located in Houston: Find pairs of last names such that the two employees in the pair work on the same project. Remove duplicates. Sort the result by the lname in the left column in the result. 
*/
SELECT DISTINCT e1.lname, e2.lname
FROM employee e1, employee e2, project p1, works_on w, works_on we
WHERE e1.ssn != e2.ssn
AND w.pno = p1.pnumber
AND we.pno = p1.pnumber
AND e1.ssn = w.essn
AND e2.ssn = we.essn
AND w.pno = we.pno
AND p1.plocation = 'Houston'
ORDER BY e1.lname;
--
------------------------------------
--
/*(16A) Hint: A NULL in the hours column should be considered as zero hours.
Find the ssn, lname, and the total number of hours worked on projects for every employee whose total is less than 40 hours. Sort the result by lname
*/ 
SELECT e.lname, e.ssn, SUM(hours) AS SumofHours
FROM employee e, works_on w
WHERE w.essn = e.ssn
GROUP BY e.lname, e.ssn
HAVING (SUM(hours) < 40 OR SUM(hours) IS NULL)
ORDER BY e.lname;
--
------------------------------------
-- 
/*(17A)
For every project that has more than 2 employees working on it: Find the project number, project name, number of employees working on it, and the total number of hours worked by all employees on that project. Sort the results by project number.
*/ 
SELECT DISTINCT p.pnumber, p.pname, COUNT(w.essn) AS EmployeeCount, SUM(hours) ASSumofHours
FROM project p, works_on w
WHERE p.pnumber = w.pno
GROUP BY p.pnumber, p.pname
HAVING COUNT(w.essn) > 2
ORDER BY p.pnumber;
-- 
-- CORRELATED SUBQUERY --------------------------------
--
/*(18A)
For every employee who has the highest salary in his department: Find the dno, ssn, lname, and salary . Sort the results by department number.
*/
SELECT e.dno, e.ssn, e.lname, e.salary
FROM employee e
WHERE e.salary = 
    (SELECT MAX(salary)
    FROM employee e2
    WHERE e.dno = e2.dno)
ORDER BY e.dno;
--
-- NON-CORRELATED SUBQUERY -------------------------------
--
/*(19A)
For every employee who does not work on any project that is located in Houston: Find the ssn and lname. Sort the results by lname
*/
SELECT e.ssn, e.lname
FROM employee e
WHERE e.ssn NOT IN
    (SELECT w.essn
    FROM works_on w, project p
    WHERE p.plocation = 'Houston'
        AND w.pno = p.pnumber)
ORDER BY e.lname;
--
-- DIVISION ---------------------------------------------
--
/*(20A) Hint: This is a DIVISION query
For every employee who works on every project that is located in Stafford: Find the ssn and lname. Sort the results by lname
*/
SELECT e.ssn, e.lname
FROM employee e
WHERE NOT EXISTS
((SELECT p.pnumber
    FROM project p
    WHERE p.plocation = 'Stafford')
    MINUS
    (SELECT w.pno
    FROM works_on w, project p
    WHERE p.plocation = 'Stafford'
        AND w.pno = p.pnumber
        AND w.essn = e.ssn))
    ORDER BY e.lname;
--
SET ECHO OFF
SPOOL OFF


