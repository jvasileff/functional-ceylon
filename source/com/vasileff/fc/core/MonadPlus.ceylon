shared
interface MonadPlus<Container>
        satisfies Monad<Container> &
                  ApplicativePlus<Container>
        given Container<out E> {

    // FIXME re-stating "bind" here; type inference doesn't work otherwise
    shared actual formal
    Container<B> bind<A, B>(Container<A> source, Container<B>(A) apply);
}
