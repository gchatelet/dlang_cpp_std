 
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
  
  class basic_string(T, TRAITS = char_traits!T, ALLOC = allocator!T) {
    alias size_type = size_t;
    enum size_t npos = size_t.max;
    
    this();
    this(const(T*) _, const ref allocator!T _);
    
    private void[8] _; // to match sizeof(std::string) and pad the object correctly.
  }
  
  alias basic_string!char string;
  alias basic_string!wchar wstring;

}

void main() {
  auto s = new std.string();
  // undefined reference to std::basic_string<char, std::char_traits<char>, std::allocator<char> >::__ctor()
  // should be              std::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string()
}