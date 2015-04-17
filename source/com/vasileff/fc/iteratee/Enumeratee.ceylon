shared
interface Enumeratee<From, To> {
    shared formal
    Iteratee<From, Iteratee<To, Out>> apply<Out>(Iteratee<To, Out> inner);
}