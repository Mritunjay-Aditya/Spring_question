-- question 1
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    user_id INT,
    payment_method VARCHAR(255),
    amount DECIMAL(10,2),
    transaction_date DATE,
    status VARCHAR(255)
);
INSERT INTO transactions (transaction_id, user_id, payment_method, amount, transaction_date, status) VALUES
(101, 202, 'Credit Card', 200.43, '2023-09-16', 'Completed'),
(102, 203, 'Netbanking', 3231.10, '2023-03-11', 'Failed'),
(103, 203, 'Netbanking', 1195.35, '2023-04-24', 'Failed'),
(104, 203, 'Debit Card', 376.11, '2023-03-10', 'Failed'),
(105, 203, 'Netbanking', 112.01, '2023-04-04', 'Failed'),
(106, 203, 'Credit Card', 111.10, '2023-09-12', 'Failed'),
(107, 203, 'Debit Card', 2344.50, '2023-10-03', 'Failed');
select user_id,
	COUNT(*) AS failed_transactions,
	COUNT(DISTINCT(payment_method)) AS distinct_payment_method
	from transactions
	where status='Failed'
	GROUP BY user_id
	HAVING COUNT(*)>5;

-- question 2
create table support_tickets(
	id SERIAL PRIMARY KEY,
	customer_id INT,
	created_at varchar(19),
	resolved_at varchar(19)
);
insert into support_tickets(customer_id,created_at,resolved_at) VALUES ( 1, '2023-12-21 05:42:00', '2024-01-01 05:42:00'),
(2, '2023-07-08 14:22:00', NULL),(3, '2023-05-22 08:54:00', '2023-06-17 00:00:00');

SELECT
    ROUND(AVG(EXTRACT(EPOCH FROM (resolved_at::timestamp - created_at::timestamp)) / 3600), 2) AS average_response_time
FROM support_tickets
WHERE resolved_at IS NOT NULL;

select ROUND(
		AVG(
		extract(
		epoch from(
		resolved_at::timestamp-created_at::timestamp
		))/3600),2) AS average_response_time
		from support_tickets;

-- question 3
create table customers(
	id serial primary key,
	name varchar(255),
	city varchar(255)
);
insert into customers(name,city) VALUES 
('Customer 1','Los Angeles'),('Customer 2','Chicago'),
('Customer 3','Chicago');

create table orders(
	id serial primary key,
	customer_id int REFERENCES customers(id),
	amount decimal(10,2)
);
INSERT INTO orders (customer_id, amount) VALUES 
(1, 150.75),(2, 230.50),(3, 345.25);

select c.id,
	c.name,
	c.city,
	o.amount AS total_spending
	from customers c
	JOIN orders o ON c.id=o.customer_id
	WHERE o.amount=(
	select MAX(o1.amount) from customers c1
	JOIN orders o1 ON c1.id=o1.customer_id
	WHERE c1.city=c.city
	GROUP BY c1.city)
	ORDER BY total_spending;

--question 4
CREATE TABLE products (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(255),
    category VARCHAR(255),
    is_available SMALLINT
);
INSERT INTO products (id, name, category, is_available) VALUES 
(1, 'PromoPro', 'beauty products', 1),
(2, 'AdVantage', 'outdoor gear', 1),
(3, 'MarketMagnet', 'sports equipment', 1),
(5,'AdBlitz','beauty products',0);
CREATE TABLE requests(
	product_id INT,
	client_email VARCHAR(255),
	FOREIGN KEY (product_id) REFERENCES products(id)
);
INSERT INTO requests (product_id, client_email) VALUES 
(1, 'salgate@f2.com'),(1, 'lwycliff@list-manage.com'),(1,'lwyclif@'),(2,'abc@'),
(2,'vsamwayst@bbb.org'),(3,'ringrey@'),(3,'apapping@'),(3,'mrysonm@istockphoto'),
(5,'ayyushin1@opera.com'),(5,'bcoulston@hubpages.com');

select p.name,
	COUNT(*) AS total_requests
	from products p
	JOIN requests r ON p.id=r.product_id
	WHERE is_available='1'
	GROUP BY p.name
	ORDER BY total_requests DESC,p.name;

-- question 5
CREATE TABLE campaigns (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(255),
    is_active SMALLINT
);
CREATE TABLE engagements (
    campaign_id INT,
    views INT,
    clicks INT,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
);
INSERT INTO campaigns (id, name, is_active) VALUES
(1, 'SummerSavings', 1),
(2, 'FallFrenzy', 1),
(3, 'WinterWonderland', 0);
INSERT INTO engagements (campaign_id, views, clicks) VALUES
(1, 100, 10),
(1, 150, 20),
(2, 200, 30),
(2, 250, 40),
(3, 300 ,50),
(1, 120, 15),
(2 ,180, 25),
(3, 220, 35),
(1, 130, 18),
(2, 210, 28);

select c.name,
	COUNT(*) AS total_engagements,
	(SUM(e.views)+SUM(e.clicks)) AS total_views_and_clicks
	from campaigns c
	JOIN engagements e ON c.id=e.campaign_id
	WHERE is_active=1
	GROUP BY c.name
	ORDER BY c.name;
	
-- question 6
CREATE TABLE accounts (
    id INT NOT NULL PRIMARY KEY,
    email VARCHAR(255)
);
CREATE TABLE reports (
    account_id INT,
    dt VARCHAR(19),
    amount DECIMAL(6, 2),
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);
INSERT INTO accounts (id, email) VALUES
(1, 'hratke0@disqus.com'),
(2, 'lcaiger1@si.edu'),
(3, 'gburkett2@vinaora.com');
INSERT INTO reports (account_id, dt, amount) VALUES
(1, '2023-05-27 01:46:19', 830.45),
(2, '2023-01-15 09:23:21', 2518.18),
(3, '2023-05-08 01:44:41', 4637.39),
(1, '2023-06-30 15:02:03', 3953.69),
(2, '2023-12-05 04:39:31', 3357.99),
(3, '2023-02-03 09:41:00', 1907.38),
(1, '2022-12-30 04:05:57', 1217.29),
(2, '2024-01-24 14:18:07', 2441.66),
(3, '2024-01-05 23:19:31', 3055.20),
(1, '2023-05-26 01:54:24', 2077.36);
select a.email,
	SUM(r.amount) AS total_report_amount
	from accounts a
	JOIN reports r ON a.id=r.account_id
	WHERE r.dt LIKE '2023-%'
	GROUP BY a.email
	ORDER BY a.email;
	
-- question 7
CREATE TABLE devices (
    id INT NOT NULL PRIMARY KEY,
    mac_address VARCHAR(255)
);
CREATE TABLE scanned_files (
    device_id INT,
    filename VARCHAR(255),
    is_infected SMALLINT,
    FOREIGN KEY (device_id) REFERENCES devices(id)
);
INSERT INTO devices (id, mac_address) VALUES
(1, '66-0F-84-41-B8-8E'),
(2, 'A6-1A-2F-3A-7B-83'),
(3, '76-CD-24-48-F0-DD');
INSERT INTO scanned_files (device_id, filename, is_infected) VALUES
(1, 'File1.mp3', 0),
(1, 'File2.xls', 1),
(2, 'File3.doc', 0),
(2, 'File4.ppt', 1),
(2, 'File5.mp3', 1),
(3, 'File6.xls', 0),
(3, 'File7.doc', 1),
(3, 'File8.ppt', 0),
(3, 'File9.mp3', 1),
(3, 'File10.xls', 0);

select d.mac_address,
	COUNT(*) AS total_files_scanned,
	SUM(CASE WHEN s.is_infected=1 THEN 1
			ELSE 0 END) AS total_infected_files
	from devices d
	JOIN scanned_files s ON d.id=s.device_id
	GROUP BY d.mac_address
	ORDER BY total_files_scanned;

-- question 8
CREATE TABLE coins (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE transactions (
    coin_id INT,
    dt VARCHAR(19),
    amount DECIMAL(5,2),
    FOREIGN KEY (coin_id) REFERENCES coins(id)
);
INSERT INTO coins (id, name) VALUES
(1, 'BitCash'),
(2, 'Etherium'),
(3, 'Litecoin');
INSERT INTO transactions (coin_id, dt, amount) VALUES
(1, '2023-07-03 12:16:53', 34.00),
(1, '2023-12-08 12:14:58', 47.00),
(2, '2022-12-16 20:42:10', 45.54),
(2, '2023-11-05 09:27:11', 53.3),
(3, '2023-12-05 06:45:23', 71.51),
(3, '2023-01-19 01:43:25', 97.18),
(3, '2024-01-24 13:34:00', 86.68),
(1, '2023-05-07 05:30:06', 25.6),
(2, '2023-03-08 08:07:20', 40.11),
(3, '2023-08-13 10:44:54', 87.54);
select c.name,
	SUM(t.amount) AS total_transaction_amount,
	COUNT(*) AS total_transactions
	FROM coins c
	JOIN transactions t ON c.id=t.coin_id
	WHERE t.dt LIKE '2023-%'
	GROUP BY c.name
	ORDER BY c.name;

--question 9
CREATE TABLE customers1 (
    id INT NOT NULL PRIMARY KEY,
    email VARCHAR(255)
);
CREATE TABLE domains (
    customer_id INT,
    name VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES customers1(id)
);
INSERT INTO customers1 (id, email) VALUES
(1, 'ebayldon0@washingtonpost.com'),
(2, 'agammade1@comcast.net'),
(3, 'goloshkin2@reference.com'),
(4, 'cantonescu3@earthlink.net'),
(5, 'fparzis4@ow.ly'),
(6, 'cpetroulis5@shutter'),
(7, 'tbeels6@bbb.org'),
(8,'zmacturlough7@4shared.com'),
(9,'eshury8@skype.com'),
(10, 'jfehners9@github.io');
INSERT INTO domains (customer_id, name) VALUES
(1, 'bfilipa.net'),
(1, 'gsparsholti.net'),
(1, 'jhughsr.org'),
(2, 'scopas8.net'),
(2, 'cglison1u.org'),
(3, 'tginiz.com'),
(3, 'arubinowitsch2l.net'),
(3, 'clockyear2m.org'),
(4, 'sfinniqand.com'),
(4, 'vborrelt.net');
select c.email,
	COUNT(*) AS total_domains
	from customers1 c
	JOIN domains d ON c.id=d.customer_id
	GROUP BY c.email
	ORDER BY c.email;

-- question 10
CREATE TABLE products1 (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(6, 2),
    in_stock SMALLINT
);
CREATE TABLE wishlists (
    product_id INT,
    customer_email VARCHAR(255),
    FOREIGN KEY (product_id) REFERENCES products1(id)
);
INSERT INTO products1 (id, name, price, in_stock) VALUES
(1, 'TechGadget Pro X', 324.24, 1),
(2, 'LuxuryHome Decor Set', 884.90, 1),
(3, 'FitnessTracker Elite', 698.59, 0);
INSERT INTO wishlists (product_id, customer_email) VALUES
(1, 'user1@example.com'),
(1, 'user2@example.com'),
(2, 'user3@example.com'),
(2, 'user4@example.com'),
(2, 'user5@example.com'),
(3, 'user6@example.com'),
(1, 'user7@example.com'),
(2, 'user8@example.com'),
(1, 'user9@example.com'),
(3, 'user10@example.com');
select p.name,
	p.price,
	COUNT(*) AS total_wishlist_count
	from products1 p
	JOIN wishlists w ON p.id=w.product_id
	WHERE in_stock=1
	GROUP BY p.name,p.price
	ORDER BY p.name;

-- question 11
CREATE TABLE campaigns1 (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE email_stats (
    campaign_id INT,
    emails_sent INT,
    emails_opened INT,
    FOREIGN KEY (campaign_id) REFERENCES campaigns1(id)
);
INSERT INTO campaigns1 (id, name) VALUES
(1, 'SummerSale2021'),
(2, 'FallPromo'),
(3, 'WinterWonderland');
INSERT INTO email_stats (campaign_id, emails_sent, emails_opened) VALUES
(1, 1000, 800),
(2, 1500, 1200),
(3, 2000, 1800),
(1, 500, 300),
(2, 700, 500),
(3, 800, 600),
(1, 300, 200),
(2, 400, 300),
(3, 600, 500),
(3, 400, 300);
select c.name,
	SUM(e.emails_sent) AS total_emails_sent,
	SUM(e.emails_opened) AS total_emails_opened,
	(SUM(e.emails_sent)-SUM(e.emails_opened)) AS total_emails_not_opened 
	from campaigns1 c
	JOIN email_stats e ON c.id=e.campaign_id
	GROUP BY c.name
	ORDER BY c.name;

-- question 12
CREATE TABLE lots (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE offers (
    lot_id INT,
    amount DECIMAL(6,2),
    FOREIGN KEY (lot_id) REFERENCES lots(id)
);
INSERT INTO lots (id, name) VALUES
(1, 'Acacia parramattensis Tindale'),
(2, 'Poa arctica R. Br. ssp. aperta (Scribn. & Merr.) Soreng'),
(3, 'Calophyllum inophyllum L.');
INSERT INTO offers (lot_id, amount) VALUES
(1, 260.91),
(1, 802.83),
(1, 986.78),
(2, 814.57),
(2, 999.06),
(2, 414.67),
(3, 200.41),
(3,593.07),
(3, 701.88),
(3, 972.87);
select l.name,
	MAX(o.amount) AS highest_offer,
	COUNT(*) AS total_offers
	from lots l
	JOIN offers o ON l.id=o.lot_id
	GROUP BY l.name
	ORDER BY l.name;

	
-- question 13
CREATE TABLE accounts1 (
    id INT NOT NULL PRIMARY KEY,
    iban VARCHAR(255)
);
CREATE TABLE transactions1(
    account_id INT,
    dt CHAR(19),
    amount DECIMAL(5,2),
    FOREIGN KEY (account_id) REFERENCES accounts1(id)
);
INSERT INTO accounts1 (id, iban) VALUES
(1, 'BG40 RFFX 4898 53DD CZD6 KQ'),
(2, 'PT42 5267 0592 8451 8001 2180 3'),
(3, 'FR96 8758 8909 81LR DJ71 ERKN D56');
INSERT INTO transactions1 (account_id, dt, amount) VALUES
(1, '2022-09-02 06:33:39', 33.31),
(1, '2022-09-20 08:14:39', 31.77),
(1, '2022-09-25 06:41:45', 72.84),
(2, '2022-09-04 22:28:12', 35.26),
(2, '2022-09-17 07:57:29', 33.27),
(2, '2022-09-27 22:30:36', 70.78),
(3, '2022-09-16 21:54:12', 75.04),
(3, '2022-09-19 18:27:39', 71.19),
(3, '2022-09-28 01:38:56', 14.34),
(3, '2022-08-30 01:35:31', 69.19);

select a.iban,
	MIN(t.amount) AS min_transaction,
	MAX(t.amount) AS max_transaction,
	ROUND(AVG(t.amount),2) AS avg_transaction,
	COUNT(*) AS total_transaction
	from accounts1 a
	JOIN transactions1 t ON a.id=t.account_id
	WHERE t.dt LIKE '2022-09-%'
	GROUP BY a.iban
	ORDER BY a.iban;

-- question 14
CREATE TABLE products2 (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(6,2),
    in_stock SMALLINT
);
CREATE TABLE wishlists2 (
    product_id INT,
    customer_email VARCHAR(255),
    FOREIGN KEY (product_id) REFERENCES products2(id)
);
INSERT INTO products2 (id, name, price, in_stock) VALUES
(1, 'TechGadget Pro X', 274.80, 1),
(2, 'LuxuryHome Decor Set', 262.84, 1),
(3, 'FitnessTracker Elite', 637.92, 0),
(4, 'GourmetCookware Set', 535.34, 1),
(5, 'Fashionista Wardrobe Collection', 525.44, 1);
INSERT INTO wishlists2 (product_id, customer_email) VALUES
(1, 'crabbec@redcross.org'),
(1, 'efindlow2@tinypic.com'),
(1, 'jmachoste5@issuu.com'),
(1, 'nselle@simplemachines.org'),
(2, 'aonn1@ebay.co.uk'),
(2, 'bbolton0@google.cn'),
(2, 'ebockett3@storify.com'),
(2, 'fdunguyg@symantec.com'),
(2, 'slowried@cbsnews.com'),
(3, 'jgately7@goo.ne.jp'),
(3, 'ospearettj@bandcamp.com'),
(3, 'rpanonsb@paypal.com'),
(3, 'ydevauxh@toplist.cz'),
(3, 'zbbabbage9@imageshack.us'),
(4 , 'dpauleya@cnbc.com'),
(4 ,'jletterick4@dailymotion.com'),
(4, 'khunnisett6@princeton.edu'),
(4 ,'rkernellf@uiuc.edu'),
(5, 'blodin8@wikimedia.org'),
(5, 'lyusupovi@nps.gov');

select p.name,
	p.price,
	COUNT(*) AS total_wishes
	from products2 p
	JOIN wishlists2 w ON p.id=w.product_id
	WHERE p.in_stock=1
	GROUP BY p.name,p.price
	ORDER BY total_wishes DESC,p.name
	LIMIT 3;

	
-- question 15
CREATE TABLE customers2 (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);
CREATE TABLE purchases2 (
    customer_id INT,
    dt VARCHAR(19),
    amount DECIMAL(6,2),
    FOREIGN KEY (customer_id) REFERENCES customers2(id)
);
INSERT INTO customers2 (id, email) VALUES
(1, 'floggies0@newsvine.com'),
(2, 'sgillbe1@ca.gov'),
(3, 'jgohn2@elegantthemes.com');
INSERT INTO purchases2 (customer_id, dt, amount) VALUES
(2, '2024-02-21 02:56:12', 228.58),
(2, '2024-02-23 09:32:47', 972.41),
(1, '2024-03-14 15:50:13', 109.16),
(1, '2024-03-17 00:31:44', 11.49),
(1, '2024-03-17 04:15:42', 692.64),
(2, '2024-03-01 04:35:09', 589.74),
(2, '2024-03-13 14:42:23', 508.75),
(2, '2024-03-17 07:57:36', 933.91),
(2, '2024-03-19 08:24:38', 488.26),
(2, '2024-03-31 23:30:54', 55.07),
(3, '2024-03-03 11:34:30', 816.67),
(3, '2024-03-08 23:46:07', 672.93),
(3, '2024-03-15 18:09:56', 260.66),
(3, '2024-03-20 15:18:11', 321.07),
(3, '2024-03-20 17:40:35', 29.06),
(3, '2024-03-20 23:41:39', 314.85),
(3, '2024-03-25 11:41:07', 67.12),
(1, '2024-04-05 03:05:10', 417.78),
(2, '2024-04-09 08:16:17', 697.53),
(3, '2024-04-02 07:56:48', 156.27);

select c.email,
	COUNT(*) AS total_purchases,
	SUM(p.amount) AS total_purchase_amount
	from customers2 c
	JOIN purchases2 p ON c.id=p.customer_id
	WHERE p.dt LIKE '2024-03-%'
	GROUP BY c.email
	ORDER BY c.email;

-- question 16
CREATE TABLE applicants (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);
CREATE TABLE appointments (
    applicant_id INT,
    dt VARCHAR(19),
    is_received BOOLEAN,
    FOREIGN KEY (applicant_id) REFERENCES applicants(id)
);
INSERT INTO applicants (id, email) VALUES
(1, 'nkienzle0@spiegel.de'),
(2, 'alaste1@bbc.co.uk'),
(3, 'jjochamany2@ow.ly'),
(4, 'bsenn3@salon.com'),
(5, 'bwhittall4@nhs.uk');
INSERT INTO appointments (applicant_id, dt, is_received) VALUES
(1, '2024-04-27','0'),
(2, '2024-04-01', '0'),
(3, '2024-04-15','0' ),
(4, '2024-03-27', '0'),
(5, '2024-03-26', '1');
select a.email,
	ap.dt AS scheduled_appointment,
	(Date '2024-04-10'-ap.dt::date) AS days_of_delay
	from applicants a
	JOIN appointments ap ON a.id=ap.applicant_id
	WHERE ap.is_received='0' AND ap.dt<'2024-04-10'
	GROUP BY a.email,ap.dt
	ORDER BY scheduled_appointment,a.email;

-- question 17
CREATE TABLE applicants2 (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);
CREATE TABLE appointments2 (
    applicant_id INT,
    dt VARCHAR(19),
    FOREIGN KEY (applicant_id) REFERENCES applicants2(id)
);
INSERT INTO applicants2 (id, email) VALUES
(1, 'rastlatt0@instagram.com'),
(2, 'gcarmody1@stanford.edu'),
(3, 'mgreenset2@state.tx.us');
INSERT INTO appointments2 (applicant_id, dt) VALUES
(1, '2024-05-26 01:36:43'),
(2 ,'2024-05-27 16:30:28'),
(3 ,'2024-05-18 19:28:52');
select a.email,
	TO_CHAR(TO_DATE(apt.dt,'YYYY-MM-DD'),'Day') AS scheduled_appointmnet
	from applicants2 a
	JOIN appointments2 apt ON a.id=apt.applicant_id
	WHERE EXTRACT(DOW FROM(TO_DATE(apt.dt,'YYYY-MM-DD'))) IN (0,6)
	order by a.email;

-- question 18
CREATE TABLE countries2 (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE domains3 (
    country_id INT ,
    name VARCHAR(255),
	is_Active BOOLEAN,
	FOREIGN KEY (country_id) REFERENCES countries2(id)
);
INSERT INTO countries2 (id, name) VALUES
(1, 'Azerbaijan'),
(2, 'Colombia'),
(3, 'China');
INSERT INTO domains3 (country_id, name, is_Active) VALUES
(1, 'angelfire.com', '1'),
(1, 'free.fr',  '1'),
(1, 'google.cn',  '1'),
(1, 'nationalgeographic.com',  '1'),
(1, 'ovh.net',  '1'),
(1, 'surveymonkey.com',  '1'),
(1, 'twitpic.com',  '1'),
(2, 'ameblo.jp',  '1'),
(2, 'berkeley.edu',  '1'),
(2, 'multiply.com',  '1'),
(2, 'redcross.org',  '1'),
(2, 'sourceforge.net',  '1'),
(3, 'hc360.com',  '1'),
(3, 'liveinternet.ru',  '1'),
(3, 'squidoo.com',  '1'),
(3, 'technorati.com',  '1'),
(3, 'webnode.com',  '1'),
(3, 'yahoo.co.jp',  '1'),
(1, 'und.de', '0'),
(1, 'qq.con', '0');

select c.name,
	COUNT(*) AS total_domains
	from countries2 c
	JOIN domains3 d ON c.id=d.country_id
	WHERE d.is_active='1'
	GROUP BY c.name
	ORDER BY c.name;

-- question 19
CREATE TABLE domains4 (
    name VARCHAR(255),
    next_renewal_date VARCHAR(19)
);
INSERT INTO domains4 (name, next_renewal_date) VALUES
('wired.com', '2024-06-14 00:10:12'),
('blogger.com', '2024-07-18 05:54:57'),
('com.com', '2024-07-21 02:57:25');

select name,
	'2024-04-10' AS today_date,
	To_Date(next_renewal_date,'YYYY-MM-DD') AS next_renewal_date,
	(next_renewal_date::date-Date '2024-04-10') AS days_until_renewal
	from domains4
	ORDER BY days_until_renewal,name;

-- question 20
CREATE TABLE users (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);
CREATE TABLE transactions2 (
    user_id INT,
    dt VARCHAR(19),
    amount DECIMAL(5,2),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
INSERT INTO users (id, email) VALUES
(1, 'bblaszczynski0@devhub.com'),
(2, 'dwookey1@chronoengine.com'),
(3, 'flerway2@wikipedia.org');
INSERT INTO transactions2 (user_id, dt, amount) VALUES
(1, '2024-02-23 19:30:03', 942.50),
(1, '2024-03-07 09:01:15', 855.22),
(1, '2024-04-01 04:18:41', 253.35),
(1, '2024-04-07 02:40:58', 886.88),
(2, '2024-02-25 05:11:39', 957.77),
(2, '2024-03-06 03:00:40', 413.39),
(2, '2024-03-07 14:41:03', 906.16),
(2, '2024-03-10 00:58:13', 116.59),
(2, '2024-03-13 23:38:29', 550.31),
(2, '2024-03-22 03:07:46', 196.23),
(2, '2024-03-24 00:23:14', 399.76),
(2, '2024-03-25 12:28:18', 398.07),
(2, '2024-03-27 09:11:15', 212.33),
(2, '2024-04-09 06:33:26', 97.85),
(3, '2024-03-01 17:24:48', 323.11),
(3, '2024-03-05 10:16:06', 673.23),
(3, '2024-03-08 14:19:46', 236.74),
(3, '2024-03-23 15:37:47', 234.87),
(3, '2024-04-05 20:55:45', 989.35),
(3, '2024-04-07 05:26:35', 369.20);
select u.email,
	COUNT(*) AS total_transactions,
	MIN(t.amount) AS min_amount,
	MAX(t.amount) AS max_amount,
	SUM(t.amount) AS total_amount
	from users u
	JOIN transactions2 t ON u.id=t.user_id
	WHERE t.dt LIKE '2024-03-%'
	GROUP BY u.email
	ORDER BY u.email;

-- question 21
CREATE TABLE users2 (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);
CREATE TABLE transactions4 (
    user_id INT,
    dt VARCHAR(19),
    amount DECIMAL(5,2),
    FOREIGN KEY (user_id) REFERENCES users2(id)
);
INSERT INTO users2 (id, email) VALUES
(1, 'lvasilevich0@google.co.uk'),
(2, 'hscholey1@sina.com.cn'),
(3, 'mmcjury2@hibu.com');
INSERT INTO transactions4 (user_id, dt, amount) VALUES
(3, '2022-12-05 00:16:56', 162.11),
(1, '2023-05-20 03:20:58', 81.58),
(1, '2023-06-08 19:24:02', 52.46),
(1, '2023-06-27 21:16:07', 447.59),
(1, '2023-07-20 08:19:32', 136.68),
(1, '2023-12-11 17:08:05', 852.55),
(1, '2023-12-15 04:45:54', 77.11),
(1, '2023-12-22 00:46:34', 670.71),
(1, '2023-12-29 12:43:23', 948.46),
(2, '2023-01-04 00:51:46', 793.50),
(2, '2023-04-07 16:29:14', 762.52),
(2, '2023-06-17 17:42:50', 527.18),
(2, '2023-10-10 11:16:51', 733.47),
(2, '2023-10-18 23:32:00', 920.14),
(3, '2023-03-27 18:31:41', 408.13),
(3, '2023-04-08 09:57:55', 817.88),
(3, '2023-05-18 09:47:14', 916.98),
(3, '2023-09-14 14:00:54', 53.30),
(3, '2023-09-30 01:34:01', 589.37),
(3, '2024-01-27 15:13:58', 666.37);
select u.email,
	COUNT(*) AS total_transactions,
	SUM(t.amount) AS total_amount
	from users2 u
	JOIN transactions4 t ON u.id=t.user_id
	WHERE t.dt LIKE '2023-%'
	GROUP BY u.email
	ORDER BY u.email;

-- Question 22
CREATE TABLE coins5 (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE transactions5 (
    coin_id INT,
    dt VARCHAR(19),
    amount DECIMAL(5,2),
    FOREIGN KEY (coin_id) REFERENCES coins5(id)
);
INSERT INTO coins5 (id, name) VALUES
(1, 'BitCash'),
(2, 'Etherium'),
(3, 'Litecoin'),
(4, 'Ripple'),
(5, 'Dogecoin');
INSERT INTO transactions5 (coin_id, dt, amount) VALUES
(1, '2022-12-09 19:40:17', 60.91),
(1, '2023-01-02 09:35:37', 76.35),
(1, '2023-03-21 09:34:39', 23.11),
(1, '2023-08-11 03:43:27', 80.20),
(1, '2023-10-21 19:42:46', 29.59),
(2, '2023-07-08 19:47:20', 69.49),
(2, '2023-09-22 14:23:40', 23.13),
(3, '2023-01-08 10:22:10', 72.45),
(3, '2023-01-28 00:54:51', 98.72),
(3, '2023-02-24 00:13:32', 70.36),
(3, '2023-05-16 15:13:19', 93.59),
(4, '2023-05-24 13:43:44', 9.34),
(4, '2023-07-25 14:59:09', 78.52),
(5, '2023-01-20 15:49:38', 81.66),
(5, '2023-08-21 17:19:45', 94.89),
(5, '2023-10-25 00:44:42', 64.40),
(5, '2023-11-30 02:38:47', 86.84),
(5, '2023-12-31 03:26:39', 58.99),
(2, '2024-01-21 10:25:26', 29.36),
(5, '2024-01-08 03:09:00', 95.25);
select c.name,
	ROUND(AVG(t.amount),2) AS avg_transaction_amount
	from coins5 c
	JOIN transactions5 t ON c.id=t.coin_id
	WHERE t.dt LIKE '2023-%'
	GROUP BY c.name
	ORDER BY avg_transaction_amount
	LIMIT 3;

--Question 23
CREATE TABLE coin (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE transaction (
    coin_id INT,
    dt VARCHAR(19),
    amount DECIMAL(5,2),
    FOREIGN KEY (coin_id) REFERENCES coin(id)
);
INSERT INTO coin (id, name) VALUES
(1, 'BitCash'),
(2, 'Etherium'),
(3, 'Litecoin');

INSERT INTO transaction (coin_id, dt, amount) VALUES
(1, '2024-02-24 14:56:31', 69.38),
(2, '2024-02-24 17:23:54', 46.79),
(1, '2024-03-07 15:07:57', 73.45),
(1, '2024-03-13 00:47:18', 2.10),
(1, '2024-03-13 06:21:06', 5.68),
(1, '2024-03-14 15:06:59', 25.32),
(1, '2024-03-20 02:10:37', 72.85),
(2, '2024-03-09 12:06:47', 67.79),
(2, '2024-03-16 06:17:14', 82.87),
(2, '2024-03-24 11:11:23', 5.96),
(2, '2024-03-26 14:36:34', 21.80),
(3, '2024-03-20 08:28:56', 5.07),
(3, '2024-03-23 06:45:13', 11.85),
(3, '2024-03-27 02:40:23', 34.25),
(3, '2024-03-28 07:37:50', 81.12),
(3, '2024-03-29 07:34:32', 19.06),
(1, '2024-04-02 08:49:17', 13.04),
(2, '2024-04-04 17:29:13', 4.74),
(2, '2024-04-04 20:17:36', 94.42),
(2, '2024-04-07 01:47:46', 64.76);

select c.name,
	COUNT(*) AS total_transactions,
	MIN(t.amount) AS min_amount,
	MAX(t.amount) AS max_amount,
	ROUND(AVG(t.amount),2) AS avg_amount
	from coin c 
	JOIN transaction t ON c.id=t.coin_id
	WHERE t.dt LIKE '2024-03-%'
	GROUP BY c.name
	ORDER BY total_transactions DESC;

--  question 24
CREATE TABLE suspicious_files (
    filename VARCHAR(255),
    extensions VARCHAR(255),
    scan_dt VARCHAR(200),
    is_suspicious SMALLINT
);
INSERT INTO suspicious_files (filename,extensions,scan_dt,is_suspicious
) VALUES
('Mauris.pdf','.pdf', '2024-04-05 23:55:27',1),
('Augue.xls', '.xls', '2024-02-28 18:11:28', 1),
('Sapien.avi', '.avi',' 2024-03-30 12:24:10 ',1),
('Pulvinar.doc', '.doc',' 2024-03-08 22:00:41', 1),
('TemporConvallisNulla.gif', '.gif', '2024-03-29 21:32:41', 1),
('InFaucibus.mp3', '.mp3', '2024-03-20 14:18:32' ,1),
('EleifendPedeLibero.ppt', '.ppt', '2024-03-05 04:47:56', 1),
('VestibulumAnteIpsum.ppt' ,'.ppt', '2024-03-05 17:34:34', 1),
('IntegerPede.ppt', '.ppt', '2024-03-12 17:11:28', 1),
('VenenatisNon.tisNon.tiff' ,  '.tiff', '2024-03-20 18:04:47', 1),
('IaculisDiam.xls', '.xls', '2024-03-01 05:18:03', 1),
('QuisqueArcuLibero.xls', '.xls', '2024-03-09 09:00:32', 1),
('MaurisSit.png', '.png', '2024-04-03 23:20:03', 0),
('SitAmetSem.mp3', '.mp3', '2024-02-23 22:06:43', 0),
('Nisi.mp3', '.mp3', '2024-02-29 09:40:45', 0),
('Magna.tiff', '.tiff' ,'2024-02-27 00:25:16', 0),
('EratVestibulum.gif', '.gif' , '2024-03-30 04:19:52', 0),
('Neque.jpeg' ,'.jpeg' ,'2024-03-07 07:11:26', 0),
('VolutpatQuam.ppt', '.ppt', '2024-03-23 04:33:43' ,0),
('NonQuam.xls', '.xls','2024-03-10 19:12:29',0);

select extensions,
	COUNT(*) AS total_suspicious_files
	from suspicious_files
	WHERE is_suspicious='1' AND scan_dt LIKE '2024-03-%'
	GROUP BY extensions
	ORDER BY total_suspicious_files DESC,extensions
	LIMIT 5;

-- question 25
CREATE TABLE clients (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);
CREATE TABLE device (
    client_id INT,
    mac_address VARCHAR(255),
    is_scanned SMALLINT,
    schedule_scan_dt VARCHAR(100),
    FOREIGN KEY (client_id) REFERENCES clients(id)
);
INSERT INTO clients (id, email) VALUES
(1, 'cbracegirdle0@irs.gov'),
(2, 'gwickardt1@msu.edu'),
(3, 'mpaulon2@edublogs.org');
INSERT INTO device (client_id, mac_address, is_scanned, schedule_scan_dt) VALUES
(1, '87-EF-C7-BD-DF-A2', 1, '2024-02-28 08:13:55'),
(1, '37-FE-45-2B-9D-2A', 1, '2024-03-07 00:00:05'),
(1, '13-82-F2-48-88-FD', 1, '2024-03-11 06:53:47'),
(1, '0D-56-2A-B2-33-EF', 1, '2024-03-30 19:41:31'),
(1, '17-C3-E3-2E-37-7E', 1, '2024-04-06 13:14:06'),
(1, '93-25-74-C5-07-32', 0, '2024-02-21 16:23:31'),
(2, '64-E1-5B-12-AC-F9', 0, '2024-02-22 10:40:23'),
(2, '0F-66-56-E2-B0-3A', 0, '2024-02-23 11:03:58'),
(2, '40-F4-40-12-C8-A5', 0, '2024-02-24 18:01:50'),
(2, 'B0-2B-99-84-68-7C', 0, '2024-02-25 21:31:06'),
(2, '07-1F-BD-16-AC-23', 0, '2024-02-29 21:45:22'),
(2, 'CA-79-F4-B4-9E-69', 0, '2024-03-29 00:05:10'),
(3, '71-EB-63-A2-3C-AF', 1, '2024-03-03 07:50:20'),
(3, '0B-40-DF-14-53-0F', 1, '2024-03-21 11:10:52'),
(3, '0A-77-ED-ED-50-28', 1, '2024-04-03 04:11:25'),
(3, 'A4-79-0C-6D-B8-4C', 1, '2024-04-04 13:50:43'),
(3, '44-A5-56-27-C8-70', 0, '2024-03-28 21:15:26'),
(3, '93-64-42-51-62-6F', 0, '2024-03-31 20:26:01'),
(3, '87-5E-B3-51-38-2D', 0, '2024-04-05 10:51:00'),
(3, 'DE-F2-F6-AD-76-4A', 0, '2024-04-08 23:15:03');
Select c.email,
	COUNT(*) AS total_scanned_devices
	from clients c
	JOIN device d ON c.id=d.client_id
	WHERE d.schedule_scan_dt LIKE '2024-03-%' and is_scanned='1'
	GROUP BY c.email
	ORDER BY c.email;

-- question 26
CREATE TABLE customers3 (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);
CREATE TABLE site_metrics (
    customer_id INT,
    cpu_usage DECIMAL(5,2),
    memory_usage DECIMAL(5,2),
    disk_usage DECIMAL(5,2),
    FOREIGN KEY (customer_id) REFERENCES customers3(id)
);
INSERT INTO site_metrics (customer_id, cpu_usage, memory_usage, disk_usage) VALUES
(1, 31.53, 80.84, 1.51),
(1, 12.54, 26.47, 47.74),
(1, 12.34, 46.24, 34.43),
(1, 26.64, 84.98, 17.56),
(2, 80.45, 50.05, 10.63),
(2, 40.14, 86.67, 15.98),
(2, 30.14, 34.38, 17.67),
(2, 1.11, 83.44, 2.95),
(3, 30.60, 18.60, 28.02),
(3, 41.64, 33.64, 5.20),
(3, 31.88, 7.37, 91.14),
(3, 43.20, 9.56, 40.40),
(3, 2.33, 34.29, 18.65),
(3, 11.50, 32.89, 71.39),
(3, 39.57, 4.49, 48.05),
(3, 25.06, 23.77, 33.00),
(3, 32.81, 1.59, 25.85),
(3, 48.38, 79.21, 8.31),
(3, 11.62, 26.75, 71.71),
(3, 54.43, 6.48, 4.86);
INSERT INTO customers3 (id, email) VALUES
(1, 'lrathke0@usa.gov'),
(2, 'epearsall1@fema.gov'),
(3, 'sivasechko2@cisco.com');

select c.email,
	ROUND(AVG(cpu_usage),2) AS average_cpu_usage,
	ROUND(AVG(memory_usage),2) AS average_memory_usage,
	ROUND(AVG(disk_usage),2) AS average_disk_usage
	from site_metrics s
	JOIN customers3 c
	ON c.id=s.customer_id
	GROUP BY c.email
	HAVING AVG(cpu_usage)>50 OR AVG(memory_usage)>50 OR AVG(disk_usage)>50
	ORDER BY c.email;

-- Question 27
CREATE TABLE customers4 (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);
CREATE TABLE sites (
    customer_id INT,
    url VARCHAR(255),
    is_active SMALLINT,
    FOREIGN KEY (customer_id) REFERENCES customers4(id));
INSERT INTO customers4 (id, email) VALUES
(1, 'dcristofol0@slashdot.org'),
(2, 'mbillanie1@japanpost.jp'),
(3, 'hmainz2@utexas.edu');
INSERT INTO sites (customer_id, url, is_active) VALUES
(1, 'https://trellian.com', 1),
(1, 'https://www.google.de', 1),
(1, 'https://merriam-webster.com', 1),
(1, 'https://wordpress.com', 1),
(1, 'https://nsw.gov.au', 1),
(1, 'https://www.barnesandnoble.com', 1),
(1, 'https://www.yahoo.com', 1),
(2, 'https://cloudflare.com', 0),
(2, 'https://www.is.gd', 1),
(2, 'https://www.unesco.org', 1),
(3, 'https://www.sina.com.cn', 0),
(3, 'https://xinhuanet.com', 1),
(3, 'https://cyberchimps.com', 1),
(3, 'https://ask.com', 1),
(3, 'https://businessinsider.com', 1),
(3, 'https://www.dailymail.co.uk', 1),
(3, 'https://www.guardian.co.uk', 1),
(3, 'https://www.microsoft.com', 1),
(3, 'https://www.gizmodo.com', 1),
(3, 'https://www.163.com', 1);

select c.email,
	COUNT(*) AS total_Active_Sites
	from customers4 c
	JOIN sites s ON c.id=s.customer_id
	WHERE s.is_active='1'
	GROUP BY c.email
	ORDER BY c.email;

-- question 28
CREATE TABLE account (
    id INT PRIMARY KEY,
    iban VARCHAR(255)
);
CREATE TABLE income1 (
    account_id INT,
    dt VARCHAR(19),
    amount DECIMAL(6,2),
    FOREIGN KEY (account_id) REFERENCES account(id)
);
INSERT INTO account (id,iban) VALUES 
(1, 'SK39 8924 2092 2997 1101 4161'),
(2,'PL28 9141 8610 8442 2367 7521 0000'),
(3,'CH93 8418 0F7G KQK4 NEHF Q'),
(4,'GT41 TBM8 DPFH MTNS BVW5 D4CX VIRR'),
(5,'IT27 Y015 0159 036T W7E5 I6ZD EQZ');
INSERT INTO income1 (account_id, dt, amount) VALUES
(1, '2024-01-17 16:43:20', 4061.53),
(1, '2024-02-28 05:30:15', 4488.11),
(1, '2024-04-07 05:41:27', 4001.91),
(2, '2023-12-21 07:38:45', 4313.69),
(2, '2024-01-08 04:48:45', 3640.82),
(2, '2024-01-20 17:31:20', 3385.15),
(3, '2024-01-06 23:18:30', 2347.15),
(3, '2024-03-08 12:53:20', 3814.86),
(3, '2024-04-01 21:18:16', 2764.27),
(4, '2024-01-02 23:52:06', 3526.08),
(4, '2024-02-04 12:32:28', 2221.91),
(4, '2024-02-11 19:44:53', 4197.07),
(4, '2024-03-06 06:28:34', 1357.44),
(4, '2024-03-16 16:13:49', 1854.52),
(5, '2023-12-31 22:08:57', 2819.54),
(5, '2024-01-14 18:03:47', 2641.20),
(5, '2024-01-23 07:50:22', 3692.56),
(5, '2024-02-28 23:43:28', 1999.09),
(5, '2024-03-20 10:29:44', 1670.18),
(5, '2024-03-27 11:12:04', 1193.15);
select a.iban,
	ROUND(AVG(i.amount),2) AS average_income,
	ROUND(SUM(i.amount),2) AS total_income
	from account a
	JOIN income1 i ON a.id=i.account_id
	WHERE i.dt>='2024-01-01' AND i.dt<='2024-03-31'
	GROUP BY a.iban
	ORDER BY average_income DESC,iban
	LIMIT 3;

--question 29
CREATE TABLE account01 (
    id INT PRIMARY KEY,
    iban VARCHAR(255)
);
CREATE TABLE income01 (
    account_id INT,
    dt VARCHAR(19),
    amount DECIMAL(6,2),
    FOREIGN KEY (account_id) REFERENCES account01(id)
);
INSERT INTO account01 (id,iban) VALUES
(1,'FR55 8924 2092 2997 1101 4161'),
(2,'DK46 9141 8610 8442 2367 7521 0000'),
(3,'RS52 8418 0F7G KQK4 NEHF Q');
INSERT INTO income01 (account_id, dt, amount) VALUES
(1, '2022-12-31 10:03:42', 2779.19),
(1, '2023-02-04 08:50:14', 1777.68),
(1, '2023-03-04 04:22:07', 1954.81),
(1, '2023-03-04 14:46:04', 1547.79),
(1, '2023-05-23 15:42:13', 1208.49),
(1, '2023-05-23 23:24:07', 1521.72),
(1, '2023-07-28 11:01:46', 1792.75),
(1, '2023-12-07 14:19:09', 2374.25),
(1, '2024-01-27 05:55:36', 2803.39),
(2, '2022-12-13 18:40:34', 1826.65),
(2, '2023-02-17 00:59:57', 3074.11),
(2, '2023-03-01 08:17:15', 1007.30),
(2, '2023-08-19 09:16:41', 4515.04),
(2, '2024-01-08 14:14:22', 3321.78),
(2, '2024-01-10 15:16:28', 2033.87),
(3, '2023-05-09 07:28:27', 3158.66),
(3, '2023-05-22 00:49:34', 3851.21),
(3, '2023-07-21 19:51:14', 4152.29),
(3, '2023-10-05 00:42:49', 4722.20),
(3, '2023-11-11 00:42:49', 1592.16);
drop table income01;
select a.iban,
	SUM(i.amount) AS total_income,
	'20%' AS tax_rate,
	ROUND(SUM(i.amount*0.2) ,2)AS calculated_tax
	from account01 a
	JOIN income01 i ON a.id=i.account_id
	WHERE i.dt LIKE '2023-%'
	GROUP BY a.iban
	ORDER BY a.iban;

-- question 30
CREATE TABLE customers12 (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);
drop table customers0;
CREATE TABLE expenses12 (
    customer_id INT,
    dt VARCHAR(19),
    amount DECIMAL(6,2),
    FOREIGN KEY (customer_id) REFERENCES customers0(id)
);
CREATE TABLE incomes12 (
    customer_id INT,
    dt VARCHAR(19),
    amount DECIMAL(6,2),
    FOREIGN KEY (customer_id) REFERENCES customers0(id)
);
INSERT INTO customers12 (id, email) VALUES
(1, 'otoohey0@elpais.com'),
(2, 'egrebbin1@state.gov'),
(3, 'arides2@sohu.com');
INSERT INTO expenses12 (customer_id, dt, amount) VALUES
(1, '2024-02-21 22:12:12', 90.41),
(1, '2024-02-27 06:48:37', 792.88),
(1, '2024-03-10 05:19:43', 442.01),
(1, '2024-03-11 19:48:25', 327.35),
(1, '2024-03-24 22:03:06', 639.62),
(1, '2024-03-29 00:37:46', 150.12),
(1, '2024-04-02 03:36:50', 257.67),
(2, '2024-02-21 06:11:26', 400.22),
(2, '2024-03-11 15:34:19', 298.41),
(2, '2024-03-25 04:36:27', 376.87),
(2, '2024-03-29 19:05:51', 530.07),
(2, '2024-03-30 07:07:28', 287.84),
(2, '2024-04-02 15:44:22', 868.03),
(3, '2024-03-01 16:02:47', 33.30),
(3, '2024-03-06 11:53:42', 838.51),
(3, '2024-03-20 23:34:48', 968.08),
(3, '2024-03-21 21:18:08', 35.36),
(3, '2024-03-30 06:51:13', 956.12),
(3, '2024-03-31 10:11:56', 896.32),
(3, '2024-03-31 22:36:57', 740.94);
INSERT INTO incomes12 (customer_id, dt, amount) VALUES
(1, '2024-02-20 21:00:55', 366.66),
(1, '2024-03-11 03:25:04', 769.38),
(1, '2024-03-15 00:49:53', 84.10),
(1, '2024-03-21 18:32:51', 839.48),
(1, '2024-03-29 15:34:13', 333.97),
(1, '2024-04-01 00:34:24', 253.13),
(1, '2024-04-02 11:13:49', 263.56),
(2, '2024-02-20 15:03:26', 822.75),
(2, '2024-02-26 14:57:39', 277.23),
(2, '2024-03-19 09:24:47', 24.08),
(2, '2024-03-20 15:54:24', 988.34),
(2, '2024-04-02 08:28:38', 990.54),
(3, '2024-02-21 10:23:33', 430.82),
(3, '2024-02-29 08:25:32', 482.85),
(3, '2024-03-01 05:10:42', 962.60),
(3, '2024-03-04 08:27:34', 30.21),
(3, '2024-03-19 12:12:01', 80.00),
(3, '2024-03-21 00:32:10', 674.76),
(3, '2024-03-23 14:14:32', 863.79),

select c.email,
	total_expenses,
	total_income from customers12 c
	JOIN(
		select customer_id,
		SUM(AMOUNT) AS total_expenses
		from expenses12 e
		WHERE dt LIKE '2024-03-%'
		GROUP BY customer_id
	)e ON c.id=e.customer_id
	JOIN(
		select customer_id,
		SUM(amount) AS total_income
		from incomes12 i
		WHERE dt LIKE '2024-03-%'
		GROUP BY customer_id
	)i ON c.id=i.customer_id
ORDER BY c.email;

-- question 31
CREATE TABLE cust1 (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);
CREATE TABLE exp1 (
    customer_id INT,
    amount DECIMAL(6,2),
    FOREIGN KEY (customer_id) REFERENCES cust(id)
);
CREATE TABLE inc1 (
    customer_id INT,
    amount DECIMAL(6,2),
    FOREIGN KEY (customer_id) REFERENCES cust(id)
);
INSERT INTO cust1 (id, email) VALUES
(1, 'dtollmache0@typepad.com'),
(2, 'eclutterbuck1@baidu.com'),
(3, 'mdensun2@ustream.tv');
INSERT INTO exp1 (customer_id, amount) VALUES
(1, 136.18),(1, 323.28),(1, 383.37),(1, 505.41),
(1, 841.21),(2, 5.23),(2, 408.33),(2, 489.45),
(2, 545.40),(2, 591.43),(2, 706.13),(2, 716.82),
(2, 761.75),(2, 796.30),(3, 152.26),(3, 211.30),
(3, 447.57),(3, 685.03),(3, 966.89),(3, 967.30);
INSERT INTO inc1 (customer_id, amount) VALUES
(1, 39.44),(1, 49.49),(1, 292.19),(1, 419.36),
(1, 529.26),(1, 695.43),(1, 763.72),(1, 797.92),
(1,833.34),(2,139.42),(2,422.18),(2, 506.59),
(2, 566.00),(2, 697.92),(2, 938.51),(3, 304.66),
(3, 345.03),(3, 371.86),(3, 371.88),(3, 552.08);

select c.email,
	ROUND(total_incomes-total_expenses,2) AS balance
	from cust1 c
	JOIN(
		select customer_id,
		SUM(amount) AS total_expenses
		from exp1 e
		GROUP BY customer_id
	)e ON c.id=e.customer_id
	JOIN(
		select customer_id,
		SUM(amount) AS total_incomes
		from inc1 i
		GROUP BY customer_id
	)i ON c.id=i.customer_id
WHERE ROUND(total_incomes-total_expenses)<0
ORDER BY c.email;

--question 32
CREATE TABLE prod (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE sale (
    product_id INT,
    dt VARCHAR(19),
    amount DECIMAL(7,2),
    FOREIGN KEY (product_id) REFERENCES prod(id)
);
INSERT INTO prod(id, name) VALUES
(1, 'Luxury Gold Watch'),
(2, 'Smartphone Holder Stand'),
(3, 'Stainless Steel Water Bottle');
INSERT INTO sale (product_id, dt, amount) VALUES
(1, '2024-01-13 17:12:22', 7008.16),
(1, '2024-01-03 03:15:27', 6191.64),
(1, '2024-01-22 18:29:09', 4527.86),
(1, '2024-01-26 19:38:53', 7828.36),
(1, '2024-02-17 09:27:13', 5273.16),
(1, '2024-02-11 09:51:24', 3364.73),
(1, '2024-02-22 23:53:15', 8584.33),
(2, '2024-01-28 11:33:58', 3710.06),
(2, '2024-01-25 14:47:25', 5221.02),
(2, '2024-01-21 07:58:53', 2525.72),
(2, '2024-03-15 14:16:18', 8158.08),
(2, '2024-03-12 17:02:01', 6760.77),
(3, '2024-01-13 19:27:51', 1942.79),
(3, '2024-02-15 08:04:40', 9186.38),
(3, '2024-03-06 08:02:51', 5821.97),
(3, '2024-03-03 15:39:18', 8676.24),
(2, '2024-04-08 09:53:01', 6327.20),
(1, '2023-12-26 05:27:51', 8360.43),
(1, '2023-12-15 14:04:40', 9101.30),
(3, '2023-12-21 15:02:51', 3857.98);

select p.name,
	TO_CHAR(s.dt::DATE,'Month') AS month,
	SUM(s.amount) AS total_sales
	from prod p 
	JOIN sale s ON p.id=s.product_id
	WHERE s.dt::DATE BETWEEN DATE '2024-01-01' AND DATE '2024-03-31'
	GROUP BY p.name,
	TO_CHAR(s.dt::DATE,'Month'),
	EXTRACT(MONTH FROM s.dt::DATE)
	ORDER BY EXTRACT(MONTH FROM s.dt::DATE),total_sales DESC;

-- question 33
CREATE TABLE project (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE employee (
    id INT PRIMARY KEY,
    ein VARCHAR(255),
    experience_years INT
);
CREATE TABLE project_employee (
    project_id INT,
    employee_id INT,
    FOREIGN KEY (project_id) REFERENCES project(id),
    FOREIGN KEY (employee_id) REFERENCES employee(id)
);
INSERT INTO project (id, name) VALUES
(1, 'Project X'),
(2, 'Sunshine Project'),
(3, 'Blue Sky Initiative');
INSERT INTO employee (id, ein, experience_years) VALUES
(1, '62-0524667', 4),
(2, '62-1435366', 1),
(3, '29-3144922', 1),
(4, '80-9606443', 1),
(5, '63-6630813', 1);
INSERT INTO project_employee (project_id, employee_id) VALUES
(1, 1),(1, 1),(1, 2),(1, 3),(1, 5),(2, 1),(2, 1),
(2, 2),(2, 5),(3, 1),(3, 1),(3, 2),(3, 3),(3, 3),
(3, 4),(3, 4),(3, 5),(3, 5),(3, 5),(3, 5);

select p.name,
	COUNT(*) AS employee_count,
	CEIL(AVG(e.experience_years)) AS average_experience_years,
	CASE WHEN COUNT(*)<5 THEN 'Yes'
	ELSE 'No' END AS is_understaffed
	from project p
	JOIN project_employee pe ON p.id=pe.project_id
	JOIN employee e ON e.id=pe.employee_id
	GROUP BY p.name
	HAVING AVG(e.experience_years)>2
	ORDER BY employee_count DESC,p.name;

-- question 34
CREATE TABLE transactions(
    dt VARCHAR(19),               -- Date and time of the transaction
    wallet VARCHAR(255),         -- Wallet address involved
    amount DECIMAL(4,2)          -- Ethereum amount transacted
);
INSERT INTO transactions(dt, wallet, amount) VALUES
('2024-01-31 13:42:19', '0x1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c', -5.78),
('2024-01-24 06:07:14', '0x1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c', -2.79),
('2024-01-25 06:39:19', '0x9B8aDc2eFf4cC3DdEe5f6a78dE9aC1F', -2.73),
('2024-01-29 04:37:45', '0x9B8aDc2eFf4cC3DdEe5f6a78dE9aC1F', 4.68),
('2024-02-28 06:20:04', '0x1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c', -7.36),
('2024-02-12 07:45:28', '0x1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c', -3.71),
('2024-02-25 09:47:49', '0x1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c', -3.53),
('2024-02-03 10:49:33', '0x1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c', 4.01),
('2024-02-14 08:55:30', '0x1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c', 8.20),
('2024-02-16 04:31:26', '0x3a4FbC5Df2E1bBfDdE5c4fA7bF8dE7aC1F', -8.96),
('2024-02-06 23:45:31', '0x3a4FbC5Df2E1bBfDdE5c4fA7bF8dE7aC1F', -7.88),
('2024-02-11 01:00:35', '0x3a4FbC5Df2E1bBfDdE5c4fA7bF8dE7aC1F', -7.66),
('2024-02-25 09:39:01', '0x3a4FbC5Df2E1bBfDdE5c4fA7bF8dE7aC1F', -7.45),
('2024-02-14 04:04:15', '0x3a4FbC5Df2E1bBfDdE5c4fA7bF8dE7aC1F', 4.17),
('2024-02-15 11:47:23', '0x3a4FbC5Df2E1bBfDdE5c4fA7bF8dE7aC1F', 7.56),
('2024-02-24 14:58:54', '0x9B8aDc2eFf4cC3DdEe5f6a78dE9aC1F', -1.45),
('2024-02-18 21:17:24', '0x9B8aDc2eFf4cC3DdEe5f6a78dE9aC1F', 1.05),
('2024-02-19 11:12:32', '0x9B8aDc2eFf4cC3DdEe5f6a78dE9aC1F', 3.67),
('2024-03-09 16:52:14', '0x1ab23c45de6f7ab89c0d1e2fa34b5c', 1.07),
('2024-03-07 10:29:49', '0x9B8aDc2eFf4cC3DdEe5f6a78dE9aC1F', 7.26);

select wallet,
	COUNT(*) AS total_transactions,
	ROUND(SUM(CASE WHEN amount>0 THEN amount ELSE 0 END),2) AS total_bought,
	ROUND(ABS(SUM(CASE WHEN amount<0 THEN amount ELSE 0 END)),2) AS total_sold
	from transactions
	WHERE dt LIKE '2024-02-%'
	GROUP BY wallet
	ORDER BY wallet;

--question 35
CREATE TABLE employees12 (
    id INT PRIMARY KEY,
    email VARCHAR(255)
);
CREATE TABLE leave_record (
    employee_id INT,
    leave_dt VARCHAR(19),
    days_taken INT,
    FOREIGN KEY (employee_id) REFERENCES employees12(id)
);
INSERT INTO employees12 (id, email) VALUES
(1, 'jquartly0@macromedia.com'),
(2, 'cchastand1@stanford.edu'),
(3, 'lpuckrin2@creativecommons.org');
INSERT INTO leave_record (employee_id, leave_dt, days_taken) VALUES
(1, '2022-11-10 11:52:14', 4),
(1, '2022-09-07 23:22:46', 1),
(2, '2022-11-11 01:47:50', 7),
(3, '2022-11-06 23:12:27', 7),
(3, '2022-11-17 07:43:18', 7),
(1, '2023-05-19 04:40:25', 2),
(1, '2023-12-25 16:29:51', 7),
(1, '2023-03-12 18:54:29', 1),
(1, '2023-08-23 12:33:56', 6),
(2, '2023-04-20 04:19:10', 5),
(2, '2023-04-28 00:41:50', 7),
(3, '2023-06-11 18:49:25', 2),
(3, '2023-12-23 15:53:10', 7),
(3, '2023-03-13 13:46:16', 2),
(3, '2023-10-08 11:57:43', 2),
(3, '2023-04-12 13:46:16', 4),
(3, '2023-01-07 11:57:43', 6),
(1, '2024-02-05 16:01:59', 1),
(1, '2024-01-05 07:49:02', 7),
(2, '2024-02-21 07:49:02', 4);

select e.email,
	SUM(l.days_taken) AS leave_days_taken,
	CASE WHEN SUM(l.days_taken)<=20 THEN 'Within Limit'
	ELSE 'Exceeded' END AS leave_status
	from employees12 e
	JOIN leave_record l ON e.id=l.employee_id
	WHERE l.leave_dt LIKE '2023-%'
	GROUP BY e.email
	ORDER BY e.email;


-- question 36
CREATE TABLE campaign (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE email_stat(
    campaign_id INT,
    emails_sent INT,
    emails_opened INT,
    FOREIGN KEY (campaign_id) REFERENCES campaign(id)
);
INSERT INTO campaign (id, name) VALUES
(1, 'SummerSale2021'),
(2, 'FallPromo'),
(3, 'WinterWonderland');
INSERT INTO email_stat (campaign_id, emails_sent, emails_opened) VALUES
(1, 1749, 775),(1, 641, 423),(1, 976, 598),(1, 756, 121),(1, 975, 107),
(1, 752, 367),(1, 1068, 809),(1, 1046, 589),(1, 1212, 939),
(1, 567, 214),(2, 1084, 283),(2, 992, 478),(2, 1505, 604),
(3, 899, 315),(3, 742, 554),(3, 1744, 917),(3, 1163, 423),
(3, 1501, 948),(3, 736, 451),(3, 537, 434);

select c.name,
	SUM(e.emails_sent) AS total_emails_sent,
	SUM(e.emails_opened) AS total_emails_opened,
	ROUND(SUM(e.emails_opened)*1.0/SUM(e.emails_sent)*100,2) AS open_rate
	from campaign c
	JOIN email_stat e ON c.id=e.campaign_id
	GROUP BY c.name
	HAVING (SUM(e.emails_opened)*1.0/SUM(e.emails_sent)*100)>50
	ORDER BY open_rate DESC,c.name;

-- question 37
CREATE TABLE bonds (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE maturities (
    bond_id INT,
    maturity DATE,
    FOREIGN KEY (bond_id) REFERENCES bonds(id)
);
INSERT INTO bonds (id, name) VALUES
(1, 'Alpha Mortgage Bond'),
(2, 'Beta Mortgage Bond'),
(3, 'Gamma Mortgage Bond');
INSERT INTO maturities (bond_id, maturity) VALUES
(1, '2024-01-26'),(1, '2024-02-22'),(1, '2024-03-26'),
(1, '2024-05-13'),(1, '2024-07-06'),(1, '2024-08-23'),
(1, '2024-09-06'),(1, '2024-11-30'),(1, '2024-12-30'),
(1, '2025-04-30'),(1, '2025-05-03'),(2, '2024-07-25'),
(2, '2024-12-07'),(3, '2023-12-16'),(3, '2024-01-25'),
(3, '2024-01-26'),(3, '2024-05-04'),(3, '2024-10-02'),
(3, '2024-12-14'),(3, '2025-01-15');
select b.name,
	COUNT(*) AS maturity_dates,
	MIN(m.maturity) AS earliest_maturity,
	MAX(m.maturity) AS latest_maturity,
	CEIL(AVG(m.maturity - DATE '2023-09-13')) AS avg_days_to_maturity
	from bonds b
	JOIN maturities m ON b.id=m.bond_id
	GROUP BY b.name
	HAVING CEIL(AVG(m.maturity - DATE '2023-09-13'))>365
	ORDER BY b.name;

-- question 38
CREATE TABLE bond(
    id INT PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE interest_rates (
    bond_id INT,
    rate DECIMAL(2,1),
    FOREIGN KEY (bond_id) REFERENCES bond(id)
);
INSERT INTO bond (id, name) VALUES
(1, 'Alpha Mortgage Bond'),
(2, 'Beta Mortgage Bond'),
(3, 'Gamma Mortgage Bond');
INSERT INTO interest_rates (bond_id, rate) VALUES
(1, 1.4),(1, 1.8),(1, 2.0),(1, 2.4),(1, 3.4),
(1, 4.6),(1, 4.7),(1, 4.9),(2, 2.0),(2, 2.1),
(2, 3.0),(2, 3.2),(2, 4.0),(3, 1.2),(3, 1.3),
(3, 1.4),(3, 2.1),(3, 2.5),(3, 3.5),(3, 4.0);

select b.name,
	COUNT(*) AS interest_rate,
	MIN(i.rate) AS lowest_rate,
	MAX(i.rate) AS highest_rate,
	ROUND(AVG(i.rate),2) AS avg_rate
	from bond b
	JOIN interest_rates i ON b.id=i.bond_id
	GROUP BY b.name
	HAVING AVG(i.rate)>3
	ORDER BY b.name;

-- question 39
CREATE TABLE bondholders (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE bonds0 (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    annual_coupon DECIMAL(5,2),
    coupons_remaining INT
);
CREATE TABLE bondholders_bonds (
    bondholder_id INT,
    bond_id INT,
    FOREIGN KEY (bondholder_id) REFERENCES bondholders(id),
    FOREIGN KEY (bond_id) REFERENCES bonds0(id)
);
INSERT INTO bondholders (id, name) VALUES
(1, 'Alex Smith'),
(2, 'Taylor Johnson'),
(3, 'Jordan Davis');
INSERT INTO bonds0 (id, name, annual_coupon, coupons_remaining) VALUES
(1, 'Golden Bonds', 150.00, 4),
(2, 'Silver Lining', 200.00, 2),
(3, 'Diamond Trust', 100.00, 4),
(4, 'Emerald Wealth', 350.00, 5),
(5, 'Ruby Returns', 150.00, 8),
(6, 'Sapphire Security', 450.00, 3),
(7, 'Amber Assurance', 100.00, 8),
(8, 'Topaz Treasury', 100.00, 2),
(9, 'Opal Opportunities', 150.00, 5),
(10, 'Pearl Prosperity', 450.00, 5),
(11, 'Platinum Promise', 450.00, 9),
(12, 'Jade Investments', 350.00, 1),
(13, 'Garnet Growth', 150.00, 4),
(14, 'Onyx Returns', 350.00, 2),
(15, 'Quartz Capital', 100.00, 2),
(16, 'Citrine Securities', 250.00, NULL),
(17, 'Aquamarine Assets', 250.00, 2),
(18, 'Peridot Portfolio', 300.00, 8),
(19, 'Tourmaline Trust', 100.00, 6),
(20, 'Moonstone Money', 150.00, 9);
INSERT INTO bondholders_bonds (bondholder_id, bond_id) VALUES
(1, 1),(1, 2),(1, 6),(1, 8),(1, 9),(1, 13),(1, 14),(1, 16),
(1, 17),(2, 4),(2, 5),(2, 7),(2, 11),(2, 15),(2, 18),(3, 3),
(3, 10),(3, 12),(3, 19),(3, 20);

select bh.name,
	SUM(b.annual_coupon*b.coupons_remaining) AS total_cash_flow
	from bondholders bh
	JOIN bondholders_bonds bb ON bb.bondholder_id=bh.id
	JOIN bonds0 b ON b.id=bb.bond_id
	GROUP BY bh.name
	HAVING SUM(b.annual_coupon*b.coupons_remaining)>10000
	ORDER BY total_cash_flow DESC;

-- question 40
CREATE TABLE investors1 (
    id INT PRIMARY KEY,
    email VARCHAR(255) UNIQUE
);
CREATE TABLE cash_flows1 (
    investor_id INT,
    cash_flow DECIMAL(8,2),
    FOREIGN KEY (investor_id) REFERENCES investors1(id)
);
INSERT INTO investors1 (id, email) VALUES
(1, 'ematson0@ebay.co.uk'),
(2, 'lsalvadore1@msn.com'),
(3, 'aclowser2@patch.com');
INSERT INTO cash_flows1 (investor_id, cash_flow) VALUES
(1, 184040.12),(1, 179280.08),(1, 179374.42),
(1, 79302.21),(1, 87466.20),(1, 194588.36),
(1, 153563.92),(1, 56377.92),(2, 59039.14),
(2, 167247.23),(2, 59311.03),(2, 183883.00),(2, 118851.21),
(3, 58868.62),(3, 96909.26),(3, 103735.73),
(3, 171261.97),(3, 86463.11),(3, 56931.73),
(3, 194699.58);
	
select i.email,
	COUNT(*) AS investments,
	MIN(c.cash_flow) AS min_cash_flow,
	MAX(c.cash_flow) AS max_cash_flow,
	ROUND(AVG(c.cash_flow),2) AS avg_cash_flow
	from investors i
	JOIN cash_flows c ON i.id=c.investor_id
	GROUP BY i.email
	HAVING SUM(c.cash_flow)>1000000
	ORDER BY i.email;

-- question 41
CREATE TABLE investor (
    id INT PRIMARY KEY,
    email VARCHAR(255) UNIQUE
);
CREATE TABLE cash_flow (
    investor_id INT,
    expected_flow DECIMAL(8,2),
    FOREIGN KEY (investor_id) REFERENCES investor(id)
);
INSERT INTO investor (id, email) VALUES
(1, 'tdowner0@timesonline.co.uk'),
(2, 'cgarza1@opera.com'),
(3, 'nbarwise2@si.edu');
INSERT INTO cash_flow (investor_id, expected_flow) VALUES
(1, 24923.83),(1, 30212.10),(1, 87126.50),(1, 56018.65),
(1, 93357.47),(1, 55073.54),(1, 27095.07),(2, 44165.12),
(2, 43658.84),(2, 35835.34),(2, 12660.46),(2, 58676.60),
(2, 95929.25),(2, 47161.23),(2, 80283.91),(2, 54427.20),
(2, 93223.98),(3, 19741.35),(3,12243.25),(3,50470.06);

select i.email,
	COUNT(*) AS investment_count,
	SUM(c.expected_flow) AS total_expected_flow,
	ROUND(MAX(c.expected_flow)-MIN(c.expected_flow),2) AS range_expected_flow
	from investor i
	JOIN cash_flow c ON i.id=c.investor_id
	GROUP BY i.email
	HAVING SUM(c.expected_flow)>100000
	ORDER BY i.email;

-- question 42
CREATE TABLE coupons (
    id INT PRIMARY KEY,
    coupon_code VARCHAR(255) UNIQUE,
    description VARCHAR(255),
    is_enabled SMALLINT
);
CREATE TABLE coupon_uses (
    coupon_id INT,
    amount DECIMAL(4,2),
    FOREIGN KEY (coupon_id) REFERENCES coupons(id)
);
INSERT INTO coupons (id, coupon_code, description, is_enabled) VALUES
(1, 'COUPON123', 'nisi nam ultrices libero non', 0),
(2, 'SAVE20', 'ac est lacinia', 1),
(3, 'DISCOUNT50', 'quis odio consequat', 1);
INSERT INTO coupon_uses (coupon_id, amount) VALUES
(1, 36.68),(1, 3.56),(1, 2.10),(1, 39.58),
(2, 39.81),(2, 24.07),(2, 28.42),(2, 31.03),
(2, 3.24),(2, 36.33),(3, 8.89),(3, 30.44),
(3, 36.94),(3, 42.65),(3, 33.61),(3, 41.92),
(3, 1.78),(3, 20.26),(3, 27.92),(3, 0.23);

select c.coupon_code,
	c.description,
	COUNT(*) AS total_uses,
	MIN(cu.amount) AS min_discount,
	MAX(cu.amount) AS max_discount,
	ROUND(AVG(cu.amount),2) AS avg_discount
	from coupons c
	JOIN coupon_uses cu ON c.id=cu.coupon_id
	WHERE c.is_enabled=1
	GROUP BY c.coupon_code,c.description
	ORDER BY c.coupon_code;

--question 43
CREATE TABLE professions (
    id INT PRIMARY KEY,
    title VARCHAR(255) UNIQUE
);
CREATE TABLE freelancers (
    id INT PRIMARY KEY,
    profession_id INT,
    email VARCHAR(255) UNIQUE,
    FOREIGN KEY (profession_id) REFERENCES professions(id)
);
-- Step 1: Create the ENUM type
CREATE TYPE project_status AS ENUM ('Completed', 'Ongoing', 'Cancelled');

-- Step 2: Create the table using the ENUM type
CREATE TABLE project1 (
    id INT PRIMARY KEY,
    freelancer_id INT,
    status project_status,
    income DECIMAL(6,2),
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(id)
);
INSERT INTO professions (id, title) VALUES
(1, 'Artificial Intelligence Engineer'),
(2, 'Network Administrator'),
(3, 'Game Developer');
INSERT INTO freelancers (id, profession_id, email) VALUES
(1, 1, 'lfernezo@microsoft.com'),
(3, 2, 'mbrydone2@delicious.com'),
(4, 2, 'jhamp3@4shared.com'),
(5, 3, 'cparfett4@twitter.com');
INSERT INTO project1 (id, freelancer_id, status, income) VALUES
(5, 1, 'Completed', 8562.13),
(11, 1, 'Completed', 6727.56),
(10, 3, 'Completed', 3753.46),
(20, 3, 'Completed', 6659.39),
(6, 4, 'Completed', 8459.28),
(13, 4, 'Completed', 5899.31),
(16, 4, 'Completed', 2709.63), 
(4, 5, 'Completed', 5029.44),
(7, 5, 'Completed', 1763.94),
(9, 5, 'Completed', 6988.36),
(8, 3, 'Cancelled', 8699.67),
(1, 5, 'Cancelled', 5403.21),
(19, 3, 'Ongoing', 72.51),
(3, 4, 'Ongoing', 8561.14),
(15, 4, 'Ongoing', 9235.78),
(17, 4, 'Ongoing', 4307.76);

select p.title,
	COUNT(*) AS total_projects,
	SUM(proj.income) AS total_income,
	COUNT(DISTINCT f.id) AS total_freelancers,
	ROUND(AVG(proj.income),2) AS avg_income_per_freelancer
	from professions p
	JOIN freelancers f ON p.id=f.profession_id
	JOIN project1 proj ON f.id=proj.freelancer_id
	WHERE proj.status='Completed'
	GROUP BY p.title
	ORDER BY total_income DESC;

-- question 44
CREATE TABLE categories1 (
    id INT PRIMARY KEY,
    title VARCHAR(255) 
);
CREATE TABLE product12 (
    id INT PRIMARY KEY,
    category_id INT,
    title VARCHAR(255),
    sku VARCHAR(255) UNIQUE,
    stock_number INT,
    FOREIGN KEY (category_id) REFERENCES categories1(id)
);
INSERT INTO categories1 (id, title) VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Home & Kitchen');
INSERT INTO product12 (id, category_id, title, sku, stock_number) VALUES
(11, 1, 'Elegant Gadget', 'EG-11', 4),
(3, 1, 'Luxury Gizmo', 'LG-3', 10),
(19, 1, 'Sleek Widget', 'SW-19', 8),
(8, 1, 'Sleek Widget', 'SW8', 8),
(14, 2, 'Elegant Gadget', 'EG14', 2),
(16, 2, 'Elegant Gadget', 'EG16', 6),
(10, 2, 'Elegant Gadget', 'EG10', 10),
(7, 2, 'Luxury Gizmo', 'LG7', 3),
(2, 2, 'Luxury Gizmo', 'LG2', 8),
(18, 2, 'Luxury Gizmo', 'LG18', 9),
(1, 2, 'Sleek Widget', 'SW12', 3),
(6, 2, 'Sleek Widget', 'SW6', 7),
(20, 3, 'Elegant Gadget', 'EG-20', 10),
(9, 3, 'Luxury Gizmo', 'LG-9', 4),
(12, 3, 'Luxury Gizmo', 'LG-12', 5),
(13, 3, 'Luxury Gizmo', 'LG-13', 5),
(5, 3, 'Luxury Gizmo', 'LG-5', 9),
(4, 3, 'Sleek Widget', 'SW-4', 8),
(15, 3, 'Sleek Widget', 'SW-15', 9),
(17, 3, 'Sleek Widget', 'SW-17', 9);

select c.title AS category,
	p.title AS title,
	SUM(p.stock_number) AS total_stock
	from categories1 c
	JOIN product12 p ON c.id=p.category_id
	GROUP BY c.title,p.title
	HAVING SUM(p.stock_number)>10
	ORDER BY category,title,total_stock DESC;

-- question 45
CREATE TABLE threat_types (
    id INT PRIMARY KEY,
    threat_type VARCHAR(255) -- Type of threat (e.g., Malware, Phishing)
);

-- Step 1: Create the ENUM type
CREATE TYPE quarantine_status AS ENUM ('Quarantined', 'Safe', 'Deleted');

-- Step 2: Create the table using the ENUM type
CREATE TABLE quarantine_urls (
    id INT PRIMARY KEY,
    threat_id INT,
    domain_name VARCHAR(255),
    status quarantine_status,
    users_affected INT,
    FOREIGN KEY (threat_id) REFERENCES threat_types(id)
);
INSERT INTO threat_types (id, threat_type) VALUES
(1, 'Phishing'),
(2, 'Rootkit'),
(3, 'Malware');
INSERT INTO quarantine_urls (id, threat_id, domain_name, status, users_affected) VALUES
(17, 1, 'amazon.com', 'Quarantined', 862),
(16, 1, 'google.com', 'Quarantined', 63),
(9, 1, 'amazon.com', 'Quarantined', 41),
(18, 2, 'amazon.com', 'Quarantined', 149),
(12, 2, 'yahoo.com', 'Quarantined', 967),
(4, 3, 'amazon.com', 'Quarantined', 377),
(10, 3, 'yahoo.com', 'Quarantined', 721),
(11, 1, 'yahoo.com', 'Deleted', 551),
    (20, 1, 'amazon.com', 'Safe', 407),
    (19, 1, 'amazon.com', 'Deleted', 665),
(15, 1, 'facebook.com', 'Safe', 52),
(2, 1, 'google.com', 'Safe', 309),
(1, 2, 'twitter.com', 'Safe', 562),
(13, 2, 'facebook.com', 'Safe', 208),
(14, 2, 'google.com', 'Deleted', 731),
(8, 2, 'twitter.com', 'Safe', 924),
(7, 2, 'twitter.com', 'Safe', 982),
    (6, 2, 'google.com', 'Deleted', 864),
    (3, 2, 'facebook.com', 'Safe', 136),
    (5, 3, 'yahoo.com', 'Safe', 949);

select q.domain_name,
	t.threat_type,
	COUNT(*) AS total_occurences,
	SUM(q.users_affected) AS total_users_affected
	from threat_types t
	JOIN quarantine_urls q ON t.id=q.threat_id
	WHERE q.status='Quarantined'
	GROUP BY q.domain_name,t.threat_type
	ORDER BY total_users_affected DESC,domain_name;

-- question 46
CREATE TABLE client0 (
    id INT PRIMARY KEY,
    mac_address VARCHAR(255)
);
CREATE TYPE stream_qualitys AS ENUM ('240p','360p','480p','720p','1080p','1440p','2160p');
CREATE TABLE stream (
    client_id INT,
    title VARCHAR(255),
    quality stream_qualitys,
    traffic INT,
    FOREIGN KEY (client_id) REFERENCES client0(id)
);
INSERT INTO client0 (id, mac_address) VALUES
(1, '2F-80-8E-F2-0E-4C'),
(2, 'A1-F7-D4-48-B9-E6'),
(3, '9F-72-DB-7C-73-FC');
INSERT INTO stream (client_id, title, quality, traffic) VALUES
(1, 'Monte Carlo', '360p', 71928308),
(1, 'Separation, The Sparation Lab', '480p', 35221785),
(1, 'Felidae', '480p', 54617023),
(1, 'Dirty Dancing', '1440p', 56419563),
(1, 'Ragtime', '1440p', 12404457),
(1, 'Oscar', '1440p', 49717246),
(1, 'Barb Wire', '2160p', 83761463),
(1, 'Jason and the Argonauts', '2160p', 27364051),
(2, 'Carry on Cruising', '240p', 33226462),
(2, 'Best of the Best', '240p', 62793858),
(2, 'Ecstasy (xtasis)', '240p', 73079415),
(2, 'Go Go Tales', '480p', 48836837),
(2, 'Nights and Weekends', '1440p', 32708277),
(3, 'Coneheads', '480p', 92308213),
(3, 'Silences of the Palace, The (Saint el Qusur)', '480p', 52917945),
(3, 'Good Pick', '720p', 71890218),
(3, 'Wuthering Heights', '720p', 19813053),
(3, 'Big Kahuna, The', '1080p', 28786846),
(3, 'Work of Director Michel Gondry, The', '2160p', 18789351),
(3, 'My Best Friends', '2160p', 44347338);

select c.mac_address,
	COUNT(*) AS streams,
	SUM(s.traffic) AS total_traffic
	from client0 c
	JOIN stream s ON c.id=s.client_id
	WHERE s.quality>='720p'
	GROUP BY c.mac_address
	ORDER BY total_traffic DESC;

-- question 47
CREATE TABLE networks (
    id INT PRIMARY KEY,
    cidr VARCHAR(255) -- IP Address v4 CIDR
);
CREATE TABLE instances (
    network_id INT,
    cpu_usage VARCHAR(255),
    memory_usage VARCHAR(255),
    network_usage VARCHAR(255),
    FOREIGN KEY (network_id) REFERENCES networks(id)
);
INSERT INTO networks (id, cidr) VALUES
(1, '24.77.36.156/9'),
(2, '74.213.138.70/7'),
(3, '167.244.163.58/29');
INSERT INTO instances (network_id, cpu_usage, memory_usage, network_usage)
VALUES
    (1, '20%', '74%', '74%'),(3, '26%', '9%', '99%'),
    (3, '2%', '21%', '97%'),(1, '51%', '19%', '89%'),
    (2, '2%', '27%', '79%'),(3, '92%', '35%', '41%'),
    (2, '27%', '5%', '44%'),(3, '67%', '47%', '79%'),
    (1, '14%', '28%', '43%'),(3, '47%', '0%', '53%'),
    (1, '38%', '3%', '46%'),(2, '71%', '51%', '6%'),
    (3, '77%', '74%', '53%'),(3, '31%', '48%', '80%'),
    (2, '31%', '42%', '24%'),(1, '77%', '65%', '46%'),
    (2, '51%', '94%', '41%'),(3, '8%', '3%', '57%'),
    (1, '1%', '56%', '62%'),(2, '15%', '66%', '65%');

select n.cidr,
	COUNT(*) AS instances,
	CONCAT(CEIL(AVG(CAST(REPLACE(i.cpu_usage,'%','') AS float))),'%') AS avg_cpu_usage,
	CONCAT(CEIL(AVG(CAST(REPLACE(i.memory_usage,'%','') AS float))),'%') AS avg_memory_usage,
	CONCAT(CEIL(AVG(CAST(REPLACE(i.network_usage,'%','') AS float))),'%') AS avg_network_usage
	from networks n
	JOIN instances i ON n.id=i.network_id
	WHERE n.id IN(
	select DISTINCT network_id from instances WHERE
	CAST(REPLACE(cpu_usage,'%','') AS float)>=80
	)
GROUP BY n.cidr
ORDER BY n.cidr;


--question 48
CREATE TABLE tasks (
    id INT PRIMARY KEY,
    hash VARCHAR(255)
);
CREATE TABLE processes (
    task_id INT,
    start_dt VARCHAR(19),
    end_dt VARCHAR(19),
    FOREIGN KEY (task_id) REFERENCES tasks(id)
);
INSERT INTO tasks (id, hash) VALUES
(1, '208f95e0fcff792f617ade3cebf33ad9'),
(2, '0f44a9ffead2f18a7f25425c1260fc74'),
(3, 'dbcf54e94395c32e01ec09a5db731912');
INSERT INTO processes (task_id, start_dt, end_dt) VALUES
(1, '2023-04-20 02:01:16', '2023-04-20 02:11:35'),
(1, '2023-04-09 15:11:10', '2023-04-09 15:26:43'),
(1, '2023-04-07 23:41:49', '2023-04-08 00:34:10'),
(2, '2023-04-07 23:05:47', '2023-04-08 00:00:05'),
(2, '2023-04-19 18:39:33', '2023-04-19 18:54:57'),
 (2, '2023-04-28 13:17:11', '2023-04-28 13:24:37'),
    (2, '2023-04-16 00:13:06', '2023-04-16 01:02:39'),
    (2, '2023-04-16 15:02:26', '2023-04-16 15:58:14'),
    (2, '2023-04-27 02:23:07', '2023-04-27 02:59:13'),
    (2, '2023-04-10 23:33:47', '2023-04-11 00:09:35'),
    (2, '2023-04-16 17:29:51', '2023-04-16 18:10:22'),
(2, '2023-04-23 12:16:01', '2023-04-23 12:48:07'),
    (3, '2023-04-01 02:25:12', '2023-04-01 02:49:26'),
    (3, '2023-04-04 03:02:43', '2023-04-04 03:42:03'),
    (3, '2023-04-10 22:42:26', '2023-04-10 23:14:42'),
    (3, '2023-04-09 17:46:12', '2023-04-09 18:10:19'),
    (3, '2023-04-25 15:09:36', '2023-04-25 15:19:54'),
(3, '2023-04-19 14:39:52', '2023-04-19 15:21:23'),
    (3, '2023-04-12 04:22:29', '2023-04-12 04:25:10'),
    (3, '2023-04-25 07:40:26', '2023-04-25 08:01:30');
	
select t.hash,
	FLOOR(SUM(extract(epoch from(p.end_dt::Timestamp-p.start_dt::timestamp)))) AS usage_time
	from tasks t
	JOIN processes p ON t.id=p.task_id
	GROUP BY t.hash
	ORDER BY usage_time DESC;

-- question 49
CREATE TABLE device0 (
    id INT PRIMARY KEY,     -- Device ID
    score INT               -- Score
);
INSERT INTO device0 (id, score) VALUES
(1, 20),(2, 50),(3, 50),(4, 68),(5, 95);

select CONCAT('Device ',id,' has class: ',
	CASE WHEN score>=80 THEN 'A'
	WHEN score>=60 AND score<80 THEN 'B'
	WHEN score>=40 AND score<60 THEN 'C'
	WHEN score>=20 AND score<40 THEN 'D'
	ELSE 'F' END) AS device
from device0;

-- question 50
CREATE TABLE accounts11 (
    id INT PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255)
);
-- Step 1: Create the ENUM type
CREATE TYPE tariff_name AS ENUM ('A', 'B', 'C', 'D', 'E');

-- Step 2: Create the table using the ENUM type
CREATE TABLE tariffs (
    id INT PRIMARY KEY,
    name tariff_name,
    cost DECIMAL(4,3)
);
CREATE TABLE readings (
    account_id INT,
    tariff_id INT,
    amount SMALLINT,
    FOREIGN KEY (account_id) REFERENCES accounts11(id),
    FOREIGN KEY (tariff_id) REFERENCES tariffs(id)
);
INSERT INTO accounts11 (id, username, email) VALUES
(1, 'hshillabeare0', 'rcalkin0@sourceforge.net'),
(2, 'sdandy1', 'agaule1@businessweek.com'),
(3, 'sgreiswood2', 'toppy2@lulu.com');
INSERT INTO tariffs (id, name, cost) VALUES
(1, 'A', 0.010),
(2, 'B', 0.020),
(3, 'C', 0.050),
(4,'D',0.075),
(5,'E',0.100);

INSERT INTO readings (account_id, tariff_id, amount) VALUES
(1, 2, 54),(1, 3, 19),(1, 3, 37),(1, 3, 89),(1, 3, 119),
(2, 1, 12),(2, 1, 44),(2, 1, 81),(2, 2, 60),(2, 2, 164),
(2, 2, 199),(2, 3, 79),(2, 5, 186),(3, 1, 31),(3, 1, 59),
(3, 1, 77),(3, 1, 95),(3, 1, 110),(3, 1, 125),
(3, 2, 31);

select a.username,
	a.email,
	MAX(t.name) AS highest_tariff,
	SUM(r.amount) AS consumption,
	ROUND(SUM(t.cost*r.amount),2) AS total_cost
	from accounts11 a
	JOIN readings r ON a.id=r.account_id
	JOIN tariffs t ON t.id=r.tariff_id
	GROUP BY a.username,a.email 
	ORDER BY a.username;

-- question 51
CREATE TABLE acc (
    id INT PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255)
);
CREATE TYPE item_type AS ENUM ('sword', 'shield', 'armor');

CREATE TABLE item (
    id INT PRIMARY KEY,
    type item_type,
    name VARCHAR(255),
    weight SMALLINT
);

CREATE TABLE accounts_items (
    account_id INT,
    item_id INT,
    FOREIGN KEY (account_id) REFERENCES acc(id),
    FOREIGN KEY (item_id) REFERENCES item(id)
);
INSERT INTO acc (id, username, email) VALUES
(1, 'esoane0', 'alefwicho@nytimes.com'),
(2, 'jrafter1', 'bmcniff1@census.gov'),
(3, 'rcawston2', 'fnickoll2@flickr.com');
INSERT INTO item (id, type, name, weight) VALUES
(1, 'shield', 'Shield of Asteraceae', 3),
(2, 'sword', 'Sword of Cyperaceae', 3),
(3, 'shield', 'Shield of Apiaceae', 3),
(4, 'sword', 'Sword of Onagraceae', 3),
(5, 'sword', 'Sword of Campanulaceae', 3);
INSERT INTO accounts_items (account_id, item_id) VALUES
(1, 2),
(1, 3),
(1, 3),
(1,4),
(1,4),
(1,5),
(1,5),
(1,5),
(2,1),
(2,1),
(2,2),
(2,2),
(2,2),
(2,2),
(2,2),
(2,3),
(2,3),
(2,5),
(3,3),
(3,4);
select a.username,
	a.email,
	COUNT(*) AS items,
	SUM(i.weight) AS total_weight
	from acc a 
	JOIN accounts_items ai ON a.id=ai.account_id
	JOIN item i ON i.id=ai.item_id
	GROUP BY a.username,a.email
	HAVING SUM(i.weight)>20
	ORDER BY total_weight DESC,a.username;

-- question 52
CREATE TABLE cities (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE banners (
    city_id INT,
    width SMALLINT,
    height SMALLINT,
    FOREIGN KEY (city_id) REFERENCES cities(id)
);
INSERT INTO cities (id, name) VALUES
(1, 'Kayu Agung'),
(2, 'Yangkou'),
(3, 'Marseille');
INSERT INTO banners (city_id, width, height) VALUES
(3, 6, 20),
(1, 20, 14),
(1, 6, 17),
(1, 15, 6),
(2, 16, 8),
(2, 6, 7),
(3,6,9),
(1, 20, 16),
(3, 19, 14),
(2, 9, 17),
(2, 8, 12),
(1, 12, 16),
(3, 15, 14),
(3, 11, 7),
(3, 6, 14),
(2, 12, 7),
(3, 7, 20),
(1, 13, 6),
(3, 10, 13),
(2, 19, 15);
select c.name,
	COUNT(*) AS banners,
	MIN(b.width*b.height) AS min_area,
	CEIL(AVG(b.width*b.height)) AS avg_area,
	MAX(b.width*b.height) AS max_area,
	SUM(b.width*b.height) AS total_area
	from cities c
	JOIN banners b ON c.id=b.city_id
	GROUP BY c.name
	ORDER BY c.name;

-- question 53
CREATE TABLE lot (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE offer (
    lot_id INT,
    amount DECIMAL(6,2),
    FOREIGN KEY (lot_id) REFERENCES lot(id)
);
INSERT INTO lot (id, name) VALUES
(1, 'Merremia quinquefolia (L.) Hallier f.'),
(2, 'Plantago maritima L.'),
(3, 'Hohenbergia antillana Mez'),
(4, 'Penstemon eriantherus Pursh var. argillosus M.E. Jones');
INSERT INTO offer (lot_id, amount) VALUES
(1, 510.51),
(2, 703.80),
(2, 181.80),
(1, 38.06),
(2, 368.78),
(3, 91.40),
(2, 413.80),
(3, 157.99),
(3, 885.82),
(2, 863.99),
(1, 307.61),
(2, 120.39),
(1, 771.96),
(2, 801.42),
(3, 871.59),
(1, 541.61),
(3, 477.62),
(2, 303.29),
(2, 612.83),
(3, 464.98);
select l.name,
	COUNT(o.lot_id) AS offers,
	MIN(o.amount) AS min_offer,
	ROUND(AVG(o.amount),2) AS avg_offer,
	MAX(o.amount) AS max_offer
	from lot l
	LEFT JOIN offer o ON l.id=o.lot_id
	GROUP BY l.name
	ORDER BY offers DESC;

	
-- question 54
CREATE TABLE accounts7 (
    id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    iban VARCHAR(255)
);
CREATE TABLE declarations (
    account_id INT,
    quarter VARCHAR(2),
    income DECIMAL(7,2),
    FOREIGN KEY (account_id) REFERENCES accounts7(id),
    CHECK (quarter IN ('Q1', 'Q2', 'Q3', 'Q4'))
);
INSERT INTO accounts7 (id, first_name, last_name, iban) VALUES
(1, 'Alex', 'Cantua', 'IL29 9590 1551 0560 0553 712'),
(2, 'Chris', 'Lashmore', 'AZ54 CNUI 01DR XEXZ ASKY QM4W F8JI'),
(3, 'Taylor', 'Blum', 'HR20 2041 7741 5014 9873 9'),
(4, 'Robin', 'Neachell', 'NL87 PPCD 0429 1849 92'),
(5, 'Drew', 'Barbier', 'FR72-7843-3990-42WM-QC8P-GVNV-F78');
INSERT INTO declarations (account_id, quarter, income) VALUES
(1, 'Q1', 49235.67),(1, 'Q2', 46653.11),(1, 'Q3', 63739.99),
(1, 'Q4', 43222.54),(2, 'Q1', 69743.50),(2, 'Q2', 29641.01),
(2, 'Q3', 97725.49),(2, 'Q4', 91481.98),(3, 'Q1', 68402.43),
(3, 'Q2', 12660.12),(3, 'Q3', 59601.65),(3, 'Q4', 54701.74),
(4, 'Q1', 55220.27),(4, 'Q2', 87752.41),(4, 'Q3', 44447.06),
(4, 'Q4', 45876.26),(5, 'Q1', 42511.74),(5, 'Q2', 22022.78),
(5, 'Q3', 88396.81),(5, 'Q4', 67252.54);

select 
	CONCAT(a.last_name,'',a.last_name) AS full_name,
	a.iban,
	SUM(d.income),
	'10%' AS rate,
	ROUND(SUM(d.income)*0.1,2) AS tax
	from accounts7 a
	JOIN declarations d ON a.id=d.account_id
	GROUP BY a.last_name,a.first_name,a.iban
	ORDER BY full_name;

-- question 55
CREATE TABLE profiles (
    id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255)
);
CREATE TABLE relations (
    profile_id INT,
    related_to VARCHAR(255),
    is_approved BOOLEAN,
    FOREIGN KEY (profile_id) REFERENCES profiles(id)
);
INSERT INTO profiles (id, first_name, last_name, email) VALUES
(1, 'Shayne', 'Shilito', 'sshilito0@ftc.gov'),
(2, 'Shell', 'Shade', 'sshade1@paginegialle.it'),
(3, 'Nobie', 'Splain', 'nsplain2@npr.org');
INSERT INTO relations (profile_id, related_to, is_approved) VALUES
(1, 'cbasinigazzii', TRUE),
(1, 'ldevered', TRUE),
(1, 'edeniskeb', TRUE),
(1, 'cstirland4', TRUE),
(1, 'ngooddiea', TRUE),
(1, 'alockney7', TRUE),
(1, 'jsorrillj', FALSE),
(1, 'bnodin3', FALSE),
(1, 'dwall2', FALSE),
(1, 'folivas', FALSE),
(2, 'ksharland6', FALSE),
(2, 'pbarosch8', FALSE),
(2, 'smacieja9', FALSE),
(2, 'bbrasonf', FALSE),
(2, 'dabrahartg', FALSE),
(3, 'gaymer5', TRUE),
(3, 'rwoolcockse', TRUE),
(3, 'egilyott0', TRUE),
(3, 'agillonc', FALSE),
(3, 'foribbinh', FALSE);

select 
	CONCAT(p.last_name,'',p.first_name) AS full_name,
	p.email,
	COUNT(*) AS total_relations,
	COUNT(CASE WHEN r.is_approved='true' then 'approved' END) AS approved_relations,
	COUNT(CASE WHEN r.is_approved='false' then 'pending' END) AS pending_relations
	from profiles p
	JOIN relations r ON p.id=r.profile_id
	GROUP BY p.last_name,p.first_name,p.email
	ORDER BY full_name;

-- question 56
CREATE TABLE accounts12(
    id INT PRIMARY KEY,
    iban VARCHAR(255)
);
CREATE TABLE trans (
    account_id INT,
    dt TIMESTAMP,
    amount DECIMAL(5,2),
    FOREIGN KEY (account_id) REFERENCES accounts12(id)
);
INSERT INTO accounts12 (id, iban) VALUES
(1, 'SE48 2961 2087 8112 2835 6438'),
(2, 'BE89 2286 5514 4847'),
(3, 'MU84 HRGV 2047 2584 5774 3195 [856] PZ');
INSERT INTO trans (account_id, dt, amount) VALUES
(2, '2022-09-25 19:24:50', 75.06),
(2, '2022-09-24 03:09:17', 41.10),
(1, '2022-09-19 04:13:17', 65.85),
(3, '2022-09-30 07:18:29', 44.57),
(1, '2022-09-26 01:51:44', 98.93),
(1, '2022-08-28 02:51:04', 60.42),
(1, '2022-08-25 23:25:54', 45.34),
(2, '2022-09-09 11:00:48', 11.05),
(3, '2022-08-25 19:37:02', 53.61),
(2, '2022-09-23 09:44:05', 89.18),
(1, '2022-08-28 19:48:40', 47.60),
(3, '2022-09-12 10:28:10', 96.40),
(3, '2022-10-03 16:49:51', 45.41),
(2, '2022-09-05 16:20:41', 46.78),
(3, '2022-10-03 04:51:29', 50.81),
(1, '2022-09-10 17:31:44', 78.72),
(2, '2022-08-31 21:59:56', 61.09),
(2, '2022-09-14 12:52:13', 20.36),
(1, '2022-09-28 11:05:21', 70.52),
(3, '2022-09-30 09:21:12', 48.00);

select a.iban,
	COUNT(*) AS total_transactions,
	SUM(t.amount) AS total
	from accounts12 a
	JOIN trans t ON a.id=t.account_id
	WHERE TO_CHAR(t.dt::date,'Month')='September'
	GROUP BY a.iban
	ORDER BY total DESC;

-- question 57
CREATE TABLE clients1(
    id SMALLINT PRIMARY KEY,
    mac VARCHAR(17),
    tariff DECIMAL(6,5)
);
CREATE TABLE traffic (
    client_id SMALLINT,
    dt VARCHAR(19),
    amount INT,
    FOREIGN KEY (client_id) REFERENCES clients1(id)
);
INSERT INTO clients1 (id, mac, tariff) VALUES
(1, 'A2-53-FC-0C-3E-B4', 0.00007),
(2, 'DC-80-42-E9-AE-FC', 0.00003),
(3, '3F-9B-A9-2A-B1-7B', 0.00007),
(4, 'D4-6F-E4-AF-47-D5', 0.00004),
(5, 'B9-65-FC-8E-F0-15', 0.00007);
INSERT INTO traffic (client_id, dt, amount) VALUES
(1, '2022-05-22', 9127),
(1, '2022-06-07', 62203),
(1, '2022-06-10', 88227),
(2, '2022-05-31', 99874),
(2, '2022-06-01', 78400),
(2, '2022-06-03', 61106),
(2, '2022-06-12', 20963),
(2, '2022-06-29', 98304),
(2, '2022-07-04', 6626),
(3, '2022-05-22', 8386),
(3, '2022-06-08', 22959),
(3, '2022-07-05', 52096),
(3, '2022-07-14', 70777),
(4, '2022-05-22', 93743),
(5, '2022-05-16', 84660),
(5, '2022-05-28', 63267),
(5, '2022-06-10', 80681),
(5, '2022-06-21', 55460),
(5, '2022-07-04', 91365),
(5, '2022-07-09', 23296);
select c.mac,
	SUM(t.amount) AS traffic,
	ROUND(SUM(t.amount*c.tariff),2) AS cost
	from clients1 c
	JOIN traffic t ON c.id=t.client_id
	WHERE t.dt LIKE '2022-05-%'
	GROUP BY c.mac
	ORDER BY cost DESC;

-- question 58
CREATE TABLE companies (
    id SMALLINT PRIMARY KEY,
    name VARCHAR(255),
    address VARCHAR(255),
    phone VARCHAR(255)
);
CREATE TABLE categorie (
    company_id SMALLINT,
    name VARCHAR(255),
    review_rating SMALLINT,
    FOREIGN KEY (company_id) REFERENCES companies(id)
);
INSERT INTO companies (id, name, address, phone) VALUES
(1, 'Casper, Oberbrunner and Williamson', '53 Di Loreto Hill', '+420 (569) 566-3689'),
(2, 'Tromp, Kozey and Abbott', '84 Mcguire Plaza', '+62 (145) 722-2330'),
(3, 'Gerlach, Hayes and Stamm', '80 Service Point', '+86 (731) 234-4119'),
(4, 'Wolff-Fadel', 'O6 Fair Oaks Trail', '+7 (894) 233-0976'),
(5, 'Kihn-Cronin', '483 Nobel Road', '+1 (396) 693-1661');
INSERT INTO categorie (company_id, name, review_rating) VALUES
(1, 'HVAC', 2),
(2, 'HVAC', 2),
(2, 'Retaining Wall and Brick Pavers', 1),
(2, 'Rebar & Wire Mesh Install', 2),
(3, 'Prefabricated Aluminum Metal Canopies', 2),
(3, 'Prefabricated Aluminum Metal Canopies', 0),
(3, 'RF Shielding', 2),
(3, 'Overhead Doors', 0),
(3, 'Rebar & Wire Mesh Install', 5),
(3, 'Termite Control', 0),
(4, 'Sitework & Site Utilities', 0),
(4, 'Electrical and Fire Alarm', 2),
(4, 'Masonry', 2),
(4, 'Temp Fencing, Decorative Fencing and Gates', 0),
(4, 'Elevator', 1),
(4, 'Drywall & Acoustical (FED)', 5),
(5, 'Asphalt Paving', 0),
(5, 'Glass & Glazing', 1),
(5, 'Framing (Steel)', 3),
(5, 'Structural & Misc Steel Erection', 1);
select c.name,
	c.address,
	c.phone,
	CONCAT(ROUND(AVG(ca.review_rating),1),' (',COUNT(*),' categories)') AS overall_review_rating
	from companies c
	JOIN categorie ca ON c.id=ca.company_id
	GROUP BY c.name,c.address,c.phone
	ORDER BY AVG(ca.review_rating) DESC,c.name;

-- question 59
CREATE TABLE accounts10 (
    id SMALLINT PRIMARY KEY,
    username VARCHAR(255),
    is_active SMALLINT -- 1 = Active, 0 = Not active
);
CREATE TABLE domains10 (
    account_id SMALLINT, -- foreign key referencing accounts.id
    name VARCHAR(255),
    expiration_date VARCHAR(19),
    FOREIGN KEY (account_id) REFERENCES accounts10(id)
);
INSERT INTO accounts10 (id, username, is_active) VALUES
(1, 'obeedie0', 0),
(2, 'stopham1', 1),
(3, 'ndolder2', 1),
(4, 'jyanshinov3', 1),
(5, 'ewilflinger4', 0);
INSERT INTO domains10 (account_id, name, expiration_date) VALUES
(1, 'imgur.com', '2022-05-14'),
(1, 'domainmarket.com', '2022-07-02'),
(1, 'comsenz.com', '2022-07-28'),
(1, 'gizmodo.com', '2022-08-09'),
(1, 'toplist.cz', '2022-08-15'),
(1, 'scientificamerican.com', '2022-09-03'),
(1, 'examiner.com', '2022-12-18'),
(1, 'photobucket.com', '2023-01-22'),
(2, 'merriam-webster.com', '2022-02-20'),
(2, 'tripod.com', '2022-08-08'),
(3, 'ca.gov', '2022-04-24'),
(3, 'ehow.com', '2022-06-28'),
(3, 'purevolume.com', '2022-07-01'),
(3, 'squidoo.com', '2022-10-27'),
(3, 'eepurl.com', '2022-12-21'),
(4, 'digg.com', '2022-05-14'),
(4, 'jugem.jp', '2022-08-05'),
(4, 'artisteer.net', '2022-10-21'),
(5, 'behance.net', '2022-03-24'),
(5, 'cnn.com', '2022-05-11');

select a.username,
	COUNT(*) AS domains,
	MIN(d.expiration_date) AS nearest_expiration
	from accounts10 a
	JOIN domains10 d ON a.id=d.account_id
	WHERE d.expiration_date::date>Date '2022-07-15' AND is_active=1
	GROUP BY a.username
	ORDER BY a.username;

-- question 60
CREATE TABLE camp (
    id SMALLINT PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE events (
    campaign_id SMALLINT,
    dt VARCHAR(19), -- Event datetime
    value DECIMAL(6,5),
    FOREIGN KEY (campaign_id) REFERENCES camp(id)
);
INSERT INTO camp (id, name) VALUES
(1, '11-080 - Registration Equipment'),
(2, '12-700 - Systems Furniture'),
(3, '9-900 - Paints and Coatings');
INSERT INTO events (campaign_id, dt, value) VALUES
(1, '2022-07-14 13:11:38', 0.59275),
(1, '2022-07-14 14:55:43', 0.12928),
(1, '2022-07-14 18:16:11', 0.82350),
(1, '2022-07-15 01:19:44', 0.97144),
(1, '2022-07-15 22:52:02', 0.60728),
(1, '2022-07-16 08:55:38', 0.71158),
(1, '2022-07-16 10:22:44', 0.29627),
(2, '2022-07-17 02:36:31', 0.42323),
(2, '2022-07-17 04:45:32', 0.91077),
(2, '2022-07-14 07:24:11', 0.35956),
(2, '2022-07-15 06:43:08', 0.16662),
(2, '2022-07-16 08:21:27', 0.02559),
(2, '2022-07-16 11:59:41', 0.34606),
(2, '2022-07-16 23:26:12', 0.62697),
(3, '2022-07-14 00:21:56', 0.97297),
(3, '2022-07-14 10:22:11', 0.93894),
(3, '2022-07-14 12:29:59', 0.44633),
(3, '2022-07-15 01:17:41', 0.37531),
(3, '2022-07-15 14:20:48', 0.24872),
(3, '2022-07-16 23:02:51', 0.80594);

select c.name,
	COUNT(*) AS events,
	ROUND(AVG(e.value),5) AS average_value
	from camp c
	JOIN events e ON c.id=e.campaign_id
	WHERE e.dt::Date= Date'2022-07-15'
	GROUP BY c.name
	HAVING ROUND(AVG(e.value),5)>=0.7
	ORDER BY average_value DESC;

-- question 61
CREATE TABLE profile (
    id SMALLINT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255)
);
CREATE TABLE deals (
    profile_id SMALLINT,
    dt VARCHAR(19), -- Deal datetime
    amount DECIMAL(5,2),
    FOREIGN KEY (profile_id) REFERENCES profile(id)
);
INSERT INTO profile (id, first_name, last_name, email) VALUES
(1, 'Wallis', 'Treadway', 'wtreadwayo@senate.gov'),
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
(4, '2022-07-05 06:05:28', 36.45),
(5, '2022-07-12 07:49:51', 14.76),
(4, '2022-07-12 18:58:11', 91.61),
(5, '2022-07-14 00:50:45', 69.61);

select p.first_name,
	p.last_name,
	p.email,
	SUM(d.amount) AS total
	from profile p
	JOIN deals d ON p.id=d.profile_id
	WHERE d.dt LIKE '2022-06-%'
	GROUP BY p.first_name,p.last_name,p.email
	ORDER BY total DESC
	LIMIT 3;

-- question 62
CREATE TABLE profiles1 (
    id SMALLINT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    is_verified SMALLINT -- 1 = True, 0 = False
);
CREATE TABLE stats (
    profile_id SMALLINT,
    job_success_score SMALLINT,
    FOREIGN KEY (profile_id) REFERENCES profiles1(id)
);
INSERT INTO profiles1(id, first_name, last_name, email, is_verified) VALUES
(1, 'Junia', 'Sehorsch', 'jsehorsch0@oracle.com', 0),
(2, 'Dave', 'Halliburton', 'dhalliburton1@pbs.org', 1),
(3, 'Agneta', 'Dutch', 'adutch2@thetimes.co.uk', 1),
(4, 'Kendell', 'Sylvester', 'ksylvester3@canalblog.com', 1),
(5, 'Koralle', 'Ragsdale', 'kragsdale4@buzzfeed.com', 1),
(6, 'Roma', 'Kenelin', 'rkenelin5@prnewswire.com', 1),
(7, 'Harold', 'Molloy', 'hmmolloy6@ycombinator.com', 1),
(8, 'Berri', 'Hartzogs', 'bhartzogs7@ox.ac.uk', 0),
(9, 'Garrik', 'Preddle', 'gpreddle8@topsy.com', 1),
(10, 'Sophie', 'Messenger', 'smessenger9@myspace.com', 1),
(11, 'Ashby', 'Philipsson', 'aphilipssona@typepad.com', 1),
(12, 'Kayle', 'Jesteco', 'kjestecob@ocn.ne.jp', 1),
(13, 'Munroe', 'Chevolleau', 'mchevolleauc@yandex.ru', 1),
(14, 'Etheline', 'Choake', 'echoaked@hao123.com', 1),
(15, 'Marten', 'Zamboniari', 'mzamboniarie@cbc.ca', 1),
(16, 'Hersch', 'Blasdale', 'hblasdalef@wunderground.com', 1),
(17, 'Jori', 'MacFaell', 'jmacfaellg@va.gov', 1),
(18, 'Margo', 'Finnemore', 'mfinnemoreh@discovery.com', 1),
(19, 'Felicle', 'Ramsdale', 'framsdalei@devhub.com', 1),
(20, 'Demetris', 'Arnet', 'darnetj@livejournal.com', 1);
INSERT INTO stats (profile_id, job_success_score) VALUES
(4, 100),(1, 100),(18, 95),(5, 95),(8, 95),(10,95),(12,95),
(13, 95),(14, 95),(20, 90),(17, 90),(7, 90),(15, 90),
(11, 85),(16, 85),(9, 85),(6, 85),(2, 85),(3, 75),
(19, 75);

select p.first_name,
	p.last_name,
	p.email,
	s.job_success_score
	from profiles1 p
	JOIN stats s ON p.id=s.profile_id
	WHERE s.job_success_score>=90 AND is_verified=1
	GROUP BY p.first_name,p.last_name,p.email,s.job_success_score
	ORDER BY s.job_success_score DESC,p.first_name,p.last_name
	LIMIT 10;

	
-- question 63
CREATE TABLE configurations (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(255)
);
CREATE TABLE deployments (
    configuration_id VARCHAR(64),
    dt VARCHAR(19),
    FOREIGN KEY (configuration_id) REFERENCES configurations(id)
);
INSERT INTO configurations (id, name) VALUES
('1vcpu_512mb_10gb_500gb', '1 CPU / 512 MB RAM / 10 GB SSD Disk / 500 GB transfer'),
('1vcpu_1gb_25gb_1tb', '1 CPU / 1 GB RAM / 25 GB SSD Disk / 1000 GB transfer'),
('1vcpu_2gb_50gb_2tb', '1 CPU / 2 GB RAM / 50 GB SSD Disk / 2 TB transfer'),
('2vcpu_2gb_60gb_3tb', '2CPUs / 2 GB RAM / 60 GB SSD Disk / 3 TB transfer'),
('2vcpu_4gb_80gb_4tb', '2CPUs / 4 GB RAM / 80 GB SSD Disk / 4 TB transfer'),
('4vcpu_8gb_160gb_5tb', '4CPUs / 8 GB RAM / 160 GB SSD Disk / 5 TB transfer'),
('8vcpu_16gb_320gb_6tb', '8CPUs / 16 GB RAM / 320 GB SSD Disk / 6 TB transfer');

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
('2vcpu_2gb_60gb_3tb', '2021-10-14 08:26:20'),
('1vcpu_2gb_50gb_2tb', '2021-11-01 19:00:30'),
('1vcpu_512mb_10gb_500gb', '2021-11-26 10:53:05'),
('1vcpu_1gb_25gb_1tb', '2021-12-27 07:07:23'),
('2vcpu_2gb_60gb_3tb', '2022-02-13 06:00:29'),
('2vcpu_2gb_60gb_3tb', '2022-03-03 09:10:30');

select c.name,
	COUNT(*) AS deployments
	from configurations c
	JOIN deployments d ON c.id=d.configuration_id
	WHERE d.dt LIKE '2021-%'
	GROUP BY c.name
	ORDER BY deployments DESC;

-- question 64
CREATE TABLE events1 (
    dt VARCHAR(19),
    type VARCHAR(64)
);
INSERT INTO events1 (dt, type) VALUES ('2022-04-04 03:36:00', 'buy');
INSERT INTO events1(dt, type) VALUES ('2022-04-21 07:05:09', 'buy');
INSERT INTO events1 (dt, type) VALUES ('2022-04-02 11:34:24', 'sell');
INSERT INTO events1 (dt, type) VALUES ('2022-05-27 16:12:50', 'buy');
INSERT INTO events1 (dt, type) VALUES ('2022-05-20 09:09:07', 'buy');
INSERT INTO events1 (dt, type) VALUES ('2022-05-22 09:06:37', 'buy');
INSERT INTO events1 (dt, type) VALUES ('2022-05-31 07:49:36', 'buy');
INSERT INTO events1(dt, type) VALUES ('2022-05-14 22:29:10', 'buy');
INSERT INTO events1(dt, type) VALUES ('2022-05-13 15:00:54', 'sell');
INSERT INTO events1(dt, type) VALUES ('2022-05-24 15:40:54', 'sell');
INSERT INTO events1 (dt, type) VALUES
('2022-05-13 01:20:05', 'sell'),
('2022-05-16 07:07:44', 'sell'),
('2022-05-01 16:57:00', 'sell'),
('2022-06-02 09:42:02', 'buy'),
('2022-06-01 06:34:59', 'buy'),
('2022-06-06 17:14:47', 'buy'),
('2022-06-05 13:37:23', 'buy'),
('2022-06-17 19:10:13', 'buy'),
('2022-06-15 21:37:13', 'sell'),
('2022-06-11 12:10:43', 'sell');
select 
	COUNT(*) AS purchases
	from events1 
	WHERE type='buy' AND dt LIKE '2022-05-%';

-- question 65
CREATE TABLE companie (
    id SMALLINT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE campaign1 (
    company_id SMALLINT,
    expenses DECIMAL(7,2),
    revenue DECIMAL(7,2),
    FOREIGN KEY (company_id) REFERENCES companie(id)
);

INSERT INTO companie (id, name) VALUES
(1, 'Lion Biotechnologies, Inc.'),
(2, 'Boston Private Financial Holdings, Inc.'),
(3, 'Universal Corporation'),
(4, 'Arbutus Biopharma Corporation'),
(5, 'Royal Bank Of Canada'),
(6, 'Penn West Petroleum Ltd'),
(7, 'Public Storage'),
(8, 'Halcon Resources Corporation'),
(9, 'TTM Technologies, Inc.'),
(10, 'Atwood Oceanics, Inc.'),
(11, 'ACADIA Pharmaceuticals Inc.'),
(12, 'Central European Media Enterprises Ltd.'),
(13, 'Oxbridge Re Holdings Limited'),
(14, 'Western Refining Logistics LP'),
(15, 'Vaalco Energy Inc'),
(16, 'Xilinx Inc.'),
(17, 'Liberty Global plc'),
(18, 'Honda Motor Company, Ltd.'),
(19, 'Great Plains Energy Inc'),
(20, 'Assurant, Inc.');

INSERT INTO campaign1 (company_id, expenses, revenue) VALUES
(1, 7390.24, 8652.18),(2, 5774.65, 7955.47),(3, 2154.71, 5920.23),
(4, 9366.49, 3397.85),(5, 2765.18, 9158.63),(6, 7908.41, 5018.85),
(7, 2251.44, 6654.52),(8, 3383.14, 9354.79),(9, 8287.96, 9522.53),
(10, 4356.62, 4658.52),(11, 9272.86, 9161.77),(12, 4996.18, 5903.57),
(13, 8354.75, 2259.26),(14, 6402.90, 8146.16),(15, 1692.05, 686.71),
(16, 5988.48, 9089.41),(17, 6192.33, 7580.19),(18, 3016.37, 7761.25),
(19, 9838.00, 1293.09),(20, 4386.00, 9513.73);
select c.name,
	SUM(ca.revenue-ca.expenses) AS profit
	from companie c
	JOIN campaign1 ca ON c.id=ca.company_id
	GROUP BY c.name
	HAVING SUM(ca.revenue-ca.expenses)>0
	ORDER BY profit DESC
	LIMIT 3;

-- question 66
CREATE TABLE clients11 (
    mac VARCHAR(64),
    upstream_rate INT,
    downstream_rate INT,
    downtime_rate VARCHAR(64)
);
INSERT INTO clients11 (mac, upstream_rate, downstream_rate, downtime_rate) VALUES
('78-C1-E5-20-D5-61', 925526, 5195, 'never'),
('78-E2-20-71-9C-30', 582152, 375829, 'never'),
('0D-09-F7-77-03-E5', 359529, 710743, 'never'),
('56-18-67-55-58-EA', 78626, 562544, 'once'),
('C9-73-EC-1C-4C-B7', 574927, 669655, 'yearly'),
('02-35-AF-B7-FC-C6', 430072, 296196, 'seldom'),
('3D-95-A3-A8-A6-F9', 894176, 489401, 'monthly'),
('8D-33-3F-0E-AD', 897666, 297063, 'weekly'),
('0E-0A-63-B9-79-AE', 69133, 984354, 'seldom'),
('15-D3-2A-DD-02-A4', 19203, 995983, 'seldom'),
('8D-42-B1-97-AB-87', 476648, 177677, 'monthly'),
('6B-64-60-47-16-D3', 700056, 374321, 'monthly'),
('FD-61-81-00-BF-EC', 216401, 498229, 'yearly'),
('95-46-C6-C7-6F-E0', 236331, 341013, 'monthly'),
('11-DE-62-32-62-5E', 694746, 451525, 'daily'),
('D6-5B-72-D5-Ff-4F', 2931, 992852, 'monthly'),
('66-BF-A4-F2-E5-A5', 861075, 44216, 'monthly'),
('E5-C9-C6-74-2E-A8', 639487, 968494, 'daily'),
('18-56-3A-93-8E-9F', 494945, 259910, 'weekly'),
('51-EB-D7-22-45-99', 219419, 326479, 'often');
select mac,
	upstream_rate,
	downstream_rate,
	downtime_rate
	from clients11 
	WHERE (downtime_rate='never' OR downtime_rate='once')
	AND downstream_rate>upstream_rate
	ORDER BY mac;

-- question 67
CREATE TABLE owners (
    id SMALLINT PRIMARY KEY,
    full_name VARCHAR(255),
    email_address VARCHAR(255),
    on_vacation SMALLINT
);
CREATE TABLE eve (
    owner_id SMALLINT,
 	dt VARCHAR(200),      -- Timestamp
    title VARCHAR(255) ,
	FOREIGN KEY (owner_id) REFERENCES owners(id)
);
INSERT INTO owners (id, full_name, email_address, on_vacation) VALUES
(2, 'Aleksandr Fellows', 'afellows1@instagram.com', 0),
(3, 'Collete Pack', 'cpack2@mit.edu', 0),
(4, 'Lorelle Squibb', 'lsquibb3@huffingtonpost.com', 0),
(1, 'Benjamin Sevier', 'bsevier0@discuz.net', 1),
(5, 'Cointon Welberry', 'cwelberry4@theguardian.com', 1);

INSERT INTO eve (owner_id, dt, title) VALUES
(1, '2021-08-13 09:17:41Z', 'ac consequat metus sapien ut.'),
(1, '2021-10-26 16:14:28Z', 'a libero nam.'),
(1, '2022-05-18 16:09:36Z', 'Vestibulum ante ipsum primis in faucibus.'),
(1, '2022-06-04 20:37:36Z', 'nisi volutpat eleifend donec.'),
(2, '2021-01-17 23:34:59Z', 'eu mi nulla ac.'),
(2, '2021-01-26 15:59:04Z', 'nisi venenatis lacinia'),
(2, '2021-04-25 05:04:29', 'arcu adipiscing molestie hendrerit'),
(2, '2022-02-22 10:24:50', 'lectus vestibulum quam sapien varius'),
(2, '2022-05-22 03:04:33', 'pellentesque quisque porta volutpat erat'),
(3, '2021-03-11 08:25:21', 'felis sed interdum venenatis'),
(3, '2022-02-15 07:29:45', 'cras mi pede malesuada in imperdiet '),
(4, '2021-02-28 16:10:55', 'cras mi pede malesuada in imperdiet et'),
(4, '2021-05-20 03:35:11', 'odio in hac habitasse platea dictumst'),
(4, '2021-09-01 19:25:41', 'sagittis nam congue risus semper'),
(4, '2022-02-04 03:11:53', 'luctus cum sociis natoque penatibus et magnis'),
(4, '2022-06-18 08:39:41', 'nec molestie sed justo pellentesque'),
(5, '2021-04-04 13:39:38', 'id massa id nisl venenatis lacinia aenean'),
(5, '2021-10-18 19:04:14', 'adipiscing lorem vitae mattis'),
(5, '2021-10-19 00:56:11', 'vestibulum eget vulputate '),
(5, '2022-04-26 18:55:04', 'at dolor quis');

select e.dt,
	e.title,
	o.full_name,
	o.email_address
	from eve e
	JOIN owners o ON o.id=e.owner_id
	WHERE o.on_vacation=0
	GROUP BY e.dt,e.title,o.full_name,o.email_address
	ORDER BY dt
	LIMIT 5;

-- question 68
CREATE TABLE client01 (
    id SMALLINT PRIMARY KEY,
    mac VARCHAR(64) NOT NULL
);
CREATE TABLE traffic01 (
    client_id SMALLINT,
    amount INT,
    FOREIGN KEY (client_id) REFERENCES client01(id)
);
INSERT INTO client01 (id, mac) VALUES
(1, 'E5-A3-AC-8A-20-F9'),
(2, '3B-2F-83-25-A8-81'),
(3, '3A-4E-A6-43-1D-B1'),
(4, 'B7-03-14-91-BF-58'),
(5, '63-1A-FD-9A-AF-6F'),
(6, 'D6-B8-1F-ID34-O4'),
(7, '38 -83-E5-F8-C8-DC'),
(8, 'E9-F6-89-F7-BD-34'),
(9, '82-E2-B3-G7-O4-41'),
(10, 'D1-9D-DE37AO49'),
(11, '8A-46-F4-83-29-13'),
(12, '4C-1F-7B-C7-08-7E'),
(13, '72-57-E6-CA-2C-91'),
(14, '57-F7-E7-E7-45-36'),
(15, '05-8A-05-1D-2D-20'),
(16, '46-06-F1-B9-65-7C'),
(17, '0A-E0-26–9D–2A–27'),
(18, 'F0–86–99–18–36–9B'),
(19, 'DD–81-BF–53-BD–9B'),
(20, '50–53–64–8E–42–BE');

INSERT INTO traffic01 (client_id, amount) VALUES
(3, 6385047),(8, 6490817),(14, 9109219),(16, 5558512),
(17, 1870152),(17, 8228920),(18, 326127),(18, 5429741),
(18, 4063477),(19, 7411789),(20, 5832337),(20, 1426585),
(13, 1097368),(13, 6769594),(13, 802387),(14, 5959513),
(14, 1300408),(14, 4631624),(18, 1629306),(19, 2814818);

select c.mac
	from traffic01 t
	JOIN client01 c ON c.id=t.client_id
	GROUP BY c.mac
	HAVING COUNT(*)>=1
	ORDER BY c.mac;

	
-- question 69
CREATE TABLE wallet (
    id SMALLINT PRIMARY KEY,
    address VARCHAR(64) NOT NULL
);
CREATE TABLE trans1 (
    wallet_id SMALLINT,
    credit DECIMAL(4,2)
);
INSERT INTO wallet (id, address) VALUES
(1, '0x1ecc4cefde6dfb773352a2dcd8b5f518ccd24ff4'),
(2, '0xf4487168610dcae7f16b6c000a7ba284bb6703c'),
(3, '0x54c5c516b5c601a3e6fdea18db966186274879e6'),
(4, '0x50c404a6790d44849c35000d95f147d2102db5f77'),
(5, '0x41cc32037fdcc6bcfb5cb04ada4e38032a84361ac'),
(6, '0xb38ca2076b2c3a0a1c0796cacb5dc3fcbb645336'),
(7, '0x923c6ee4edebce6c37c512eb90e9b26fc9bbfc3e1'),
(8, '0x76cfbf67e1765117a98fd2286bdcb731b0d29ec'),
(9, '0xf4dff43df89365453440dbeb5e53445d3400d218'),
(10, '0x010a4b23f985eda6b397864878cb70bf0b233aa6'),
(11, '0x106c4c852394d5a6580c11ca006687a798ec78c7'),
(12, '0x541da74bf4b2283524a65156263bcce7429ba61f'),
(13, '0x86df8e62ad23a35ee2e64b3b4b128d8a3660116a'),
(14, '0x6bd021b12b779aec27009f18bdad227685df5474'),
(15, '0x7073e9f48b7211d99400db48cbade8ed31dd9d077'),
(16, '0x4672e132b9627ad7bf76e5af431bb5fbeb93b1bzf'),
(17, '0x5c8bc82a01db39df85fee09bf5af1c48afe06cb96'),
(18, '0xc17cd30f90081b45004e06d549534ef8658795672'),
(19, '0xf830618ca9f027ce5f23bf270629aa6a418ad355c'),
(20, '0xa13ac1b923fcc174a42a34009142ea18192a3ea7');

INSERT INTO trans1 (wallet_id, credit) VALUES
(3, 5.21),(6, 24.04),(8, 29.66),(10, 1.67),(10, 3.32),
(10, 4.27),(14, 3.32),(14, 3.35),(15, 14.34),(16, 11.94),
(20, 13.86),(20, 16.54),(21, 11.64),(25, 12.86),
(26, 8.77),(26, 12.36),(27, 29.65),(28, 3.00),
(28, 13.26),(28, 2.85);

select w.address
	from trans1 t
	JOIN wallet w ON w.id=t.wallet_id
	GROUP BY w.address
	HAVING COUNT(*)>=1
	ORDER BY w.address;
	
-- question 70
CREATE TABLE animal (
    id SMALLINT PRIMARY KEY,
    name VARCHAR(64) NOT NULL
);
CREATE TABLE tracklog1 (
    animal_id SMALLINT,
    tracked_at VARCHAR(19)
);
INSERT INTO animal (id, name) VALUES
(1, 'Blue and yellow macaw'),(2, 'Jungle kangaroo'),
(3, 'Stork, woolly-necked'),(4, 'North American river otter'),
(5, 'Square-lipped rhinoceros'),(6, 'Black-fronted bulbul'),
(7, 'American beaver'),(8, 'Capybara'),(9, 'Black-backed jackal'),
(10, 'Dragon, ornate rock'),(11, 'Wombat, southern hairy-nosed'),
(12, 'Snake, carpet'),(13, 'Egyptian cobra'),(14, 'Green heron'),
(15, 'Indian star tortoise'),(16, 'Roan antelope'),(17, 'Rhea, common'),(18, 'Fairy penguin'),
(19, 'Black-eyed bulbul'),(20, 'Starling, cape');

INSERT INTO tracklog1 (animal_id, tracked_at) VALUES
(2, '2021-07-08 12:30:34'),
(5, '2021-09-15 03:00:04'),
(8, '2021-12-14 11:20:50'),
(9, '2021-05-15 14:54:15'),
(11, '2021-07-03 17:04:14'),
(11, '2021-02-23 09:02:11'),
(15, '2021-11-02 22:49:37'),
(15, '2021-07-31 04:51:25'),
(15, '2021-06-06 14:57:23'),
(19, '2021-03-25 00:02:31'),
(19, '2021-04-21 22:02:51'),
(19, '2021-07-17 17:12:35'),
(21, '2021-05-06 03:35:59'),
(22, '2021-09-21 22:49:36'),
(22, '2021-12-04 00:26:29'),
(24, '2021-12-27 08:19:52'),
(26, '2021-05-14 07:30:11'),
(28, '2021-06-08 00:47:00'),
(28, '2021-04-24 00:42:31'),
(30, '2021-05-06 21:03:03');

select name
	from animal a
	JOIN tracklog1 t ON a.id=t.animal_id
	GROUP BY name
	HAVING COUNT(*)>=1
	ORDER BY name;

-- question 71
CREATE TABLE customers11 (
    id INT PRIMARY KEY,
    customer_name VARCHAR(30) NOT NULL
);
CREATE TABLE orders1 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_type VARCHAR(5),
    order_amount DECIMAL(18,2)
);
INSERT INTO customers11 (id, customer_name) VALUES
(401, 'Hubert Keesler'),
(402, 'Devin Vert'),
(403, 'Lashawna Bowerman'),
(404, 'Brigid Wellborn'),
(405, 'Josefine Perl');
INSERT INTO orders1(order_id, customer_id, order_type, order_amount) VALUES
(4361, 401, 'Sell', 912.77),
(3478, 405, 'Sell', 741.69),
(7292, 405, 'Sell', 436.05),
(5833, 405, 'Sell', 231.30),
(3472, 402, 'Buy', 950.92),
(4472, 401, 'Sell', 367.70),
(2624, 404, 'Buy', 218.15),
(7198, 405, 'Buy', 797.29),
(7660, 403, 'Buy', 131.18),
(5192, 401, 'Buy', 362.44),
(5260, 402, 'Buy', 636.26),
(2726, 403, 'Sell', 138.15),
(6594, 401, 'Buy', 234.51),
(4657, 404, 'Buy', 427.30),
(9744, 402, 'Sell', 623.36);

select c.customer_name,
	ROUND(SUM(CASE WHEN o.order_type='Buy' THEN o.order_amount*0.001
	ELSE o.order_amount*0.0015 END),2) AS total_fees
	FROM customers11 c
	JOIN orders1 o ON c.id=o.customer_id
	GROUP BY c.customer_name
	ORDER BY c.customer_name;

-- question 72
CREATE TABLE credit_holders (
    id INT PRIMARY KEY,
    first_name VARCHAR(15) NOT NULL,
    last_name VARCHAR(15) NOT NULL,
    interest_rate INT
);
CREATE TABLE transact(
    transaction_id INT PRIMARY KEY,
    credit_holder_id INT,
    amount DECIMAL(18,2),
    FOREIGN KEY (credit_holder_id) REFERENCES credit_holders(id)
);
INSERT INTO credit_holders (id, first_name, last_name, interest_rate) VALUES
(101, 'Clemencia', 'Hutsell', 12),
(102, 'Susannah', 'Ismail', 18),
(103, 'Sixta', 'Hagy', 18),
(104, 'Otto', 'Izquierdo', 18),
(105, 'Anita', 'Degroot', 15);
INSERT INTO transact (transaction_id, credit_holder_id, amount)
VALUES
  (4361, 101, 65.22),  (3478, 104, 51.85),  (7292, 104, 64.60),
  (5833, 105, 72.15),  (3472, 102, 96.28),  (4472, 101, 80.06),
  (2624, 101, 85.27),  (7198, 104, 23.73),  (7660, 103, 81.86),
  (5192, 101, 69.64),  (5260, 101, 71.72),  (2726, 102, 57.66),
  (6594, 103, 23.23),  (4657, 101, 81.68),  (9744, 104, 99.57),
  (2054, 103, 51.13),  (7156, 105, 12.78),  (3273, 105, 36.15),
  (9756, 101, 45.41),  (9702,105,69.75);

select 
	CONCAT(c.first_name,'',c.last_name) AS full_name,
	ROUND(SUM(t.amount*(1+c.interest_rate/100.0)),2) AS dues
	from credit_holders c
	JOIN transact t ON c.id=t.credit_holder_id
	WHERE c.interest_rate>12
	GROUP BY c.first_name,c.last_name
	ORDER BY dues DESC;

-- question 73
CREATE TABLE ACCOUNTS13 (
    id INT,
    account_holder VARCHAR(30),
    amount VARCHAR(10)
);
INSERT INTO ACCOUNTS13 (id, account_holder, amount) VALUES
(1, 'Ellis Beane', '$5582.03'),
(2, 'Drew Nolf', '$2470.3'),
(3, 'Jordan Chatmon', '$6211.52'),
(4, 'Robin Hansard', '$8133.31'),
(5, 'Spencer Days', '$5273.81'),
(6, 'Morgan Criss', '$3741.85'),
(7, 'Wesley Waugh', '$7056.14'),
(8, 'Alex Canty', '$2590.45'),
(9, 'Blake Hawbaker', '$3987.27'),
(10, 'Taylor Blackston', '$8351.98');

select 
	account_holder,
	CONCAT('$',ROUND(CAST(SUBSTRING(amount,2) AS decimal)*0.05,2)) AS interest
	from accounts13
	order by account_holder;

-- question 74
CREATE TABLE TRANSACTIONS01 (
    transaction_id VARCHAR(10),
    amount DECIMAL(18,2)
);
INSERT INTO TRANSACTIONS01 (transaction_id, amount) VALUES
('19SEP2187', 785.72),('19OCT4361', 752.64),
('19APR3478', 197.92),('19SEP7292', 910.26),
('21MAR5833', 344.70),('20MAY3472', 939.61),
('20DEC4472', 154.98),('20DEC2624', 935.44),
('21JUN7198', 309.81),('19APR7660', 528.10),
('19APR7660', 528.10),('20MAR5192', 995.22),
('19OCT5260', 861.11),('21JUN2726', 611.94),
('19OCT6594', 478.54),('19APR4657', 183.20);

select 
	LEFT(transaction_id,2) AS year,
	SUBSTRING(transaction_id,3,3) AS month,
	SUM(amount) AS total_transactions
	from transactions01 t
	GROUP BY year,month
	ORDER BY year,month;

-- question 75
CREATE TABLE RESULTS (
    id INT,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    cgpa_first_year FLOAT,
    cgpa_second_year FLOAT,
    cgpa_third_year FLOAT,
    cgpa_fourth_year FLOAT
);
drop table results;
INSERT INTO RESULTS (id, first_name, last_name, cgpa_first_year,cgpa_second_year, cgpa_third_year, cgpa_fourth_year) VALUES
(1, 'Pearlene', 'Beane', 7, 5.1, 8.4, 8.9),
(2, 'Franklin', 'Nolf', 7.7, 7.2, 5.2, 8.3),
(3, 'Bell', 'Chatmon', 7.3, 8.4, 8.9, 10),
(4, 'Belva', 'Hansard', 6.2, 9.2, 5.8, 6.7),
(5, 'Missy', 'Days', 8.3, 10, 7.3, 6.7),
(6, 'Vicenta', 'Criss', 5.4, 9.5, 6.1, 9),
(7, 'Annelle', 'Waugh', 6.5, 7.9,9.6,9.3),
(8, 'Darby', 'Canty', 5.5,9,8.6,5.9),
(9, 'Ka', 'Hawbaker',5.7,6.4,5.2,6.8),
(10, 'Alease', 'Blackston',5.3,7.5,9.3,6);
select 
	CONCAT(first_name,'',last_name) AS full_name,
	ROUND(((cgpa_first_year+cgpa_second_year+
		cgpa_third_year+cgpa_fourth_year)/4) :: numeric,1) AS average_gpa
	from results
	order by average_gpa DESC;
	
-- question 76
CREATE TABLE FUNDS (
    id INT,
    order_date DATE,
    fund_name VARCHAR(50),
    order_amount INT
);
INSERT INTO FUNDS (id, order_date, fund_name, order_amount) VALUES
(1, '2021-09-05', 'Mid-Cap', 151),
(2, '2020-11-27', 'Small-Cap', 784),
(3, '2020-11-22', 'Multi-Cap', 761),
(4, '2020-02-26', 'Large-Cap', 778),
(5, '2020-01-04', 'Mid-Cap', 949),
(6, '2020-02-01', 'Large-Cap', 392),
(7, '2020-02-07', 'Mid-Cap', 629),
(8, '2020-06-01', 'Small-Cap', 529),
(9, '2020-08-05', 'Large-Cap', 258),
(10, '2021-09-23', 'Mid-Cap', 739),
(11, '2020-02-14', 'Large-Cap', 563),
(12, '2021-09-29', 'Small-Cap', 817),
(13, '2020-05-11', 'Large-Cap', 121),
(14, '2021-09-18', 'Mid-Cap', 341),
(15, '2021-09-07', 'Large-Cap', 260),
(16, '2021-10-11', 'Small-Cap', 102),
(17, '2020-06-04', 'Mid-Cap', 496),
(18, '2021-07-26', 'Multi-Cap', 321),
(19, '2020-04-11', 'Small-Cap', 323),
(20, '2020-09-24', 'Multi-Cap', 938),
(21, '2020-06-16', 'Small-Cap', 668),
(22, '2021-03-08', 'Small-Cap', 733),
(23, '2021-04-27', 'Small-Cap', 597),
(24, '2020-01-11', 'Small-Cap', 767),
(25, '2021-11-14', 'Small-Cap', 489);

select 
	EXTRACT(month from order_date) AS month,
	fund_name,
	SUM(order_amount) AS total_investments
	from funds
	GROUP BY month,fund_name
	ORDER by month,fund_name;

-- question 77
CREATE TABLE traffic0 (
    client VARCHAR(17) PRIMARY KEY,
    protocol VARCHAR(64),
    traffic_in INT,
    traffic_out INT
);
INSERT INTO traffic0 (client, protocol, traffic_in, traffic_out) VALUES
('02-E1-80-76-EC-4B', 'BGP', 0, 234737),
('43-15-AA-26-0F-A4', 'BGP', 402860, 606565),
('90-E7-B0-14-7E-8C', 'BGP', 840772, 988197),
('FB-60-23-C1-5E-D6', 'DNS', 341155, 356569),
('4D-6D-7F-62-F4-00', 'FTP', 8346, 413322),
('09-89-26-46-C4-21', 'FTP', 210656, 470568),
('B1-6A-35-2F-1A-C2', 'FTP', 897097, 161083),
('0C-CA-68-2D-4B-F5', 'HTTP', 918793, 550403),
('A4-C6-52-10-E2-9C', 'HTTPS', 520856, 185387),
('95-B8-7D-78-06-42', 'POP', 150880, 423073),
('B9-C1-1B-32-55-95', 'POP', 862946, 979544),
('14-FD-21-F6-5E-67', 'SMTP', 139389, 280646),
('70-E1-2D-B1-B2-9B', 'SMTP', 163986, 450401),
('C6-F1-59-FF-5D-BE', 'SMTP', 271295, 878246),
('62-01-CF-AD-32-A7', 'SMTP', 388933, 81625),
('41-B0-FB-B6-D1-93', 'SMTP', 752842, 253981),
('93-0F-31-07-5F-4A', 'SSH', 496717, 599280),
('52-F2-BF-A5-A4-74', 'SSH', 632534, 128765),
('87-66-B5-A5-2F-7B', 'SSH', 835441, 354950),
('CE-FC-80-F3-95-58', 'UDP', 903443, 120298);
-- a team needs a list of all the protocols for which incoming traffic is higher than outgoing.

select protocol,
	SUM(traffic_in),
	SUM(traffic_out)
	from traffic0 
	GROUP BY protocol
	HAVING SUM(traffic_in)>	SUM(traffic_out)
	ORDER BY protocol;

-- question 78
select 
concat(cust.first_name,'',cust.last_name) as customer
count(status) as failure
from customers21 cust
join campaigns21 c 
on cust.id = c.customer_id
join events e 
on cust.id=e.campaign_ig
where status = 'failure'
group by first_name,last_name
having count(status)>3

CREATE TABLE customers21 (
    id SMALLINT PRIMARY KEY,
    first_name VARCHAR(64),
    last_name VARCHAR(64)
);
CREATE TABLE campaigns21 (
    id SMALLINT PRIMARY KEY,
    customer_id SMALLINT,
    name VARCHAR(64),
    FOREIGN KEY (customer_id) REFERENCES customers21(id)
);
CREATE TABLE events21 (
    dt VARCHAR(19),
    campaign_id SMALLINT,
    status VARCHAR(64),
    FOREIGN KEY (campaign_id) REFERENCES campaigns21(id)
);

INSERT INTO customers21 (id, first_name, last_name) VALUES
(1, 'Whitney', 'Ferrero'),
(2, 'Dickie', 'Romera');
select * from campaigns21;

INSERT INTO campaigns21 (id, customer_id, name) VALUES
(1, 1, 'Upton Group'),
(2, 1, 'Roob, Hudson and Rippin'),
(3, 1, 'McCullough, Rempel and Larson'),
(4, 1, 'Lang and Sons'),
(5, 2, 'Ruecker, Hand and Haley');

INSERT INTO events21 (dt, campaign_id, status) VALUES
('2021-12-02 13:52:00', 1, 'failure'),
('2021-12-02 08:17:48', 2, 'failure'),
('2021-12-02 08:18:17', 2, 'failure'),
('2021-12-01 11:55:32', 3, 'failure'),
('2021-12-01 06:53:16', 4, 'failure'),
('2021-12-02 04:51:09', 4, 'failure'),
('2021-12-01 06:34:04', 5, 'failure'),
('2021-12-02 03:21:18', 5, 'failure'),
('2021-12-02 03:18:24', 5, 'failure'),
('2021-12-02 15:32:37', 1, 'success'),
('2021-12-01 04:23:20', 1, 'success'),
('2021-12-02 06:53:24', 1, 'success'),
('2021-12-02 08:01:02', 2, 'success'),
('2021-12-01 15:57:19', 2, 'success'),
('2021-12-02 16:14:34', 3, 'success'),
('2021-12-02 21:56:38', 3, 'success'),
('2021-12-01 05:54:43', 4, 'success'),
('2021-12-02 17:56:45', 4, 'success'),
('2021-12-02 11:56:50', 4, 'success'),
('2021-12-02 06:08:20', 5, 'success');

select 
	CONCAT(cust.FIRST_NAME,'',cust.last_name) AS full_name,
	COUNT(*) AS failures
	from customers21 cust
	JOIN campaigns21 c ON cust.id=c.customer_id
	JOIN events21 e ON c.id=e.campaign_id
	WHERE e.status='failure'
	GROUP BY cust.FIRST_NAME,cust.last_name
	HAVING COUNT(*)>3;

-- question 79
Select
CONCAT(c.first_name,'',c.last_name) as candidate,
count(*) as votes
from candidate c 
join result r 
on c.id = r.candidate_id
group by first_name,last_name
order by votes DESC;

CREATE TABLE candidates (
    id SMALLINT,
    first_name VARCHAR(64),
    last_name VARCHAR(64)
);
CREATE TABLE result (
    candidate_id SMALLINT,
    vote_at VARCHAR(19)
);
INSERT INTO candidates (id, first_name, last_name) VALUES
(1, 'Xavier', 'Ping'),
(2, 'Westley', 'Drewell'),
(3, 'Dominick', 'Scoble');
INSERT INTO result (candidate_id, vote_at) VALUES
(0, '2021-12-01 15:32:37'),
(1, '2021-12-01 04:23:20'),
(1, '2021-12-01 06:53:24'),
(1, '2021-12-02 08:01:02'),
(1, '2021-12-02 15:57:19'),
(2, '2021-12-01 08:17:48'),
(2, '2021-12-01 08:18:17'),
(2, '2021-12-01 16:14:34'),
(2, '2021-12-02 16:14:34'),
(2, '2021-12-02 21:56:38'),
(2, '2021-12-02 11:55:32'),
(2, '2021-12-02 21:54:50'),
(2, '2021-12-02 00:43:18'),
(3, '2021-12-01 06:59:33'),
(3, '2021-12-02 08:36:35'),
(3, '2021-12-02 10:20:33'),
(3, '2021-12-02 14:02:38'),
(4, '2021-12-02 05:05:55'),  -- corrected from '2021;12;02 05;05;55'
(5, '2021-12-02 15:50:50'),  -- corrected from '2021;1202 15;50;50'
(5, '2021-12-02 20:45:08');  -- corrected from '20121;-12022045;;08'

select
	CONCAT(c.first_name,'',c.last_name) AS full_name,
	COUNT(*) AS votes
	from candidates c
	JOIN result r ON c.id=r.candidate_id
	GROUP BY c.first_name,c.last_name
	ORDER BY votes DESC;

-- question 80
CREATE TABLE event0 (
    dt VARCHAR(19),         -- Transaction timestamp
    customer VARCHAR(64),   -- Customer name
    amount DECIMAL(5,2)     -- Transaction amount
);
INSERT INTO event0 (dt, customer, amount) VALUES
('2021-11-22 06:41:01', 'Donaugh Furneaux', 0.89),
('2021-12-22 20:07:04', 'Donaugh Furneaux', 10.51),
('2021-12-31 05:22:11', 'Donaugh Furneaux', 55.92),
('2021-12-12 21:26:42', 'Harley Lyddiard', 37.68),
('2021-11-22 21:24:30', 'Kippy Jelly', 85.87),
('2021-11-25 07:00:29', 'Kippy Jelly', 7.25),
('2021-12-16 16:48:32', 'Kippy Jelly', 65.49),
('2021-12-22 23:30:55', 'Latrina Jackman', 93.49),
('2021-11-24 19:38:52', 'Latrina Jackman', 82.28),
('2021-11-30 22:59:33', 'Latrina Jackman', 96.87),
('2021-12-30 13:05:34', 'Latrina Jackman', 88.19),
('2021-11-22 02:08:02', 'Maribel Braim', 20.19),
('2021-12-13 00:14:58', 'Maribel Braim', 97.99),
('2021-12-26 13:22:20', 'Maribel Braim', 57.06),
('2021-12-29 00:20:27', 'Maribel Braim', 24.35),
('2021-11-25 14:29:29', 'Orrin Curley', 6.69),
('2021-12-08 06:22:16', 'Orrin Curley', 36.85),
('2021-12-09 15:32:16', 'Orrin Curley', 11.04),
('2021-11-28 00:15:20', 'Rasla Venny', 14.59),
('2021-12-25 09:58:23', 'Rasla Venny', 6.41);

select 
	customer,
	COUNT(*) AS transactions,
	SUM(amount) AS total
	from event0
	WHERE dt LIKE '2021-12-%'
	GROUP BY customer
	HAVING COUNT(*)>=3
	ORDER BY customer;

-- question 81
CREATE TABLE marks (
    STUDENT_ID INTEGER,
    MARKS INTEGER
);
INSERT INTO marks (STUDENT_ID, MARKS) VALUES
(1, 450),
(2, 200),
(3, 260),
(2, 300),
(3, 250);
select student_id,
	SUM(marks) AS SUM_OF_MARKS
	from marks 
	GROUP BY student_id
	HAVING SUM(marks)>=500
	ORDER BY student_id DESC;

	
--question 82
CREATE TABLE FAMILIES1(
    ID VARCHAR(255),         -- Unique ID of the family
    NAME VARCHAR(255),       -- Name of the primary contact
    FAMILY_SIZE INTEGER      -- Size of the family
);
CREATE TABLE COUNTRY1 (
    ID VARCHAR(255),         -- Unique ID of the country
    NAME VARCHAR(255),       -- Name of the country
    MIN_SIZE INTEGER         -- Minimum size group to get a discount
);
INSERT INTO FAMILIES1 (ID, NAME, FAMILY_SIZE) VALUES('c00dac11bde74750b4d207b9c182a85f', 'Alex Thomas', 9),
('eb6f2d3426694667ae3e79d6274114a4', 'Chris Gray', 2);
INSERT INTO COUNTRY1 (ID, NAME, MIN_SIZE) VALUES
('023fd23615bd4ff4b2ae0a13ed7efec9', 'Bolivia', 2),
('be247f73de0f4b2d810367cb26941fb9', 'Cook Islands', 4),
('3e85ab80a6f84ef3b9068b21dbcc54b3', 'Brazil', 4);

select MAX(discounted_price)
	FROM(
	select 
		COUNT(*) AS discounted_price
		FROM families1 f 
		JOIN country1 c ON f.family_size>c.min_size
		GROUP BY f.id
	)
	
-- question 83
CREATE TABLE ACTIVITIES (
    ID INTEGER PRIMARY KEY,     -- ID of the activity
    NAME VARCHAR(255)           -- Name of the activity
);
CREATE TABLE FRIEND (
    ID INTEGER PRIMARY KEY,     -- ID of a friend
    NAME VARCHAR(255),          -- Name of the friend
    ACTIVITY VARCHAR(255)       -- Name of the activity the friend takes part in
);
INSERT INTO ACTIVITIES (ID, NAME) VALUES
(1, 'Horse Riding'),
(2, 'Eating'),
(3, 'Playing');
INSERT INTO FRIEND(ID, NAME, ACTIVITY) VALUES
(1, 'James Smith', 'Horse Riding'),
(2, 'Eric Jenkins', 'Eating'),
(3, 'Sean Cox', 'Eating'),
(4, 'Eric Schmidt', 'Horse Riding'),
(5, 'Chris Evans', 'Eating'),
(6, 'Jessica Breeds', 'Playing');

select f.activity
	from friend f
	JOIN activities a ON f.activity=a.name
	GROUP BY f.activity
	HAVING COUNT(*) NOT IN
	(
		(select MAX(cnt) from(select COUNT(*) AS cnt from friend f GROUP BY f.activity) sub),
		(select MIN(cnt) from(select COUNT(*) AS cnt from friend f GROUP BY f.activity) sub)
	);


--question 84
CREATE TABLE CUSTOMERS22 (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255),
    phone VARCHAR(15),
    visited_on DATE,
    amount INTEGER
);
INSERT INTO CUSTOMERS22 (id, name, phone, visited_on, amount) VALUES
(1, 'Julia', '1234567890', '2015-05-01', 100),
(2, 'Samantha', '1234567890', '2015-05-02', 200),
(3, 'Julia-Samantha', '1234567890', '2015-05-03', 300);

select 
	c1.visited_on,
	c1.amount,
	ROUND(AVG(c2.amount)) AS avg_amount
	from customers22 c1
	JOIN customers22 c2 ON c2.visited_on 
	BETWEEN(c1.visited_on- INTERVAL '6 days') AND c1.visited_on
	GROUP BY c1.visited_on,c1.amount 
	ORDER BY avg_amount;

--question 85
drop table student;
CREATE TABLE STUDENT (
    ID INT PRIMARY KEY,
    NAME VARCHAR(255)
);
CREATE TABLE EXAMINATION (
    STUDENT_ID INT,
    SUBJECT VARCHAR(255),
    FOREIGN KEY (STUDENT_ID) REFERENCES STUDENT(ID)
);
INSERT INTO STUDENT (ID, NAME) VALUES
(1, 'Taylor'),
(2, 'Wesley'),
(3, 'Jordan'),
(4, 'Robin'),
(5, 'Alex');
INSERT INTO EXAMINATION (STUDENT_ID, SUBJECT) VALUES
(1, 'Biology'),
(1, 'Physics'),
(3, 'History'),
(4, 'Geography'),
(4, 'Geography');

select s.id,
	e.subject,
	COUNT(*) AS NUMBER_OF_TIMES
	from student s
	JOIN examination e ON s.id=e.student_id
	GROUP BY s.id,e.subject
	ORDER BY s.id;

--question 86
CREATE TABLE CUSTOMER9 (
    ID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    COUNTRY VARCHAR(50),
    CREDIT_LIMIT FLOAT
);
INSERT INTO CUSTOMER9 (ID, FIRST_NAME, LAST_NAME, COUNTRY, CREDIT_LIMIT) VALUES
(1, 'Alex', 'White', 'USA', 200350.54),
(2, 'Tyler', 'Hanson', 'UK', 15354.23),
(3, 'Jordan', 'Fernandez', 'France', 359200.67),
(4, 'Drew', 'Bradley', 'Albania', 1060.57),
(5, 'Blake', 'Fuller', 'USA', 14789.00),
(6, 'Spencer', 'Johnston', 'China', 100243.35),
(7, 'Ellis', 'Gutierrez', 'USA', 998999.20),
(8, 'Morgan', 'Thomas', 'Canada', 500500.23),
(9, 'Riley', 'Garza', 'UK', 18782.44),
(10, 'Peyton', 'Harris', 'USA', 158367.00);

select id,
	CONCAT(first_name,'',last_name) AS full_name
	from customer9
	WHERE LENGTH(CONCAT(first_name,'',last_name))<12
	ORDER BY LENGTH(CONCAT(first_name,'',last_name)),
			LOWER(CONCAT(first_name,'',last_name));

--question 87
CREATE TABLE STUDENTS1 (
    ID INT PRIMARY KEY CHECK (ID BETWEEN 1 AND 1000),
    NAME VARCHAR(100) NOT NULL CHECK (LENGTH(NAME) BETWEEN 1 AND 100),
    SCORE FLOAT
);
INSERT INTO STUDENTS1 (ID, NAME, SCORE) VALUES
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

select id,
	name
	from students1
	WHERE score>(
		select AVG(SCORE) from students1
	);

-- question 88
CREATE TABLE Order1 (
    id INT PRIMARY KEY,
    order_date DATE,
    status VARCHAR(50),
    customer_id INT
);
INSERT INTO Order1 (id, order_date, status, customer_id) VALUES
(10100, '2003-01-06', 'PLACED', 363),
(10101, '2003-01-06', 'PLACED', 128),
(10102, '2003-01-06', 'IN TRANSIT', 181),
(10103, '2003-01-06', 'DELIVERED', 121),
(10104, '2003-01-07', 'DELIVERED', 114),
(10106, '2003-01-07', 'IN TRANSIT', 278),
(10120, '2003-01-07', 'PLACED', 114),
(10122, '2003-05-05', 'IN TRANSIT', 350),
(10123, '2003-05-05', 'DELIVERED', 103);

select *
	from order1
	WHERE status NOT LIKE 'DELIVERED'
	ORDER BY order_date
	LIMIT 5;
			OR
select *
	from order1
	WHERE status IN('PLACED','IN TRANSIT')
	ORDER BY order_date
	LIMIT 5;

-- question 89
CREATE TABLE CUSTOMER01 (
    ID INT PRIMARY KEY CHECK (ID BETWEEN 1 AND 1000),
    NAME VARCHAR(100) NOT NULL CHECK (LENGTH(NAME) BETWEEN 1 AND 100),
    COUNTRY VARCHAR(100),
    CREDITS INT
);
INSERT INTO CUSTOMER01 (ID, NAME, COUNTRY, CREDITS) VALUES
(1, 'Frances White', 'USA', 200350),
(2, 'Carolyn Bradley', 'UK', 15354),
(3, 'Annie Fernandez', 'France', 359200),
(4, 'Ruth Hanson', 'Albania', 1060),
(5, 'Paula Fuller', 'USA', 14789),
(6, 'Bonnie Johnston', 'China', 100243),
(7, 'Ruth Gutierrez', 'USA', 998999),
(8, 'Ernest Thomas', 'Canada', 509500),
(9, 'Joe Garza', 'UK', 18782),
(10, 'Anne Harris', 'USA', 158367);

select id,
	name
	from customer01
	WHERE country='USA' AND credits>=100000
	ORDER BY id;

-- question 89
CREATE TABLE CUSTOMER010 (
    ID INT PRIMARY KEY CHECK (ID BETWEEN 1 AND 1000),
    NAME VARCHAR(100) NOT NULL CHECK (LENGTH(NAME) BETWEEN 1 AND 100),
    COUNTRY VARCHAR(100),
    CREDITS INT
);
INSERT INTO CUSTOMER010 (ID, NAME, COUNTRY, CREDITS) VALUES
(1, 'Frances White', 'USA', 200350),
(2, 'Carolyn Bradley', 'UK', 15354),
(3, 'Annie Fernandez', 'France', 359200),
(4, 'Ruth Hanson', 'Albania', 1060),
(5, 'Paula Fuller', 'USA', 14789),
(6, 'Bonnie Johnston', 'China', 100243),
(7, 'Ruth Gutierrez', 'USA', 998999),
(8, 'Ernest Thomas', 'Canada', 509500),
(9, 'Joe Garza', 'UK', 18782),
(10, 'Anne Harris', 'USA', 158367);

select id,
	name
	from customer01
	WHERE country='USA' AND credits>=100000
	ORDER BY id;

-- question 90
CREATE TABLE COLLECTION (
    RED INT CHECK (RED BETWEEN 30 AND 100),
    GREEN INT CHECK (GREEN BETWEEN 30 AND 100),
    BLUE INT CHECK (BLUE BETWEEN 30 AND 100)
);
INSERT INTO COLLECTION (RED, GREEN, BLUE) VALUES
(65, 65, 87),
(50, 50, 50),
(30, 50, 100),
(40, 50, 90),
(92, 50, 50);

select 
	CASE
		WHEN RED=GREEN AND GREEN=BLUE THEN 'GOOD'
		WHEN (RED=GREEN AND RED<>BLUE)
		OR (RED=BLUE AND RED<>GREEN)
		OR (GREEN=BLUE AND GREEN<>RED)
		THEN 'BAD'
		ELSE 'WORSE'
	END AS TYPE_OF_COLLECTION
from collection;

-- QUESTION 91
drop table employees;
CREATE TABLE EMPLOYEES1 (
    ID INT PRIMARY KEY,
    NAME VARCHAR(100)
);
CREATE TABLE COMPANY (
    ID INT PRIMARY KEY,
    NAME VARCHAR(100)
);
CREATE TABLE SALARY12 (
    EMPLOYEE_ID INT,
    COMPANY_ID INT,
    SALARY INT,
    FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES1(ID),
    FOREIGN KEY (COMPANY_ID) REFERENCES COMPANY(ID)
);
INSERT INTO EMPLOYEES1 (ID, NAME) VALUES
(1, 'Frances White'),
(2, 'Carolyn Bradley'),
(3, 'Annie Fernandez'),
(4, 'Ruth Hanson'),
(5, 'Paula Fuller'),
(6, 'Bonnie Johnston'),
(7, 'Ruth Gutierrez'),
(8, 'Ernest Thomas'),
(9, 'Joe Garza'),
(10, 'Anne Harris');
INSERT INTO COMPANY (ID, NAME) VALUES
(1, 'PeopleSoft Inc'),
(2, 'Baker Hughes Incorporated'),
(3, 'MDU Resources Group Inc.'),
(4, 'DST Systems, Inc.'),
(5, 'Williams Companies Inc'),
(6, 'Fisher Scientific International Inc.'),
(7, 'Emcor Group Inc.'),
(8, 'Genuine Parts Company'),
(9, 'MPS Group Inc.'),
(10, 'Novellus Systems Inc');

INSERT INTO SALARY12 (EMPLOYEE_ID, COMPANY_ID, SALARY) VALUES
(2, 4, 27779),
(2, 9, 36330),
(3, 9, 71466),
(3, 10, 22804),
(5, 5, 49892),
(6, 4, 31493),
(6, 10, 26888),
(7, 3, 87118),
(7, 7, 70767),
(7, 9, 39929);

select c.name
	from employees1 e
	JOIN salary12 s ON e.id=s.employee_id
	JOIN company c ON c.id=s.company_id
	GROUP BY c.name
	HAVING AVG(s.salary)>40000;

-- question 92
select distinct p.name,
	c.name from schedule s 
	JOIN professors p ON p.id=s.professor_id 
	JOIN course c ON c.id=s.course_id;

-- question 93
CREATE TABLE DEPARTMENTS (
    ID INT PRIMARY KEY,
    NAME VARCHAR(100)
);
CREATE TABLE PROFESSORS (
    ID INT PRIMARY KEY,
    NAME VARCHAR(100),
    DEPARTMENT_ID INT,
    SALARY INT,
    FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS(ID)
);
CREATE TABLE COURSE (
    ID INT PRIMARY KEY,
    NAME VARCHAR(100),
    DEPARTMENT_ID INT,
    CREDITS INT,
    FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS(ID)
);

CREATE TABLE SCHEDULE (
    PROFESSOR_ID INT,
    COURSE_ID INT,
    SEMESTER INT,
    YEAR INT,
    FOREIGN KEY (PROFESSOR_ID) REFERENCES PROFESSORS(ID),
    FOREIGN KEY (COURSE_ID) REFERENCES COURSE(ID)
);
INSERT INTO DEPARTMENTS (ID, NAME) VALUES
(3, 'Biological Sciences'),
(5, 'Technology'),
(6, 'Humanities & Social Sciences'),
(2, 'Clinical Medicine'),
(4, 'Arts and Humanities'),
(1, 'Physical Sciences');
INSERT INTO PROFESSORS (ID, NAME, DEPARTMENT_ID, SALARY) VALUES
(1, 'Alex Burton', 5, 7340),
(8, 'Jordan Diaz', 1, 17221),
(9, 'Drew Hicks', 5, 16613),
(2, 'Tyler Matthews', 2, 14521),
(10, 'Blake Foster', 4, 28526),
(3, 'Spencer Peters', 1, 10487),
(4, 'Ellis Marshall', 3, 6353),
(7, 'Morgan Lee', 2, 25796),
(5, 'Riley Peterson', 1, 35678),
(6, 'Peyton Fields', 5, 26648);
INSERT INTO COURSE (ID, NAME, DEPARTMENT_ID, CREDITS) VALUES
(9, 'Clinical Biochemistry', 2, 3),
(4, 'Astronomy', 1, 6),
(10, 'Clinical Neuroscience', 2, 5),
(1, 'Pure Mathematics and Mathematical Statistics', 1, 3),
(6, 'Geography', 1, 7),
(8, 'Chemistry', 1, 1),
(5, 'Physics', 1, 8),
(3, 'Earth Science', 1, 7),
(7, 'Materials Science and Metallurgy', 1, 5),
(2,' Applied Mathematics and Theoretical Physics',1,5);  -- Credits not provided
INSERT INTO SCHEDULE (PROFESSOR_ID, COURSE_ID, SEMESTER, YEAR) VALUES
(5, 3, 6, 2012),
(7, 3, 1, 2013),
(5, 7, 6, 2010),
(2, 10, 2, 2004),
(5, 1, 1, 2011),
(2, 9, 4, 2005),
(7, 10, 6, 2009),
(5, 6, 4, 2007),
(7, 9, 1, 2014),
(9, 9, 5, 2011);

select 
	p.name,
	c.name
	from professors p
	JOIN SCHEDULE s ON p.id=s.professor_id
	JOIN course c ON c.id=s.course_id
	GROUP BY p.name,c.name;

-- question 94
CREATE TABLE DEPARTMENT (
    ID INT PRIMARY KEY,
    NAME VARCHAR(100)
);
CREATE TABLE PROFESSOR (
    ID INT PRIMARY KEY,
    NAME VARCHAR(100),
    DEPARTMENT_ID INT,
    SALARY INT,
    FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENT(ID)
);
INSERT INTO DEPARTMENT (ID, NAME) VALUES
(3, 'Biological Sciences'),
(5, 'Technology'),
(6, 'Humanities & Social Sciences'),
(2, 'Clinical Medicine'),
(4, 'Arts and Humanities'),
(1, 'Physical Sciences');
INSERT INTO PROFESSOR (ID, NAME, DEPARTMENT_ID, SALARY) VALUES
(1, 'Shauna Rivera', 1, 22606),
(8, 'Ruth Price', 3, 9287),
(9, 'Julie Gonzalez', 4, 18870),
(2, 'Craig Elliott', 5, 27524),
(10, 'Scott Butler', 1, 26200),
(3, 'Nancy Russell', 2, 7076);

select p.name,
	p.salary
	from professor p
	JOIN department d ON d.id=p.department_id
	WHERE d.name<>'Arts and Humanities'
	AND p.salary>(
		select MIN(p.salary) from professor p
		JOIN department d ON d.id=p.department_id
		WHERE d.name='Arts and Humanities'
	)
GROUP BY p.name,p.salary
ORDER BY p.salary;

-- question 95
CREATE TABLE STUDENTS (
    STUDENT_ID INT PRIMARY KEY,
    STUDENT_NAME VARCHAR(50),
    STUDENT_AGE INT
);
CREATE TABLE MAJORS (
    MAJOR_ID INT PRIMARY KEY,
    MAJOR_NAME VARCHAR(50)
);
CREATE TABLE REGISTER (
    STUDENT_ID INT,
    MAJOR_ID INT,
    FOREIGN KEY (STUDENT_ID) REFERENCES STUDENTS(STUDENT_ID),
    FOREIGN KEY (MAJOR_ID) REFERENCES MAJORS(MAJOR_ID)
);
INSERT INTO STUDENTS (STUDENT_ID, STUDENT_NAME, STUDENT_AGE) VALUES
(1, 'John', 20),
(2, 'Masie', 21),
(3, 'Harry', 21);
INSERT INTO MAJORS (MAJOR_ID, MAJOR_NAME) VALUES
(1000, 'Computer Science'),
(2000, 'Biology'),
(3000, 'Physics');
INSERT INTO REGISTER (STUDENT_ID, MAJOR_ID) VALUES
(2, 1000),
(3, 3000),
(1, 2000);

select s.student_name,
	m.major_name
	from students s
	JOIN register r ON s.student_id=r.student_id
	JOIN majors m ON m.major_id=r.major_id
	GROUP BY s.student_name,m.major_name
	LIMIT 20;

-- question 96
CREATE TABLE STUDENT1 (
    ID INT PRIMARY KEY,
    AGE INT,
    SCORE INT
);
INSERT INTO STUDENT1 (ID, AGE, SCORE) VALUES(1, 19, 91),(2, 20, 90),(3, 20, 87),(4, 21, 72),(5, 19, 98),(6, 20, 50);
select * from student1
	ORDER BY id
	LIMIT 1 OFFSET 2;

-- question 97
CREATE TABLE EMPLOYEE23 (
    NAME VARCHAR(50),
    PHONE VARCHAR(15),
    AGE INT
);
INSERT INTO EMPLOYEE23 (NAME, PHONE, AGE) VALUES
('Sam', '1000040000', 30),
('Alex', '1000020000', 60),
('Alex', '1000020012', 65),
('Sam', '1000040000', 30),
('Chris', '1000012000', 34),
('Chris', '1000012000', 34);

select name
	from employee23
	GROUP BY name,phone,age
	HAVING COUNT(*)>1;

-- question 98
drop table transactions;
CREATE TABLE transactions12 (
    dt VARCHAR(19),
    customer VARCHAR(64),
    debit DECIMAL(5,2),
    credit DECIMAL(5,2)
);
INSERT INTO transactions12 (dt, customer, debit, credit) VALUES
('2021-11-30 12:48:22', 'Arney Cuff', 6.43, 16.12),
('2021-12-25 19:00:46', 'Arney Cuff', 97.78, 12.53),
('2021-11-27 21:34:24', 'Donaugh Furneaux', 89.71, 85.04),
('2021-11-15 07:31:37', 'Ferrell Brunn', 63.58, 28.58),
('2021-11-25 15:30:56', 'Gibbie Jurisic', 25.81, 13.75),
('2021-11-21 00:09:50', 'Harley Lyddiard', 57.49, 7.11),
('2021-12-01 07:37:42', 'Harley Lyddiard', 48.33, 82.35),
('2021-12-02 13:08:52', 'Harley Lyddiard', 12.13, 63.81),
('2021-11-24 03:51:13', 'Kippy Jelly', 50.34, 12.91),
('2021-12-04 10:11:40', 'Latrina Jackman', 10.73, 39.51),
('2021-12-02 13:02:50', 'Latrina Jackman', 5.35, 96.74),
('2022-10-17 13:44:00', 'Latrina Jackman', 54.99, 92.73),
('2012-10-30 14:43:00', 'Maribel Braim', 57.02, 9.61),
('2012-10-20 09:57:00', 'Orrin Curley', 65.44, 51.31),
('2012-10-14 19:57:25', 'Orrin Curley', 84.14, 96.44),
('2010-10-09 20:28:21', 'Rasla Venny', 80.33, 20.69);

select customer,
	ROUND(SUM(debit)-sum(credit),2) AS balance
	from transactions12 
	WHERE dt LIKE '%-12-%'
	GROUP BY customer
	ORDER BY customer;

