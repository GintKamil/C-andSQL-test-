/*Создание таблиц*/
CREATE TABLE Products
(
ID INT PRIMARY KEY IDENTITY,
NameProduct NVARCHAR(30) NOT NULL,
Cost MONEY NOT NULL,
Volume INT NOT NULL,
);

CREATE TABLE Managers
(
ID INT PRIMARY KEY IDENTITY,
Fio NVARCHAR(50) NOT NULL,
Salary MONEY NOT NULL,
Age INT NOT NULL,
Phone NVARCHAR(12) NOT NULL,
);

CREATE TABLE Sells
(
ID INT PRIMARY KEY IDENTITY,
ID_Manag INT NOT NULL,
ID_Prod INT NOT NULL,
CountSells INT NOT NULL,
SumSells MONEY NOT NULL,
DateSells DATE NOT NULL,
FOREIGN KEY (ID_Manag) REFERENCES Managers(ID),
FOREIGN KEY (ID_Prod) REFERENCES Products(ID),
);

/*Заполнение таблиц (сначало не знал какая тема магазина, поэтому сначало добавил свои продукты, после уже добавил требуемые)*/
INSERT INTO Products (NameProduct, Cost, Volume) 
VALUES ('Телевизор', 100000, 10), 
('Телефон', 250000, 20), 
('Холодильник', 150000, 5), 
('Наушники', 42000, 30), 
('Ноутбук', 200000, 4),
('Фанера', 60000, 100),
('ОСБ', 50000, 100);

INSERT INTO Managers (Fio, Salary, Age, Phone) 
VALUES ('Иванов И.И.', 50000, 30, '7234567890'), 
('Сергеев С.С.', 60000, 35, '7987654321'), 
('Громова И.В.', 55000, 32, '7765432109'), 
('Никитин Н.Н.', 48000, 28, '7192837465'), 
('Власов В.С.', 52000, 31, '7647382910');

INSERT INTO Sells (ID_Manag, ID_Prod, CountSells, SumSells, DateSells) 
VALUES (1, 1, 1, 150000, '2021-01-01'), 
(2, 2, 2, 40000, '2021-02-05'), 
(3, 3, 1, 40000, '2021-03-10'), 
(4, 4, 3, 5000, '2021-04-15'), 
(5, 5, 2, 120000, '2021-06-20'),
(5, 4, 1, 1700, '2021-06-20'),
(1, 6, 10, 20000, '2021-04-24'),
(3, 7, 5, 3000, '2021-05-05'),
(1, 7, 15, 9000, '2021-08-22'); 


/*1. Вывести менеджеров, у которых есть номер телефона*/
SELECT Fio FROM Managers WHERE Phone IS NOT NULL;

/*2. Вывести кол-во продаж на 20 июня 2021*/
SELECT COUNT(*) FROM Sells WHERE DateSells = '2021-06-20';

/*3. Вывести среднюю сумму продаж с товаром Фанера */
SELECT AVG(Sells.SumSells) AS AverageSumSells 
FROM Sells 
INNER JOIN Products ON Sells.ID_Prod = Products.ID 
WHERE Products.NameProduct LIKE '%Фанера%';

/*4. Вывести ФИО и сумму продаж с товаром 'ОСБ'*/
SELECT M.Fio, S.SumSells 
FROM Managers M 
INNER JOIN Sells S ON M.ID = S.ID_Manag 
INNER JOIN Products P ON S.ID_Prod = P.ID 
WHERE P.NameProduct = 'ОСБ'

/*5. Вывести менеджера и товар, проданный 22 августа 2021*/
SELECT M.Fio, P.NameProduct
FROM Managers M
INNER JOIN Sells S ON M.ID = S.ID_Manag
INNER JOIN Products P ON S.ID_Prod = P.ID
WHERE S.DateSells = '2021-08-22';

/*6. Вывести все товары, у которых в название есть слово Фанера и цена не ниже 1750*/
SELECT NameProduct, Cost/Volume AS PricePerUnit
FROM Products
WHERE NameProduct LIKE '%Фанера%' AND Cost/Volume >= 1750;

/*7. Вывести историю продаж товаров, группируя по месяцу продажи и наименованию товара*/ 
SELECT p.NameProduct, MONTH(s.DateSells) AS Month, SUM(s.CountSells) AS CountSells, SUM(s.SumSells) AS SumSells 
FROM Products p 
JOIN Sells s ON p.ID = s.ID_Prod 
GROUP BY p.NameProduct, MONTH(s.DateSells) 
ORDER BY p.NameProduct, MONTH(s.DateSells)

/*8. Вывести количество повторяющихся значений и сами значения из таблицы "Товары"*/ 
/*Не совсем понял, что требуется*/
SELECT NameProduct, COUNT(*) AS Repetitions 
FROM Products 
GROUP BY NameProduct 
HAVING COUNT(*) > 1;