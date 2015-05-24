shared
interface Foldable<Box>
        satisfies Wrapping<FoldableWrapper, Box>
        given Box<out E> {

    shared formal
    B foldLeft<A, B>
            (Box<A> source,
             B initial)
            (B(B, A) accumulating);

    shared default
    A intercalate<A>(Monoid<A> monoid, Box<A> source, A a)
        =>  foldLeft<A,A?>(source, null)((partial, element)
            =>  monoid.append(
                    if (exists partial)
                    then monoid.append(partial, a)
                    else monoid.zero,
                    element)) else monoid.zero;
}

shared
interface FoldableOpsMixin<Box, A, out Self, out FSelf>
        satisfies Wrapper<Box, A, Self, FSelf>
        given FSelf<FSB>
            satisfies Foldable<FSB> & Wrapping<Self, FSB>
            given FSB<out FSBE>
        given Box<out E>
        given Self<SB, SE>
            given SB<out SBE> {

    shared default
    B foldLeft<B>(B initial)(B(B, A) accumulating)
        =>  typeClass.foldLeft(unwrapped, initial)(accumulating);

    shared default
    A|B intercalate<B>(Monoid<A|B> monoid, B item)
        =>  typeClass.intercalate(monoid, unwrapped, item);
}

shared
interface FoldableWrapper<Box, A>
        satisfies FoldableOpsMixin<Box, A, FoldableWrapper, Foldable>
        given Box<out E> {}

// Foldable + Monad

shared
interface FoldableMonad<Box>
        satisfies Monad<Box>
            & Foldable<Box>
            & Wrapping<FoldableMonadWrapper, Box>
        given Box<out E> {

    shared actual default
    FoldableMonadWrapper<Box, A> wrap<A>
            (Box<A> unwrapped)
            => let (uw = unwrapped) object
            satisfies FoldableMonadWrapper<Box, A> {

        shared actual
        Box<A> unwrapped => uw;

        shared actual
        FoldableMonad<Box> typeClass => outer;
    };
}

shared
interface FoldableMonadWrapper<Box, A>
        satisfies MonadWrapper<Box, A>
            & FoldableWrapper<Box, A>
            & MonadOpsMixin<Box, A, FoldableMonadWrapper, FoldableMonad>
            & FoldableOpsMixin<Box, A, FoldableMonadWrapper, FoldableMonad>
        given Box<out E> {}

// Foldable + MonadPlus

shared
interface FoldableMonadPlus<Box>
        satisfies MonadPlus<Box>
            & Foldable<Box>
            & Wrapping<FoldableMonadPlusWrapper, Box>
        given Box<out E> {

    shared actual default
    FoldableMonadPlusWrapper<Box, A> wrap<A>
            (Box<A> unwrapped)
            => let (uw = unwrapped) object
            satisfies FoldableMonadPlusWrapper<Box, A> {

        shared actual
        Box<A> unwrapped => uw;

        shared actual
        FoldableMonadPlus<Box> typeClass => outer;
    };
}

shared
interface FoldableMonadPlusWrapper<Box, A>
        satisfies MonadPlusWrapper<Box, A>
            & FoldableWrapper<Box, A>
            & MonadPlusOpsMixin<Box, A, FoldableMonadPlusWrapper, FoldableMonadPlus>
            & FoldableOpsMixin<Box, A, FoldableMonadPlusWrapper, FoldableMonadPlus>
        given Box<out E> {}
