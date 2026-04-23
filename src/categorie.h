#pragma once
#include <sqlite3.h>
#include <vector>
#include <sstream>


namespace categorie{
    void stall();
    void open(sqlite3* db);
    void visualizzaCategorie(sqlite3* db);
    int creaCategoria(sqlite3* db, std::string new_name);
    int rinominaCategoria(sqlite3* db);
    std::vector<std::string> stringToVector(const std::string& testo);
    std::string underscoretospace(std::string s);
    std::string spacetounderscore(std::string s);
    bool notSpaceNoNewline(char c);
}