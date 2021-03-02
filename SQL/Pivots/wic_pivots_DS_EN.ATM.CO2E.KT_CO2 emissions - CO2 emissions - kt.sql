--wszystkie kraje, czyli waluta nie pusta
select 
	*
from country c2 
where c2.currencyunit!=''
;

--wszystkie roczniki odczytów dla wskaŸnika "CO2 emissions (kt)"
--do tabeli przestawnej
select distinct  
	i.rocznik  
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EN.ATM.CO2E.KT' and c2.currencyunit!=''
order by i.rocznik 
;

--skrajne roczniki odczytów dla wskaŸnika "CO2 emissions (kt)"
select distinct 
	first_value (i.rocznik) over() as newrocznik
,	last_value (i.rocznik) over() as oldrocznik
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EN.ATM.CO2E.KT' and c2.currencyunit!=''
group by i.rocznik
;

--jaki jest najœwie¿szy odczyt wskaŸnika? 
--wiêkszoœæ krajów do 2011
select distinct 
	i.countryname 
,	max(i.rocznik) over (partition by i.countryname) as naj_rocznik 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EN.ATM.CO2E.KT' and c2.currencyunit!=''
group by i.countryname, i.rocznik
order by i.countryname 
;


--wszystkie odczyty dla wskaŸnika "CO2 emissions (kt)"
--wszystkie kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
--	and i.rocznik = '2013'
order by i.countryname, i.rocznik 
;

--najwy¿sze 10 odczytów dla wskaŸnika "CO2 emissions (kt)" dla 2011 roku
--tylko kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2011'
order by i.value desc
limit 10
;

--najwy¿sze 10 odczytów dla wskaŸnika "CO2 emissions (kt)" dla 2011 roku
--same nazwy krajów
select 
	i.countryname 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
	and i.rocznik = '2011'
order by i.value desc
limit 10
;

--dane dla krajów top 10
--w odstêpach co 5 lat (2011, 2006, 2001)

with krajetop as
(
select 
	i.countryname as kraj 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
	and i.rocznik = '2011'
order by i.value desc
limit 10
)
select
	kt.kraj
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
	and i2.rocznik = '2011'
	and i2.countryname=kt.kraj) as value2011
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
	and i2.rocznik = '2006'
	and i2.countryname=kt.kraj) as value2006
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
	and i2.rocznik = '2001'
	and i2.countryname=kt.kraj) as value2001
from krajetop kt
;

--najni¿sze odczyty dla wskaŸnika "CO2 emissions (kt)" dla 2011 roku
--wszystkie kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2011'
order by i.value asc
limit 10
;

--najni¿sze 10 odczytów dla wskaŸnika "CO2 emissions (kt)" dla 2011 roku
--same nazwy krajów
select 
	i.countryname 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
	and i.rocznik = '2011'
order by i.value asc
limit 10
;

--dane dla krajów bottom 10
--w odstêpach co 5 lat (2011, 2006, 2001)

with krajebottom as
(
select 
	i.countryname as kraj 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
	and i.rocznik = '2011'
order by i.value asc
limit 10
)
select
	kb.kraj
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
	and i2.rocznik = '2011'
	and i2.countryname=kb.kraj) as value2011
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
	and i2.rocznik = '2006'
	and i2.countryname=kb.kraj) as value2006
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
	and i2.rocznik = '2001'
	and i2.countryname=kb.kraj) as value2001
from krajebottom kb
;