-- Które kraje wysteêpuj¹ w zestawieniach wszystkich 3 wskaŸników
select distinct 
	vrtd.kraj as kraj
from v_randd_top10_dane vrtd 
join v_tmk_top10_dane vitd on vitd.kraj = vrtd.kraj 
join v_art_top10_dane vatd on vatd.kraj = vrtd.kraj
;


-- Tworzê zestawienie 3 wskaŸników dla ('Japan', 'Korea, Rep.', 'Germany', 'France')
-- bo te kraje wystêpuj¹ we wszystkich trzech zestawieniach debeœciaków
-- I badam korelacje w latach 2003-2010, bo te s¹ wspólne

with fourcountries as
(
select 
	vrtd.kraj as kraj
,	vrtd.rocznik as rocznik
,	vrtd.wartosc as wart_RD
,	round(vitd.ips::numeric, 2) as liczba_TMK
,	round(vatd.articles::numeric, 2) as liczba_ART
,	round(vgdp.gdp::numeric, 2) as GDP_per_capita
,	round(vmob.mobile_per_100::numeric, 2) as mobiles_per_100
,	round(vint.internet_per_100::numeric, 2) as internet_per_100
from v_randd_top10_dane vrtd 
join v_tmk_top10_dane vitd on vitd.kraj = vrtd.kraj and vitd.rocznik = vrtd.rocznik 
join v_art_top10_dane vatd on vatd.kraj = vrtd.kraj and vatd.rocznik = vrtd.rocznik
join v_gdp_4_dane vgdp on vgdp.kraj = vrtd.kraj and vgdp.rocznik = vrtd.rocznik
join v_mobile_4_dane vmob on vmob.kraj = vrtd.kraj and vmob.rocznik = vrtd.rocznik
join v_internet_4_dane vint on vint.kraj = vrtd.kraj and vint.rocznik = vrtd.rocznik
where vrtd.kraj in ('Japan', 'Korea, Rep.', 'Germany', 'France')
)
select
	corr(fc.wart_RD, fc.liczba_TMK) as korelacja_RD_TMK
,	corr(fc.wart_RD, fc.liczba_ART) as korelacja_RD_ART
,	corr(fc.GDP_per_capita, fc.liczba_ART) as korelacja_GDP_ART
,	corr(fc.GDP_per_capita, fc.wart_RD) as korelacja_GDP_RD
,	corr(fc.GDP_per_capita, fc.liczba_TMK) as korelacja_GDP_TMK
,	corr(fc.wart_RD, fc.mobiles_per_100) as korelacja_RD_MOB
,	corr(fc.wart_RD, fc.internet_per_100) as korelacja_RD_INTERNET
,	corr(fc.GDP_per_capita, fc.mobiles_per_100) as korelacja_GDP_MOB
,	corr(fc.GDP_per_capita, fc.internet_per_100) as korelacja_GDP_INTERNET
from fourcountries fc
;

--Tworzê widok z 4 krajami z GDP per capita

drop view  v_GDP_4;

create view v_GDP_4 as
select 
	c2.currencyunit as waluta
,	i.countryname as kraj
,	i.indicatorcode as wskaznik 
,	i.rocznik as rocznik
,	i.value as gdp
,	dense_rank() over (order by i.value desc) as ranking 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='NY.GDP.PCAP.CD' 
	and c2.currencyunit!=''
	and i.rocznik = '2010'
	and i.countryname in ('Japan', 'Korea, Rep.', 'Germany', 'France')
order by i.value desc
;

-- Zestawiam dane za 2003-2010 dla 4 krajów z GDP
drop view  v_GDP_4_dane;

create view v_GDP_4_dane as
select 
	t10.ranking as ranking
,	i2.countryname as kraj 
,	i2.indicatorcode as wskaznik
,	i2.rocznik as rocznik
,	i2.value as gdp
from indicators i2 
join v_GDP_4 t10 on t10.kraj = i2.countryname
where i2.indicatorcode ='NY.GDP.PCAP.CD' 
	and i2.rocznik ::numeric between 2003 and 2010
order by 1, 4
;


--Tworzê widok z 4 krajami z Mobile per 100

drop view  v_mobile_4;

create view v_mobile_4 as
select 
	c2.currencyunit as waluta
,	i.countryname as kraj
,	i.indicatorcode as wskaznik 
,	i.rocznik as rocznik
,	i.value as mobile_per_100
,	dense_rank() over (order by i.value desc) as ranking 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IT.CEL.SETS.P2' 
	and c2.currencyunit!=''
	and i.rocznik = '2010'
	and i.countryname in ('Japan', 'Korea, Rep.', 'Germany', 'France')
order by i.value desc
;

-- Zestawiam dane za 2003-2010 dla 4 krajów z Mobile per 100
drop view  v_mobile_4_dane;

create view v_mobile_4_dane as
select 
	t10.ranking as ranking
,	i2.countryname as kraj 
,	i2.indicatorcode as wskaznik
,	i2.rocznik as rocznik
,	i2.value as mobile_per_100
from indicators i2 
join v_mobile_4 t10 on t10.kraj = i2.countryname
where i2.indicatorcode ='IT.CEL.SETS.P2' 
	and i2.rocznik ::numeric between 2003 and 2010
order by 1, 4
;

--Tworzê widok z 4 krajami z Internet per 100

drop view  v_internet_4;

create view v_internet_4 as
select 
	c2.currencyunit as waluta
,	i.countryname as kraj
,	i.indicatorcode as wskaznik 
,	i.rocznik as rocznik
,	i.value as internet_per_100
,	dense_rank() over (order by i.value desc) as ranking 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='IT.NET.USER.P2' 
	and c2.currencyunit!=''
	and i.rocznik = '2010'
	and i.countryname in ('Japan', 'Korea, Rep.', 'Germany', 'France')
order by i.value desc
;

-- Zestawiam dane za 2003-2010 dla 4 krajów z Internet per 100
drop view  v_internet_4_dane;

create view v_internet_4_dane as
select 
	t10.ranking as ranking
,	i2.countryname as kraj 
,	i2.indicatorcode as wskaznik
,	i2.rocznik as rocznik
,	i2.value as internet_per_100
from indicators i2 
join v_internet_4 t10 on t10.kraj = i2.countryname
where i2.indicatorcode ='IT.NET.USER.P2' 
	and i2.rocznik ::numeric between 2003 and 2010
order by 1, 4
;