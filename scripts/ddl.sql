-- Создание схемы "auto"
CREATE SCHEMA IF NOT EXISTS auto;

-- Создание таблицы "customer"
CREATE TABLE IF NOT EXISTS auto.customer (
  customer_id INTEGER PRIMARY KEY,
  customer_nm VARCHAR(50),
  phone_no VARCHAR(50),
  tg_username VARCHAR(30) NOT NULL,
  email VARCHAR(50),
  sail_pct INTEGER,
  total_sales REAL
);

-- Создание таблицы "booking"
CREATE TABLE IF NOT EXISTS auto.booking (
  booking_id INTEGER PRIMARY KEY,
  client_id INTEGER,
  session_dttm TIME NOT NULL,
  CONSTRAINT fk_booking_customer
    FOREIGN KEY (client_id) REFERENCES auto.customer(customer_id)
);

-- Создание таблицы "sale"
CREATE TABLE IF NOT EXISTS auto.sale (
  customer_id INTEGER,
  sale_pct INTEGER,
  total_sales REAL,
  history_dttm TIME NOT NULL,
  CONSTRAINT fk_sale_customer
    FOREIGN KEY (customer_id) REFERENCES auto.customer(customer_id)
);

-- Создание таблицы "car"
CREATE TABLE IF NOT EXISTS auto.car (
  car_id INTEGER PRIMARY KEY,
  customer_id INTEGER,
  maker VARCHAR(50),
  model VARCHAR(50),
  year INTEGER,
  reg_no VARCHAR(50),
  CONSTRAINT fk_car_customer
    FOREIGN KEY (customer_id) REFERENCES auto.customer(customer_id)
);

-- Создание таблицы "order"
CREATE TABLE IF NOT EXISTS auto.order (
  order_id INTEGER PRIMARY KEY,
  car_id INTEGER,
  open_dt DATE,
  close_dt DATE,
  payment_amt REAL,
  closed_flg BOOLEAN,
  CONSTRAINT fk_order_car
    FOREIGN KEY (car_id) REFERENCES auto.car(car_id)
);

-- Создание таблицы "details"
CREATE TABLE IF NOT EXISTS auto.details (
  detail_id INTEGER PRIMARY KEY,
  maker VARCHAR(50),
  detail_cnt INTEGER,
  price REAL,
  detail_nm VARCHAR(50)
);

-- Создание таблицы "details_in_order"
CREATE TABLE IF NOT EXISTS auto.details_in_order (
  order_id INTEGER,
  detail_id INTEGER,
  CONSTRAINT fk_details_in_order_order
    FOREIGN KEY (order_id) REFERENCES auto.order(order_id),
  CONSTRAINT fk_details_in_order_details
    FOREIGN KEY (detail_id) REFERENCES auto.details(detail_id)
);

-- Создание таблицы "service"
CREATE TABLE IF NOT EXISTS auto.service (
  service_id INTEGER PRIMARY KEY,
  service_nm VARCHAR(50),
  price REAL
);

-- Создание таблицы "service_in_order"
CREATE TABLE IF NOT EXISTS auto.service_in_order (
  order_id INTEGER,
  service_id INTEGER,
  CONSTRAINT fk_service_in_order_order
    FOREIGN KEY (order_id) REFERENCES auto.order(order_id),
  CONSTRAINT fk_service_in_order_service
    FOREIGN KEY (service_id) REFERENCES auto.service(service_id)
);
