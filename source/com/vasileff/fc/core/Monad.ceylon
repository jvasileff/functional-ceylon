shared
interface Monad<Box>
        satisfies Applicative<Box>
        given Box<out E> {

    shared formal
    Box<B> bind<A, B>(Box<A> source, Box<B>(A) apply);

    shared actual default
    Box<B> map<A, B>(Box<A> source, B(A) apply)
        =>  bind(source, compose(unit<B>, apply));

    shared default
    Box<A> join<A>(Box<Box<A>> source)
        =>  bind<Box<A>, A>(source, identity);

    // TODO consider reverting to using an anonymous class
    // after https://github.com/ceylon/ceylon-spec/issues/1310
    shared actual default
    MonadWrapper<Box, A> wrap<A>
            (Box<A> unwrapped)
        =>  MonadWrapperImpl<Box, A>
                (this, unwrapped);
}

shared
interface MonadOpsMixin<Box, out A, out Self>
        satisfies Wrapper<Box, A, Self, Monad> &
                  ApplicativeOpsMixin<Box, A, Self>
        given Box<out E>
        given Self<C, El> given C<out E2> {

    shared default
    Self<Box, B> bind<B>(
            Box<B>(A) apply)
        =>  wrap<B>(typeClass.bind(unwrapped, apply));
}

shared
interface MonadWrapper<Box, out A>
        satisfies ApplicativeWrapper<Box, A>
            & MonadOpsMixin<Box, A, MonadWrapper>
        given Box<out E> {}

class MonadWrapperImpl<Box, A>(
        shared actual Monad<Box> typeClass,
        shared actual Box<A> unwrapped)
        satisfies MonadWrapper<Box, A>
        given Box<out E> {

    shared actual
    MonadWrapper<Box, E> wrap<E>(Box<E> wrapped)
        =>  MonadWrapperImpl<Box, E>(typeClass, wrapped);
}
