import ceylon.promise {
    Deferred,
    Promise
}

shared
object promiseTypeClass satisfies Monad<Promise> {
    shared actual
    Promise<B> bind<A, B>
            (Promise<A> source,
            Promise<B>(A) apply)
        =>  source.flatMap(apply);

    shared actual
    Promise<B> map<A, B>
            (Promise<A> source,
            B(A) apply)
        =>  source.map(apply);

    shared actual
    Promise<A> unit<A>(A element) {
        value deferred = Deferred<A>();
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
