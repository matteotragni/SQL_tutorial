select * from customer
select * from product
select * from sales

--the IN statement:
select * from customer
where city = 'Seattle'
or    city = 'Philadelphia'

--if you want to avoid the or:
select * from customer
where city in ('Seattle', 'Philadelphia');


--the BETWEEN statement:
select * from customer where age between 20 and 30;
select * from customer where not age between 20 and 30;
select * from sales where ship_date between '2015-04-01' and '2016-01-01';


/*WILDCARDS:
% = allows you to match any string of any length
- A% means starts with A;
- %A means anything that ends with A;
- A%B means starts with A and ends with B

_ = allows you to match on a single charachter:
AB_C means string starts with AB, then there is one charachter, then there is C */

--You can implement the wildcards using the LIKE command':
select * from customer
where customer_name like 'J%';

select * from customer
where customer_name like '%Nelson%';

select * from customer
where customer_name like '____ %'; --i.e. a name which starts with 4 charachters

--!!! IF YOU WANT TO WRITE THE % SYMBOL WITHOUT IT BEING CONSIDERED AS A WILDCARD, YOU MUST TYPE \% !!!

select distinct city from customer
where region in ('North', 'East');

select * from sales
select * from sales
where sales between 100 and 500;

select * from customer
select distinct customer_name from customer
where customer_name like '____ %';


--ORDER BY command:
select * from customer
where state = 'California'
order by Customer_name;
/*when selecting either ascending or descending order, you use ASC or DESC (if you don't specify it,
ASC is going to be automatically selected) */
select * from customer
where state = 'California'
order by Customer_name desc;

select * from customer
order by city asc, customer_name desc;
select * from customer order by age asc;


--LIMIT command
-- suppose you want to find out who are the ten oldest consumers from Florida:
select * from customer
where state = 'Florida' and segment = 'Consumer'
order by age desc
limit 10;

select * from sales
where discount > 0
order by discount desc
limit 10;

--AS command
select * from customer
select customer_id as "Serial number" from customer


--COUNT
select count(*) from sales;
/* Not very useful like this. Imagine you want to count how many orders has a particular customer
done and how many products he ordered: */

select count(order_line) as "Number of products ordered", count(distinct order_id) as "Number of orders"
from sales
where customer_id = 'CG-12520';

--SUM
select sum(profit) as "tot profit" from sales;
select sum(quantity) as "tot quantity" from sales
where product_id = 'FUR-TA-10000577';

--AVG (AVERAGE)
select avg(age) as "Average customer age"
from customer

select avg(sales*0.1) as "Average commission per sales"
from sales

--MIN/MAX
select min(sales) as "min sales on June 2015" from sales
where order_date between '2015-06-01' and '2015-06-30';

select max(sales) as "max sales on June 2015" from sales
where order_date between '2015-06-01' and '2015-06-30';

--exercise
--Find the sum of all the sales value
select sum(sales) from sales; --2,297,200.86
--Count the number of customers with age between 20 and 30
select count(*) from customer
where age between 20 and 30;--150
--Find the average age of East region customers 
select avg(age) as "Average age of customers from East" from customer 
where region = 'East'; --44
--Find the minimum and maximum aged customer from Philadelphia 
select min(age) as "Youngest customer from Philadelphia" from customer
where city = 'Philadelphia'; --18
select max(age) as "Oldest customer from Philadelphia" from customer
where city = 'Philadelphia'; --70 


--GROUP BY
--e.g. how many customers live in every region?
select region, count(customer_id) from customer
group by region
--and what is the average age of them in those regions? in which state?
select region, state, avg(age) as average_age, count(customer_id) as tot_customers from customer
group by region, state
--how many products were sold?
select product_id, sum(quantity) as "quantity sold" from sales
group by product_id
order by "quantity sold" desc;

select customer_id,
min(sales) as min_sales,
max(sales) as max_sales,
avg(sales) as avg_sales,
sum(sales) as tot_sales
from sales
group by customer_id
order by tot_sales desc
limit 5;

--HAVING: it is used together with GROUP BY to filter
select region, count(customer_id) as customer_count from customer
group by region
having count(customer_id)>200;

select region, count(customer_id) as customer_count from customer
where customer_name like 'A%'
group by region;

/* !!! WHERE vs HAVING:
'where' is used before the group by command, while 'having' is used for aggregate
functions (i.e. after group by) */
select region, count(customer_id) as customer_count from customer
where customer_name like 'A%'
group by region
having count(customer_id) >15;

/*exercise
make a table showing the following figures for each product id:
- tot. sales in $ (order by desc);
- tot. sales quantity;
- no. of orders;
- max sales value;
- min sales value;
- average sales value
After, get the list of product IDs where the quantity of product sold is > 10 */
select * from sales

select product_id,
sum(sales) as "tot sales in $",
sum(quantity) as tot_sales_quantity,
count(order_id) as "no. of orders",
max(sales) as "max sales value",
min(sales) as "min sales value",
avg(sales) as "average sales value"
from sales 
group by product_id
having sum(quantity) > 10
order by sum(sales) desc;


--CASE WHEN
select *, case
           when age < 30 then 'young'
		   when age > 60 then 'senior'
		   else               'middle aged'
end as age_category 
from customer;


--JOINS
--create a sales table of 2015
create table sales_2015 as select * from sales
where ship_date between '2015-01-01' and '2015-12-31'
select count(distinct customer_id) from sales_2015;

--create a table with customers aged between 20 and 60
create table customer_20_60 as select * from customer
where age between 20 and 60;
select * from customer_20_60

--INNER JOIN: it finds all pairs of rows 
select 
    a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age
from sales_2015 as a
inner join customer_20_60 as b
on a.customer_id = b.customer_id
order by customer_id;

--LEFT JOIN: returns all rows from the left table, even if there are no matches in the right table
select 
    a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age
from sales_2015 as a
left join customer_20_60 as b
on a.customer_id = b.customer_id
order by customer_id;

--RIGHT JOIN: returns all rows from the right table, even if there are no matches in the left table
select
    a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age
from sales_2015 as a
right join customer_20_60 as b
on a.customer_id = b.customer_id
order by customer_id;
--some of the customer id now are null, because they are taken from the sales table, where they are not present
--in order to get them, you can simply change the a.customer_id in b.customer_id
select
    a.order_line,
	a.product_id,
	b.customer_id,
	a.sales,
	b.customer_name,
	b.age
from sales_2015 as a
right join customer_20_60 as b
on a.customer_id = b.customer_id
order by customer_id;


--FULL JOIN: combines left and right
select 
    a.order_line,
	a.product_id,
	a.customer_id,
	a.sales,
	b.customer_name,
	b.age,
	b.customer_id
from sales_2015 as a
full join customer_20_60 as b
on a.customer_id = b.customer_id
order by a.customer_id, b.customer_id;

--CROSS JOIN
create table months (MM integer);
create table years (YYYY integer);
insert into months values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12);
insert into years values (2011), (2012), (2013), (2014) , (2015), (2016), (2017) , (2018), (2019);

select * from months
select * from years

select a.yyyy, b.mm
from years as a, months as b
order by a.yyyy, b.mm;


/*COMBINING QUERIES
--INTERSECT: will give me those rows present in both tables;
--EXCEPT: will remove those rows present in both tables;
--UNION: will combine both tables */

--INTERSECT
select customer_id from sales_2015
intersect
select customer_id from customer_20_60;

--!!! INTERSECT AND UNION ALL allow duplicates to remain in the output !!!

--EXCEPT
select customer_id 
from sales_2015
except
select customer_id from customer_20_60
order by customer_id;
--so now you will have only the customer_id not present in the customer_20_60 table

--UNION
select customer_id
from sales_2015
union
select customer_id
from customer_20_60
order by customer_id;

/*exercise
Find the total sales in every state for customer_20_60 and sales_2015 */
select b.state,
sum(sales) as total_sales
from sales_2015 as a
left join customer_20_60 as b
on a.customer_id = b.customer_id
group by b.state;
--Get data containing product_id, product_name, category, total sales, value of that product and total quantity sold
select a.*, sum(b.sales) as total_sales, sum(quantity) as total_quantity
from product as a
left join sales as b
on a.product_id = b.product_id
group by a.product_id


--SUBQUERY
select * from sales
where customer_id in (select customer_id from customer where age > 60);


select 
     a.product_id,
	 a.product_name,
	 a.category,
	 b.quantity,
	 b.sales
from product as a
left join (select product_id,
		   sum(quantity) as quantity,
		   sum(sales) as sales
		   from sales
		   group by product_id) as b
on a.product_id = b.product_id
order by quantity desc;


--joining the 3 tables: get dat with all the columns of sales, and customer name , customer age, product name and category
select c.customer_name, c.age, sp.* from customer as c
right join (select s.*, p.product_name, p.category
		   from sales as s
		   left join product as p 
           on s.product_id = p.product_id) as sp
on c.customer_id = sp.customer_id;

--VIEW: it doesn't actually creates a table, so it does not waste space
create view logistics as
select a.order_line, a.order_id, b.customer_name, b.city, b.state, b.country
from sales as a
left join customer as b
on a.customer_id = b.customer_id
order by order_line;

select * from logistics
drop view logistics 

create view Daily_Billing as
select order_line, product_id, sales, discount
from sales where order_date in (select max(order_date) from sales);

select * from Daily_Billing
drop view Daily_Billing

--INDEX
create index mon_idx
on months(MM);
drop index mon_idx


--STRING FUNCTIONS
--LENGTH
select customer_name, length(customer_name)
from customer 
where age > 30;

--UPPER & LOWER
select upper('matteo')
select lower('MAttEo')

--REPLACE
select customer_name, country,
replace(country,'United States','US') as new_country
from customer;

--TRIM
select trim(leading ' ' from '   Start-Tech Academy   '); --removes the space at the beginning
select trim(trailing ' ' from '   Start-Tech Academy   '); -- removes the space at the end
select trim(both ' ' from '   Start-Tech Academy   ');-- removes both
select trim('  Start-Tech academy   '); -- same as both
--RTRIM & LTRIM
select rtrim('     Start-Tech academy   ', ' '); -- removes the space from the right side
select ltrim('     Start-Tech academy   ', ' '); -- removes the space from the left side

--CONCAT
select customer_name,
city||', '||state||', '||country as Address
from customer;

--SUBSTRING
select customer_id, customer_name,
substring(customer_id for 2) as cust_group
from customer
where substring(customer_id for 2) = 'AB';

--STRING AGGREGATOR
select order_id,
string_agg(product_id,', ')
from sales
group by order_id
order by order_id;

--exercise
--find the maximum length of charachters in the product name string from product table:
select max(length(product_name)) from product --127
/*get product name, sub-category and category from product table, and an additional column named "product details"
 which contains a concatenated string of product name, sub-category and category:*/
select product_name, sub_category, category,
product_name||', '||sub_category||', '||category as product_details
from product;


--MATHEMATICAL FUNCTIONS
--CEIL & FLOOR (they basically round up and down the values you specify to the closest integer)
select order_line,
       sales,
	   ceil(sales) as round_up,
	   floor(sales) as round_down
from sales

--RANDOM: returns a value between 0 and 1(exclusive)
--e.g. a= 10 ; b= 50
select random(), random()*40+10, floor(random()*40+10)
select customer_name, random() as rand_n from customer order by rand_n
limit 5

--ROUND
select order_line,
       sales,
	   round(sales)
from sales
order by sales desc;


--POWER ==> power(m,n) i.e. m raised to the power of n
select power(6,2)
select power(age,2), age from customer

--make a new table which contains all customer ids, with the tot. number of order, sales, quantity and profit:
select a.*, b.order_num, b.tot_sales, b.tot_quantity, b.tot_profit
from customer as a
left join (select customer_id, count(distinct order_id) as order_num, sum(round(sales)) as tot_sales,
		   sum(quantity) as tot_quantity, sum(round(profit)) as tot_profit
		   from sales group by customer_id) as b
on a.customer_id = b.customer_id;

--IN ORDE TO CREATE A NEW TABLE WITH THE PREVIOUSLY JOINT TABLES, YOU CAN SIMPLY:
create table customer_order as (select a.*, b.order_num, b.tot_sales, b.tot_quantity, b.tot_profit
from customer as a
left join (select customer_id, count(distinct order_id) as tot_orders, sum(round(sales)) as tot_sales,
		   sum(quantity) as tot_quantity, sum(round(profit)) as tot_profit
		   from sales group by customer_id) as b
on a.customer_id = b.customer_id);

select * from customer_order
order by state

--Find average profit for each customer
select a.customer_id, b.average_profit
from customer as a
left join(select customer_id, avg(profit) as average_profit from sales group by customer_id) as b
on a.customer_id = b.customer_id
order by average_profit desc;



--WINDOW FUNCTIONS
--ROW NUMBER
--Find top 3 customers from each state
select * from (select customer_id, customer_name, state, tot_orders, row_number() over (partition by state order by tot_orders desc) as row_n
from customer_order) as result
where row_n <= 3;

/*RANK AND DENSERANK: the first provides you with skipping ranking, while the second deosn't
i.e. RANK: 1-2-2-4-5 while DENSERANK: 1-2-2-3-4*/
select customer_id, customer_name, state, tot_orders,
rank() over (partition by state order by tot_orders desc) as rank_n, 
dense_rank() over ( partition by state order by tot_orders) as d_rank_n
from customer_order;

--NTILE: divides the data in n groups
--get the to 20% customers from each state
select customer_id, customer_name, state, tot_orders,
ntile(5) over (partition by state order by tot_orders desc)
from customer_order;
--to get only the 20%:
select * from 
(select customer_id, customer_name, state, tot_orders,
ntile(5) over (partition by state order by tot_orders desc) as ntile_n
from customer_order) as top_20_percent
where ntile_n = 1;

--AVERAGE
--get the average revenues for each state
select customer_id, customer_name, state, tot_sales as revenue,
avg(tot_sales) over (partition by state) as avg_revenue
from customer_order;

--detect customers who buy at a level under the average:
select * from (select customer_id, customer_name, state, tot_sales as revenue,
avg(tot_sales) over (partition by state) as avg_revenue
from customer_order) as average
where revenue < avg_revenue;

--COUNT
select customer_id, customer_name, state, count(customer_id) over (partition by state) as count_of_customers_per_state
from customer_order

--SUMTOTAL
create table order_rollup as (select order_id, max(order_date) as order_date, max(customer_id) as customer_id, sum(sales) as sales 
							  from sales group by order_id)

create table order_rollup_state as (select a.*, b.state
from order_rollup as a
left join customer as b
on a.customer_id = b.customer_id)
select * from order_rollup_state

select *,
sum(sales) over (partition by state) as tot_sales_per_state
from order_rollup_state;

--RUNNING TOTAL: it returns the cumulative sum of the selected data
select *,
sum(sales) over (partition by state) as tot_sales_per_state,
sum(sales) over (partition by state order by order_date) as running_total
from order_rollup_state;

--"2014-01-03" to "2017-12-30"
select * from order_rollup_state
where extract(year from order_date) = 2014;

select *,
sum(round(sales::numeric, 2)) over (partition by extract(year from order_date)) as tot_sales_of_the_year
from order_rollup_state
order by order_date;

--COALESCE: it returns the first non-null value in a list of values
create table emp_name (
	S_No int,
	First_name varchar,
	Middle_name varchar,
	Last_name varchar);

insert into emp_name (S_No, First_name, Middle_name, Last_name) values (1 ,  'Paul',   'Van' ,     'Hugh' );
insert into emp_name (S_No, First_name,              Last_name) values (2 ,  'David',           'Flashing');
insert into emp_name (S_No,             Middle_name, Last_name) values (3 ,            'Lena',  'Radford' );
insert into emp_name (S_No, First_name,              Last_name) values (4  , 'Matt' ,              'Brew' );
insert into emp_name (S_No,                          Last_name) values (5 ,                       'Holden');
insert into emp_name (S_No, First_name, Middle_name, Last_name) values (6 , 'Erin',     'Tee',    'Muller');
select * from emp_name

select *, coalesce(first_name, middle_name, last_name) as coalesce_name from emp_name
--as you can see in the output, if there is the first name, you'll get it; if you don't, it goes to the middle, or to the last


