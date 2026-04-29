-- GENERAZIONE_TABELLE
CREATE TABLE Categorie (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    Nome varchar(255) NOT NULL UNIQUE
);

CREATE TABLE Transazioni (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    Data date NOT NULL,
    Importo decimal(10, 2) NOT NULL CHECK (Importo > 0),
    Descrizione varchar(600),
    Categoria int NOT NULL,

    FOREIGN KEY (Categoria) REFERENCES Categorie(id)
);

CREATE TABLE Budget(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    Importo_max decimal(10, 2) NOT NULL CHECK (Importo_max > 0),
    Mese int NOT NULL CHECK (Mese >= 1 AND Mese <= 12),
    Anno int NOT NULL CHECK (Anno > 0),
    Categoria int NOT NULL,

    UNIQUE (Mese, Anno, Categoria),
    FOREIGN KEY (Categoria) REFERENCES Categorie(id)
);

-- CREA_CATEGORIA
INSERT INTO Categorie (Nome) VALUES (?);

-- RINOMINA_CATEGORIA
UPDATE Categorie SET Nome = (?) WHERE Nome = (?);

-- ADD_TRANSAZIONE
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (?, ?, ?, ?);
-- ADD_TRANSAZIONE_CD
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (?, CURRENT_DATE, ?, ?);

-- GET_ID_CATEGORIA
SELECT id FROM Categorie WHERE Nome = ?;

-- SPESE_PER_CATEGORIA
SELECT C.id, C.Nome, SUM(T.Importo) AS Totale
FROM Categorie C
LEFT JOIN Transazioni T ON T.Categoria = C.id
GROUP BY C.id, C.Nome
ORDER BY C.Nome;

-- SPESE_MENSILI_VS_BUDGET
SELECT
    C.id AS CAT_ID,
    C.Nome,
    CAST(strftime('%m', T.Data) AS INTEGER) AS Mese,
    CAST(strftime('%Y', T.Data) AS INTEGER) AS Anno,
    SUM(T.Importo) AS Totale,
    B.Importo_max
FROM Transazioni T
JOIN Categorie C ON T.Categoria = C.id
LEFT JOIN Budget B
    ON B.Categoria = C.id
    AND B.Mese = CAST(strftime('%m', T.Data) AS INTEGER)
    AND B.Anno = CAST(strftime('%Y', T.Data) AS INTEGER)
WHERE C.Nome = ?
AND CAST(strftime('%m', T.Data) AS INTEGER) = ?
AND CAST(strftime('%Y', T.Data) AS INTEGER) = ?
GROUP BY C.id, C.Nome, Mese, Anno;


-- SVUOTA_TOTALMENTE_IL_DB
DROP TABLE Transazioni;
DROP TABLE Categorie;
DROP TABLE Budget;

-- POPOLA_CON_DATI
INSERT INTO Categorie (Nome) VALUES ('Alimentari');
INSERT INTO Categorie (Nome) VALUES ('Abitazione');
INSERT INTO Categorie (Nome) VALUES ('Trasporti');
INSERT INTO Categorie (Nome) VALUES ('Svago');
INSERT INTO Categorie (Nome) VALUES ('Varie ed eventuali');
INSERT INTO Categorie (Nome) VALUES ('Abbonamenti');

INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (100.50, '2023-01-15', 1, 'Spesa settimanale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (200.00, '2023-01-20', 2, 'Affitto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (50.75,  '2023-01-25', 3, 'Benzina');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (25.40,  '2023-01-05', 1, 'Pane e latte');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (15.90,  '2023-01-07', 1, 'Frutta e verdura');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (60.00,  '2023-01-10', 6, 'Abbonamento streaming mensile');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (120.00, '2023-01-12', 2, 'Bolletta elettrica');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (8.50,   '2023-01-13', 3, 'Biglietto autobus');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (45.00,  '2023-01-18', 4, 'Cena fuori');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (12.30,  '2023-01-21', 5, 'Articoli per la casa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (30.00,  '2023-02-02', 1, 'Spesa settimanale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (850.00, '2023-02-01', 2, 'Affitto febbraio');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (55.00,  '2023-02-05', 3, 'Rifornimento auto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (20.00,  '2023-02-09', 4, 'Cinema con amici');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (5.99,   '2023-02-10', 6, 'App store');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (40.00,  '2023-02-14', 1, 'Spesa extra');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (18.00,  '2023-02-20', 5, 'Cancellare lampadina');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (300.00, '2023-03-01', 2, 'Ristrutturazione piccola');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (22.00,  '2023-03-03', 3, 'Taxi notturno');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (75.00,  '2023-03-12', 4, 'Serata fuori');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (14.50,  '2023-03-15', 1, 'Colazione al bar');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (9.99,   '2023-03-20', 6, 'Abbonamento app');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (60.00,  '2023-03-22', 5, 'Piccole commissioni');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (45.00,  '2023-04-02', 1, 'Spesa mensile');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (820.00, '2023-04-01', 2, 'Affitto aprile');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (30.00,  '2023-04-05', 3, 'Carburante');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (120.00, '2023-04-10', 4, 'Abbonamento palestra trimestrale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (3.50,   '2023-04-12', 5, 'Materiale ufficio');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (49.99,  '2023-04-15', 6, 'Servizio cloud annuale (prima rata)');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (270.00, '2023-05-01', 1, 'Spesa mensile grande');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (900.00, '2023-05-02', 2, 'Affitto maggio');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (40.00,  '2023-05-06', 3, 'Manutenzione auto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (150.00, '2023-05-10', 4, 'Weekend fuori');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (20.00,  '2023-05-13', 5, 'Piccole spese varie');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (12.99,  '2023-05-14', 6, 'Abbonamento mensile');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (35.00,  '2023-06-03', 1, 'Spesa settimanale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (75.00,  '2023-06-05', 3, 'Tagliando auto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (85.00,  '2023-06-20', 4, 'Cena importante');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (10.00,  '2023-06-22', 5, 'Regalo piccolo');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (49.99,  '2023-06-25', 6, 'Rinnovo app');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (260.00, '2023-07-01', 1, 'Spesa mensile');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (880.00, '2023-07-02', 2, 'Affitto luglio');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (60.00,  '2023-07-08', 3, 'Carburante e pedaggi');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (200.00, '2023-07-15', 4, 'Concerto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (18.75,  '2023-07-20', 5, 'Accessori casa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (14.99,  '2023-07-25', 6, 'Music streaming');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (240.00, '2023-08-01', 1, 'Spesa mensile agosto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (860.00, '2023-08-03', 2, 'Affitto agosto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (55.00,  '2023-08-10', 3, 'Benzina');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (95.00,  '2023-08-18', 4, 'Escursione pagata');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (5.00,   '2023-08-20', 5, 'Caffè e snack');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (45.00,  '2023-01-22', 1, 'Spesa mercato aggiuntiva');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (35.00,  '2023-01-30', 4, 'Uscita serale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (60.00,  '2023-02-16', 3, 'Rifornimento auto aggiuntivo');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (4.99,   '2023-02-24', 6, 'Acquisto app');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (25.00,  '2023-03-08', 5, 'Materiale casa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (100.00, '2023-03-28', 2, 'Servizio domestico');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (55.50,  '2023-04-20', 1, 'Spesa mensile extra');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (20.00,  '2023-04-22', 3, 'Taxi breve');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (80.00,  '2023-05-21', 4, 'Attività ricreativa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (9.99,   '2023-05-27', 6, 'Abbonamento app');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (200.00, '2023-06-15', 2, 'Manutenzione casa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (15.00,  '2023-06-30', 5, 'Piccole spese casa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (45.00,  '2023-07-18', 3, 'Carburante');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (120.00, '2023-07-28', 4, 'Big evento');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (90.00,  '2023-08-12', 1, 'Spesa mensile integrativa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (29.99,  '2023-08-30', 6, 'Servizio digitale extra');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (80.00,  '2023-09-03', 1, 'Spesa settimanale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (45.00,  '2023-09-10', 3, 'Carburante');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (860.00, '2023-09-15', 2, 'Affitto settembre');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (55.00, '2023-09-20', 4, 'Cena fuori');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (12.99, '2023-10-05', 6, 'Abbonamento app');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (95.50, '2023-10-12', 1, 'Spesa mercato');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (120.00, '2023-10-20', 3, 'Manutenzione auto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (25.00, '2023-10-25', 5, 'Materiale casa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (880.00, '2023-11-01', 2, 'Affitto novembre');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (180.00, '2023-11-10', 4, 'Weekend fuori');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (220.00, '2023-12-24', 1, 'Spesa Natale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (49.99, '2024-01-05', 6, 'Rinnovo servizio');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (27.45, '2023-01-08', 4, 'Shopping online extra');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (42.00, '2023-01-26', 2, 'Riparazione domestica');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (18.20, '2023-02-03', 5, 'Piccola commissione');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (230.00, '2023-02-19', 2, 'Fornitura casa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (60.75, '2023-03-06', 1, 'Spesa settimanale extra');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (12.00, '2023-03-21', 6, 'Acquisto app minore');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (34.90, '2023-04-04', 3, 'Piccola manutenzione auto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (95.00, '2023-04-23', 4, 'Cena con amici');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (15.30, '2023-05-05', 5, 'Materiale ufficio piccolo');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (480.00, '2023-05-25', 2, 'Intervento straordinario casa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (38.60, '2023-06-07', 1, 'Spesa congelati');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (22.50, '2023-06-18', 3, 'Servizio taxi');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (9.50, '2023-07-02', 6, 'Micro acquisto app');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (160.00, '2023-07-20', 4, 'Evento e biglietti');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (210.00, '2023-08-06', 1, 'Spesa mensile extra');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (65.00, '2023-08-22', 3, 'Controllo meccanico');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (55.25, '2023-09-09', 4, 'Cena speciale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (14.00, '2023-09-27', 5, 'Piccole forniture casa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (102.40, '2023-10-11', 1, 'Spesa mercato grande');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (29.99, '2023-10-29', 6, 'Abbonamento digitale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (18.00, '2023-11-03', 5, 'Accessori casa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (95.00, '2023-11-21', 4, 'Weekend breve');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (320.00, '2023-12-08', 1, 'Spesa Natale aggiuntiva');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (75.00, '2023-12-18', 3, 'Carburante festivo');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (48.00, '2024-02-14', 2, 'Materiale manutenzione');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (27.50, '2024-03-10', 1, 'Spesa mensile anticipata');

INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (300.00, 1, 2023, 1);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (800.00, 1, 2023, 2);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (150.00, 1, 2023, 3);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (100.00, 1, 2023, 4);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (280.00, 1, 2023, 5);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (12.00,  1, 2023, 6);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (300.00, 2, 2023, 1);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (800.00, 2, 2023, 2);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (150.00, 2, 2023, 3);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (120.00, 2, 2023, 4);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (100.00, 2, 2023, 5);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (14.99,  2, 2023, 6);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (320.00, 3, 2023, 1);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (820.00, 3, 2023, 2);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (160.00, 3, 2023, 3);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (140.00, 3, 2023, 4);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (120.00, 3, 2023, 5);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (14.99,  3, 2023, 6);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (300.00, 4, 2023, 1);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (830.00, 4, 2023, 2);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (140.00, 4, 2023, 3);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (150.00, 4, 2023, 4);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (110.00, 4, 2023, 5);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (12.99,  4, 2023, 6);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (310.00, 5, 2023, 1);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (900.00, 5, 2023, 2);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (170.00, 5, 2023, 3);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (200.00, 5, 2023, 4);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (130.00, 5, 2023, 5);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (12.99,  5, 2023, 6);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (260.00, 6, 2023, 1);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (880.00, 6, 2023, 2);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (150.00, 6, 2023, 3);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (180.00, 6, 2023, 4);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (90.00,  6, 2023, 5);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (14.99,  6, 2023, 6);

INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (300.00, 1, 2024, 1);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (850.00, 1, 2024, 2);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (160.00, 1, 2024, 3);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (150.00, 1, 2024, 4);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (120.00, 1, 2024, 5);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (12.99,  1, 2024, 6);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (320.00, 2, 2024, 1);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (860.00, 2, 2024, 2);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (150.00, 2, 2024, 3);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (140.00, 2, 2024, 4);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (110.00, 2, 2024, 5);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (14.99,  2, 2024, 6);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (310.00, 3, 2024, 1);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (880.00, 3, 2024, 2);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (170.00, 3, 2024, 3);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (160.00, 3, 2024, 4);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (130.00, 3, 2024, 5);
INSERT INTO Budget (Importo_max, Mese, Anno, Categoria) VALUES (12.99,  3, 2024, 6);