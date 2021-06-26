{\rtf1\ansi\ansicpg1252\cocoartf2580
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww28600\viewh18000\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 -- Comparing Rental and Inventory Table\
-- how many foreign keys only exist in rental table?\
select\
  count (distinct rental.inventory_id)\
from\
  dvd_rentals.rental\
where\
  not exists (\
    select\
    from\
      dvd_rentals.inventory\
    where\
      rental.inventory_id = inventory.inventory_id\
  );\
-- output ->0\
  -- how many foreign keys only exist in inventory table?\
select\
  count (distinct inventory.inventory_id)\
from\
  dvd_rentals.inventory\
where\
  not exists (\
    select\
    from\
      dvd_rentals.rental\
    where\
      rental.inventory_id = inventory.inventory_id\
  );\
-- output ->1\
  -- Find the spotted 'inventory_id'\
select\
  *\
from\
  dvd_rentals.inventory\
where\
  not exists (\
    select\
    from\
      dvd_rentals.rental\
    where\
      rental.inventory_id = inventory.inventory_id\
  );\
-- output -> inventory_id = 5\
  -- Comparing Inventory and Film table\
  -- how many foreign keys only exist in inventory table?\
select\
  count (distinct inventory.film_id)\
from\
  dvd_rentals.film\
where\
  not exists (\
    select\
    from\
      dvd_rentals.film_category\
    where\
      film.film_id = film_category.film_id\
  );\
-- output ->0\
  -- how many foreign keys only exist in film table?\
select\
  count (distinct film.film_id)\
from\
  dvd_rentals.film_category\
where\
  not exists (\
    select\
    from\
      dvd_rentals.inventory\
    where\
      film.film_id = inventory.film_id\
  );\
-- output ->42\
  -- Comparing Film and Film_Category table\
  -- how many foreign keys only exist in film table?\
select\
  count (distinct film.film_id)\
from\
  dvd_rentals.film\
where\
  not exists (\
    select\
    from\
      dvd_rentals.film_category\
    where\
      film.film_id = film_category.film_id\
  );\
-- output ->0\
  -- how many foreign keys only exist in film_category table?\
select\
  count (distinct film_category.film_id)\
from\
  dvd_rentals.film_category\
where\
  not exists (\
    select\
    from\
      dvd_rentals.film\
    where\
      film.film_id = film_category.film_id\
  );\
-- output ->0\
\
-- Join the complete data_set\
drop table if exists complete_dataset;\
create temp table complete_dataset as\
select\
  rental.customer_id,\
  inventory.inventory_id,\
  film.title,\
  category.name\
from\
  dvd_rentals.rental\
  inner join dvd_rentals.inventory on rental.inventory_id = inventory.inventory_id\
  inner join dvd_rentals.film on inventory.film_id = film.film_id\
  inner join dvd_rentals.film_category on film.film_id = film_category.film_id\
  inner join dvd_rentals.category on film_category.category_id = category.category_id;\
\
select * from complete_dataset limit 5;}