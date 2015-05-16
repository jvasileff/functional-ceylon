import ceylon.promise {
    Deferred,
    Promise
}

import com.vasileff.fc.core {
    Functor,
    identityFunctor,
    maybeFunctor,
    sequentialFunctor,
    promiseFunctor
}

shared
void functorExamples() {
    F<String> doubleToString<F>
            (Functor<F> f, F<Integer> source)
            given F<out E>
        =>  f.map(source, (Integer i) => (i*2).string);

    print(doubleToString(identityFunctor, 5));

    print(doubleToString(maybeFunctor, 5));
    print(doubleToString(maybeFunctor, null));

    print(doubleToString(sequentialFunctor, {1,2,3,4,5}.sequence()));
    print(doubleToString(sequentialFunctor, 1:5));

    value deferred = Deferred<Integer>();
    value promise = doubleToString<Promise>(promiseFunctor, deferred.promise);
    promise.completed((s) => print("From promise: " + s));
    deferred.fulfill(6);
}
