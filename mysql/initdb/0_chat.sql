CREATE DATABASE chat;

USE chat;

CREATE TABLE messages (
  id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
  content VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO messages (content) VALUES ("hello");
INSERT INTO messages (content) VALUES ("hello");
INSERT INTO messages (content) VALUES ("hello");
INSERT INTO messages (content) VALUES ("hello");
INSERT INTO messages (content) VALUES ("hello");
INSERT INTO messages (content) VALUES ("hello");
INSERT INTO messages (content) VALUES ("hello");
INSERT INTO messages (content) VALUES ("hello");
INSERT INTO messages (content) VALUES ("hello");
INSERT INTO messages (content) VALUES ("hello");
