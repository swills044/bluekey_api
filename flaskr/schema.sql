/*We want to get rid of all data when initilizing the db */

DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS service_;
DROP TABLE IF EXISTS ongoing_;
DROP TABLE IF EXISTS review_;
DROP TABLE IF EXISTS message_;
DROP TABLE IF EXISTS token;


/* Realised i was over engineering the account system, using enums instead */
CREATE TABLE account
(
    id INTEGER PRIMARY KEY,
    acc_type Text,
    name Text UNIQUE NOT NULL,
    email Text,
    logo Text,
    telephone INTEGER,
    password Text
);

/* Cannot store arrays in sql - lightbulb
    only reviews need the specific service id, not both ways lmao
 */
CREATE TABLE service_
(
    id INTEGER PRIMARY KEY,
    account_id INTEGER,
    provider INTEGER,
    cost INTEGER,
    desc_ Text,
    website_link Text,
    views INTEGER
);

CREATE TABLE ongoing_
(
    id INTEGER PRIMARY KEY,
    provider_id INTEGER,
    consumer_id INTEGER,
    service_id INTEGER,
    status INTEGER,
    dateCreated INTEGER,
    dateEnded INTEGER,
    cost INTEGER
);

CREATE TABLE review_
(
    id INTEGER PRIMARY KEY,
    provider_id INTEGER,
    consumer_id INTEGER,
    ongoing_id INTEGER,
    textbody Text
);

CREATE TABLE message_
(
    id INTEGER PRIMARY KEY,
    ongoing_id INTEGER,
    sender_id INTEGER,
    reciever_id INTEGER,
    textbody Text,
    dateCreated INTEGER
);

CREATE TABLE token
(
    id INTEGER PRIMARY KEY,
    account_id INTEGER,
    minsexpire INTEGER
);





