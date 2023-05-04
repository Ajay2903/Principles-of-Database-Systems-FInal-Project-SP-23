-- Create the database (if it doesn't already exist)
CREATE DATABASE IF NOT EXISTS sqlscript;

-- Select the database to use
USE sqlscript;

DROP TABLE IF EXISTS att_tick,
                     attractions,
                     card,
                     menuitems,
                     orders,
                     parking,
                     payments,
                     shows,
                     storcategories,
                     stores,
                     ticket,
                     visitors;


CREATE TABLE attractions (
attraction_id INT(10) NOT NULL,
attraction_name VARCHAR(50) NOT NULL,
description VARCHAR(100) NOT NULL,
attraction_type VARCHAR(50) NOT NULL,
status VARCHAR(20) NOT NULL,
capacity INT(3) NOT NULL,
minimunheight DECIMAL(5, 2) NOT NULL,
duration TIME NOT NULL,
location_section VARCHAR(10) NOT NULL,
PRIMARY KEY (attraction_id)

);


CREATE TABLE payments (
payment_id INT(10) NOT NULL,
payment_method VARCHAR(15) NOT NULL,
payment_date DATE NOT NULL,
payment_amount DECIMAL(5, 2) NOT NULL,
PRIMARY KEY (payment_id)

);
CREATE TABLE card (
payment_id INT(10) NOT NULL,
fname_on_card VARCHAR(20) NOT NULL,
card_type VARCHAR(10) NOT NULL,
card_number BIGINT(16) NOT NULL,
exparation_date DATE NOT NULL,
cvvnumber INT(3) NOT NULL,
lname_on_card VARCHAR(20) NOT NULL,
PRIMARY KEY (payment_id),
FOREIGN KEY(payment_id) REFERENCES payments(payment_id)
);


CREATE TABLE storcategories (
cat_id INT(10) NOT NULL,
category VARCHAR(20) NOT NULL,
PRIMARY KEY (cat_id)
);

CREATE TABLE stores (
store_id INT(10) NOT NULL,
store_name VARCHAR(30) NOT NULL,
storcategories_cat_id INT(10) NOT NULL,
PRIMARY KEY (store_id),
FOREIGN KEY (storcategories_cat_id)
        REFERENCES storcategories(cat_id)
);

CREATE TABLE menuitems (
menuitem_id INT(10) NOT NULL,
description VARCHAR(50) NOT NULL,
unitprice DECIMAL(5, 2) NOT NULL,
stores_store_id INT(10) NOT NULL,
PRIMARY KEY (menuitem_id),
FOREIGN KEY (stores_store_id)
        REFERENCES stores(store_id)
);

CREATE TABLE ticket (
ticket_id INT(10) NOT NULL,
ticket_method VARCHAR(10) NOT NULL,
ticket_purchase_date DATE NOT NULL,
ticket_visit_date DATE NOT NULL,
discount DECIMAL(5, 2) NOT NULL,
ticket_price DECIMAL(5, 2) NOT NULL,
ticket_type VARCHAR(10) NOT NULL,
orders_order_id INT(10) NOT NULL,
PRIMARY KEY (ticket_id)

);

CREATE TABLE att_tick (
ticket_visit_date DATE NOT NULL,
ticket_ticket_id INT(10) NOT NULL,
attractions_attraction_id INT(10) NOT NULL,
FOREIGN KEY(attractions_attraction_id) REFERENCES attractions(attraction_id),
FOREIGN KEY(ticket_ticket_id) REFERENCES ticket(ticket_id)

);

CREATE TABLE visitors (
visitor_id INT(10) NOT NULL,
visitor_fname VARCHAR(20) NOT NULL,
visitor_email_address VARCHAR(20) NOT NULL,
visitor_phone_number BIGINT(12) NOT NULL,
visitor_dob DATE NOT NULL,
visitor_type VARCHAR(10) NOT NULL,
visitor_lname VARCHAR(10) NOT NULL,
address_street VARCHAR(50),
zipcode INT(5) NOT NULL,
address_city VARCHAR(20),
address_state VARCHAR(2),
PRIMARY KEY (visitor_id)
);
CREATE TABLE orders (
order_id INT(10) NOT NULL,
order_date DATE NOT NULL,
quantity INT(3) NOT NULL,
visitors_visitor_id INT(10) NOT NULL,
stores_store_id INT(10) NOT NULL,
payments_payment_id INT(10) NOT NULL,
PRIMARY KEY (order_id),
FOREIGN KEY (payments_payment_id)
        REFERENCES payments(payment_id),
FOREIGN KEY (stores_store_id)
        REFERENCES stores(store_id),
FOREIGN KEY (visitors_visitor_id)
        REFERENCES visitors(visitor_id)
);

CREATE TABLE parking (
parking_id INT(10) NOT NULL,
parking_lot VARCHAR(1) NOT NULL,
spot_number INT(3) NOT NULL,
time_in TIME NOT NULL,
time_out TIME NOT NULL,
fee DECIMAL(5, 2) NOT NULL,
orders_order_id INT(10),
PRIMARY KEY (parking_id),
FOREIGN KEY (orders_order_id)
        REFERENCES orders(order_id)
);
CREATE TABLE shows (
show_id INT(10) NOT NULL,
show_name VARCHAR(50) NOT NULL,
description VARCHAR(100) NOT NULL,
show_type VARCHAR(10) NOT NULL,
start_time TIME NOT NULL,
end_time TIME NOT NULL,
wheelchair_accessible VARCHAR(1) NOT NULL,
price DECIMAL(5, 2) NOT NULL,
visits_visit_id INT NOT NULL,
orders_order_id INT(10),
PRIMARY KEY (show_id),
FOREIGN KEY (orders_order_id)
        REFERENCES orders(order_id)
);
ALTER TABLE VISITORS ADD CONSTRAINT C_VISITOR_TYPE CHECK
(VISITOR_TYPE IN ('Individual','Group','Member', 'Student'));
ALTER TABLE ATTRACTIONS ADD CONSTRAINT C_STATUS CHECK (STATUS IN
('Open', 'Closed', 'Under Maintenance'));
ALTER TABLE SHOWS ADD CONSTRAINT C_SHOW_TYPE CHECK (SHOW_TYPE IN
('Drama', 'Musical', 'Comedy', 'Horror', 'Adventure'));
ALTER TABLE STORCATEGORIES ADD CONSTRAINT C_CATEGORY CHECK
(CATEGORY IN ('Food Stall', 'Ice Cream Parlor', 'Restaurant', 'Gift Shop', 'Apparels'));
ALTER TABLE PAYMENTS ADD CONSTRAINT C_PAYMENT_METHOD CHECK
(PAYMENT_METHOD IN ('Cash', 'Credit Card', 'Debit Card'));
ALTER TABLE TICKET ADD CONSTRAINT C_TICKET_METHOD CHECK
(TICKET_METHOD IN ('Online', 'Onsite'));
ALTER TABLE TICKET ADD CONSTRAINT C_TICKET_TYPE CHECK (TICKET_TYPE
IN ('Child', 'Adult', 'Senior', 'Member'));

DELIMITER $$

CREATE TRIGGER ApplyOnlineDiscount
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
    IF NEW.ticket_method = 'Online' THEN
        SET NEW.discount = NEW.discount + 5;
    END IF;
END$$

CREATE TRIGGER ApplyMemberDiscount
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
    DECLARE ticketCount INT;
    IF NEW.ticket_type = 'Member' THEN
        SELECT COUNT(*) INTO ticketCount FROM ticket WHERE orders_order_id = NEW.orders_order_id AND ticket_type = 'Member';
        IF ticketCount < 5 THEN
            SET NEW.discount = NEW.discount + 10;
        END IF;
    END IF;
END$$



CREATE TRIGGER UpdateTicketPrice
BEFORE INSERT ON ticket
FOR EACH ROW
BEGIN
    SET NEW.ticket_price = NEW.ticket_price * (1 - (NEW.discount / 100));
END$$

DELIMITER ;

INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0001, 'John', 'john@email.com', 1234567890, '1968-03-22', 'Individual', 'Doe', '123 Main St', 12345, 'New York', 'NY');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0002, 'Jane', 'jane@email.com', 2345678901, '1974-04-10', 'Group', 'Smith', '456 Elm St', 67890, 'Los Angeles', 'CA');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0003, 'Theo', 'Theo@email.com', 3245678901, '1974-05-22', 'Group', 'Smith', '456 Elm St', 67890, 'Los Angeles', 'CA');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0004, 'Tim', 'Tim@email.com', 2435678901, '2018-03-22', 'Group', 'Smith', '456 Elm St', 67890, 'Los Angeles', 'CA');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0005, 'Alice', 'alice@email.com', 3456789012, '2014-03-21', 'Member', 'Johnson', '789 Pine St', 24680, 'Chicago', 'IL');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0006, 'Bob', 'bob@email.com', 4567890123, '1999-03-22', 'Student', 'Brown', '321 Oak St', 86420, 'Houston', 'TX');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0007, 'Eve', 'eve@email.com', 5678901234, '1999-04-22', 'Student', 'Jones', '654 Cedar St', 48260, 'Philadelphia', 'PA');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0008, 'Frank', 'frank@email.com', 6789012345, '1960-03-22', 'Individual', 'Williams', '987 Walnut St', 13579, 'Phoenix', 'AZ');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0009, 'Grace', 'grace@email.com', 7890123456, '1998-03-22', 'Member', 'Davis', '147 Maple St', 97531, 'San Antonio', 'TX');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0010, 'Hank', 'hank@email.com', 8901234567, '1999-08-22', 'Student', 'Miller', '258 Cherry St', 86421, 'San Diego', 'CA');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0011, 'Iris', 'iris@email.com', 9012345678, '1999-08-22', 'Individual', 'Wilson', '369 Birch St', 75315, 'Dallas', 'TX');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0012, 'Jack', 'jack@email.com', 0123456789, '2023-03-22', 'Group', 'Moore', '741 Hickory St', 95173, 'San Jose', 'CA');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0013, 'Jack', 'jack@email.com', 0123456789, '2023-03-22', 'Group', 'Moore', '741 Hickory St', 95173, 'San Jose', 'CA');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0014, 'Jack', 'jack@email.com', 0123456789, '2023-03-22', 'Group', 'Moore', '741 Hickory St', 95173, 'San Jose', 'CA');
INSERT INTO VISITORS (VISITOR_ID, Visitor_Fname, Visitor_Email_address, Visitor_Phone_number, Visitor_DOB, Visitor_TYPE, Visitor_Lname, Address_Street, Zipcode, Address_city, Address_state) VALUES (0015, 'Jack', 'jack@email.com', 0123456789, '2023-03-22', 'Group', 'Moore', '741 Hickory St', 95173, 'San Jose', 'CA');

INSERT INTO storcategories (cat_id, category) VALUES (1, 'Food Stall');
INSERT INTO storcategories (cat_id, category) VALUES (2, 'Ice Cream Parlor');
INSERT INTO storcategories (cat_id, category) VALUES (3, 'Restaurant');
INSERT INTO storcategories(cat_id, category) VALUES (4, 'Gift Shop');
INSERT INTO storcategories (cat_id, category) VALUES (5, 'Apparels');

INSERT INTO stores (store_id, store_name, storcategories_cat_id) VALUES (1, 'Burger Shack',
1);
INSERT INTO stores (store_id, store_name, storcategories_cat_id) VALUES (2, 'Cold Delights',
2);
INSERT INTO stores (store_id, store_name, storcategories_cat_id) VALUES (3, 'The Fancy
Fork', 3);
INSERT INTO stores (store_id, store_name, storcategories_cat_id) VALUES (4, 'Treasure
Trove', 4);
INSERT INTO stores (store_id, store_name, storcategories_cat_id) VALUES (5, 'Stylish
Threads', 5);
INSERT INTO stores (store_id, store_name, storcategories_cat_id) VALUES (6, 'Pizza Palace',
1);
INSERT INTO stores (store_id, store_name, storcategories_cat_id) VALUES (7, 'Sweet
Sensations', 2);
INSERT INTO stores (store_id, store_name, storcategories_cat_id) VALUES (8, 'Sushi Central',
3);
INSERT INTO stores (store_id, store_name, storcategories_cat_id) VALUES (9, 'Toy Box', 4);
INSERT INTO stores (store_id, store_name, storcategories_cat_id) VALUES (10, 'Trendy
Trinkets', 5);

INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (1, 'Roller Rush', 'Exciting roller
coaster ride', 'roller_coaster', 'Open', 24, 1.2, '00:02:30', 'Lot A');
INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (2, 'Water Whirl', 'Fun water
slide adventure', 'water_ride', 'Open', 30, 1.0, '00:01:30',  'Lot B');
INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (3, 'Mystery Manor', 'Spooky
dark ride', 'dark_ride', 'Under Maintenance', 12, 1.1, '00:03:00',  'Lot
C');
INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (4, 'Kiddie Kingdom', 'Play area
for young children', 'kid_ride', 'Open', 100, 0.6, '00:00:30',  'Lot D');
INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (5, 'Sky High', 'Towering swing
ride', 'swing_ride', 'Open', 16, 1.3, '00:01:00', 'Lot A');
INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (6, 'Tunnel of Terror', 'Scary
roller coaster', 'roller_coaster', 'Open', 20, 1.2, '00:02:45',  'Lot E');
INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (7, 'Lazy River', 'Relaxing water
ride', 'water_ride', 'Open', 50, 0.9, '00:08:00',  'Lot F');
INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (8, 'Dino Dash', 'Family roller
coaster', 'roller_coaster', 'Open', 18, 1.0, '00:01:45',  'Lot G');
INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (9, 'Twister Tower', 'Thrilling
drop tower', 'drop_ride', 'Open', 12, 1.3, '00:01:20',  'Lot H');
INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (10, 'Wacky Wheels','Family-friendly bumper cars',
 'car_ride', 'Open', 16, 1.0, '00:02:00', 'Lot I');
INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (11, 'Carousel Cove', 'Classic
carousel ride', 'carousel_ride', 'Open', 30, 0.9, '00:01:30',  'Lot J');
INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (12, 'Pirate Plunge',
'Swashbuckling water slide', 'water_ride', 'Open', 20, 1.0, '00:01:15', 
'Lot K');
INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (13, 'Galactic Adventure',
'Space-themed roller coaster', 'roller_coaster', 'Open', 24, 1.2, '00:02:30',
 'Lot L');
INSERT INTO attractions (attraction_id, attraction_name, description, attraction_type, status,
capacity, minimunHeight, duration, location_section) VALUES (14, 'Jungle Cruise', 'Boat ride
through the jungle', 'water_ride', 'Closed', 20, 1.0, '00:05:00',  'Lot
L');

INSERT INTO menuitems (MenuItem_ID, Description, UnitPrice,stores_store_ID) VALUES (1,
'Cheeseburger', 5.99,1);
INSERT INTO menuitems (MenuItem_ID, Description, UnitPrice,stores_store_ID) VALUES (2,
'Veggie Burger', 5.49,1);
INSERT INTO menuitems (MenuItem_ID, Description, UnitPrice,stores_store_ID) VALUES (3,
'Vanilla Cone', 2.99,2);
INSERT INTO menuitems (MenuItem_ID, Description, UnitPrice,stores_store_ID) VALUES (4,
'Chocolate Sundae', 3.99,2);
INSERT INTO menuitems (MenuItem_ID, Description, UnitPrice,stores_store_ID) VALUES (5,
'Grilled Chicken', 12.99,3);
INSERT INTO menuitems (MenuItem_ID, Description, UnitPrice,stores_store_ID) VALUES (6,
'Pasta Alfredo', 10.99,3);
INSERT INTO menuitems (MenuItem_ID, Description, UnitPrice,stores_store_ID) VALUES (7,
'Stuffed Toy', 9.99,9);
INSERT INTO menuitems (MenuItem_ID, Description, UnitPrice,stores_store_ID) VALUES (8,
'T-shirt', 14.99,10);
INSERT INTO menuitems (MenuItem_ID, Description, UnitPrice,stores_store_ID) VALUES (9,
'Cap', 8.99,10);
INSERT INTO menuitems (MenuItem_ID, Description, UnitPrice,stores_store_ID) VALUES
(10, 'Socks', 4.99,10);

INSERT INTO payments (payment_id, payment_date, payment_amount, payment_method)
VALUES (1, '2023-03-22', 55, 'Credit Card');
INSERT INTO payments (payment_id, payment_date, payment_amount, payment_method)
VALUES (2, '2023-03-23', 45, 'Credit Card');
INSERT INTO payments (payment_id, payment_date, payment_amount, payment_method)
VALUES (3, STR_TO_DATE('2023-04-02', '%Y-%m-%d'), 25, 'Cash');
INSERT INTO payments (payment_id, payment_date, payment_amount, payment_method)
VALUES (4, STR_TO_DATE('2023-04-02', '%Y-%m-%d'), 15, 'Cash');
INSERT INTO payments (payment_id, payment_date, payment_amount, payment_method)
VALUES (5, STR_TO_DATE('2023-04-03', '%Y-%m-%d'), 10, 'Debit Card');
INSERT INTO payments (payment_id, payment_date, payment_amount, payment_method)
VALUES (6, STR_TO_DATE('2023-04-03', '%Y-%m-%d'), 50, 'Credit Card');
INSERT INTO payments (payment_id, payment_date, payment_amount, payment_method)
VALUES (7, STR_TO_DATE('2023-04-04', '%Y-%m-%d'), 55, 'Debit Card');
INSERT INTO payments (payment_id, payment_date, payment_amount, payment_method)
VALUES (8, STR_TO_DATE('2023-04-04', '%Y-%m-%d'), 55, 'Debit Card');
INSERT INTO payments (payment_id, payment_date, payment_amount, payment_method)
VALUES (9, STR_TO_DATE('2023-04-02', '%Y-%m-%d'), 105, 'Cash');
INSERT INTO payments (payment_id, payment_date, payment_amount, payment_method)
VALUES (10, STR_TO_DATE('2023-04-02', '%Y-%m-%d'), 95, 'Credit Card');

INSERT INTO CARD (payment_id, FName_on_Card, LName_on_Card, Card_type,
Card_Number, exparation_date, CVVNumber)
VALUES
(1, 'John', 'Doe', 'Debit', 1000200030004000, STR_TO_DATE('2028-04-02', '%Y-%m-%d'), 001);
INSERT INTO CARD (payment_id, FName_on_Card, LName_on_Card, Card_type,
Card_Number, exparation_date, CVVNumber)
VALUES (2, 'Jane', 'Smith', 'Credit', 1000300020004000, STR_TO_DATE('2028-04-03', '%Y-%m-%d'), 002);
INSERT INTO CARD (payment_id, FName_on_Card, LName_on_Card, Card_type,
Card_Number, exparation_date, CVVNumber)
VALUES (3, 'Alice', 'Johnson', 'Debit', 1100200030004000, STR_TO_DATE('2028-04-04', '%Y-%m-%d'), 003);
INSERT INTO CARD (payment_id, FName_on_Card, LName_on_Card, Card_type,
Card_Number, exparation_date, CVVNumber)
VALUES (4, 'Bob', 'Brown', 'Credit', 1200200030004000, STR_TO_DATE('2028-04-05', '%Y-%m-%d'), 004);
INSERT INTO CARD (payment_id, FName_on_Card, LName_on_Card, Card_type,
Card_Number, exparation_date, CVVNumber)
VALUES (5, 'Eve', 'Jones', 'Debit', 1000200030004400, STR_TO_DATE('2028-04-06', '%Y-%m-%d'), 005);
INSERT INTO CARD (payment_id, FName_on_Card, LName_on_Card, Card_type,
Card_Number, exparation_date, CVVNumber)
VALUES (6, 'Frank', 'Williams', 'Credit', 1000200033004000, STR_TO_DATE('2028-04-07', '%Y-%m-%d'), 006);
INSERT INTO CARD (payment_id, FName_on_Card, LName_on_Card, Card_type,
Card_Number, exparation_date, CVVNumber)
VALUES (7, 'Grace', 'Davis', 'Debit', 1000220030004000, STR_TO_DATE('2028-04-08', '%Y-%m-%d'), 007);

INSERT INTO TICKET (ticket_id, Ticket_Method, Ticket_Purchase_Date, Ticket_visit_date, Discount, Ticket_price, Ticket_Type, ORDERS_Order_ID)
VALUES (1, 'Online', STR_TO_DATE('2023-03-16', '%Y-%m-%d'), STR_TO_DATE('2023-04-16', '%Y-%m-%d'), 0.05, 95, 'Adult', 1);

INSERT INTO TICKET (ticket_id, Ticket_Method, Ticket_Purchase_Date, Ticket_visit_date, Discount, Ticket_price, Ticket_Type, ORDERS_Order_ID)
VALUES (2, 'Onsite', STR_TO_DATE('2023-03-16', '%Y-%m-%d'), STR_TO_DATE('2023-04-16', '%Y-%m-%d'), 0, 100, 'Adult', 2);

INSERT INTO TICKET (ticket_id, Ticket_Method, Ticket_Purchase_Date, Ticket_visit_date, Discount, Ticket_price, Ticket_Type, ORDERS_Order_ID)
VALUES (3, 'Online', STR_TO_DATE('2023-03-16', '%Y-%m-%d'), STR_TO_DATE('2023-04-16', '%Y-%m-%d'), 0.05, 95, 'Adult', 3);

INSERT INTO TICKET (ticket_id, Ticket_Method, Ticket_Purchase_Date, Ticket_visit_date, Discount, Ticket_price, Ticket_Type, ORDERS_Order_ID)
VALUES (4, 'Onsite', STR_TO_DATE('2023-03-16', '%Y-%m-%d'), STR_TO_DATE('2023-04-16', '%Y-%m-%d'), 0.15, 85, 'child', 3);

INSERT INTO TICKET (ticket_id, Ticket_Method, Ticket_Purchase_Date, Ticket_visit_date, Discount, Ticket_price, Ticket_Type, ORDERS_Order_ID)
VALUES (5, 'Onsite', STR_TO_DATE('2023-03-16', '%Y-%m-%d'), STR_TO_DATE('2023-04-16', '%Y-%m-%d'), 0, 100, 'Adult', 4);

INSERT INTO TICKET (ticket_id, Ticket_Method, Ticket_Purchase_Date, Ticket_visit_date, Discount, Ticket_price, Ticket_Type, ORDERS_Order_ID)
VALUES (6, 'Online', STR_TO_DATE('2023-03-16', '%Y-%m-%d'), STR_TO_DATE('2023-04-16', '%Y-%m-%d'), 0.05, 95, 'Adult', 5);

INSERT INTO TICKET (ticket_id, Ticket_Method, Ticket_Purchase_Date, Ticket_visit_date, Discount, Ticket_price, Ticket_Type, ORDERS_Order_ID)
VALUES (7, 'Online', STR_TO_DATE('2023-03-16', '%Y-%m-%d'), STR_TO_DATE('2023-04-16', '%Y-%m-%d'), 0.05, 95, 'Adult', 6);

INSERT INTO TICKET (ticket_id, Ticket_Method, Ticket_Purchase_Date, Ticket_visit_date, Discount, Ticket_price, Ticket_Type, ORDERS_Order_ID)
VALUES (8, 'Online', STR_TO_DATE('2023-03-16', '%Y-%m-%d'), STR_TO_DATE('2023-04-16', '%Y-%m-%d'), 0.15, 85, 'Senior', 7);

INSERT INTO TICKET (ticket_id, Ticket_Method, Ticket_Purchase_Date, Ticket_visit_date, Discount, Ticket_price, Ticket_Type, ORDERS_Order_ID)
VALUES (9, 'Online', STR_TO_DATE('2023-03-16', '%Y-%m-%d'), STR_TO_DATE('2023-04-16', '%Y-%m-%d'), 0.15, 85, 'Member', 8);

INSERT INTO TICKET (ticket_id, Ticket_Method, Ticket_Purchase_Date, Ticket_visit_date, Discount, Ticket_price, Ticket_Type, ORDERS_Order_ID)
VALUES (10, 'Online', STR_TO_DATE('2023-03-16', '%Y-%m-%d'), STR_TO_DATE('2023-04-16', '%Y-%m-%d'), 0.5, 95, 'Adult', 9);



INSERT INTO ATT_TICK (ticket_visit_date, TICKET_ticket_ID, attractions_attraction_ID)
VALUES (STR_TO_DATE('2023-04-08', '%Y-%m-%d'), 1, 1);
INSERT INTO ATT_TICK (ticket_visit_date, TICKET_ticket_ID, attractions_attraction_ID)
VALUES (STR_TO_DATE('2023-04-09', '%Y-%m-%d'), 2, 2);
INSERT INTO ATT_TICK (ticket_visit_date, TICKET_ticket_ID, attractions_attraction_ID)
VALUES (STR_TO_DATE('2023-04-10', '%Y-%m-%d'), 3, 3);
INSERT INTO ATT_TICK (ticket_visit_date, TICKET_ticket_ID, attractions_attraction_ID)
VALUES (STR_TO_DATE('2023-04-11', '%Y-%m-%d'), 4, 4);
INSERT INTO ATT_TICK (ticket_visit_date, TICKET_ticket_ID, attractions_attraction_ID)
VALUES (STR_TO_DATE('2023-04-12', '%Y-%m-%d'), 5, 5);
INSERT INTO ATT_TICK (ticket_visit_date, TICKET_ticket_ID, attractions_attraction_ID)
VALUES (STR_TO_DATE('2023-04-13', '%Y-%m-%d'), 6, 6);
INSERT INTO ATT_TICK (ticket_visit_date, TICKET_ticket_ID, attractions_attraction_ID)
VALUES (STR_TO_DATE('2023-04-14', '%Y-%m-%d'), 7, 7);
INSERT INTO ATT_TICK (ticket_visit_date, TICKET_ticket_ID, attractions_attraction_ID)
VALUES (STR_TO_DATE('2023-04-15', '%Y-%m-%d'), 8, 8);
INSERT INTO ATT_TICK (ticket_visit_date, TICKET_ticket_ID, attractions_attraction_ID)
VALUES (STR_TO_DATE('2023-04-16', '%Y-%m-%d'), 9, 9);

INSERT INTO ORDERS (Order_ID, Order_date, quantity, visitors_visitor_id, STORES_Store_ID, PAYMENTS_Payment_ID)
VALUES
(1, '2023-04-16', 2, 1, 1, 1);
INSERT INTO ORDERS (Order_ID, Order_date, quantity, visitors_visitor_id, STORES_Store_ID, PAYMENTS_Payment_ID)
VALUES
(2, '2023-04-16', 3, 2, 2, 2);
INSERT INTO ORDERS (Order_ID, Order_date, quantity, visitors_visitor_id, STORES_Store_ID, PAYMENTS_Payment_ID)
VALUES
(3, '2023-04-16', 4, 2, 2, 2);
INSERT INTO ORDERS (Order_ID, Order_date, quantity, visitors_visitor_id, STORES_Store_ID, PAYMENTS_Payment_ID)
VALUES
(4, '2023-04-16', 5, 3, 3, 3);
INSERT INTO ORDERS (Order_ID, Order_date, quantity, visitors_visitor_id, STORES_Store_ID, PAYMENTS_Payment_ID)
VALUES
(5, '2023-04-16', 6, 4, 4, 4);
INSERT INTO ORDERS (Order_ID, Order_date, quantity, visitors_visitor_id, STORES_Store_ID, PAYMENTS_Payment_ID)
VALUES
(6, '2023-04-16', 2, 5, 5, 5);
INSERT INTO ORDERS (Order_ID, Order_date, quantity, visitors_visitor_id, STORES_Store_ID, PAYMENTS_Payment_ID)
VALUES
(7, '2023-04-16', 3, 6, 6, 6);
INSERT INTO ORDERS (Order_ID, Order_date, quantity, visitors_visitor_id, STORES_Store_ID, PAYMENTS_Payment_ID)
VALUES
(8, '2023-04-16', 4, 7, 7, 7);
INSERT INTO ORDERS (Order_ID, Order_date, quantity, visitors_visitor_id, STORES_Store_ID, PAYMENTS_Payment_ID)
VALUES
(9, '2023-04-16', 5, 8, 8, 8);
INSERT INTO ORDERS (Order_ID, Order_date, quantity, visitors_visitor_id, STORES_Store_ID, PAYMENTS_Payment_ID)
VALUES
(10, '2023-04-16', 6, 9, 9, 9);

INSERT INTO SHOWS (show_id, show_name, description, show_type, start_time, end_time,
wheelchair_accessible, visits_visit_id, price) VALUES (1, 'Dancing Fountains', 'Synchronized
water', 'Comedy', '14:00:00', '14:30:00',
'Y', 1, 7.50);
INSERT INTO SHOWS (show_id, show_name, description, show_type, start_time, end_time,
wheelchair_accessible, visits_visit_id, price) VALUES (2, 'Birds of Paradise', 'Exotic bird show',
'Drama', '12:00:00', '12:45:00', 'N', 2,
8.10);
INSERT INTO SHOWS (show_id, show_name, description, show_type, start_time, end_time,
wheelchair_accessible, visits_visit_id, price) VALUES (3, 'Jungle Rhythms', 'Live music and
dance', 'Musical', '16:00:00', '16:45:00',
'Y', 3, 6.60);
INSERT INTO SHOWS (show_id, show_name, description, show_type, start_time, end_time,
wheelchair_accessible, visits_visit_id, price) VALUES (4, 'Street Parade', 'Parade featuring park
mascots and performers', 'Adventure', '18:00:00',
'18:30:00', 'N', 4, 9.99);
INSERT INTO SHOWS (show_id, show_name, description, show_type, start_time, end_time,
wheelchair_accessible, visits_visit_id, price) VALUES (5, 'Nighttime Spectacular', 'Fireworks
and laser show', 'Horror', '20:00:00', '20:20:00',
'Y', 5, 9.20);

INSERT INTO PARKING(Parking_ID, Parking_Lot , Spot_number, Time_in, Time_out, Fee)
VALUES (1,'A',10, '14:00:00', '19:30:00', 6.52);
INSERT INTO PARKING(Parking_ID, Parking_Lot , Spot_number, Time_in, Time_out, Fee)
VALUES (2,'B',14, '14:01:00', '19:30:00', 7.21);
INSERT INTO PARKING(Parking_ID, Parking_Lot , Spot_number, Time_in, Time_out, Fee)
VALUES (3,'C',18, '14:02:00', '19:30:00', 5.65);
INSERT INTO PARKING(Parking_ID, Parking_Lot , Spot_number, Time_in, Time_out, Fee)
VALUES (4,'B',13, '14:03:00', '19:30:00', 4.98);
INSERT INTO PARKING(Parking_ID, Parking_Lot , Spot_number, Time_in, Time_out, Fee)
VALUES (5,'A',23, '14:04:00', '19:30:00', 9.02);
INSERT INTO PARKING(Parking_ID, Parking_Lot , Spot_number, Time_in, Time_out, Fee)
VALUES (6,'D',11, '14:05:00', '19:30:00', 5.93);
INSERT INTO PARKING(Parking_ID, Parking_Lot , Spot_number, Time_in, Time_out, Fee)
VALUES (7,'C',20, '14:06:00', '19:30:00', 7.77);
INSERT INTO PARKING(Parking_ID, Parking_Lot , Spot_number, Time_in, Time_out, Fee)
VALUES (8,'D',32, '14:00:00', '19:30:00', 8.88);
