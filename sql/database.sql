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

-- SPESE_TRA_DATE
SELECT * FROM Transazioni
WHERE Data BETWEEN ? AND ?
ORDER BY Data DESC;
-- SPESE_TRA_DATE_CD
SELECT * FROM Transazioni
WHERE Data BETWEEN CURRENT_DATE AND ?
ORDER BY Data DESC;
-- SPESE_TRA_DATE_CD_B
SELECT * FROM Transazioni
WHERE Data BETWEEN CURRENT_DATE AND CURRENT_DATE
ORDER BY Data DESC;

-- SVUOTA_TOTALMENTE_IL_DB
DROP TABLE Transazioni;
DROP TABLE Categorie;
DROP TABLE Budget;