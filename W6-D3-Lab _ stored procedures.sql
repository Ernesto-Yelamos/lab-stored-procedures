# Lab | Stored procedures
	# In this lab, you will be using the Sakila database of movie rentals.

use sakila;
-- set sql_safe_updates=0;
-- SET sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

### Instructions
	# Write queries, stored procedures to answer the following questions:
	-- 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented `Action` movies. Convert the query into a simple stored procedure. Use the following query:
	/*
    select first_name, last_name, email
    from customer
    join rental on customer.customer_id = rental.customer_id
    join inventory on rental.inventory_id = inventory.inventory_id
    join film on film.film_id = inventory.film_id
    join film_category on film_category.film_id = film.film_id
    join category on category.category_id = film_category.category_id
    where category.name = "Action"
    group by first_name, last_name, email;
	*/
 
			select distinct(concat(a.first_name, ' ', a.last_name)) as customer_name, a.email from sakila.customer as a
			join sakila.rental as b on b.customer_id = a.customer_id
			join sakila.inventory as c on c.inventory_id = b.inventory_id
			join sakila.film_category as d on d.film_id = c.film_id
			join sakila.category as e on e.category_id = d.category_id
			where e.name = 'ACTION'
			group by customer_name, a.email;

drop procedure if exists name_email_action;
delimiter //
create procedure name_email_action()
begin
	select distinct(concat(a.first_name, ' ', a.last_name)) as customer_name, a.email from sakila.customer as a
			join sakila.rental as b on b.customer_id = a.customer_id
			join sakila.inventory as c on c.inventory_id = b.inventory_id
			join sakila.film_category as d on d.film_id = c.film_id
			join sakila.category as e on e.category_id = d.category_id
			where e.name = 'ACTION'
			group by customer_name, a.email;
end;
//
delimiter ;

call name_email_action();


	/*
	2. Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take 
    a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
    For eg., it could be `action`, `animation`, `children`, `classics`, etc.
	*/
drop procedure if exists name_email_category;
delimiter //
create procedure name_email_category(in category_name varchar(100))
begin
	select distinct(concat(a.first_name, ' ', a.last_name)) as customer_name, a.email, e.name as category from sakila.customer as a
			join sakila.rental as b on b.customer_id = a.customer_id
			join sakila.inventory as c on c.inventory_id = b.inventory_id
			join sakila.film_category as d on d.film_id = c.film_id
			join sakila.category as e on e.category_id = d.category_id
            where e.name COLLATE utf8mb4_general_ci = category_name
			group by customer_name, a.email;
end;
//
delimiter ;

call name_email_category('Drama');


	/*
	3. Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter 
    only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.
	*/
select b.name as category_name, count(a.film_id) as amount_films from sakila.film_category as a 
join sakila.category as b on b.category_id = a.category_id
group by category_name;


drop procedure if exists category_amount_films;
delimiter //
create procedure category_amount_films(in param int(4))
begin
	select b.name as category_name, count(a.film_id) as amount_films from sakila.film_category as a 
	join sakila.category as b on b.category_id = a.category_id
    group by category_name
    having amount_films COLLATE utf8mb4_general_ci > param;
end;
//
delimiter ;

call category_amount_films(60);
    