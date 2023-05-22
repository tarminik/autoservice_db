-- 1. Запрос предназначен для выбора производителей автомобилей, у которых количество автомобилей в базе данных превышает 3. Его цель - исследовать производителей, которые представлены в базе данных автосервиса с значительным количеством автомобилей.
SELECT maker,
       COUNT(*) AS car_count
FROM auto.car
GROUP BY maker
HAVING COUNT(*) > 3;

-- 2. Запрос позволяет выбрать клиентов, у которых количество заказов превышает 2 и средняя сумма платежа больше 1000. Это может быть полезным для идентификации клиентов с высокой активностью и значительными средними платежами, что может быть интересно для анализа или принятия управленческих решений.
SELECT c.customer_id,
       c.customer_nm,
       COUNT(o.order_id) AS order_count
FROM auto.customer c
         JOIN
     auto.car cr ON c.customer_id = cr.customer_id
         JOIN
     auto.order o ON cr.car_id = o.car_id
GROUP BY c.customer_id,
         c.customer_nm
HAVING COUNT(*) > 2
   AND AVG(payment_amt) > 1000;

--3. Запрос позволяет выбрать клиентов из базы данных автосервиса и отсортировать их по общей сумме продаж в порядке убывания. Это может быть полезно для идентификации клиентов с наибольшими продажами и выделения наиболее значимых клиентов в контексте автосервиса.
SELECT customer_id,
       customer_nm,
       total_sales
FROM auto.customer
ORDER BY total_sales DESC;

-- 4. Запрос для нумерации заказов каждого клиента в порядке убывания суммы продаж.
SELECT order_id,
       customer_id,
       total_sales,
       ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY total_sales DESC) AS rank
FROM (SELECT o.order_id, c.customer_id, SUM(s.total_sales) AS total_sales
      FROM auto."order" o
               JOIN auto.car c ON o.car_id = c.car_id
               JOIN auto.sale s ON c.customer_id = s.customer_id
      GROUP BY o.order_id, c.customer_id) AS subquery;


-- 5. Запрос выводит топ-3 клиентов с наибольшей суммой продаж.
SELECT customer_id, total_sales
FROM (SELECT customer_id,
             SUM(total_sales)                                   AS total_sales,
             ROW_NUMBER() OVER (ORDER BY SUM(total_sales) DESC) AS rank
      FROM auto.sale
      GROUP BY customer_id) AS subquery
WHERE rank <= 3;


-- 6. Топ 5 клиентов с наибольшим числом заказов.
SELECT c.customer_id, c.customer_nm, COUNT(o.order_id) AS order_count
FROM auto.customer c
         JOIN auto.car ca ON c.customer_id = ca.customer_id
         JOIN auto.order o ON ca.car_id = o.car_id
GROUP BY c.customer_id, c.customer_nm
ORDER BY order_count DESC
LIMIT 5;

-- 7. Запрос для нахождения клиента с наибольшим количеством заказанных услуг.
SELECT customer_id, customer_nm, service_count
FROM (SELECT c.customer_id,
             c.customer_nm,
             COUNT(so.service_id)                                   AS service_count,
             ROW_NUMBER() OVER (ORDER BY COUNT(so.service_id) DESC) AS rank
      FROM auto.customer c
               JOIN auto.car ca ON c.customer_id = ca.customer_id
               JOIN auto."order" o ON ca.car_id = o.car_id
               JOIN auto.service_in_order so ON o.order_id = so.order_id
      GROUP BY c.customer_id, c.customer_nm) AS subquery
WHERE rank = 1;
