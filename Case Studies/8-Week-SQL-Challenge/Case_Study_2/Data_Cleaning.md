## Data Cleaning

As discussed in the previous section, the data has some issues which need to be tackled before it can be used to answer the questions of the case study.
We discuss the approach taken to clean and wrangle each flawed dataset below.

**customer_orders**
- Exclusions and extras columns have values such as 'null' and 'Nan' which need to cleaned and replaced with actual null values.
- All blanks have been cleaned and replaced with actual null values 

**Before** </br>

<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/co_unc.PNG" width="550" height="400"/>

```sql
create or replace view customer_orders_refined
   as
   select row_number() over(order by order_id) as record_id, order_id, customer_id, pizza_id,
   (case 
		when exclusions = '' then null
        when exclusions = 'null' then null
        else exclusions
        end) as exclusions,
	(case
		when extras = 'null' then null
        when extras = '' then null
        when extras is null then null
        else extras
        end) as extras,
        order_time
	from customer_orders;
 ```
 **After** </br>
 
<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/co_clean.PNG" width="580" height="400"/>

Further this view has been refined to separate out the topping_ids added to the exclusions and extras columns.
MySQL's **JSON_TABLE()** which helps in separating comma-separated values to different rows.
We utilize json_array() to convert string to JSON data to tabular data using json_table(). 
The extracted data is then mapped to columns in a relational table form.

**After** </br>

<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/co_clean2.PNG" width="550" height="400"/>

**runner_orders**
The columns 'distance' and 'duration' have mixed values with words 'km', 'minutes' and 'mins' which need to be cleared out.
The column 'cancellation' has issues as well and as a result this column needs to be standardised too. 

**Before** </br>

<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/ro_unc.PNG" width="600" height="250"/>

```sql
create or replace view runner_orders_refined 
    as
    select order_id, runner_id, 
    (case
		when pickup_time = 'null' then null
        else cast(pickup_time as datetime)
	end) as pickup_time,
    (case
		when distance = 'null' then null
        else cast(regexp_replace(distance, '[a-z]','') as float)
	end) as distance,
    (case
		when duration = 'null' then null
        else cast(regexp_replace(duration, '[a-z]', '') as float)
	end) as duration,
    (case
		when cancellation = 'null' then null
        when cancellation = '' then null
        else cancellation
	end) as cancellation
	from
    runner_orders;
```
**After** </br>

<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/ro_clean.PNG" width="650" height="300"/>

**pizza_recipes**
Using a json_table() we separate our the comma-separated values of the topping_ids and assign a new row to each topping_id

**Before** </br>

<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/pizza_unc.PNG" width="250" height="80"/>

```sql
create temporary table pizza_recipe_refined (pizza_id int, topping int);

insert into pizza_recipe_refined
(select t2.pizza_id, trim(t1.toppings) as toppings
from pizza_recipes t2  join
json_table(trim(replace(json_array(toppings),",",'","')),
'$[*]' columns (toppings varchar(50) path '$')) t1);

```

**After** </br>

<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/pizza_clean.PNG" width="230" height="330"/>

We are now ready to solve the case study starting with :bar_chart: [A. Pizza Metrics](https://github.com/ShrutiL1396/SQL/tree/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2) 
