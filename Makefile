
all: cpp_std


instantiated.o: instantiated.cpp
	g++ -g -O0 $< -c -o $@

cpp_std: instantiated.o cpp_std.d
	~/dlang/dmd/src/dmd -of$@ $^