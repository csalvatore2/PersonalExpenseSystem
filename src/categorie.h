#pragma once
#include <sqlite3.h>
#include <vector>
#include "util.h"

namespace categorie{
    void open(sqlite3* db);
    std::string visualizzaCategorie(sqlite3* db);
    int creaCategoria(sqlite3* db, std::string new_name);
    int rinominaCategoria(sqlite3* db);
    bool cercaCategoria(std::string DBlist, std::string nome);
}