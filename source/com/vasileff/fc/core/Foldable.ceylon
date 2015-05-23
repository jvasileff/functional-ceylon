shared
interface Foldable<Box>
        given Box<out E> {

    shared formal
    B foldLeft<A, B>
            (Box<A> source,
             B initial)
            (B(B, A) accumulating);
}

shared
interface FoldableOpsMixin<Box, out A, Self>
        satisfies Wrapper<Box, A, Self, Foldable>
        given Box<out E>
        given Self<C, El> given C<out E2> {

    shared default
    B foldLeft<B>(B initial)(B(B, A) accumulating)
        =>  typeClass.foldLeft(unwrapped, initial)(accumulating);
}

shared
interface FoldableMonadPlusWrapper<Box, out A>
        satisfies MonadWrapper<Box, A>
            & MonadOpsMixin<Box, A, FoldableMonadPlusWrapper>
            & FoldableOpsMixin<Box, A, FoldableMonadPlusWrapper>
        given Box<out E> {}
