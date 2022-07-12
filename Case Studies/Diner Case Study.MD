<h1 align="center">8 SQL Case Studies</h1>

## Description

Working with SQL to find insighst from data is something which I really enjoy. I took up the fun Danny Ma's 8 weeks of SQL challenge and this is my first case study 
pertaining to it. 

This case study consists of 3 key datasets :
- sales
- menu
- members

<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/Case_study.PNG" width="600" height="400" />

## Case Study Questions and Solutions

-- 1. What is the total amount each customer spent at the restaurant?
```sql
select s.customer_id as customer,sum(m.price) as total_expense
from sales s inner join menu m
on s.product_id = m.product_id
group by s.customer_id
order by 1;
```
-- 2. How many days has each customer visited the restaurant?
```sql
select customer_id as customer, count(distinct order_date) as number_of_days_visited
from sales
group by customer_id
order by 1;
```
-- 3. What was the first item from the menu purchased by each customer?
```sql
with cte as 
(select customer_id as customer,product_id, dense_rank() over(partition by customer_id order by order_date)
as prnk
from sales)
select distinct cte.customer, m.product_name as product
from cte inner join menu m
on cte.product_id = m.product_id
where cte.prnk = 1;
```

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
```sql
with t1 as
(select product_id,count(product_id) as maxprod
from sales
group by product_id
order by maxprod desc
limit 1)
select product_name as Product, t1.maxprod as Number_of_times_ordered
from t1 inner join menu 
on t1.product_id = menu.product_id;
```

-- 5. Which item was the most popular for each customer?
```sql
with t2 as 
(select customer_id, product_id, count(product_id) as item_count
from sales 
group by customer_id, product_id
order by customer_id,item_count desc),
t3 as
(select customer_id, product_id, item_count , dense_rank() over (partition by customer_id
order by item_count desc) as item_rank
from t2)
select t3.customer_id, product_name as popular_item, t3.item_count
from t3 inner join menu 
on t3.product_id = menu.product_id
where item_rank = 1
order by customer_id;
```

-- 6. Which item was purchased first by the customer after they became a member?
```sql
with t4 as
(select s.customer_id, product_id, order_date, dense_rank() over(partition by customer_id order 
by order_date asc) as cust_rnk
from sales s inner join members m on
s.customer_id = m.customer_id
where s.order_date >= m.join_date)
select customer_id as customer, order_date, product_name as first_order
from t4 inner join menu
on t4.product_id = menu.product_id
where cust_rnk = 1
order by 1 asc;
```

-- 7. Which item was purchased just before the customer became a member?
```sql
with t4 as
(select s.customer_id, product_id, order_date, dense_rank() over(partition by customer_id order 
by order_date asc) as cust_rnk
from sales s inner join members m on
s.customer_id = m.customer_id
where s.order_date < m.join_date)
select customer_id as customer, order_date, product_name as first_order
from t4 inner join menu
on t4.product_id = menu.product_id
where cust_rnk = 1
order by 1 asc;
```

-- 8. What is the total items and amount spent for each member before they became a member?
```sql
with t4 as
(select s.customer_id, product_id, order_date
from sales s inner join members m on
s.customer_id = m.customer_id
where s.order_date < m.join_date)
select customer_id as customer, count(product_name) as total_items, sum(price) as total_price
from t4 inner join menu
on t4.product_id = menu.product_id
group by t4.customer_id
order by 1 asc;
```


-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
```sql
with t5 as
(select s.customer_id as customer, s.product_id, m.price, m.product_name,
(case 
	when product_name in ('curry','ramen') then price*10
    else price*20
end) as points
from sales s inner join menu m
on s.product_id = m.product_id)
select customer, sum(points) as total_points
from t5
group by 1;
```
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
```sql
with cte 
as
(select s.customer_id as customer, order_date, product_id, join_date
from sales s inner join members m 
on s.customer_id = m.customer_id),
cte2 as
(select customer, order_date, product_name, price,join_date,
case 
	when product_name = 'sushi' then price*20
	when datediff(order_date,join_date) <= 6 and datediff(order_date,join_date) >= 0 then price*20
    when datediff(order_date,join_date) >= 7 and product_name in ('curry','ramen') then price*10
    when datediff(order_date,join_date) < 0 then price*10
	else price*10
end as total_points
from cte inner join menu m
on cte.product_id = m.product_id
order by 1)
select customer, sum(total_points)
from cte2 
where order_date < '2021-02-01'
group by 1;
```



## BONUS QUESTIONS 

![Bonus Question 1](https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/Bonus1.PNG) </br>
```sql
with master_table
as
(select s.customer_id as customer_id, order_date, m.product_name, m.price, coalesce(mem.join_date,0) as join_date
from sales s inner join menu m
on s.product_id = m.product_id
left join members mem
on s.customer_id = mem.customer_id)
select customer_id, order_date, product_name, price,
case
	when order_date < join_date or join_date = 0 then 'N'
    else 'Y'
end as member
 from master_table;
```

![Bonus Question 2](https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/Bonus2.PNG) </br>
```sql
with master_table
as
(select s.customer_id as customer_id, order_date, m.product_name, m.price, coalesce(mem.join_date,0) as join_date
from sales s inner join menu m
on s.product_id = m.product_id
left join members mem
on s.customer_id = mem.customer_id), 
next_tab as
(select customer_id, order_date, product_name, price,
case
	when order_date < join_date or join_date = 0 then 'N'
    else 'Y'
end as member
 from master_table)
select *, 
(case 
when member <> 'N' then dense_rank() over (partition by customer_id, (case when member='Y' then 1 else null end) order by order_date asc)
else null
end) as 'ranking'
from next_tab
```
