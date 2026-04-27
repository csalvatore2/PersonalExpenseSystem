#include <iostream>
#include <vector>
#include <sstream>
#include "util.h"


namespace util{
    void stall(){
        //aspettare che l'utente prema invio prima di riproporre il menu
        std::cout << "Premi invio per continuare...";
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        std::cout << "                                  " << std::endl;
        std::cout << "                                  " << std::endl;
    }

    int inInt(){
        std::string input;
        while (true) {
            std::getline(std::cin, input);
            try {
                size_t idx;
                int value = std::stoi(input, &idx);

                if (idx == input.size()) {
                    return value;
                }
            } catch (...) {}
            std::cout << "Inserisci un numero intero valido: ";
        }
    }

    std::vector<std::string> stringToVector(const std::string& testo) {
        std::vector<std::string> risultato;
        std::stringstream ss(testo);
        std::string riga;

        while (std::getline(ss, riga)) {
            // rimuovi spazi finali (tipo "Franco ")
            riga.erase(riga.find_last_not_of(" \n\r\t") + 1);

            // evita righe vuote
            if (!riga.empty()) {
                risultato.push_back(riga);
            }
        }

        return risultato;
    }

    double inDouble() {
        std::string input;

        while (true) {
            std::getline(std::cin, input);

            //rimuove spazi
            input.erase(remove_if(input.begin(), input.end(), ::isspace), input.end());
            //sostituisce virgola con punto
            for (char& c : input) {
                if (c == ',') c = '.';
            }
            //controlla che sia un formato plausibile
            bool punto = false;
            bool valido = true;
            //itera ogni carattere
            for (size_t i = 0; i < input.size(); i++) {
                char c = input[i];
                //se è una cifra, prossimo loop
                if (std::isdigit(c)) continue;
                //se è un punto prossimo loop e lo segnaliamo nel bool
                if (c == '.' && !punto) {
                    punto = true;
                    continue;
                }
                //se non è nessuno dei due, rompiamo il loop e segnaliamo la non validità
                valido = false;
                break;
            }
            //de non è valido, riproponiamo la domanda da capo
            if (!valido || input.empty() || input == "." ) {
                std::cout << "Input non valido, riprova: ";
                continue;
            }

            //conversione finale con punto per ritornare il valore (la virgola è già stata sostituita)
            try {
                size_t idx;
                //idx ci dice se tutta la stringa è stata convertita, in modo da verificare non sia stato immesso un insieme di numeri e lettere
                double value = std::stod(input, &idx);
                //controlliamo anche sia positivo
                if (idx != input.size() || value < 0.0) {
                    std::cout << "Input non valido, riprova: ";
                    continue;
                }
                return value;
            //qualsiasi errore nella conversione riprende l'input
            } catch (...) {
                std::cout << "Input non valido, riprova: ";
            }
        }
    }

    bool inData(std::string& data, int& y, int& m, int& d){
        //std::cout << "Inserire la data (yyyy-mm-dd) (premere invio per data odierna): " << std::endl;
        //svuota il buffer prima di chiedere nuovo input
        std::getline(std::cin, data);

        if(data==""){
            data = "CURRENT_DATE";
            return true;
        }else{
            if(!formattaData(data, y, m, d) || !validaData(data, y, m, d)){
                std::cout << "inserisci data valida (yyyy/mm/dd): " << std::endl;
                return inData(data, y, m, d);
            }else{
                //rifutiamo il caso in cui l'anno sia precedente al 1900
                if (y < 1900){
                    std::cout << "inserisci formato anno valido yyyy/mm/dd: " << std::endl;
                    return inData(data, y, m, d);
                }
                data = std::to_string(y) + "-" +
                    (m < 10 ? "0" : "") + std::to_string(m) + "-" +
                    (d < 10 ? "0" : "") + std::to_string(d);
                return true;
            }
        }
    }

    bool validaData(std::string& data, int& y, int& m, int& d){
        //verifichiamo che non sia una data assurda
        if (m < 1 || m > 12) return false;
        int giorni[] = {31,28,31,30,31,30,31,31,30,31,30,31};
        // calcoliamo il caso bisestile
        if ((y % 4 == 0 && y % 100 != 0) || (y % 400 == 0)) {
            giorni[1] = 29;
        }
        return d >= 1 && d <= giorni[m - 1];
    }

    bool formattaData(const std::string& input, int& y, int& m, int& d) {
        //funzione per formattare e leggere la data correttamente, cercando di accettare 
        //più formattazioni possibili, purchè in ordine anno-mese-giorno
        std::string pulito;
        // sostituisci tutto ciò che non è cifra con spazio
        for (char c : input) {
            if (std::isdigit(c))
                pulito += c;
            else
                pulito += ' ';
        }
        std::istringstream iss(pulito);
        // prova a leggere 3 numeri
        if (iss >> y >> m >> d) {
            return true;
        }

        // caso speciale: yyyymmdd
        std::string digits;
        for (char c : input) {
            if (std::isdigit(c)) digits += c;
        }

        if (digits.size() == 8) {
            y = std::stoi(digits.substr(0, 4));
            m = std::stoi(digits.substr(4, 2));
            d = std::stoi(digits.substr(6, 2));
            return true;
        }
        return false;
    }

    std::string inString(bool vuoto_ok) {
        std::string input;

        while (true) {
            std::getline(std::cin, input);

            // rimuove spazi iniziali
            input.erase(0, input.find_first_not_of(" \t\r\n"));

            // rimuove spazi finali
            input.erase(input.find_last_not_of(" \t\r\n") + 1);

            if (!input.empty() || vuoto_ok) {
                return input;
            }

            std::cout << "Inserisci un testo valido: ";
        }
    }
}