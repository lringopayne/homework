 -- Display the first and last names of all actors from the table `actor`
 use sakila;
 Select first_name, last_name
 From actor;
 
 -- Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
Select upper(concat(first_name, " ", last_name)) as "Actor_Name"
From actor; 

-- You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
Select actor_id, first_name, last_name
From actor
Where first_name = "Joe";

-- Find all actors whose last name contain the letters `GEN`:
Select last_name, first_name
from actor
Where last_name like "%GEN%";

-- Find all actors whose last names contain the letters `LI`. 
-- This time, order the rows by last name and first name, in that order:
Select last_name, first_name
from actor
Where last_name like "%LI%"
order by last_name, first_name;

-- Using `IN`, display the `country_id` and `country` columns of the following countries: 
-- Afghanistan, Bangladesh, and China:
Select country_id, country
From country
Where country in ("Afghanistan", "Bangladesh", "China");

-- You want to keep a description of each actor. 
-- You don't think you will be performing queries on a description, so create a 
-- column in the table `actor` named `description` and use the data type `BLOB` 
-- (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor
ADD description blob;

-- Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the `description` column.
ALTER TABLE actor
DROP description;

-- List the last names of actors, as well as how many actors have that last name.
Select last_name, count(*)
From actor
Group By last_name;

-- List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
Select last_name, count(*)
From actor
Group By last_name
Having count(*) >= 2; 

 -- The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`.
 -- Write a query to fix the record.
UPDATE actor
SET
first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

 -- Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

UPDATE actor
SET
first_name = IF( first_name = 'HARPO', 'GROUCHO', first_name )
WHERE last_name = 'WILLIAMS';

-- You cannot locate the schema of the `address` table. Which query would you use to re-create it?

SHOW CREATE TABLE address;

-- OR

SELECT `table_schema` 
FROM `information_schema`.`tables` 
WHERE `table_name` = 'address';

-- Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

 Select s.first_name, s.last_name, a.address
 From staff s
 Join address a ON s.address_id = a.address_id;
 
 -- Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
 
Select concat(s.first_name, " ", s.last_name) as "Staff_Name", sum(p.amount) as "Total_Amount"
From payment p
Join staff s ON p.staff_id = s.staff_id
Where p.payment_date like "%2005-08%"
Group By p.staff_id;

-- List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

Select f.title, count(fa.film_id) as "Number_of_Actors"
From film_actor fa
Inner Join film f ON fa.film_id = f.film_id
Group By fa.film_id;

-- How many copies of the film `Hunchback Impossible` exist in the inventory system?

Select f.title, count(i.film_id) as "Number_of_Copies"
From inventory i
Join film f ON i.film_id = f.film_id
Where f.title = 'Hunchback Impossible'
Group By i.film_id;

-- Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

Select  c.last_name, c.first_name, sum(p.amount) as "Total_Amount"
From payment p
Join customer c ON p.customer_id = c.customer_id
Group By p.customer_id
order by c.last_name, c.first_name;

-- The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

Select
b.title
from (Select f.title
From film f
Join language l ON f.language_id = l.language_id
Where l.name = 'English') b
Where (title like "K%") OR (title like "Q%");

-- Use subqueries to display all actors who appear in the film `Alone Trip`.

Select concat(a.first_name, " ", a.last_name) as "Actor_Name"
From(Select fa.actor_id 
From film_actor fa
Join film f ON fa.film_id = f.film_id
Where f.title = 'Alone Trip') new_table
Join actor a ON new_table.actor_id = a.actor_id;

-- You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select concat(c.first_name, " ", c.last_name) as "Customer_Name"
From customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
Where co.country = 'Canada';

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select f.title as "Family Films"
From film_category fc
join film f on fc.film_id = f.film_id
join category c on fc.category_id = c.category_id
Where c.name = 'Family';

-- Display the most frequently rented movies in descending order.

select f.title as "Most Recent Films"
From rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
order by r.rental_date;

-- Write a query to display how much business, in dollars, each store brought in.

Select  a.address as "Store Address", concat('$', sum(p.amount)) as "Total Sales"
From payment p
Join staff s ON p.staff_id = s.staff_id
Join store st ON s.store_id = st.store_id
Join address a ON st.address_id = a.address_id
Group By p.staff_id;

-- Write a query to display for each store its store ID, city, and country.

Select  s.store_id , ci.city, co.country
From store s
Join address a ON s.address_id = a.address_id
Join city ci ON a.city_id = ci.city_id
Join country co ON ci.country_id = co.country_id;

-- List the top five genres in gross revenue in descending order. 
-- (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

Select c.name, sum(p.amount) as "Gross Revenue"
From payment p
Join rental r ON p.rental_id = r.rental_id
Join inventory i ON r.inventory_id = i.inventory_id
Join film_category fc ON i.film_id = fc.film_id
Join category c ON fc.category_id = c.category_id
Group By c.name
order by sum(p.amount) DESC
limit 5;

-- In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW
new_view
AS Select c.name, sum(p.amount) as "Gross Revenue"
From payment p
Join rental r ON p.rental_id = r.rental_id
Join inventory i ON r.inventory_id = i.inventory_id
Join film_category fc ON i.film_id = fc.film_id
Join category c ON fc.category_id = c.category_id
Group By c.name
order by sum(p.amount) DESC
limit 5;

-- How would you display the view that you created in 8a?

SELECT * FROM sakila.new_view;

-- You find that you no longer need the view `top_five_genres`. Write a query to delete it.

DROP VIEW new_view;