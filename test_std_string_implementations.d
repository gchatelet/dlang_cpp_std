///////////////////////////////////////////////////////////////////////////////
// Import implementations
///////////////////////////////////////////////////////////////////////////////

import std_string_class;
import std_string_struct;

extern(C++) {
  // Returns a statically allocated string by ptr.
  std_string* getStringPtr();
  // Returns a dynamicaly allocated string by ptr.
  std_string* getStringPtr(const(char*) ptr,size_t size);
  // Returns a statically allocated string by reference.
  ref std_string getStringRef();
  // Returns a statically allocated string by copy.
  std_string getStringCopy(); // Can't work with class implementation.
  // Returns the size of the string
  pragma(mangle, "_Z13getStringSizeRKSs") size_t getStringSize(ref const std_string str);
}

///////////////////////////////////////////////////////////////////////////////
// Most of the tests below will allocate a string on the C++ side via the
// make function below.
// Since we don't deallocate, this program leaks memory.
///////////////////////////////////////////////////////////////////////////////

version(use_structs) {
ref std_string make(string str) {
  return *getStringPtr(str.ptr, str.length);
}
}

version(use_classes) {
std_string make(string str) {
  return cast(std_string)(getStringPtr(str.ptr, str.length));
}
}

import std.stdio;

void test_string_iterator() {
  auto s = make("ab");
  assert(s.begin[0] == 'a');
  assert(s.end[-1] == 'b');
  assert(s.end[0] == '\0');

  assert(s.cbegin[0] == 'a');
  assert(s.cend[-1] == 'b');
  assert(s.cend[0] == '\0');
}

void test_string_const_iterator() {
  const s = make("ab");
  assert(s.begin[0] == 'a');
  assert(s.end[-1] == 'b');
  assert(s.end[0] == '\0');

  assert(s.cbegin[0] == 'a');
  assert(s.cend[-1] == 'b');
  assert(s.cend[0] == '\0');
}

void test_string_capacity() {
  const c = make("ab");
  assert(c.size == 2);
  assert(c.length == 2);
  assert(c.max_size > 0);
  assert(c.capacity >= 2);
  assert(!c.empty());
  //
  auto s = make("ab");
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

void test_string_element_access() {
  const c = make("ab");
  assert(c[0] == 'a');
  assert(c.at(1) == 'b');
  assert(c.back() == 'b');
  assert(c.front() == 'a');
  auto s = make("ab");
  assert(c[0] == 'a');
  assert(s.at(1) == 'b');
  assert(s.back() == 'b');
  assert(s.front() == 'a');
  s[0] = 'c';
  assert(s[0] == 'c');
}

void test_string_append() {
  const constant = make("abc");
  auto s = make("");

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

void test_string_assign() {
  const constant = make("abc");
  auto s = make("");

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

void test_string_insert() {
  const abc = make("abc");
  const def = make("def");
  auto s = make("abc");

  s.insert(1, def);
  assert(s.asArray == "adefbc");

  s.assign(abc);
  s.insert(1, def, 1, 1);
  assert(s.asArray == "aebc");

  s.assign(abc);
  s.insert(1, "def");
  assert(s.asArray == "adefbc");

  s.assign(abc);
  s.insert(1, "def", 2);
  assert(s.asArray == "adebc");

  s.assign(abc);
  s.insert(1, 2, 'f');
  assert(s.asArray == "affbc");
}

void test_string_erase() {
  auto s = make("abc");

  s.erase(1, 1);
  assert(s.asArray == "ac");
}

void test_string_push_back() {
  auto s = make("");
  assert(s.size() == 0);

  s.push_back('_');
  assert(s.size() == 1);

  s.pop_back();
  assert(s.size() == 0);

//   s += '_';
//   assert(s.size() == 1);
//   assert(s.asArray == "_");
}


void test_string_copy() {
  const s = make("hello");
  char[2] buffer;
  s.copy(buffer.ptr, 2);
  assert(buffer == "he");
  s.copy(buffer.ptr, 2, 1);
  assert(buffer == "el");
  s.copy(buffer.ptr, 2, 0);
  assert(buffer == "he");
}

void test_string_find() {
  const s = make("hello");
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

///////////////////////////////////////////////////////////////////////////////
// Test below works with classes by hacking the type system.
///////////////////////////////////////////////////////////////////////////////

void test_string_pass_by_const_ref() {
  const s = make("hello");
version(use_structs) {
  assert(getStringSize(s) == 5);
}
version(use_classes) {
  assert(getStringSize(*s.c_ptr) == 5);
  assert(getStringSize(s.c_ref) == 5);
}
}

///////////////////////////////////////////////////////////////////////////////
// Tests below currently don't work with classes because of layout issues.
///////////////////////////////////////////////////////////////////////////////

// substr return by value, this code cannot work out of the box with class implementation.
void test_string_substr() {
version(use_structs) {
  const s = make("hello");
  assert(s.substr().asArray == s.asArray);
  assert(s.substr(1, 2).asArray == "el");
}
}

void test_string_copy_ctor() {
version(use_structs) {
  auto string_from_d = std_string("string_from_d\0overun");
  assert(string_from_d.asArray == "string_from_d");

  auto string_copy_from_d = std_string(string_from_d);
  assert(string_copy_from_d.asArray == string_from_d.asArray);

  string_copy_from_d.push_back('_');
  assert(string_copy_from_d.asArray != string_from_d.asArray);
  assert(string_copy_from_d.data !is string_from_d.data);
}
}

import std.stdio;

void main() {

  test_string_copy_ctor();
  test_string_iterator();
  test_string_const_iterator();
  test_string_capacity();
  test_string_element_access();
  test_string_append();
  test_string_assign();
  test_string_insert();
  test_string_erase();
  test_string_push_back();
  test_string_copy();
  test_string_find();
  test_string_substr();
  test_string_pass_by_const_ref();

  version(use_structs) {
    writeln(getStringPtr().asArray());
    writeln(getStringRef().asArray());
    // substr return by value, this code cannot work out of the box with class implementation.
    writeln(getStringCopy().asArray());
  }
}