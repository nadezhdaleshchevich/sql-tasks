use Northwind;

/* ������� 1

�������� ������, ������� ������� ������ ���������� � ���� �������, 
��������� �� ���� �������� CustomerID � CompanyName. 
������ ������� ������ ���� ������������� �� ���� ���������.
*/

select c.CustomerID, c.CompanyName
from.Customers as c
order by c.CustomerID asc;

/* ������� 2

�������� ������, ������� ������� EmployeeID ���������� �������� ��������� ����������.
*/

select top 1 e.EmployeeID
from Employees as e
order by e.HireDate desc

/* ������� 3

�������� ������, ������� ������� ������ ���� ����� �� ������� dbo.Customers.Country. 
������ ������ ���� ������������ � ���������� �������, ������ ��������� 
������ ���������� �������� � �� ������ ��������� ���������.
*/

select distinct c.Country 
from Customers as c
order by c.Country;

select c.Country 
from Customers as c
group by c.Country 
order by c.Country;

/* ������� 4

�������� ������, ������� ������� ������ �������� ��������-����������, 
������������� � �������� �������: ������, ������, ������, ��������, �����. 
������ ������ ���� ������������ �� ����-�������������� �������� � �������� ���������� �������.
*/

select c.CustomerID, c.City 
from Customers as c
where c.City in ('Berlin', 'London', 'Madrid', 'Brussels', 'Paris')
order by c.CustomerID desc;

/* ������� 5

�������� ������, ������� ������� ������ ��������������� ��������, 
��� ������� ������ ���� ���������� (dbo.Orders.RequiredDate) � �������� 1996 ����. 
������ ������ ���� ������������ � ���������� �������.
*/

select distinct o.CustomerID
from Orders as o
where YEAR(o.RequiredDate) = 1996
	and MONTH(o.RequiredDate) = 9
order by o.CustomerID  asc;
 

select distinct o.CustomerID
from Orders as o
where o.RequiredDate between '1996-09-01' and '1996-09-30' 
order by o.CustomerID  asc;

/* ������� 6

�������� ������, ������� ������� ��� ����������� ���� ��������-���������, 
��� ����� �������� ���������� � ���� "171" � �������� "77", � ����� ����� 
����� ���������� � ���� "171" � ������������ �� "50".
*/

select c.CompanyName, c.Phone, c.Fax
from Customers as c
where c.Phone like '(171)%77%' 
	and c.Fax like '(171)%50';

/* ������� 7

�������� ������, ������� ������� ���������� ��������-����������, ������� ��������� � �������, 
������������� ���� ������������� �������. �������������� ������� ������ �������� �� ���� 
������� City � CustomerCount.
*/

select c.City, COUNT(c.CustomerID)
from Customers as c
where c.Country in ('Norway', 'Sweden', 'Finland')
group by c.City;

/* ������� 8

�������� ������, ������� ������� ���������� ��������-���������� � �������, 
� ������� ���� 10 � ����� ����������. �������������� ������� ������ ����� ������� 
Country � CustomerCount, ������ ������� ������ ���� ������������� � �������� ������� 
�� ���������� ���������� � ������.
*/

select Country, COUNT(Customers.CustomerID) as CustomerCount
from Customers
group by Customers.Country
having COUNT(Customers.CustomerID) > 10
order by CustomerCount desc;

/* ������� 9

�������� ������, ������� ������� ������� ��������� ������ (dbo.Order.Freight) ������� ��� ��������-����������, 
������� ��������� ������ �������� ������ �����, ������������� �������������� ��� ������. �������������� 
��������� ������� �������� �������� ������� ��������� ������ ������ - ������ ��� ����� 100, ��� ������ 10. 
�������������� ������� ������ ����� ������� CustomerID � FreightAvg, �������� ������� ��������� ������ ���� 
��������� �� ������ ��������, ������ ������ ���� ������������� � �������� ������� �� �������� �������� �������� ������.
*/ 

select Orders.CustomerID, ROUND(AVG(Orders.Freight), 0) as FreightAvg
from Orders
where Orders.ShipCountry in ('Britain', 'Canada')
group by Orders.CustomerID
having AVG(Orders.Freight) >= 100 or AVG(Orders.Freight) < 10
order by FreightAvg desc

select *
from (select Orders.CustomerID, ROUND(AVG(Orders.Freight), 0) as FreightAvg
		from Orders
		where Orders.ShipCountry in ('Britain', 'Canada')
		group by Orders.CustomerID) as Customers
where FreightAvg >= 100 or FreightAvg < 10
order by FreightAvg desc

/* ������� 10

�������� ������, ������� ������� EmployeeID �������������� �������� ��������� ����������. 
����������� ��������� ��� ���������� ���������� �������� ����������.
*/

select top 1 Employees.EmployeeID
from Employees
where Employees.EmployeeID not in (select top 1 Employees.EmployeeID 
									from Employees 
									order by Employees.HireDate desc)
order by Employees.HireDate desc;

select top 1 Employees.EmployeeID
from Employees
where Employees.EmployeeID != (select top 1 Employees.EmployeeID 
								from Employees 
								order by Employees.HireDate desc)
order by Employees.HireDate desc;

/* ������� 11

�������� ������, ������� ������� EmployeeID �������������� �������� ��������� ����������. 
����������� �������� ����� OFFSET � FETCH.
*/

select Employees.EmployeeID
from Employees
order by Employees.HireDate desc
offset 1 rows
fetch FIRST 1 rows only;

/* ������� 12

�������� ������, ������� ������� ����� ����� ������� ������� ��� ��������-���������� ��� �������, 
��������� ������ ������� ������ ��� ����� ������� �������� ��������� ������ ���� �������, 
� ����� ���� �������� ������ ������ ��������� �� ������ �������� ���� 1996 ����. �������������� ������� 
������ ����� ������� CustomerID � FreightSum, ������ ������� ������ ���� ������������� �� ����� ������� �������.
*/

select Orders.CustomerID, SUM(Orders.Freight) as FreightSum
from Orders
where Orders.Freight >= (select AVG(Orders.Freight) from Orders)
	and Orders.ShippedDate between '1996-07-016' and '1996-07-31' 
group by Orders.CustomerID;

/* ������� 13

�������� ������, ������� ������� 3 ������ � ���������� ����������, ������� ���� ������� ����� 
1 �������� 1997 ���� ������������ � ���� ���������� � ������ ����� �������. ����� ��������� 
�������������� ��� ����� ��������� ������� ������ � ������ ��������. �������������� ������� 
������ ����� ������� CustomerID, ShipCountry � OrderPrice, ������ ������� ������ ���� ������������� 
�� ��������� ������ � �������� �������.
*/

select top 3 o.CustomerID, o.ShipCountry, (SUM(d.Quantity * d.UnitPrice - d.Discount)) as OrderPrice
from [Order Details] as d 
	inner join Orders as o on d.OrderID=o.OrderID
where o.OrderDate >= '1997-09-01'
	and o.ShipCountry in ('Argentina', 'Bolivia', 'Brazil', 'Venezuela', 'Guyana', 'French Guiana', 'Colombia', 'Paraguay', 'Peru', 'Suriname', 'Uruguay', 'Falkland Islands', 'Chile', 'Ecuador')	
group by o.OrderID, o.CustomerID, o.ShipCountry
order by OrderPrice desc;

/* ������� 14

���������� ������ � �������������� �����������:
*/

SELECT DISTINCT s.CompanyName,
(SELECT min(t.UnitPrice) FROM dbo.Products as t WHERE t.SupplierID = p.SupplierID) as MinPrice,
(SELECT max(t.UnitPrice) FROM dbo.Products as t WHERE t.SupplierID = p.SupplierID) as MaxPrice
FROM dbo.Products AS p
INNER JOIN dbo.Suppliers AS s ON p.SupplierID = s.SupplierID
ORDER BY s.CompanyName

select distinct s.CompanyName, MIN(p.UnitPrice), MAX(p.UnitPrice)
from Products as p 
	inner join Suppliers as s on p.SupplierID=s.SupplierID
group by s.CompanyName
order by s.CompanyName;

/* ������� 15

�������� ������, ������� ������� ������ ��������-���������� �� �������, ������� ������ ������ � 
����������� ����������� ����� � �������� �������� ����� ������ Speedy Express. �������������� 
������� ������ ����� ������� Customer � Employee, ������� Employee ������ ��������� FirstName � LastName 
����������.
*/

select c.CustomerID, (e.FirstName + ' ' + e.LastName) as Employee
from Customers as c
	right join Orders as o on c.CustomerID=o.CustomerID
	inner join Employees as e on o.EmployeeID=e.EmployeeID
	inner join Shippers as s on  o.ShipVia=s.ShipperID
where c.City='London'
	and e.City='London'
	and s.CompanyName='Speedy Express'

/* ������� 16

�������� ������, ������� ������� ������ ��������� �� ��������� Beverages � Seafood, ������� ����� �������� 
� ����������� (Discontinued) � ������� �������� �� ������ � ���������� ������ 20 ����. �������������� 
������� ������ ����� ������� ProductName, UnitsInStock, ContactName � Phone ����������. ������ ������� 
������ ���� ������������� �� �������� ���������� ������.
*/

select p.ProductName, p.UnitsInStock, s.ContactName, s.Phone
from Products as p 
	inner join Categories as c on p.CategoryID=c.CategoryID
	inner join Suppliers as s on p.SupplierID=s.SupplierID
where c.CategoryName in ('Beverages', 'Seafood')
	and p.Discontinued=0
	and p.UnitsInStock<20