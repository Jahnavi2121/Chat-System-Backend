DROP TABLE IF EXISTS Channels CASCADE;
DROP TABLE IF EXISTS Communities CASCADE;
DROP TABLE IF EXISTS UsersXCommunities CASCADE;
DROP TABLE IF EXISTS Messages CASCADE;
DROP TABLE IF EXISTS Users CASCADE;

-- Create Users table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    changed_username VARCHAR(50) NULL,
    suspended_until DATE,
    suspension_status VARCHAR(50),
    created_on DATE ,
    changed_date DATE DEFAULT NULL
);

-- Create Communities table
CREATE TABLE Communities (
    id SERIAL PRIMARY KEY,
    community_name VARCHAR(255) NOT NULL
);

-- Create UsersXCommunities table
CREATE TABLE UsersXCommunities (
    user_id INT REFERENCES Users(user_id),
    community_id INT REFERENCES Communities(id),
    PRIMARY KEY (user_id, community_id)
);

CREATE TABLE Channels (
    id SERIAL PRIMARY KEY,
    channel_name VARCHAR(255) NOT NULL,
    community_id INT REFERENCES Communities(id)
    
);

-- Create Messages table
CREATE TABLE Messages (
    message_id SERIAL PRIMARY KEY,
    message_text TEXT,
    sent_date DATE,
    is_read BOOLEAN,
    sender_id INT REFERENCES Users(user_id),
    receiver_id INT REFERENCES Users(user_id),
    channel_id INT REFERENCES Channels(id)
);


-- Insert users (with the correct number of values for each column)
INSERT INTO Users (username, suspended_until, suspension_status, created_on, changed_date) VALUES
('Abbott', NULL, 'un-suspended', '1920-01-01', NULL),
('Costello', NULL, 'un-suspended', '1920-01-02', NULL),
('Moe', NULL, 'un-suspended', '1920-01-03', NULL),
('Larry', '2060-01-01', 'suspended', '1920-01-04', NULL),
('Curly', '1999-12-31', 'suspended', '1920-01-05', NULL),
('DrMarvin',NULL,'un-suspended','1991-05-16',NULL),
('spicelover',NULL,'un-suspended',NULL,NULL),
('Paul',NULL,'un-suspended','1991-05-16',NULL);


-- Insert communities
INSERT INTO Communities (community_name) VALUES
('Arrakis'),
('Comedy');

INSERT INTO Channels (channel_name, community_id) VALUES
('#Worms', (SELECT id FROM Communities WHERE community_name = 'Arrakis')),
('#Random', (SELECT id FROM Communities WHERE community_name = 'Arrakis')),
('#ArgumentClinic', (SELECT id FROM Communities WHERE community_name = 'Comedy')),
('#Dialogs', (SELECT id FROM Communities WHERE community_name = 'Comedy'));

-- Insert messages with correct sender and receiver references
INSERT INTO Messages (sender_id, receiver_id, message_text, sent_date, is_read,channel_id) VALUES
((SELECT user_id FROM Users WHERE username = 'Abbott'), (SELECT user_id FROM Users WHERE username = 'Costello'), 'Hello Costello!', '1923-06-01', TRUE,2),
((SELECT user_id FROM Users WHERE username = 'Costello'), (SELECT user_id FROM Users WHERE username = 'Abbott'), 'Hi Abbott!', '1930-07-02', FALSE,2),
((SELECT user_id FROM Users WHERE username = 'Moe'), (SELECT user_id FROM Users WHERE username = 'Larry'), 'Message from Moe', '1995-05-15', TRUE,3),
((SELECT user_id FROM Users WHERE username = 'Larry'), (SELECT user_id FROM Users WHERE username = 'Moe'), 'Message from Larry', '1995-08-22', FALSE,4),
((SELECT user_id FROM Users WHERE username = 'Moe'),(SELECT user_id FROM Users WHERE username ='Larry'),'I am in a meeting','1995-08-23',TRUE,3),
((SELECT user_id FROM Users WHERE username = 'Paul'), (SELECT user_id FROM Users WHERE username = 'Moe'), 'Hey Moe, how are you?', NULL, TRUE,3),
((SELECT user_id FROM Users WHERE username = 'Moe'), (SELECT user_id FROM Users WHERE username = 'Paul'), 'Doing well, thanks Paul!', NULL, TRUE,3),
((SELECT user_id FROM Users WHERE username = 'DrMarvin'), (SELECT user_id FROM Users WHERE username = 'spicelover'), 'I am a doctor, not a spice lover', '1991-02-16', TRUE,4),
((SELECT user_id FROM Users WHERE username = 'spicelover'), (SELECT user_id FROM Users WHERE username = 'DrMarvin'), 'I am a spice lover, not a doctor', '1993-05-16', TRUE,1),
((SELECT user_id FROM Users WHERE username = 'Paul'), (SELECT user_id FROM Users WHERE username = 'Moe'), 'Howz your work going?','1926-06-12', TRUE,3),
((SELECT user_id FROM Users WHERE username = 'Moe'), (SELECT user_id FROM Users WHERE username = 'Paul'), 'Going  well, thanks Paul!','1932-11-19', TRUE,3),
((SELECT user_id FROM Users WHERE username = 'DrMarvin'), (SELECT user_id FROM Users WHERE username = 'Abbott'), 'Are you joining us this sunday?', '1991-05-16', TRUE,4),
((SELECT user_id FROM Users WHERE username = 'Abbott'), (SELECT user_id FROM Users WHERE username = 'DrMarvin'), 'Yes , of course!!!', '1991-05-16', TRUE,2),
((SELECT user_id FROM Users WHERE username = 'spicelover'), (SELECT user_id FROM Users WHERE username = 'Costello'), 'Happy Birthday!!!', '1994-03-21', TRUE,1),
((SELECT user_id FROM Users WHERE username = 'Costello'), (SELECT user_id FROM Users WHERE username = 'spicelover'), 'Thank you!!!', '1994-05-21', FALSE,2),
((SELECT user_id FROM Users WHERE username = 'Curly'),(SELECT user_id FROM Users WHERE username = 'Larry'),'I am in a meeting','1995-08-23',TRUE,4);



INSERT INTO UsersXCommunities (user_id, community_id) VALUES
((SELECT user_id FROM Users WHERE username = 'Abbott'), (SELECT id FROM Communities WHERE community_name = 'Comedy')),
((SELECT user_id FROM Users WHERE username = 'Costello'), (SELECT id FROM Communities WHERE community_name = 'Comedy')),
((SELECT user_id FROM Users WHERE username = 'Moe'), (SELECT id FROM Communities WHERE community_name = 'Comedy')),
((SELECT user_id FROM Users WHERE username = 'Larry'), (SELECT id FROM Communities WHERE community_name = 'Comedy')),
((SELECT user_id FROM Users WHERE username = 'Curly'), (SELECT id FROM Communities WHERE community_name = 'Comedy')),
((SELECT user_id FROM Users WHERE username = 'DrMarvin'), (SELECT id FROM Communities WHERE community_name = 'Comedy')),
((SELECT user_id FROM Users WHERE username = 'spicelover'), (SELECT id FROM Communities WHERE community_name = 'Arrakis'));


