#include <string>

void unsused() {
    std::string s;
    s.c_str();
    s.size();
    s.push_back('a');
    s.pop_back();
    std::string copy(s);
    copy += s;
    copy += "a";
    copy += 'a';
}

std::string* getStringPtr() {
    static std::string s("string from ptr");
    return &s;
}

std::string& getStringRef() {
    static std::string s("string from ref");
    return s;
}

std::string getStringCopy() {
    return "string copy";
}