-- База данных предназначена для поиса и бронирования жилья для путешествий. Хранит в себе данные о пользователях и различных типах жилья 
-- (отелях, апартаментах и прочее), которые можно забранировать.


DROP DATABASE IF EXISTS booking;
CREATE DATABASE booking ;
USE booking;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100),
 	
	phone BIGINT UNSIGNED UNIQUE, 
	`status` ENUM('Genius 1-го уровня', 'Genius 2-го уровня', 'Genius 3-го уровня') DEFAULT 'Genius 1-го уровня'
	
--   INDEX users_firstname_lastname_idx(firstname, lastname)
) COMMENT 'юзеры';


DROP TABLE IF EXISTS countries;
CREATE TABLE countries (
    country_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    country_name varchar(50) NOT NULL UNIQUE 
);

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
    country_id SMALLINT UNSIGNED NOT NULL,
    region_id INT UNSIGNED NOT NULL,
    state_id INT UNSIGNED NOT NULL,
    city_id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
    city_name varchar(50) NOT NULL,
    
    CONSTRAINT city_loc UNIQUE (region_id, state_id, country_id),
    INDEX city_idx(region_id, state_id, country_id),
    PRIMARY KEY (city_id),
    FOREIGN KEY (country_id) REFERENCES countries  (country_id)
);



DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    birthday DATE,
    gender CHAR(1),
	photo_id BIGINT UNSIGNED ,
    created_at DATETIME DEFAULT NOW(),
    citizenship SMALLINT UNSIGNED,
    hometown MEDIUMINT UNSIGNED,
    adress VARCHAR(100),
    

FOREIGN KEY (user_id) REFERENCES users (id),
FOREIGN KEY (citizenship ) REFERENCES countries  (country_id),
FOREIGN KEY (hometown) REFERENCES cities (city_id)
);

DROP TABLE IF EXISTS `cards`;
CREATE TABLE `cards` (
    card_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	card_num VARCHAR(50) NOT NULL UNIQUE,
	card_type VARCHAR(50) NOT NULL,
    owner_name VARCHAR(100) NOT NULL,
    validity VARCHAR(50) NOT NULL, #срок дейсвия (месяц/год)
    CVC SMALLINT UNSIGNED NOT NULL
) COMMENT 'карты для оплаты бронирования';


DROP TABLE IF EXISTS cards_users;
CREATE TABLE cards_users (
    user_id BIGINT UNSIGNED NOT NULL,
    card_id BIGINT UNSIGNED NOT NULL UNIQUE  

);

ALTER TABLE booking.cards_users
ADD CONSTRAINT cards_users_fk_1 
FOREIGN KEY (user_id) REFERENCES users (id); 

ALTER TABLE booking.cards_users
ADD CONSTRAINT cards_users_fk_2 
FOREIGN KEY (card_id) REFERENCES cards (card_id); 


DROP TABLE IF EXISTS `type_of_housing`;
CREATE TABLE `type_of_housing` (
    id TINYINT NOT NULL PRIMARY KEY, 
    `type` VARCHAR(100) NOT NULL
) COMMENT 'Тип жилья';



DROP TABLE IF EXISTS `hotels`;
CREATE TABLE `hotels` (
	hotel_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	hotel_type TINYINT NOT NULL,
	hotel_name VARCHAR(100),
	country_id SMALLINT UNSIGNED NOT NULL,
	city_id MEDIUMINT UNSIGNED NOT NULL,
	adress VARCHAR(100),
    contact_person VARCHAR(100),
    phone BIGINT UNSIGNED UNIQUE,
    
INDEX hotel_name_idx(hotel_name),
FOREIGN KEY (city_id) REFERENCES cities (city_id),
FOREIGN KEY (hotel_type) REFERENCES type_of_housing (id),
FOREIGN KEY (country_id) REFERENCES countries (country_id)

);


DROP TABLE IF EXISTS `hotel_profile`;
CREATE TABLE `hotel_profile` (
    hotel_id BIGINT UNSIGNED NOT NULL UNIQUE,
    parking ENUM ('да, бесплатно', 'да, платно', 'нет'),
    breakfast ENUM ('да', 'да, по запросу', 'нет'), 
    wifi BIT,
    swimmimg_pool BIT,
    transfer BIT, 
	arrival_time TIME,
    departure_time TIME,
    pay_card BIT,

FOREIGN KEY (hotel_id) REFERENCES hotels (hotel_id) 
    
);


DROP TABLE IF EXISTS `rooms`;
CREATE TABLE `rooms` (
	room_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50),
	room_type ENUM ('одноместный', 'двухместный', 'трехместный', 'четырехместный', 'ЛЮКС', 'Семейный'),
    guests TINYINT NOT NULL COMMENT 'макс. число гостей в номере',
	no_smoking BIT,
    balcon BIT,
    price INT UNSIGNED
);
   

DROP TABLE IF EXISTS hotel_rooms;
CREATE TABLE hotel_rooms  (
    hotel_id BIGINT UNSIGNED NOT NULL,
    room_id BIGINT UNSIGNED NOT NULL UNIQUE,
    room_amount TINYINT NOT NULL  COMMENT 'количество номеров данного типа',
    
FOREIGN KEY (hotel_id) REFERENCES hotels (hotel_id)
ON DELETE CASCADE,
FOREIGN KEY (room_id) REFERENCES rooms (room_id) 
ON DELETE CASCADE
);



DROP TABLE IF EXISTS booking;
CREATE TABLE booking (
    arrival_date DATE NOT NULL,
    depart_date DATE NOT NULL,
   -- quantity_guest TINYINT NOT NULL,
    is_payed BIT NOT NULL,
--     price INT UNSIGNED NOT NULL  COMMENT 'Цена',
    who_booked BIGINT UNSIGNED NOT NULL,
    hotel_booked BIGINT UNSIGNED NOT NULL, 
    room_booked  BIGINT UNSIGNED NOT NULL,

FOREIGN KEY (who_booked) REFERENCES users (id),
FOREIGN KEY (room_booked) REFERENCES hotel_rooms (room_id),
FOREIGN KEY (hotel_booked) REFERENCES hotel_rooms (hotel_id)
);


DROP TABLE IF EXISTS feedback; 
CREATE TABLE feedback (
	
	user_id BIGINT UNSIGNED NOT NULL,
    hotel_id BIGINT UNSIGNED NOT NULL,
    desription TEXT COMMENT 'Описание',
    evaluation ENUM ('ужасно', 'плохо', 'средне', 'хорошо', 'очень хорошо', 'отлично'),
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, -- можно будет даже не упоминать это поле при обновлении
	
    PRIMARY KEY (hotel_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (hotel_id) REFERENCES hotels (hotel_id)-- ,
    -- CHECK (initiator_user_id <> target_user_id)
);


-- **** Заполним таблицы базы данныx **** --

#
# TABLE STRUCTURE FOR: users
#

INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password_hash`, `phone`, `status`) VALUES ('1', 'Vladimir', 'Armstrong', 'carmela04@example.org', 'e8b73f40b8048adf056b7e790a4c90e99172cd35', '89113235945', 'Genius 1-го уровня');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password_hash`, `phone`, `status`) VALUES ('2', 'Nya', 'Roberts', 'ydaniel@example.com', 'de1ac24bd997a46d0b0f9faacd734aff5ea5e37d', '89129618488', 'Genius 1-го уровня');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password_hash`, `phone`, `status`) VALUES ('3', 'Lina', 'Reinger', 'noble.nitzsche@example.org', '5b879cc12ac871182142be84e85ebda938a423cf', '89223944433', 'Genius 1-го уровня');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password_hash`, `phone`, `status`) VALUES ('4', 'Marilyne', 'McGlynn', 'heidenreich.boyd@example.com', '03e47512291a55110a83e7584b26b682b88e8a73', '89154401828', 'Genius 2-го уровня');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password_hash`, `phone`, `status`) VALUES ('5', 'Clifford', 'Conn', 'aankunding@example.org', '86b88482db586147f000e912a198a8633436ac0c', '89187359455', 'Genius 1-го уровня');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password_hash`, `phone`, `status`) VALUES ('6', 'Rylan', 'Mante', 'antone51@example.net', '9d8b06e940534103abb7d14c681e481eee6acd60', '89167173593', 'Genius 2-го уровня');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password_hash`, `phone`, `status`) VALUES ('7', 'Isidro', 'Stark', 'reid49@example.org', '8b632ef63366fa6f900f1894d7ae49d33af57b67', '89226002469', 'Genius 1-го уровня');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password_hash`, `phone`, `status`) VALUES ('8', 'Sid', 'Welch', 'katrina.crona@example.net', '4341a96186626b28f3d8788bfcef3381a56707d7', '89194791212', 'Genius 3-го уровня');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password_hash`, `phone`, `status`) VALUES ('9', 'Cedrick', 'Abernathy', 'angelita.wolff@example.org', 'a83cbc4574177fccdc004583d53248b787ba8940', '89274445111 
', 'Genius 3-го уровня');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password_hash`, `phone`, `status`) VALUES ('10', 'Lurline', 'Waelchi', 'francesco.effertz@example.org', 'c887d368ba4ae570fdd1a01abddb3ef551a9aeb0', '39', 'Genius 2-го уровня');

#
# TABLE STRUCTURE FOR: countries
#

INSERT INTO `countries` (`country_id`, `country_name`) VALUES (15, 'Australia');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (8, 'Burkina Faso');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (13, 'Canada');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (12, 'Chile');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (7, 'Colombia');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (9, 'Comoros');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (4, 'Croatia');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (5, 'Dominica');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (11, 'Faroe Islands');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (1, 'Grenada');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (2, 'Guadeloupe');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (14, 'Jersey');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (3, 'Jordan');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (10, 'Martinique');
INSERT INTO `countries` (`country_id`, `country_name`) VALUES (6, 'Qatar');

#
# TABLE STRUCTURE FOR: cities
#

INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (1, 13, 14, 1, 'Boscoland');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (2, 12, 14, 2, 'Port Reina');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (3, 8, 20, 3, 'North Lysanneside');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (4, 13, 1, 4, 'Klingberg');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (5, 4, 14, 5, 'New Haven');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (6, 9, 8, 6, 'South Judyhaven');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (7, 15, 12, 7, 'Adellfurt');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (8, 18, 19, 8, 'South Zander');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (9, 6, 6, 9, 'Chasityberg');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (10, 19, 16, 10, 'Luettgentown');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (11, 11, 17, 11, 'Collierfort');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (12, 19, 4, 12, 'North Monroe');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (13, 8, 3, 13, 'South Favian');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (14, 13, 15, 14, 'South Marilou');
INSERT INTO `cities` (`country_id`, `region_id`, `state_id`, `city_id`, `city_name`) VALUES (15, 11, 8, 15, 'New Vivianechester');

#
# TABLE STRUCTURE FOR: profiles
#

INSERT INTO `profiles` (`user_id`, `birthday`, `gender`, `photo_id`, `created_at`, `citizenship`, `hometown`, `adress`) VALUES ('1', '2009-08-21', 'm', '20', '1995-07-20 18:35:48', 1, 1, '25747 Marguerite Ports Apt. 687');
INSERT INTO `profiles` (`user_id`, `birthday`, `gender`, `photo_id`, `created_at`, `citizenship`, `hometown`, `adress`) VALUES ('2', '1977-09-08', 'm', '11', '1977-06-08 00:39:47', 2, 2, '10605 Bins Meadows');
INSERT INTO `profiles` (`user_id`, `birthday`, `gender`, `photo_id`, `created_at`, `citizenship`, `hometown`, `adress`) VALUES ('3', '2018-05-01', 'f', '12', '2006-12-27 10:46:32', 3, 3, '73379 Corkery Springs Apt. 561');
INSERT INTO `profiles` (`user_id`, `birthday`, `gender`, `photo_id`, `created_at`, `citizenship`, `hometown`, `adress`) VALUES ('4', '1993-10-19', 'm', '3', '2002-02-24 17:02:23', 4, 4, '42702 Schuppe Hollow Suite 854');
INSERT INTO `profiles` (`user_id`, `birthday`, `gender`, `photo_id`, `created_at`, `citizenship`, `hometown`, `adress`) VALUES ('5', '1985-01-07', 'f', '20', '2004-08-06 06:45:15', 5, 5, '15616 Abshire Estate');
INSERT INTO `profiles` (`user_id`, `birthday`, `gender`, `photo_id`, `created_at`, `citizenship`, `hometown`, `adress`) VALUES ('6', '1976-09-12', 'f', '6', '1997-12-13 23:58:05', 6, 6, '28755 Hackett Forks Suite 821');
INSERT INTO `profiles` (`user_id`, `birthday`, `gender`, `photo_id`, `created_at`, `citizenship`, `hometown`, `adress`) VALUES ('7', '2006-07-10', 'f', '13', '2018-01-28 08:13:49', 7, 7, '687 Stewart Mill');
INSERT INTO `profiles` (`user_id`, `birthday`, `gender`, `photo_id`, `created_at`, `citizenship`, `hometown`, `adress`) VALUES ('8', '2022-02-12', 'm', '7', '2003-09-13 12:21:23', 8, 8, '848 Leonie Valley');
INSERT INTO `profiles` (`user_id`, `birthday`, `gender`, `photo_id`, `created_at`, `citizenship`, `hometown`, `adress`) VALUES ('9', '1975-06-29', 'm', '1', '1993-03-09 20:34:26', 9, 9, '7697 Jordyn Corner');
INSERT INTO `profiles` (`user_id`, `birthday`, `gender`, `photo_id`, `created_at`, `citizenship`, `hometown`, `adress`) VALUES ('10', '2012-07-25', 'm', '16', '2004-03-24 15:03:52', 10, 10, '5973 Hilpert Parks');

#
# TABLE STRUCTURE FOR: type_of_housing
#

INSERT INTO `type_of_housing` (`id`, `type`) VALUES (1, 'апартаменты');
INSERT INTO `type_of_housing` (`id`, `type`) VALUES (2, 'дом целиком');
INSERT INTO `type_of_housing` (`id`, `type`) VALUES (3, 'гостиница');
INSERT INTO `type_of_housing` (`id`, `type`) VALUES (4, 'хостел');
INSERT INTO `type_of_housing` (`id`, `type`) VALUES (5, 'кемпинг');

#
# TABLE STRUCTURE FOR: hotels
#

INSERT INTO `hotels` (`hotel_id`, `hotel_type`, `hotel_name`, `country_id`, `city_id`, `adress`, `contact_person`, `phone`) VALUES ('11', 1, 'repellat', 1, 1, '0626 Wehner Shores Apt. 457', 'Avery OKon', '89221234');
INSERT INTO `hotels` (`hotel_id`, `hotel_type`, `hotel_name`, `country_id`, `city_id`, `adress`, `contact_person`, `phone`) VALUES ('12', 2, 'eos', 2, 2, '48902 Stiedemann Garden', 'Keshawn Legros', '89272223242');
INSERT INTO `hotels` (`hotel_id`, `hotel_type`, `hotel_name`, `country_id`, `city_id`, `adress`, `contact_person`, `phone`) VALUES ('13', 3, 'debitis', 3, 3, '255 Bins Track Suite 743', 'Eda Abernathy', '89141859677');
INSERT INTO `hotels` (`hotel_id`, `hotel_type`, `hotel_name`, `country_id`, `city_id`, `adress`, `contact_person`, `phone`) VALUES ('14', 4, 'autem', 4, 4, '377 Wilfredo Plaza Suite 600', 'Dr. Omari Schmidt V', '89124445787');
INSERT INTO `hotels` (`hotel_id`, `hotel_type`, `hotel_name`, `country_id`, `city_id`, `adress`, `contact_person`, `phone`) VALUES ('15', 5, 'voluptatem', 5, 5, '1829 Bogan Gateway', 'Elinor Stehr', '89226784321');
INSERT INTO `hotels` (`hotel_id`, `hotel_type`, `hotel_name`, `country_id`, `city_id`, `adress`, `contact_person`, `phone`) VALUES ('16', 1, 'distinctio', 6, 6, '2535 Jeremy Gateway Apt. 304', 'Prof. Linnea Okuneva IV', '89169607900');
INSERT INTO `hotels` (`hotel_id`, `hotel_type`, `hotel_name`, `country_id`, `city_id`, `adress`, `contact_person`, `phone`) VALUES ('19', 4, 'at', 9, 9, '75050 Ratke Ridges', 'Alvena Rau', '89277778899');
INSERT INTO `hotels` (`hotel_id`, `hotel_type`, `hotel_name`, `country_id`, `city_id`, `adress`, `contact_person`, `phone`) VALUES ('20', 5, 'non', 10, 10, '1893 Rogahn Underpass', 'Freeda Graham', '89160507434');

#
# TABLE STRUCTURE FOR: cards
#

INSERT INTO `cards` (`card_id`, `card_num`, `card_type`, `owner_name`, `validity`, `CVC`) VALUES ('1', '4716098944090', 'Visa', 'Antwan', '06/24', 194);
INSERT INTO `cards` (`card_id`, `card_num`, `card_type`, `owner_name`, `validity`, `CVC`) VALUES ('2', '4485053144542', 'Visa', 'Nicolette', '09/22', 904);
INSERT INTO `cards` (`card_id`, `card_num`, `card_type`, `owner_name`, `validity`, `CVC`) VALUES ('3', '4929655679059', 'Visa', 'Faye', '08/23', 508);
INSERT INTO `cards` (`card_id`, `card_num`, `card_type`, `owner_name`, `validity`, `CVC`) VALUES ('4', '4916985336799', 'Visa', 'Bert', '04/25', 544);
INSERT INTO `cards` (`card_id`, `card_num`, `card_type`, `owner_name`, `validity`, `CVC`) VALUES ('5', '5514791685394196', 'Visa', 'Floyd', '03/23', 185);
INSERT INTO `cards` (`card_id`, `card_num`, `card_type`, `owner_name`, `validity`, `CVC`) VALUES ('6', '4929436477630', 'MasterCard', 'Chanelle', '01/25', 532);

#
# TABLE STRUCTURE FOR: rooms
#

INSERT INTO `rooms` (`room_id`, `name`, `room_type`, `guests`, `no_smoking`, `balcon`, `price`) VALUES ('1', 'vero', 'трехместный', 4, 0, 1, 6967);
INSERT INTO `rooms` (`room_id`, `name`, `room_type`, `guests`, `no_smoking`, `balcon`, `price`) VALUES ('2', 'ut', 'трехместный', 4, 1, 1, 2663);
INSERT INTO `rooms` (`room_id`, `name`, `room_type`, `guests`, `no_smoking`, `balcon`, `price`) VALUES ('3', 'quam', 'ЛЮКС', 2, 1, 1, 7583);
INSERT INTO `rooms` (`room_id`, `name`, `room_type`, `guests`, `no_smoking`, `balcon`, `price`) VALUES ('4', 'quia', 'четырехместный', 3, 1, 0, 2524);
INSERT INTO `rooms` (`room_id`, `name`, `room_type`, `guests`, `no_smoking`, `balcon`, `price`) VALUES ('5', 'dicta', 'Семейный', 1, 1, 1, 2230);
INSERT INTO `rooms` (`room_id`, `name`, `room_type`, `guests`, `no_smoking`, `balcon`, `price`) VALUES ('6', 'sed', 'Семейный', 4, 1, 1, 9429);
INSERT INTO `rooms` (`room_id`, `name`, `room_type`, `guests`, `no_smoking`, `balcon`, `price`) VALUES ('7', 'sequi', 'трехместный', 2, 1, 0, 4973);
INSERT INTO `rooms` (`room_id`, `name`, `room_type`, `guests`, `no_smoking`, `balcon`, `price`) VALUES ('8', 'harum', 'двухместный', 4, 0, 0, 7786);
INSERT INTO `rooms` (`room_id`, `name`, `room_type`, `guests`, `no_smoking`, `balcon`, `price`) VALUES ('9', 'quibusdam', 'одноместный', 1, 1, 1, 8725);
INSERT INTO `rooms` (`room_id`, `name`, `room_type`, `guests`, `no_smoking`, `balcon`, `price`) VALUES ('10', 'deserunt', 'четырехместный', 4, 1, 1, 2979);

#
# TABLE STRUCTURE FOR: hotel_profile
#

INSERT INTO `hotel_profile` (`hotel_id`, `parking`, `breakfast`, `wifi`, `swimmimg_pool`, `transfer`, `arrival_time`, `departure_time`, `pay_card`) VALUES ('11', 'нет', 'нет', 1, 1, 1, '02:18:03', '00:08:41', 0);
INSERT INTO `hotel_profile` (`hotel_id`, `parking`, `breakfast`, `wifi`, `swimmimg_pool`, `transfer`, `arrival_time`, `departure_time`, `pay_card`) VALUES ('12', 'да, бесплатно', 'да, по запросу', 1, 1, 1, '20:33:51', '16:32:55', 1);
INSERT INTO `hotel_profile` (`hotel_id`, `parking`, `breakfast`, `wifi`, `swimmimg_pool`, `transfer`, `arrival_time`, `departure_time`, `pay_card`) VALUES ('13', 'нет', 'да', 1, 0, 0, '14:00:27', '14:38:08', 1);
INSERT INTO `hotel_profile` (`hotel_id`, `parking`, `breakfast`, `wifi`, `swimmimg_pool`, `transfer`, `arrival_time`, `departure_time`, `pay_card`) VALUES ('14', 'да, платно', 'нет', 1, 1, 1, '21:21:55', '10:39:12', 1);
INSERT INTO `hotel_profile` (`hotel_id`, `parking`, `breakfast`, `wifi`, `swimmimg_pool`, `transfer`, `arrival_time`, `departure_time`, `pay_card`) VALUES ('15', 'да, бесплатно', 'да', 1, 1, 0, '21:04:50', '02:56:02', 1);
INSERT INTO `hotel_profile` (`hotel_id`, `parking`, `breakfast`, `wifi`, `swimmimg_pool`, `transfer`, `arrival_time`, `departure_time`, `pay_card`) VALUES ('16', 'да, платно', 'да, по запросу', 1, 1, 1, '05:20:36', '23:47:29', 1);
INSERT INTO `hotel_profile` (`hotel_id`, `parking`, `breakfast`, `wifi`, `swimmimg_pool`, `transfer`, `arrival_time`, `departure_time`, `pay_card`) VALUES ('19', 'нет', 'да', 1, 1, 1, '04:39:14', '15:11:21', 1);
INSERT INTO `hotel_profile` (`hotel_id`, `parking`, `breakfast`, `wifi`, `swimmimg_pool`, `transfer`, `arrival_time`, `departure_time`, `pay_card`) VALUES ('20', 'да, бесплатно', 'нет', 1, 1, 1, '13:05:25', '14:03:05', 1);

#
# TABLE STRUCTURE FOR: hotel_rooms
#

INSERT INTO `hotel_rooms` (`hotel_id`, `room_id`, `room_amount`) VALUES ('11', '1', 2);
INSERT INTO `hotel_rooms` (`hotel_id`, `room_id`, `room_amount`) VALUES ('12', '2', 8);
INSERT INTO `hotel_rooms` (`hotel_id`, `room_id`, `room_amount`) VALUES ('13', '3', 8);
INSERT INTO `hotel_rooms` (`hotel_id`, `room_id`, `room_amount`) VALUES ('14', '4', 0);
INSERT INTO `hotel_rooms` (`hotel_id`, `room_id`, `room_amount`) VALUES ('15', '5', 5);
INSERT INTO `hotel_rooms` (`hotel_id`, `room_id`, `room_amount`) VALUES ('16', '6', 0);
INSERT INTO `hotel_rooms` (`hotel_id`, `room_id`, `room_amount`) VALUES ('19', '7', 5);
INSERT INTO `hotel_rooms` (`hotel_id`, `room_id`, `room_amount`) VALUES ('20', '8', 0);
INSERT INTO `hotel_rooms` (`hotel_id`, `room_id`, `room_amount`) VALUES ('11', '9', 4);
INSERT INTO `hotel_rooms` (`hotel_id`, `room_id`, `room_amount`) VALUES ('12', '10', 5);

#
# TABLE STRUCTURE FOR: booking
#

INSERT INTO `booking` (`arrival_date`, `depart_date`, `is_payed`, `who_booked`, `hotel_booked`, `room_booked`) VALUES ('1993-10-01', '1983-07-15', 1, '1', '11', '1');
INSERT INTO `booking` (`arrival_date`, `depart_date`, `is_payed`, `who_booked`, `hotel_booked`, `room_booked`) VALUES ('2004-09-15', '2008-07-18', 1, '2', '12', '2');
INSERT INTO `booking` (`arrival_date`, `depart_date`, `is_payed`, `who_booked`, `hotel_booked`, `room_booked`) VALUES ('2016-09-29', '2020-07-21', 1, '3', '13', '3');
INSERT INTO `booking` (`arrival_date`, `depart_date`, `is_payed`, `who_booked`, `hotel_booked`, `room_booked`) VALUES ('2019-05-31', '1980-10-31', 0, '4', '14', '4');
INSERT INTO `booking` (`arrival_date`, `depart_date`, `is_payed`, `who_booked`, `hotel_booked`, `room_booked`) VALUES ('1974-08-16', '1988-08-20', 1, '5', '15', '5');
INSERT INTO `booking` (`arrival_date`, `depart_date`, `is_payed`, `who_booked`, `hotel_booked`, `room_booked`) VALUES ('2005-11-19', '2018-10-06', 0, '6', '16', '6');
INSERT INTO `booking` (`arrival_date`, `depart_date`, `is_payed`, `who_booked`, `hotel_booked`, `room_booked`) VALUES ('1972-07-02', '1984-02-26', 1, '7', '19', '7');
INSERT INTO `booking` (`arrival_date`, `depart_date`, `is_payed`, `who_booked`, `hotel_booked`, `room_booked`) VALUES ('1997-11-28', '1996-06-27', 1, '8', '20', '8');
INSERT INTO `booking` (`arrival_date`, `depart_date`, `is_payed`, `who_booked`, `hotel_booked`, `room_booked`) VALUES ('2022-01-10', '1998-01-04', 0, '9', '11', '9');
INSERT INTO `booking` (`arrival_date`, `depart_date`, `is_payed`, `who_booked`, `hotel_booked`, `room_booked`) VALUES ('1985-05-16', '1972-11-01', 1, '10', '12', '10');
 

#
# TABLE STRUCTURE FOR: cards_users
#

INSERT INTO `cards_users` (`user_id`, `card_id`) VALUES ('1', '1');
INSERT INTO `cards_users` (`user_id`, `card_id`) VALUES ('2', '2');
INSERT INTO `cards_users` (`user_id`, `card_id`) VALUES ('3', '3');
INSERT INTO `cards_users` (`user_id`, `card_id`) VALUES ('4', '4');
INSERT INTO `cards_users` (`user_id`, `card_id`) VALUES ('5', '5');
INSERT INTO `cards_users` (`user_id`, `card_id`) VALUES ('6', '6');

#
# TABLE STRUCTURE FOR: feedback
#

INSERT INTO `feedback` (`user_id`, `hotel_id`, `desription`, `evaluation`, `created_at`, `updated_at`) VALUES ('1', '11', 'Esse ad omnis iste minus.', 'средне', '1990-05-27 19:26:17', '2012-11-13 03:03:07');
INSERT INTO `feedback` (`user_id`, `hotel_id`, `desription`, `evaluation`, `created_at`, `updated_at`) VALUES ('2', '12', 'Voluptate in molestias deserunt et quia in at.', 'очень хорошо', '2001-02-02 18:05:32', '1973-11-22 00:30:38');
INSERT INTO `feedback` (`user_id`, `hotel_id`, `desription`, `evaluation`, `created_at`, `updated_at`) VALUES ('3', '13', 'Molestiae animi eum et labore ut.', 'очень хорошо', '2013-09-22 03:10:29', '1990-03-15 04:57:01');
INSERT INTO `feedback` (`user_id`, `hotel_id`, `desription`, `evaluation`, `created_at`, `updated_at`) VALUES ('4', '14', 'Sint esse sunt maxime reiciendis occaecati natus et.', 'плохо', '1975-06-20 08:18:11', '2001-10-08 08:29:05');
INSERT INTO `feedback` (`user_id`, `hotel_id`, `desription`, `evaluation`, `created_at`, `updated_at`) VALUES ('5', '15', 'Mollitia vel illum rerum deserunt.', 'плохо', '1990-10-13 03:30:12', '1976-01-09 05:25:51');


-- -------------- ***** Триггер *****---------
-- Уменьшение количества свободных комнат в отеле при осуществении бронирования
USE booking;

DROP TRIGGER IF EXISTS free_rooms;
delimiter //
CREATE TRIGGER free_rooms AFTER INSERT ON booking
FOR EACH ROW
BEGIN
-- 	IF (hotel_rooms.room_amount > 0)
-- 	THEN
	    UPDATE hotel_rooms
	        SET room_amount=room_amount - 1
	    WHERE hotel_id=NEW.hotel_booked AND room_id=NEW.room_booked;
--     END IF;
END//
delimiter ;


INSERT INTO `booking` (`arrival_date`, `depart_date`, `is_payed`, `who_booked`, `hotel_booked`, `room_booked`) VALUES ('1985-05-16', '1972-11-01', 1, '1', '12', '2');


SET @user_id = 2;
-- -------------- ***** Триггер *****---------
-- Запонение таблицы cards_user (платежные карты пользователей) после добавления новой карты


DROP TRIGGER IF EXISTS cards_users_insert;
delimiter //
CREATE TRIGGER cards_users_insert AFTER INSERT ON cards
FOR EACH ROW
BEGIN
DECLARE userId int;
Set userId = @user_id;
	INSERT INTO cards_users VALUES (userId, NEW.card_id);
END //
delimiter ;
 
-- Проверка --
INSERT INTO `cards` (`card_num`, `card_type`, `owner_name`, `validity`, `CVC`) VALUES ('406677718896', 'Mir', 'Fiona', '01/25', 115);





-- ------------------ Мои бронирования	---------------------
-- Создадим запрос на вывод данных бронирования конкретного пользователя ----------

SET @user_id = 2;

SELECT firstname, 
       lastname,
       hotel_name,
       arrival_date,
       depart_date,
       price
from users AS u
JOIN hotels AS h
JOIN booking AS b
JOIN rooms AS r
JOIN hotel_rooms AS hr
ON b.who_booked = @user_id AND u.id = @user_id  AND h.hotel_id = b.hotel_booked 
AND hr.hotel_id = b.hotel_booked AND  hr.room_id = b.room_booked  AND r.room_id = hr.room_id;


-- ------Создадим представление ------- 
-- ------- Все бронирования ------

DROP VIEW IF EXISTS all_booking;
CREATE VIEW all_booking AS
SELECT id,
       firstname, 
       lastname,
       hotel_name,
       arrival_date,
       depart_date,
       price
from users AS u
JOIN hotels AS h
JOIN booking AS b
JOIN rooms AS r
JOIN hotel_rooms AS hr
ON b.who_booked = u.id AND h.hotel_id = b.hotel_booked 
AND hr.hotel_id = b.hotel_booked AND  hr.room_id = b.room_booked  AND r.room_id = hr.room_id; 

-- Бронирования конкретного пользователя ------
SELECT firstname, 
       lastname,
       hotel_name,
       arrival_date,
       depart_date,
       price
FROM all_booking 
WHERE id = @user_id;

-- -----------------------------------------------------------------------------------------
-- ----------------------- Профиль отеля --------------------------------------
SELECT h.hotel_id, 
       hotel_name,
       city_name,
       adress,
       parking ,
       breakfast,
CASE (transfer)
         WHEN 0 THEN 'нет'
         WHEN 1 THEN 'да'
    END AS transfer, 
CASE (wifi)
         WHEN 0 THEN 'нет'
         WHEN 1 THEN 'да'
    END AS free_wifi
from hotel_profile AS hp
JOIN hotels AS h
JOIN cities AS c
ON hp.hotel_id = h.hotel_id  AND h.city_id = c.city_id;  

-- -------- Создадим представление профилей отелей ----------------

DROP VIEW IF EXISTS hotels_view;
CREATE VIEW hotels_view AS 
SELECT h.hotel_id, 
       hotel_name,
       city_name,
       adress,
       parking ,
       breakfast,
CASE (transfer)
         WHEN 0 THEN 'нет'
         WHEN 1 THEN 'да'
    END AS transfer, 
CASE (wifi)
         WHEN 0 THEN 'нет'
         WHEN 1 THEN 'да'
    END AS free_wifi
from hotel_profile AS hp
JOIN hotels AS h
JOIN cities AS c
ON hp.hotel_id = h.hotel_id  AND h.city_id = c.city_id;


SELECT hotel_name,
       city_name,
       adress,
       parking ,
       breakfast,
       transfer, 
       free_wifi
FROM hotels_view 
WHERE hotel_id = 11;



