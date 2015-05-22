shared
interface PlusEmpty<Box>
        satisfies Plus<Box>
        given Box<out E> {

    shared formal
    Box<Nothing> empty;
}
