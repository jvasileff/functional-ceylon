import ceylon.promise {
    Promise,
    Deferred
}

import com.vasileff.ceylon.random.api {
    LCGRandom
}

///////////////////////////////////////
// FUNCTOR
///////////////////////////////////////
shared
interface Functor<F> given F<out E> {
    shared formal
    F<Out> map<In, Out>(F<In> source, Out(In) apply);
}

///////////////////////////////////////
// MONAD
///////////////////////////////////////

shared
interface Monad<M> satisfies Functor<M> given M<out E> {

    shared formal
    M<Out> unit<Out>(Out element);

    shared formal
    M<Out> bind<In, Out>(M<In> source, M<Out>(In) apply);

    shared actual default
    M<Out> map<In, Out>(M<In> source, Out(In) apply)
        =>  bind<In, Out>(source, (x) => unit(apply(x)));
}

///////////////////////////////////////
// Identity Monad
///////////////////////////////////////

shared
alias Identity<out T> => T;

shared
object identityMonad satisfies Monad<Identity> {
    shared actual
    Out bind<In, Out>(In source, Out(In) apply)
        =>  apply(source);

    shared actual
    Out unit<Out>(Out element)
        =>  element;
}

///////////////////////////////////////
// Maybe Monad
///////////////////////////////////////

shared
alias Maybe<out T> => T?;

shared
object maybeMonad satisfies Monad<Maybe> {
    shared actual
    Out? bind<In, Out>(In? source, Out?(In) apply)
        =>  if (exists source)
            then apply(source)
            else null;

    shared actual
    Out unit<Out>(Out element)
        =>  element;
}

///////////////////////////////////////
// Sequential Monad
///////////////////////////////////////

shared
object sequentialMonad satisfies Monad<Sequential> {
    shared actual
    Sequential<Out> bind<In, Out>
            (Sequential<In> source,
            Sequential<Out>(In) apply)
        =>  source.flatMap(apply).sequence();

    shared actual
    Sequential<Out> unit<Out>(Out element)
        =>  Singleton(element);
}

///////////////////////////////////////
// Promise Monad
///////////////////////////////////////

shared
object promiseMonad satisfies Monad<Promise> {
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
}

///////////////////////////////////////
// SequentialT Functor
//      (wrap a Sequential inside
//       another functor)
///////////////////////////////////////

shared
class SequentialT<Outer, out Element>
        (outerFunctor, unwrapped)
        given Outer<out E> {

    Functor<Outer> outerFunctor;

    shared
    Outer<Sequential<Element>> unwrapped;

    shared
    SequentialT<Outer, B> map<B>(B(Element) f)
        =>  SequentialT<Outer, B>(outerFunctor,
                outerFunctor.map<Element[], B[]>(
                    unwrapped, (list) => list.collect(f)));
}

shared
class SequentialTFunctor<Outer>
        (Functor<Outer> outerFunctor)
        satisfies Functor<ST>
        given Outer<out F> {

    shared
    alias ST<out Element>
        =>  SequentialT<Outer, Element>;

    shared actual
    SequentialT<Outer, Out> map<In, Out>
            (ST<In> source, Out(In) apply)
        =>  source.map(apply);

    shared
    SequentialT<Outer, Element> wrap<Element>
            (Outer<Element[]> source)
        =>  SequentialT<Outer, Element>
                       (outerFunctor, source);
}

///////////////////////////////////////
// Stock Quote Service
///////////////////////////////////////

shared alias Symbol => String;
shared alias Quote => Symbol->Float;

shared
Container<Quote> quoteService<Container>(
        Functor<Container> f,
        Container<Symbol> source)
        given Container<out E>
    =>  let (random = LCGRandom())
        f.map(source, (Symbol symbol)
            =>  symbol ->
                    random.nextInteger(50000)/100.0);

///////////////////////////////////////
// Stock Quote Service Client
///////////////////////////////////////

shared
void run() {
    // degenerate case: uses an Identity container to
    // make quoteService act like a simple function
    // from Symbol to Quote
    Quote ibmQuote = quoteService(identityMonad, "RHT");
    print(ibmQuote); // RHT->100.0

    // Obtain multiple quotes at once,
    // from [Symbol*] to [Quote*]
    [Quote*] quotes = quoteService(sequentialMonad, ["RHT", "IBM", "AAPL"]);
    print(quotes); // [RHT->100.0, IBM->100.0, AAPL->100.0]

    // obtain a quote *when* we know which one we need!
    // from Promise<Symbol> to Promise<Quote>
    Deferred<Symbol> deferred = Deferred<Symbol>();
    Promise<Quote> promisedQuote = quoteService(promiseMonad, deferred.promise);
    promisedQuote.completed((quote) => print("Now we have it: ``quote``"));
    deferred.fulfill("FB"); // Now we have it: FB->100.0

    // obtain a bunch of quotes *when* we know which ones we need!
    // from Promise<[Symbol*]> to Promise<[Quote*]>
    value promiseSequentialFunctor = SequentialTFunctor(promiseMonad);
    Deferred<[Symbol*]> deferredList = Deferred<[Symbol*]>();    
    Promise<[Quote*]> promisedQuotes = quoteService(
            promiseSequentialFunctor,
            promiseSequentialFunctor
                .wrap(deferredList.promise)).unwrapped;
    promisedQuotes.completed((quotes) => print("Now we have them: ``quotes``"));
    deferredList.fulfill(["TWTR", "EBAY"]); // JS Compiler meltdown!
}
