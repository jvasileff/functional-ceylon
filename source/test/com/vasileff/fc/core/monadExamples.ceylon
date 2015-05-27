import ceylon.promise {
    Deferred,
    Promise
}
import ceylon.test {
    test,
    assertEquals
}

import com.vasileff.fc.core {
    Functor,
    Monad,
    sequentialTypeClass,
    promiseTypeClass,
    Applicative,
    identityTypeClass,
    maybeTypeClass,
    MonadPlus,
    Foldable,
    FoldableWrapper,
    MonadWrapper,
    integerPlusMonoid
}

shared test
void functorExamples() {
    F<String> doubleToString<F>
            (Functor<F> f, F<Integer> source)
            given F<out E>
        =>  f.map(source, compose(Integer.string, 2.times));

    assertEquals(doubleToString(identityTypeClass, 5), "10");

    assertEquals(doubleToString(maybeTypeClass, 5), "10");
    assertEquals(doubleToString(maybeTypeClass, null), null);

    assertEquals(doubleToString(sequentialTypeClass,
            {1,2,3,4,5}.sequence()),
            ["2","4","6","8","10"]);

    assertEquals(doubleToString(sequentialTypeClass,
            1:5),
            ["2","4","6","8","10"]);

    value deferred = Deferred<Integer>();
    value promise = doubleToString<Promise>
            (promiseTypeClass, deferred.promise);
    promise.completed((s) => assertEquals(s, "12"));
    deferred.fulfill(6);
}

shared test
void applicativeExamples() {
    value f = [2.times, 3.plus];
    assertEquals(sequentialTypeClass.apply([1,2,3], f),
            [2, 4, 6, 4, 5, 6]);

    value deferredValue = Deferred<Integer>();
    value deferredFunction = Deferred<Integer(Integer)>();
    value promise = promiseTypeClass.apply(
            deferredValue.promise, deferredFunction.promise);
    promise.completed((i)
        =>  assertEquals(i, 20));
    deferredValue.fulfill(10);
    deferredFunction.fulfill(2.times);

    function doubleWithApplicative<Container>(
            Applicative<Container> applicative,
            Container<Integer> container)
            given Container<out E>
        =>  applicative.apply(container, applicative.unit(2.times));

    assertEquals(doubleWithApplicative
            (identityTypeClass, 21), 42);

    assertEquals(doubleWithApplicative
            (maybeTypeClass, null), null);

    assertEquals(doubleWithApplicative
            (sequentialTypeClass, 22..24), [44,46,48]);

    doubleWithApplicative(promiseTypeClass,
            promiseTypeClass.unit(25)).completed((i)
                =>  assertEquals(i, 50));
}

shared test
void coalesceExample() {
    Container<Element&Object> coalesce<Container, Element>(
            MonadPlus<Container> monad,
            Container<Element> source)
            given Container<out E>
        =>  monad.bind(source, (Element e)
            =>  if (exists e)
                then monad.unit(e)
                else monad.empty);

    assertEquals(coalesce<Sequential, Integer?>
            (sequentialTypeClass, [1, 2, null, 3]),
            [1,2,3]);

    assertEquals(coalesce<Sequential, Integer?>
            (sequentialTypeClass, [null]),
            []);
}

shared test
void wrapperExample() {
    // with wrapper
    assertEquals(sequentialTypeClass.wrap([1,2,3])
            .map(2.times)
            .map(2.plus)
            .foldLeft(0)(plus), 18);

    // without wrapper
    value tc = sequentialTypeClass;
    assertEquals(tc.foldLeft(
        tc.map(tc.map([1,2,3],
            2.times),
            2.plus),
        0)(plus), 18);

    F<String> doubleToString<F>
            (Functor<F> & Foldable<F> f, F<Integer> source)
            given F<out E>
        =>  f.wrap(source)
                .map(2.times).map(Object.string)
                .unwrapped;

    assertEquals(doubleToString
            (sequentialTypeClass, 1:5),
            ["2","4","6","8","10"]);
}

shared test
void flattenExample() {
    Container<Element> flattenTest<Container, Element>(
            Monad<Container> monad,
            Container<Container<Element>> source)
            given Container<out E>
        =>  monad.join(source);

    assertEquals(sequentialTypeClass.join([[1,2],[3,4]]),
            [1,2,3,4]);

    assertEquals(flattenTest<Sequential, Integer>
            (sequentialTypeClass, [[1,2],[3,4]]),
            [1,2,3,4]);
}

shared test
void liftExample() {
    function quadrupleWithLift<Container>(
            Monad<Container> monad,
            Container<Integer> ints)
            given Container<out E>
        =>  let (double = monad.lift(2.times))
            double(double(ints));

    assertEquals(quadrupleWithLift
            (identityTypeClass, 2), 8);

    assertEquals(quadrupleWithLift
            (sequentialTypeClass, 2..5), [8,12,16,20]);
}

shared
void wrapperExperiment() {
    alias AdHocTypeClass
        =>  Foldable<Sequential> &
            Monad<Sequential>;

    alias AdHocWrapper
        =>  FoldableWrapper<Sequential,Integer> &
            MonadWrapper<Sequential,Integer>;

    AdHocTypeClass tc = sequentialTypeClass;

    AdHocWrapper wrapper = tc.wrap([1,2,3]);
    // would be nice to have this be guaranteed,
    // and w/o assert. But probably not possible.
    assert(is AdHocWrapper result1 = wrapper.map(2.times));
    assert(is AdHocWrapper result2 = wrapper.map(2.times));
    print(result2.fold(integerPlusMonoid));
}
