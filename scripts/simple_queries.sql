-- 1. SELECT, чтобы получить информацию о клиентах и их автомобилях
SELECT c.customer_id, c.customer_nm, c.phone_no, ca.maker, ca.model
FROM auto.customer c
         JOIN auto.car ca ON c.customer_id = ca.customer_id;

-- 2. UPDATE, чтобы изменить информацию о клиенте по его идентификатору
UPDATE auto.customer
SET email    = 'new_email@example.com',
    sail_pct = 10
WHERE customer_id = 1;


-- 3. INSERT, чтобы добавить новую запись о заказе
INSERT INTO auto.order (order_id, car_id, open_dt, close_dt, payment_amt, closed_flg)
VALUES (987, 5, '2023-05-19', '2023-05-20', 500.00, true);

-- 4. DELETE, чтобы удалить запись о клиенте по его идентификатору
DELETE
FROM auto.customer
WHERE customer_id = 1;

-- 5. SELECT для получения списка клиентов и связанных с ними автомобилей из таблиц customer и car
SELECT c.customer_nm, c.email, ca.maker, ca.model
FROM auto.customer AS c
         JOIN auto.car AS ca ON c.customer_id = ca.customer_id;

-- 6. SELECT для получения списка клиентов и суммарной скидки для каждого клиента из таблиц customer и sale
SELECT c.customer_nm, SUM(s.sale_pct) AS total_discount
FROM auto.customer AS c
         LEFT JOIN auto.sale AS s ON c.customer_id = s.customer_id
GROUP BY c.customer_nm;

-- 7. SELECT для получения детальной информации о заказе, включая информацию о клиенте, автомобиле, услугах и деталях из соответствующих таблиц
SELECT o.order_id, c.customer_nm, ca.maker, ca.model, s.service_nm, d.detail_nm
FROM auto.order AS o
         JOIN auto.car AS ca ON o.car_id = ca.car_id
         JOIN auto.customer AS c ON ca.customer_id = c.customer_id
         JOIN auto.service_in_order AS sio ON o.order_id = sio.order_id
         JOIN auto.service AS s ON sio.service_id = s.service_id
         JOIN auto.details_in_order AS dio ON o.order_id = dio.order_id
         JOIN auto.details AS d ON dio.detail_id = d.detail_id;

-- 8. SELECT для получения клиентов, у которых общая сумма потраченных средств превышает среднюю сумму по всем клиентам
SELECT c.customer_nm, c.total_sales
FROM auto.customer AS c
WHERE c.total_sales > (SELECT AVG(total_sales) FROM auto.customer);
