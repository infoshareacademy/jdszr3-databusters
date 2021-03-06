-- Jakie roczniki? 1960-2015
select distinct i.rocznik from Indicators i 
order by i.rocznik desc
;

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