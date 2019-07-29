use Northwind;

/* Задание 1

Напишите запрос, который выводит список заказчиков в виде таблицы, 
состоящей из двух столбцов CustomerID и CompanyName. 
Строки таблицы должны быть отсортированы по коду заказчика.
*/

select c.CustomerID, c.CompanyName
from.Customers as c
order by c.CustomerID asc;

/* Задание 2

Напишите запрос, который выводит EmployeeID последнего нанятого компанией сотрудника.
*/

select top 1 e.EmployeeID
from Employees as e
order by e.HireDate desc

/* Задание 3

Напишите запрос, который выводит список всех стран из колонки dbo.Customers.Country. 
Список должен быть отсортирован в алфавитном порядке, должен содержать 
только уникальные значения и не должен содержать дубликаты.
*/

select distinct c.Country 
from Customers as c
order by c.Country;

select c.Country 
from Customers as c
group by c.Country 
order by c.Country;

/* Задание 4

Напишите запрос, который выводит список названий компаний-заказчиков, 
расположенных в следущих городах: Берлин, Лондон, Мадрид, Брюссель, Париж. 
Список должен быть отсортирован по коду-идентификатору компании в обратном алфавитном порядке.
*/

select c.CustomerID, c.City 
from Customers as c
where c.City in ('Berlin', 'London', 'Madrid', 'Brussels', 'Paris')
order by c.CustomerID desc;

/* Задание 5

Напишите запрос, который выводит список идентификаторов компаний, 
для которых заказы были доставлены (dbo.Orders.RequiredDate) в сентябре 1996 года. 
Список должен быть отсортирован в алфавитном порядке.
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

/* Задание 6

Напишите запрос, который выводит имя контактного лица компании-заказчика, 
чей номер телефона начинается с кода "171" и содержит "77", а также номер 
факса начинается с кода "171" и оканчивается на "50".
*/

select c.CompanyName, c.Phone, c.Fax
from Customers as c
where c.Phone like '(171)%77%' 
	and c.Fax like '(171)%50';

/* Задание 7

Напишите запрос, который выводит количество компаний-заказчиков, которые находятся в городах, 
принадлежащих трем скандинавским странам. Результирующая таблица должна состоять из двух 
колонок City и CustomerCount.
*/

select c.City, COUNT(c.CustomerID)
from Customers as c
where c.Country in ('Norway', 'Sweden', 'Finland')
group by c.City;

/* Задание 8

Напишите запрос, который выводит количество компаний-заказчиков в странах, 
в которых есть 10 и более заказчиков. Результирующая таблица должна иметь колонки 
Country и CustomerCount, строки которой должны быть отсортированы в обратном порядке 
по количеству заказчиков в стране.
*/

select Country, COUNT(Customers.CustomerID) as CustomerCount
from Customers
group by Customers.Country
having COUNT(Customers.CustomerID) > 10
order by CustomerCount desc;

/* Задание 9

Напишите запрос, который выводит среднюю стоимость фрахта (dbo.Order.Freight) заказов для компаний-заказчиков, 
которые указывали местом доставки заказа город, принадлежащий Великобритании или Канаде. Дополнительным 
критерием выборки является значение средней стоимости фрахта заказа - больше или равно 100, или меньше 10. 
Результирующая таблица должна иметь колонки CustomerID и FreightAvg, значение средней стоимости должно быть 
округлено до целого значения, строки должны быть отсортированы в обратном порядке по значению среднего значения фрахта.
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

/* Задание 10

Напишите запрос, который выводит EmployeeID предпоследнего нанятого компанией сотрудника. 
Используйте подзапрос для исключения последнего нанятого сотрудника.
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

/* Задание 11

Напишите запрос, который выводит EmployeeID предпоследнего нанятого компанией сотрудника. 
Используйте ключевые слова OFFSET и FETCH.
*/

select Employees.EmployeeID
from Employees
order by Employees.HireDate desc
offset 1 rows
fetch FIRST 1 rows only;

/* Задание 12

Напишите запрос, который выводит общую сумму фрахтов заказов для компаний-заказчиков для заказов, 
стоимость фрахта которых больше или равна средней величине стоимости фрахта всех заказов, 
а также дата отгрузки заказа должна находится во второй половине июля 1996 года. Результирующая таблица 
должна иметь колонки CustomerID и FreightSum, строки которой должны быть отсортированы по сумме фрахтов заказов.
*/

select Orders.CustomerID, SUM(Orders.Freight) as FreightSum
from Orders
where Orders.Freight >= (select AVG(Orders.Freight) from Orders)
	and Orders.ShippedDate between '1996-07-016' and '1996-07-31' 
group by Orders.CustomerID;

/* Задание 13

Напишите запрос, который выводит 3 заказа с наибольшей стоимостью, которые были созданы после 
1 сентября 1997 года включительно и были доставлены в страны Южной Америки. Общая стоимость 
рассчитывается как сумма стоимости деталей заказа с учетом дисконта. Результирующая таблица 
должна иметь колонки CustomerID, ShipCountry и OrderPrice, строки которой должны быть отсортированы 
по стоимости заказа в обратном порядке.
*/

select top 3 o.CustomerID, o.ShipCountry, (SUM(d.Quantity * d.UnitPrice - d.Discount)) as OrderPrice
from [Order Details] as d 
	inner join Orders as o on d.OrderID=o.OrderID
where o.OrderDate >= '1997-09-01'
	and o.ShipCountry in ('Argentina', 'Bolivia', 'Brazil', 'Venezuela', 'Guyana', 'French Guiana', 'Colombia', 'Paraguay', 'Peru', 'Suriname', 'Uruguay', 'Falkland Islands', 'Chile', 'Ecuador')	
group by o.OrderID, o.CustomerID, o.ShipCountry
order by OrderPrice desc;

/* Задание 14

Перепишите запрос с использованием группировки:
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

/* Задание 15

Напишите запрос, который выводит список компаний-заказчиков из Лондона, которые делали заказы у 
сотрудников лондонского офиса и заказали доставку через службу Speedy Express. Результирующая 
таблица должна иметь колонки Customer и Employee, колонка Employee должна содержать FirstName и LastName 
сотрудника.
*/

select c.CustomerID, (e.FirstName + ' ' + e.LastName) as Employee
from Customers as c
	right join Orders as o on c.CustomerID=o.CustomerID
	inner join Employees as e on o.EmployeeID=e.EmployeeID
	inner join Shippers as s on  o.ShipVia=s.ShipperID
where c.City='London'
	and e.City='London'
	and s.CompanyName='Speedy Express'

/* Задание 16

Напишите запрос, который выводит список продуктов из категорий Beverages и Seafood, которые можно заказать 
у поставщиков (Discontinued) и которые остались на складе в количестве меньше 20 штук. Результирующая 
таблица должна иметь колонки ProductName, UnitsInStock, ContactName и Phone поставщика. Строки таблицы 
должны быть отсортированы по значению складского запаса.
*/

select p.ProductName, p.UnitsInStock, s.ContactName, s.Phone
from Products as p 
	inner join Categories as c on p.CategoryID=c.CategoryID
	inner join Suppliers as s on p.SupplierID=s.SupplierID
where c.CategoryName in ('Beverages', 'Seafood')
	and p.Discontinued=0
	and p.UnitsInStock<20