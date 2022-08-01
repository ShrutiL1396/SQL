## 🥩:tomato:🍄 Case Study #2 - C. Ingredient Optimisation

#### 1. What are the standard ingredients for each pizza?

```sql
select p.pizza_id, p3.pizza_name as pizza, group_concat(p2.topping_name) as ingredients
from pizza_recipe_refined p inner join pizza_toppings p2
on p.topping = p2.topping_id inner join pizza_names p3
on p.pizza_id = p3.pizza_id
group by p.pizza_id;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/c1.PNG" width="710" height="100"/>

#### 2. What was the most commonly added extra?

To answer the above question and the next question, a temporary table is created which will list down the ingredient names for each type
of pizza

```sql
create temporary table all_ingredients(pizza_id int, pizza varchar(100), ingredients varchar(1000));

insert into all_ingredients
select p.pizza_id, p3.pizza_name as pizza, group_concat(p2.topping_name) as ingredients
from pizza_recipe_refined p inner join pizza_toppings p2
on p.topping = p2.topping_id inner join pizza_names p3
on p.pizza_id = p3.pizza_id
group by p.pizza_id;

```
#### Temporary Table is as follows:-
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/c2prep.PNG" width="710" height="100"/>

```sql
with pop_extra as
(select extras, count(extras) as extra_count
from customer_orders_refined_split
group by extras
having extras is not null)
select p2.topping_name as common_extra, max(extra_count) as order_count
from pop_extra p inner join pizza_toppings p2
on p.extras = p2.topping_id;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/c2.PNG" width="260" height="80"/>

#### 3. What was the most common exclusion?

```sql
with pop_exclu as
(select exclusions as ex_id, count(exclusions) as exclusions_count
from customer_orders_refined_split
where exclusions is not null
group by exclusions
order by exclusions_count desc
limit 1)
select p2.topping_name as common_exclusion, p.exclusions_count as order_count
from pop_exclu p inner join pizza_toppings p2
on p.ex_id = p2.topping_id;

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/c3.PNG" width="260" height="80"/>

#### 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

```sql
with t1 as
(select order_id, row_num,customer_id, pizza_id, exclusions, extras,exc, cte2.topping_name as ext, 
pizza
from
	(select c.*, pt.topping_name as exc, a.pizza
	from 
	customer_orders_refined_split c left join all_ingredients a
	on c.pizza_id = a.pizza_id left join pizza_toppings pt 
	on pt.topping_id = c.exclusions) cte1
left join pizza_toppings cte2 on cte2.topping_id = cte1.extras)
select order_id, customer_id, pizza_id, 
(case
	when exc is null and ext is null then pizza
    when exc is null and ext is not null then concat(pizza," - Extra ",group_concat(distinct ext))
    when exc is not null and ext is null then concat(pizza," - Exclude ",group_concat(distinct exc))
    else concat(pizza," - Exclude ",group_concat(distinct exc), concat(" - Extra ",group_concat(distinct ext)) )
end) as final_orders
from t1
group by row_num;

```

#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/c4.PNG" width="520" height="350"/>

#### 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

In order to tackle this problem we create 2 sets of tables which will keep a track of the extra ingredients and ingredients to be excluded in each order

#### Extras

```sql
create table all_extras(record_id int, order_id int, extra_id int);

insert into all_extras
select distinct record_id, order_id, extras
from customer_orders_refined_split c left join pizza_toppings p
on c.extras = p.topping_id
order by record_id asc;

```
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/extras.PNG" width="310" height="360"/>

#### Exclusions

```sql
create table all_exclude(record_id int, order_id int, exclusion_id int);

insert into all_exclude
select distinct record_id, order_id, exclusions
from customer_orders_refined_split c left join pizza_toppings p
on c.exclusions = p.topping_id
order by record_id asc;

```
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/excl.PNG" width="310" height="360"/>

#### Note that the 'record_id' field is important in each of these tables as this will be used to link these tables with customer_orders_refined and answer the question.

```sql
with cte as
(select 
c.record_id, 
p.pizza_name, 
pt.topping_name,
(case
	when pt.topping_id in 
    (select extra_id from all_extras x where x.record_id = c.record_id) then '2x'
    else ''
end) as extra_status
from customer_orders_refined c join pizza_names p
on c.pizza_id = p.pizza_id join pizza_recipe_refined pr 
on p.pizza_id = pr.pizza_id join pizza_toppings pt
on pr.topping = pt.topping_id
group by c.record_id, p.pizza_name, pt.topping_name, pt.topping_id)

select c.order_id, 
c.customer_id, 
c.pizza_id, 
c.exclusions, 
c.extras, 
c.order_time,
concat(t1.pizza_name," : ",group_concat(concat(t1.extra_status,t1.topping_name))) as i_list
from customer_orders_refined c inner join cte t1
on c.record_id = t1.record_id
group by c.record_id, c.order_id, c.customer_id, c.pizza_id, c.exclusions, c.extras, c.order_time,
t1.pizza_name ;

```
#### Result:- </br>

<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/c5.PNG" width="800" height="360"/>

Solutions to the next section can be found here :- 💰⭐ [D. Pricing and Ratings](https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/D_Pricing_Ratings.md)

