 
pragma(lib, "/lib/libstdc++.a"); // get all symbols with "nm -Cgnu -g -A /lib/libstdc++.a"

extern (C++, __gnu_cxx) {

  struct new_allocator(T) {
    alias size_type = size_t;
    void deallocator(T*, size_type);
  }

}

extern(C++, std) {

  struct allocator(T) {
    alias size_type = size_t;
  }

  struct char_traits(CharT) {
  }
  
  struct basic_string(T, TRAITS = char_traits!T, ALLOC = allocator!T) {
    alias size_type = size_t;
    enum size_t npos = size_t.max;
    
    // undefined reference to std::basic_string<char, std::char_traits<char>, std::allocator<char> >::__ctor()
    // should be              std::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string()
    pragma(mangle, "_ZNSsC1Ev") @disable this();
    pragma(mangle, "_ZNSsC1ERKSs") this(ref const this);
    pragma(mangle, "_ZNSsD1Ev") ~this();
    
    // std::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string(char const*, std::allocator<char> const&)
    pragma(mangle, "_ZNSsC1EPKcRKSaIcE") this(const(T*) /* , ref const(allocator!T) _*/);
    
    pragma(mangle, "_ZNKSs5c_strEv") const(T*) c_str() const;
    
    // Capacity
    pragma(mangle, "_ZNKSs4sizeEv") size_t size() const;
    
    // Modifier

// opUnary string is probably conflicting with std.string
//     pragma(mangle, "_ZNSspLERKSs") ref(string) opUnary(string s)(ref const string _) if (s == "+=");
//     pragma(mangle, "_ZNSspLEPKc") ref(string) opUnary(string s)(const(T*) _) if (s == "+=");
//     pragma(mangle, "_ZNSspLEc") ref(string) opUnary(string s)(T _) if (s == "+=");
    
    pragma(mangle, "_ZNSs9push_backEc") void push_back(char _);
    pragma(mangle, "_ZNSs8pop_backEv") void pop_back();
    
    const(T[]) asArray() const { return c_str()[0 .. size()]; }
    
    private void[8] _ = void; // to match sizeof(std::string) and pad the object correctly.
  }
  
  alias basic_string!char string;
  alias basic_string!wchar wstring;

}

extern(C++) {
  std.string* getStringPtr();
  ref std.string getStringRef();
  std.string getStringCopy();
}

void main() {
  auto string_from_d = std.string("string_from_d\0overun");
  assert(string_from_d.asArray == "string_from_d");
  
  auto string_copy_from_d = std.string(string_from_d);
  assert(string_copy_from_d.asArray == "string_from_d");
  
  string_copy_from_d.push_back('_');
  assert(string_copy_from_d.asArray == "string_from_d_");
  
  string_copy_from_d.pop_back();
  assert(string_copy_from_d.asArray == "string_from_d");
  
  string_copy_from_d += '_';
  assert(string_copy_from_d.asArray == "string_from_d_");
  
  import std.stdio;
  writeln(string_from_d.asArray());
  writeln(string_copy_from_d.asArray());
  writeln(getStringPtr().asArray());
  writeln(getStringRef().asArray());
//   writeln(getStringCopy().asArray());
//   auto string_copy = getStringCopy();
//   writeln(string_copy);
}