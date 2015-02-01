
all: cpp_std


instantiated.o: instantiated.cpp
	g++ -std=c++11 -g -O0 $< -c -o $@

cpp_std: instantiated.o cpp_std.d raii.d std_string.d
	~/dlang/dmd/src/dmd -unittest -g -of$@ $^
.PHONY: cpp_std

clean:
	rm *.o cpp_std