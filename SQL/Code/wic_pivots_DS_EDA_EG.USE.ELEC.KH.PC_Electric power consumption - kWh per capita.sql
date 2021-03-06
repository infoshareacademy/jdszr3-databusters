--wszystkie kraje, czyli waluta nie pusta
select 
	*
from country c2 
where c2.currencyunit!=''
;

--wszystkie roczniki odczytów dla wskaŸnika "Electric power consumption (kWh per capita)"
--do tabeli przestawnej
select distinct  
	i.rocznik  
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.USE.ELEC.KH.PC' and c2.currencyunit!=''
order by i.rocznik 
;

--skrajne roczniki odczytów dla wskaŸnika "Electric power consumption (kWh per capita)"
select distinct 
	first_value (i.rocznik) over() as newrocznik
,	last_value (i.rocznik) over() as oldrocznik
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.USE.ELEC.KH.PC' and c2.currencyunit!=''
group by i.rocznik
;

--jaki jest najœwie¿szy odczyt wskaŸnika? 
--wiêkszoœæ krajów do 2012, tylko Benin 2008
select distinct 
	i.countryname 
,	max(i.rocznik) over (partition by i.countryname) as naj_rocznik 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.USE.ELEC.KH.PC' and c2.currencyunit!=''
group by i.countryname, i.rocznik
order by i.countryname 
;

--wszystkie odczyty dla wskaŸnika "Electric power consumption (kWh per capita)"
--wszystkie kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
--	and i.rocznik = '2013'
order by i.countryname, i.rocznik 
;

--najwy¿sze 10 odczytów dla wskaŸnika "Electric power consumption (kWh per capita)" dla 2012 roku
--tylko kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2012'
order by i.value desc
limit 10
;

--najwy¿sze 10 odczytów dla wskaŸnika "Electric power consumption (kWh per capita)" dla 2012 roku
--same nazwy krajów
select 
	i.countryname 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
	and i.rocznik = '2012'
order by i.value desc
limit 10
;

--dane dla krajów top 10
--w odstêpach co 5 lat (2012, 2007, 2002)

with krajetop as
(
select 
	i.countryname as kraj 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
	and i.rocznik = '2012'
order by i.value desc
limit 10
)
select
	kt.kraj
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2012'
	and i2.countryname=kt.kraj) as value2012
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2007'
	and i2.countryname=kt.kraj) as value2007
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2002'
	and i2.countryname=kt.kraj) as value2002
from krajetop kt
;

--najni¿sze odczyty dla wskaŸnika "Electric power consumption (kWh per capita)" dla 2012 roku
--wszystkie kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2012'
order by i.value asc
limit 10
;

--najni¿sze 10 odczytów dla wskaŸnika "Electric power consumption (kWh per capita)" dla 2012 roku
--same nazwy krajów
select 
	i.countryname 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
	and i.rocznik = '2012'
order by i.value asc
limit 10
;

--dane dla krajów bottom 10
--w odstêpach co 5 lat (2012, 2007, 2002)

with krajebottom as
(
select 
	i.countryname as kraj 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
	and i.rocznik = '2012'
order by i.value asc
limit 10
)
select
	kb.kraj
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2012'
	and i2.countryname=kb.kraj) as value2012
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2007'
	and i2.countryname=kb.kraj) as value2007
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
	and i2.rocznik = '2002'
	and i2.countryname=kb.kraj) as value2002
from krajebottom kb
;

--widok z odczytami dla wskaŸnika "Electric power consumption (kWh per capita)"
drop view v_indi1;

create view v_indi1 as
(
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik as rocznik
,	i.value
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.USE.ELEC.KH.PC' and c2.currencyunit!=''
order by i.countryname, i.rocznik
)
;


--tabela przestawna
SELECT *
FROM crosstab
(
'select
	indi1.countryname::text  
,	indi1.rocznik::text  
,	sum(indi1.value)::numeric
--,	indi1.value::numeric  
from v_indi1 indi1 
group by indi1.countryname, indi1.rocznik
order by indi1.countryname, indi1.rocznik 
'
)
AS final_result
(
	   "kraj"  text
,      "1960"  numeric
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
)
;

--w ostatnich 5 latach
select 
	vi.countryname  
,	vi.rocznik
,	vi.value::numeric as akt_rok
,	(lag(vi.value) over())::numeric as pop_rok
,	(vi.value-lag(vi.value) over())*100.0/lag(vi.value) over() as dynamika
from v_indi1 vi 
where vi.rocznik in ('2012', '2011', '2010', '2009', '2008')
order by vi.countryname, vi.rocznik 
;

select 
	vi.countryname  
,	vi.rocznik
,	vi.value::numeric as akt_rok
,	(lag(vi.value) over())::numeric as pop_rok
,	(vi.value-lag(vi.value) over())*100.0/lag(vi.value) over() as dynamika
from v_indi1 vi 
where vi.rocznik in ('2012', '1961') and vi.countryname = 'Australia'
order by vi.countryname, vi.rocznik 
;