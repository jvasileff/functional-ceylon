shared
interface PlusEmpty<Container>
        satisfies Plus<Container>
        given Container<out E> {
    shared formal
    Container<Nothing> empty;
}
