all:
	g++ -std=c++17 src/main.cpp src/categorie.cpp src/transazioni.cpp src/db.cpp src/util.cpp src/budget.cpp src/report.cpp -lsqlite3 -o app

popola:
	rm -f sql/spese.db
	sqlite3 sql/spese.db < sql/popola_con_dati.sql

reset_db:
	rm -f sql/spese.db