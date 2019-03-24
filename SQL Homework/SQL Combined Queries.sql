-- 1a. Display the first and last names of all actors from the table `actor`. --
USE sakila;
SELECT 
first_name AS First_Name, 
last_name AS Last_Name 
FROM actor; 

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT 
CONCAT(first_name, " ", last_name) AS Actor_Name 
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT 
actor_id as ID, 
first_name as First_Name, 
last_name as Last_Name
FROM actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT 
first_name as First_Name, 
last_name as Last_Name
FROM actor
WHERE last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters `LI`. 
-- This time, order the rows by last name and first name, in that order:
SELECT 
first_name as First_Name, 
last_name as Last_Name
FROM actor
WHERE last_name like '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id AS ID, 
country AS Country
FROM country 
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. 
-- You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` 
-- and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor 
ADD COLUMN description BLOB NOT NULL AFTER last_update;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor 
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT 
last_name as Last_Name, 
COUNT(last_name) as Count
FROM actor 
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT 
last_name,
COUNT(last_name) AS Count
FROM actor 
GROUP BY last_name
HAVING (COUNT(last_name) >=2);


-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. 
-- Write a query to fix the record.
UPDATE actor 
SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO' AND last_name = 'Williams';


-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
-- It turns out that `GROUCHO` was the correct name after all! In a single query, 
-- if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor
SET first_name = 'GROUCHO' 
WHERE first_name = 'HARPO';


-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;


-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
ON s.address_id = a.address_id;


-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT s.first_name AS First_Name, s.last_name AS Last_Name, SUM(p.amount) as Total_Amount
FROM payment p
JOIN staff s
ON p.staff_id =s.staff_id
WHERE p.payment_date like '2005-08%'
GROUP BY first_name;


--  6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT f.title as Movie_Title, COUNT(DISTINCT fa.actor_id) as Number_of_Actors
FROM film_actor fa
INNER JOIN film f 
ON fa.film_id = f.film_id 
GROUP BY f.title;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT f.title as Movie_Title, COUNT(i.film_id) as Count_of_Movie
FROM film f 
INNER JOIN inventory i  
ON f.film_id = i.film_id 
WHERE f.title = 'Hunchback Impossible';



-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT c.first_name AS First_Name, c.last_name AS Last_Name, SUM(p.amount) as Total_Paid
FROM payment p
JOIN customer c
ON p.customer_id = c.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY last_name asc;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title
FROM film
WHERE title like 'K%' or title like 'Q%' and language_id in 
(SELECT language_id 
FROM language 
WHERE name='English'
);


-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT film_id, title 
FROM film 
WHERE title ='Alone Trip';

SELECT first_name, last_name 
FROM actor
WHERE actor_id IN 
(SELECT actor_id 
FROM film_actor 
WHERE film_id=17
);


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information
SELECT first_name, last_name, email
FROM customer
JOIN address ON address.address_id = customer.address_id
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id
Where country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as _family_ films. 
SELECT title 
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c on fc.category_id = c.category_id
where name='Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(rental_id) AS Total_Rentals 
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY title
ORDER BY total_rentals DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in
SELECT store_id, address, sum(amount) as total_dollars 
FROM address
JOIN store ON store.address_id = address.address_id
JOIN payment ON store.manager_staff_id = payment.staff_id
GROUP BY store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, address, city, country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city c ON c.city_id = a.city_id
JOIN country cu ON c.country_id = cu.country_id
GROUP BY store_id;

-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT name AS film_category, sum(amount) AS total_revenue
FROM payment
JOIN rental ON rental.rental_id = payment.rental_id
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film_category ON film_category.film_id = inventory.film_id
JOIN category ON category.category_id = film_category.category_id
GROUP BY name
ORDER BY total_revenue DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres AS
SELECT name AS film_category, sum(amount) AS total_revenue
FROM payment
JOIN rental ON rental.rental_id = payment.rental_id
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film_category ON film_category.film_id = inventory.film_id
JOIN category ON category.category_id = film_category.category_id
GROUP BY name
ORDER BY total_revenue DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a? --
SELECT * FROM top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it. --
DROP VIEW top_five_genres; 
