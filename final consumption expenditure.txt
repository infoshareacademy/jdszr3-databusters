--Final consumption expenditure (current US$)
--lata

select distinct  
	i.year  
from indicators i
join country c on i.countrycode = c.countrycode 
where i.indicatorcode='NE.CON.TOTL.CD' and c.currencyunit!=''
order by i.year 



--Final consumption expenditure (current US$)
--ilosc danych

select count()
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit != ''
and	 i.indicatorcode='NE.CON.TOTL.CD'
;

--Final consumption expenditure (current US$) 
--wartości uszeregowane latami i nazwa kraju

select  i.countryname 
,		i.year as rok
,	    i.indicatorcode 
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit != ''
and	 i.indicatorcode ='NE.CON.TOTL.CD'
order by 1,2
;

-- lista najwyzszych final consumption expenditure (limit 50) miedzy 2000-2014
--Final consumption expenditure (current US$) 

select  i.countryname 
,		sum(value)
,		i.year as rok
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit != '' and i.year between '2000' and '2014'
and	 i.indicatorcode ='NE.CON.TOTL.CD'
group by i.countryname 
,        i.year 
order by sum desc
limit 50
;

--moje bazgroly, brakuje USA w 2014
select  i.countryname 
,		sum(value)
,		i.year as rok
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit != '' and i.year = '2014'
and	 i.indicatorcode ='NE.CON.TOTL.CD'
group by i.countryname 
,        i.year 
order by sum desc
limit 50
;


select  i.countryname 
,		sum(value)
,		i.year as rok
from indicators i 
join country c on i.countrycode = c.countrycode 
where c.currencyunit != '' and i.countryname = 'United States'
and	 i.indicatorcode ='NE.CON.TOTL.CD'
group by i.countryname 
,        i.year 
order by sum desc
limit 50
;



