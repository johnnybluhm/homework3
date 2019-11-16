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
(ship_country <> 'USA') AND shipped_date BETWEEN '1996-08-01' AND '1996-08-31'
GROUP BY ship_country;

/* RESULT 
 ship_country | shipped 
--------------+---------
 Spain        |       2
 Mexico       |       1
 Brazil       |       1
 UK           |       1
 Italy        |       1
 Venezuela    |       2
 Germany      |       7
 Finland      |       1
 Sweden       |       2
 France       |       2
(10 rows)

*/

--QUERY 6

SELECT customer_id FROM orders GROUP BY
customer_id HAVING
count(*)<4;

/* RESULT
 customer_id 
-------------
 CONSH
 LAZYK
 GROSR
 FRANR
 LAUGB
 THECR
 BOLID
 NORTS
 CENTC
 TRAIH
(10 rows)

*/

--QUERY 7

SELECT supplier_id, SUM(units_in_stock*unit_price) FROM products GROUP BY 
supplier_id HAVING
COUNT(DISTINCT product_id)>3;

/* 
RESULT
 supplier_id |       sum        
-------------+------------------
           2 |  2833.7999420166
           7 | 4409.65005874634
           8 | 4276.99999523163
          12 | 3301.84996032715
(4 rows)


*/

--QUERY 8 

SELECT company_name, product_name, unit_price FROM products
INNER JOIN suppliers
ON products.supplier_id= suppliers.supplier_id
WHERE products.supplier_id= ANY(SELECT suppliers.supplier_id FROM suppliers WHERE country= 'France')
ORDER BY unit_price DESC;

/* 
RESULT
        company_name        |      product_name      | unit_price 
----------------------------+------------------------+------------
 Aux joyeux ecclésiastiques | Côte de Blaye          |      263.5
 Gai pâturage               | Raclette Courdavault   |         55
 Gai pâturage               | Camembert Pierrot      |         34
 Aux joyeux ecclésiastiques | Chartreuse verte       |         18
 Escargots Nouveaux         | Escargots de Bourgogne |      13.25
(5 rows)
*/


--QUERY 9

SELECT last_name, first_name, title, extension, COUNT(employees.employee_id) AS number_of_orders FROM Employees 
INNER JOIN orders
ON employees.employee_id = orders.employee_id
GROUP BY last_name, first_name, title, extension HAVING
count(DISTINCT)<75;

/*RESULT
 last_name | first_name |        title         | extension | number_of_orders 
-----------+------------+----------------------+-----------+------------------
 Suyama    | Michael    | Sales Representative | 428       |               67
 Buchanan  | Steven     | Sales Manager        | 3453      |               42
 King      | Robert     | Sales Representative | 465       |               72
 Dodsworth | Anne       | Sales Representative | 452       |               43
(4 rows)

*/

--QUERY 10

CREATE TABLE top_items(
    item_id INT NOT NULL,
    item_code INT NOT NULL,
    item_name VARCHAR(40) NOT NULL,
    inventory_date DATE NOT NULL,
    supplier_id INT NOT NULL,
    item_quantity INT NOT NULL,
    item_price DECIMAL(9,2) NOT NULL,
    PRIMARY KEY(item_id)
);

--QUERY 11

INSERT INTO top_items
SELECT product_id, category_id, product_name, CURRENT_DATE, units_in_stock, unit_price, supplier_id 
FROM products 
WHERE units_in_stock*unit_price > 2500;

--QUERY 12

DELETE FROM top_items
WHERE item_quantity < 50;

--QUERY 13

ALTER TABLE top_items
ADD inventory_value DECIMAL(9,2) DEFAULT 0;

--QUERY 14

UPDATE top_items
SET inventory_value = item_price*item_quantity;

--QUERY 15

DROP TABLE top_items;

--QUERY 16

SELECT last_name, first_name, COUNT(DISTINCT customer_id) AS clients FROM Employees 
INNER JOIN orders
ON employees.employee_id= orders.employee_id
GROUP BY last_name, first_name HAVING
count(DISTINCT orders.customer_id)>50
ORDER BY clients DESC;

/* RESULT

-------+------------+---------
 Peacock   | Margaret   |      75
 Davolio   | Nancy      |      65
 Leverling | Janet      |      63
 Fuller    | Andrew     |      59
 Callahan  | Laura      |      56
(5 rows)
*/

--QUERY 17

SELECT product_name FROM products WHERE
unit_price<(SELECT AVG(unit_price) from products);

/* RESULT
           product_name           
----------------------------------
 Chai
 Chang
 Aniseed Syrup
 Chef Anton's Cajun Seasoning
 Chef Anton's Gumbo Mix
 Grandma's Boysenberry Spread
 Queso Cabrales
 Konbu
 Tofu
 Genen Shouyu
 Pavlova
 Teatime Chocolate Biscuits
 Sir Rodney's Scones
 Gustaf's Knäckebröd
 Tunnbröd
 Guaraná Fantástica
 NuNuCa Nuß-Nougat-Creme
 Nord-Ost Matjeshering
 Gorgonzola Telino
 Geitost
 Sasquatch Ale
 Steeleye Stout
 Inlagd Sill
 Gravad lax
 Chartreuse verte
 Boston Crab Meat
 Jack's New England Clam Chowder
 Singaporean Hokkien Fried Mee
 Gula Malacca
 Rogede sild
 Spegesild
 Zaanse koeken
 Chocolade
 Maxilaku
 Valkoinen suklaa
 Filo Mix
 Tourtière
 Pâté chinois
 Ravioli Angelo
 Escargots de Bourgogne
 Sirop d'érable
 Louisiana Fiery Hot Pepper Sauce
 Louisiana Hot Spiced Okra
 Laughing Lumberjack Lager
 Scottish Longbreads
 Outback Lager
 Flotemysost
 Röd Kaviar
 Longlife Tofu
 Rhönbräu Klosterbier
 Lakkalikööri
 Original Frankfurter grüne Soße
(52 rows)
*/

--QUERY 18

SELECT count(DISTINCT orders.employee_id) FROM orders JOIN employees
ON orders.employee_id = employees.employee_id
WHERE orders.ship_city != employees.city AND orders.ship_address != employees.address;

/*RESULT 
 count 
-------
     9
(1 row)
*/

--QUERY 19

SELECT employees.first_name, employees.last_name, temp1.client_count, temp2.order_count from employees, (SELECT employee_id, count(DISTINCT customer_id) as client_count FROM orders
WHERE order_date BETWEEN '1998-01-01' AND '1998-12-31'
GROUP BY employee_id) as temp1, (SELECT orders.employee_id as employee_id, count(orders.order_id) as order_count FROM orders
GROUP BY orders.employee_id) as temp2 where employees.employee_id = temp1.employee_id and temp1.employee_id = temp2.employee_id

/*RESULT

 first_name | last_name | client_count | order_count 
------------+-----------+--------------+-------------
 Nancy      | Davolio   |           32 |         123
 Andrew     | Fuller    |           34 |          96
 Janet      | Leverling |           30 |         127
 Margaret   | Peacock   |           33 |         156
 Steven     | Buchanan  |           11 |          42
 Michael    | Suyama    |           17 |          67
 Robert     | King      |           21 |          72
 Laura      | Callahan  |           23 |         104
 Anne       | Dodsworth |           16 |          43
(9 rows)

*/

--QUERY 20

‘Janet Leverling’ wants to know the count of all the orders which were getting shipped from ‘Sweden’ and took less than a week time to ship.


SELECT count(order_id) FROM orders
WHERE ship_country = 'Sweden' 
AND shipped_date-order_date<7 
AND employee_id = (SELECT employee_id FROM employees WHERE first_name='Janet');

/* RESULT
 count 
-------
     1
(1 row)
*/

--QUERY 21

The company ‘Leka Trading’ was blacklisted by the regulators. List out all the product which were being supplied from this supplier.

SELECT product_name FROM products
JOIN suppliers
ON products.supplier_id= suppliers.supplier_id
WHERE company_name = 'Leka Trading';

/* RESULT

         product_name          
-------------------------------
 Singaporean Hokkien Fried Mee
 Ipoh Coffee
 Gula Malacca
(3 rows)

*/


