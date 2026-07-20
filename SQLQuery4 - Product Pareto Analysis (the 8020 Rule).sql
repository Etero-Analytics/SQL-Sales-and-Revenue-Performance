--Product Pareto Analysis (the 80/20 Rule)
with ProductSales as (
    select
        p.Name ProductName,
        pc.Name CategoryName,
        sum(sod.LineTotal) ProductRevenue
    from Sales.SalesOrderDetail sod
    join Production.Product p on sod.ProductID = p.ProductID
    join Production.ProductSubcategory psc on p.ProductSubcategoryID = psc.ProductSubcategoryID
    join Production.ProductCategory pc on psc.ProductCategoryID = pc.ProductCategoryID
    group by p.Name, pc.Name
),
CumulativeSales as (
    select 
        ProductName,
        CategoryName,
        ProductRevenue,
        ROW_NUMBER() over (order by ProductRevenue desc) ProductRank,
        COUNT(*) over () TotalProducts,
        SUM(ProductRevenue) over (
            order by ProductRevenue desc 
            rows between unbounded preceding and current row
        ) RunningTotalRevenue,
        SUM(ProductRevenue) over () GrandTotalRevenue
    from ProductSales
)
select 
    ProductName,
    CategoryName,
    ProductRevenue,
    ProductRank,
    ROUND(RunningTotalRevenue * 100.0 / GrandTotalRevenue, 2) CumulativeRevenuePCT,
    ROUND(ProductRank * 100.0 / TotalProducts, 2) CumulativeProductPCT,
    case when RunningTotalRevenue * 100.0 / GrandTotalRevenue <= 80 
         then 'Top 80%' else 'Long Tail' end ParetoSegment
from CumulativeSales
order by ProductRevenue desc