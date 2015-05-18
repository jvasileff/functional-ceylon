shared
interface ApplicativePlus<Container>
        satisfies Applicative<Container> &
                  PlusEmpty<Container>
        given Container<out E> {}