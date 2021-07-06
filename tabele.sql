/* Bazy Danych Projekt 3 Kacper Knuth */

-- USE master;
--DROP DATABASE Projekt3;
--GO

--CREATE DATABASE Projekt3;
--GO

--USE Projekt3;
--GO


SET LANGUAGE polski;
GO

-------- USUÑ TABELE --------

DROP TABLE IF EXISTS Profil_Dealera;
DROP TABLE IF EXISTS Modele_Silniki;
DROP TABLE IF EXISTS Wyposazenie_Samochodow;
DROP TABLE IF EXISTS Dodatkowe_wyposazenie;
DROP TABLE IF EXISTS Samochod_Ciezarowy;
DROP TABLE IF EXISTS Samochod_Osobowy;
DROP TABLE IF EXISTS Sprzedaz;
DROP TABLE IF EXISTS Klient;
DROP TABLE IF EXISTS Samochod;
DROP TABLE IF EXISTS Dealer;
DROP TABLE IF EXISTS Typ_Silnika;
DROP TABLE IF EXISTS Model;
DROP TABLE IF EXISTS Marka;

--------- CREATE - UTWÓRZ TABELE I POWI¥ZANIA --------

CREATE TABLE Marka
(
    Nazwa   VARCHAR(30) NOT NULL CONSTRAINT pk_marka_nazwa PRIMARY KEY,
    Rok_za³o¿enia   SMALLINT
    --CONSTRAINT ck_len_marka_nazwa CHECK (LEN(Nazwa) > 0)
);

CREATE TABLE Model
(
    ID  INT IDENTITY(1,1) CONSTRAINT pk_model_id PRIMARY KEY,
    Nazwa VARCHAR(30) NOT NULL,
    Rok_wprowadzenia_na_rynek SMALLINT NOT NULL,
    Nastepna_Generacja_Id INT NULL,
    Marka_Nazwa VARCHAR(30) NOT NULL,
    FOREIGN KEY (Nastepna_Generacja_Id) REFERENCES Model(ID),
    FOREIGN KEY (Marka_Nazwa) REFERENCES Marka(Nazwa),
);

CREATE UNIQUE INDEX idx_model_generacje
ON Model(Nastepna_Generacja_Id)
WHERE Nastepna_Generacja_Id IS NOT NULL;

CREATE TABLE Typ_Silnika
(
    ID INT IDENTITY(1,1) CONSTRAINT pk_silnik_id PRIMARY KEY,
    Rodzaj_paliwa VARCHAR(20) NOT NULL,
    Opis_parametrów VARCHAR(50) NOT NULL,
    CONSTRAINT ck_rodzaj_paliwa CHECK (Rodzaj_paliwa IN ('Benzyna', 'Olej napêdowy', 'Gaz'))
);

CREATE TABLE Dealer
(
    Nazwa VARCHAR(100) NOT NULL CONSTRAINT pk_dealer_nazwa PRIMARY KEY,
    Adres VARCHAR(100) NOT NULL
);

CREATE TABLE Samochod
(
    VIN CHAR(17) NOT NULL CONSTRAINT pk_samochod_vin PRIMARY KEY,
    Rok_produkcji SMALLINT,
    Kraj_pochodzenia VARCHAR(35),
    Skrzynia_biegów VARCHAR(20),
    Przebieg REAL,
    Model_Id INT NOT NULL,
    Typ_Silnika_Id INT NOT NULL,
    Dealer_Nazwa VARCHAR(100)
    FOREIGN KEY (Model_Id) REFERENCES Model(ID),
    FOREIGN KEY (Typ_Silnika_Id) REFERENCES Typ_Silnika(ID),
    FOREIGN KEY (Dealer_Nazwa) REFERENCES Dealer(Nazwa)
);

CREATE TABLE Dodatkowe_wyposazenie
(
    Nazwa VARCHAR(50) NOT NULL CONSTRAINT pk_wyposazenie_nazwa PRIMARY KEY
);

CREATE TABLE Klient
(
    ID INT IDENTITY(1,1) CONSTRAINT pk_klient_id PRIMARY KEY,
    Imie VARCHAR(20) NOT NULL CONSTRAINT ck_klient_imie CHECK (Imie LIKE '[A-Z]%'),
    Nazwisko VARCHAR(30) NOT NULL CONSTRAINT ck_klient_nazwisko CHECK (Nazwisko LIKE '[A-Z]%'),
    Numer_telefonu CHAR(9) CONSTRAINT ck_klient_numer_tel CHECK (Numer_telefonu LIKE '[0-9]%')
);

CREATE TABLE Sprzedaz
(
    Data_Sprzedazy DATE NOT NULL,
    Cena MONEY,
    Dealer_Nazwa VARCHAR(100) NOT NULL REFERENCES Dealer(Nazwa),
    Klient_Id INT NOT NULL REFERENCES Klient(ID),
    Samochod_VIN CHAR(17) NOT NULL REFERENCES Samochod(VIN)
    PRIMARY KEY(Data_Sprzedazy, Dealer_Nazwa, Klient_Id, Samochod_VIN)
);

CREATE TABLE Wyposazenie_Samochodow
(
    Samochod_VIN CHAR(17) NOT NULL REFERENCES Samochod(VIN),
    Nazwa_Wyposazenia VARCHAR(50) NOT NULL REFERENCES Dodatkowe_wyposazenie(Nazwa)
    PRIMARY KEY(Samochod_VIN, Nazwa_Wyposazenia)
);

CREATE TABLE Modele_Silniki
(
    Id_Modelu INT NOT NULL REFERENCES Model(ID),
    Id_Silnika INT NOT NULL REFERENCES Typ_Silnika(ID),
    PRIMARY KEY(Id_Modelu, Id_Silnika)
);

CREATE TABLE Profil_Dealera
(
    Dealer_Nazwa VARCHAR(100) NOT NULL REFERENCES Dealer(Nazwa),
    Model_Id INT NOT NULL REFERENCES Model(ID),
    PRIMARY KEY(Dealer_Nazwa, Model_Id)
);

CREATE TABLE Samochod_Osobowy
(
    Model_Id INT NOT NULL REFERENCES Model(ID),
    Pojemnosc_bagaznika REAL,
    Liczba_pasazerow INT NOT NULL,
    PRIMARY KEY(Model_Id)
);

CREATE TABLE Samochod_Ciezarowy
(
    Model_Id INT NOT NULL REFERENCES Model(ID),
    Ladownosc REAL,
    PRIMARY KEY(Model_Id)
);

GO

---------- INSERT - WSTAW DANE -------

INSERT INTO Marka VALUES
('Alfa Romeo', 1910),
('Audi', 1910),
('BMW', 1917),
('Ford', 1903),
('Volkswagen', 1937);

INSERT INTO Model VALUES
('GTV II', 1994, NULL, 'Alfa Romeo'),
('A6', 1994, NULL, 'Audi'),
('A7', 2010, 2, 'Audi'),
('M5', 1999, NULL, 'BMW'),
('Mustang VI', 2014, NULL, 'Ford');

INSERT INTO Typ_Silnika VALUES
('Benzyna', '148 KM'),
('Olej napêdowy', '286 KM'),
('Benzyna', '300 KM');

INSERT INTO Dealer VALUES
('Grupa Krotoski-Cichy', 'Gdañsk'),
('Grupa Zdunek', 'Poznañ'),
('Auto Boss', 'Gdynia');

INSERT INTO Samochod VALUES
('1J4GZ78S9TC239448', 2018, 'Niemcy', 'Manualna 7-stopniowa', 11761.12, 2, 2, 'Grupa Krotoski-Cichy'), 
('KM8JT3AC9AU079440', 2015, 'Polska', 'Automatyczna', 2002.22, 5, 3, 'Auto Boss');

INSERT INTO Dodatkowe_wyposazenie VALUES
('Nawigacja TOMTOM'),
('RENEGADE G³oœniki');

INSERT INTO Klient VALUES
('Stanis³aw', 'Kowalski', '456879123'),
('Marek', 'Maszota', '789432765');

INSERT INTO Sprzedaz VALUES
('2019-01-12', 179949 ,'Auto Boss', 1, 'KM8JT3AC9AU079440');

INSERT INTO Wyposazenie_Samochodow VALUES
('KM8JT3AC9AU079440', 'Nawigacja TOMTOM');

INSERT INTO Modele_Silniki VALUES
(2, 2),
(5, 3);

INSERT INTO Profil_Dealera VALUES
('Auto Boss', 5),
('Grupa Krotoski-Cichy', 2);

INSERT INTO Samochod_Osobowy VALUES
(1, 155, 4),
(2, 565, 5),
(3, 535, 5),
(4, 330, 5),
(5, 408, 4);