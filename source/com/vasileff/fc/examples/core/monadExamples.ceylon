import ceylon.promise {
    Deferred,
    Promise
}

import com.vasileff.fc.core {
    Functor,
    Monad,
    sequentialTypeClass,
    promiseTypeClass,
    Applicative,
    identityTypeClass,
    maybeTypeClass,
    MonadPlus
}

shared
void functorExamples() {
    F<String> doubleToString<F>
            (Functor<F> f, F<Integer> source)
            given F<out E>
        =>  f.map(source, (Integer i) => (i*2).string);

    print(doubleToString(identityTypeClass, 5));

    print(doubleToString(maybeTypeClass, 5));
    print(doubleToString(maybeTypeClass, null));

    print(doubleToString(sequentialTypeClass, {1,2,3,4,5}.sequence()));
    print(doubleToString(sequentialTypeClass, 1:5));

    value deferred = Deferred<Integer>();
    value promise = doubleToString<Promise>(promiseTypeClass, deferred.promise);
    promise.completed((s) => print("From promise: " + s));
    deferred.fulfill(6);
}

shared
void applicativeExamples() {
    value f = [2.times, 3.plus];
    value result = sequentialTypeClass.apply([1,2,3], f);
    print(result); // [2, 4, 6, 4, 5, 6]

    value deferredValue = Deferred<Integer>();
    value deferredFunction = Deferred<Integer(Integer)>();
    value promise = promiseTypeClass.apply(
            deferredValue.promise, deferredFunction.promise);
    promise.completed((Integer val) => print("final result: ``val``"));
    deferredValue.fulfill(10);
    deferredFunction.fulfill(2.times);

    function doubleWithApplicative<Container>(
            Applicative<Container> applicative,
            Container<Integer> container)
            given Container<out E>
        =>  applicative.apply(container, applicative.unit(2.times));

    print(doubleWithApplicative(identityTypeClass, 21));
    print(doubleWithApplicative(maybeTypeClass, null));
    print(doubleWithApplicative(sequentialTypeClass, 22..24));

    doubleWithApplicative(promiseTypeClass,
            promiseTypeClass.unit(25)).completed(print);
}

shared
void coalesceExample() {
    Container<Element&Object> coalesce<Container, Element>(
            MonadPlus<Container> monad,
            Container<Element> source)
            given Container<out E>
        =>  monad.bind(source, (Element e)
            =>  if (exists e)
                then monad.unit(e)
                else monad.empty);

    print(coalesce<Sequential, Integer?>(
            sequentialTypeClass, [1, 2, null, 3]));

    print(coalesce<Sequential, Integer?>(
            sequentialTypeClass, [null]));
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

shared
void liftExample() {
    function quadrupleWithLift<Container>(
            Monad<Container> monad,
            Container<Integer> ints)
            given Container<out E>
        =>  let (double = monad.lift(2.times))
            double(double(ints));

    print(quadrupleWithLift(identityTypeClass, 2));
    print(quadrupleWithLift(sequentialTypeClass, 2..5));
}
