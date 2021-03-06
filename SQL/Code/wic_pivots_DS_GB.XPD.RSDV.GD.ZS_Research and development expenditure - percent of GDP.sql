--wszystkie kraje, czyli waluta nie pusta
select 
	*
from country c2 
where c2.currencyunit!=''
;

--wszystkie roczniki odczytów dla wskaŸnika "Research and development expenditure (% of GDP)"
--do tabeli przestawnej
select distinct  
	i.rocznik  
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='GB.XPD.RSDV.GD.ZS' and c2.currencyunit!=''
order by i.rocznik 
;

--skrajne roczniki odczytów dla wskaŸnika "Research and development expenditure (% of GDP)"
select distinct 
	first_value (i.rocznik) over() as newrocznik
,	last_value (i.rocznik) over() as oldrocznik
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='GB.XPD.RSDV.GD.ZS' and c2.currencyunit!=''
group by i.rocznik
;

--jaki jest najœwie¿szy odczyt wskaŸnika? 
--wiêkszoœæ krajów do 2013/2011
select distinct 
	i.countryname 
,	max(i.rocznik) over (partition by i.countryname) as naj_rocznik 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='GB.XPD.RSDV.GD.ZS' and c2.currencyunit!=''
group by i.countryname, i.rocznik
order by i.countryname 
;

--wszystkie odczyty dla wskaŸnika "Research and development expenditure (% of GDP)"
--wszystkie kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i.countryname = 'Denmark'
--	and i.rocznik = '2011'
order by i.countryname, i.rocznik 
;

--najwy¿sze 10 odczytów dla wskaŸnika "Research and development expenditure (% of GDP)" dla 2010 roku
--tylko kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2010'
order by i.value desc
limit 10
;

--najwy¿sze 10 odczytów dla wskaŸnika "Research and development expenditure (% of GDP)" dla 2011 roku
--same nazwy krajów
select 
	i.countryname as kraj
,	i.indicatorcode as wskaznik
,	i.rocznik as rocznik
,	i.value as wartosc
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i.rocznik::numeric between 2000 and 2010
order by 1, 3, 4 desc
--limit 10
;

--dane dla krajów top 10
--w odstêpach co 5 lat (2011, 2006, 2001, 1996)

with krajetop as
(
select 
	i.countryname as kraj 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i.rocznik = '2010'
order by i.value desc
limit 10
)
select
	kt.kraj
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2010'
	and i2.countryname=kt.kraj) 
	/
	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2000'
	and i2.countryname=kt.kraj) as trend_2010_vs_2000
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2010'
	and i2.countryname=kt.kraj) as value2010
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2005'
	and i2.countryname=kt.kraj) as value2005
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2000'
	and i2.countryname=kt.kraj) as value2000
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '1995'
	and i2.countryname=kt.kraj) as value1995
from krajetop kt
where
(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '1995'
	and i2.countryname=kt.kraj) notnull
and 
(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2000'
	and i2.countryname=kt.kraj) notnull
order by 2 desc
;
/*wniosek: wœród krajów, które maj¹ komplet odczytów w latach 2001-2011
najwiêkszy procentowo wzrost wydatków na R&D odnotowa³y kraje:
China
Slovenia
Korea, Rep.
Austria
Denmark
*/


--najni¿sze odczyty dla wskaŸnika "Research and development expenditure (% of GDP)" dla 2011 roku
--wszystkie kraje, czyli currency nie równa siê ''
select 
	c2.currencyunit
,	i.countryname 
,	i.indicatorcode 
,	i.rocznik
,	i.value 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
--	and i.countryname = 'Latvia'
	and i.rocznik = '2011'
order by i.value asc
limit 10
;

--najni¿sze 10 odczytów dla wskaŸnika "Research and development expenditure (% of GDP)" dla 2011 roku
--same nazwy krajów
select 
	i.countryname 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i.rocznik = '2011'
order by i.value asc
limit 10
;

--dane dla krajów bottom 10
--w odstêpach co 5 lat (2011, 2006, 2001, 1996)

with krajebottom as
(
select 
	i.countryname as kraj 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i.rocznik = '2011'
order by i.value asc
limit 30
)
select
	kb.kraj
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2011'
--	and i2.value notnull
	and i2.countryname=kb.kraj) 
	/
	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2001'
--	and i2.value notnull
	and i2.countryname=kb.kraj) as trend_2011_vs_2001
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2011'
--	and i2.value notnull
	and i2.countryname=kb.kraj) as value2011
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2006'
--	and i2.value notnull
	and i2.countryname=kb.kraj) as value2006
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2001'
--	and i2.value notnull
	and i2.countryname=kb.kraj) as value2001
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '1996'
--	and i2.value notnull
	and i2.countryname=kb.kraj) as value1996
from krajebottom kb
where
(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2001'
--	and i2.value notnull
	and i2.countryname=kb.kraj) notnull
and 
(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2006'
--	and i2.value notnull
	and i2.countryname=kb.kraj) notnull
order by 2 asc
;
/*wniosek: wœród krajów, które maj¹ komplet odczytów w latach 2001-2011
najwiêkszy procentowo spadek wydatków na R&D odnotowa³y kraje:
Trinidad and Tobago
Panama
Cuba
Madagascar
Kuwait
*/


--Dane szczegó³owe dla 5 krajów o najwiêkszej dynamice przyrostu procentowego wydatków na R&D

select 
	i.countryname as kraj
,	i.rocznik  as rocznik
,	i.value as kasaNaRD
from indicators i
where i.countryname = 'China' and i.indicatorcode='GB.XPD.RSDV.GD.ZS' and (i.rocznik)::numeric between 2001 and 2011
group by i.countryname, i.rocznik, i.value
;

-- tabela przestawna dla 5 wiod¹cych krajów
drop view v_RandDexp_top5;
create view v_RandDexp_top5 as
select 
	i.countryname as kraj
,	i.rocznik  as rocznik
,	i.value as wartosc
from indicators i 
where i.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and i.countryname in ('China', 'Slovenia', 'Korea, Rep.', 'Austria', 'Denmark')
	and (i.rocznik)::numeric between 2000 and 2010
;

drop view v_RandDexp_top5_pivot;
create view v_RandDexp_top5_pivot as
select *
from crosstab
(
'select 
	t5.kraj::text
,	t5.rocznik::numeric
,	t5.wartosc::numeric
from v_RandDexp_top5 t5 
'
)
as kraj_rocznikowo
(
	   "kraj"  text
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
)
;

--Œrednie wydatki w grupie 5 dominuj¹cych pañstw
with dane_top5 as
(
select 
	i.countryname as kraj
,	i.rocznik  as rocznik
,	i.value as wartosc
from indicators i 
where i.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and i.countryname in ('China', 'Slovenia', 'Korea, Rep.', 'Austria', 'Denmark')
	and (i.rocznik)::numeric between 2001 and 2011
)
select
	dane_top5.rocznik
,	avg(dane_top5.wartosc) as srednia_akt
,	lag(avg(dane_top5.wartosc)) over() as srednia_old
from dane_top5
group by dane_top5.rocznik
;

--Tworzê widok z 10 krajami o najwy¿szych wydatkach w 2010 roku
-- wykluczam Australiê, bo ma dziury w odczytach

drop view  v_RandD_top10;

create view v_RandD_top10 as
select 
	c2.currencyunit as waluta
,	i.countryname as kraj
,	i.indicatorcode as wskaznik 
,	i.rocznik as rocznik
,	i.value as wartosc
,	dense_rank() over (order by i.value desc) as ranking 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='GB.XPD.RSDV.GD.ZS' 
	and c2.currencyunit!=''
	and i.rocznik = '2010'
	and i.countryname not in ('Australia')
order by i.value desc
limit 10
;

-- Zestawiam dane za 2003-2010 dla najlepszych 10 krajów z v_RandD_top10
drop view  v_RandD_top10_dane;

create view v_RandD_top10_dane as
select 
	t10.ranking as ranking
,	i2.countryname as kraj 
,	i2.indicatorcode as wskaznik
,	i2.rocznik as rocznik
,	i2.value as wartosc
from indicators i2 
join v_RandD_top10 t10 on t10.kraj = i2.countryname
where i2.indicatorcode ='GB.XPD.RSDV.GD.ZS' 
	and i2.rocznik ::numeric between 2003 and 2010
order by 1, 4
;

--Tworzê tabelê przestawn¹ dla v_RandD_top10_dane

select *
from crosstab
(
'select 
	t10.kraj::text
,	t10.rocznik::numeric
,	t10.wartosc::numeric
from v_RandD_top10_dane t10 
'
)
as kraj_rocznikowo
(
	   "kraj"  text
,      "2003"  numeric
,      "2004"  numeric
,      "2005"  numeric
,      "2006"  numeric
,      "2007"  numeric
,      "2008"  numeric
,      "2009"  numeric
,      "2010"  numeric
)
;
