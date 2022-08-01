## 🍕:runner: Case Study #2 - E. Bonus Questions

#### If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

#### Change in the pizza_recipes table
```sql
insert into pizza_recipes
values ('3', '1,2,3,4,5,6,7,8,9,10,11,12');

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/bonus_1.PNG"/>

#### 2.Change in the pizza_names table

```sql
insert into pizza_names 
values ('3','Supreme');

```
#### Result:- </br>
<img src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/bonus2.PNG"/>

This concludes Case Study #2 !!!
