## :runner:🧑‍ Case Study #2 - B. Runner and Customer Experience

#### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

```sql
select week(registration_date) as week_registered, count(runner_id) as num_registered_runners
from runners
group by 1;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/b1.PNG" width="240" height="90"/>

#### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

```sql
select r.runner_id, round(avg(timestampdiff(minute, c.order_time, r.pickup_time)),2) as avg_pickup_time_mins
from customer_orders_refined c inner join runner_orders_refined r
on c.order_id = r.order_id
group by runner_id;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/b2.PNG" width="240" height="90"/>

#### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

```sql
with pizza_ord_prep as
(select c.customer_id, c.order_id, count(c.pizza_id) as num_of_pizza,
round(timestampdiff(minute, c.order_time, r.pickup_time),2) as mins
from customer_orders_refined c inner join runner_orders_refined r
on c.order_id = r.order_id
where r.cancellation is null
group by c.order_id)
select num_of_pizza, round(avg(mins),2) as avg_prep_time
from pizza_ord_prep
group by num_of_pizza;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/b3.PNG" width="240" height="90"/>

#### 4. What was the average distance travelled for each customer?

```sql
select c.customer_id, round(avg(r.distance),2) as avg_dist_travelled
from customer_orders_refined c inner join runner_orders_refined r
on c.order_id = r.order_id
where r.cancellation is null
group by 1;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/b4.PNG" width="240" height="130"/>

#### 5. What was the difference between the longest and shortest delivery times for all orders?

```sql
select max(duration) as max_duration, min(duration) as min_duration, 
(max(duration) - min(duration)) as difference_in_duration
from runner_orders_refined
where cancellation is null;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/b5.PNG" width="320" height="60"/>

#### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

```sql
select runner_id, order_id, distance as distance_in_km, round((duration/60),2) as duration_in_hr,
round((distance/(duration/60)),2) as avg_speed
from runner_orders_refined
where cancellation is null
group by order_id,runner_id
order by 1;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/b6.PNG" width="370" height="200"/>

#### 7. What is the successful delivery percentage for each runner?
```sql
with tot_orders
as
(select runner_id, count(order_id) as total_orders
from runner_orders_refined
group by runner_id),
success_orders as 
(select runner_id, count(order_id) as successful_orders
from runner_orders_refined
where cancellation is null
group by runner_id)

select t.runner_id, t.total_orders as total_orders, s.successful_orders as successful_orders, 
concat(round(((successful_orders/total_orders)*100),2),"%") as successful_deliv_perc
from tot_orders t inner join success_orders s
on t.runner_id = s.runner_id;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/b7.PNG" width="350" height="90"/>

Solutions to the next section can be found at:- 🥩🍅🍄 [C. Ingredient Optimisation](https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/C_Ingredient_Optimisation.md)
