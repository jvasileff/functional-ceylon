shared suppressWarnings("unusedDeclaration")
interface Wrapper<Box, out A, out Self, out TypeClass>
        given Box<out E>
        given Self<SB, SE> given SB<out SBE>
        given TypeClass<TB> given TB<out TBE> {

    shared formal
    Box<A> unwrapped;

    shared formal
    TypeClass<Box> typeClass;
}

shared
interface Wrapping<out WrapperType, Box>
        given WrapperType<WB, WE> given WB<out WBE>
        given Box<out BE> {

    shared formal
    WrapperType<Box, A> wrap<A>(Box<A> unwrapped);
}
