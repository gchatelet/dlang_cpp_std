# Summary of my findings

## Struct VS class

Since we're unsure whether they should be implemented as structs or classes I implemented `std::string` as both a [D struct](std_string_struct.d) and a [D class](std_string_class.d).
Summarizing the differences in the table below.

|                                |struct        | class         |
|--------------------------------|--------------|---------------|
|D and C++ have value semantics  | yes          | no            |
|D type mangles as C++           | no           | yes           |
|Stack constructible on D side   | yes          | no            |

### Known issues

Since class implementation uses reference semantic, some functions can't be called :

    // would assign pointers
    basic_string opAssign(const basic_string s);

    // C++ would return a value but D interpret it as pointer
    basic_string substr(size_t pos = 0, size_t len = npos) const;

## Ctors/Dtor are not typed alike between C++ and D

See [bug 14086](https://issues.dlang.org/show_bug.cgi?id=14086).
+ D uses `type::ctor()`, `type::dtor()`
+ C++ uses `type::type()`, `type::~type()`

This leads to incorrect mangling of `extern(C++)` constructors and destructors and undefined reference when linking.

## Name mangling

###Linux
+ Incorrect name mangling for const standard abbreviations - [bug 14178](https://issues.dlang.org/show_bug.cgi?id=14178)

###Windows

+ In case we decide to go for structs, name mangling will be incorrect on Windows platforms which [encodes structs and classes differently](http://en.wikipedia.org/wiki/Visual_C%2B%2B_name_mangling#Data_Type).

## Exceptions handling

+ No plan yet.

## Conflicting std namespaces

Declaring `extern(C++, std)` conflicts with everything in module `std` :

    extern(C++, std) {
      struct S;
    }

    import std.stdio;
    void foo() {
      writeln();
    };

Returns `main.d(5): Error: import main.std conflicts with namespace main.std at main.d(1)`.

As a workaround, modules declaring STL interfaces should not import phobos.