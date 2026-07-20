--Regional sales performance and Territory Ranking

select
	st.[Group] Region,
	st.Name CountryTerritory,
	SUM(soh.Subtotal) TotalRevenue,
	COUNT(soh.SalesOrderID) OrderCount,
	DENSE_RANK() over (order by SUM(soh.Subtotal) desc) RevenueRank
from Sales.SalesOrderHeader soh
join Sales.SalesTerritory st
	on soh.TerritoryID = st.TerritoryID
Group By st.[Group], st.Name
Order By RevenueRank