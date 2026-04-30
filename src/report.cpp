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

        RigaSpesaVsBudget resp = db_u::getSpeseMensiliVsBudget(db, m, a, cat);

        std::cout << "-----------------------------------------------" << std::endl;
        std::cout << "-----------------Report------------------------" << std::endl;
        std::cout << "-----------------------------------------------" << std::endl;

        if (resp.id == -1 || resp.mese == -1
            || resp.anno == -1  || resp.nome == "") {
            std::cout << "Risposta invalida dal db." << std::endl;
            std::cout << "Nome Categoria: " << resp.nome << std::endl;
            std::cout << "Mese:           " << resp.mese << std::endl;
            std::cout << "Anno:           " << resp.anno << std::endl;
            std::cout << "Spesa:          " << resp.speso << std::endl;
            std::cout << "Budget:         " << resp.limite << std::endl;
        }
        else{
            float perc = round(((resp.speso / resp.limite) * 100)*100.0) / 100.0;
            std::cout << "Nome Categoria: " << resp.nome << std::endl;
            std::cout << "Mese:           " << resp.mese << std::endl;
            std::cout << "Anno:           " << resp.anno << std::endl;
            std::cout << "Spesa:          " << resp.speso << std::endl;
            std::cout << "Budget:         " << resp.limite << std::endl;
            std::cout << "Percentuale:    " << perc << "%" << std::endl;
            if (resp.stato) {
                std::cout << "ENTRO IL BUDGET" << std::endl;
            } else {
                std::cout << "SUPERAMENTO BUDGET" << std::endl;
            }
        }
        std::cout << "-----------------------------------------------" << std::endl << std::endl;

    }

    void elencoSpesePerData(sqlite3* db) {
        std::cout << "-----------------------------------------------" << std::endl;
        std::cout << "---------------------Spese---------------------" << std::endl;
        std::cout << "-----------------------------------------------" << std::endl;

        //voglio far leggere le spese tra due date
        std::string data1, data2;
        int y1,m1,d1,y2,m2,d2;

        std::cout << "Inserire la data di inizio del periodo (premere invio per data odierna): " << std::endl;
        
        bool res = util::inData(data1, y1, m1, d1);
        if (!res){
            std::cout << "Data non valida, ritorno al menu report" << std::endl;
            return;
        }
        std::cout << "Inserire la data di fine del periodo (premere invio per data odierna): " << std::endl;
        res = util::inData(data2, y2, m2, d2);

        if (!res){
            std::cout << "Data non valida, ritorno al menu report" << std::endl;
            return;
        }
        // Controllo che la data di inizio sia precedente a quella di fine
        if (y1 > y2 || (y1 == y2 && m1 > m2) || (y1 == y2 && m1 == m2 && d1 > d2)){
            std::swap(data1, data2);
        }

        std::vector<spesa> spese = db_u::getSpeseTraDate(db, data1, data2);
        std::cout << "---------------------------------------------------------------------------" << std::endl;
        std::cout << "| Data       | Importo   | Categoria       | Descrizione                   |" << std::endl;
        std::cout << "---------------------------------------------------------------------------" << std::endl;
        
        // Data       | Importo   | Categoria       | Descrizione                   |
        // 2023-01-07 | 100000.00 | AAAAAAAAAAA     | Descrizione1                  |
        //      11    |      10   | 16.             | 30.                           |
        
        //PER OGNI RIGA DELLE SPESE
        for (int i = 0; i < spese.size(); i++){
            const spesa& spesa = spese[i];
            std::cout << "| ";
            //STAMPA COLONNA DATA
            for (int j = 0; j < 11; j++) {
                if (j < spesa.data.length()) {
                    std::cout << spesa.data[j];
                } else {
                    std::cout << " ";
                }
            }
            //STAMPA COLONNA IMPORTO
            std::cout << "| ";
            int dopovirgola = -1;
            for (int j = 0; j < 10; j++) {
                std::string importo_str = std::to_string(std::round(spesa.importo * 100.0) / 100.0);
                if (j < importo_str.length()) {
                    if (importo_str[j] == '.') {
                        dopovirgola = 0;
                    }
                    if (dopovirgola >= 0) {
                        dopovirgola++;
                    }
                    if (dopovirgola > 3) {
                        std::cout << " ";
                    } else {
                        std::cout << importo_str[j];
                    }
                } else {
                    std::cout << " ";
                }
            }
            //STAMPA COLONNA CATEGORIA
            std::cout << "| ";
            for (int j = 0; j < 16; j++) {
                if (j < spesa.categoria.length()) {
                    std::cout << spesa.categoria[j];
                } else {
                    std::cout << " ";
                }
            }
            //STAMPA COLONNA DESCRIZIONE
            std::cout << "| ";
            for (int j = 0; j < 30; j++) {
                if (j < spesa.descrizione.length()) {
                    std::cout << spesa.descrizione[j];
                } else {
                    std::cout << " ";
                }
            }
            std::cout << "|" << std::endl;
            
        }
        std::cout << "---------------------------------------------------------------------------" << std::endl;
    }

}