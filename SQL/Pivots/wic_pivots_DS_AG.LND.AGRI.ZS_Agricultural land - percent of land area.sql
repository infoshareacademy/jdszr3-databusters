--wszystkie kraje, czyli waluta nie pusta
select 
	*
from country c2 
where c2.currencyunit!=''
;

--wszystkie roczniki odczytów dla wskaŸnika "Agricultural land (% of land area)"
--do tabeli przestawnej
select distinct  
	i.rocznik  
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='AG.LND.AGRI.ZS' and c2.currencyunit!=''
order by i.rocznik 
;

--skrajne roczniki odczytów dla wskaŸnika "Agricultural land (% of land area)"
select distinct 
	first_value (i.rocznik) over() as newrocznik
,	last_value (i.rocznik) over() as oldrocznik
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='AG.LND.AGRI.ZS' and c2.currencyunit!=''
group by i.rocznik
;

--jaki jest najœwie¿szy odczyt wskaŸnika? 
--wiêkszoœæ krajów do 2013, tylko Kosovo 2007
select distinct 
	i.countryname 
,	max(i.rocznik) over (partition by i.countryname) as naj_rocznik 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='AG.LND.AGRI.ZS' and c2.currencyunit!=''
group by i.countryname, i.rocznik
order by i.countryname 
;

--wszystkie odczyty dla wskaŸnika "Agricultural land (% of land area)"
--wszystkie kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='AG.LND.AGRI.ZS' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
--	and i.rocznik = '2013'
order by i.countryname, i.rocznik 
;

--najwy¿sze 10 odczytów dla wskaŸnika "Agricultural land (% of land area)" dla 2013 roku
--tylko kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='AG.LND.AGRI.ZS' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2013'
order by i.value desc
limit 10
;

--najwy¿sze 10 odczytów dla wskaŸnika "Agricultural land (% of land area)" dla 2013 roku
--same nazwy krajów
select 
	i.countryname 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='AG.LND.AGRI.ZS' 
	and c2.currencyunit!=''
	and i.rocznik = '2013'
order by i.value desc
limit 10
;

--dane dla krajów top 10
--w odstêpach co 5 lat (2013, 2008, 2003)

with krajetop as
(
select 
	i.countryname as kraj 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='AG.LND.AGRI.ZS' 
	and c2.currencyunit!=''
	and i.rocznik = '2013'
order by i.value desc
limit 10
)
select
	kt.kraj
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='AG.LND.AGRI.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2013'
	and i2.countryname=kt.kraj) as value2013
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='AG.LND.AGRI.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2008'
	and i2.countryname=kt.kraj) as value2008
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='AG.LND.AGRI.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2003'
	and i2.countryname=kt.kraj) as value2003
from krajetop kt
;

--najni¿sze odczyty dla wskaŸnika "Agricultural land (% of land area)" dla 2013 roku
--wszystkie kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='AG.LND.AGRI.ZS' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2013'
order by i.value asc
limit 10
;

--najni¿sze 10 odczytów dla wskaŸnika "Agricultural land (% of land area)" dla 2013 roku
--same nazwy krajów
select 
	i.countryname 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='AG.LND.AGRI.ZS' 
	and c2.currencyunit!=''
	and i.rocznik = '2013'
order by i.value asc
limit 10
;

--dane dla krajów bottom 10
--w odstêpach co 5 lat (2013, 2008, 2003)

with krajebottom as
(
select 
	i.countryname as kraj 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='AG.LND.AGRI.ZS' 
	and c2.currencyunit!=''
	and i.rocznik = '2013'
order by i.value asc
limit 10
)
select
	kb.kraj
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='AG.LND.AGRI.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2013'
	and i2.countryname=kb.kraj) as value2013
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='AG.LND.AGRI.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2008'
	and i2.countryname=kb.kraj) as value2008
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='AG.LND.AGRI.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2003'
	and i2.countryname=kb.kraj) as value2003
from krajebottom kb
;



--widok z odczytami dla wskaŸnika "Agricultural land (% of land area)"
drop view v_AGRIZS;

create view v_AGRIZS as
(
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik as rocznik
,	i.value
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='AG.LND.AGRI.ZS' and c2.currencyunit!=''
order by i.countryname, i.rocznik
)
;


--tabela przestawna
SELECT *
FROM crosstab
(
'select
	agrizs.countryname::text  
,	agrizs.rocznik::text  
,	sum(agrizs.value)::numeric
--,	agrizs.value::numeric  
from v_agrizs agrizs 
group by agrizs.countryname, agrizs.rocznik
order by agrizs.countryname, agrizs.rocznik 
'
)
AS final_result
(
	   "kraj"  text
,      "1961"  numeric
,      "1962"  numeric
,      "1963"  numeric
,      "1964"  numeric
,      "1965"  numeric
,      "1966"  numeric
,      "1967"  numeric
,      "1968"  numeric
,      "1969"  numeric
,      "1970"  numeric
,      "1971"  numeric
,      "1972"  numeric
,      "1973"  numeric
,      "1974"  numeric
,      "1975"  numeric
,      "1976"  numeric
,      "1977"  numeric
,      "1978"  numeric
,      "1979"  numeric
,      "1980"  numeric
,      "1981"  numeric
,      "1982"  numeric
,      "1983"  numeric
,      "1984"  numeric
,      "1985"  numeric
,      "1986"  numeric
,      "1987"  numeric
,      "1988"  numeric
,      "1989"  numeric
,      "1990"  numeric
,      "1991"  numeric
,      "1992"  numeric
,      "1993"  numeric
,      "1994"  numeric
,      "1995"  numeric
,      "1996"  numeric
,      "1997"  numeric
,      "1998"  numeric
,      "1999"  numeric
,      "2000"  numeric
,      "2001"  numeric
,      "2002"  numeric
,      "2003"  numeric
,      "2004"  numeric
,      "2005"  numeric
,      "2006"  numeric
,      "2007"  numeric
,      "2008"  numeric
,      "2009"  numeric
,      "2010"  numeric
,      "2011"  numeric
,      "2012"  numeric
,      "2013"  numeric
)
;

--dynamika w ostatnich 5 latach
--oszukana, bo na prze³omie krajów zaci¹ga dane z poprzedniego kraju
select 
	agrizs.countryname  
,	agrizs.rocznik
,	agrizs.value::numeric as akt_rok
,	(lag(agrizs.value) over())::numeric as pop_rok
,	(agrizs.value-lag(agrizs.value) over())*100.0/lag(agrizs.value) over() as dynamika
from v_agrizs agrizs 
where agrizs.rocznik in ('2013', '2012', '2011', '2010', '2009')
order by agrizs.countryname, agrizs.rocznik 
;

--widok dla ostatnich 5 lat
drop view v_agrizs5;
create view v_agrizs5 as
select 
	agrizs.countryname  
,	agrizs.rocznik
,	agrizs.value::numeric as akt_rok
,	(lag(agrizs.value) over())::numeric as pop_rok
,	(agrizs.value-lag(agrizs.value) over())*100.0/lag(agrizs.value) over() as dynamika
from v_agrizs agrizs 
where agrizs.rocznik in ('2013', '2012', '2011', '2010', '2009')
order by agrizs.countryname, agrizs.rocznik 
;

--tabela przestawna dla ostatnich 5 lat

SELECT *
FROM crosstab
(
'select
	agrizs5.countryname::text  
,	agrizs5.rocznik::text  
,	sum(agrizs5.dynamika)::numeric
from v_agrizs5 agrizs5
group by agrizs5.countryname, agrizs5.rocznik
order by agrizs5.countryname, agrizs5.rocznik 
'
)
AS final_result
(
	   "kraj"  text
,      "2009"  numeric
,      "2010"  numeric
,      "2011"  numeric
,      "2012"  numeric
,      "2013"  numeric
)
;

