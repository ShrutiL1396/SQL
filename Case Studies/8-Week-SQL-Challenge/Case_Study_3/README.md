<h1 align="center">CASE STUDY #3 - Foodie-Fi</h1>

<p align="center">
  <img width="400" height="350" src="https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/pizza.PNG">
</p>

## Introduction
Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

## Data Set
Danny has shared the data design for Foodie-Fi and also short descriptions on each of the database tables - our case study focuses on only 2 tables but there will be a challenge to create a new table for the Foodie-Fi team.

The two tables used in the case study are:-
- **plans** - This table has all the details about existing plans offered by Foodie-Fi. The information in the table includes, the plan_id, plan_name and the price of the plan.
- **subscriptions** - Customer subscriptions show the exact date where their specific plan_id starts. After the trial period of 7 days is over customers are automatically upgraded to the pro monthly plan. While downgrades take effect after the existing plan ends on its said end date, upgrades take effect straightaway. In case a customer decides to cancel their subscription, they enter the 'churn' plan however they can keep the access until their next billing date of the previous plan.

The mapping of all the tables can be seen below in the Entity-Relationship Diagram

<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/dataset2.PNG" width="500" height="300" />


## Questions and Solutions
Let's proceed to the first section of this case study 🥑[A. Customer Journey]

