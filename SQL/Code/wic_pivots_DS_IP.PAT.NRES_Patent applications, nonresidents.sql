--wszystkie kraje, czyli waluta nie pusta
select 
	*
from country c2 
where c2.currencyunit!=''
;

--wszystkie roczniki odczytów dla wskaŸnika "Patent applications, nonresidents"
--do tabeli przestawnej
select distinct  
	i.rocznik  
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.PAT.NRES' and c2.currencyunit!=''
order by i.rocznik 
;

--skrajne roczniki odczytów dla wskaŸnika "Patent applications, nonresidents"
select distinct 
	first_value (i.rocznik) over() as newrocznik
,	last_value (i.rocznik) over() as oldrocznik
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.PAT.NRES' and c2.currencyunit!=''
group by i.rocznik
;

--jaki jest najœwie¿szy odczyt wskaŸnika? 
--wiêkszoœæ krajów do 2013, ale wiele te¿ wczeœniej 2007
select distinct 
	i.countryname 
,	max(i.rocznik) over (partition by i.countryname) as naj_rocznik 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.PAT.NRES' and c2.currencyunit!=''
group by i.countryname, i.rocznik
order by i.countryname 
;

--wszystkie odczyty dla wskaŸnika "Patent applications, nonresidents"
--wszystkie kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.PAT.NRES' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2013'
order by i.countryname, i.rocznik 
;

--najwy¿sze 10 odczytów dla wskaŸnika "Patent applications, nonresidents" dla 2013 roku
--tylko kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.PAT.NRES' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2013'
order by i.value desc
limit 10
;

--najwy¿sze 10 odczytów dla wskaŸnika "Patent applications, nonresidents" dla 2013 roku
--same nazwy krajów
select 
	i.countryname 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.PAT.NRES' 
	and c2.currencyunit!=''
	and i.rocznik = '2013'
order by i.value desc
limit 10
;

--dane dla krajów top 10
--w odstêpach co 5 lat (2013, 2008, 2003, 1998)

with krajetop as
(
select 
	i.countryname as kraj 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.PAT.NRES' 
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
	where i2.indicatorcode='IP.PAT.NRES' 
	and c2.currencyunit!=''
	and i2.rocznik = '2013'
	and i2.countryname=kt.kraj) as value2013
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.PAT.NRES' 
	and c2.currencyunit!=''
	and i2.rocznik = '2008'
	and i2.countryname=kt.kraj) as value2008
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.PAT.NRES' 
	and c2.currencyunit!=''
	and i2.rocznik = '2003'
	and i2.countryname=kt.kraj) as value2003
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.PAT.NRES' 
	and c2.currencyunit!=''
	and i2.rocznik = '1998'
	and i2.countryname=kt.kraj) as value1998
from krajetop kt
;

--najni¿sze odczyty dla wskaŸnika "Patent applications, nonresidents" dla 2013 roku
--wszystkie kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.PAT.NRES' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2013'
order by i.value asc
limit 10
;

--najni¿sze 10 odczytów dla wskaŸnika "Patent applications, nonresidents" dla 2013 roku
--same nazwy krajów
select 
	i.countryname 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.PAT.NRES' 
	and c2.currencyunit!=''
	and i.rocznik = '2013'
order by i.value asc
limit 10
;

--dane dla krajów bottom 10
--w odstêpach co 5 lat (2013, 2008, 2003, 1998)

with krajebottom as
(
select 
	i.countryname as kraj 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IP.PAT.NRES' 
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
	where i2.indicatorcode='IP.PAT.NRES' 
	and c2.currencyunit!=''
	and i2.rocznik = '2013'
	and i2.countryname=kb.kraj) as value2013
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.PAT.NRES' 
	and c2.currencyunit!=''
	and i2.rocznik = '2008'
	and i2.countryname=kb.kraj) as value2008
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.PAT.NRES' 
	and c2.currencyunit!=''
	and i2.rocznik = '2003'
	and i2.countryname=kb.kraj) as value2003
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='IP.PAT.NRES' 
	and c2.currencyunit!=''
	and i2.rocznik = '1998'
	and i2.countryname=kb.kraj) as value1998
from krajebottom kb
;