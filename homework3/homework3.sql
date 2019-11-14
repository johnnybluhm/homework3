--QUERY 1

SELECT last_name, first_name AS name FROM Employees WHERE
Employees.city = ANY(Select Employees.city FROM Employees WHERE city!='London') AND Employees.hire_date = ANY(SELECT hire_date FROM Employees WHERE ('2019-04-14'-hire_date)>5)
GROUP BY last_name, first_name
ORDER BY last_name;

--RESULT

 last_name |   name   
-----------+----------
 Callahan  | Laura
 Davolio   | Nancy
 Fuller    | Andrew
 Leverling | Janet
 Peacock   | Margaret
(5 rows)

--QUERY 2

SELECT product_id, product_name, units_in_stock, unit_price FROM products WHERE
products.units_in_stock< products.reorder_level AND products.units_in_stock>1;

--RESULT 2 

 /*
 product_id |       product_name        | units_in_stock | unit_price 
------------+---------------------------+----------------+------------
          2 | Chang                     |             17 |         19
          3 | Aniseed Syrup             |             13 |         10
         11 | Queso Cabrales            |             22 |         21
         21 | Sir Rodney's Scones       |              3 |         10
         30 | Nord-Ost Matjeshering     |             10 |      25.89
         32 | Mascarpone Fabioli        |              9 |         32
         37 | Gravad lax                |             11 |         26
         43 | Ipoh Coffee               |             17 |         46
         45 | Rogede sild               |              5 |        9.5
         48 | Chocolade                 |             15 |      12.75
         49 | Maxilaku                  |             10 |         20
         56 | Gnocchi di nonna Alice    |             21 |         38
         64 | Wimmers gute Semmelknödel |             22 |      33.25
         66 | Louisiana Hot Spiced Okra |              4 |         17
         68 | Scottish Longbreads       |              6 |       12.5
         70 | Outback Lager             |             15 |         15
         74 | Longlife Tofu             |              4 |         10
(17 rows)

*/

--QUERY 3

SELECT product_name, unit_price FROM products WHERE
products.unit_price = ANY(SELECT MIN(unit_price) FROM products);

/*  RESULT

 product_name | unit_price 
--------------+------------
 Geitost      |        2.5
(1 row)

*/

--QUERY 4

SELECT product_id, product_name, (units_in_stock*unit_price) AS total_inventory_value FROM products WHERE
(products.unit_price*products.units_in_stock)<200
ORDER BY total_inventory_value ASC;

/* RESULT

 product_id |       product_name        | total_inventory_value 
------------+---------------------------+-----------------------
         29 | Thüringer Rostbratwurst   |                     0
          5 | Chef Anton's Gumbo Mix    |                     0
         53 | Perth Pasties             |                     0
         17 | Alice Mutton              |                     0
         31 | Gorgonzola Telino         |                     0
         21 | Sir Rodney's Scones       |                    30
         74 | Longlife Tofu             |                    40
         45 | Rogede sild               |                  47.5
         66 | Louisiana Hot Spiced Okra |                    68
         68 | Scottish Longbreads       |                    75
         24 | Guaraná Fantástica        |                    90
          3 | Aniseed Syrup             |                   130
         13 | Konbu                     |                   144
         54 | Tourtière                 |      156.449995994568
         48 | Chocolade                 |                191.25
(15 rows)

*/

--QUERY 5

SELECT ship_country, count(ship_via) AS shipped FROM orders WHERE
orders.ship_country = ANY(SELECT ship_country FROM orders WHERE ship_country !='USA') AND orders.order_date = ANY(SELECT YEAR(order_date) AS year, MONTH(order_date) AS month FROM orders WHERE month='08' AND year='1996')
GROUP BY ship_country;






