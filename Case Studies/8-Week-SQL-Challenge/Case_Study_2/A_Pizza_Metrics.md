## :pizza:🧀 Case Study #2 - A. Pizza Metrics

#### 1. How many pizzas were ordered?

```sql
select count(pizza_id) as total_pizzas
from customer_orders_refined;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/a1.PNG" width="130" heigth="100"/>

#### 2. How many unique customer orders were made?
```sql
select count(distinct order_id) as unique_orders
from customer_orders_refined;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/a2.PNG" width="130" heigth="100"/>

#### 3. How many successful orders were delivered by each runner?
```sql
select runner_id,count(order_id) as successful_orders_delivered
from runner_orders_refined
where cancellation is null
group by runner_id;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/a3.PNG" width="250" heigth="200"/>

#### 4. How many of each type of pizza was delivered?

```sql
select c.pizza_id,p.pizza_name,count(c.pizza_id) as number_of_pizza_ordered
from customer_orders_refined c inner join runner_orders_refined r
on c.order_id = r.order_id inner join pizza_names p 
on c.pizza_id = p.pizza_id
where r.cancellation is null
group by pizza_id;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/a4.PNG" width="300" heigth="250"/>

#### 5. How many Vegetarian and Meatlovers were ordered by each customer?

```sql
select c.customer_id, c.pizza_id, p.pizza_name,count(c.pizza_id) as number_of_times_ordered
from customer_orders_refined c inner join pizza_names p
on c.pizza_id = p.pizza_id
group by 1,2
order by 1;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/a5.PNG" width="400" heigth="350"/>

#### 6. What was the maximum number of pizzas delivered in a single order?

```sql
select c.customer_id,c.order_id,count(c.pizza_id) as max_pizza_delivered
from customer_orders_refined c inner join runner_orders_refined r 
on c.order_id = r.order_id
where r.cancellation is null
group by 2
order by max_pizza_delivered desc
limit 1;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/a6.PNG" width="300" heigth="350"/>

#### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

```sql
select c.customer_id,
sum(case when exclusions is not null or extras is not null then 1 else 0 end) as orders_w_change,
sum(case when exclusions is null and extras is null then 1 else 0 end) as order_wo_change
from customer_orders_refined c inner join runner_orders_refined r
on c.order_id = r.order_id
where r.cancellation is null
group by 1;


```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/a7.PNG" width="300" heigth="350"/>

#### 8. How many pizzas were delivered that had both exclusions and extras?

```sql
select c.customer_id, c.exclusions, c.extras,coalesce(count(c.pizza_id),0) as pizzas_delivered
from customer_orders_refined c inner join runner_orders_refined r
on c.order_id = r.order_id
where r.cancellation is null and exclusions is not null and extras is not null
group by c.order_id;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/a8.PNG" width="300" heigth="350"/>

#### 9. What was the total volume of pizzas ordered for each hour of the day?

```sql
with pizza_hr_vol as 
(select *, hour(order_time) as hour_of_day
from customer_orders_refined)
select hour_of_day,count(pizza_id) as pizza_volume
from pizza_hr_vol
group by hour_of_day
order by 1;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/a9.PNG" width="200" heigth="280"/>

#### 10. What was the volume of orders for each day of the week?
```sql
with pizza_week_vol as 
(select *, dayname(order_time) as day_of_week
from customer_orders_refined)
select day_of_week,order_time,count(pizza_id) as pizza_volume_week
from pizza_week_vol
group by day_of_week
order by pizza_volume_week desc;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/a10.PNG" width="320" heigth="370"/>

Solutions to the next section can be found here:- 🏃🧔 [B. Runner and Customer Experience](https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/B_Runner_Cust_Exp.md)
