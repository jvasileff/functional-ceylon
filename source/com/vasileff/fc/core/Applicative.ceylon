shared
interface Applicative<Box>
        satisfies Functor<Box>
        given Box<out E> {

    shared formal
    Box<A> unit<A>(A element);

    shared formal
    Box<B> apply<A, B>(
            Box<A> container,
            Box<B(A)> f);

    // TODO consider reverting to using an anonymous class
    // after https://github.com/ceylon/ceylon-spec/issues/1310
    shared actual default
    ApplicativeWrapper<Box, A> wrap<A>
            (Box<A> unwrapped)
        =>  ApplicativeWrapperImpl<Box, A>
                (this, unwrapped);
}

shared
interface ApplicativeOpsMixin<Box, out A, out Self>
        satisfies Wrapper<Box, A, Self, Applicative>
            & FunctorOpsMixin<Box, A, Self>
        given Box<out E>
        given Self<C, El> given C<out E2> {

    shared default
    Self<Box, B> apply<B>(Box<B(A)> f)
        =>  wrap<B>(typeClass.apply(unwrapped, f));
}

shared
interface ApplicativeWrapper<Box, out A>
        satisfies FunctorWrapper<Box, A>
            & ApplicativeOpsMixin<Box, A, ApplicativeWrapper>
        given Box<out E> {}

class ApplicativeWrapperImpl<Box, A>(
        shared actual Applicative<Box> typeClass,
        shared actual Box<A> unwrapped)
        satisfies ApplicativeWrapper<Box, A>
        given Box<out E> {

    shared actual
    ApplicativeWrapper<Box, E> wrap<E>(Box<E> wrapped)
        =>  ApplicativeWrapperImpl<Box, E>(typeClass, wrapped);
}
