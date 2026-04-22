#include <iostream>
#include "db.h"
#include <sqlite3.h>
#include <fstream>
#include <sstream>
#include <string>

namespace db_u {
    //FUNZIONI GENERALI
    void init(sqlite3* db){
        std::cout<<"init"<<std::endl;
        //se è vuoto creiamo le tabelle
        if (!checkTabelle(db)){
            creaTabelle(db);
        }
    }
    //Funzione che prepara la query
    sqlite3_stmt* prepare(sqlite3* db, const char* query) {
        sqlite3_stmt* stmt;

        int rc = sqlite3_prepare_v2(db, query, -1, &stmt, nullptr);

        if (rc != SQLITE_OK) {
            std::cerr << "Errore prepare: " << sqlite3_errmsg(db) << std::endl;
            return nullptr;
        }

        return stmt;
    }

    //rifinisce la query
    void bind_int(sqlite3_stmt* stmt, int index, int value) {
        sqlite3_bind_int(stmt, index, value);
    }

    void bind_txt(sqlite3_stmt* stmt, int index, const char* nomeTabella){
        sqlite3_bind_text(stmt, index, nomeTabella, -1, SQLITE_TRANSIENT);
    }

    //funzione per prendere la qery dal file.sql
    std::string getQuery(const std::string& tag){
        //apre il file
        std::ifstream file("../sql/database.sql");
        //Controlla se file è aperto
        if (!file.is_open()) {
            throw std::runtime_error("Impossibile aprire il file SQL");
        }
        //riga contiene la corrente, result accumula per return
        std::string riga, result;
        bool r = false;

        //legge ogni riga del file.sql e mi restituisce la query richiesta
        while (std::getline(file, riga)) {
            //std::cout<<riga<<std::endl;
            if (riga.find("-- " + tag) != std::string::npos) {
                r = true;
                continue;
            }
            if (r && riga.rfind("--", 0) == 0) {
                break; // prossimo blocco
            }
            if (r) {
                result += riga + "\n";
            }
        }

        //controlliamo il risultato
        if (result == ""){
            std::string errStr = "error while finding " + tag + " in database.sql "; 
            return "error";
        }

        return result;
    }

    //legge per step la risposta
    bool step(sqlite3_stmt* stmt) {
        return sqlite3_step(stmt) == SQLITE_ROW;
    }

    //legge le colonne
    const unsigned char* column_text(sqlite3_stmt* stmt, int col) {
        return sqlite3_column_text(stmt, col);
    }

    //libera la memoria
    void finalize(sqlite3_stmt* stmt) {
        sqlite3_finalize(stmt);
    }


    //FUNZIONI SPECIFICHE
    bool checkTabella(sqlite3* db, const char* nomeTabella) {
        const char* query = "SELECT count(*) FROM sqlite_master WHERE type='table' AND name=?;";
        sqlite3_stmt* stmt;
        bool exists = false;

        stmt = prepare(db, query);
        bind_txt(stmt, 1, nomeTabella);

        if (sqlite3_step(stmt) == SQLITE_ROW) {
            // Se il conteggio è 1, la tabella esiste
            exists = sqlite3_column_int(stmt, 0) > 0;
        }

        finalize(stmt);
        return exists;
    }
    
    bool checkTabelle(sqlite3* db){
        //std::cout << "controllo tabelle" << std::endl;
        const char* nomiTabelle[3] = {
            "Categorie",
            "Transazioni",
            "Budget"
        };
        int count = 0;
        for (int i = 0; i < 3; i++){
            //std::cout << "controllo nome " << nomiTabelle[i] << std::endl;
            if (checkTabella(db, nomiTabelle[i])){
                count++;
                //std::cout<<count<<std::endl;
            }
        }
        if (count == 3) {
            return true;
        }else{
            return false;
        }
    }
    
    void creaTabelle(sqlite3* db){
        //CREA LE TABELLE SE NON ESISTONO
        //std::cout << "creo tabelle" << std::endl;
        std::string qstr = getQuery("GENERAZIONE_TABELLE");
        //controllo che la funzione getquery non dia errore, non stampo niente perchè la stampa avviene già nella fnzione
        if (qstr == "error"){
            return;
        }

        //std::cout << qstr << std::endl;
        char* errMsg = nullptr;
        int rc = sqlite3_exec(db, qstr.c_str(), nullptr, nullptr, &errMsg);
        if (rc != SQLITE_OK) {
            std::cerr << "Errore creazione tabelle: " << errMsg << std::endl;
            sqlite3_free(errMsg);
        } else {
            std::cout << "Tabella creata correttamente o già esistente." << std::endl;
        }
    }
    
    std::string getCategorie(sqlite3* db){
        const char* query = "SELECT DISTINCT Nome FROM Categorie";
        sqlite3_stmt* stmt = prepare(db,query);
        std::string response;

        if (stmt == nullptr){
            std::cout << "Errore nell'ottenimento delle categorie, riprova" << std::endl;
            return "1";
        }

        // esegui la query riga per riga
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char* nome = sqlite3_column_text(stmt, 0);
            if (nome) {
                response += reinterpret_cast<const char*>(nome);
                response += "\n";
            }
        }

        sqlite3_finalize(stmt);
        return response;
    }

    int creaCategoria(sqlite3* db, std::string new_name){
        //prendiamo dal file .sql la query corretta
        std::string query = getQuery("CREA_CATEGORIA");
        //controlliamo non ci siano errori nella lettura dal file della query
        if (query == "error"){
            return 1;
        }

        sqlite3_stmt* stmt;
        stmt = prepare(db, query.c_str());
        
        bind_txt(stmt, 1, new_name.c_str());
        int rc = sqlite3_step(stmt);
        finalize(stmt);

        //verifichiamo sia andato 
        if (rc!=SQLITE_DONE){
            std::string errStr = sqlite3_errmsg(db);
            if (errStr == "UNIQUE constraint failed: Categorie.Nome"){
                std::cerr << "Errore nell'inserimento: Categoria "<< new_name << " già esistente" << std::endl;
            }else{
                std::cerr << "Errore nell'inserimento sconosciuto" << std::endl;
            }
            return 1;
        }

        return 0;
    }

    int cercaCategoria(sqlite3* db, std::string name){
        return 1;
    }

    int rinominaCategoria(sqlite3* db, std::string old_name, std::string new_name){

        return 0;
    }
}