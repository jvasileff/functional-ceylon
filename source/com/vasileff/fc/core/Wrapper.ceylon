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
