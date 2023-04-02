USE sakila;

#1. List each pair of actors that have worked together.
SELECT DISTINCT a1.first_name AS actor1_first_name,
                a1.last_name AS actor1_last_name,
                a2.first_name AS actor2_first_name,
                a2.last_name AS actor2_last_name
FROM actor a1
JOIN film_actor fa1 ON a1.actor_id = fa1.actor_id
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
WHERE a1.actor_id < a2.actor_id;

#2.For each film, list actor that has acted in more films.
SELECT f.title AS film_title,
       a.first_name AS actor_first_name,
       a.last_name AS actor_last_name,
       COUNT(DISTINCT fa.film_id) AS num_films
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
JOIN (
    SELECT fa.actor_id, COUNT(DISTINCT fa.film_id) AS num_films
    FROM film_actor fa
    GROUP BY fa.actor_id
) af ON a.actor_id = af.actor_id
LEFT JOIN (
    SELECT f.film_id, fa.actor_id, COUNT(DISTINCT fa.film_id) AS num_films
    FROM film f
    JOIN film_actor fa ON f.film_id = fa.film_id
    GROUP BY f.film_id, fa.actor_id
) ff ON f.film_id = ff.film_id AND a.actor_id = ff.actor_id
GROUP BY f.film_id, a.actor_id
HAVING COUNT(*) = MAX(ff.num_films)