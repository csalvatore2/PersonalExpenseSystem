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