
///////////////////////////////////////////////////////////////////////////////
// Check that ctor/dtor are called as expected.
///////////////////////////////////////////////////////////////////////////////
extern (C++, ctor_test) {
    struct Counter {
        int ctor = 0;
        int ctor_copy = 0;
        int dtor = 0;
    }
    
    struct RAII(T) {
      pragma(mangle, "_ZN9ctor_test4RAIIIiEC1EPNS_7CounterE") this(Counter* ptr);
      pragma(mangle, "_ZN9ctor_test4RAIIIiEC1ERKS1_") this(ref const this);
      pragma(mangle, "_ZN9ctor_test4RAIIIiED1Ev") ~this();
     private:
        Counter* counter_;
    };
}

unittest {
    Counter counter = Counter();
    {
        assert(counter.ctor == 0);
        auto raii = RAII!int(&counter);
        assert(counter.ctor == 1);
        auto raii_copy = RAII!int(raii);
        assert(counter.ctor_copy == 1);
        assert(counter.dtor == 0);
    }
    assert(counter.dtor == 2);
}
