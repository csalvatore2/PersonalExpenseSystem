#include <iostream>
#include "db.h"
#include "util.h"
#include <sqlite3.h>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>


namespace db_u {
    //FUNZIONI GENERALI
    void init(sqlite3* db){
        //std::cout<<"init"<<std::endl;
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

    void bind_double(sqlite3_stmt* stmt, int index, double value){
        sqlite3_bind_double(stmt, index, value);    
    }        

    //funzione per prendere la qery dal file.sql
    std::string getQuery(const std::string& tag){
        //apre il file
        std::ifstream file("./sql/database.sql");
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

    int rinominaCategoria(sqlite3* db, std::string old_name, std::string new_name){
        std::string query = getQuery("RINOMINA_CATEGORIA");
        if (query == "error"){
            std::cout << "errore nel fetch da f.sql." << std::endl;
            return 1;
        }

        //std::cout << query << std::endl;
        ////old_name = "\""+ old_name + "\"";
        ////new_name = "\""+ new_name + "\"";
        //std::cout << new_name << std::endl;
        //std::cout << old_name << std::endl;
        
        sqlite3_stmt* stmt;
        stmt = prepare(db, query.c_str());
        
        bind_txt(stmt, 1, new_name.c_str());
        bind_txt(stmt, 2, old_name.c_str());
        int rc = step(stmt);
        finalize(stmt);
        std::string errStr = sqlite3_errmsg(db);

        if (rc!=SQLITE_DONE && errStr != "not an error"){
            std::cerr << "Errore nell'inserimento. Messaggio errore: " << errStr << std::endl;
            return 1;
        }else{
            return 0;
        }

    }

    bool aggiungiTransazione(sqlite3* db, double importo, std::string data, std::string cat, std::string desc){
        //prendiamo dal file .sql la query corretta
        //Consideriamo 2 casi, uno con CURRENT DATE e l'altro normale
        if(data == "CURRENT_DATE"){
            std::string query = getQuery("ADD_TRANSAZIONE_CD");
            //controlliamo non ci siano errori nella lettura dal file della query
            if (query == "error"){
                return false;
            }
            //trasforma il nome della categoria in id
            int id = getCatID(db, cat);
    
            double t_importo = importo;
            sqlite3_stmt* stmt;
            stmt = prepare(db, query.c_str());
            bind_double(stmt, 1, importo);
            bind_int(stmt, 2, id);
            bind_txt(stmt, 3, desc.c_str());
            int rc = sqlite3_step(stmt);
            finalize(stmt);
            //verifichiamo sia andato 
            if (rc!=SQLITE_DONE){
                std::string errStr = sqlite3_errmsg(db);
                std::cerr << "Errore nell'inserimento della transazione" << std::endl;
                return false;
            }
            return true;
        }else{
            std::string query = getQuery("ADD_TRANSAZIONE");
            //controlliamo non ci siano errori nella lettura dal file della query
            if (query == "error"){
                return false;
            }
    
            //trasforma il nome della categoria in id
            int id = getCatID(db, cat);
    
            sqlite3_stmt* stmt;
            stmt = prepare(db, query.c_str());
            
            bind_double(stmt, 1, importo);
            bind_txt(stmt, 2, data.c_str());
            bind_int(stmt, 3, id);
            bind_txt(stmt, 4, desc.c_str());
            int rc = sqlite3_step(stmt);
            finalize(stmt);
    
            //verifichiamo sia andato 
            if (rc!=SQLITE_DONE){
                std::string errStr = sqlite3_errmsg(db);
                std::cerr << "Errore nell'inserimento della transazione" << std::endl;
                return false;
            }
    
            return true;
        }
    }

    int getCatID(sqlite3* db, std::string cat){
        int id = -1;
        //ottendo la q dal file.sql
        std::string query = getQuery("GET_ID_CATEGORIA");

        if (query == "error"){
            return id;
        }

        sqlite3_stmt* stmt;
        stmt = prepare(db, query.c_str());

        bind_txt(stmt, 1, cat.c_str());
        //mi aspetto solo una riga
        int rc = sqlite3_step(stmt);

        if (rc == SQLITE_ROW){
            id = sqlite3_column_int(stmt, 0);
        }

        finalize(stmt);

        return id;

    }

    bool creaBudget(sqlite3* db, int m, int y, std::string cat, double imp){
        std::string query = getQuery("ADD_BUDGET");

        if (query == "error"){
            std::cout << "Errore nella lettura della query." << std::endl;
            return false;
        }
        //trasforma il nome della categoria in id
        int id = getCatID(db, cat);

        sqlite3_stmt* stmt;
        stmt = prepare(db, query.c_str());

        bind_int(stmt, 1, m);
        bind_int(stmt, 2, y);
        bind_int(stmt, 3, id);
        bind_double(stmt, 4, imp);
        int rc = sqlite3_step(stmt);
        finalize(stmt);
        if (rc!=SQLITE_DONE){
            std::string errStr = sqlite3_errmsg(db);
            std::cerr << "Errore nell'inserimento del budget." << std::endl;
            return false;
        }
        return true;

    }

    std::vector<RigaSpesa> getSpesePerCategoria(sqlite3* db){
        std::string query = getQuery("SPESE_PER_CATEGORIA");

        if (query == "error"){
            std::cout << "Errore nella lettura della query." << std::endl;
            return {};
        }

        //std::cout << "Query trovata con successo: " << std::endl;
        
        sqlite3_stmt* stmt;
        stmt = prepare(db, query.c_str());
        
        //std::cout << "Query preparata con successo: " << std::endl;
        std::vector<RigaSpesa> spese;
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //std::cout << "Riga n letta con successo: " << std::endl;
            double spesa = sqlite3_column_double(stmt, 2);
            int id = sqlite3_column_int(stmt, 0);
            std::string nome = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 1));
            RigaSpesa r;
            r.id = id;
            r.nome = nome;
            r.totale = spesa;
            spese.push_back(r);
        }

        finalize(stmt);
        return spese;
    }

    RigaSpesaVsBudget getSpeseMensiliVsBudget(sqlite3* db, int m, int y, std::string cat){
        std::string query = getQuery("SPESE_MENSILI_VS_BUDGET");

        if (query == "error"){
            std::cout << "Errore nella lettura della query." << std::endl;
            return {};
        }

        sqlite3_stmt* stmt;
        stmt = prepare(db, query.c_str());

        bind_txt(stmt, 1, cat.c_str());
        bind_int(stmt, 2, m);
        bind_int(stmt, 3, y);

        RigaSpesaVsBudget speseVsBudget;

        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int id_cat = -1;
            id_cat = sqlite3_column_int(stmt, 0);
            std::string cat = "";
            cat = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 1));
            int mese = -1;
            mese = sqlite3_column_int(stmt, 2);
            int yr = -1;
            yr = sqlite3_column_int(stmt, 3);
            double spesa = 0;
            spesa = sqlite3_column_double(stmt, 4);
            double budget = 0;
            budget = sqlite3_column_double(stmt, 5);
            bool s = (spesa < budget);
            RigaSpesaVsBudget r;
            r.id = id_cat;
            r.nome = cat;
            r.mese = mese;
            r.anno = yr;
            r.speso = spesa;
            r.limite = budget;
            r.stato = s;
            speseVsBudget = r;
        }


        finalize(stmt);
        return speseVsBudget;
    }

    std::vector<spesa> getSpeseTraDate(sqlite3* db, std::string data1, std::string data2){
        //verifichiamo se e quale data è CD e usiamo query diverse
        bool d1cd = false;
        bool d2cd = false;
        std::string query;
        if(data1 =="CURRENT_DATE" && data2 == "CURRENT_DATE"){
            query = getQuery("SPESE_TRA_DATE_CD_B");
            d1cd = d2cd = true;
        }else if(data1 == "CURRENT_DATE" && data2 != "CURRENT_DATE"){
            query = getQuery("SPESE_TRA_DATE_CD");
            d1cd = true;
            d2cd = false;
        }else if(data2 == "CURRENT_DATE" && data1 != "CURRENT_DATE"){
            query = getQuery("SPESE_TRA_DATE_CD");
            d1cd = false;
            d2cd = true;
        }else{
            query = getQuery("SPESE_TRA_DATE");
            d1cd = d2cd = false;
        }

        if (query == "error"){
            std::cout << "Errore nella lettura della query." << std::endl;
            return {};
        }

        sqlite3_stmt* stmt;
        stmt = prepare(db, query.c_str());

        if(d1cd && d2cd){
            
        }else if(d1cd && !d2cd){
            bind_txt(stmt, 1, data2.c_str());
            bind_txt(stmt, 2, data2.c_str());
        }else if(!d1cd && d2cd){
            bind_txt(stmt, 1, data1.c_str());
            bind_txt(stmt, 2, data1.c_str());
        }else{
            bind_txt(stmt, 1, data1.c_str());
            bind_txt(stmt, 2, data2.c_str());
        }

        std::vector<spesa> spese;

        while (sqlite3_step(stmt) == SQLITE_ROW) {
            double importo = sqlite3_column_double(stmt, 2);
            std::string data = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 1));
            std::string cat = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 4));
            std::string desc = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 3));
            spesa s;
            s.data = data;
            s.importo = importo;
            s.descrizione = desc;
            s.categoria = cat;
            spese.push_back(s);
        }

        finalize(stmt);
        return spese;
    }
}