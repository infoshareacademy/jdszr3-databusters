create database wic;
drop table country_csv;
delete from series_csv sc;
select * from series_csv sc;
select count(*) from series_csv sc;
select count(*) from series s ;

-- Ile krajów? 247 krajów
select count(distinct countrycode) 
from Indicators i 
;

-- Ile wskaŸników? 1344 wskaŸniki
select count(distinct i.IndicatorName)
from Indicators i 
;

-- Jakie roczniki? 1960-2015
select distinct i.rocznik from Indicators i 
order by i.rocznik desc
;

-- Czy któreœ pole jest null? Nie ma nulli
SELECT
	*
FROM Indicators i
where 
	i.CountryCode is NULL 
or 	i.CountryName is NULL 
or 	i.IndicatorCode is NULL 
or 	i.IndicatorName is NULL 
or 	i.Rocznik is NULL 
or 	i.Value is NULL 
;

SELECT
	i.IndicatorName 
,	i.Rocznik 
,	count(i.indicatorname) 
FROM Indicators i
--group by ROLLUP (i.IndicatorName, i.Rocznik)
group by (i.IndicatorName, i.Rocznik)
;

-- Ile tematów obejmuj¹ wskaŸniki? 91
select
	s.topic 
,	count(s.topic) 
from series s
group by s.topic 
;

-- Ile krajów ze strefy EUR? 19
select
	c.othergroups 
,	c.countrycode 
,	c.longname 
from country c 
where c.othergroups = 'Euro area'
;

-- Ile krajów ze strefy HIPC? 40
select
	c.othergroups 
,	c.countrycode 
,	c.longname 
from country c 
where c.othergroups = 'HIPC'
;

-- Ile krajów innych? 188
select
	c.othergroups 
,	c.countrycode 
,	c.longname 
from country c 
where c.othergroups='' 
;

-- Ile krajów w ró¿nych grupach?
select
	c.othergroups 
,	count(c.othergroups) 
from country c 
group by c.othergroups 
;

-- Ile krajów w ró¿nych regionach?
select
	c.region 
,	count(c.region) 
from country c 
group by c.region 
;

-- Ile krajów w ró¿nych grupach dochodowych?
select
	c.incomegroup 
,	count(c.incomegroup) 
from country c 
group by c.incomegroup 
;

create extension tablefunc;

select distinct
	i.indicatorname 
from indicators i 
;


--WskaŸniki posortowane wed³ug wskaŸnika->kraju->rocznika
select
	i.indicatorname 
,	i.countryname
,	i.rocznik 
,	i.value 
from indicators i
order by i.indicatorname, i.countryname, i.rocznik
;

--Liczba danych dla poszczególnych wskaŸników
select
	i.indicatorname
,	i.indicatorcode 
, 	count(*) as licznik
,	s2.topic
from indicators i
join series s2 on s2.seriescode = i.indicatorcode 
group by i.indicatorname, i.indicatorcode, s2.topic
--having count(*)>5000 and i.indicatorname ilike '%electricity%'
having s2.topic ilike '%Infrastructure: Technology%'
--having i.indicatorcode ilike '%1564%'
order by s2.topic
;

select	i2.indicatorcode 
,		i2.indicatorname
,		count(*)
from indicators i2 
where indicatorcode = 'SP.POP.1564.TO.ZS'
group by	i2.indicatorcode 
,			i2.indicatorname
;

select	seriescode 
,		topic
,		indicatorname 
from series s2 
where s2.indicatorname like '%electricity%'
;

select
	i.indicatorname
,	i.indicatorcode 
, 	count(*) as licznik
,	s2.topic 
--,	i.countryname 
from indicators i
join series s2 on s2.indicatorname = i.indicatorname 
group by i.indicatorname, i.indicatorcode, s2.topic
having count(*)>5000 
	and i.indicatorname in 
	(
'Adjusted net national income (current US$)'
,'Adjusted net national income per capita (current US$)'
,'Adjusted savings: education expenditure (current US$)'
,'Agriculture, value added (current US$)'
,'Agriculture, value added (% of GDP)'
,'Industry, value added (annual % growth)'
,'Industry, value added (% of GDP)'
,'Manufacturing, value added (annual % growth)'
,'Manufacturing, value added (% of GDP)'
,'Services, etc., value added (annual % growth)'
,'Services, etc., value added (% of GDP)'
,'Exports of goods and services (current US$)'
,'Exports of goods and services (% of GDP)'
,'Imports of goods and services (annual % growth)'
,'Imports of goods and services (% of GDP)'
,'Final consumption expenditure (current US$)'
,'Final consumption expenditure, etc. (current US$)'
,'GDP growth (annual %)'
,'GDP per capita growth (annual %)'
,'GDP per capita (current US$)'
,'GNI growth (annual %)'
,'GNI per capita growth (annual %)'
,'GNI (current US$)'
,'Inflation, consumer prices (annual %)'
,'Inflation, GDP deflator (annual %)'
,'Population density (people per sq. km of land area)'
,'Population in largest city'
,'Population in the largest city (% of urban population)'
,'Population in urban agglomerations of more than 1 million'
,'Population in urban agglomerations of more than 1 million (% of total population)'
,'Population growth (annual %)'
,'Population ages 65 and above (% of total)'
,'Population, female (% of total)'
,'Population, total'
,'Rural population'
,'Rural population (% of total population)'
,'Rural population growth (annual %)'
,'Urban population'
,'Urban population (% of total)'
,'Urban population growth (annual %)'
,'CO2 emissions (kg per 2005 US$ of GDP)'
,'CO2 emissions (kt)'
,'CO2 emissions (metric tons per capita)'
,'Electric power consumption (kWh per capita)'
,'Energy use (kg of oil equivalent per capita)'
,'Agricultural land (% of land area)'
,'Agricultural land (sq. km)'
,'Arable land (% of land area)'
,'Arable land (hectares per person)'
,'Arable land (hectares)'
,'Forest area (% of land area)'
,'Forest area (sq. km)'
,'Land area (sq. km)'
,'Surface area (sq. km)'
,'Life expectancy at birth, female (years)'
,'Life expectancy at birth, male (years)'
,'Life expectancy at birth, total (years)'
,'Birth rate, crude (per 1,000 people)'
,'Death rate, crude (per 1,000 people)'
,'Fixed telephone subscriptions'
,'Fixed telephone subscriptions (per 100 people)'
,'Internet users (per 100 people)'
,'Mobile cellular subscriptions'
,'Mobile cellular subscriptions (per 100 people)'
,'Patent applications, nonresidents'
,'Scientific and technical journal articles'
,'Trademark applications, direct nonresident'
,'Trademark applications, direct resident'
,'Trademark applications, total'
)
order by s2.topic
;


--Kategorie tematów w series - 91
with tematy as
(
select distinct 
	s.topic 
from series s 
order by s.topic
)
select 
	count(*)
from tematy
;


select *
--	i.indicatorname
--,	i.countryname 
--, 	count(*) as licznik
from indicators i
where i.indicatorname = 'Population, ages 15-64 (% of total)' and i.rocznik = 2010
;

--Wybrane wskaŸniki posortowane
with indic_sel as
(
select
	* 
from indicators i
where i.indicatorcode 
in ('NY.GDP.PCAP.CD', 
	'SH.XPD.TOTL.ZS', 
	'SI.POV.GINI', 
	'SH.DTH.IMRT', 
	'SL.MNF.0714.ZS', 
	'IT.NET.USER.P2',
	'EG.ELC.ACCS.ZS')
order by i.indicatorname, i.countryname, i.rocznik
)
select
	ins.indicatorcode
,	max(ins.rocznik) over (partition by rocznik)
from indic_sel ins
;

select
	s.seriescode 
,	s.longdefinition 
from series s 
where s.seriescode 
	in (	'IP.PAT.NRES'
		,	'IP.JRN.ARTC.SC'
		,	'IP.TMK.NRES'
		,	'IP.TMK.RESD'
		,	'IP.TMK.TOTL'
		,	'GB.XPD.RSDV.GD.ZS')
;

select
	s.topic 
,	s.seriescode 
,	s.indicatorname 
,	s.longdefinition 
from series s 
where s.topic = 'Infrastructure: Technology'
;
