-- Classic Models Company


-- Orders and Sales Query using Orders, Order Details, Customers, and Products Tables
select 
os.customerNumber,
c.customerName,
os.orderDate,
os.shippedDate,
ods.orderNumber,
ods.productCode,
p.productName,
ods.quantityOrdered,
ods.priceEach,
(ods.quantityOrdered * ods.priceEach) as 'subtotal',
os.status
from orderdetails as ods
join products as p 
on ods.productCode = p.productCode
join orders as os 
on os.orderNumber = ods.orderNumber
join customers as c
on c.customerNumber = os.customerNumber
where os.status = 'shipped'
order by orderNumber ASC;

-- Sales by Rep and Location Query using Orders, Order Details, Customers, Employees, Offices Tables
select 
o.customerNumber,
c.customerName,
c.state,
c.salesRepEmployeeNumber,
concat(e.firstName, " ",e.lastName) as empName,
e.officeCode,
offices.city,
offices.state,
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
where o.status = "Shipped";