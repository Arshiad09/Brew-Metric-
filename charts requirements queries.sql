-- chart requirements
use coffee_shop_sales_database;
select * from coffee_shop_sales;
-- total sales,orders and quantity on a particular day
select 
sum(unit_price * transaction_qty) as total_sales,
count(transaction_id) as total_orders,
sum(transaction_qty) as total_qty_sold
from coffee_shop_sales
where transaction_date= '2023-02-01';

-- total sales on weekends and weekdays
-- weekends sat and sun
-- sun =1 
select 
case when dayofweek(transaction_date) in (1,7) then 'weekend'
else 'weekdays' end as day_type,
sum(unit_price*transaction_qty) as total_sales
from coffee_shop_sales
where month(transaction_date)= 5 -- may
group by day_type;

-- sales analysis based on location 
select store_location,
sum(unit_price*transaction_qty) as total_sales
from coffee_shop_sales
where month(transaction_date)= 5
group by store_location;

-- daily sales comparison with average line in a particular month
with cte as (select 
avg(total_sales) as avg_sales
from (
	select sum(transaction_qty * unit_price) as total_sales
    from coffee_shop_sales
	where month(transaction_date)= 5  
     group by transaction_date) as inner_query)
     
select 
day(transaction_date) as day_of_month,
sum(unit_price * transaction_qty) as total_sales,
case when sum(unit_price * transaction_qty)>=(select 
						avg(total_sales) as avg_sales
						from (
						select sum(transaction_qty * unit_price) as total_sales
						from coffee_shop_sales
						where month(transaction_date)= 5  
						group by transaction_date) as inner_query) then 'above average'
	else 'below average' end as comparison

from coffee_shop_sales 
where month(transaction_date)=5 
group by transaction_date;

-- sales by category 
select product_category,sum(unit_price * transaction_qty) as total_sales
from coffee_shop_sales 
where month(transaction_date)=5
group by product_category order by total_sales desc;

-- top 10 products by sale 
select product_type,sum(unit_price * transaction_qty) as total_sales
from coffee_shop_sales 
where month(transaction_date)=5 and product_category='coffee'
group by product_type order by total_sales desc limit 10;

-- sales per hour 
select sum(unit_price * transaction_qty) as total_sales,
sum(transaction_qty) as total_quntity_sold,
count(*) as total_orders
from coffee_shop_sales 
where month(transaction_date)=5 and 
dayofweek(transaction_date)=1
and hour(transaction_time)=14; -- hour number 8

select 
hour(transaction_time) ,
sum(unit_price * transaction_qty) as total_sales
from coffee_shop_sales
where month(transaction_date)=5
group by hour(transaction_time)
order by hour(transaction_time) ;

-- sales analysis by days in a particular month
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
Day_of_Week;


