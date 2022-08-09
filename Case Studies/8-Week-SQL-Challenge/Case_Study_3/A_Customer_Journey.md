### 🥑 A. Customer Journey

Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.
Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!


#### 1. Total Number of Customers
```sql
select count(distinct customer_id) as total_subscribers
from subscriptions;
```
#### Result:-
<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_3/Image_set/a1.PNG" width="150" height="60"/>

#### 2. Number of customers who cancelled the subscription after trial period
```sql
with sub_ranking as 
(select *,
rank() over (partition by customer_id order by start_date asc) as first_day,
rank() over (partition by customer_id order by start_date desc) as last_day
from subscriptions
order by customer_id)
select count(distinct customer_id) as customer_cancel_post_trial 
from sub_ranking
where first_day = 2 and last_day = 1
and plan_id = 4;
```
#### Result:-
<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_3/Image_set/a2.PNG" width="180" height="60"/>

#### 3. Customer 1's journey
```sql
select s.customer_id, s.plan_id, p.plan_name, s.start_date, p.price 
from subscriptions s inner join plans p
on s.plan_id = p.plan_id
where customer_id = 1;
```
#### Result:-
<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_3/Image_set/a3.PNG" width="400" height="90"/>

- Customer 1 started with a 7 day trial plan costing $0.00
- After the trial period the customer continued to stay with Foodie-Fi and upgraded to a basic monthly plan costing $9.90. They have since then been a customer of Foodie-Fi

#### 4. Customer 2's journey
```sql
select s.customer_id, s.plan_id, p.plan_name, s.start_date, p.price 
from subscriptions s inner join plans p
on s.plan_id = p.plan_id
where customer_id = 2;
```
#### Result:-
<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_3/Image_set/a4.PNG" width="400" height="90"/>

- Customer 2 started with a 7 day trial plan costing $0.00. 
- After the trial period ended the customer seemed to enjoy Foodi-Fi services and upgraded to a pro annual plan costing $199.00. 
- They have since then, 2020-09-27, been a customer of Foodie-Fi.

#### 5. Customer 11's journey
```sql
select s.customer_id, s.plan_id, p.plan_name, s.start_date, p.price 
from subscriptions s inner join plans p
on s.plan_id = p.plan_id
where customer_id = 11;
```
#### Result:-
<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_3/Image_set/a5.PNG" width="400" height="90"/>

- Customer 11 started with a 7 day trial plan costing $0.00
- After the trial period ended the customer decided to discontinue the usage of Foodie-Fi and cancelled their subscription on 2020-11-26.

#### 6. Customer 13's journey
```sql
select s.customer_id, s.plan_id, p.plan_name, s.start_date, p.price 
from subscriptions s inner join plans p
on s.plan_id = p.plan_id
where customer_id = 13;
```
#### Result:-
<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_3/Image_set/a6.PNG" width="400" height="90"/>

- Customer 13 started their Foodie-Fi jourey like most customers with a trial of 7 days.
- After that they upgraded to a basic monthly plan costing $9.90. Customer 13 too seemed pleased with Foodie-Fi and decided to get additional benefits of the subscription service
and upgraded their plan to pro monthly after about 3 months of basic monthly plan usage.

#### 7. Customer 15's journey
```sql
select s.customer_id, s.plan_id, p.plan_name, s.start_date, p.price 
from subscriptions s inner join plans p
on s.plan_id = p.plan_id
where customer_id = 15;
```
#### Result:-
<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_3/Image_set/a7.PNG" width="400" height="90"/>

- Customer 15 started their Foodie-Fi jourey a trial of 7 days.
- After the trial period was over they didn't unsubscribe explicitly and were upgraded automatically to the pro monthly plan costing $19.90
- They were subscribed to Foodie-Fi for a month. It is likely that after realising about the automatic upgrade they unsubscribed from Foodie-Fi after a month's usage.

#### 8. Customer 16's journey
```sql
select s.customer_id, s.plan_id, p.plan_name, s.start_date, p.price 
from subscriptions s inner join plans p
on s.plan_id = p.plan_id
where customer_id = 16;
```
#### Result:-
<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_3/Image_set/a8.PNG" width="400" height="90"/>

- Customer 16 started their Foodie-Fi jourey with a 7 day trial.
- After that they upgraded to a basic monthly plan costing $9.90.
- Customer 16 decided to get upgraded to the pro annual back after using the basic monthly pack for about 4 months.
- They are now subcribed until 2021-10-21 for a year, unless they decide to discontinue the services before that. 

#### 9. Customer 18's journey
```sql
select s.customer_id, s.plan_id, p.plan_name, s.start_date, p.price 
from subscriptions s inner join plans p
on s.plan_id = p.plan_id
where customer_id = 18;
```
#### Result:-
<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_3/Image_set/a9.PNG" width="400" height="90"/>

- Customer 18 started with a 7 day trial plan costing $0.00
- After the trial period, the customer was automatically upgraded to a pro monthly plan, on 2020-07-13. It is likely that they are happy with the services and have decided to stay with Foodie-Fi.

#### 10. Customer 19's journey
```sql
select s.customer_id, s.plan_id, p.plan_name, s.start_date, p.price 
from subscriptions s inner join plans p
on s.plan_id = p.plan_id
where customer_id = 19;
```
#### Result:-
<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_3/Image_set/a10.PNG" width="400" height="90"/>

- Customer 19 started using Foodie-Fi on a trial basis on 2020-06-22.
- After the trial period, the customer was automatically upgraded to a pro monthly plan and continued using the pro monthly plan for 2 months.
- Satisfied with the content they upgraded to a pro annual subscription for a year on 2020-08-29.

Solutions to the next part of the challenge can be found at :- [B. Data Analysis Questions]
