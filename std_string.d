
pragma(lib, "/lib/libstdc++.a"); // get all symbols with "nm -Cgnu -g -A /lib/libstdc++.a"

import std_allocator;

///////////////////////////////////////////////////////////////////////////////
// std::string declaration.
//
// Current caveats :
// - manual name mangling (=> only string is functionnal, wstring won't work)
//   See https://issues.dlang.org/show_bug.cgi?id=14086.
// - won't work with custom allocators.
// - missing noexcept 
// - iterators are implemented as pointers
// - no reverse_iterator nor rbegin/rend
// - missing functions : replace, swap
///////////////////////////////////////////////////////////////////////////////

extern(C++, std) {

  struct char_traits(CharT) { }

  struct basic_string(T, TRAITS = char_traits!T, ALLOC = allocator!T) {

    enum size_t npos = size_t.max;

    alias value_type = T;
    alias traits_type = TRAITS;
    alias allocator_type = ALLOC;
    alias reference = ref T;
    alias const_reference = ref const(T);
    alias pointer = T*;
    alias const_pointer = const(T*);
    alias iterator = pointer;
    alias const_iterator = const_pointer;
    // alias reverse_iterator
    // alias const_reverse_iterator
    alias difference_type = ptrdiff_t;
    alias size_type = size_t;

    // Ctor/dtor
    pragma(mangle, "_ZNSsC1Ev") @disable this();
    pragma(mangle, "_ZNSsC1ERKSs") this(ref const this);
    pragma(mangle, "_ZNSsC1EPKcRKSaIcE") this(const(T*) _, ref const allocator_type _ = defaultAlloc);

    pragma(mangle, "_ZNSsD1Ev") ~this();

    pragma(mangle, "_ZNSsaSERKSs") ref basic_string opAssign(ref const basic_string s);

    // Iterator
    pragma(mangle, "_ZNSs5beginEv") iterator begin();
    pragma(mangle, "_ZNKSs5beginEv") const_iterator begin() const;
    pragma(mangle, "_ZNKSs6cbeginEv") const_iterator cbegin() const;

    pragma(mangle, "_ZNSs3endEv") iterator end();
    pragma(mangle, "_ZNKSs3endEv") const_iterator end() const;
    pragma(mangle, "_ZNKSs4cendEv") const_iterator cend() const;

    // no reverse iterator for now.

    // Capacity
    pragma(mangle, "_ZNKSs4sizeEv") size_t size() const;
    pragma(mangle, "_ZNKSs6lengthEv") size_t length() const;
    pragma(mangle, "_ZNKSs8max_sizeEv") size_t max_size() const;
    pragma(mangle, "_ZNKSs8capacityEv") size_t capacity() const;
    pragma(mangle, "_ZNKSs5emptyEv") bool empty() const;

    pragma(mangle, "_ZNSs5clearEv") void clear();
    pragma(mangle, "_ZNSs6resizeEm") void resize(size_t n);
    pragma(mangle, "_ZNSs6resizeEmc") void resize(size_t n, T c);
    pragma(mangle, "_ZNSs7reserveEm") void reserve(size_t n = 0);
    pragma(mangle, "_ZNSs13shrink_to_fitEv") void shrink_to_fit();

    // Element access
    pragma(mangle, "_ZNSsixEm") ref T opIndex(size_t i);
    pragma(mangle, "_ZNKSsixEm") ref const(T) opIndex(size_t i) const;

    pragma(mangle, "_ZNSs2atEm") ref T at(size_t i);
    pragma(mangle, "_ZNKSs2atEm") ref const(T) at(size_t i) const;

    pragma(mangle, "_ZNSs4backEv") ref T back();
    pragma(mangle, "_ZNKSs4backEv") ref const(T) back() const;

    pragma(mangle, "_ZNSs5frontEv") ref T front();
    pragma(mangle, "_ZNKSs5frontEv") ref const(T) front() const;

    // Modifier
    pragma(mangle, "_ZNSspLERKSs") ref basic_string opOpAssign(string op)(ref const basic_string _) if (op == "+");
    pragma(mangle, "_ZNSspLEPKc") ref basic_string opOpAssign(string op)(const(T*) _) if (op == "+");
    pragma(mangle, "_ZNSspLEc") ref basic_string opOpAssign(string op)(T _) if (op == "+");

    pragma(mangle, "_ZNSs6appendEmc") ref basic_string append(size_t n, char c);
    pragma(mangle, "_ZNSs6appendEPKc") ref basic_string append(const char* s);
    pragma(mangle, "_ZNSs6appendEPKcm") ref basic_string append(const char* s, size_t n);
    pragma(mangle, "_ZNSs6appendERKSs") ref basic_string append(ref const basic_string str);
    pragma(mangle, "_ZNSs6appendERKSsmm") ref basic_string append(ref const basic_string str, size_t subpos, size_t sublen);

    pragma(mangle, "_ZNSs9push_backEc") void push_back(T _);

    pragma(mangle, "_ZNSs6assignEmc") ref basic_string assign(size_t n, char c);
    pragma(mangle, "_ZNSs6assignEPKc") ref basic_string assign(const char* s);
    pragma(mangle, "_ZNSs6assignEPKcm") ref basic_string assign(const char* s, size_t n);
    pragma(mangle, "_ZNSs6assignERKSs") ref basic_string assign(ref const basic_string str);
    pragma(mangle, "_ZNSs6assignERKSsmm") ref basic_string assign(ref const basic_string str, size_t subpos, size_t sublen);

    pragma(mangle, "_ZNSs6insertEmRKSs") ref basic_string insert (size_t pos, ref const basic_string str);
    pragma(mangle, "_ZNSs6insertEmRKSsmm") ref basic_string insert (size_t pos, ref const basic_string str, size_t subpos, size_t sublen);
    pragma(mangle, "_ZNSs6insertEmPKc") ref basic_string insert (size_t pos, const char* s);
    pragma(mangle, "_ZNSs6insertEmPKcm") ref basic_string insert (size_t pos, const char* s, size_t n);
    pragma(mangle, "_ZNSs6insertEmmc") ref basic_string insert (size_t pos, size_t n, char c);

    pragma(mangle, "_ZNSs5eraseEmm") ref basic_string erase(size_t pos = 0, size_t len = npos);

    // replace
    // swap
    pragma(mangle, "_ZNSs8pop_backEv") void pop_back();

    // String operations
    pragma(mangle, "_ZNKSs5c_strEv") const(T*) c_str() const;

    pragma(mangle, "_ZNKSs4dataEv") const(T*) data() const;

    pragma(mangle, "_ZNKSs4copyEPcmm") size_t copy(T* s, size_t len, size_t pos = 0) const;

    pragma(mangle, "_ZNKSs4findERKSsm") size_t find(ref const basic_string str, size_t pos = 0) const;
    pragma(mangle, "_ZNKSs4findEPKcm") size_t find(const(T*) s, size_t pos = 0) const;
    pragma(mangle, "_ZNKSs4findEPKcmm") size_t find(const(T*) s, size_t pos, size_type n) const;
    pragma(mangle, "_ZNKSs4findEcm") size_t find(T c, size_t pos = 0) const;

    pragma(mangle, "_ZNKSs5rfindERKSsm") size_t rfind(ref const basic_string str, size_t pos = npos) const;
    pragma(mangle, "_ZNKSs5rfindEPKcm") size_t rfind(const(T*) s, size_t pos = npos) const;
    pragma(mangle, "_ZNKSs5rfindEPKcmm") size_t rfind(const(T*) s, size_t pos, size_t n) const;
    pragma(mangle, "_ZNKSs5rfindEcm") size_t rfind(T c, size_t pos = npos) const;

    pragma(mangle, "_ZNKSs13find_first_ofERKSsm") size_t find_first_of(ref const basic_string str, size_t pos = 0) const;
    pragma(mangle, "_ZNKSs13find_first_ofEPKcm") size_t find_first_of(const(T*) s, size_t pos = 0) const;
    pragma(mangle, "_ZNKSs13find_first_ofEPKcmm") size_t find_first_of(const(T*) s, size_t pos, size_t n) const;
    pragma(mangle, "_ZNKSs13find_first_ofEcm") size_t find_first_of(T c, size_t pos = 0) const;

    pragma(mangle, "_ZNKSs12find_last_ofERKSsm") size_t find_last_of(ref const basic_string str, size_t pos = npos) const;
    pragma(mangle, "_ZNKSs12find_last_ofEPKcm") size_t find_last_of(const(T*) s, size_t pos = npos) const;
    pragma(mangle, "_ZNKSs12find_last_ofEPKcmm") size_t find_last_of(const(T*) s, size_t pos, size_t n) const;
    pragma(mangle, "_ZNKSs12find_last_ofEcm") size_t find_last_of(T c, size_t pos = npos) const;

    pragma(mangle, "_ZNKSs17find_first_not_ofERKSsm") size_t find_first_not_of(ref const basic_string str, size_t pos = 0) const;
    pragma(mangle, "_ZNKSs17find_first_not_ofEPKcm") size_t find_first_not_of(const(T*) s, size_t pos = 0) const;
    pragma(mangle, "_ZNKSs17find_first_not_ofEPKcmm") size_t find_first_not_of(const(T*) s, size_t pos, size_t n) const;
    pragma(mangle, "_ZNKSs17find_first_not_ofEcm") size_t find_first_not_of(T c, size_t pos = 0) const;

    pragma(mangle, "_ZNKSs16find_last_not_ofERKSsm") size_t find_last_not_of(ref const basic_string str, size_t pos = npos) const;
    pragma(mangle, "_ZNKSs16find_last_not_ofEPKcm") size_t find_last_not_of(const(T*) s, size_t pos = npos) const;
    pragma(mangle, "_ZNKSs16find_last_not_ofEPKcmm") size_t find_last_not_of(const(T*) s, size_t pos, size_t n) const;
    pragma(mangle, "_ZNKSs16find_last_not_ofEcm") size_t find_last_not_of(T c, size_t pos = npos) const;

    pragma(mangle, "_ZNKSs6substrEmm") basic_string substr(size_t pos = 0, size_t len = npos) const;

    pragma(mangle, "_ZNKSs7compareERKSs") int compare(ref const basic_string str) const;
    pragma(mangle, "_ZNKSs7compareEmmRKSs") int compare(size_t pos, size_t len, ref const basic_string str) const;
    pragma(mangle, "_ZNKSs7compareEmmRKSsmm") int compare(size_t pos, size_t len, ref const basic_string str, size_t subpos, size_t sublen) const;
    pragma(mangle, "_ZNKSs7compareEPKc") int compare(const(T*) s) const;
    pragma(mangle, "_ZNKSs7compareEmmPKc") int compare(size_t pos, size_t len, const(T*) s) const;
    pragma(mangle, "_ZNKSs7compareEmmPKcm") int compare(size_t pos, size_t len, const(T*) s, size_t n) const;

    // D helpers
    const(T[]) asArray() const { return c_str()[0 .. size()]; }

    private:
      void[8] _ = void; // to match sizeof(std::string) and pad the object correctly.
      __gshared static immutable allocator!T defaultAlloc;
  }

  alias basic_string!char std_string;
  static assert(std_string.sizeof == 8);

//   alias basic_string!wchar wstring;
//   static assert(wstring.sizeof == 8);
}

///////////////////////////////////////////////////////////////////////////////
// Tests
///////////////////////////////////////////////////////////////////////////////

unittest {
  auto string_from_d = std_string("string_from_d\0overun");
  assert(string_from_d.asArray == "string_from_d");

  auto string_copy_from_d = std_string(string_from_d);
  assert(string_copy_from_d.asArray == string_from_d.asArray);

  string_copy_from_d.push_back('_');
  assert(string_copy_from_d.asArray != string_from_d.asArray);
  assert(string_copy_from_d.data !is string_from_d.data);
}

unittest {
  auto s = std_string("ab");
  assert(s.begin[0] == 'a');
  assert(s.end[-1] == 'b');
  assert(s.end[0] == '\0');

  assert(s.cbegin[0] == 'a');
  assert(s.cend[-1] == 'b');
  assert(s.cend[0] == '\0');
}

unittest {
  const s = std_string("ab");
  assert(s.begin[0] == 'a');
  assert(s.end[-1] == 'b');
  assert(s.end[0] == '\0');

  assert(s.cbegin[0] == 'a');
  assert(s.cend[-1] == 'b');
  assert(s.cend[0] == '\0');
}

unittest { // Capacity
  const c = std_string("ab");
  assert(c.size == 2);
  assert(c.length == 2);
  assert(c.max_size > 0);
  assert(c.capacity >= 2);
  assert(!c.empty());
  //
  auto s = std_string("ab");
  s.clear();
  assert(s.empty());
  s.reserve(5);
  assert(s.capacity() >= 5);
  s.shrink_to_fit();
  assert(s.empty());
  s.resize(1);
  assert(s.size == 1);
  s.resize(2, 'a');
  assert(s.size == 2);
}

unittest { // Element access
  const c = std_string("ab");
  assert(c[0] == 'a');
  assert(c.at(1) == 'b');
  assert(c.back() == 'b');
  assert(c.front() == 'a');
  auto s = std_string("ab");
  assert(s[0] == 'a');
  assert(s.at(1) == 'b');
  assert(s.back() == 'b');
  assert(s.front() == 'a');
  s[0] = 'c';
  assert(s[0] == 'c');
}

unittest {
  std_string s = std_string("");
  assert(s.size() == 0);
}

unittest { // Modifiers append
  const constant = std_string("abc");
  auto s = std_string("");

  s.append(constant);
  assert(s.asArray == "abc");
  s.clear;

  s.append(constant, 1, 2);
  assert(s.asArray == "bc");
  s.clear;

  s.append("a");
  assert(s.asArray == "a");
  s.clear;

  s.append("ab", 1);
  assert(s.asArray == "a");
  s.clear;

  s.append(2, 'a');
  assert(s.asArray == "aa");
}

unittest { // Modifiers assign
  const constant = std_string("abc");
  auto s = std_string("");

  s.assign(constant);
  assert(s.asArray == "abc");

  s.assign(constant, 1, 2);
  assert(s.asArray == "bc");

  s.assign("a");
  assert(s.asArray == "a");

  s.assign("ab", 1);
  assert(s.asArray == "a");

  s.assign(2, 'a');
  assert(s.asArray == "aa");
}

unittest { // Modifiers insert
  const abc = std_string("abc");
  const def = std_string("def");
  auto s = std_string(abc);

  s.insert(1, def);
  assert(s.asArray == "adefbc");

  s = abc;
  s.insert(1, def, 1, 1);
  assert(s.asArray == "aebc");

  s = abc;
  s.insert(1, "def");
  assert(s.asArray == "adefbc");

  s = abc;
  s.insert(1, "def", 2);
  assert(s.asArray == "adebc");

  s = abc;
  s.insert(1, 2, 'f');
  assert(s.asArray == "affbc");
}

unittest { // Modifiers erase
  auto s = std_string("abc");

  s.erase(1, 1);
  assert(s.asArray == "ac");
}

unittest { // Modifiers push_back, pop_back
  std_string s = std_string("");
  assert(s.size() == 0);

  s.push_back('_');
  assert(s.size() == 1);

  s.pop_back();
  assert(s.size() == 0);

//   s += '_';
//   assert(s.size() == 1);
//   assert(s.asArray == "_");
}


unittest {
  const s = std_string("hello");
  char[2] buffer;
  s.copy(buffer.ptr, 2);
  assert(buffer == "he");
  s.copy(buffer.ptr, 2, 1);
  assert(buffer == "el");
  s.copy(buffer.ptr, 2, 0);
  assert(buffer == "he");
}

unittest {
  const s = std_string("hello");
  assert(s.find('e') == 1);
  assert(s.find("el") == 1);
  assert(s.find(s) == 0);
  assert(s.find('_') == std_string.npos);

  assert(s.rfind('e') == 1);
  assert(s.rfind("el") == 1);
  assert(s.rfind(s) == 0);
  assert(s.rfind('_') == std_string.npos);

  assert(s.find_first_of('e') == 1);
  assert(s.find_first_of("el") == 1);
  assert(s.find_first_of(s) == 0);
  assert(s.find_first_of('_') == std_string.npos);

  assert(s.find_last_of('e') == 1);
  assert(s.find_last_of("el") == 3);
  assert(s.find_last_of(s) == 4);
  assert(s.find_last_of('_') == std_string.npos);

  assert(s.find_first_not_of('e') == 0);
  assert(s.find_first_not_of("el") == 0);
  assert(s.find_first_not_of(s) == std_string.npos);
  assert(s.find_first_not_of('_') == 0);

  assert(s.find_last_not_of('e') == 4);
  assert(s.find_last_not_of("el") == 4);
  assert(s.find_last_not_of(s) == std_string.npos);
  assert(s.find_last_not_of('_') == 4);
}

unittest {
  const s = std_string("hello");
  assert(s.substr().asArray == s.asArray);
  assert(s.substr(1, 2).asArray == "el");
}
