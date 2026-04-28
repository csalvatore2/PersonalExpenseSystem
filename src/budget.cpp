#include <iostream>
#include <sqlite3.h>
#include "budget.h"
#include "util.h"
#include "db.h"
#include "categorie.h"

namespace budget {
    void open(sqlite3* db) {
        std::cout << "----------------------------------" << std::endl;
        std::cout << "-------------GESTIONE-------------" << std::endl;
        std::cout << "----------BUDGET MENSILE----------" << std::endl;
        std::cout << "----------------------------------" << std::endl << std::endl;    
    
        //input mese e anno
        int m = 0;
        bool isMeseValid = true;
        //verifica validità
        do{
            if (!isMeseValid){
                std::cout << "Attenzione! Mese non valido." << std::endl;
                std::cout << "Inserisci un mese valido: " << std::endl;
            }else{
            std::cout << "Inserire il mese cui il budget si riferisce: " << std::endl;
            }
            m = util::inInt();
            //valida categorie
            isMeseValid = (m > 0 && m <= 12);
        }while(!isMeseValid);

        int y = 0;
        bool isAnnoValid = true;
        //verifica validità
        do{
            if (!isAnnoValid){
                std::cout << "Attenzione! Anno non valido." << std::endl;
                std::cout << "Inserisci un anno valido: " << std::endl;
            }else{
            std::cout << "Inserire l'anno cui il budget si riferisce: " << std::endl;
            }
            y = util::inInt();
            //std::cout << y << std::endl;
            //valida categorie
            isAnnoValid = (y > 1940 && y < 2200);
        }while(!isAnnoValid);
        
        //in categoria
        std::string cat = "";
        bool isin = true;
        std::string categorie_esistenti = db_u::getCategorie(db);

        do{
            if (!isin){
                std::cout << "Attenzione! Categoria non esistente." << std::endl;
                std::cout << "Scegli una categoria tra le categorie esistenti: " << std::endl;
                std::cout << categorie_esistenti << std::endl;
            }
            std::cout << "Inserire la categoria cui il budget si riferisce: " << std::endl;
            cat = util::inString();
            //valida categorie
            isin = categorie::cercaCategoria(categorie_esistenti, cat);
        }while(!isin);
        

        //in importo max
        std::cout << "Inserire l'importo del budget mensile: " << std::endl;
        double imp = util::inDouble();

        bool resp = db_u::creaBudget(db, m, y, cat, imp);

        if (resp){
            std::cout <<"Budget inserito correttamente."<< std::endl;
        }
    }
}