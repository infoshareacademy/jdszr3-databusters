with krajetop as
(
select 
	i.countryname as kraj 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.ELC.RNWX.ZS' 
	and c2.currencyunit!=''
	and i.rocznik = '2005'
order by i.value desc 
limit 15
)
select
	kt.kraj
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EG.ELC.RNWX.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2000'
	and i2.countryname=kt.kraj) as value2000
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EG.ELC.RNWX.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2005'
	and i2.countryname=kt.kraj) as value2005
,	(select i2.value 
	from indicators i2
	join country c2 on i2.countrycode = c2.countrycode 
	where i2.indicatorcode='EG.ELC.RNWX.ZS' 
	and c2.currencyunit!=''
	and i2.rocznik = '2010'
	and i2.countryname=kt.kraj) as value2010
from krajetop kt
;


select * from indicators i 
where indicatorname like '%electri%'

select * from indicators i 
where indicatorcode like 'EG.ELC.RNWX.ZS'