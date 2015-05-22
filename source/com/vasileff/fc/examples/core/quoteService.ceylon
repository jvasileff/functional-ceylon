import ceylon.promise {
    Promise,
    Deferred
}

import com.vasileff.ceylon.random.api {
    LCGRandom
}
import com.vasileff.fc.core {
    Functor,
    identityTypeClass,
    sequentialTypeClass,
    promiseTypeClass
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
    SequentialT<Outer, B> map<A, B>
            (ST<A> source, B(A) apply)
        =>  source.map(apply);

    shared
    SequentialT<Outer, Element> wrapOuter<Element>
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
    Quote rhtQuote = quoteService(identityTypeClass, "RHT");
    print(rhtQuote); // RHT->100.0

    // Obtain multiple quotes at once,
    // from [Symbol*] to [Quote*]
    [Quote*] quotes = quoteService(sequentialTypeClass, ["RHT", "IBM", "AAPL"]);
    print(quotes); // [RHT->100.0, IBM->100.0, AAPL->100.0]

    // obtain a quote *when* we know which one we need!
    // from Promise<Symbol> to Promise<Quote>
    Deferred<Symbol> deferred = Deferred<Symbol>();
    Promise<Quote> promisedQuote = quoteService(promiseTypeClass, deferred.promise);
    promisedQuote.completed((quote) => print("Now we have it: ``quote``"));
    deferred.fulfill("FB"); // Now we have it: FB->100.0

    // obtain a bunch of quotes *when* we know which ones we need!
    // from Promise<[Symbol*]> to Promise<[Quote*]>
    value promiseSequentialFunctor = SequentialTFunctor(promiseTypeClass);
    Deferred<[Symbol*]> deferredList = Deferred<[Symbol*]>();

    // FIXME look into type inference? Seems like inference is correct, but doesn't
    // give ST credit for being covariant in Element?
    Promise<[Quote*]> promisedQuotes = quoteService<SequentialTFunctor<Promise>.ST>(
            promiseSequentialFunctor,
            promiseSequentialFunctor.wrapOuter(
                deferredList.promise)
        ).unwrapped;
    promisedQuotes.completed((quotes) => print("Now we have them: ``quotes``"));
    deferredList.fulfill(["TWTR", "EBAY"]); // JS Compiler meltdown!
}
