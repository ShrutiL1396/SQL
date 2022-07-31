<h1 align="center">CASE STUDY #2 - Pizza Runner</h1>

## Introduction
Did you know that over 115 million kilograms of pizza is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

## Data Set
This case study makes use of the following tables
- **runners** :- The runners table shows the registration_date for each new runner
- **pizza_names** :-  Pizza Runner only has 2 pizzas available the Meat Lovers or Vegetarian with the respective id!
- **pizza_recipes** :- Details of all the pizzas along with the pizza_id and standard set of toppings which are used as part of the pizza recipe.
- **pizza_toppings** :- Each of the 12 topping ids are associated with the respective topping name
- **customer orders** :- Customer pizza orders are captured in the customer_orders table with 1 row for each individual pizza that is part of the order. The table also consists of the exclusions which indicate the ingredient (topping_id) to be removed from the pizza and the extras are the ingredients which need to be added to the pizza.
- **runner_orders** :- After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer. The table also stores information about the pickup_time which is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. Additional fields of the table also include the distance and duration fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

The mapping of all the tables can be seen below in the Entity-Relationship Diagram

<img src = "https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_2/Image_Set_2/dataset2.PNG" width="500" height="300" />

## Data Cleaning
When going through the tables, there were a few issues with some tables and such these needed refinement and cleaning before they could be used to solve the case study. I have performed cleaning of a few tables to prepare them to answer the upcoming questions:-


## Questions and Solutions
🍕[Case Study Questions and Solutions](https://github.com/ShrutiL1396/SQL/blob/main/Case%20Studies/8-Week-SQL-Challenge/Case_Study_1/Danny's_Diner.md)
