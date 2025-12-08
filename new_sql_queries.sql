1,3,5,6,8,9,53,62,63,64,65,68,69,77,78,79,85,87,102,108,109,110,111,112,116,118,119,120,121,123,124,127,128


-- Question1 

CREATE TABLE SUPERHERO (
    ID INT PRIMARY KEY,
    NAME VARCHAR(100),
    LATITUDE FLOAT,
    LONGITUDE FLOAT
);

INSERT INTO SUPERHERO (ID, NAME, LATITUDE, LONGITUDE) VALUES
(1, 'Batman', 50.0, 85.0),
(2, 'Spiderman', 65.0, 65.0),
(3, 'Thor', 45.0, 30.0),
(4, 'Deadpool', 25.0, 69.0),
(5, 'Hulk', 30.0, 20.0),
(6, 'Captain America', 70.0, 75.0),
(7, 'Superman', 85.0, 45.0);


Select NAME 
from SUPERHERO
where length(NAME)<7

-- Question 3

CREATE TABLE PLANT (
    NAME VARCHAR(100) PRIMARY KEY,
    SPECIES VARCHAR(100),
    SEED_DATE DATE
);

CREATE TABLE WEATHER (
    PLANT_SPECIES VARCHAR(100),
    TYPE VARCHAR(50)
);

INSERT INTO PLANT (NAME, SPECIES, SEED_DATE) VALUES
('Maraschill1', 'Bryophyte', '2017-04-14'),
('Cycat', 'Gymnosperm', '2017-04-10'),
('Maraschill2', 'Bryophyte', '2016-05-07');

INSERT INTO WEATHER (PLANT_SPECIES, TYPE) VALUES
('Bryophyte', 'Sunny'),
('Gymnosperm', 'Rainy'),
('Gymnosperm', 'Sunny'),
('Gymnosperm', 'Dry');

SELECT  p.NAME, w.TYPE
FROM PLANT AS p
JOIN WEATHER AS w
  ON w.PLANT_SPECIES = p.SPECIES
WHERE p.SPECIES IN (
  SELECT PLANT_SPECIES
  FROM WEATHER
  GROUP BY PLANT_SPECIES
  HAVING COUNT(DISTINCT TYPE) = 1
);

SELECT p.NAME, MIN(w.TYPE) AS TYPE
FROM PLANT p
JOIN WEATHER w
ON w.PLANT_SPECIES = p.SPECIES
GROUP BY p.NAME
HAVING COUNT(DISTINCT w.TYPE) = 1;
 
-- Question 5

CREATE TABLE EMPLOYEE (
    ID      INT PRIMARY KEY,
    NAME    VARCHAR(20) NOT NULL,
    AGE     INT NOT NULL,
    ADDRESS VARCHAR(25),
    SALARY  INT
);

CREATE TABLE EMPLOYEE_UIN (
    ID   INT PRIMARY KEY,
    UIN  VARCHAR(20) NOT NULL,
    CONSTRAINT fk_employee_uin
        FOREIGN KEY (ID) REFERENCES EMPLOYEE(ID)
);

INSERT INTO EMPLOYEE (ID, NAME, AGE, ADDRESS, SALARY) VALUES
(1, 'Sherrie', 23, 'Paris', 74635),
(2, 'Paul',    30, 'Sydney', 72167),
(3, 'Mary',    24, 'Paris',  75299),
(4, 'Sam',     47, 'Sydney', 46681),
(5, 'Dave',    22, 'Texas',  11843);

INSERT INTO EMPLOYEE_UIN (ID, UIN) VALUES
(1, '57520-0440'),
(2, '49363-001'),
(3, '63559-194'),
(4, '68599-6112'),
(5, '63588-453');

Select eu.UIN, e.NAME
from EMPLOYEE e
JOin EMPLOYEE_UIN eu
on e.ID=eu.ID
where e.age<25
order by  e.NAME, e.ID;

-- Question 6


CREATE TABLE STUDENT1(
    ID INT PRIMARY KEY,
    NAME VARCHAR(50) NOT NULL,
    SCORE FLOAT NOT NULL
);

INSERT INTO STUDENT1 (ID, NAME, SCORE) VALUES
(1, 'Bob', 50),
(2, 'John', 65.5),
(3, 'Harry', 45),
(4, 'Dick', 85),
(5, 'Dev', 25),
(6, 'Sid', 98),
(7, 'Tom', 90),
(8, 'Julia', 70.5),
(9, 'Erica', 81),
(10, 'Jerry', 85);


SELECT ID, NAME
FROM STUDENT1
ORDER BY SCORE DESC
LIMIT 3


-- Question 8


CREATE TABLE ORDERS (
    ID INT PRIMARY KEY,
    ORDER_DATE DATE NOT NULL,
    STATUS VARCHAR(20) NOT NULL,   -- PLACED | SHIPPED | IN TRANSIT | DELIVERED
    CUSTOMER_ID INT NOT NULL
);

INSERT INTO ORDERS (ID, ORDER_DATE, STATUS, CUSTOMER_ID) VALUES
(1, '2003-01-06', 'PLACED',     363),
(2, '2003-01-06', 'PLACED',     128),
(3, '2003-01-06', 'IN TRANSIT', 181),
(4, '2003-01-06', 'DELIVERED',  121),
(5, '2003-01-07', 'DELIVERED',  114),
(6, '2003-01-07', 'IN TRANSIT', 278),
(7, '2003-01-07', 'PLACED',     114),
(8, '2003-05-05', 'IN TRANSIT', 350);


Select count(STATUS)
from ORDERS
where STATUS <>'DELIVERED'

-- Question 9

CREATE TABLE EMPLOYEE12 (
    ID INT PRIMARY KEY,
    NAME VARCHAR(50) NOT NULL,
    SALARY INT NOT NULL
);

INSERT INTO EMPLOYEE12(ID, NAME, SALARY) VALUES
(1, 'Candice', 4685),
(2, 'Juliana', 2253),
(3, 'Scarlet', 2350),
(4,'Illeana',1151);


SELECT NAME, SALARY
FROM EMPLOYEE12
WHERE SALARY > 500
ORDER BY RIGHT(NAME, 3) ASC, SALARY DESC, ID ASC;


-- Question 53

-- Create streamers table
CREATE TABLE streamers (
    id INT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL
);

-- Create completed_streams table
CREATE TABLE completed_streams (
    id INT PRIMARY KEY,
    streamer_id INT NOT NULL,
    viewers INT NOT NULL,
    FOREIGN KEY (streamer_id) REFERENCES streamers(id)
);

-- Insert data into streamers
INSERT INTO streamers (id, username) VALUES
(1, 'Gamer123'),
(2, 'StreamMaster'),
(3, 'ProGaming'),
(4, 'NinjaPlayer');

-- Insert data into completed_streams
INSERT INTO completed_streams (id, streamer_id, viewers) VALUES
(3, 4, 9428),
(17, 4, 8643),
(15, 4, 6978),
(19, 4, 5762),
(18, 4, 5493),
(5, 4, 4225),
(13, 4, 2242),
(7, 3, 3937),
(14, 3, 3575),
(2, 3, 930),
(6, 2, 9275),
(9, 2, 6611),
(20, 2, 6576),
(1, 2, 5958),
(12, 2, 4380),
(16, 2, 1931),
(8, 2, 1213),
(4, 2, 489),
(10, 1, 4497),
(11, 1, 3221);

Select s.username, 
       count(c.streamer_id) as total_streams, 
	   Round(avg(c.viewers)) as avg_viewers
from streamers s
join completed_streams c
on s.id=c.streamer_id
group by s.username
having count(c.streamer_id)>5 and avg(c.viewers)>5000


-- Question 62


-- Create accounts table
CREATE TABLE accounts (
    id INT PRIMARY KEY,
    email VARCHAR(255) NOT NULL
);

-- Create results table
CREATE TABLE results (
    account_id INT NOT NULL,
    words INT NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- Insert data into accounts
INSERT INTO accounts (id, email) VALUES
(1, 'bmacalpyne0@scribd.com'),
(2, 'adarkins1@hatena.ne.jp'),
(3, 'zphin2@theguardian.com');

-- Insert data into results
INSERT INTO results (account_id, words) VALUES
(1, 354),
(1, 120),
(1, 60),
(1, 91),
(1, 283),
(2, 353),
(2, 316),
(2, 193),
(2, 341),
(2, 111),
(2, 208),
(2, 347),
(2, 136),
(3, 280),
(3, 176),
(3, 355),
(3, 136),
(3, 385),
(3, 210);

Select a.email, 
       count(r.account_id) as outputs,
	   min(r.words) as min_words,
	   max(r.words) as max_words,
	   Round(avg(r.words),2) as avg_words
from ACCOUNTS a
join RESULTS r
on a.id=r.account_id
group by a.email
having  avg(r.words)>200
order by a.email



-- Question 63

-- Create accounts table
CREATE TABLE accounts12 (
    id INT PRIMARY KEY,
    mac VARCHAR(255) NOT NULL
);

-- Create encryptions table
CREATE TABLE encryptions12 (
    account_id INT NOT NULL,
    salt VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL,
    FOREIGN KEY (account_id) REFERENCES accounts12(id)
);

-- Insert data into accounts
INSERT INTO accounts12 (id, mac) VALUES
(1, '0C-6B-27-2E-E0-49'),
(2, '01-51-06-EC-7C-FB'),
(3, '7F-43-FD-22-2E-94');

-- Insert data into encryptions
INSERT INTO encryptions12 (account_id, salt, is_active) VALUES
(1, 'cc20ad47815', '0'),
(1, 'eb4a0bb0', '0'),
(1, '3be64cd2a1644b', '0'),
(1, '339c8ee8856c28', '0'),
(1, '27d2075', '0'),
(1, '960c872e5dc', '0'),
(1, '531ca74d', '1'),
(1, '4101965', '1'),
(1, 'f2707', '1'),
(1, '7a1c7adbe686e', '1'),
(1, '5d98604bbfb', '0'),
(2, 'f617f', '0'),
(2, '013c49b42bee9', '1'),
(2, '599f71b43c9', '0'),
(3, 'ea7b576a4b', '0'),
(3, '99a57e', '1'),
(3, 'be2d70bb50', '1'),
(3, 'd1b48f27ecdba', '1'),
(3, '0fd088f68', '1'),
(3, '1bc22ee', '1');

Select a.mac, count(e.salt)
from accounts12 a
JOin encryptions12 e
on a.id=e.account_id
where is_active='1' and length(e.salt)<8
group by a.id
order by a.mac

-- Question 64


-- Create tables
CREATE TABLE customers (
    id INT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    country VARCHAR(255) NOT NULL
);

CREATE TABLE countries (
    name VARCHAR(255) PRIMARY KEY,
    commission DECIMAL(3,2) NOT NULL
);

CREATE TABLE transactions (
    customer_id INT NOT NULL,
    amount DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Insert data: customers
INSERT INTO customers (id, email, country) VALUES
(1, 'lspellward0@ustream.tv', 'Germany'),
(2, 'egauvain1@zimbio.com',    'Belgium'),
(3, 'bnisus2@miibeian.gov.cn', 'France'),
(4, 'esnare3@netscape.com',    'Belgium'),
(5, 'etricker4@google.cn',     'Other');

-- Insert data: countries + commission rates
INSERT INTO countries (name, commission) VALUES
('Austria',        0.10),
('Belgium',        0.25),
('France',         0.15),
('Germany',        0.15),
('Other',          0.30),
('United Kingdom', 0.20),
('United States',  0.25);

-- Insert data: transactions
INSERT INTO transactions (customer_id, amount) VALUES
(4, 19.98),
(1, 28.51),
(1, 64.46),
(4, 82.06),
(4, 13.75),
(3, 16.99),
(4, 58.54),
(4, 46.50),
(2, 13.96),
(4, 13.31),
(1, 19.66),
(2, 64.51),
(5, 20.60),
(3, 56.76),
(4, 67.45),
(3, 72.56),
(4, 61.12),
(1, 41.41),
(1, 91.28),
(5, 3.93);

Select c.email as email,
       c.country as country,
       count(t.customer_id) as transactions,
	   sum(t.amount) as total_amount,
	   Round(sum(t.amount)*(co.commission),2) as total_commission
from customers c
join countries co
on c.country=co.name
join transactions t
on c.id=t.customer_id
group by c.email, c.country,co.commission
order by c.email;

-- Question 65

-- Create customers table
CREATE TABLE customers12 (
    id INT PRIMARY KEY,
    email VARCHAR(255) NOT NULL
);

-- Create packages table (PostgreSQL-friendly: use VARCHAR + CHECK)
CREATE TABLE packages12 (
    id INT PRIMARY KEY,
    status VARCHAR(20) NOT NULL,
    weight DECIMAL(5,2) NOT NULL,
    CONSTRAINT chk_packages12_status
        CHECK (status IN ('created','shipped','delivered','on hold','cancelled'))
);

-- Create customers_packages table
CREATE TABLE customers_packages12 (
    customer_id INT NOT NULL,
    package_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers12(id),
    FOREIGN KEY (package_id) REFERENCES packages12(id)
);

-- Insert data into customers
INSERT INTO customers12 (id, email) VALUES
(1, 'nhalifax0@auda.org.au'),
(2, 'nbrashier1@reference.com'),
(3, 'aflowerdew2@columbia.edu');

-- Insert data into packages
INSERT INTO packages12 (id, status, weight) VALUES
(1, 'delivered', 93.37),
(2, 'created', 86.16),
(3, 'delivered', 66.24),
(4, 'delivered', 78.63),
(5, 'on hold', 53.33),
(6, 'cancelled', 53.34),
(7, 'created', 13.25),
(8, 'delivered', 17.54),
(9, 'shipped', 42.80),
(10, 'on hold', 72.64),
(11, 'cancelled', 93.14),
(12, 'delivered', 64.94),
(13, 'delivered', 58.34),
(14, 'shipped', 6.92),
(15, 'cancelled', 58.50),
(16, 'delivered', 99.20),
(17, 'delivered', 11.26),
(18, 'created', 94.78),
(19, 'shipped', 12.28),
(20, 'created', 5.16);

-- Insert data into customers_packages
INSERT INTO customers_packages12 (customer_id, package_id) VALUES
(1, 4),
(1, 6),
(1, 13),
(2, 18),
(2, 7),
(2, 8),
(2, 9),
(2, 15),
(3, 11),
(3, 20),
(3, 19),
(3, 17),
(3, 16),
(3, 14),
(3, 12),
(3, 1),
(3, 10),
(3, 5),
(3, 3),
(3, 2);

Select c.email, 
       count(*) as total_packages, 
	   sum(p.weight) as total_weight
from customers12 c
join customers_packages12 cp
on cp.customer_id=c.id
join packages12 p
on p.id=cp.package_id
where p.status IN('created','shipped','on hold')
group by c.email
ORDER BY total_weight DESC;

-- Question 68


-- Create tables
CREATE TABLE gateways (
    id INT NOT NULL,            -- Internet gateway ID
    firewall_id VARCHAR(32) NOT NULL
    -- In the image, there can be multiple rows per gateway (one per assigned firewall)
    -- No PK here to allow multiple mappings as per sample data
);

CREATE TABLE firewalls (
    id VARCHAR(32) NOT NULL,    -- Firewall ID (not unique because sample shows duplicates)
    rules_count INT NOT NULL
);

-- Sample data (as shown in images)

-- Gateways mappings
INSERT INTO gateways (id, firewall_id) VALUES
(1, 'abc123'),
(2, 'def456'),
(3, 'abc456'),
(1, 'def123'),
(2, 'def789');

-- Firewalls rules_count
INSERT INTO firewalls (id, rules_count) VALUES
('abc123', 60),
('def456', 20),
('abc456', 120),
('abc123', 41),
('def789', 70);

select g.id as  gateway_id,
       sum(f.rules_count) as total_rules_count
from gateways g
join firewalls f
on g.firewall_id=f.id
group by g.id
having count(g.firewall_id)>1 and  sum(f.rules_count)>100

-- Question 69


-- Create activities table (PostgreSQL)
CREATE TABLE activities (
    id   INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    dt   TIMESTAMP NOT NULL
);

-- Create segments table (PostgreSQL)
CREATE TABLE segments (
    activity_id INT NOT NULL,
    steps       SMALLINT NOT NULL,
    calories    SMALLINT NOT NULL,
    FOREIGN KEY (activity_id) REFERENCES activities(id)
);

-- Insert data: activities
INSERT INTO activities (id, name, dt) VALUES
(1, 'Running', '2022-08-28 00:24:13'),
(2, 'Hiking',  '2022-09-14 06:15:50'),
(3, 'Walking', '2022-09-01 15:47:08');

-- Insert data: segments
-- Activity 1 (Running)
INSERT INTO segments (activity_id, steps, calories) VALUES
(1, 1308, 115),
(1, 1931,  98),
(1,  522, 112),
(1, 1460,  64),
(1, 1598,  58),
(1, 1031,  63),
(1, 1480,  22),
(1, 2243, 107);

-- Activity 2 (Hiking)
INSERT INTO segments (activity_id, steps, calories) VALUES
(2, 1230,  35),
(2,  733,  25),
(2, 2108,  92),
(2, 1831,  54),
(2, 1651,  79),
(2,  757,  66),
(2,  634,  94);

-- Activity 3 (Walking)
INSERT INTO segments (activity_id, steps, calories) VALUES
(3, 1184, 111),
(3, 1968,  74),
(3, 1048, 104),
(3, 1203, 119),
(3, 1441,  58);

Select a.name, a.dt, 
       count(s.activity_id) as segments,
	   round(avg(s.steps))average_segment_steps,
       sum(s.steps) as total_steps, 
	   sum(s.calories) as total_calories
from activities a
join segments s
on a.id=s.activity_id
where to_char(a.dt::DATE, 'Month') in ('September')
group by a.name,a.dt
order by dt

-- Question 77

-- Create contacts table (PostgreSQL)
CREATE TABLE contacts (
    id         INT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name  VARCHAR(255) NOT NULL,
    phone      VARCHAR(255) NOT NULL
);

-- Create calls table (PostgreSQL)
CREATE TABLE calls (
    contact_id INT NOT NULL,
    dt         TIMESTAMP NOT NULL,
    FOREIGN KEY (contact_id) REFERENCES contacts(id)
);

-- Insert data: contacts
INSERT INTO contacts (id, first_name, last_name, phone) VALUES
(1, 'Alex', 'Kalinsky', '+254 (590) 396-8341'),
(2, 'Sam',  'Cruz',     '+93 (476) 737-7603'),
(3, 'Chris','Opie',     '+33 (715) 652-9815');

-- Insert data: calls (as shown in images)
INSERT INTO calls (contact_id, dt) VALUES
(2, '2022-09-18 05:21:38'),
(2, '2022-08-30 06:23:06'),
(1, '2022-09-22 22:36:27'),
(3, '2022-09-03 06:56:16'),
(3, '2022-09-19 19:05:09'),
(2, '2022-09-13 09:15:30'),
(1, '2022-09-18 22:31:21'),
(3, '2022-09-07 04:37:31'),
(3, '2022-09-27 12:15:50'),
(1, '2022-09-30 09:40:00'),
(3, '2022-09-27 23:43:14'),
(1, '2022-08-28 07:49:54'),
(2, '2022-09-04 02:08:54'),
(1, '2022-08-31 04:41:40'),
(3, '2022-09-21 00:09:05'),
(3, '2022-09-21 11:07:25'),
(2, '2022-09-07 14:36:39'),
(1, '2022-09-16 12:39:51'),
(2, '2022-09-28 07:39:39'),
(1, '2022-08-29 16:37:37');
Select (c.last_name, ' ' ,c.first_name) as full_name,
        c.phone as phone_number,
		count(cl.contact_id) as calls
from contacts c
join calls cl
on c.id=cl.contact_id
where to_char(dt::date, 'Month') ='September'
group by c.last_name, c.first_name,c.phone
order by full_name

-- Question 78


CREATE TABLE CITIES (
    id   INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE CLIENTS (
    id      INT PRIMARY KEY,
    city_id INT NOT NULL,
    name    VARCHAR(100) NOT NULL,
    email   VARCHAR(200) NOT NULL,
    CONSTRAINT fk_clients_city
        FOREIGN KEY (city_id) REFERENCES CITIES(id)
);


CREATE TABLE SESSIONS (
    id        INT PRIMARY KEY,
    client_id INT NOT NULL,
    actions   INT NOT NULL,
    duration  INT NOT NULL,  -- duration in minutes (as per sample)
    CONSTRAINT fk_sessions_client
        FOREIGN KEY (client_id) REFERENCES CLIENTS(id)
);


INSERT INTO CITIES (id, name) VALUES
(1, 'Cooktown'),
(2, 'South Suzanne');

INSERT INTO CLIENTS (id, city_id, name, email) VALUES
(1, 2, 'Robert Delgado', 'robertdelgado@hotmail.com'),
(2, 2, 'Thomas Williams', 'thomaswilliams@bradley.org'),
(3, 1, 'Michele Peterson', 'michelepeterson@hotmail.com'),
(4, 1, 'Bill Wheeler', 'billwheeler@gmail.com'),
(5, 1, 'David Lloyd', 'davidlloyd@gmail.com'),
(6, 1, 'Morgan Powers', 'morganpowers@hansen.biz');

INSERT INTO SESSIONS (id, client_id, actions, duration) VALUES
(1,  1, 21, 200),
(2,  3,  6,  55),
(3,  2, 30, 230),
(4,  2, 16, 125),
(5,  2, 11, 110),
(6,  6, 30, 285),
(7,  3, 18, 170),
(8,  1,  6,  50),
(9,  2,  4,  40),
(10, 1, 10,  90),
(11, 6, 11,  95),
(12, 5, 16, 140),
(13, 3, 24, 220),
(14, 6, 17, 160),
(15, 2, 23, 205),
(16, 3, 11,  90),
(17, 6,  5,  50),
(18, 3, 19, 180),
(19, 5, 22, 205),
(20, 4,  6,  60);

Select c.name, 
       sum(s.duration) as total_Session
from CITIES c
join CLIENTS cl
on c.id=cl.city_id
join SESSIONS s
on cl.id=s.client_id
group by c.name
order by total_Session


-- Question 79


CREATE TABLE customers1 (
    id SMALLINT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE warehouses1 (
    customer_id SMALLINT NOT NULL,
    volume DECIMAL(5,2) NOT NULL,
    is_active SMALLINT NOT NULL,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customers1(id)
);

INSERT INTO customers1 (id, name) VALUES
(1, 'Grady Group'),
(2, 'Yundt, Ritchie, and Mann'),
(3, 'Feest Inc');

INSERT INTO warehouses1 (customer_id, volume, is_active) VALUES
(1, 68.41, 0),
(1, 95.96, 1),
(1, 63.77, 1),
(1, 89.41, 1),
(1, 17.22, 1),
(1, 89.77, 1),
(1, 60.25, 1),
(2, 46.30, 0),
(2, 76.22, 0),
(2, 89.33, 1),
(2, 50.07, 1),
(2, 67.48, 1),
(2, 62.28, 1),
(2, 40.23, 1),
(2, 16.60, 1),
(2, 29.29, 0),
(3, 30.51, 1),
(3, 34.35, 1),
(3, 43.64, 1),
(3, 45.71, 1);

Select c.name as cust_name,
       count(is_active) as active_warehouse,
	   min(w.volume) as smallest_active_Warehouse,
	   max(w.volume) as largertaw,
	   sum(w.volume) as totalaw
from customers1 c
join  warehouses1 w
on c.id=w.customer_id
where is_active=1
group by c.name

-- Question 85

CREATE TABLE profiles (
    id SMALLINT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE deals (
    profile_id SMALLINT NOT NULL,
    dt VARCHAR(19) NOT NULL,
    amount DECIMAL(5,2) NOT NULL,
    CONSTRAINT fk_profile FOREIGN KEY (profile_id) REFERENCES profiles(id)
);

INSERT INTO profiles (id, first_name, last_name, email) VALUES
(1, 'Wallis', 'Treadway', 'wtreadway0@senate.gov'),
(2, 'Franklin', 'Blackston', 'fblackston1@parallels.com'),
(3, 'Honoria', 'Constant', 'hconstant2@umich.edu'),
(4, 'Bertine', 'Hillaby', 'bhillaby3@artisteer.com'),
(5, 'Constance', 'Knutsen', 'cknutsen4@google.ca');

INSERT INTO deals (profile_id, dt, amount) VALUES
(5, '2022-05-21 02:44:24', 49.10),
(2, '2022-05-22 23:26:59', 46.21),
(1, '2022-05-23 09:56:25', 58.57),
(5, '2022-05-28 02:38:08', 27.81),
(4, '2022-06-04 07:16:27', 22.31),
(4, '2022-06-04 14:15:03', 36.33),
(5, '2022-06-04 15:03:10', 21.41),
(1, '2022-06-07 02:58:06', 92.84),
(4, '2022-06-08 05:09:52', 24.41),
(3, '2022-06-13 03:28:52', 61.55),
(4, '2022-06-16 15:09:39', 77.70),
(5, '2022-06-18 16:51:32', 58.79),
(4, '2022-06-20 02:55:20', 43.61),
(3, '2022-06-22 06:52:10', 10.41),
(1, '2022-06-23 04:59:05', 6.59),
(1, '2022-06-30 16:11:02', 43.07),
(5, '2022-07-05 06:05:28', 36.45),
(5, '2022-07-12 07:49:51', 14.76),
(4, '2022-07-12 18:58:11', 91.61),
(5,'2022-07-14 00:50:45', 69.61);

select p.first_name as firstname, 
       p.last_name as lastname, 
	   p.email, 
	   sum(d.amount) as total_dealamt
from profiles p
join deals d
on p.id=d.profile_id
where dt like '2022-06%'
group by p.first_name, p.last_name,p.email
order by total_dealamt desc
Limit 3;


-- Question 87


CREATE TABLE configurations (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE deployments (
    configuration_id VARCHAR(64) NOT NULL,
    dt VARCHAR(19) NOT NULL,
    CONSTRAINT fk_configuration FOREIGN KEY (configuration_id) REFERENCES configurations(id)
);

INSERT INTO configurations (id, name) VALUES
('1vcpu_512mb_10gb_500gb', '1 CPU / 512 MB RAM / 10 GB SSD Disk / 500 GB transfer'),
('1vcpu_1gb_25gb_1tb', '1 CPU / 1 GB RAM / 25 GB SSD Disk / 1000 GB transfer'),
('1vcpu_2gb_50gb_2tb', '1 CPU / 2 GB RAM / 50 GB SSD Disk / 2 TB transfer'),
('2vcpu_2gb_60gb_3tb', '2 CPUs / 2 GB RAM / 60 GB SSD Disk / 3 TB transfer'),
('2vcpu_4gb_80gb_4tb', '2 CPUs / 4 GB RAM / 80 GB SSD Disk / 4 TB transfer'),
('4vcpu_8gb_160gb_5tb', '4 CPUs / 8 GB RAM / 160 GB SSD Disk / 5 TB transfer'),
('8vcpu_16gb_320gb_6tb', '8 CPUs / 16 GB RAM / 320 GB SSD Disk / 6 TB transfer');

INSERT INTO deployments (configuration_id, dt) VALUES
('1vcpu_512mb_10gb_500gb', '2020-10-22 05:59:47'),
('1vcpu_1gb_25gb_1tb', '2020-11-09 06:07:57'),
('1vcpu_2gb_50gb_2tb', '2020-12-02 14:47:24'),
('2vcpu_2gb_60gb_3tb', '2021-01-24 15:41:42'),
('4vcpu_8gb_160gb_5tb', '2021-01-25 09:31:37'),
('2vcpu_2gb_60gb_3tb', '2021-02-08 02:43:14'),
('1vcpu_512mb_10gb_500gb', '2021-03-25 06:13:36'),
('8vcpu_16gb_320gb_6tb', '2021-03-26 22:23:42'),
('2vcpu_2gb_60gb_3tb', '2021-05-24 09:48:16'),
('1vcpu_512mb_10gb_500gb', '2021-05-31 05:03:28'),
('1vcpu_2gb_50gb_2tb', '2021-08-25 22:24:10'),
('2vcpu_4gb_80gb_4tb', '2021-09-05 22:12:17'),
('2vcpu_4gb_80gb_4tb', '2021-09-23 08:31:50'),
('2vcpu_4gb_80gb_4tb', '2021-09-28 05:15:24'),
('2vcpu_4gb_80gb_4tb', '2021-10-14 08:26:20'),
('1vcpu_2gb_50gb_2tb', '2021-11-01 19:00:30'),
('1vcpu_512mb_10gb_500gb', '2021-11-26 10:53:05'),
('1vcpu_1gb_25gb_1tb', '2021-12-27 07:07:23'),
('2vcpu_2gb_60gb_3tb', '2022-02-13 06:00:29'),
('2vcpu_2gb_60gb_3tb', '2022-03-03 09:10:30');


select c.name as config_name,
       count(*) as no_of_deploy
from configurations c
join deployments d
on c.id=d.configuration_id
where dt like '2021%'
group by c.name
order by no_of_deploy desc;


-- Question 102


CREATE TABLE event (
    id INT PRIMARY KEY,
    name VARCHAR(15) NOT NULL,
    country VARCHAR(15) NOT NULL,
    age INT NOT NULL
);

INSERT INTO event (id, name, country, age) VALUES
(26, 'Taylor', 'France', 15),
(27, 'Wesley', 'France', 16),
(28, 'Jordan', 'England', 18),
(29, 'Robin', 'Germany', 22),
(30, 'Alex', 'Germany', 16),
(31, 'Drew', 'France', 20),
(32, 'Blake', 'Germany', 16),
(33, 'Spencer', 'Belgium', 22),
(34, 'Ellis', 'France', 17),
(35, 'Morgan', 'Germany', 16);
Select country, count(*) as total_participation
from  event
where country in('England','France','Germany') 
group by country, age
having age>=15 and age<=20

-- Question 108

CREATE TABLE cities1 (
    id VARCHAR(32) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE users1 (
    id VARCHAR(32) PRIMARY KEY,
    city_id VARCHAR(32) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(200) NOT NULL,
    CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES cities1(id)
);

CREATE TABLE rides1 (
    id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) NOT NULL,
    distance INT NOT NULL,
    fare INT NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users1(id)
);

INSERT INTO cities1 (id, name) VALUES
('1', 'Cooktown'),
('2', 'South Suzanne');

INSERT INTO users1 (id, city_id, name, email) VALUES
('1', '2', 'Robin Delgado', 'robindelgado@hotmail.com'),
('2', '2', 'Sam Williams', 'samwilliams@bradley.org'),
('3', '1', 'Pat Peterson', 'patpeterson@hotmail.com'),
('4', '1', 'Chris Wheeler', 'chriswheeler@gmail.com'),
('5', '1', 'Jordan Lloyd', 'jordanlloyd@gmail.com'),
('6', '1', 'Morgan Powers', 'morganpowers@hansen.biz');

INSERT INTO rides1 (id, user_id, distance, fare) VALUES
('1', '1', 21, 200),
('2', '3', 6, 55),
('3', '2', 30, 230),
('4', '2', 16, 125),
('5', '2', 11, 110),
('6', '6', 30, 285),
('7', '3', 18, 170),
('8', '1', 6, 50),
('9', '2', 4, 40),
('10', '1', 10, 90),
('11', '6', 11, 95),
('12', '5', 16, 140),
('13', '3', 24, 220),
('14', '6', 17, 160),
('15', '2', 23, 205),
('16', '3', 11, 90),
('17', '6', 5, 50),
('18', '3', 19, 180),
('19', '5', 22, 205),
('20', '4', 6, 60);

Select c.NAME, sum(r.fare) 
from CITIES1 c
join USERS1 u
on c.id=u.city_id
join RIDES1 r
on u.id=r.user_id
group by c.NAME
ORDER by sum(r.fare),  c.NAME

-- Question 109


CREATE TABLE exam (
    name  TEXT PRIMARY KEY,  -- space-separated first and last name
    marks INTEGER NOT NULL
);

INSERT INTO exam (name, marks) VALUES
    ('Robin A', 10),
    ('Sam B',   6),
    ('Alex C',  15);
	
select 
	UPPER(name),
	marks 
from exam
	WHERE marks%2=0
	order by name;
	
			OR
SELECT
    UPPER(name) AS name,
    marks
FROM exam
WHERE (marks % 2) = 0
ORDER BY
    SPLIT_PART(name, ' ', 1),  -- first name
    SPLIT_PART(name, ' ', 2);  -- last name
 
-- Question 110

CREATE TABLE cust (
    name text NOT NULL,
    id text PRIMARY KEY
);

CREATE TABLE invoices (
    customer_id TEXT NOT NULL,
    value INTEGER NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES cust(id)
);

INSERT INTO cust(name, id) VALUES
    ('Chris', '9aa8af36f78334f0e8f0ebcb22ca46107'),
    ('Robin', '14643f56e564f0aa9d36333b3f20c70'),
    ('Sam',   '17f6bc047f064899e18635d737ea840');

INSERT INTO invoices (customer_id, value) VALUES
    ('17f6bc047f064899e18635d737ea840', 1000),
    ('9aa8af36f78334f0e8f0ebcb22ca46107', 500),
    ('14643f56e564f0aa9d36333b3f20c70', 1000);
 
select c.name
	from cust c
	JOIN invoices i ON c.id=i.customer_id
	WHERE i.value=(select MAX(value) from invoices)
	ORDER BY c.name;

-- Question 111

CREATE TABLE marks (
    id  TEXT PRIMARY KEY,
    marks INTEGER NOT NULL
);

INSERT INTO marks (id, marks) VALUES
    ('abc123', 30),
    ('def456', 70),
    ('def123', 50);
 
select 
	MAX(marks) AS MAX_MARKS,
	MIN(marks) AS MIN_MARKS
	from marks;
 
-- Question 112

CREATE TABLE house (
    buyer_id  INTEGER NOT NULL,
    house_id  TEXT PRIMARY KEY
);

CREATE TABLE price (
    house_id TEXT PRIMARY KEY,
    price    INTEGER NOT NULL
);

INSERT INTO house (buyer_id, house_id) VALUES
    (1, 'abc123'),
    (2, 'def456'),
    (3, 'abc456'),
    (1, 'def123'),
    (2, 'def789');

INSERT INTO price (house_id, price) VALUES
    ('abc123', 60),
    ('def456', 20),
    ('abc456', 120),
    ('def123', 40),
    ('def789', 70);

select h.buyer_id,
	SUM(p.price) AS total_worth
	from house h
	JOIN price p ON h.house_id=p.house_id
	GROUP BY h.buyer_id
	HAVING COUNT(*)>1 AND SUM(p.price)>=100;
 
--question 116

CREATE TABLE students (
    id    INTEGER PRIMARY KEY,
    name  VARCHAR(50) NOT NULL,
    marks INTEGER NOT NULL
);

INSERT INTO students (id, name, marks) VALUES
    (1, 'Matt', 44),
    (2, 'John', 57),
    (3, 'Lucas', 78);
 
select id,
	name,
	marks,
	CASE WHEN marks>90 THEN 'A+'
	WHEN marks>70 THEN 'A'
	WHEN marks>50 THEN 'B'
	WHEN marks>40 THEN 'C'
	ELSE 'Fail' END AS grade
	from students;
 
--Question 118

CREATE TABLE customer (
    id      INTEGER PRIMARY KEY,
    name    VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    credits INTEGER
);

INSERT INTO customer (id, name, country, credits) VALUES
    (1, 'Frances White', 'USA', 200350),
    (2, 'Carolyn Bradley', 'UK', 15354),
    (3, 'Annie Fernandez', 'France', 359200),
    (4, 'Ruth Hanson', 'Albania', 1060),
    (5, 'Paula Fuller', 'USA', 14789),
    (6, 'Bonnie Johnston', 'China', 10243),
    (7, 'Ruth Gutierrez', 'USA', 998999),
    (8, 'Ernest Thomas', 'Canada', 503080),
    (9, 'Joe Garza', 'UK', 18782),
    (10, 'Anne Harris', 'USA', 158367);
 
select id,name
	from customer
	order by name DESC,id;
 
--Question 119

CREATE TABLE order1 (
    id INT PRIMARY KEY,
    order_date  DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    customer_id INT NOT NULL
);

INSERT INTO order1 (id, order_date, status, customer_id) VALUES
    (10100, '2003-01-06', 'PLACED', 363),
    (10101, '2003-01-06', 'PLACED', 128),
    (10102, '2003-01-06', 'IN TRANSIT', 181),
    (10103, '2003-01-06', 'DELIVERED', 121),
    (10104, '2003-01-07', 'DELIVERED', 114),
    (10106, '2003-01-07', 'IN TRANSIT', 278),
    (10107, '2003-01-07', 'PLACED', 114),
    (10122, '2003-05-05', 'IN TRANSIT', 350),
    (10123, '2003-05-05', 'DELIVERED', 103);
 
select * from order1
	WHERE status<>'DELIVERED'
	order by order_date,id
	LIMIT 5;


-- Question 120

CREATE TABLE CUSTOMER12 (
    ID INT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    COUNTRY VARCHAR(50) NOT NULL,
    CREDITS INT NOT NULL
);

INSERT INTO CUSTOMER12 (ID, NAME, COUNTRY, CREDITS) VALUES
(1, 'Frances White', 'USA', 200350),
(2, 'Carolyn Bradley', 'UK', 15354),
(3, 'Annie Fernandez', 'France', 359200),
(4, 'Ruth Hanson', 'Albania', 1060),
(5, 'Paula Fuller', 'USA', 14789),
(6, 'Bonnie Johnston', 'China', 100243),
(7, 'Ruth Gutierrez', 'USA', 998999),
(8, 'Ernest Thomas', 'Canada', 500500),
(9, 'Joe Garza', 'UK', 18782),
(10,'Anne Harris', 'USA', 158367);

select ID , NAME 
FROM CUSTOMER12 
WHERE COUNTRY='USA' and CREDITS>100000


-- Question 121

CREATE TABLE DEPARTMENT (
    ID INT PRIMARY KEY,
    NAME VARCHAR(50) NOT NULL,
    LOCATION VARCHAR(50) NOT NULL
);

CREATE TABLE EMPLOYEEs12 (
    ID INT PRIMARY KEY,
    NAME VARCHAR(50) NOT NULL,
    SALARY INT NOT NULL,
    DEPT_ID INT NOT NULL,
    CONSTRAINT fk_department FOREIGN KEY (DEPT_ID) REFERENCES DEPARTMENT(ID)
);

INSERT INTO DEPARTMENT (ID, NAME, LOCATION) VALUES
(1, 'Executive', 'Sydney'),
(2, 'Production', 'Sydney'),
(3, 'Resources', 'Cape Town'),
(4, 'Technical', 'Texas'),
(5, 'Management', 'Paris');

INSERT INTO EMPLOYEEs12 (ID, NAME, SALARY, DEPT_ID) VALUES
(1, 'Candice', 4685, 1),
(2, 'Julia', 2559, 2),
(3, 'Bob', 4405, 3),
(4, 'Scarlet', 2358, 1);

Select e.name, e.salary, d.name as dept_name,
      d.LOCATION as dept_loc
from EMPLOYEEs12 e
join DEPARTMENT d
on e.DEPT_ID=d.ID
ORDER BY e.name;

-- Question 123

CREATE TABLE HACKER (
    ID INT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    MONTHS INT NOT NULL,
    HACKOS INT NOT NULL
);

INSERT INTO HACKER (ID, NAME, MONTHS, HACKOS) VALUES
(1, 'Frances White', 5, 20),
(2, 'Carolyn Bradley', 2, 10),
(3, 'Annie Fernandez', 10, 5),
(4, 'Ruth Hanson', 5, 15),
(5, 'Paula Fuller', 6, 15),
(6, 'Bonnie Johnston', 8, 12),
(7, 'Ruth Gutierrez', 7, 10),
(8, 'Ernest Thomas', 4, 30),
(9, 'Joe Garza', 5, 25),
(10, 'Anne Harris', 7, 15);

select NAME 
from HACKER
WHERE (HACKOS*MONTHS)>100 AND MONTHS<10

-- Question 124


CREATE TABLE HACKER1 (
    ID INT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    MONTHS INT NOT NULL,
    HACKOS INT NOT NULL
);

INSERT INTO HACKER1 (ID, NAME, MONTHS, HACKOS) VALUES
(1, 'Frances White', 5, 20),
(2, 'Carolyn Bradley', 2, 10),
(3, 'Annie Fernandez', 10, 5),
(4, 'Ruth Hanson', 5, 15),
(5, 'Paula Fuller', 6, 15),
(6, 'Bonnie Johnston', 8, 12),
(7, 'Ruth Gutierrez', 7, 10),
(8, 'Ernest Thomas', 6, 24),
(9, 'Joe Garza', 8, 18),
(10, 'Anne Harris', 7, 15);



SELECT 
    MAX(MONTHS * HACKOS) AS maximum_hackos,
    COUNT(*) AS number_of_hackers
FROM HACKER1
WHERE (MONTHS * HACKOS) = (
    SELECT MAX(MONTHS * HACKOS) FROM HACKER1
);


-- Question 127

CREATE TABLE DEPARTMENT12 (
    ID INT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL
);

CREATE TABLE PROFESSOR12 (
    ID INT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    DEPARTMENT_ID INT NOT NULL,
    SALARY FLOAT NOT NULL,
    CONSTRAINT fk_department FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENT12(ID)
);

INSERT INTO DEPARTMENT12 (ID, NAME) VALUES
(3, 'Biological Sciences'),
(5, 'Technology'),
(6, 'Humanities & Social Sciences'),
(2, 'Clinical Medicine'),
(4, 'Arts and Humanities'),
(1, 'Physical Sciences');

INSERT INTO PROFESSOR12 (ID, NAME, DEPARTMENT_ID, SALARY) VALUES
(1, 'Shawn Rivera', 1, 22606),
(8, 'Ruth Price', 3, 9287),
(9, 'Julie Gonzalez', 4, 18870),
(2, 'Craig Elliot', 5, 27524),
(10, 'Scott Butler', 1, 26200),
(3, 'Nancy Russell', 2, 20067),
(4, 'Clarence Johnson', 1, 7249),
(7, 'Louis Schmidt', 1, 13437),
(5, 'Terry Thompson', 5, 28432);

SELECT d.name AS department_name,
ROUND(AVG(p.salary)::numeric, 4) AS avg_salary
FROM departments12 d
JOIN professor12 p ON p.department_id = d.id
GROUP BY d.name
ORDER BY AVG(p.salary) DESC
limit 2;
 
-- Question 128

CREATE TABLE department123 (
id  INTEGER PRIMARY KEY,
name  VARCHAR(100) NOT NULL
);

CREATE TABLE professor123 (
    id   INTEGER PRIMARY KEY,
    name   VARCHAR(100) NOT NULL,
    department_id  INTEGER NOT NULL REFERENCES department123(id),
    salary   INTEGER NOT NULL
);

CREATE TABLE course123 (
    id   INTEGER PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    department_id  INTEGER NOT NULL REFERENCES department123(id),
    credits  INTEGER NOT NULL

);

CREATE TABLE schedule123 (
    professor_id  INTEGER NOT NULL REFERENCES professor123(id),
    course_id  INTEGER NOT NULL REFERENCES course123(id),
    semester  INTEGER NOT NULL,
    year   INTEGER NOT NULL,
    PRIMARY KEY (professor_id, course_id, semester, year)
);

INSERT INTO department123 (id, name) VALUES
    (3, 'Biological Sciences'),
    (5, 'Technology'),
    (6, 'Humanities & Social Sciences'),
    (2, 'Clinical Medicine'),
    (4, 'Arts and Humanities'),
    (1, 'Physical Sciences');

INSERT INTO professor123 (id, name, department_id, salary) VALUES
    (1, 'Alex Burton',5, 7340),
    (8, 'Jordan Diaz',1,17221),
    (9, 'Derek Hicks',5, 16613),
    (2, 'Tyler Matthews',2,14521),
    (10, 'Blake Foster',4,28526),
    (3, 'Spencer Peters',1,10487),
    (4, 'Ellis Marshall', 3,6353),
    (7, 'Morgan Lee',2,  25796),
    (5, 'Riley Peterson',1,35678),
	(6, 'Peyton Fields',5, 26648);

INSERT INTO course123 (id, name, department_id, credits) VALUES
    (9,  'Clinical Biochemistry', 2, 3),
    (4,  'Astronomy', 1, 6),
    (10, 'Clinical Neuroscience',2, 5),
    (1,  'Pure Mathematics and Mathematical Statistics',1, 3),
    (6,  'Geography', 1, 7),
    (8,  'Chemistry',1, 1),
    (5,  'Physics', 1, 8),
    (3,  'Earth Science',1, 7),
    (7,  'Materials Science and Metallurgy', 1, 5),
    (2,  'Applied Mathematics and Theoretical Physics', 1, 5);

INSERT INTO schedule123 (professor_id, course_id, semester, year) VALUES
    (5, 3,  6, 2012),
    (7, 3,  1, 2013),
    (5, 7,  6, 2010),
    (2, 10, 2, 2004),
    (5, 1,  1, 2011),
    (2, 9,  4, 2005),
    (7, 10, 6, 2009),
    (5, 6,  4, 2007),
    (7, 9,  1, 2014),
    (9, 9,  5, 2011);
 
SELECT DISTINCT
    p.name AS professor_name,
    c.name AS course_name
FROM professor123 p
JOIN schedule123 s ON p.id = s.professor_id
JOIN course123 c ON c.id = s.course_id
ORDER BY course_name;
 









