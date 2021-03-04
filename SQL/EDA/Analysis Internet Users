--Lista krajów - wartości z walutą
select distinct i.countryname 
,		c.currencyunit 
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
order by 1
;

-- Lista danych w latach 2000,2005,2010
with Internet users
(select *
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorname ='Internet users (per 100 people)'
and i."Year" in(2000, 2005, 2010)
)
select  g.countryname 
,		round(sum(value))
from internet users
group by g.countryname 
order by 2 desc
;

--Internet users (per 100 people)
--ilosc danych
select count(*)
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorname ='Internet users (per 100 people)'
;

--sprawdzenie dla jakich lat są podane wartości w zależności od kraju
select  i.countryname 
,		i."Year" as rok
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorname ='Internet users (per 100 people)'
order by 1,2
;

--Sprawdzenie dla jakich lat mamy podane wartosci
with lata as
(select  i.countryname 
,		i."Year" as rok
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorname ='Internet users (per 100 people)'
order by 2
)
select distinct rok 
from lata
;

-- Kraje, które w latach 2000, 2005,2010 mają najwyższą value
--Internet users (per 100 people)
select  i.countryname 
,		i."Year" as rok
,		round(sum(value))
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorname ='Internet users (per 100 people)'
group by i.countryname 
,		i."Year"
order by 2 desc
;

-- Kraje, które w latach 2000, 2005, 2010 mają najniższą value
--Internet users (per 100 people)
select  i.countryname 
,		i."Year" as rok
,		round(sum(value))
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorname ='Internet users (per 100 people)'
group by i.countryname 
,		i."Year"
order by 2 asc
;

-- Statystyki dla Internet users (per 100 people)
select  i.countryname 
,		avg(value) as srednia
,		min(value) as minimalna
,		max(value) as maksymalna
,		percentile_cont(0.5) within group (order by value) as mediana	
,		percentile_cont(0.25) within group (order by value) as q1
,		percentile_cont(0.75) within group (order by value) as q3
from indicators i
join country c on i.countrycode = c.countrycode 
where i.indicatorname ='Internet users (per 100 people)' and c.currencyunit <> ''
group by i.rocznik, i.countryname ;

-- YoY
with yoy as (
select   
		avg(value) as srednia
,		rocznik 	
from indicators
where i.indicatorname ='Internet users (per 100 people)' and c.currencyunit <> ''
group by rocznik 
)
select lag(srednia) over ()
,		srednia 
,		rocznik 
,		(srednia - lag(srednia) over() ) / lag(srednia) over () *100 as zmiana
from yoy 
;
-- pivot dla Internet users (per 100 people)
with pivot_users as
(select  i.countryname 
,		i.countrycode 
,		i.indicatorname 
,		i.indicatorcode 
,		i."Year" as rok
,		value 
,		c.currencyunit 
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorname ='Internet users (per 100 people)'
and  i."Year" in (2000,2005,2010)
order by i.countryname
)
select * 
from crosstab('select countryname::varchar(1024), rok::int4, value::numeric
				from pivot_users
				group by 1,2,3')
as	 last_result("countryname" varchar(1024)
,	 "2000" numeric
,	 "2005" numeric
,	 "2010" numeric
)
