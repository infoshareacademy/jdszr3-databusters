--Gini index
--ilosc danych
select count(*)
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorcode ='SI.POV.GINI'
;

--sprawdzenie dla jakich lat są podane wartości w zależności od kraju

select  i.countryname 
,		i."Year" as rok
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorcode ='SI.POV.GINI'
order by 1,2
;

--sprawdzenie dla jakich lat mamy podane wartosci
with lata as
(select  i.countryname 
,		i."Year" as rok
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorcode ='SI.POV.GINI'
order by 2
)
select distinct rok 
from lata
;

-- Kraje, które na przetrzeni wszystkich lat mają najwyższą value

select  i.countryname 
--,		i."Year" as rok
,		round(sum(value))
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorcode ='SI.POV.GINI'
group by i.countryname 
--,		i."Year"
order by 2 desc
;


--Sprawdzenie kwartyli i różnic pomiędzy
--ktore kraje mialy najzwyszy wzrost

with kwartyle as
(select i.countryname 
,		sum(i.value)
,		percentile_disc(0.25) within group (order by i.value) as q1
,		percentile_disc(0.5) within group (order by i.value)  as q2
,		percentile_disc(0.75) within group (order by i.value) as q3
,		percentile_disc(1) within group (order by i.value) as q4
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorcode ='SI.POV.GINI'
group by i.countryname
)
select  countryname 
,		round(q4-q1) as calkowity_wzrost
,		round(q4 - q2) as posredni
from kwartyle 
order by 2 desc
;

-- ktore kraje mialy najnizszy wzrost?

with kwartyle2 as
(select i.countryname 
,		sum(i.value)
,		percentile_disc(0.25) within group (order by i.value) as q1
,		percentile_disc(0.5) within group (order by i.value)  as q2
,		percentile_disc(0.75) within group (order by i.value) as q3
,		percentile_disc(1) within group (order by i.value) as q4
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit <> ''
and	 i.indicatorcode ='SI.POV.GINI'
group by i.countryname
)
select  countryname 
,		round(q4-q1) as calkowity_wzrost
,		round(q4 - q2) as posredni
from kwartyle2 
order by 2 asc
;

-- pivot 
with currency_4 as
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
and	 i.indicatorcode ='SI.POV.GINI'
and  i."Year" in (2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015)
order by i.countryname
)
select * 
from crosstab('select countryname::varchar(1024), rok::int4, value::numeric
				from currency_4
				group by 1,2,3')
as	 final_result("countryname" varchar(1024)
,	 "2000" numeric
,	 "2001" numeric
,	 "2002" numeric
,	 "2003" numeric
,	 "2004" numeric
,	 "2005" numeric
,	 "2006" numeric
,	 "2007" numeric
,	 "2008" numeric
,	 "2009" numeric
,	 "2010" numeric
,	 "2011" numeric
,	 "2012" numeric
,	 "2013" numeric
,	 "2014" numeric
)
;