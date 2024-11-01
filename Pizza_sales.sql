-- queries for kpi's:
select * from pizza_sales;
SELECT SUM(total_price) AS Total_Revenue from pizza_sales;
SELECT SUM(total_price)/COUNT (DISTINCT order_id) AS Avg_order_value from pizza_sales
SELECT SUM(quantity) AS Total_Pizza_Sold from pizza_sales;
SELECT count(DISTINCT order_id) AS Total_order from pizza_sales;
SELECT cast(cast(SUM(quantity)AS DECIMAL(10,2))/
cast(COUNT (DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) AS Avg_pizzas_per_order from pizza_sales

-- now hourly trend for total pizzas sold

SELECT DATEPART(HOUR, order_time) as order_hour, SUM(quantity) as total_pizzas_sold
from pizza_sales
group by DATEPART(HOUR, order_time)
order by DATEPART(HOUR, order_time)

--weekly trends for total orders
SELECT DATEPART(ISO_WEEK, order_date) as week_number, YEAR(order_date) as Order_year,
count(DISTINCT order_id) as Total_orders from pizza_sales
group by DATEPART(ISO_WEEK, order_date),YEAR(order_date)
order by DATEPART(ISO_WEEK, order_date),YEAR(order_date)

-- ratio of sales

SELECT pizza_category, sum(total_price) as Total_sales, sum(total_price) * 100 / 
(SELECT sum(total_price) from pizza_sales where MONTH(order_date)=1) as PCT
from pizza_sales 
where MONTH(order_date)=1
group by pizza_category

-- percentage of sales by pizza size:

SELECT pizza_size, cast(sum(total_price) as DECIMAL(10,2)) as Total_sales, cast(sum(total_price) * 100 / 
(SELECT sum(total_price) from pizza_sales where DATEPART(quarter,order_date)=1)AS DECIMAL(10,2)) as PCT
from pizza_sales 
where DATEPART(quarter,order_date)=1
group by pizza_size
order by PCT DESC

---top 5 best revenue, total quantity and total orders

SELECT TOP 5 pizza_name, Sum(total_price) as total_revenue from pizza_sales
group by  pizza_name
order by  total_revenue DESC

--bottom 5 pizza
SELECT TOP 5 pizza_name, Sum(total_price) as total_revenue from pizza_sales
group by  pizza_name
order by  total_revenue ASC

-- top 5 pizzas by quantity
SELECT TOP 5 pizza_name, Sum(quantity) as total_quantity from pizza_sales
group by  pizza_name
order by  total_quantity DESC

--bottom 5 by quantity
SELECT TOP 5 pizza_name, Sum(quantity) as total_quantity from pizza_sales
group by  pizza_name
order by  total_quantity ASC


--top 5 by orders
SELECT TOP 5 pizza_name, count(DISTINCT order_id) as total_orders from pizza_sales
group by  pizza_name
order by  total_orders DESC

-- bottom 5 by orders
SELECT TOP 5 pizza_name, count(DISTINCT order_id) as total_orders from pizza_sales
group by  pizza_name
order by  total_orders ASC
