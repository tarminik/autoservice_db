-- Создание схемы "auto"
CREATE SCHEMA IF NOT EXISTS auto;

-- Создание таблицы "customer"
CREATE TABLE IF NOT EXISTS auto.customer
(
    customer_id SERIAL PRIMARY KEY,
    customer_nm VARCHAR(50),
    phone_no    VARCHAR(50),
    tg_username VARCHAR(50) NOT NULL,
    email       VARCHAR(50),
    sail_pct    INTEGER CHECK (sail_pct BETWEEN 0 AND 100),
    total_sales REAL CHECK (total_sales >= 0)
);

-- Создание таблицы "booking"
CREATE TABLE IF NOT EXISTS auto.booking
(
    booking_id   SERIAL PRIMARY KEY,
    client_id    SERIAL,
    session_dttm TIME NOT NULL,
    CONSTRAINT fk_booking_customer
        FOREIGN KEY (client_id) REFERENCES auto.customer (customer_id)
);

-- Создание таблицы "sale"
CREATE TABLE IF NOT EXISTS auto.sale
(
    customer_id  SERIAL,
    sale_pct     INTEGER CHECK (sale_pct >= 0 AND sale_pct >= 100),
    total_sales  REAL CHECK (total_sales >= 0),
    history_dttm TIME NOT NULL,
    CONSTRAINT pk_sale PRIMARY KEY (customer_id, history_dttm),
    CONSTRAINT fk_sale_customer
        FOREIGN KEY (customer_id) REFERENCES auto.customer (customer_id)
);

-- Создание таблицы "car"
CREATE TABLE IF NOT EXISTS auto.car
(
    car_id      SERIAL PRIMARY KEY,
    customer_id SERIAL,
    maker       VARCHAR(50),
    model       VARCHAR(50),
    year        INTEGER,
    reg_no      VARCHAR(50),
    CONSTRAINT fk_car_customer
        FOREIGN KEY (customer_id) REFERENCES auto.customer (customer_id)
);

-- Создание таблицы "order"
CREATE TABLE IF NOT EXISTS auto.order
(
    order_id    SERIAL PRIMARY KEY,
    car_id      SERIAL,
    open_dt     DATE,
    close_dt    DATE,
    payment_amt REAL,
    closed_flg  BOOLEAN,
    CONSTRAINT fk_order_car
        FOREIGN KEY (car_id) REFERENCES auto.car (car_id)
);

-- Создание таблицы "details"
CREATE TABLE IF NOT EXISTS auto.details
(
    detail_id  SERIAL PRIMARY KEY,
    maker      VARCHAR(50),
    detail_cnt INTEGER CHECK (detail_cnt >= 0),
    price      REAL CHECK (price >= 0),
    detail_nm  VARCHAR(50)
);

-- Создание таблицы "details_in_order"
CREATE TABLE IF NOT EXISTS auto.details_in_order
(
    order_id  SERIAL,
    detail_id SERIAL,
    CONSTRAINT pk_details_in_order PRIMARY KEY (order_id, detail_id),
    CONSTRAINT fk_details_in_order_order
        FOREIGN KEY (order_id) REFERENCES auto.order (order_id),
    CONSTRAINT fk_details_in_order_details
        FOREIGN KEY (detail_id) REFERENCES auto.details (detail_id)
);

-- Создание таблицы "service"
CREATE TABLE IF NOT EXISTS auto.service
(
    service_id SERIAL PRIMARY KEY,
    service_nm VARCHAR(50),
    price      REAL CHECK (price >= 0)
);

-- Создание таблицы "service_in_order"
CREATE TABLE IF NOT EXISTS auto.service_in_order
(
    order_id   SERIAL,
    service_id SERIAL,
    CONSTRAINT pk_service_in_order PRIMARY KEY (order_id, service_id),
    CONSTRAINT fk_service_in_order_order
        FOREIGN KEY (order_id) REFERENCES auto.order (order_id),
    CONSTRAINT fk_service_in_order_service
        FOREIGN KEY (service_id) REFERENCES auto.service (service_id)
);
