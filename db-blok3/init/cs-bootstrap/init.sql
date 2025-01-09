USE secrets;

CREATE TABLE User (
    username VARCHAR(30) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    voornaam VARCHAR(255) NOT NULL,
    achternaam VARCHAR(255) NOT NULL,
    last_login DATETIME,
    PRIMARY KEY (username)
);

CREATE TABLE Secret (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    info VARCHAR(255) NOT NULL,
    user_name VARCHAR(30) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_name) REFERENCES User(username)
);

CREATE TABLE shared_with (
    secret_id INT NOT NULL,
    username VARCHAR(30) NOT NULL,
    PRIMARY KEY (secret_id, username),
    FOREIGN KEY (secret_id) REFERENCES Secret(id),
    FOREIGN KEY (username) REFERENCES User(username)
);
