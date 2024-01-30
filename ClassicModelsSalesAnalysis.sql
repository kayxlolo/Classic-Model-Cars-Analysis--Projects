/* Classic Model Cars Sales Analysis

Below we are analyzing the following:
- Sales Rep count
- Top 5 clients based on Sales
- Bottom 5 clients based on Sales
- List all products and corresponding units sold
- Average units sold per product 
- What products based on units sold are above average compared to all products sold?
	- include validation checks
*/

-- Sales Reps' current Client Count
select
c.salesRepEmployeeNumber,
e.firstName,
e.lastName,
count(distinct c.customerName) as clientCount
from customers c
join employees e on c.salesRepEmployeeNumber = e.employeeNumber
group by c.salesRepEmployeeNumber;

-- Top 5 clients (in Sales)
select 
o.customerNumber,
upper(c.customerName),
sum(od.quantityOrdered * od.priceEach) as total
from orders as o
join orderdetails as od on o.orderNumber = od.orderNumber
join customers as c on o.customerNumber = c.customerNumber
where o.status = "Shipped"
group by o.customerNumber
order by total desc
limit 5;

-- Lowest 5 Clients (in Sales)
select 
c.customerName,
o.customerNumber,
sum(od.quantityOrdered * od.priceEach) as total
from orders as o
join orderdetails as od on o.orderNumber = od.orderNumber
join customers as c on o.customerNumber = c.customerNumber
where o.status = "Shipped"
group by o.customerNumber
order by total asc
limit 5;

-- *** SAMPLE QUESTION: What products based on units sold are above average compared to all products sold? ***

-- 1) Find all products and total quantities
select 
productCode, 
sum(priceEach * quantityOrdered) as subtotal, 
sum(quantityOrdered) as total_quantity
from orderdetails
group by productCode
order by total_quantity desc;

-- 2) find the average units sold per product
select avg(quantityOrdered) from orderdetails; -- <- this is the average quantity ordered PER ORDER.  DONT use this for average. Need total qty avg. Use below.

-- 3) use WITH clause to group total quantities by product and getting average of total quantities for each product
with totalQTY as (
select 
productCode, 
sum(priceEach * quantityOrdered) as subtotal, 
sum(quantityOrdered) as total_quantity
from orderdetails
group by productCode
order by total_quantity desc)

select * from totalQTY
join (select avg (total_quantity) as total_avg
from totalQTY x) avgTotals
on totalQTY.total_quantity > avgTotals.total_avg;

-- Validation - Check 1 product subtotals
select
productCode,
priceEach,
quantityOrdered,
(priceEach * quantityOrdered) as subtotal
from orderdetails
where productCode = 'S10_1678';

-- Validation - Check 1 product quantity totals
select sum(priceEach * quantityOrdered)
from orderdetails
where productCode = 'S10_1678';