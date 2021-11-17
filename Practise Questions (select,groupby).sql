/*
Name :- Shruti Shivaji Lanke
Panther ID :- 002583158
Assignment 1 - Part I
*/

use largeco;

/*Q1
Question 1. Write a query to display the SKU (stock keeping unit), description, type,
base, category, and price for all products that have a PROD_BASE of Water and a
PROD_CATEGORY of Sealer. And, use aliases to each attribute. For instance,
PROD_DESCRIPT -> ‘product description’.
*/

SELECT PROD_SKU AS 'PRODUCT SKU CODE', PROD_DESCRIPT AS 'PRODUCT DESCRIPTION', PROD_TYPE AS 'PRODUCT TYPE', 
PROD_BASE AS 'PRODUCT BASE', PROD_CATEGORY AS 'PRODUCT CATEGORY', PROD_PRICE AS 'PRODUCT PRICE'
FROM lgproduct 
WHERE PROD_BASE = 'Water' AND PROD_CATEGORY =  'Sealer';

/*Q2
Write a query to display the employee number, last name, first name,
salary “from” date, salary end date, and salary amount for employees 83731, 83745,
and 84039. Sort the output by employee number and salary “from” date.
*/

SELECT EMP.EMP_NUM, EMP.EMP_LNAME, EMP.EMP_FNAME, SAL.SAL_FROM , SAL.SAL_END, SAL.SAL_AMOUNT 
FROM lgemployee AS EMP , lgsalary_history AS SAL  
WHERE 
EMP.EMP_NUM = SAL.EMP_NUM AND 
EMP.EMP_NUM IN (83731, 83745, 84039) 
ORDER BY EMP.EMP_NUM,SAL.SAL_FROM ASC;

/*Q3
Write a query to display the first name, last name, street, city, state, and
zip code of any customer who purchased a Foresters Best brand top coat between
July 15, 2017, and July 31, 2017. If a customer purchased more than one such
product, display the customer’s information only once in the output. Sort the output
by sate, last name, and then first name.
*/

SELECT DISTINCT(CUST_FNAME),CUST_LNAME,CUST_STREET,CUST_CITY,CUST_STATE,CUST_ZIP
FROM lgcustomer INNER JOIN lginvoice ON lgcustomer.CUST_CODE = lginvoice.CUST_CODE
INNER JOIN lgline ON lgline.INV_NUM = lginvoice.INV_NUM
INNER JOIN lgproduct ON lgproduct.PROD_SKU = lgline.PROD_SKU
INNER JOIN lgbrand ON lgbrand.BRAND_ID = lgproduct.BRAND_ID
WHERE PROD_CATEGORY = 'Top Coat'
AND BRAND_NAME = 'FORESTERS BEST'
AND INV_DATE BETWEEN '2017-07-15' AND '2017-07-31'
ORDER BY CUST_STATE,CUST_LNAME,CUST_FNAME ASC;

/*Q4
Write a query to display the employee number, last name, email address,
title, and department name of each employee whose job title ends in the word
“ASSOCIATE”. Sort the output by department name and employee title.
*/

SELECT EMP.EMP_NUM, EMP.EMP_LNAME, EMP.EMP_EMAIL, EMP.EMP_TITLE, DEPT.DEPT_NAME
FROM lgemployee as EMP
INNER JOIN lgdepartment AS DEPT ON EMP.DEPT_NUM = DEPT.DEPT_NUM
WHERE EMP.EMP_TITLE LIKE '%ASSOCIATE'
ORDER BY DEPT.DEPT_NAME,EMP.EMP_TITLE asc;



/*Q5
Write a query to display the number of products within each base and
type combination, sorted by base and then by type.
*/

SELECT PROD_BASE, PROD_TYPE, COUNT(PROD_SKU) AS NUMPRODUCTS
FROM lgproduct
GROUP BY PROD_TYPE, PROD_BASE
ORDER BY PROD_BASE, PROD_TYPE ASC;

/*Q6
Write a query to display the brand ID, brand name, and average price of
products of each brand. Sort the output by brand name. Results are shown with the
average price rounded to two decimal places.
*/

SELECT B.BRAND_ID, B.BRAND_NAME, ROUND(AVG(PROD_PRICE),2) AS AVGPRICE
FROM lgbrand AS B INNER JOIN lgproduct AS PROD
ON PROD.BRAND_ID = B.BRAND_ID
GROUP BY B.BRAND_ID
ORDER BY B.BRAND_NAME ASC;

/*Q7
Write a query to display the department number, department name,
department phone number, employee number, and last name of each department
manager. Sort the output by department name.
*/

SELECT D.DEPT_NUM, D.DEPT_NAME, D.DEPT_PHONE, EMP.EMP_NUM ,EMP.EMP_LNAME
FROM lgdepartment D INNER JOIN lgemployee EMP ON 
D.EMP_NUM = EMP.EMP_NUM
WHERE D.DEPT_NUM = EMP.DEPT_NUM
ORDER BY D.DEPT_NAME ASC;

/*Q8
Write a query to display the brand ID, brand name, brand type, and
average price (round to 2 decimal places) of products for the brand that has the
largest average product price. Results are shown with the average price rounded to
two decimal places.
*/

SELECT B.BRAND_ID,B.BRAND_NAME,B.BRAND_TYPE, ROUND(AVG(PROD.PROD_PRICE),2) as AVGPRICE
FROM lgbrand B INNER JOIN lgproduct PROD 
ON B.BRAND_ID = PROD.BRAND_ID
GROUP BY B.BRAND_ID,B.BRAND_NAME
HAVING ROUND(AVG(PROD.PROD_PRICE),2)  = 
(SELECT MAX(AVG_PRICE) FROM
(SELECT ROUND(AVG(PROD.PROD_PRICE),2) AS AVG_PRICE
FROM lgbrand B INNER JOIN lgproduct PROD 
ON B.BRAND_ID = PROD.BRAND_ID
GROUP BY B.BRAND_ID,B.BRAND_NAME) AS AVG_PRICE_CALC);


/*Q9
Write a query to display the manager name, department name,
department phone number, employee, customer name, invoice date, and invoice total
for the department manager of the employee who made a sale to a customer whose
last name is Hagan on May 18, 2017.
*/

SELECT MGR.EMP_FNAME,MGR.EMP_LNAME, D.DEPT_NAME, D.DEPT_PHONE,
EMP.EMP_FNAME,EMP.EMP_LNAME,C.CUST_FNAME, C.CUST_LNAME, I.INV_DATE, I.INV_TOTAL
FROM lgdepartment D , lgemployee MGR, lgemployee EMP, lgcustomer C, lginvoice I
WHERE 
D.EMP_NUM = MGR.EMP_NUM AND
D.DEPT_NUM = EMP.DEPT_NUM AND
EMP.EMP_NUM = I.EMPLOYEE_ID
AND
I.CUST_CODE = C.CUST_CODE 
AND C.CUST_LNAME = 'HAGAN' 
AND I.INV_DATE = '2017-05-18';


/* Q10	
The Binder Prime Company wants to recognize the employee who sold
the most of its products during a specified period. Write a query to display the
employee number, employee first name, employee last name, email address, and
total units sold for the employee who sold the most Binder Prime brand products
between November 1, 2017, and December 5, 2017. If there is a tie for most units,
sort the output by employee last name.
*/	

SELECT E.EMP_NUM,E.EMP_FNAME,E.EMP_LNAME,E.EMP_EMAIL,SUM(LINE_QTY) AS TOTAL 
FROM lgemployee E INNER JOIN lginvoice I ON E.EMP_NUM = I.EMPLOYEE_ID
INNER JOIN lgline L ON I.INV_NUM = L.INV_NUM 
INNER JOIN lgproduct P ON L.PROD_SKU = P.PROD_SKU
INNER JOIN lgbrand B ON P.BRAND_ID = B.BRAND_ID 
WHERE B.BRAND_NAME = 'BINDER PRIME'
AND I.INV_DATE BETWEEN '2017-11-01' AND '2017-12-05'
GROUP BY E.EMP_FNAME,E.EMP_LNAME,E.EMP_EMAIL
HAVING SUM(LINE_QTY) =
(
SELECT SUM(LINE_QTY) AS TOTAL 
FROM lgemployee E INNER JOIN lginvoice I ON E.EMP_NUM = I.EMPLOYEE_ID
INNER JOIN lgline L ON I.INV_NUM = L.INV_NUM 
INNER JOIN lgproduct P ON L.PROD_SKU = P.PROD_SKU
INNER JOIN lgbrand B ON P.BRAND_ID = B.BRAND_ID 
WHERE B.BRAND_NAME = 'BINDER PRIME'
AND I.INV_DATE BETWEEN '2017-11-01' AND '2017-12-05'
GROUP BY E.EMP_NUM
ORDER BY TOTAL DESC
LIMIT 1)
ORDER BY E.EMP_LNAME;


/*Q11 
LargeCo is planning a new promotion in Alabama (AL) and wants to
know about the largest purchases made by customers in that state. Write a query to
display the customer code, customer first name, last name, full address, invoice date,
and invoice total of the largest purchase made by each customer in AL. Be certain
to include any customers in AL who have never made a purchase; their invoice date
should be NULL and the invoice totals should display as 0. Sort the results by
customer last name, and then first name.
*/

SELECT C.CUST_CODE, C.CUST_FNAME, C.CUST_LNAME, C.CUST_STREET,C.CUST_CITY,C.CUST_STATE,C.CUST_ZIP,
I.INV_DATE, I.INV_TOTAL AS 'LARGEST INVOICE'
FROM lgcustomer C INNER JOIN lginvoice I
ON C.CUST_CODE = I.CUST_CODE
WHERE C.CUST_STATE='AL'
AND I.INV_TOTAL = 
(SELECT MAX(I2.INV_TOTAL) FROM lginvoice I2 WHERE I2.CUST_CODE = C.CUST_CODE)
UNION
SELECT C2.CUST_CODE, C2.CUST_FNAME, C2.CUST_LNAME, C2.CUST_STREET,C2.CUST_CITY,C2.CUST_STATE,C2.CUST_ZIP,
NULL, 0
FROM lgcustomer C2
WHERE C2.CUST_STATE='AL'
AND C2.CUST_CODE NOT IN (SELECT INV3.CUST_CODE FROM lginvoice INV3)
ORDER BY CUST_LNAME, CUST_FNAME;


/* Q12
The purchasing manager is still concerned about the impact of price on
sales. Write a query to display the brand name, brand type, product SKU, product
description, and price of any products that are not a premium brand, but that cost
more than the most expensive premium brand products.
 */

SELECT B.BRAND_NAME, B.BRAND_TYPE, P.PROD_SKU, P.PROD_DESCRIPT, P.PROD_PRICE
FROM lgbrand B INNER JOIN 
lgproduct P ON B.BRAND_ID = P.BRAND_ID
WHERE BRAND_TYPE != 'PREMIUM'
AND P.PROD_PRICE >
(
SELECT MAX(P.PROD_PRICE)
FROM lgbrand B 
INNER JOIN lgproduct P 
ON B.BRAND_ID = P.BRAND_ID
WHERE B.BRAND_TYPE = 'PREMIUM');

