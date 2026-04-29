#pragma once
#include <string>
#include <vector>

struct RigaSpesa {
    int id;
    std::string nome;
    float totale;
};

struct RigaSpesaVsBudget{
    int id;
    std::string nome;
    int mese;
    int anno;
    float speso;
    float limite;
    bool stato;
};


namespace util{
    constexpr bool VUOTO_OK = true;

    void stall();
    int inInt();
    std::vector<std::string> stringToVector(const std::string& testo);
    double inDouble();
    bool inData(std::string& data, int& y, int& m, int& d);
    bool formattaData(const std::string& input, int& y, int& m, int& d);
    bool validaData(std::string& data, int& y, int& m, int& d);
    std::string inString(bool vuoto_ok = false);
}