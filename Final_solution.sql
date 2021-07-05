{\rtf1\ansi\ansicpg1252\cocoartf2580
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 --Create Base Dataset\
DROP TABLE IF EXISTS complete_joint_dataset;\
CREATE TEMP TABLE complete_joint_dataset AS\
SELECT\
  rental.customer_id,\
  inventory.film_id,\
  film.title,\
  category.name AS category_name,\
  rental.rental_date\
FROM\
  dvd_rentals.rental\
  INNER JOIN dvd_rentals.inventory ON rental.inventory_id = inventory.inventory_id\
  INNER JOIN dvd_rentals.film ON inventory.film_id = film.film_id\
  INNER JOIN dvd_rentals.film_category ON film.film_id = film_category.film_id\
  INNER JOIN dvd_rentals.category ON film_category.category_id = category.category_id;\
\
--Category counts\
  DROP TABLE IF EXISTS category_counts;\
CREATE TEMP TABLE category_counts AS\
SELECT\
  customer_id,\
  category_name,\
  COUNT(*) AS rental_count,\
  MAX(rental_date) AS latest_rental_date\
FROM\
  complete_joint_dataset\
GROUP BY\
  customer_id,\
  category_name;\
\
--Total counts\
  DROP TABLE IF EXISTS total_counts;\
CREATE TEMP TABLE total_counts AS\
SELECT\
  customer_id,\
  SUM(rental_count) AS total_count\
FROM\
  category_counts\
GROUP BY\
  customer_id;\
\
--Top Categories\
  DROP TABLE IF EXISTS top_categories;\
CREATE TEMP TABLE top_categories AS WITH ranked_cte AS (\
    SELECT\
      customer_id,\
      category_name,\
      rental_count,\
      DENSE_RANK() OVER(\
        PARTITION BY customer_id\
        ORDER BY\
          rental_count DESC,\
          latest_rental_date DESC,\
          category_name\
      ) AS category_rank\
    FROM\
      category_counts\
  )\
SELECT\
  *\
FROM\
  ranked_cte\
WHERE\
  category_rank < 3;\
--Average Category count\
  DROP TABLE IF EXISTS average_category_count;\
CREATE TEMP TABLE average_category_count AS\
SELECT\
  category_name,\
  FLOOR(AVG(rental_count)) AS category_average\
FROM\
  category_counts\
GROUP BY\
  category_name;\
\
--Top Category Percentile\
SELECT\
  category_name,\
  PERCENT_RANK() OVER(\
    PARTITION BY category_name\
    ORDER BY\
      rental_count DESC\
  ) AS percentile\
FROM\
  category_counts\
limit\
  5;}