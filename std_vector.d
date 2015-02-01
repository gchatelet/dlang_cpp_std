pragma(lib, "/lib/libstdc++.a"); // get all symbols with "nm -Cgnu -g -A /lib/libstdc++.a"

import std_allocator;

///////////////////////////////////////////////////////////////////////////////
// std::vector declaration.
//
// Current caveats :
// - manual name mangling (=> only string is functionnal, wstring won't work)
//   See https://issues.dlang.org/show_bug.cgi?id=14086.
// - won't work with custom allocators.
// - missing noexcept 
// - iterators are implemented as pointers
// - no reverse_iterator nor rbegin/rend
///////////////////////////////////////////////////////////////////////////////

extern(C++, std) {
  
  struct vector(T, ALLOC = allocator!T) {
    alias value_type = T;
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
  
    this(ref const allocator_type _ = defaultAlloc);
    this(size_type n);
    this(size_type n, ref const value_type val, ref const allocator_type _ = defaultAlloc);
    this(ref const vector x);
    this(ref const vector x, ref const allocator_type _ = defaultAlloc);
    
    ~this();
    
    private:
      void[24] _ = void; // to match sizeof(std::vector) and pad the object correctly.
      __gshared static immutable allocator!T defaultAlloc;
  }

}

///////////////////////////////////////////////////////////////////////////////
// Tests
///////////////////////////////////////////////////////////////////////////////

