#include <iostream>
#include <vector>
#include <sqlite3.h>
#include "report.h"
#include "util.h"
#include "db.h"
#include "categorie.h"

namespace report {
    void open(sqlite3* db) {
        int sel = 0;
            do{
            std::cout << "                                  " << std::endl;
            std::cout << "                                  " << std::endl;
            std::cout << "----------------------------------" << std::endl;
            std::cout << "---------------REPORT-------------" << std::endl;
            std::cout << "----------------------------------" << std::endl;
            std::cout << "1. Totale spese per categoria     " << std::endl;
            std::cout << "2. Spese mensili vs budget        " << std::endl;
            std::cout << "3. Elenco spese per data          " << std::endl;
            std::cout << "4. Indietro.                      " << std::endl;
            std::cout << "----------------------------------" << std::endl;
            std::cout << "Inserisci la tua selezione: ";
            //input utente e validazione
            sel = util::inInt();

            switch (sel){
                case 1:
                    // Totale spese per categoria
                    spesePerCategoria(db);
                    util::stall();
                    break;
                case 2:
                    // Spese mensili vs budget
                    speseMensiliVsBudget(db);
                    util::stall();
                    break;
                case 3:
                    // Elenco completo delle spese ordinate per data
                    elencoSpesePerData(db);
                    util::stall();
                    break;
                case 4:
                    // Ritorna al menu principale
                    break;

                default:
                    std::cout << "Selezione non valida" << std::endl;
                    break;
            }

        } while (sel != 4);
    }

    void spesePerCategoria(sqlite3* db) {
        std::cout << "----------------------------------------------" << std::endl;
        std::cout << "----------Totale spese per categoria----------" << std::endl;
        std::cout << "----------------------------------------------" << std::endl;
        //leggi spese da db, con struct definito in util.h
        std::vector<RigaSpesa> spese = db_u::getSpesePerCategoria(db);
        std::cout << "| Categoria                      | Totale     |" << std::endl;
        std::cout << "-----------------------------------------------" << std::endl;
        
        //PER OGNI RIGA DELLA RISPOSTA DAL DB
        for (int i = 0; i < spese.size(); i++) {
            const RigaSpesa& spesa = spese[i];
            //std::cout << "ID Categoria: " << spesa.id << " - Nome: " << spesa.nome << " - Totale: " << spesa.totale << std::endl;
            
            //Stampa i dettagli della spesa mettendoli in una sorta di tabella con corretta spaziatura
            //tot 46 char - 2 per i 'bordi' | e 2 per gli spazi |
            std::cout << "| ";
            for (int j = 0; j < 30; j++) {
                if (j < spesa.nome.length()) {
                    std::cout << spesa.nome[j];
                } else {
                    std::cout << " ";
                }
            } 
            std::cout << " | " ;
            
            int dopovirgola = -1;
            for (int j = 0; j < 10; j++) {
                std::string totale_str = std::to_string(std::round(spesa.totale * 100.0) / 100.0);
                if (j < totale_str.length()) {
                    if (totale_str[j] == '.') {
                        dopovirgola = 0;
                    }
                    if (dopovirgola >= 0) {
                        dopovirgola++;
                    }
                    if (dopovirgola > 3) {
                        std::cout << " ";
                    } else {
                        std::cout << totale_str[j];
                    }
                } else {
                    std::cout << " ";
                }
            }
            std::cout << " |" << std::endl;
        }
        
        std::cout << "-----------------------------------------------" << std::endl;
    }

    void speseMensiliVsBudget(sqlite3* db) {
        std::cout << "----------------------------------------------" << std::endl;
        std::cout << "----------------Budget Check------------------" << std::endl;
        std::cout << "----------------------------------------------" << std::endl;
        //CHIEDO MESE
        int m = 0;
        bool isMValido = true;
        do{
            if(!isMValido){
                std::cout << "Attenzione! Mese non valido." << std::endl;
                std::cout << "Inserisci un mese valido: " << std::endl;
            }else{
                std::cout << "Inserisci mese di riferimento:" << std::endl;
            }
            m = util::inInt();
            isMValido = (m >= 1 && m <= 12);

        } while (!isMValido);

        //CHIEDO ANNO
        int a = 0;
        bool isAValido = true;
        do{
            if(!isAValido){
                std::cout << "Attenzione! Anno non valido." << std::endl;
                std::cout << "Inserisci un anno valido: " << std::endl;
            }else{
                std::cout << "Inserisci anno di riferimento:" << std::endl;
            }
            a = util::inInt();
            isAValido = (a > 1940 && a < 2200);

        } while (!isAValido);

        //CHIEDO CATEGORIA
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

        db_u::getSpeseMensiliVsBudget(db, m, a, cat);

    }

    void elencoSpesePerData(sqlite3* db) {
        std::cout << "Elenco completo delle spese ordinate per data" << std::endl;
    }

}