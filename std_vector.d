import std_allocator;

///////////////////////////////////////////////////////////////////////////////
// std::vector declaration.
//
// Current caveats :
// - manual name mangling (=> only vector!int is functionnal)
//   See https://issues.dlang.org/show_bug.cgi?id=14086.
// - won't work with custom allocators.
// - missing noexcept 
// - iterators are implemented as pointers
// - no reverse_iterator nor rbegin/rend
///////////////////////////////////////////////////////////////////////////////

extern(C++, std) {

  class vector(T, ALLOC = allocator!T) {
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

    // Ctor/dtor
    pragma(mangle, "_ZNSt6vectorIiSaIiEEC1Ev") @disable this();
    pragma(mangle, "_ZNSt6vectorIiSaIiEEC2EmRKS0_") this(size_type n, ref const allocator_type _ = defaultAlloc);
    pragma(mangle, "_ZNSt6vectorIiSaIiEEC2EmRKiRKS0_") this(size_type n, ref const value_type val, ref const allocator_type _ = defaultAlloc);
    pragma(mangle, "_ZNSt6vectorIiSaIiEEC2ERKS1_") this(ref const vector x);

    pragma(mangle, "_ZNSt6vectorIiSaIiEED1Ev") ~this();

    pragma(mangle, "_ZNSt6vectorIiSaIiEEaSERKS1_") ref vector opAssign(ref const vector s);

    // Iterator
    pragma(mangle, "_ZNSt6vectorIiSaIiEE5beginEv") iterator begin();
    pragma(mangle, "_ZNKSt6vectorIiSaIiEE5beginEv") const_iterator begin() const;
    pragma(mangle, "_ZNKSt6vectorIiSaIiEE6cbeginEv") const_iterator cbegin() const;

    pragma(mangle, "_ZNSt6vectorIiSaIiEE3endEv") iterator end();
    pragma(mangle, "_ZNKSt6vectorIiSaIiEE3endEv") const_iterator end() const;
    pragma(mangle, "_ZNKSt6vectorIiSaIiEE4cendEv") const_iterator cend() const;

    // no reverse iterator for now.

    // Capacity
    pragma(mangle, "_ZNKSt6vectorIiSaIiEE4sizeEv") size_t size() const;
    pragma(mangle, "_ZNKSt6vectorIiSaIiEE8max_sizeEv") size_t max_size() const;
    pragma(mangle, "_ZNKSt6vectorIiSaIiEE8capacityEv") size_t capacity() const;
    pragma(mangle, "_ZNKSt6vectorIiSaIiEE5emptyEv") bool empty() const;

    pragma(mangle, "_ZNSt6vectorIiSaIiEE5clearEv") void clear();
    pragma(mangle, "_ZNSt6vectorIiSaIiEE6resizeEm") void resize(size_t n);
    pragma(mangle, "_ZNSt6vectorIiSaIiEE6resizeEmRKi") void resize(size_t n, T c);
    pragma(mangle, "_ZNSt6vectorIiSaIiEE7reserveEm") void reserve(size_t n = 0);
    pragma(mangle, "_ZNSt6vectorIiSaIiEE13shrink_to_fitEv") void shrink_to_fit();

    // Element access
    pragma(mangle, "_ZNSt6vectorIiSaIiEEixEm") ref T opIndex(size_t i);
    pragma(mangle, "_ZNKSt6vectorIiSaIiEEixEm") ref const(T) opIndex(size_t i) const;

    pragma(mangle, "_ZNSt6vectorIiSaIiEE2atEm") ref T at(size_t i);
    pragma(mangle, "_ZNKSt6vectorIiSaIiEE2atEm") ref const(T) at(size_t i) const;

    pragma(mangle, "_ZNSt6vectorIiSaIiEE4backEv") ref T back();
    pragma(mangle, "_ZNKSt6vectorIiSaIiEE4backEv") ref const(T) back() const;

    pragma(mangle, "_ZNSt6vectorIiSaIiEE5frontEv") ref T front();
    pragma(mangle, "_ZNKSt6vectorIiSaIiEE5frontEv") ref const(T) front() const;

    // Modifier

    pragma(mangle, "_ZNSt6vectorIiSaIiEE9push_backEOi") void push_back(ref const T _);
    void push_back(const T _) { push_back(_);} // forwards to ref version
    pragma(mangle, "_ZNSt6vectorIiSaIiEE8pop_backEv") void pop_back();


    private:
      void[24] _ = void; // to match sizeof(std::vector) and pad the object correctly.
      __gshared static immutable allocator!T defaultAlloc;
  }

}

///////////////////////////////////////////////////////////////////////////////
// Tests
///////////////////////////////////////////////////////////////////////////////

unittest {
  auto s = new vector!int(0);

  assert(s.begin == s.end);
  assert(s.cbegin == s.cend);
}

unittest {
  const s = new vector!int(0);

  assert(s.begin == s.end);
  assert(s.cbegin == s.cend);
}

unittest {
  auto s = new vector!int(0);

  assert(s.empty);
  s.push_back(10);
  assert(!s.empty);
  assert(s.begin[0] == 10);
  assert(s[0] == 10);
  assert(s.at(0) == 10);

  s[0] = 1;
  assert(s[0] == 1);

  s.at(0) = 2;
  assert(s[0] == 2);

  assert(s.front == 2);
  assert(s.back == 2);

  s.pop_back();
  assert(s.empty);
  assert(s.cbegin == s.cend);
}


unittest {
  auto s = new vector!int(0);

  s.resize(5);
  assert(s.capacity >= 5);
  assert(s.size == 5);
  assert(!s.empty);
  assert(s.begin[0] == 0);
}