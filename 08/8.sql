
CREATE TABLE Person
(
    pid SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Wohnort VARCHAR(100) NOT NULL
);

CREATE TABLE Halter
(
    pid INTEGER PRIMARY KEY,
    Typ VARCHAR(100) NOT NULL,
    FOREIGN KEY (pid) REFERENCES Person(pid)
);

CREATE TABLE Aufpasser
(
    pid INTEGER PRIMARY KEY,
    Stundenlohn DECIMAL DEFAULT NULL,
    FOREIGN KEY(pid) REFERENCES Person(pid) ON DELETE CASCADE
);

CREATE TABLE Futter
(
    Hersteller VARCHAR(100) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    PRIMARY KEY(Hersteller, Name)
);

CREATE TABLE Haustier
(
    hid SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    GebTag INTEGER NOT NULL,
    GebMonat INTEGER NOT NULL,
    GebJahr INTEGER NOT NULL,
    CHECK (GebTag >= 1 AND GebTag <= 12),
    CHECK (GebMonat >= 1 AND GebMonat <= 31),
    CHECK (GebJahr >= 1900 AND GebJahr <= 2019)
    /*Nachteil, dass dies jedes Jahr aktualisiert werden müsste.*/
);

CREATE TABLE Hund
(
    hid INTEGER PRIMARY KEY,
    Rasse VARCHAR(100) NOT NULL,
    FOREIGN KEY(hid) REFERENCES Haustier(hid) ON DELETE CASCADE
);

CREATE TABLE Katze
(
    hid INTEGER PRIMARY KEY,
    Dominanz INTEGER DEFAULT NULL,
    Fellfarbe VARCHAR(100) NOT NULL,
    FOREIGN KEY(hid) REFERENCES Haustier(hid) ON DELETE CASCADE,
    CHECK ((Dominanz <= 100 AND Dominanz >= 0) OR Dominanz IS NULL)
);

CREATE TABLE Lieblingsplatz
(
    lid SERIAL PRIMARY KEY
);

CREATE TABLE Kamin
(
    lid INTEGER PRIMARY KEY,
    Material VARCHAR(100) NOT NULL,
    FOREIGN KEY (lid) REFERENCES Lieblingsplatz(lid) ON DELETE CASCADE
);

CREATE TABLE Karton
(
    lid INTEGER PRIMARY KEY,
    FOREIGN KEY (lid) REFERENCES Lieblingsplatz(lid) ON DELETE CASCADE

);

CREATE TABLE Laptop
(
    lid INTEGER PRIMARY KEY,
    Hersteller VARCHAR(100) NOT NULL,
    Kennzeichnung VARCHAR(100) DEFAULT NULL,
    FOREIGN KEY (lid) REFERENCES Lieblingsplatz(lid) ON DELETE CASCADE

);

CREATE TABLE hatbei
(
    hid INTEGER NOT NULL,
    pid INTEGER NOT NULL,
    lid INTEGER NOT NULL,
    PRIMARY KEY(hid,pid),
    FOREIGN KEY(hid) REFERENCES Haustier(hid) ON DELETE CASCADE,
    FOREIGN KEY(pid) REFERENCES Person(pid) ON DELETE CASCADE,
    FOREIGN KEY(lid) REFERENCES Lieblingsplatz(lid) ON DELETE CASCADE
);

CREATE TABLE mag
(
    Hersteller VARCHAR(100) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    hid INTEGER NOT NULL,
    PRIMARY KEY(Hersteller, Name, hid),
    FOREIGN KEY(Hersteller, Name) REFERENCES Futter(Hersteller, Name) ON DELETE CASCADE,
    FOREIGN KEY(hid) REFERENCES Haustier(hid) ON DELETE CASCADE
);

/*Kamin is not a Karton or a Laptop */
ALTER TABLE Kamin
    ADD CHECK (Kamin.lid NOT IN (SELECT Karton.lid FROM Karton)), 
    ADD CHECK (Kamin.lid NOT IN (SELECT Laptop.lid FROM Laptop)
);

/*Karton is not a Kamin or a Laptop */
ALTER TABLE Karton
    ADD CHECK (Karton.lid NOT IN (SELECT Kamin.lid FROM Kamin)), 
    ADD CHECK (Karton.lid NOT IN (SELECT Laptop.lid FROM Laptop)
);

/*Laptop is not a Karton or a Kamin */
ALTER TABLE Laptop
    ADD CHECK (Laptop.lid NOT IN (SELECT Karton.lid FROM Karton)), 
    ADD CHECK (Laptop.lid NOT IN (SELECT Kamin.lid FROM Kamin)
);

/*Lieblingsplatz is a Laptop or a Karton or a Kamin */
ALTER TABLE Lieblingsplatz
    ADD CHECK (
        (Lieblingsplatz.lid IN (SELECT Karton.lid FROM Karton)) OR (Lieblingsplatz.lid IN (SELECT Kamin.lid FROM Kamin)) OR (Lieblingsplatz.lid IN (SELECT Laptop.lid FROM Laptop))
        )
;

/*Katze is not a Hund */
ALTER TABLE Katze
    ADD CHECK (Katze.hid NOT IN (SELECT Hund.hid FROM Hund))
;

/*Hund is not a Katze */
ALTER TABLE Hund
    ADD CHECK (Hund.hid NOT IN (SELECT Katze.hid FROM Katze))
;

/*Haustier has at least 1 Lieblingsfutter */
ALTER TABLE Haustier
	ADD CHECK (Haustier.hid IN (SELECT Haustier.hid FROM mag))
;

/*Haustier has at least 1 Lieblingsplatz */
ALTER TABLE Haustier
	ADD CHECK (Haustier.hid IN (SELECT Haustier.hid FROM hatbei))
;

/* Haustier has only 1 Halter and vice versa */
ALTER TABLE Haustier
    ADD pid integer NOT NULL REFERENCES Halter(pid) ON DELETE CASCADE
;
ALTER TABLE Halter
    ADD hid integer NOT NULL REFERENCES Haustier(hid) ON DELETE CASCADE
;

