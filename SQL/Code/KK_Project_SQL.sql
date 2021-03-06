--Finding the best and worst countries
--Adjusted net national income per capita (current US$)

select i.countryname  
,		avg(value)
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorcode = 'NY.ADJ.NNTY.PC.CD'
and i."Year" in (2000, 2005, 2010)
group by i.countryname 
order by 2 desc
limit 10
;

--View for pivot
create view net_income as
select i.countryname  
,		i."Year" as rok
,		i.value 
from indicators i 
where i.countryname in ('Luxembourg'
,'Switzerland'
,'Norway'
,'Denmark'
,'United States'
,'Sweden'
,'Netherlands'
,'Qatar'
,'Japan'
,'Ireland')
and	 i.indicatorcode = 'NY.ADJ.NNTY.PC.CD'
and i."Year" in (2000, 2005, 2010)
group by i.countryname 
,		i."Year" 
,		i.value 
;

--Pivot with the best countries in 2000, 2005 and 2010
select * 
from crosstab('select countryname::varchar(1024), rok::int4, value::numeric
				from net_income
				group by 1,2,3')
as	 final_result("countryname" varchar(1024)
,	 "2000" numeric
,	 "2005" numeric
,	 "2010" numeric
)
;

--Check the presented values from the pivot

select i.countryname 
,		i."Year" 
,		avg(value)
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorcode = 'NY.ADJ.NNTY.PC.CD'
and i."Year" in (2000, 2005, 2010)
group by i.countryname 
,		i."Year" 
order by 1
;

--Finding the lowest countries
--Adjusted net national income per capita (current US$)

select i.countryname  
,		avg(value)
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorcode = 'NY.ADJ.NNTY.PC.CD'
and i."Year" in (2000, 2005, 2010)
group by i.countryname 
order by 2 asc
limit 10
;

--View for pivot
create view net_income_low as
select i.countryname  
,		i."Year" as rok
,		i.value 
from indicators i 
where i.countryname in ('Congo, Rep.'
,'Burundi'
,'Liberia'
,'Ethiopia'
,'Malawi'
,'Niger'
,'Congo, Dem. Rep.'
,'Sierra Leone'
,'Guinea'
,'Madagascar' )
and	 i.indicatorcode = 'NY.ADJ.NNTY.PC.CD'
and i."Year" in (2000, 2005, 2010)
group by i.countryname 
,		i."Year" 
,		i.value 
;

--Pivot with the lowest countries in 2000, 2005 and 2010
select * 
from crosstab('select countryname::varchar(1024), rok::int4, value::numeric
				from net_income_low
				group by 1,2,3')
as	 final_result("countryname" varchar(1024)
,	 "2000" numeric
,	 "2005" numeric
,	 "2010" numeric
)
;

-- Getting all countries 

select i.countryname  
,		avg(value)
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorcode = 'SI.POV.GINI'
and i."Year" in (2000, 2005, 2010)
group by i.countryname 
order by 2 desc


--countiries with high GINI and GDP
select i.countryname  
,		i."Year" 
,		sum(value)
from indicators i 
where i.countryname in('Chile'
,'Micronesia Fed. Sts.'
,'Bolivia'
,'South Africa'
,'Brazil'
,'Honduras'
,'Colombia')
and	 i.indicatorcode = 'NY.GDP.PCAP.CD'
and i."Year" in (2000, 2005, 2010)
group by 1,2
order by 2 desc

--View for pivot
create view GDPGINI as
select i.countryname  
,		i."Year" as rok
,		i.value 
from indicators i 
where i.countryname in ('Chile'
,'Micronesia Fed. Sts.'
,'Bolivia'
,'South Africa'
,'Brazil'
,'Honduras'
,'Colombia')
and	 i.indicatorcode = 'NY.GDP.PCAP.CD'
and i."Year" in (2000, 2005, 2010)
group by i.countryname 
,		i."Year" 
,		i.value 
;

--Pivot with the best countries in 2000, 2005 and 2010
select * 
from crosstab('select countryname::varchar(1024), rok::int4, value::numeric
				from GDPGINI 
				group by 1,2,3')
as	 final_result("countryname" varchar(1024)
,	 "2000" numeric
,	 "2005" numeric
,	 "2010" numeric
)
;

