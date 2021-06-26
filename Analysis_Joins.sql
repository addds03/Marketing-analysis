-- Comparing Rental and Inventory Table

-- how many foreign keys only exist in rental table?
select
  count (distinct rental.inventory_id)
from
  dvd_rentals.rental
where
  not exists (
    select
    from
      dvd_rentals.inventory
    where
      rental.inventory_id = inventory.inventory_id
  );
-- output ->0

-- how many foreign keys only exist in inventory table?
select
  count (distinct inventory.inventory_id)
from
  dvd_rentals.inventory
where
  not exists (
    select
    from
      dvd_rentals.rental
    where
      rental.inventory_id = inventory.inventory_id
  );
-- output ->1

-- Find the spotted 'inventory_id'
select
  *
from
  dvd_rentals.inventory
where
  not exists (
    select
    from
      dvd_rentals.rental
    where
      rental.inventory_id = inventory.inventory_id
  );
-- output -> inventory_id = 5

-- Comparing Inventory and Film table

-- how many foreign keys only exist in inventory table?
select
  count (distinct inventory.film_id)
from
  dvd_rentals.inventory
where
  not exists (
    select
    from
      dvd_rentals.film
    where
      film.film_id = inventory.film_id
  );
-- output ->1

-- how many foreign keys only exist in film table?
select
  count (distinct film.film_id)
from
  dvd_rentals.film
where
  not exists (
    select
    from
      dvd_rentals.inventory
    where
      film.film_id = inventory.film_id
  );
-- output ->42

  
