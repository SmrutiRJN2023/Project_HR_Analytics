USE Project_hr;
SELECT * FROM hr1;
SELECT * FROM hr2;
CREATE TABLE hr3 AS SELECT * FROM hr1 INNER JOIN hr2 ON hr1.EmployeeNumber=hr2.EmployeeID;
SELECT * FROM hr3;
USE Project_hr;

-- TOTAL EMPLOYEES
SELECT COUNT(EmployeeCount) AS Total_Employee FROM hr3;

-- ATTRITION
SELECT COUNT(Attrition) AS Attrition FROM hr3 WHERE Attrition="Yes";

-- ACTIVE EMPLOYEES
SELECT COUNT(Attrition) AS Active_Employees FROM hr3 WHERE Attrition="No";

-- ATTRITION RATE
SELECT ROUND(((SELECT COUNT(Attrition) FROM hr3 WHERE Attrition="Yes")/ SUM(EmployeeCount))*100,2) AS Attrition_Rate FROM hr3;

-- AVERAGE AGE
SELECT ROUND(AVG(AGE)) AS AVG_Age FROM hr3;

-- AVERAGE MONTHLY INCOME
SELECT ROUND(AVG(MonthlyIncome)) AS AVG_MonthlyIncome FROM hr3;

-- AVERAGE YEARS AT COMPANY
SELECT ROUND(AVG(YearsAtCompany)) AS AVG_YearsAtCompany FROm hr3;

-- YEARS FROM DATE OF JOINING
SELECT Date_Joining,YEAR(Date_Joining) AS Year_Joining FROM hr3;

-- MONTHNUMBER FROM DATE OF JOINING
SELECT Date_Joining,MONTH(Date_Joining) AS Month_Joining FROM hr3;

-- MONTHFULLNAME FROM DATE OF JOINING
SELECT Date_Joining,MONTHNAME(Date_Joining) AS MonthName_Joining FROM hr3;

-- QUARTER FROM DATE OF JOINING
SELECT Date_Joining,Quarter(Date_Joining) AS Quarter_Joining FROM hr3;

-- YEAR MONTH FROM DATE OF JOINING
SELECT DATE_FORMAT(Date_Joining,"%Y-%M") AS YearMonth_Joining FROM hr3;

-- WEEKDAYNUMBER FROM DATE OF JOINING
SELECT Date_Joining,DAYOFWEEK(Date_Joining) AS WeekDay_Joining FROM hr3;

-- WEEKDAYNAME FROM DATE OF JOINING
SELECT Date_Joining, DAYNAME(Date_Joining) AS DayName_Joining FROM hr3;

-- FINANCIAL YEAR FROM DATE OF JOINING
SELECT Date_Joining,
CASE WHEN MONTH(Date_Joining)>=4 THEN
YEAR(Date_Joining)+1
ELSE YEAR(Date_Joining) END AS Financial_Year FROM hr3;
USE Project_hr;

-- FINANCIAL QUARTER FROM DATE OF JOINING
SELECT Date_Joining,
CASE WHEN MONTH(Date_Joining) BETWEEN 4 AND 6 THEN  CONCAT(( YEAR (Date_Joining)+1) ,  "-",  "QTR-1")
WHEN MONTH(Date_Joining) BETWEEN 7 AND 9 THEN CONCAT ((YEAR(Date_Joining)+1),"-", "QTR-2")
WHEN MONTH(Date_Joining) BETWEEN 10 AND 12 THEN CONCAT(( YEAR(Date_Joining)+1),"-" ,"QTR-3")
WHEN MONTH(Date_Joining) BETWEEN  1 AND 3 THEN CONCAT((YEAR(Date_Joining)),"-", "QTR-4")
END AS Financial_Quarter FROM hr3;

-- FINANCIAL MONTH FROM DATE OF JOINING
SELECT Date_Joining,
CASE WHEN MONTH(Date_Joining)>=4 THEN MONTH(Date_Joining)-3
ELSE MONTH(Date_Joining)+9
END AS Financial_Month FROM hr3;

USE Project_hr;
-- KPI-1 AVERAGE ATTRITION RATE FOR ALL THE DEPARTMENT
 SELECT (100*COUNT(*)/(SELECT COUNT(*) FROM hr3 WHERE Attrition="Yes"))/2 AS AVG_AttritionRate,Department FROM hr3  GROUP BY Department ORDER BY AVG_AttritionRate DESC;
 
CREATE VIEW aview AS SELECT (100*COUNT(*)/(SELECT COUNT(*) FROM hr3 WHERE Attrition="Yes"))/2 AS AVG_AttritionRate,Department FROM hr3 WHERE Department='Sales' OR Department='Research & Development' GROUP BY Department ORDER BY AVG_AttritionRate DESC;

SELECT * FROM aview;

-- KPI-2 AVERAGE HOURLYRATE OF MALE RESEARCH SCIENTIST
SELECT ROUND(AVG(HourlyRate),2) AS AVG_HourlyRate FROM hr3 WHERE Gender="Male" AND JobRole="Research Scientist";

 CREATE VIEW aview1 AS SELECT ROUND(AVG(HourlyRate),2) AS AVG_HourlyRate FROM hr3 WHERE  Gender="Female" AND JobRole="Research Scientist";
 
 SELECT * FROM aview1;
 
-- KPI-3 JOBROLEWISE ATTRITION RATE AND MONTHLY INCOME STATS
SELECT ROUND(((SELECT COUNT(ATTRITION) FROM hr3 WHERE Attrition="Yes")/ SUM(EmployeeCount))*100,2)/10 AS Attrition_Rate,ROUND(AVG(MonthlyIncome),2) AS AVG_MonthlyIncome,JobRole FROM hr3 GROUP BY JobRole ORDER BY AVG_Monthlyincome DESC;

CREATE VIEW  aview2 AS SELECT ROUND(((SELECT COUNT(ATTRITION) FROM hr3 WHERE Attrition="Yes")/ SUM(EmployeeCount))*100,2)/10 AS Attrition_Rate,ROUND(AVG(MonthlyIncome),2) AS AVG_MonthlyIncome,JobRole FROM hr3 WHERE JobRole IN ("Manager","Research Scientist","Developer","Sales Executive") GROUP BY JobRole ORDER BY AVG_Monthlyincome DESC;

SELECT * FROM aview2;

-- KPI-4 DEPARTMENTWISE AVERAGE OF WORKING YEARS
SELECT Department,ROUND(AVG(TotalWorkingYears),2) AS AVG_WorkingYears FROM hr3 GROUP BY Department ORDER BY AVG_WorkingYears DESC;

CREATE VIEW aview3 AS SELECT Department,ROUND(AVG(TotalWorkingYears),2) AS AVG_WorkingYears FROM hr3 WHERE Attrition="No" GROUP BY Department ORDER BY AVG_WorkingYears DESC;

SELECT * FROM aview3;

-- KPI-5 DEPARTMENTWISE NUMBER OF EMPLOYEES
SELECT Department,SUM(EmployeeCount) AS SUM_EmployeeCount FROM hr3 GROUP BY Department ORDER BY SUM_EmployeeCount DESC;

CREATE VIEW aview4 AS SELECT Department,SUM(EmployeeCount) AS SUM_EmployeeCount FROM hr3 WHERE Attrition="No" GROUP BY Department ORDER BY SUM_EmployeeCount DESC;

SELECT * FROM aview4;

-- KPI-6 NUMBER OF EMPLOYEES BASED ON EDUCATIONAL FIELD  
SELECT EducationField,SUM(EmployeeCount) AS SUM_EmployeeCount FROM hr3 GROUP BY EducationField ORDER BY SUM_EmployeeCount DESC;

CREATE VIEW aview5 AS SELECT EducationField,SUM(EmployeeCount) AS SUM_EmployeeCount FROM hr3 WHERE Attrition="No" GROUP BY EducationField ORDER BY SUM_EmployeeCount DESC;

SELECT* FROM aview5;

-- KPI-7 JOBROLE AND WORKLIFEBALANCE
SELECT JobRole,ROUND(AVG(WorkLifeBalance),2) AS AVG_WorkLifeBalance FROM hr3 GROUP BY JobRole ORDER BY AVG_WorkLifeBalance DESC;

CREATE VIEW aview6 AS SELECT JobRole,ROUND(AVG(WorkLifeBalance),2) AS AVG_WorkLifeBalance FROM hr3 WHERE Gender="Male" GROUP BY JobRole ORDER BY AVG_WorkLifeBalance DESC;

SELECT * FROM aview6;

-- KPI-8 JOBROLEWISE ATTRITION RATE AND YEAR SINCE LAST PROMOTION RELATION
SELECT ROUND(((SELECT COUNT(ATTRITION) FROM hr3 WHERE Attrition="Yes")/ SUM(EmployeeCount))*100,2)/10 AS Attrition_Rate,ROUND(AVG(YearsSinceLastPromotion),2) AS AVG_YearsSinceLastPromotion,JobRole FROM hr3 GROUP BY JobRole ORDER BY AVG_YearsSinceLastPromotion DESC;

CREATE VIEW aview7 AS SELECT ROUND(((SELECT COUNT(ATTRITION) FROM hr3 WHERE Attrition="Yes")/ SUM(EmployeeCount))*100,2)/10 AS Attrition_Rate,ROUND(AVG(YearsSinceLastPromotion),2) AS AVG_YearsSinceLastPromotion,JobRole FROM hr3 WHERE JobRole="Manager" OR JobRole="Research Scientist" GROUP BY JobRole ORDER BY AVG_YearsSinceLastPromotion DESC;

SELECT * FROM aview7;
USE Project_hr;
-- KPI-9 GENDER BASED PERCENTAGE OF EMPLOYEES
SELECT ROUND(((SELECT COUNT(Gender) FROM hr3 WHERE Gender="Male")/ SUM(EmployeeCount))  *100,2) AS Percentage_EmployeeMale, ROUND(((SELECT COUNT(Gender) FROM hr3 WHERE Gender="Female")/ SUM(EmployeeCount))  *100,2) AS Percentage_EmployeeFemale FROM hr3;

CREATE VIEW aview8 AS SELECT ROUND(((SELECT COUNT(Gender) FROM hr3 WHERE Gender="Male")/ SUM(EmployeeCount))  *100,2) AS Percentage_EmployeeMale, ROUND(((SELECT COUNT(Gender) FROM hr3 WHERE Gender="Female")/ SUM(EmployeeCount))  *100,2) AS Percentage_EmployeeFemale FROM hr3 WHERE YearsAtCompany<=10;

 SELECT * FROM aview8;
 
-- KPI-10 MONTHLY NEW HIRE AND ATTRITION
SELECT MONTHNAME(Date_Joining) AS MonthName_Joining,COUNT(*)  AS NewHire FROM hr3 WHERE TIMESTAMPDIFF(YEAR,Date_Joining,CURDATE())<=1 AND Attrition="Yes"  GROUP BY MonthName_Joining ORDER BY NewHire DESC;

-- KPI-11 DEPARTMENTWISE JOBROLE AND JOB SATISFACTION
SELECT Department,COUNT(JobRole)  AS  COUNT_JobRole ,ROUND(AVG(JobSatisfaction),2) AS AVG_JobSatisfaction FROM hr3 GROUP BY Department ORDER BY COUNT_JobRole DESC;

CREATE VIEW aview10 AS SELECT Department,COUNT(JobRole)  AS  COUNT_JobRole ,ROUND(AVG(JobSatisfaction),2) AS AVG_JobSatisfaction FROM hr3 WHERE Attrition="Yes" GROUP BY Department ORDER BY COUNT_JobRole DESC;

SELECT * FROM aview10;

