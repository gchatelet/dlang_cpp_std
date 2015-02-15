
all: cpp_std_struct cpp_std_class
	@echo "Running tests..."
	@if (./cpp_std_struct && ./cpp_std_class) ; then echo "Success !" ; else echo "Failure..." ; fi

instantiated.o: instantiated.cpp
	g++ -std=c++11 -g -O0 $< -c -o $@

cpp_std_struct: instantiated.o test_std_string_implementations.d raii.d std_string_struct.d std_allocator.d std_vector.d
	~/dlang/dmd/src/dmd -version=use_structs -g -of$@ $^ -L/lib/libstdc++.a
.PHONY: cpp_std_struct

cpp_std_class: instantiated.o test_std_string_implementations.d raii.d std_string_class.d std_allocator.d std_vector.d
	~/dlang/dmd/src/dmd -version=use_classes -g -of$@ $^ -L/lib/libstdc++.a
.PHONY: cpp_std_class

clean:
	rm -f *.o cpp_std_struct cpp_std_class