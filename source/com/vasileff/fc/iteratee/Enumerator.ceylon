shared abstract
class Enumerator<Element>() {
    shared formal
    Iteratee<Element, Out> apply<Out>(Iteratee<Element, Out> iteratee);

    shared default
    Out|Error<Element> run<Out>(Iteratee<Element, Out> iteratee)
        =>  apply(iteratee).run();

    shared default
    Out runOrThrow<Out>(Iteratee<Element, Out> iteratee) {
        switch (result = apply(iteratee).run())
        // is check for Error first, to avoid throwing if is on Out fails...
        case (is Error<Element>) {
            throw result.throwable;
        }
        else {
            return result;
        }
    }

    "Compose this `Enumerator` with the given [[enumeratee]]."
    shared
    Enumerator<OtherElement> through<OtherElement>(
            Enumeratee<Element, OtherElement> enumeratee) =>
            object extends Enumerator<OtherElement>() {

        shared actual
        Iteratee<OtherElement, Out> apply<Out>(
                Iteratee<OtherElement, Out> iteratee)
            =>  let (// Iteratee<Element,Iteratee<OtherElement,Out>>
                     transformed = enumeratee.apply(iteratee),
                     applied = outer.apply(transformed),
                     result = applied.run())

                // it will keep getting back a new
                //      Iteratee<Element, Iteratee<OtherElement, Out>>
                // until it gets a Done, holding the final Iteratee<OtherElement, Out>
                // which it will extract with run(), and return.

                // FIXME Element and To not disjoint.
                // And, is this the right approach? What about remainingInput?
                // The error would be from the enumeratee, right?
                // Maybe just throw that one?
                if (is Error<Element> result)
                then Error(result.throwable, nil.input<OtherElement>())
                else result;
    };

    shared
    Enumerator<OtherElement> map<OtherElement>(
            OtherElement(Element) f)
        =>  through(enumeratees.map(f));

    shared
    Enumerator<OtherElement> mapInput<OtherElement>(
            Input<OtherElement>(Input<Element>) f)
        =>  through(enumeratees.mapInput(f));

    shared
    Enumerator<Other> flatMap<Other>(Enumerator<Other>(Element) f) => object
            extends Enumerator<Other>() {

        shared actual
        Iteratee<Other, Out> apply<Out>(Iteratee<Other, Out> iteratee) {

            value folder = iteratees.foldEarly<Element, Iteratee<Other, Out>>(
                    iteratee)((Iteratee<Other, Out> it, Element e)
                =>  let (result = f(e).apply(it))
                    [result, isDoneOrError(result)]);

            // FIXME as with through, how should error be handled?
            value result = outer.run(folder);
            return if (is Error<Element> result)
            then Error(result.throwable, nil.input<Other>())
            else result;
        }
    };

    shared
    Boolean isDoneOrError<In, Out>(Iteratee<In, Out> iteratee)
        =>  !(iteratee is NextRaw);

}
