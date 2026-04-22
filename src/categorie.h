#pragma once
#include <sqlite3.h>


namespace categorie{
    void stall();
    void open(sqlite3* db);
    void visualizzaCategorie(sqlite3* db);
    int creaCategoria(sqlite3* db, std::string new_name);
    int rinominaCategoria(sqlite3* db);
}