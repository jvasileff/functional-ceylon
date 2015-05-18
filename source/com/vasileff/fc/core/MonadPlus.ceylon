shared
interface MonadPlus<Container>
        satisfies Monad<Container> &
                  ApplicativePlus<Container>
        given Container<out E> {}
