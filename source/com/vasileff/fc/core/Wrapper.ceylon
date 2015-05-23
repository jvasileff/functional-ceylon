shared
interface Wrapper<Box, out A, out Self, out TypeClass>
        given Box<out E>
        given Self<SC, SE>
            given SC<out SCE>
        given TypeClass<TC>
            given TC<out TCE> {

    shared formal
    Box<A> unwrapped;

    shared formal
    TypeClass<Box> typeClass;

    shared formal
    Self<Box, B> wrap<B>(Box<B> unwrapped);
}

// TODO should type classes encode their wrapper type?
// Something like:
//      interface Wrapping<Wrapper> given Wrapper<B, E> {
//          Wrapper<Box, A> wrap<A>(Box<A> unwrapped) => ...
//      }
//
//      interface Functor<Box>
//          satisfies Wrapping<FunctorWrapper>`? { ... }
//
// The idea being to try to remove the `wrap` method
// from `Wrapper`
