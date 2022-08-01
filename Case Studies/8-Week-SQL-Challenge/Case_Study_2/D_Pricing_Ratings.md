## 💰⭐ Case Study #2 - D. Pricing and Ratings

#### 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

```sql
with cte 
as
(select c.order_id, c.customer_id, c.pizza_id, p.pizza_name
from customer_orders_refined c inner join runner_orders_refined r
on c.order_id = r.order_id inner join pizza_names p on c.pizza_id = p.pizza_id
where r.cancellation is null)
select concat(sum(case when pizza_id = 1 then 12 else 10 end),'$') as total_earnings
from cte;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/d1.PNG" />

#### 2. What if there was an additional $1 charge for any pizza extras?
- Add cheese is $1 extra

```sql
with cte 
as
(select c.order_id, c.customer_id, c.pizza_id,
(length(extras) - length(replace(extras,',','')) + 1) as topping_rate
from customer_orders_refined c inner join runner_orders_refined r
on c.order_id = r.order_id 
where r.cancellation is null)
select concat((sum(case when pizza_id = 1 then 12 else 10 end) + sum(topping_rate)),'$') 
as total_earnings_w_toppings
from cte;

```

#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/d2.PNG" />

#### 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

```sql
create table order_ratings(customer_id int, order_id int, rating int, review varchar(1000));

insert into order_ratings
values
('101','1','2','Delivery speed was slow. Could be better.'),
('101','2','3','Satisfied with the pizza. Delivery could be faster.'),
('102','3','4','Both the pizzas were really good! Enjoyed the delivery.'),
('103','4','1','Ordered 3 pizzas with the same exclusions. The delivery guy kept asking for instructions and despite that got my pizza after an hour. Would not reccommend at all.'),
('104','5','4','Enjoyed the pizza. The delivery guy arrived within half an hour and was really polite.'),
('105','7','3','My go-to pizza place, which serves authentic pizzas. Although delivery service needs work'),
('102','8','4','Amazing pizza. Amazing delivery and service.'),
('104','10','5','Lightning fast delivery!! Both the pizzas were awesome. 100% would reccommend.');

```
#### Result:- </br>

<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/d3.PNG" />

#### 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas

```sql
select c.customer_id, c.order_id, r.runner_id,
c.order_time, r.pickup_time, odr.rating,
round(timestampdiff(minute, c.order_time, r.pickup_time),2) as time_diff_ord_pickup_mins,
r.duration, 
round(r.distance/(r.duration/60),2) as avg_speed,
count(c.pizza_id) as total_num_pizza
from customer_orders_refined c inner join runner_orders_refined r
on c.order_id = r.order_id inner join order_ratings odr
on c.order_id = odr.order_id
group by r.order_id;

```

#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/d4.PNG" />

#### 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

```sql
select concat(round(sum(total_pizza_cost - runner_revenue),2),'$') as pizza_runner_revenue
from
(
select order_id, distance, round((0.30 * distance),2) as runner_revenue, sum(pizza_cost) as total_pizza_cost
from
(select c.order_id, c.customer_id, c.pizza_id, r.distance, 
(case when pizza_id = 1 then 12 else 10 end) as pizza_cost
from customer_orders_refined c inner join runner_orders_refined r
on c.order_id = r.order_id 
where r.cancellation is null) t1
group by order_id) t2;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/d5.PNG" />

Solutions to the Bonus Questions are here:- 🍕:runner: [Bonus Questions](https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/E_Bonus_Questions.md)
