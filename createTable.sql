drop database if exists restaurantDB;
create database restaurantDB;
use restaurantDB;

create table roles(
	id int primary key auto_increment,
	roleName varchar(30)
);

create table employees(
	id int primary key auto_increment,
    name varchar(30) not null,
    egn varchar(10) constraint EgnShouldBe10CharsLong check (char_length(egn) = 10),
    phone varchar(10),
    
    roleID int not null,
    foreign key(roleID) references roles(id)

);


create table items(
	id int primary key auto_increment,
    name varchar(30) not null,
    category ENUM("Безалкохолна напитка", "Алкохолна напитка", "Основно", "Предястие", "Десерт") not null,
    price decimal(5,2) not null,
    prep_time_min int null default null,
    weight_grams int null default null

);

create table products(
	id int primary key auto_increment,
    name varchar(30)
);

create table allergens(
	id int primary key auto_increment,
    name varchar(20) not null unique
);

create table item_allergens(
	itemID int,
    allergenID int,
    primary key(itemID, allergenID),
    
    foreign key(itemID) references items(id),
    foreign key(allergenID) references allergens(id)
);


create table item_products(
	itemID int not null,
    productID int not null,
    
    primary key(itemID,productID),
    foreign key (itemID) references items(id) on delete cascade,
    foreign key(productID) references products(id) on delete cascade

);

create table orders(
	id int primary key auto_increment,
    order_time timestamp default current_timestamp,
    total_amount decimal(10,2) not null,
    is_night_bonus_paid int default 0,
    
    employeeID int not null,
    foreign key (employeeID) references employees(id)

);

create table order_items(
	orderID int not null,
    itemID int not null,
    quantity int not null default 1,
    primary key(orderID, itemID),
    foreign key (orderID) references orders(id),
    foreign key (itemID) references items(id)
);

create table salaryPayments(
	id int primary key auto_increment,
    employeeID int not null,
    month tinyint not null check (month between 1 and 12),
    year Year not null,
    salaryAmount decimal(10,2) constraint salaryCantBeNegative check (salaryAmount >=0),
    date_of_payment datetime,
    
    foreign key (employeeID) references employees(id),
    unique key unique_month_pay (month, year, employeeID)
);

create table salaryPayments_log (
	id int primary key auto_increment,
    operation ENUM("INSERT","DELETE","UPDATE") not null,
    old_employee_id INT,
    new_employee_id INT,
    old_month TINYINT,
    new_month TINYINT,
    old_year YEAR,
    new_year YEAR,
    old_salary_amount DECIMAL(10, 2),
    new_salary_amount DECIMAL(10, 2),
    old_date_of_payment DATETIME,
    new_date_of_payment DATETIME,
    date_of_log DATETIME DEFAULT CURRENT_TIMESTAMP

);

INSERT INTO roles (roleName) VALUES
('Мениджър'), 
('Главен готвач'), 
('Барман'), 
('Сервитьор');

INSERT INTO employees (name, egn, phone, roleID) VALUES
('Иван Иванов', '8501011234', '0888123456', 1), 
('Мария Петрова', '9005124567', '0899123456', 2), 
('Георги Димитров', '9508237890', '0877123456', 3), 
('Елена Колева', '9811112233', '0888987654', 4); 


INSERT INTO products (name) VALUES
('Домати'), 
('Краставици'), 
('Сирене'), 
('Пилешко месо'), 
('Шоколад'), 
('Прясно мляко');


INSERT INTO allergens (name) VALUES
('Лактоза'), 
('Глутен'), 
('Ядки');


INSERT INTO items (name, category, price, prep_time_min, weight_grams) VALUES
('Кока-Кола', 'Безалкохолна напитка', 3.50, NULL, 330),
('Ракия Бургаска', 'Алкохолна напитка', 5.00, NULL, 50),
('Шопска салата', 'Предястие', 8.50, 10, 350),
('Пилешка пържола', 'Основно', 14.90, 20, 300),
('Шоколадова торта', 'Десерт', 7.50, 5, 150);


INSERT INTO item_products (itemID, productID) VALUES
(3, 1), 
(3, 2),
(3, 3), 
(4, 4), 
(5, 5), 
(5, 6); 


INSERT INTO item_allergens (itemID, allergenID) VALUES
(3, 1), 
(5, 1), 
(5, 2); 


INSERT INTO orders (total_amount, employeeID) VALUES
(31.90, 4), 
(12.50, 4); 

-- 9. Съдържание на самите поръчки
INSERT INTO order_items (orderID, itemID, quantity) VALUES
(1, 3, 1), 
(1, 4, 1), 
(1, 1, 2), 
(2, 5, 1), 
(2, 2, 1); 


INSERT INTO salaryPayments (employeeID, month, year, salaryAmount, date_of_payment) VALUES
(1, 3, 2024, 2500.00, '2024-04-05 10:00:00'),
(2, 3, 2024, 2000.00, '2024-04-05 10:05:00'),
(3, 3, 2024, 1500.00, '2024-04-05 10:10:00'),
(4, 3, 2024, 1200.00, '2024-04-05 10:15:00');


INSERT INTO orders (order_time, total_amount, is_night_bonus_paid, employeeID) 
VALUES ('2024-03-15 23:30:00', 45.00, 0, 4);





