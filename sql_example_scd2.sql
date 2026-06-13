-- Создание RAW таблицы с историей изменений адресов клиентов
CREATE TABLE customer_address_raw (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    address VARCHAR(200) NOT NULL,
    effective_from DATE NOT NULL,
    effective_to DATE NOT NULL,
    current BOOLEAN NOT NULL,
    CONSTRAINT valid_date_range CHECK (effective_from <= effective_to)
);

-- Создание индексов для RAW таблицы
CREATE INDEX idx_raw_customer_id ON customer_address_raw(customer_id);
CREATE INDEX idx_raw_current ON customer_address_raw(current);
CREATE INDEX idx_raw_effective_dates ON customer_address_raw(effective_from, effective_to);

-- Создание ODS таблицы с текущими адресами клиентов
CREATE TABLE customer_address_ods (
    customer_id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    address VARCHAR(200) NOT NULL,
    current BOOLEAN NOT NULL DEFAULT TRUE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Вставка данных в RAW таблицу (~200 строк)
INSERT INTO customer_address_raw (customer_id, name, city, address, effective_from, effective_to, current)
VALUES
-- Клиент 1: история из 3 адресов
(101, 'Иванов Петр Сергеевич', 'Москва', 'ул. Ленина, д. 15, кв. 22', '2020-01-10', '2021-09-14', FALSE),
(101, 'Иванов Петр Сергеевич', 'Москва', 'ул. Пушкина, д. 7, кв. 56', '2021-09-15', '2023-11-30', FALSE),
(101, 'Иванов Петр Сергеевич', 'Москва', 'Ленинградский пр-т, д. 78, кв. 132', '2023-12-01', '9999-12-31', TRUE),

-- Клиент 2: история из 2 адресов
(102, 'Смирнова Анна Васильевна', 'Санкт-Петербург', 'Невский пр-т, д. 112, кв. 45', '2019-05-22', '2022-08-14', FALSE),
(102, 'Смирнова Анна Васильевна', 'Москва', 'Тверская ул., д. 25, кв. 17', '2022-08-15', '9999-12-31', TRUE),

-- Клиент 3: история из 4 адресов
(103, 'Кузнецов Дмитрий Алексеевич', 'Казань', 'ул. Баумана, д. 32, кв. 8', '2018-03-15', '2019-11-20', FALSE),
(103, 'Кузнецов Дмитрий Алексеевич', 'Нижний Новгород', 'ул. Минина, д. 14, кв. 75', '2019-11-21', '2021-04-30', FALSE),
(103, 'Кузнецов Дмитрий Алексеевич', 'Москва', 'Кутузовский пр-т, д. 45, кв. 222', '2021-05-01', '2024-02-28', FALSE),
(103, 'Кузнецов Дмитрий Алексеевич', 'Москва', 'Новый Арбат, д. 16, кв. 154', '2024-03-01', '9999-12-31', TRUE),

-- Клиент 4: история из 2 адресов
(104, 'Соколова Елена Игоревна', 'Екатеринбург', 'ул. Ленина, д. 48, кв. 33', '2021-07-03', '2023-05-19', FALSE),
(104, 'Соколова Елена Игоревна', 'Санкт-Петербург', 'Московский пр-т, д. 189, кв. 42', '2023-05-20', '9999-12-31', TRUE),

-- Клиент 5: история из 3 адресов
(105, 'Новиков Сергей Владимирович', 'Новосибирск', 'Красный пр-т, д. 77, кв. 15', '2019-01-25', '2020-12-31', FALSE),
(105, 'Новиков Сергей Владимирович', 'Красноярск', 'ул. Мира, д. 30, кв. 28', '2021-01-01', '2022-10-14', FALSE),
(105, 'Новиков Сергей Владимирович', 'Сочи', 'ул. Морская, д. 12, кв. 95', '2022-10-15', '9999-12-31', TRUE),

-- Клиент 6: история из 2 адресов
(106, 'Морозова Ольга Андреевна', 'Казань', 'ул. Декабристов, д. 85, кв. 47', '2020-09-17', '2023-03-31', FALSE),
(106, 'Морозова Ольга Андреевна', 'Москва', 'Ленинский пр-т, д. 36, кв. 89', '2023-04-01', '9999-12-31', TRUE),

-- Клиент 7: история из 3 адресов
(107, 'Волков Александр Петрович', 'Ростов-на-Дону', 'ул. Большая Садовая, д. 64, кв. 31', '2018-11-10', '2020-07-23', FALSE),
(107, 'Волков Александр Петрович', 'Краснодар', 'ул. Красная, д. 15, кв. 77', '2020-07-24', '2024-01-10', FALSE),
(107, 'Волков Александр Петрович', 'Санкт-Петербург', 'ул. Рубинштейна, д. 9, кв. 41', '2024-01-11', '9999-12-31', TRUE),

-- Клиент 8: история из 2 адресов
(108, 'Козлова Наталья Сергеевна', 'Самара', 'ул. Ленинградская, д. 25, кв. 12', '2022-02-18', '2023-08-06', FALSE),
(108, 'Козлова Наталья Сергеевна', 'Тольятти', 'ул. Революционная, д. 52, кв. 89', '2023-08-07', '9999-12-31', TRUE),

-- Клиент 9: история из 4 адресов
(109, 'Лебедев Игорь Викторович', 'Владивосток', 'ул. Светланская, д. 83, кв. 29', '2017-06-12', '2019-04-30', FALSE),
(109, 'Лебедев Игорь Викторович', 'Хабаровск', 'ул. Муравьева-Амурского, д. 17, кв. 45', '2019-05-01', '2021-03-14', FALSE),
(109, 'Лебедев Игорь Викторович', 'Иркутск', 'ул. Карла Маркса, д. 39, кв. 74', '2021-03-15', '2023-09-29', FALSE),
(109, 'Лебедев Игорь Викторович', 'Москва', 'Садовое кольцо, д. 10, кв. 111', '2023-09-30', '9999-12-31', TRUE),

-- Клиент 10: история из 3 адресов
(110, 'Павлова Мария Александровна', 'Уфа', 'ул. Ленина, д. 42, кв. 38', '2019-09-01', '2021-11-14', FALSE),
(110, 'Павлова Мария Александровна', 'Пермь', 'Комсомольский пр-т, д. 68, кв. 125', '2021-11-15', '2024-04-23', FALSE),
(110, 'Павлова Мария Александровна', 'Екатеринбург', 'ул. 8 Марта, д. 51, кв. 203', '2024-04-24', '9999-12-31', TRUE);

-- Добавляем больше клиентов для достижения примерно 200 строк в таблице

-- Клиенты 11-20
INSERT INTO customer_address_raw (customer_id, name, city, address, effective_from, effective_to, current)
SELECT
    110 + i AS customer_id,
    CASE (i % 10)
        WHEN 0 THEN 'Петров Алексей Иванович'
        WHEN 1 THEN 'Сидорова Екатерина Петровна'
        WHEN 2 THEN 'Федоров Михаил Николаевич'
        WHEN 3 THEN 'Андреева Юлия Сергеевна'
        WHEN 4 THEN 'Григорьев Антон Дмитриевич'
        WHEN 5 THEN 'Максимова Светлана Игоревна'
        WHEN 6 THEN 'Степанов Владислав Олегович'
        WHEN 7 THEN 'Никитина Анастасия Владимировна'
        WHEN 8 THEN 'Белов Роман Алексеевич'
        WHEN 9 THEN 'Крылова Дарья Максимовна'
    END AS name,
    CASE (i % 7)
        WHEN 0 THEN 'Москва'
        WHEN 1 THEN 'Санкт-Петербург'
        WHEN 2 THEN 'Новосибирск'
        WHEN 3 THEN 'Екатеринбург'
        WHEN 4 THEN 'Казань'
        WHEN 5 THEN 'Нижний Новгород'
        WHEN 6 THEN 'Челябинск'
    END AS city,
    CASE (i % 5)
        WHEN 0 THEN 'ул. Центральная, д. ' || (i + 10) || ', кв. ' || (i * 2)
        WHEN 1 THEN 'пр-т Ленина, д. ' || (i + 15) || ', кв. ' || (i * 3)
        WHEN 2 THEN 'ул. Садовая, д. ' || (i + 7) || ', кв. ' || (i * 4)
        WHEN 3 THEN 'бульвар Победы, д. ' || (i + 3) || ', кв. ' || (i * 5)
        WHEN 4 THEN 'ул. Молодежная, д. ' || (i + 22) || ', кв. ' || (i * 2 + 10)
    END AS address,
    ('2020-01-01'::date + (i * 7 || ' days')::interval)::date AS effective_from,
    ('2022-12-31'::date + (i * 5 || ' days')::interval)::date AS effective_to,
    FALSE AS current
FROM generate_series(1, 10) i;

-- Добавляем текущие адреса для клиентов 11-20
INSERT INTO customer_address_raw (customer_id, name, city, address, effective_from, effective_to, current)
SELECT
    110 + i AS customer_id,
    CASE (i % 10)
        WHEN 0 THEN 'Петров Алексей Иванович'
        WHEN 1 THEN 'Сидорова Екатерина Петровна'
        WHEN 2 THEN 'Федоров Михаил Николаевич'
        WHEN 3 THEN 'Андреева Юлия Сергеевна'
        WHEN 4 THEN 'Григорьев Антон Дмитриевич'
        WHEN 5 THEN 'Максимова Светлана Игоревна'
        WHEN 6 THEN 'Степанов Владислав Олегович'
        WHEN 7 THEN 'Никитина Анастасия Владимировна'
        WHEN 8 THEN 'Белов Роман Алексеевич'
        WHEN 9 THEN 'Крылова Дарья Максимовна'
    END AS name,
    CASE (i % 7)
        WHEN 0 THEN 'Краснодар'
        WHEN 1 THEN 'Сочи'
        WHEN 2 THEN 'Калининград'
        WHEN 3 THEN 'Владивосток'
        WHEN 4 THEN 'Тюмень'
        WHEN 5 THEN 'Самара'
        WHEN 6 THEN 'Ростов-на-Дону'
    END AS city,
    CASE (i % 5)
        WHEN 0 THEN 'ул. Новая, д. ' || (i + 30) || ', кв. ' || (i * 7)
        WHEN 1 THEN 'пер. Солнечный, д. ' || (i + 5) || ', кв. ' || (i * 6)
        WHEN 2 THEN 'ул. Морская, д. ' || (i + 12) || ', кв. ' || (i * 4 + 5)
        WHEN 3 THEN 'пр-т Мира, д. ' || (i + 8) || ', кв. ' || (i * 3 + 10)
        WHEN 4 THEN 'ул. Речная, д. ' || (i + 19) || ', кв. ' || (i * 5 + 2)
    END AS address,
    ('2023-01-01'::date + (i * 10 || ' days')::interval)::date AS effective_from,
    '9999-12-31'::date AS effective_to,
    TRUE AS current
FROM generate_series(1, 10) i;

-- Клиенты 21-40 (с двумя адресами каждый: прошлый и текущий)
INSERT INTO customer_address_raw (customer_id, name, city, address, effective_from, effective_to, current)
SELECT
    120 + i AS customer_id,
    CASE (i % 10)
        WHEN 0 THEN 'Комаров Илья Павлович'
        WHEN 1 THEN 'Маркова Валентина Андреевна'
        WHEN 2 THEN 'Орлов Артем Станиславович'
        WHEN 3 THEN 'Титова Виктория Романовна'
        WHEN 4 THEN 'Калинин Денис Евгеньевич'
        WHEN 5 THEN 'Антонова Ирина Валерьевна'
        WHEN 6 THEN 'Осипов Глеб Кириллович'
        WHEN 7 THEN 'Соловьева Полина Тимофеевна'
        WHEN 8 THEN 'Тимофеев Кирилл Владиславович'
        WHEN 9 THEN 'Давыдова Алиса Артемовна'
    END AS name,
    CASE (i % 8)
        WHEN 0 THEN 'Омск'
        WHEN 1 THEN 'Самара'
        WHEN 2 THEN 'Уфа'
        WHEN 3 THEN 'Красноярск'
        WHEN 4 THEN 'Воронеж'
        WHEN 5 THEN 'Пермь'
        WHEN 6 THEN 'Волгоград'
        WHEN 7 THEN 'Краснодар'
    END AS city,
    'ул. ' || (CASE (i % 10)
        WHEN 0 THEN 'Лесная'
        WHEN 1 THEN 'Парковая'
        WHEN 2 THEN 'Заречная'
        WHEN 3 THEN 'Полевая'
        WHEN 4 THEN 'Степная'
        WHEN 5 THEN 'Луговая'
        WHEN 6 THEN 'Озерная'
        WHEN 7 THEN 'Березовая'
        WHEN 8 THEN 'Цветочная'
        WHEN 9 THEN 'Кленовая'
    END) || ', д. ' || (i + 1) || ', кв. ' || (i * 3) AS address,
    ('2020-01-01'::date + (i * 15 || ' days')::interval)::date AS effective_from,
    ('2023-01-01'::date + (i * 10 || ' days')::interval)::date AS effective_to,
    FALSE AS current
FROM generate_series(1, 20) i;

-- Текущие адреса для клиентов 21-40
INSERT INTO customer_address_raw (customer_id, name, city, address, effective_from, effective_to, current)
SELECT
    120 + i AS customer_id,
    CASE (i % 10)
        WHEN 0 THEN 'Комаров Илья Павлович'
        WHEN 1 THEN 'Маркова Валентина Андреевна'
        WHEN 2 THEN 'Орлов Артем Станиславович'
        WHEN 3 THEN 'Титова Виктория Романовна'
        WHEN 4 THEN 'Калинин Денис Евгеньевич'
        WHEN 5 THEN 'Антонова Ирина Валерьевна'
        WHEN 6 THEN 'Осипов Глеб Кириллович'
        WHEN 7 THEN 'Соловьева Полина Тимофеевна'
        WHEN 8 THEN 'Тимофеев Кирилл Владиславович'
        WHEN 9 THEN 'Давыдова Алиса Артемовна'
    END AS name,
    CASE (i % 6)
        WHEN 0 THEN 'Москва'
        WHEN 1 THEN 'Санкт-Петербург'
        WHEN 2 THEN 'Казань'
        WHEN 3 THEN 'Сочи'
        WHEN 4 THEN 'Севастополь'
        WHEN 5 THEN 'Калининград'
    END AS city,
    CASE (i % 5)
        WHEN 0 THEN 'Кутузовский пр-т, д. ' || (i + 50) || ', кв. ' || (i * 10)
        WHEN 1 THEN 'Ленинский пр-т, д. ' || (i + 30) || ', кв. ' || (i * 8)
        WHEN 2 THEN 'ул. Тверская, д. ' || (i + 15) || ', кв. ' || (i * 12)
        WHEN 3 THEN 'Невский пр-т, д. ' || (i + 40) || ', кв. ' || (i * 11)
        WHEN 4 THEN 'бульвар Приморский, д. ' || (i + 25) || ', кв. ' || (i * 9)
    END AS address,
    ('2023-01-02'::date + (i * 10 || ' days')::interval)::date AS effective_from,
    '9999-12-31'::date AS effective_to,
    TRUE AS current
FROM generate_series(1, 20) i;

-- Клиенты 41-60 (с тремя адресами каждый: два прошлых и текущий)
-- Первый адрес
INSERT INTO customer_address_raw (customer_id, name, city, address, effective_from, effective_to, current)
SELECT
    140 + i AS customer_id,
    'Клиент № ' || (140 + i) AS name,
    CASE (i % 10)
        WHEN 0 THEN 'Тверь'
        WHEN 1 THEN 'Ярославль'
        WHEN 2 THEN 'Иркутск'
        WHEN 3 THEN 'Хабаровск'
        WHEN 4 THEN 'Владивосток'
        WHEN 5 THEN 'Томск'
        WHEN 6 THEN 'Мурманск'
        WHEN 7 THEN 'Архангельск'
        WHEN 8 THEN 'Саратов'
        WHEN 9 THEN 'Тула'
    END AS city,
    'ул. Старая, д. ' || i || ', кв. ' || (i * 2) AS address,
    ('2018-01-01'::date + (i * 20 || ' days')::interval)::date AS effective_from,
    ('2020-01-01'::date + (i * 15 || ' days')::interval)::date AS effective_to,
    FALSE AS current
FROM generate_series(1, 20) i;

-- Второй адрес
INSERT INTO customer_address_raw (customer_id, name, city, address, effective_from, effective_to, current)
SELECT
    140 + i AS customer_id,
    'Клиент № ' || (140 + i) AS name,
    CASE (i % 8)
        WHEN 0 THEN 'Липецк'
        WHEN 1 THEN 'Кострома'
        WHEN 2 THEN 'Киров'
        WHEN 3 THEN 'Пенза'
        WHEN 4 THEN 'Оренбург'
        WHEN 5 THEN 'Астрахань'
        WHEN 6 THEN 'Ульяновск'
        WHEN 7 THEN 'Чебоксары'
    END AS city,
    'пр-т Широкий, д. ' || (i + 10) || ', кв. ' || (i * 4) AS address,
    ('2020-01-02'::date + (i * 15 || ' days')::interval)::date AS effective_from,
    ('2022-06-01'::date + (i * 12 || ' days')::interval)::date AS effective_to,
    FALSE AS current
FROM generate_series(1, 20) i;

-- Третий (текущий) адрес
INSERT INTO customer_address_raw (customer_id, name, city, address, effective_from, effective_to, current)
SELECT
    140 + i AS customer_id,
    'Клиент № ' || (140 + i) AS name,
    CASE (i % 6)
        WHEN 0 THEN 'Москва'
        WHEN 1 THEN 'Санкт-Петербург'
        WHEN 2 THEN 'Казань'
        WHEN 3 THEN 'Сочи'
        WHEN 4 THEN 'Екатеринбург'
        WHEN 5 THEN 'Новосибирск'
    END AS city,
    'ул. Новая, д. ' || (i + 20) || ', кв. ' || (i * 6) AS address,
    ('2022-06-02'::date + (i * 12 || ' days')::interval)::date AS effective_from,
    '9999-12-31'::date AS effective_to,
    TRUE AS current
FROM generate_series(1, 20) i;

-- Заполнение ODS таблицы (текущие записи из RAW таблицы)
INSERT INTO customer_address_ods (customer_id, name, city, address, current)
SELECT customer_id, name, city, address, current
FROM customer_address_raw
WHERE current = TRUE
ORDER BY customer_id
LIMIT 10;

-- Вывод содержимого ODS таблицы
SELECT * FROM customer_address_ods ORDER BY customer_id;

-- Вывод полной истории изменений для определенного клиента
SELECT * FROM customer_address_raw
WHERE customer_id = 103
ORDER BY effective_from;

-- Проверка количества строк в RAW таблице
SELECT COUNT(*) FROM customer_address_raw;

-- Проверка количества строк в ODS таблице
SELECT COUNT(*) FROM customer_address_ods;

-- Статистика количества переездов по клиентам
SELECT customer_id, name, COUNT(*) as address_changes
FROM customer_address_raw
GROUP BY customer_id, name
ORDER BY address_changes DESC, customer_id
LIMIT 10;

-- Топ-5 городов по количеству текущих адресов
SELECT city, COUNT(*) as residents
FROM customer_address_ods
GROUP BY city
ORDER BY residents DESC
LIMIT 5;

-- Клиенты, которые переехали из одного города в другой
SELECT r1.customer_id, r1.name,
       r1.city as previous_city,
       r2.city as current_city,
       r1.effective_to as moved_date
FROM customer_address_raw r1
JOIN customer_address_raw r2
  ON r1.customer_id = r2.customer_id
  AND r1.effective_to = r2.effective_from
WHERE r1.city <> r2.city
ORDER BY moved_date DESC
LIMIT 10;