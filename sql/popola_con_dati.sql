-- CREA TABELLE SE NON ESISTONO
CREATE TABLE IF NOT EXISTS Categorie (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    Nome varchar(255) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Transazioni (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    Data date NOT NULL,
    Importo decimal(10, 2) NOT NULL CHECK (Importo > 0),
    Descrizione varchar(600),
    Categoria int NOT NULL,

    FOREIGN KEY (Categoria) REFERENCES Categorie(id)
);

CREATE TABLE IF NOT EXISTS Budget(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    Importo_max decimal(10, 2) NOT NULL CHECK (Importo_max > 0),
    Mese int NOT NULL CHECK (Mese >= 1 AND Mese <= 12),
    Anno int NOT NULL CHECK (Anno > 0),
    Categoria int NOT NULL,

    UNIQUE (Mese, Anno, Categoria),
    FOREIGN KEY (Categoria) REFERENCES Categorie(id)
);

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
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (45.20, '2026-02-02', 1, 'Spesa supermercato');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (780.00, '2026-02-04', 2, 'Manutenzione casa - riparazione impianto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (22.50, '2026-02-05', 3, 'Carburante rifornimento');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (15.00, '2026-02-06', 5, 'Piccole forniture casa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (9.99, '2026-02-08', 6, 'Abbonamento app mensile');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (60.75, '2026-02-10', 1, 'Spesa settimanale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (850.00, '2026-02-11', 2, 'Affitto parziale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (3.20, '2026-02-12', 5, 'Caffè e snack');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (12.99, '2026-02-14', 6, 'Streaming musicale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (30.00, '2026-02-15', 4, 'Cinema con amici');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (48.40, '2026-02-17', 1, 'Cena veloce fuori');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (25.00, '2026-02-18', 3, 'Taxi notturno');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (120.00, '2026-02-20', 5, 'Riparazione piccolo elettrodomestico');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (16.80, '2026-02-21', 1, 'Frutta e verdura');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (14.50, '2026-02-22', 4, 'Biglietto per mostra');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (7.50, '2026-02-24', 3, 'Biglietto autobus');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (49.99, '2026-02-27', 6, 'Rinnovo servizio cloud');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (55.00, '2026-03-01', 1, 'Spesa mensile');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (900.00, '2026-03-03', 2, 'Affitto marzo');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (65.25, '2026-03-04', 3, 'Carburante e pedaggi');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (120.00, '2026-03-06', 4, 'Concerto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (18.30, '2026-03-07', 5, 'Materiale ufficio');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (12.99, '2026-03-09', 6, 'Abbonamento app');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (28.00, '2026-03-10', 1, 'Spesa settimanale extra');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (40.00, '2026-03-12', 3, 'Manutenzione auto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (85.00, '2026-03-13', 4, 'Cena importante');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (5.50, '2026-03-15', 5, 'Piccole spese varie');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (32.90, '2026-03-17', 1, 'Spesa mercato');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (14.00, '2026-03-18', 3, 'Taxi breve');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (49.99, '2026-03-20', 6, 'Servizio digitale annuale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (210.00, '2026-03-22', 2, 'Intervento idraulico');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (75.00, '2026-03-24', 4, 'Weekend fuori');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (19.60, '2026-03-25', 1, 'Colazione al bar');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (60.00, '2026-03-27', 3, 'Rifornimento auto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (29.99, '2026-03-30', 6, 'Abbonamento digitale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (95.40, '2026-04-01', 1, 'Spesa mensile grande');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (880.00, '2026-04-02', 2, 'Affitto aprile');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (42.00, '2026-04-04', 3, 'Tagliando auto');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (160.00, '2026-04-06', 4, 'Evento e biglietti');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (11.20, '2026-04-07', 5, 'Materiale casa');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (14.99, '2026-04-09', 6, 'Abbonamento mensile');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (35.00, '2026-04-10', 1, 'Spesa settimanale');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (60.00, '2026-04-12', 3, 'Carburante e pedaggi');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (120.00, '2026-04-14', 4, 'Cena con amici');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (7.80, '2026-04-16', 5, 'Caffè e snack');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (49.99, '2026-04-18', 6, 'Servizio cloud mensile');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (28.50, '2026-04-20', 1, 'Spesa veloce');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (120.00, '2026-04-21', 2, 'Bolletta annuale frazionata');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (22.00, '2026-04-23', 3, 'Biglietto autobus e metro');
INSERT INTO Transazioni (Importo, Data, Categoria, Descrizione) VALUES (80.00, '2026-04-25', 4, 'uscita serale');

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