#include <iostream>
#include "categorie.h"
#include "db.h"
#include <sqlite3.h>
#include <algorithm>
#include <sstream>


namespace categorie{
    void open(sqlite3* db){
        int sel = 0;
        do{
            //mostra menu
            std::cout << "                                  " << std::endl;
            std::cout << "                                  " << std::endl;
            std::cout << "----------------------------------" << std::endl;
            std::cout << "--------GESTIONE  CATEGORIE-------" << std::endl;
            std::cout << "----------------------------------" << std::endl;
            std::cout << "1. Visualizza Categorie.          " << std::endl;
            std::cout << "2. Crea Nuova Categoria.          " << std::endl;
            std::cout << "3. Rinomina   Categoria.          " << std::endl;
            std::cout << "4. Indietro.                      " << std::endl;
            std::cout << "----------------------------------" << std::endl;
            std::cout << "Inserisci la tua selezione: ";

            
            //seleziona voce
            //verifica validità input
            if (!(std::cin >> sel)) {
                std::cin.clear();
                std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
                std::cout << "Input non valido.\n";
                continue;
            }
            std::cout << "                                  " << std::endl;
            
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            
            switch(sel){
                case 1:
                    //Vedere categorie presenti
                    std::cout << "----------------------------------" << std::endl;
                    std::cout << "------VISUALIZZA CATEGORIE--------" << std::endl;
                    std::cout << "----------------------------------" << std::endl;

                    visualizzaCategorie(db);
                    stall();
                    break;
                case 2:
                {
                    std::cout << "----------------------------------" << std::endl;
                    std::cout << "---------CREA CATEGORIA-----------" << std::endl;
                    std::cout << "----------------------------------" << std::endl;
                    //Creare Nuova Categoria
                    //fai inserire nuovo nome
                    std::cout << "Inserisci il nome della categoria che desideri aggiungere: " << std::endl;
                    std::string new_name;
                    std::getline(std::cin, new_name);
                    //Valida stringa
                    if (new_name.length() < 3){
                        std::cout << "Inserisci un nome con almeno tre lettere." << std::endl;
                        break;
                    }
                    
                    //collegati con db
                    //aggiungi la categoria
                    int result = creaCategoria(db, new_name);
                    
                    //messaggio di conferma
                    if (result == 0){
                        std::cout << "Hai aggiunto " << new_name << std::endl;
                    }

                    stall();
                    break;
                }
                case 3:
                {
                    //rinominare vecchia categoria
                    std::cout << "----------------------------------" << std::endl;
                    std::cout << "-------RINOMINA CATEGORIA---------" << std::endl;
                    std::cout << "----------------------------------" << std::endl;

                    //astraiamo maggiormente per poter chiamare ricorsivamente la funzione 
                    rinominaCategoria(db);
                    stall();
                    break;
                }
                case 4:

                    std::cout << "" << std::endl;
                    break;
                default:
                    
                    std::cout << "Selezione non valida" << std::endl;
                    break;
            }

        }while(sel != 4);  
    }

    void stall(){
        //aspettare che l'utente prema invio prima di riproporre il menu
        std::cout << "Premi invio per continuare...";
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        std::cout << "                                  " << std::endl;
        std::cout << "                                  " << std::endl;
    }

    void visualizzaCategorie (sqlite3* db) {
        //leggi categorie da db
        std::string resp = db_u::getCategorie(db);

        //Stampale
        if (resp != "0"){
            std::cout << resp << std::endl;
        }else{
            std::cout << "errore nella lettura delle categorie" << std::endl;
        }
    }

    int creaCategoria(sqlite3* db, std::string new_name){
        //crea nuova categoria
        int resp = db_u::creaCategoria(db, new_name);
        //verifica sia tutto ok;
        if (resp == 0){
            return 0;
        }else{
            return 1;
        }
    }

    int rinominaCategoria(sqlite3* db){
        //TODO PROBLEMI CON PAROLE DOPPIE
        //seleziona categoria
        std::cout << "Inserisci il nome della categoria che desideri rinominare: " << std::endl;
        std::string old_name;
        std::getline(std::cin, old_name);

        // Verifica la presenza del nome nel db
        // ottiene tutte le categorie
        std::string DBlist = db_u::getCategorie(db);
        std::string tmp_old_name = old_name;
        // confronta la stringa di risposta con il nome inserito
        // metto tutto in lowercase
        std::transform(tmp_old_name.begin(), tmp_old_name.end(), tmp_old_name.begin(), ::tolower);
        std::transform(DBlist.begin(), DBlist.end(), DBlist.begin(), ::tolower);
        
        bool trovato = false;
        std::stringstream slist(DBlist);
        std::string riga;
        while (std::getline(slist, riga)) {
            // togliamo eventuali spazi di troppo
            riga.erase(riga.find_last_not_of(" \n\r\t") + 1);

            if (riga == tmp_old_name) {
                trovato = true;
                break;
            }
        }
        slist.clear();              // reset flag (EOF, errori)
        slist.seekg(0);             // torna all'inizio

        if (!trovato){
            //in caso di errore nella selezione, mostra tutte le categorie e riavvia il processo
            std::cout << "Categoria " << old_name << " non trovata " << std::endl << "seleziona una tra le seguenti categorie" << std::endl;
            visualizzaCategorie(db);
            rinominaCategoria(db);
            return 1;
        }else{
            //selezionare il nuovo nome da dare
            std::cout << "Inserisci il nuovo nome per la categoria " << old_name << ":" << std::endl;
            std::string new_name;
            std::getline(std::cin, new_name);

            //verifica che il nome non sia uguale al precedente o ad uno già nel db
            std::string tmp_new_name = new_name;
            std::transform(tmp_new_name.begin(), tmp_new_name.end(), tmp_new_name.begin(), ::tolower);
            //verifica che il nome non sia uguale al precedente
            if (tmp_new_name == tmp_old_name){
                std::cout << "Attenzione: il nome della categoria è uguale al precedente" << std::endl;
                return 1;
            }else
            {   
                //verifica che il nome non sia uguale ad uno già nel db
                bool t = false;
                //stesso processo di old_name, questa volta con new_name
                std::stringstream sl(DBlist);
                std::string r;
                std::cout << "confronto: " << tmp_new_name << DBlist << std::endl;
                while (std::getline(sl, r)) {
                    // togliamo eventuali spazi di troppo
                    riga.erase(r.find_last_not_of(" \n\r\t") + 1);
                    std::cout << "confronto: " << tmp_new_name << r << std::endl;
                    if (r == tmp_new_name) {
                        t = true;
                        break;
                    }
                }
                if (t){
                    std::cout << "Attenzione: il nome della categoria è già presente" << std::endl;
                    return 1;
                }
            }

            //cambia il nome nella colonna (senza nessun problema, le altre si riferiscono all'id)
            int resp = db_u::rinominaCategoria(db, old_name, new_name);
            //verifica sia tutto ok;
            //messaggio di conferma
            if (resp == 0){
                std::cout << "Hai cambiato il nome della categoria " <<old_name << " in " <<  new_name << std::endl;
                return 0;
            }else{
                std::cout << "Errore sconosciuto nel tentativo di cambiare il nome della categoria " << old_name << " in " <<  new_name << std::endl;
                return 1;
            }
        }
    }
}


