import ceylon.promise {
    Deferred,
    Promise
}

import com.vasileff.fc.core {
    Functor,
    identityFunctor,
    maybeFunctor,
    sequentialFunctor,
    promiseFunctor,
    PlusEmpty,
    Monad,
    sequentialTypeClass
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

shared
void coalesceExample() {
    // TODO simplify; see https://github.com/ceylon/ceylon-js/issues/556
    Container<Element&Object> coalesce<Container, Element>(
            Monad<Container> monad, PlusEmpty<Container> plusEmpty,
            //Monad<Container> & PlusEmpty<Container> typeClass,
            Container<Element> source)
            given Container<out E>
        =>  //let (Monad<Container> monad = typeClass)
            //let (PlusEmpty<Container> plusEmpty = typeClass)
            monad.bind(source, (Element e)
            =>  if (exists e)
                then monad.unit(e)
                else plusEmpty.empty);

    print(coalesce<Sequential, Integer?>(
            sequentialTypeClass, sequentialTypeClass,
            [1, 2, null, 3]));

    print(coalesce<Sequential, Integer?>(
            sequentialTypeClass, sequentialTypeClass,
            [null]));
}

shared
void flattenExample() {
    Container<Element> flattenTest<Container, Element>(
            Monad<Container> monad,
            Container<Container<Element>> source)
            given Container<out E>
        =>  monad.join(source);

    // TODO nope, doesn't work yet!!!
    print(flattenTest<Sequential, Integer>
        (sequentialTypeClass, [[1,2],[3,4]]));
}
