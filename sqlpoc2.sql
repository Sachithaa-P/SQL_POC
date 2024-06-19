1.Citywise count(shipping mode) in desc order
SELECT City, `Ship Mode`, COUNT(*) AS Mode_Count
FROM orders
GROUP BY City, `Ship Mode`
ORDER BY Mode_Count desc;

2.Statewise avg(price) per order
select  ord.State ,avg(pr.ProdPrice) as avg_price  
from orders ord join price pr on
ord.`Order ID` = pr.`Order ID`
group by ord.state,ord.`Order ID`;

3.Regionwise count(segments)
SELECT region, COUNT(*) AS segment_count
FROM Orders
GROUP BY region;

4.Top 10 cities with most number of orders
select City , Count(`Order ID`) as Number_of_orders
from orders
group by city
order by Number_of_orders desc
limit 10;

5.Most ordered product in each segment along with its count, category and sub-category 
with Ordered_products as(
select pr.Category,pr.`Sub-Category`,
pr.`Product Name`,c.Segment,
count(*) No_of_orders,
row_number () over (partition by c.segment order by count(*) desc) as revenue_rank
from 
customer c join product pr on c.`Order ID`=pr.`Order ID`
group by 
pr.`Product Name`,pr.Category,pr.`Sub-Category`,c.Segment)
select Category,`Sub-Category`,`Product Name`,Segment,No_of_orders
from Ordered_products 
where revenue_rank = 1;

6.Top 5 managers under whom most profits have been earned  
SELECT m.Manager, Sum(p.Profit) AS Total_profit
FROM manager m 
JOIN orders o ON m.State = o.State 
JOIN price p ON o.`Order ID` = p.`Order ID`
GROUP BY m.Manager
ORDER BY Total_profit DESC
LIMIT 5;

7.Top 3 returned products
select pr.`Product Name`
from product pr join returns re on
pr.`Order ID` = re.`Order ID`
group by pr.`Product Name`
order by pr.`Product Name` desc
limit 3;

8.Have discounts led to increase in profits ?  (Discounted vs Non-discounted) Count(orders)
with ordered_details as(
select ProdPrice,Quantity,Discount,`Order ID`,
(ProdPrice * Quantity *(1-Discount)) as Profit ,
case
when Discount > 0 then 1
else 0
end as is_discounted from price)
select sum(Profit) as Total_Profit ,
sum(is_discounted) as discounted_orderID_Count,
count(*) - sum(is_discounted) as nondiscounted_orderID_Count 
from ordered_details;

9.Day, month, year in which most orders were placed
select `Order Date`, COUNT(`Order ID`) AS num_orders
from orders
group by `Order Date`
order by  num_orders DESC
limit 1;

10.Day on which most "Sameday" orders were placed 
select `Order Date`, COUNT(*) as Most_Orders 
from orders 
group by `Order Date` 
order by Most_Orders desc
limit 1;

11.Product that was ordered the maximum on sameday delivery 
select p.`Product Name`,count(*) as most_product 
from product p join orders o on o.`Order ID`=p.`Order ID`
where `Order Date`='9/6/2013'
group by p.`Product Name`
order by most_product desc
limit 1;

12.	Most valuble customer in each state
with Order_details as(
select c.`Customer Name`,
c.`Customer ID`,
o.State,
o.`Order ID`,
sum(p.ProdPrice*p.Quantity*(1-p.Discount)) as Total_revenue,
sum(p.Profit) as Total_Profit ,
row_number () over (partition by o.State order by sum((p.ProdPrice)*(p.Quantity)*(1-p.Discount)) desc) as Revenue_rank,
row_number () over (partition by o.State order by sum(p.Profit)) as Profit_rank
from customer c join orders o on c.`Order ID`=o.`Order ID`
join price p on o.`Order ID`=p.`Order ID`
group by  c.`Customer Name`,
c.`Customer ID`,
o.State,
o.`Order ID`)
select `Customer Name`,
`Customer ID`,State,Total_revenue from Order_details
where Revenue_rank =1;

13.	Top 3 valuble customers in each segment
with Valuable_customer as(
select c.`Customer ID`,
c.`Customer Name`,
c.Segment ,
row_number() over (partition by c.Segment order by  SUM(p.ProdPrice * p.Quantity * (1 - p.Discount)) desc) as Revenue_rank
from customer c join orders o on c.`Order ID`=o.`Order ID`
join price p on o.`Order ID` = p.`Order ID`
group by c.`Customer ID`,
c.`Customer Name`,
c.Segment)
select  `Customer ID`,
`Customer Name`,
Segment 
from Valuable_customer
where Revenue_rank <= 3;

14.	Display returned orderid statewise to the corresponding manager separated by '||'
select concat(r.`Order ID`,' || ',m.state,' || ',m.Manager) as Returned_OrderID
from manager m
join orders o on m.State = o.State 
join returns r on o.`Order ID`= r.`Order ID`;

15.	Difference bw Order date and Ship date (statewise & productwise)
Statewise
select State , `Ship Date`-`Order Date` as Date_diff 
from orders 
group by State, `Ship Date`,`Order Date` ;

Productwise
select p.`Product Name`, o.`Ship Date`-o.`Order Date` as Date_diff
from orders o join product p on o.`Order ID`=p.`Order ID`
group by p.`Product Name`,o.`Order Date`,o.`Ship Date`;

16.	Unique products for each city --- New vendor ID generation
select distinct o.City,p.`Product Name`,CONCAT(o.City, '___', p.`Product Name`) as New_Vendor_ID
from orders o 
join product p on o.`Order ID` = p.`Order ID`;
