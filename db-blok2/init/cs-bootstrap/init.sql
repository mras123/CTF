USE dashboard;

CREATE TABLE User (
    userid INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    rollen VARCHAR (255) NOT NULL,
    rollen VARCHAR(50) NOT NULL DEFAULT 'Guest'
    email VARCHAR(255) NOT NULL

);

CREATE TABLE Visitor (
    remotehost VARCHAR(20) NOT NULL,
    useragent VARCHAR(400) NOT NULL,
    PRIMARY KEY (remotehost, useragent)
);

CREATE TABLE Request (
    requestid INT AUTO_INCREMENT,
    requesttype VARCHAR(40) NOT NULL,
    referer VARCHAR(255) NOT NULL,
    PRIMARY KEY (requestid)
);

CREATE TABLE Uri (
    urlpath VARCHAR(255) NOT NULL,
    bytesize VARCHAR(20) NOT NULL,
    PRIMARY KEY (urlpath)
);

CREATE TABLE Event (
    eventid INT AUTO_INCREMENT,
    remotehost VARCHAR(20) NOT NULL,
    useragent VARCHAR(400) NOT NULL,
    requestid INT,
    urlpath VARCHAR(255) NOT NULL,
    logtime TIME NOT NULL,
    logdate DATE NOT NULL,
    logtimezone VARCHAR(20) NOT NULL,
    statuscode VARCHAR(20) NOT NULL,
    PRIMARY KEY (eventid),
    FOREIGN KEY (remotehost, useragent) REFERENCES Visitor(remotehost, useragent),
    FOREIGN KEY (requestid) REFERENCES Request(requestid),
    FOREIGN KEY (urlpath) REFERENCES Uri(urlpath)
);


START TRANSACTION;

INSERT INTO User (username, password_hash, email) VALUES ("admin", "$argon2id$v=19$m=65536,t=3,p=4$S8qw3tIZL42JCd7dXxb8Sg$RGKdpN66YUNd4z9iFxaNZrYHdhCIwMf7D7DB96yUlBM","SecretManager.nl@gmail.com");
INSERT INTO User (username, password_hash, rollen) VALUES ("Cristophe Deloo", "$argon2id$v=19$m=65536,t=3,p=4$S8qw3tIZL42JCd7dXxb8Sg$RGKdpN66YUNd4z9iFxaNZrYHdhCIwMf7D7DB96yUlBM", "Guest");
INSERT INTO User (username, password_hash, rollen) VALUES ("Sander Hentati", "$argon2id$v=19$m=65536,t=3,p=4$S8qw3tIZL42JCd7dXxb8Sg$RGKdpN66YUNd4z9iFxaNZrYHdhCIwMf7D7DB96yUlBM", "Guest");



COMMIT;
