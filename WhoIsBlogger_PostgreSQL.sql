--Users(userId, age)
CREATE TABLE Users (
    userId SERIAL PRIMARY KEY,
    age INTEGER
);
-- каждый userId из таблицы Users является уникальным 
INSERT INTO Users (age) VALUES
    (25),
    (30),
    (25),
    (28),
    (32),
    (40),
    (22),
    (30),
    (31),
    (27),
    (33),
    (37),
    (40),
    (26),
    (36),
    (39),
    (33),
    (34),
    (28),
    (41);

--  Items (itemId, price).
CREATE TABLE Items (
    itemId INTEGER PRIMARY KEY,
    price INTEGER
);
INSERT INTO Items (itemId, price) VALUES
    (101, 12000),
    (102, 40000),
    (103, 5000),
    (104, 4000),
    (105, 30000),
    (106, 100000),
    (107, 2300),
    (108, 19999),
    (109, 30000),
    (110, 27000),
    (111, 33000),
    (112, 34000),
    (113, 200),
    (114, 20000),
    (115, 30000),
    (116, 10000),
    (117, 999),
    (118, 9999),
    (119, 1000),
    (120, 40000);

/*
У нас есть ситуация при которой человек пользователь (userId) покупает несколько 
предметов, т.о у нас в покупках (Purchases) будет ситуация при которой в рамках 
одной сделки, покупки (purchaseId) будет несколько строчек с одним purchaseId в 
которых будет в колонке itemId один человек (т.е и в purchaseId и в userId будут
строки с одинаковыми значениями, эти кололнки НЕ будут уникальными). itemId так же
не будет уникальными т.к разные люди могут покупать одинаковый товар
*/
-- Purchases (purchaseId, userId, itemId, date)
CREATE TABLE Purchases (
    purchaseId INTEGER,
    userId INTEGER REFERENCES Users(userId),
    itemId INTEGER REFERENCES Items(itemId),
    date DATE
);
INSERT INTO Purchases (purchaseId, userId, itemId, date)
VALUES
	(71, 1, 101, '2022-01-01'),
    (71, 1, 102, '2022-01-01'),
    (71, 1, 103, '2022-01-01'),
    (71, 1, 104, '2022-01-01'),
    (71, 1, 105, '2022-01-01'),
    (61, 1, 112, '2022-02-01'),
  	(72, 2, 102, '2022-01-02'),
    (72, 2, 101, '2022-01-02'),
	(72, 2, 120, '2022-01-02'),
    (73, 3, 103, '2022-01-03'),
    (62, 3, 105, '2022-02-03'),
    (74, 4, 104, '2022-01-04'),
    (74, 4, 101, '2022-01-04'),
    (75, 5, 101, '2022-01-01'),
    (75, 5, 107, '2022-01-01'),
    (75, 5, 109, '2022-01-01'),
    (75, 5, 110, '2022-01-01'),
    (76, 6, 106, '2022-01-02'),
    (77, 7, 101, '2022-01-05'),
    (77, 7, 114, '2022-01-05'),
    (77, 7, 117, '2022-01-05'),
    (63, 7, 119, '2022-02-05'),
    (78, 8, 108, '2022-01-06'),
    (79, 9, 109, '2022-01-06'),
    (80, 10, 110, '2022-01-07'),
    (80, 10, 111, '2022-01-07'),
    (81, 11, 111, '2022-01-08'),
    (81, 11, 112, '2022-01-08'),
    (82, 12, 101, '2022-01-05'),
    (82, 12, 102, '2022-01-05'),
    (82, 12, 112, '2022-01-05'),
    (83, 13, 113, '2022-01-01'),
    (64, 13, 117, '2022-02-01'),
    (84, 14, 113, '2022-01-01'),
    (85, 15, 115, '2022-01-01'),
    (85, 15, 116, '2022-01-01'),
	(85, 15, 119, '2022-01-01'),
    (86, 16, 115, '2022-01-02'),
    (87, 17, 117, '2022-01-02'),
    (88, 18, 102, '2022-01-03'),
    (88, 18, 104, '2022-01-03'),
    (88, 18, 107, '2022-01-03'),
    (89, 19, 120, '2022-01-04'),
    (90, 20, 120, '2022-01-20');
    
/*
А) какую сумму в среднем в месяц тратит:
- пользователи в возрастном диапазоне от 18 до 25 лет включительно
- пользователи в возрастном диапазоне от 26 до 35 лет включительно
*/
  
--- пользователи в возрастном диапазоне от 18 до 25 лет включительно
SELECT subquery.userId,
		EXTRACT(MONTH FROM subquery.date) AS month,
        AVG(subquery.price) AS average_spending
FROM ( 
	SELECT Purchases.*, Users.age, Items.price
    FROM Purchases
    JOIN Users ON Purchases.userId = Users.userId
    JOIN Items ON Purchases.itemId = Items.itemId
    WHERE Users.age BETWEEN 18 AND 25
) AS subquery
GROUP BY subquery.userId, EXTRACT(MONTH FROM subquery.date)
ORDER BY subquery.userId, month;


-- пользователи в возрастном диапазоне от 26 до 35 лет включительно
SELECT subquery.userId,
		EXTRACT(MONTH FROM subquery.date) AS month,
        AVG(subquery.price) AS average_spending
FROM ( 
	SELECT Purchases.*, Users.age, Items.price
    FROM Purchases
    JOIN Users ON Purchases.userId = Users.userId
    JOIN Items ON Purchases.itemId = Items.itemId
    WHERE Users.age BETWEEN 26 AND 35
) AS subquery
GROUP BY subquery.userId, EXTRACT(MONTH FROM subquery.date)
ORDER BY subquery.userId, month;


-- в каком месяце года выручка от пользователей в возрастном диапазоне 35+ самая большая
-- Изначально у меня в Purchases были данные только за один месяц (Январь), 
-- но когда начал делать это задание ввел несколько дополнительных строчек с 
-- указанием Февраля
SELECT 
	CASE
      WHEN EXTRACT(MONTH FROM subquery.date) = 1 THEN 'Январь'
      WHEN EXTRACT(MONTH FROM subquery.date) = 2 THEN 'Февраль'
      WHEN EXTRACT(MONTH FROM subquery.date) = 3 THEN 'Март'
      WHEN EXTRACT(MONTH FROM subquery.date) = 4 THEN 'Апрель'
      WHEN EXTRACT(MONTH FROM subquery.date) = 5 THEN 'Май'
      WHEN EXTRACT(MONTH FROM subquery.date) = 6 THEN 'Июнь'
      WHEN EXTRACT(MONTH FROM subquery.date) = 7 THEN 'Июль'
      WHEN EXTRACT(MONTH FROM subquery.date) = 8 THEN 'Август'
      WHEN EXTRACT(MONTH FROM subquery.date) = 9 THEN 'Сентябрь'
      WHEN EXTRACT(MONTH FROM subquery.date) = 10 THEN 'Октябрь'
      WHEN EXTRACT(MONTH FROM subquery.date) = 11 THEN 'Ноябрь'
      WHEN EXTRACT(MONTH FROM subquery.date) = 12 THEN 'Декабрь'
	END AS month_name,
	SUM(subquery.price) AS total_revenue
FROM ( 
	SELECT Purchases.*, Users.age, Items.price
    FROM Purchases
    JOIN Users ON Purchases.userId = Users.userId
    JOIN Items ON Purchases.itemId = Items.itemId
    WHERE Users.age >= 35
) AS subquery
-- групируем по месяцам
GROUP BY month_name
ORDER BY total_revenue DESC
LIMIT 1;
 
-- какой товар обеспечивает дает наибольший вклад в выручку за последний год
-- в моем случае последний год 2022, в выражение можно указать любые года
-- в ответе будет три значения: год за который смотрим, itemid - товар который мы нашли
-- общая сумма выручки по этому товару
SELECT EXTRACT(YEAR FROM subquery.date) AS year_name,
	   subquery.itemid,
	   SUM(subquery.price) AS total_revenue  
FROM ( 
	SELECT Purchases.*, Items.price
    FROM Purchases
    JOIN Items ON Purchases.itemId = Items.itemId
) AS subquery
WHERE EXTRACT(YEAR FROM subquery.date) = 2022
GROUP BY year_name, subquery.itemid
-- сортируем в убывание чтобы взять первый элемент из получившийся таблице
ORDER BY total_revenue DESC
LIMIT 1;


-- топ-3 товаров по выручке и их доля в общей выручке за любой год
-- под фразой за любой год я понял что мы указываем за какой конкретно год хотим искать
select  top3Items.itemid, 
	    top3Items.total_revenue AS productprofit,
        CAST(top3Items.total_revenue AS float) / 
        CAST(total_revenue_year.total_year_earnings AS float) * 100 AS share_of_total_prof
from (
	--1 й подзапрос, вычисляем выручку топ 3 товара (itemid) за указанный год
    SELECT Items.itemId, SUM(Items.price) AS total_revenue
    FROM Purchases
    JOIN Items ON Purchases.itemId = Items.itemId
    -- JOIN чтобы отфильтровать по дате
    WHERE EXTRACT(YEAR FROM Purchases.date) = 2022
    GROUP BY Items.itemId
    ORDER BY total_revenue DESC
    LIMIT 3
  ) AS top3Items 
  CROSS JOIN (
    -- 2й подзапрос, находим общую выручку за указанный год
    SELECT SUM(Items.price) AS total_year_earnings
    FROM Purchases
    JOIN Items ON Purchases.itemId = Items.itemId
    WHERE EXTRACT(YEAR FROM Purchases.date) = 2022
  ) AS total_revenue_year;
    











--select * from Users;
--select * from Items;
--select * from Purchases;
    
