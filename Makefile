
all: cpp_std


instantiated.o: instantiated.cpp
	g++ -std=c++11 -g -O0 $< -c -o $@

cpp_std: instantiated.o cpp_std.d raii.d std_string.d std_allocator.d std_vector.d
	~/dlang/dmd/src/dmd -unittest -g -of$@ $^ -L/usr/lib/x86_64-linux-gnu/libstdc++.so.6
.PHONY: cpp_std

clean:
	rm *.o cpp_std