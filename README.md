# PersonalExpenceSystem

# 💰 Personal Expense System

Sistema a riga di comando per la gestione delle spese personali e del budget mensile, sviluppato in C++ con database SQLite.

---

## 📋 Requisiti

| Requisito | Versione minima |
|-----------|----------------|
| Compilatore C++ | g++ con supporto C++17 |
| SQLite3 | 3.x |
| Make | qualsiasi versione |

## 🗂️ Struttura del progetto

```
PersonalExpenseSystem/
├── src/
│   └── main.cpp          # Codice sorgente principale
├── sql/
│   ├── database.sql      # Schema del database (CREATE TABLE)
│   └── popola_con_dati.sql  # Dati di esempio (INSERT)
├── demo/
│   └── demo_video.mp4    # Video dimostrativo
├── Makefile
└── README.md
```

---

## ⚙️ Compilazione

```bash
make
```

In alternativa, senza Makefile:

```bash
g++ src/main.cpp -o PersonalExpenseSystem -lsqlite3 -std=c++17
```

---

## ▶️ Avvio del programma

```bash
./PersonalExpenseSystem
```

Al primo avvio il programma crea automaticamente il database SQLite (`spese.db`) nella directory corrente.

### Caricamento dei dati di esempio (opzionale)

```bash
sqlite3 expenses.db < sql/popola_con_dati.sql
```

---

## 🧭 Funzionalità principali

- **Gestione categorie** — aggiunta e rinomina categorie di spesa
- **Registrazione transazioni** — inserimento spese con data, importo, categoria e descrizione
- **Budget mensile** — impostazione di un limite di spesa per categoria e mese
- **Report spese per categoria** — totale speso per ciascuna categoria
- **Report spese vs budget** — confronto tra speso e budget impostato per un dato mese
- **Storico spese** — elenco delle transazioni in un intervallo di date

---

## 🗄️ Database

Il database è gestito tramite SQLite (file locale `expenses.db`) e contiene tre tabelle:

- **Categorie** — elenco delle categorie di spesa
- **Transazioni** — registro delle spese
- **Budget** — budget mensile per categoria

Lo schema completo con tutti i vincoli è disponibile in `sql/database.sql`.

---

## 👤 Autore

Salvatore C. — Progetto finale di Programmazione