#include <iostream>
#include <sqlite3.h>
#include <sstream>
#include <cctype>
#include "util.h"
#include "transazioni.h"
#include "categorie.h"
#include "db.h"

namespace transazioni {
    void open(sqlite3* db) {
        std::cout << "----------------------------------" << std::endl;
        std::cout << "------------INSERISCI-------------" << std::endl;
        std::cout << "-----------NUOVA SPESA------------" << std::endl;
        std::cout << "----------------------------------" << std::endl << std::endl;
        
        //input dell'importo
        double t_d = 0;
        //std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        std::cout << "Inserire l'importo della spesa: " << std::endl;
        t_d = util::inDouble();
        
        //std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        int y,m,d;
        std::string t_data;
        std::cout << "Inserire la data (yyyy-mm-dd) (premere invio per data odierna): " << std::endl;
        //anche in questo caso astratta per ricorsione (se c'è tempo refactoring con while try e catch)
        util::inData(t_data,y,m,d);

        std::string t_cat;
        bool isin = true;
        std::string categorie_esistenti = db_u::getCategorie(db);

        do{
            if (!isin){
                std::cout << "Attenzione! Categoria non esistente." << std::endl;
                std::cout << "Scegli una categoria tra le categorie esistenti: " << std::endl;
                std::cout << categorie_esistenti << std::endl;
            }
            std::cout << "Inserire la categoria: " << std::endl;
            t_cat = util::inString();
            //valida categorie
            isin = categorie::cercaCategoria(categorie_esistenti, t_cat);
        }while(!isin);
            
        std::string t_des;
        std::cout << "Inserire la Descrizione (opzionale): " << std::endl;
        t_des = util::inString(util::VUOTO_OK);

        bool resp = db_u::aggiungiTransazione(db, t_d, t_data, t_cat, t_des);
        
        if (resp){
            std::cout <<"Spesa inserita correttamente"<< std::endl;
        }
    }

}