/* Classic Model Cars Company - Sales Rep Analysis
5 Data Tables used for this analysis are: Orders, Customers, Employees, Order Details, and Offices

Below query first combine necessary data from various tables into one dataset to show all clients, their corresponding sales reps, and sales per order.
Then, from there, the primary statement finds the top 5 sales reps by sales revenue along with the corresponding % of revenue compared to overall total sales.
This query can be easily adjusted in the primary SELECT statement to find the bottom sales reps by sales revenue as well.  
Or if stake holder wants to view client name breakouts rather than sales rep breakouts the primary SELECT statement can be adjusted to do so as well */

with empclient as (
select 
o.customerNumber,
c.customerName,
c.state,
c.salesRepEmployeeNumber,
concat (e.firstName, " ", e.lastName) as empName,
offices.city,
offices.territory,
od.orderNumber,
o.orderDate,
o.status,
(od.quantityOrdered * od.priceEach) as subtotal
from orders as o
join orderdetails as od on o.orderNumber = od.orderNumber
join customers as c on o.customerNumber = c.customerNumber
join employees as e on c.salesRepEmployeeNumber = e.employeeNumber
join offices on e.officeCode = offices.officeCode
where o.status = "Shipped"),

totalsales as (
select 
sum(od.quantityOrdered * od.priceEach) as total
from orderdetails as od)

select 
empclient.empName,
round (sum(empclient.subtotal),0) as repRevenueTotals,
round ((select * from totalsales),0) as grandTotal,
round ((sum(empclient.subtotal)/(select * from totalsales) * 100),1) as percentage
from empclient, totalsales
group by empclient.empName
order by repRevenueTotals desc
limit 5;




