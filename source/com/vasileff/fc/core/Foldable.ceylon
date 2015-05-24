shared
interface Foldable<Box>
        given Box<out E> {

    shared formal
    B foldLeft<A, B>
            (Box<A> source,
             B initial)
            (B(B, A) accumulating);

    shared default
    A intercalate<A>(Monoid<A> monoid, Box<A> source, A a)
        =>  foldLeft<A,A?>(source, null)((A? partial, element)
            =>  monoid.append(
                    if (exists partial)
                    then monoid.append(partial, a)
                    else monoid.zero,
                    element)) else monoid.zero;
}

shared
interface FoldableOpsMixin<Box, out A, Self>
        satisfies Wrapper<Box, A, Self, Foldable>
        given Box<out E>
        given Self<C, El> given C<out E2> {

    shared default
    B foldLeft<B>(B initial)(B(B, A) accumulating)
        =>  typeClass.foldLeft(unwrapped, initial)(accumulating);

    // FIXME FoldableOpsMixin can't be covariant in A!
    //shared default
    //A intercalate(Monoid<A> monoid, A item)
    //    =>  typeClass.intercalate(monoid, unwrapped, item);
}

shared
interface FoldableMonadPlusWrapper<Box, out A>
        satisfies MonadWrapper<Box, A>
            & MonadOpsMixin<Box, A, FoldableMonadPlusWrapper>
            & FoldableOpsMixin<Box, A, FoldableMonadPlusWrapper>
        given Box<out E> {}
