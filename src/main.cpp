#include <iostream>
#include <sqlite3.h>
#include <limits> 
#include "categorie.h"
#include "transazioni.h"
#include "report.h"
#include "budget.h"
#include "db.h"
#include "util.h"

using namespace std;

int main() {
    sqlite3 *db;
    int rc;

    // apriamo database
    rc = sqlite3_open("spese.db", &db);
    //verifichiamo non restituisca errori
    if (rc) {
        cout << "Errore apertura DB: " << sqlite3_errmsg(db) << endl;
        return 1;
    } else {
        //cout << "DB Aperto" << endl;
        //inizializziamo
        db_u::init(db);
    }

        //Messaggio di benvenuto
    cout << "----------------------------------"<< endl;
    cout << "----------------------------------"<< endl;
    cout << "------------Welcome!--------------"<< endl;
    cout << "----------------------------------"<< endl;
    cout << "----------------------------------"<< endl;
    cout << "                                  " << endl;
    util::stall();
    
    int sel = 0;

    do{
        //mostra il menu
        cout << "----------------------------------" << endl;
        cout << "-----SISTEMA--SPESE--PERSONALI----" << endl;
        cout << "----------------------------------" << endl;
        cout << " 1. Gestione Categorie.           " << endl;
        cout << " 2. Inserisci Spesa.              " << endl;
        cout << " 3. Definisci Budget Mensile.     " << endl;
        cout << " 4. Visualizza Report.            " << endl;
        cout << " 5. Esci.                         " << endl;
        cout << "----------------------------------" << endl;
        cout << "                                  " << endl;
        cout << "Inserisci la tua selezione: ";

        //error hand
        sel = util::inInt();
        //puliamo il buffer perchè all'interno delle funzioni utilizzo std::getline;
        //std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

        switch (sel)
        {
        case 1:
            categorie::open(db);
            break;
        case 2:
            transazioni::open(db);
            break;
        case 3:
            budget::open(db);
            break;
        case 4:
            report::open(db);
            break;
        case 5:
            cout << "Exit" << endl;
            break;
        
        default:
            cout << "input non valido" << endl;
            break;
        }
        
    }while (sel != 5);

    

    sqlite3_close(db);
    return 0;
}