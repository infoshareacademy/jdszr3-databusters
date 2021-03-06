--correlation

--emission
create view v_RandD_top10 as
select 
	c2.currencyunit as waluta
,	i.countryname as kraj
,	i.indicatorcode as wskaznik 
,	i.rocznik as rocznik
,	i.value as wartosc
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EN.ATM.CO2E.KT' 
	and c2.currencyunit!=''
	and i.rocznik = '2010'
order by i.value desc
limit 10
;

--electric consumption
create view v_RandD_top as
select 
	c2.currencyunit as waluta
,	i.countryname as kraj
,	i.indicatorcode as wskaznik 
,	i.rocznik as rocznik
,	i.value as wartosc
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.USE.ELEC.KH.PC' 
	and c2.currencyunit!=''
	and i.rocznik = '2010'
order by i.value desc
limit 10
;

create view v_RandD_top_dane as
select 
	i2.countryname as kraj 
,	i2.indicatorcode as wskaznik
,	i2.rocznik as rocznik
,	i2.value as wartosc
from indicators i2 
join v_RandD_top t10 on t10.kraj = i2.countryname
where i2.indicatorcode ='EG.USE.ELEC.KH.PC' 
	and i2.rocznik ::numeric between 2003 and 2010
order by 1, 4
;


--emissions
create view v_RandD_top10_dane as
select 
	i2.countryname as kraj 
,	i2.indicatorcode as wskaznik
,	i2.rocznik as rocznik
,	i2.value as wartosc
from indicators i2 
join v_RandD_top10 t10 on t10.kraj = i2.countryname
where i2.indicatorcode ='EN.ATM.CO2E.KT' 
	and i2.rocznik ::numeric between 2003 and 2010
order by 1, 4
;
--renewable EG.ELC.RNWX.ZS

create view renew as
select 
	c2.currencyunit as waluta
,	i.countryname as kraj
,	i.indicatorcode as wskaznik 
,	i.rocznik as rocznik
,	i.value as wartosc
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='EG.ELC.RNWX.ZS' 
	and c2.currencyunit!=''
	and i.rocznik = '2010'
order by i.value desc
limit 10


create view renew_dane as
select 
	i2.countryname as kraj 
,	i2.indicatorcode as wskaznik
,	i2.rocznik as rocznik
,	i2.value as wartosc
from indicators i2 
join renew re on re.kraj = i2.countryname
where i2.indicatorcode ='EG.ELC.RNWX.ZS' 
	and i2.rocznik ::numeric between 2003 and 2010
order by 1, 4

--gdp
create view v_gdp as
select 
	c2.currencyunit as waluta
,	i.countryname as kraj
,	i.indicatorcode as wskaznik 
,	i.rocznik as rocznik
,	i.value as wartosc
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='NY.GDP.PCAP.CD' 
	and c2.currencyunit!=''
	and i.rocznik = '2010'
order by i.value desc
limit 30;

create view v_gdp_dane as
select 
	i2.countryname as kraj 
,	i2.indicatorcode as wskaznik
,	i2.rocznik as rocznik
,	i2.value as wartosc
from indicators i2 
join v_gdp t10 on t10.kraj = i2.countryname
where i2.indicatorcode ='NY.GDP.PCAP.CD' 
	and i2.rocznik ::numeric between 2003 and 2010
order by 1, 4

--kraje gdp
select distinct 
	vrtd.kraj as kraj
from v_gdp_dane vrtd 
--join v_RandD_top10_dane vitd on vitd.kraj = vrtd.kraj 
;

--kraje emissions
select distinct 
	vrtd.kraj as kraj
from v_RandD_top10_dane vrtd 
join v_RandD_top10_dane vitd on vitd.kraj = vrtd.kraj 
;


--korelacja
with fourcountries as
(
select 
	vrtd.kraj as kraj
,	vrtd.rocznik as rocznik
,	vrtd.wartosc as wart_emisji
,	round(vgdp.wartosc::numeric,2) as GDP_per_capita
,	cons.wartosc as consumption
,	re.wartosc as renewable
from v_RandD_top10_dane vrtd 
join v_gdp_dane vgdp on vgdp.kraj = vrtd.kraj 
join v_RandD_top_dane cons on vgdp.kraj = cons.kraj and vgdp.rocznik = cons.rocznik
join renew_dane re on vgdp.kraj = re.kraj 
--where vgdp.kraj in ('United States')
)
select
	corr(fc.wart_emisji, fc.GDP_per_capita) as korelacja_GDP_emission
,	corr(fc.consumption, fc.GDP_per_capita) as korelacja_GDP_consumption
,	corr(fc.renewable, fc.GDP_per_capita) as korelacja_GDP_renewable
from fourcountries fc
;
--'Iceland', 'Canada', 'Norway', 'United States', 'Qatar', 'Sweden'