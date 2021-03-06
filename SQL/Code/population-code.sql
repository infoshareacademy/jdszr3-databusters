1. 10 top with the highest Birthrate (Birth rate, crude (per 1,000 people)  "SP.DYN.CBRT.IN")
with krajetop as
(
select 
    i.countryname as kraj 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='SP.DYN.CBRT.IN' 
    and i.year = '2010'
order by i.value desc
limit 10
)
select
    kt.kraj
,   (select i2.value 
    from indicators i2
    join country c2 on i2.countrycode = c2.countrycode 
    where i2.indicatorcode='SP.DYN.CBRT.IN' 
    and i2.year = '2000'
    and i2.countryname=kt.kraj) as y2000
,   (select i2.value 
    from indicators i2
    join country c2 on i2.countrycode = c2.countrycode 
    where i2.indicatorcode='SP.DYN.CBRT.IN' 
    and i2.year = '2005'
    and i2.countryname=kt.kraj) as y2005
,   (select i2.value 
    from indicators i2
    join country c2 on i2.countrycode = c2.countrycode 
    where i2.indicatorcode='SP.DYN.CBRT.IN' 
    and i2.year = '2010'
    and i2.countryname=kt.kraj) as y2010
from krajetop kt
;
2.  10 top with the lowest Birthrate (Birth rate, crude (per 1,000 people)  "SP.DYN.CBRT.IN")
with krajetop as
(
select 
    i.countryname as kraj 
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='SP.DYN.CBRT.IN' 
    and i.year = '2010'
order by i.value 
limit 10
)
select
    kt.kraj
,   (select i2.value 
    from indicators i2
    join country c2 on i2.countrycode = c2.countrycode 
    where i2.indicatorcode='SP.DYN.CBRT.IN' 
    and i2.year = '2000'
    and i2.countryname=kt.kraj) as y2000
,   (select i2.value 
    from indicators i2
    join country c2 on i2.countrycode = c2.countrycode 
    where i2.indicatorcode='SP.DYN.CBRT.IN' 
    and i2.year = '2005'
    and i2.countryname=kt.kraj) as y2005
,   (select i2.value 
    from indicators i2
    join country c2 on i2.countrycode = c2.countrycode 
    where i2.indicatorcode='SP.DYN.CBRT.IN' 
    and i2.year = '2010'
    and i2.countryname=kt.kraj) as y2010
from krajetop kt
;
3.  Life expectancy at birth, total (years) "SP.DYN.LE00.IN" for 10 top with the highest Birthrate (Birth rate, crude (per 1,000 people) "SP.DYN.CBRT.IN")
SELECT CountryName, Value
    FROM Indicators
    JOIN Country using(CountryCode)
    WHERE Year IN (2010)
    AND Indicatorcode IN ('SP.DYN.LE00.IN')
    AND Region <> ''
    AND CountryName IN ('Niger', 'Angola', 'Chad', 'Mali', 'Somalia', 'Uganda', 'Burundi', 'Congo, Dem. Rep.', 'Gambia', 
    'The Burkina Faso')
    order by Value 
    
4. Life expectancy at birth, total (years) "SP.DYN.LE00.IN" for 10 top with the lowest Birthrate (Birth rate, crude (per 1,000 people)    "SP.DYN.CBRT.IN")
SELECT CountryName, Value
    FROM Indicators
    JOIN Country using(CountryCode)
    WHERE Year IN (2010)
    AND Indicatorcode IN ('SP.DYN.LE00.IN')
    AND Region <> ''
    AND CountryName IN ('Germany', 'Japan', 'Hungary', 'Liechtenstein', 'Bosnia and Herzegovina',
    'Singapore', 'Austria', 'Korea, Rep.', 'Latvia', 'Malta')
    order by Value desc
5. 10 countries with the lowest births attended by skilled health staff (% of total) rate, 
and their mortality rate,  neonatal. (The first 28 days of life) and life expectancy.
select i.countryname as kraj, i.Value
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='SH.STA.BRTC.ZS' 
    and i.year = '2010'
order by i.value 
limit 10
/*select i.countryname as kraj, i.Value
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='SH.DYN.NMRT' 
    and i.year = '2010'
    and i.countryname in ('South Sudan', 'Chad', 'Sudan', 'Bangladesh', 'Timor-Leste', 'Eritrea', 'Afghanistan', 'Lao PDR',
                        'Guinea-Bissau', 'Tanzania')
order by i.value 
limit 10
*/
/*select i.countryname as kraj, i.Value
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='SP.DYN.LE00.IN' 
    and i.year = '2010'
    and i.countryname in ('South Sudan', 'Chad', 'Sudan', 'Bangladesh', 'Timor-Leste', 'Eritrea', 'Afghanistan', 'Lao PDR',
                        'Guinea-Bissau', 'Tanzania')
order by i.value 
limit 10
*/
create view top_the_lowest as
    SELECT CountryName, Value, IndicatorCode 
    FROM Indicators
    JOIN Country using(CountryCode)
    WHERE Year IN (2010)
    AND Indicatorcode IN ('SH.STA.BRTC.ZS', 'SH.DYN.NMRT', 'SP.DYN.LE00.IN')
    AND CountryName IN ('South Sudan', 'Chad', 'Sudan', 'Bangladesh', 'Timor-Leste', 'Eritrea', 'Afghanistan', 'Lao PDR',
                        'Guinea-Bissau', 'Tanzania')
    order by Value desc, CountryName 
create view tabela_przest as
SELECT * FROM crosstab('select CountryName::text, IndicatorCode::text, Value::numeric from top_the_lowest
group by 1,2,3')
AS final_result("CountryName" text, "SH.DYN.NMRT" numeric, "SH.STA.BRTC.ZS" numeric, "SP.DYN.LE00.IN" numeric);
select "CountryName" as kraj, "SH.DYN.NMRT" as mortality_rate, "SH.STA.BRTC.ZS" as skilled_staff, 
"SP.DYN.LE00.IN" as life_expectancy from tabela_przest 
6. 10 countries with the highest births attended by skilled health staff (% of total) rate, 
and their mortality rate,  neonatal. (The first 28 days of life) and life expectancy.
select i.countryname as kraj, i.Value
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='SH.STA.BRTC.ZS' 
    and i.year = '2010'
    and i.countryname not in ('Palau')
order by i.value desc
limit 10
/*select i.countryname as kraj, i.Value
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='SH.DYN.NMRT' 
    and i.year = '2010'
    and i.countryname in ('Kazakhstan', 'Croatia', 'Slovenia', 'Ukraine', 'Belarus', 'Czech Republic', 'Cuba', 'Chile',
                        'Russian Federation', 'Fiji')
order by i.value 
limit 10
*/
/*select i.countryname as kraj, i.Value
from indicators i
join country c2 on i.countrycode = c2.countrycode 
where i.indicatorcode='SP.DYN.LE00.IN' 
    and i.year = '2010'
    and i.countryname in ('Kazakhstan', 'Croatia', 'Slovenia', 'Ukraine', 'Belarus', 'Czech Republic', 'Cuba', 'Chile',
                        'Russian Federation', 'Fiji')
order by i.value 
limit 10
*/
create view top_the_highest as
    SELECT CountryName, Value, IndicatorCode 
    FROM Indicators
    JOIN Country using(CountryCode)
    WHERE Year IN (2010)
    AND Indicatorcode IN ('SH.STA.BRTC.ZS', 'SH.DYN.NMRT', 'SP.DYN.LE00.IN')
    AND CountryName IN ('Kazakhstan', 'Croatia', 'Slovenia', 'Ukraine', 'Belarus', 'Czech Republic', 'Cuba', 'Chile',
                        'Russian Federation', 'Fiji')
    order by Value desc, CountryName 
create view tabela_przest2 as
SELECT * FROM crosstab('select CountryName::text, IndicatorCode::text, Value::numeric from top_the_highest
group by 1,2,3')
AS final_result("CountryName" text, "SH.DYN.NMRT" numeric, "SH.STA.BRTC.ZS" numeric, "SP.DYN.LE00.IN" numeric);
select "CountryName" as kraj, "SH.DYN.NMRT" as mortality_rate, "SH.STA.BRTC.ZS" as skilled_staff, 
"SP.DYN.LE00.IN" as life_expectancy from tabela_przest2