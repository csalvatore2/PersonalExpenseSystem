#pragma once
#include <iostream>
#include <sqlite3.h>

namespace db_u{
    void init(sqlite3* db);
    sqlite3_stmt* prepare(sqlite3* db, const char* query);
    void bind_int(sqlite3_stmt* stmt, int index, int value);
    void bind_txt(sqlite3_stmt* stmt, int index, const char* nomeTabella);
    std::string getQuery(const std::string& tag);
    bool step(sqlite3_stmt* stmt);
    const unsigned char* column_text(sqlite3_stmt* stmt, int col);
    void finalize(sqlite3_stmt* stmt);
    bool checkTabella(sqlite3* db);
    bool checkTabelle(sqlite3* db);
    void creaTabelle(sqlite3* db);
    std::string getCategorie(sqlite3* db);
    int creaCategoria(sqlite3* db, std::string new_name);
    int rinominaCategoria(sqlite3* db, std::string old_name, std::string new_name);
    int cercaCategoria(sqlite3* db, std::string name);
}

