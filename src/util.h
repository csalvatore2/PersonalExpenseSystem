#pragma once
#include <string>
#include <vector>

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