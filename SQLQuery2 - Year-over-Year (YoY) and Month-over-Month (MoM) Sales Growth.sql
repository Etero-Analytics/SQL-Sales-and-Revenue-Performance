--Year-over-Year (YoY) and Month-over-Month (MoM) Sales Growth
with MonthlySales as (
    select
        YEAR(OrderDate) SalesYear,
        MONTH(OrderDate) SalesMonth,
        SUM(Subtotal) MonthlyRevenue
    from Sales.SalesOrderHeader
    group by YEAR(OrderDate), MONTH(OrderDate)
),
GrowthCalc as (
    select
        SalesYear,
        SalesMonth,
        MonthlyRevenue,
        LAG(MonthlyRevenue, 1) over (order by SalesYear, SalesMonth) PrevMonthRevenue,
        LAG(MonthlyRevenue, 12) over (order by SalesYear, SalesMonth) PrevYearRevenue
    from MonthlySales
)
select
    SalesYear,
    SalesMonth,
    MonthlyRevenue,
    PrevMonthRevenue,
    ROUND((MonthlyRevenue - PrevMonthRevenue) / PrevMonthRevenue * 100.0, 2) MoM_Growth_PCT,
    PrevYearRevenue,
    ROUND((MonthlyRevenue - PrevYearRevenue) / PrevYearRevenue * 100.0, 2) YoY_Growth_PCT
from GrowthCalc
order by SalesYear, SalesMonth