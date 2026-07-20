-- Executive KPI Overview (The Foundation)
select 
    (select count(distinct SalesOrderID) from Sales.SalesOrderHeader) TotalOrders,
    (select sum(Subtotal) from Sales.SalesOrderHeader) TotalRevenue,
    (select avg(Subtotal) from Sales.SalesOrderHeader) AverageOrderValue,
    (select sum(OrderQty) from Sales.SalesOrderDetail) TotalUnitsSold