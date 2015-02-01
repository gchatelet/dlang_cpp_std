#include <string>
#include <vector>

///////////////////////////////////////////////////////////////////////////////
// Instantiation of templates
///////////////////////////////////////////////////////////////////////////////

namespace ctor_test {
  struct Counter {
    int ctor = 0;
    int ctor_copy = 0;
    int dtor = 0;
  };
  
  template<typename T>
  struct RAII {
    RAII(Counter* ptr) : counter_(ptr) { ++counter_->ctor; }
    RAII(const RAII& other) : counter_(other.counter_) { ++counter_->ctor_copy; }
    ~RAII() { ++counter_->dtor; }
    private:
      Counter* counter_ = nullptr;
  };
}

void instantiateRaii() {
  ctor_test::Counter counter;
  ctor_test::RAII<int> raii(&counter);
  ctor_test::RAII<int> rai_copy(raii);
}

void instantiateString() {
  std::string s;
  s.c_str();
  s.data();
  s.size();
  s.push_back('a');
  s.pop_back();
  s.begin();
  s.end();
  s.cbegin();
  s.cend();
  //
  const std::string c;
  c.begin();
  c.end();
  //
  c.length();
  c.max_size();
  c.capacity();
  c.empty();
  //
  s.clear();
  s.reserve();
  s.shrink_to_fit();
  s.resize(1);
  s.resize(1, 'a');
  //
  c[0];
  c.at(0);
  c.back();
  c.front();
  s[0];
  s.at(0);
  s.back();
  s.front();
  //
  std::string copy(s);
  //
  copy += s;
  copy += "a";
  copy += 'a';
  //
  s.append(std::string());
  s.append(std::string(), 0, 0);
  s.append("");
  s.append("", 0);
  s.append(0, 'a');
  //
  s.assign(std::string());
  s.assign(std::string(), 0, 0);
  s.assign("");
  s.assign("", 0);
  s.assign(0, 'a');
  //
  s.insert(0, std::string());
  s.insert(0, std::string(), 0, 0);
  s.insert(0, "");
  s.insert(0, "", 0);
  s.insert(0, 0, 'a');
  //
  s.erase(0, 0);
  //
  copy = s;
  //
  char buffer[1];
  s.copy(buffer, 0);
  //
  s.find(std::string());
  s.find("");
  s.find("", 0, 0);
  s.find('_');
  
  s.rfind(std::string());
  s.rfind("");
  s.rfind("", 0, 0);
  s.rfind('_');
  
  s.find_first_of(std::string());
  s.find_first_of("");
  s.find_first_of("", 0, 0);
  s.find_first_of('_');
  
  s.find_last_of(std::string());
  s.find_last_of("");
  s.find_last_of("", 0, 0);
  s.find_last_of('_');
  
  s.find_first_not_of(std::string());
  s.find_first_not_of("");
  s.find_first_not_of("", 0, 0);
  s.find_first_not_of('_');
  
  s.find_last_not_of(std::string());
  s.find_last_not_of("");
  s.find_last_not_of("", 0, 0);
  s.find_last_not_of('_');
  
  s.substr();
  
  s.compare(std::string());
  s.compare(0, 0, std::string());
  s.compare(0, 0, std::string(), 0, 0);
  s.compare("");
  s.compare(0, 0, "");
  s.compare(0, 0, "", 0);
}


void instantiateVector() {
  { std::vector<int> _(1); }
  { std::vector<int> _(1,1); }
  std::vector<int> s;
  s.data();
  s.size();
  s.push_back('a');
  s.pop_back();
  s.begin();
  s.end();
  s.cbegin();
  s.cend();
  //
  const std::vector<int> c;
  c.begin();
  c.end();
  //
  c.max_size();
  c.capacity();
  c.empty();
  //
  s.clear();
  s.reserve(10);
  s.shrink_to_fit();
  s.resize(1);
  s.resize(1, 'a');
  //
  c[0];
  c.at(0);
  c.back();
  c.front();
  s[0];
  s.at(0);
  s.back();
  s.front();
  //
  std::vector<int> copy(s);
  //
  s.assign(0, 10);
  //
  s.insert(s.end(), 0);
  s.insert(s.end(), 0, 0);
  //
  s.erase(s.end());
  s.erase(s.end(), s.end());
  //
  copy = s;
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