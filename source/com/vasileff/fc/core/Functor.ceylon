shared
interface Functor<Box>
        given Box<out E> {

    shared formal
    Box<B> map<A, B>(Box<A> source, B(A) f);

    shared default
    Box<B>(Box<A>) lift<A, B>(B(A) f)
        // FIXME this is newly broken? See [[liftExample]]
        //=>  shuffle(curry(map<A,B>))(f);
        =>  (Box<A> as) => map<A,B>(as, f);

    // TODO consider reverting to using an anonymous class
    // after https://github.com/ceylon/ceylon-spec/issues/1310
    shared default
    FunctorWrapper<Box, A> wrap<A>
            (Box<A> unwrapped)
        =>  FunctorWrapperImpl<Box, A>
                (this, unwrapped);
}

shared
interface FunctorOpsMixin<Box, out A, out Self>
        satisfies Wrapper<Box, A, Self, Functor>
        given Box<out E>
        given Self<C, El> given C<out E2> {

    shared default
    Self<Box, B> map<B>(B(A) f)
        =>  wrap<B>(typeClass.map(unwrapped, f));
}

shared
interface FunctorWrapper<Box, out A>
        satisfies FunctorOpsMixin<Box, A, FunctorWrapper>
        given Box<out E> {}

class FunctorWrapperImpl<Box, A>(
        shared actual Functor<Box> typeClass,
        shared actual Box<A> unwrapped)
        satisfies FunctorWrapper<Box, A>
        given Box<out E> {

    shared actual
    FunctorWrapper<Box, E> wrap<E>(Box<E> wrapped)
        =>  FunctorWrapperImpl<Box, E>(typeClass, wrapped);
}
