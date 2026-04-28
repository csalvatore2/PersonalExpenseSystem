#include <iostream>
#include <sqlite3.h>

namespace report{
    void open(sqlite3* db);
    void spesePerCategoria(sqlite3* db);
    void speseMensiliVsBudget(sqlite3* db);
    void elencoSpesePerData(sqlite3* db);
}