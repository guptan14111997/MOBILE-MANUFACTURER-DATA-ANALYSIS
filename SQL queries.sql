

use db_SQLCaseStudies;

-- Q1--BEGIN 
	
-- 1. List all the states in which we have customers who have bought cellphones 
-- from 2005 till today

Select distinct state from dim_customer as c
Left join fact_transactions as t
On c.idcustomer = t.idcustomer
left join dim_location as l
on l.idlocation = t.idlocation
where dte >= '2005-01-01';


-- Q1--END

-- Q2--BEGIN
-- What state in the US is buying the most 'Samsung' cell phones?


    
select state from fact_transactions as t
left join dim_location as l
on l.idlocation = t.idlocation
left join dim_model as M
on T.idmodel= M.idmodel
left join dim_manufacturer as A
on M.idmanufacturer = A.idmanufacturer 
where country = 'US'
and manufacturer_name= 'SAMSUNG'
group by state, manufacturer_name
order by sum(quantity) desc
limit 1;


-- Q2--END

-- Q3--BEGIN      
	
--  Show the number of transactions for each model per zip code per state.

Select idmodel, zipcode, state, count(*)
As tran_cnt from fact_transactions as t
left join dim_location as l
on l.idlocation = t.idlocation
Group by idmodel, zipcode, state
Order by idmodel, state;

-- Q3--END

-- Q4--BEGIN

-- 4. Show the cheapest cellphone (Output should contain the price also)

select distinct model_name, unit_price from fact_transactions as t
left join dim_model as m
on t.idmodel = m.idmodel
order by unit_price 
limit 1;


-- Q4--END

-- Q5--BEGIN
 -- Find out the average price for each model in the top5 manufacturers in 
 -- terms of sales quantity and order by average price.
 
select t.idmodel, avg(totalprice) as avgprice from fact_transactions as t
left join dim_model as m
on t.idmodel = m.idmodel

where idmanufacturer in (select idmanufacturer from
						(select m.idmanufacturer, manufacturer_name, avg(quantity), sum(totalprice)  from fact_transactions as t
						left join dim_model as m
						on t.idmodel = m.idmodel
						left join dim_manufacturer as a
						on m.idmanufacturer= a.idmanufacturer
						group by idmanufacturer, manufacturer_name
						order by sum(quantity) desc
						limit  5) as x)
group by idmodel
order by avgprice desc;



-- Q5--END

-- Q6--BEGIN


 -- List the names of the customers and the average amount spent in 2009, 
-- where the average is higher than 500

select customer_name, avg(totalprice) as avgamt from dim_customer as c
left join fact_transactions as t
on c.idcustomer = t.idcustomer
left join dim_date as d
on d.dte = t.dte
where yr = '2009'
group by customer_name
having avg(totalprice) > 500;


-- Q6--END
	
-- Q7--BEGIN  
	-- 7. List if there is any model that was in the top 5 in terms of quantity, 
	-- simultaneously in 2008, 2009 and 2010
    
    select idmodel from
   (select idmodel , sum(quantity) from fact_transactions
    where year(dte) = '2009'
    group by idmodel
    order by sum(quantity) desc
    limit 5) as a
    intersect
    select idmodel from
	(select idmodel , sum(quantity) from fact_transactions
    where year(dte) = '2008'
    group by idmodel
    order by sum(quantity) desc
    limit 5) as b
    intersect
    select idmodel from
     ( select idmodel , sum(quantity) from fact_transactions
    where year(dte) = '2010'
    group by idmodel
    order by sum(quantity) desc
    limit 5) as c;

    
 -- ---------------------------OR------------------------------------------------------------------------------------------------------------------   
    
    
select  idmodel, sum(qty_2009), sum(qty_2008), sum(qty_2010) from
(select idmodel, case when year(t.dte) = '2009' 
                then sum(quantity)
                else 0
                end as qty_2009,
                                    case when year(t.dte) = '2008'
									then sum(quantity)
									else 0
									end as qty_2008,
                                                           case when year(t.dte) = '2010' 
															then sum(quantity)
															else 0
															end as qty_2010
                
from fact_transactions as t
left join dim_date as d
on d.dte = t.dte
group by idmodel, year(t.dte), t.dte
order by qty_2008 desc) as x
group by idmodel
limit 1;


-- Q7--END	
-- Q8--BEGIN

--  Show the manufacturer with the 2nd top sales in the year of 2009 and the 
--  manufacturer with the 2nd top sales in the year of 2010.

select * from
(select manufacturer_name, year(t.dte) as yr, sum(totalprice) as sale from fact_transactions as t
left join dim_model as m
on t.idmodel = m.idmodel
left join dim_manufacturer as a
on m.idmanufacturer= a.idmanufacturer
left join dim_date as d
on d.dte = t.dte
where yr = '2009'
group by manufacturer_name, year(t.dte) 

having sale <> (select  top_sale from
								( select  sum(totalprice) as top_sale
                                  from fact_transactions as t
									left join dim_model as m
									on t.idmodel = m.idmodel
									left join dim_manufacturer as a
									on m.idmanufacturer= a.idmanufacturer
									left join dim_date as d
									on d.dte = t.dte
                                    where yr = '2009'
                                    group by manufacturer_name
	                                order by sum(totalprice) desc
                                    limit 1) as x)

order by sum(totalprice) desc
limit 1) as a
 
 union

select * from 
(select manufacturer_name, year(t.dte) as yr, sum(totalprice) as sale from fact_transactions as t
left join dim_model as m
on t.idmodel = m.idmodel
left join dim_manufacturer as a
on m.idmanufacturer= a.idmanufacturer
left join dim_date as d
on d.dte = t.dte
where yr = '2010'
group by manufacturer_name, year(t.dte) 

having sale <> (select  top_sale from
								( select  sum(totalprice) as top_sale
                                  from fact_transactions as t
									left join dim_model as m
									on t.idmodel = m.idmodel
									left join dim_manufacturer as a
									on m.idmanufacturer= a.idmanufacturer
									left join dim_date as d
									on d.dte = t.dte
                                    where yr = '2010'
                                    group by manufacturer_name
	                                order by sum(totalprice) desc
                                    limit 1) as x)

order by sum(totalprice) desc
limit 1) as b;

-- Q8--END
-- Q9--BEGIN
	
-- Show the manufacturers that sold cellphones in 2010 but did not in 2009.

select manufacturer_name from
                                  (select distinct manufacturer_name, yr
                                  from fact_transactions as t
									left join dim_model as m
									on t.idmodel = m.idmodel
									left join dim_manufacturer as a
									on m.idmanufacturer= a.idmanufacturer
									left join dim_date as d
                                    on d.dte = t.dte
                                   where yr = '2010') as x
				except  
                               
   select manufacturer_name from                            
                                    (select distinct manufacturer_name, yr
                                  from fact_transactions as t
									left join dim_model as m
									on t.idmodel = m.idmodel
									left join dim_manufacturer as a
									on m.idmanufacturer= a.idmanufacturer
									left join dim_date as d
                                    on d.dte = t.dte
                                   where yr = '2009') as y;



-- Q9--END

-- Q10--BEGIN
	
--  Find top 100 customers and their average spend, average quantity by each 
	-- year. Also find the percentage of change in their spend.
       
select *, ((avgspend-prev_spend)/prev_spend) as per_change
from(select *, lag(avgspend, 1) over (partition by idcustomer order by yr) as prev_spend 
from(select t.idcustomer,customer_name, year(dte) as yr, avg(totalprice) as avgspend, avg(quantity) as avgqty 
from dim_customer as c       
left join fact_transactions as t
on t.idcustomer = c.idcustomer
where (t.idcustomer, customer_name) in (select x.idcustomer, customer_name 
                                       from
									   (select t.idcustomer, customer_name, avg(totalprice) as spend 
									   from dim_customer as c
						               left join fact_transactions as t
									   on t.idcustomer = c.idcustomer
				            	       group by c.idcustomer, customer_name
						               order by spend desc
									   limit 100) as x)
group by  idcustomer, customer_name, year(dte)) as y) as z;
            

-- Q10--END