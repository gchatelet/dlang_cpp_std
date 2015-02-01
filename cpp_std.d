 
import std_string;
import raii;

extern(C++) {
  std_string* getStringPtr();
  ref std_string getStringRef();
  std_string getStringCopy();
}

void main() {
  import std.stdio;
  writeln(getStringPtr().asArray());
  writeln(getStringRef().asArray());
  writeln(getStringCopy().asArray());
}