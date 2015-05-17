import ceylon.promise {
    Deferred,
    Promise
}

shared
object promiseTypeClass satisfies Monad<Promise> {
    shared actual
    Promise<Out> bind<In, Out>
            (Promise<In> source,
            Promise<Out>(In) apply)
        =>  source.flatMap(apply);

    shared actual
    Promise<Out> map<In, Out>
            (Promise<In> source,
            Out(In) apply)
        =>  source.map(apply);

    shared actual
    Promise<Out> unit<Out>(Out element) {
        value deferred = Deferred<Out>();
        deferred.fulfill(element);
        return deferred.promise;
    }

    shared actual
    Promise<B> apply<A, B>(
            Promise<A> container,
            Promise<B(A)> f)
        =>  container.and(f)
                .map((f, a) => f(a));
}

shared
Functor<Promise> promiseFunctor = promiseTypeClass;

shared
Monad<Promise> promiseMonad = promiseTypeClass;
