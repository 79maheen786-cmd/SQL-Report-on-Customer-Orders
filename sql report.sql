create database employee;
use employee;
/*3.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table,
 and make a list of employees and details of their department. */
 
 select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT from emp_record_table;
 
 /*
 4.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
●	less than two
●	greater than four 
●	between two and four */

SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM
    emp_record_table
WHERE
    EMP_RATING < 2 OR EMP_RATING > 4
        OR EMP_RATING BETWEEN 2 AND 4;





/*
5.	Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department 
from the employee table and then give the resultant column alias as NAME.*/

SELECT 
    CONCAT(FIRST_NAME,' ', LAST_NAME) AS NAME,DEPT
FROM
    emp_record_table
WHERE
    DEPT = 'FINANCE';

SELECT * FROM emp_record_table;





/*
6.	Write a query to list only those employees who have someone reporting to them.
 Also, show the number of reporters (including the President).*/

SELECT 
    e.EMP_ID, e.FIRST_NAME, e.ROLE
FROM
    emp_record_table e
        JOIN
    emp_record_table r ON e.EMP_ID = r.MANAGER_ID order by e.EMP_ID;
 
 
----------------------------------------------

SELECT 
    e.EMP_ID, e.FIRST_NAME, count(r.EMP_ID) asnum_reporters
FROM
    emp_record_table e
        JOIN
    emp_record_table r ON e.EMP_ID = r.MANAGER_ID
    group by e.EMP_ID,e.FIRST_NAME; 
 
 /*
 7.	Write a query to list down all the employees from the healthcare and finance departments using union. 
 Take data from the employee record table.
*/

SELECT 
    EMP_ID, FIRST_NAME, DEPT
FROM
    emp_record_table
WHERE
    DEPT = 'healthcare' 
UNION SELECT 
    EMP_ID, FIRST_NAME, DEPT
FROM
    emp_record_table
WHERE
    DEPT = 'finance';



/*
8.	Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. 
Also include the respective employee rating along with the max emp rating 
for the department.
*/

SELECT 
    e.EMP_ID,
    e.FIRST_NAME,
    e.LAST_NAME,
    e.ROLE,
    e.DEPT,
    e.EMP_RATING,
    d.max_rating
  
FROM
    emp_record_table e
        JOIN
    (SELECT 
        DEPT, MAX(EMP_RATING) AS max_rating
    FROM
    emp_record_table 
    GROUP BY DEPT) d ON e.DEPT = d.DEPT;


/*
9.	Write a query to calculate the minimum and the maximum salary of the employees in each role.
 Take data from the employee record table.
*/
    
    SELECT 
    ROLE, 
    MIN(SALARY) AS min_salary, 
    MAX(SALARY) AS max_salary
FROM 
    emp_record_table
GROUP BY ROLE;

    
   

/*
10.	Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.
*/

SELECT EMP_ID, EXP, RANK() OVER (ORDER BY EXP DESC) FROM emp_record_table;

/*
11.	Write a query to create a view that displays employees in various countries whose salary is more than six thousand.
 Take data from the employee record table.
*/

CREATE VIEW EMPVIEW AS
    SELECT 
        EMP_ID, FIRST_NAME, COUNTRY, SALARY
    FROM
        emp_record_table
    WHERE
        SALARY > 6000
    GROUP BY COUNTRY
;


/*
12.	Write a nested query to find employees with experience of more than ten years. 
Take data from the employee record table.
*/

SELECT 
    *
FROM
    emp_record_table
WHERE
    EMP_ID IN (SELECT 
            EMP_ID
        FROM
            emp_record_table
        WHERE
            EXP > 10);



/*
13.	Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. 
Take data from the employee record table.
*/
DELIMITER $$
create procedure EMP_PRO()
BEGIN
SELECT 
    *
FROM
    emp_record_table
WHERE
    EXP > 3;
END $$
DELIMITER ;

CALL EMP_PRO();

/*
14.	Write a query using stored functions in the project table to check whether the job profile
 assigned to each employee in the data science team matches the organization’s set standard.

The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'.
*/




DELIMITER $$
CREATE function EMP_FUNC(EXP INT)
returns varchar(50)
deterministic
BEGIN
DECLARE STD_LEVEL VARCHAR (50) DEFAULT '' ;
IF EXP <= 2 THEN
        SET STD_LEVEL = 'JUNIOR DATA SCIENTIST';
    ELSEIF EXP > 2 AND EXP <= 5 THEN
        SET STD_LEVEL = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF EXP > 5 AND EXP <= 10 THEN
        SET STD_LEVEL = 'SENIOR DATA SCIENTIST';
    ELSEIF EXP > 10 AND EXP <= 12 THEN
        SET STD_LEVEL = 'LEAD DATA SCIENTIST';
    ELSEIF EXP > 12 AND EXP <= 16 THEN
        SET STD_LEVEL = 'MANAGER';
    ELSE
        SET STD_LEVEL = 'UNDEFINED';

END IF;
RETURN(STD_LEVEL);
END$$
DELIMITER ;

SELECT 
    e.PROJ_ID,
    e.FIRST_NAME,
    e.EXP,
    e.DEPT,
    e.ROLE as actual_role,
    EMP_FUNC(e.EXP) AS expected_role
FROM
    emp_record_table e
        JOIN
    proj_table p ON e.PROJ_ID = p.PROJECT_ID
WHERE
    e.ROLE like '%DATA SCIENTIST%';







/*
15.	Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
*/

create INDEX EMP_INDEX
ON emp_record_table (FIRST_NAME(20));


/*
16.	Write a query to calculate the bonus for all the employees, 
based on their ratings and salaries (Use the formula: 5% of salary * employee rating).
*/
SELECT 
    EMP_ID,
    FIRST_NAME,
    SALARY,
    EMP_RATING,
    (0.05 * SALARY * EMP_RATING) AS bonus
FROM
    emp_record_table;

 


/*
17.	Write a query to calculate the average salary distribution based on the continent 
and country. Take data from the employee record table.
*/     

select * from emp_record_table;
SELECT 
    COUNTRY, CONTINENT, AVG(SALARY) AS 'avg'
FROM
    emp_record_table
GROUP BY CONTINENT , COUNTRY;

