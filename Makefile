
all: cpp_std


instantiated.o: instantiated.cpp
	g++ -std=c++11 -g -O0 $< -c -o $@

cpp_std: instantiated.o cpp_std.d
	~/dlang/dmd/src/dmd -g -of$@ $^
.PHONY: cpp_std