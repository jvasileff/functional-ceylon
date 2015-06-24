shared
object iteratees {

    shared
    Iteratee<Element, {Element*}> consume<Element>(
            {Element*}? data = null)
        =>  reversed<Element>()
            .map((rest)
                =>  let (tail = rest.sequence().reversed)
                    if (exists data)
                    then data.chain(rest)
                    else tail);

    shared
    Iteratee<Element, {Element*}> reversed<Element>(
            {Element*} data = emptyCons)
        =>  fold<Element, {Element*}>(data)((partial, element)
            =>  partial.follow(element));

    shared
    Iteratee<Element, {Element*}> take<Element>(
            Integer count,
            {Element*}? data = null) {

        Next<Element, ConsList<Element>> step(
                Integer count,
                ConsList<Element> data = emptyCons) => Next.onInput {

            function element(Element element)
                =>  let (remaining = count - 1,
                         list = data.follow(element))
                    if (remaining.zero)
                    then Done(list, nil.input<Element>())
                    else step(remaining, list);

            function nil()
                =>  step(count, data);

            function eof()
                =>  Done(data, eof.input<Element>());
        };

        return if (count < 1)
        then Done(data else {}, nil.input<Element>())
        else step(count).map((ConsList<Element> rest)
            =>  let (tail = rest.sequence().reversed)
                if (exists data)
                then data.chain(tail)
                else tail);
    }

    shared
    Iteratee<Element, {Element*}> takeWhile<Element>(
            Boolean matches(Element c),
            {Element*}? data = null) {

        Next<Element, ConsList<Element>> step(
                ConsList<Element> data = emptyCons) => Next.onInput {

            function element(Element element)
                =>  if (!matches(element))
                    then Done(data, Chunk(element))
                    else step(data.follow(element));

            function nil()
                =>  step(data);

            function eof()
                =>  Done(data, eof.input<Element>());
        };

        return step().map((ConsList<Element> rest)
            =>  let (tail = rest.sequence().reversed)
                if (exists data)
                then data.chain(rest)
                else tail);
    }

    shared
    Iteratee<Element, Element?> head<Element>()
            given Element satisfies Object {

        Next<Element, Element?> step() => Next.onInput {
            function element(Element element)
                =>  Done(element, nil.input<Element>());

            function nil()
                =>  step();

            function eof()
                =>  Done(null, eof.input<Element>());
        };

        return step();
    }

    shared
    Iteratee<Element, Integer> drop<Element>(Integer count) {

        Next<Element, Integer> step(Integer count) => Next.onInput {

            function element(Element element)
                =>  let (remaining = count - 1)
                    if (remaining.zero)
                    then Done(0, nil.input<Element>())
                    else step(remaining);

            function nil()
                =>  step(count);

            function eof()
                =>  Done(count, eof.input<Element>());
        };

        return if (count < 1)
        then Done(count, nil.input<Element>())
        else step(count);
    }

    shared
    Iteratee<Element, Anything> dropWhile<Element>(
            Boolean matches(Element c)) {

        Next<Element, Anything> step() => Next.onInput {

            function element(Element element)
                =>  if (!matches(element))
                    then Done(null, Chunk(element))
                    else step();

            function nil()
                =>  step();

            function eof()
                =>  Done(null, eof.input<Element>());
        };

        return step();
    }

    shared
    Iteratee<Element, Element?> peek<Element>()
            given Element satisfies Object {

        Next<Element, Element?> step() => Next.onInput {
            function element(Element element)
                =>  Done(element, Chunk(element));

            function nil()
                =>  step();

            function eof()
                =>  Done(null, eof.input<Element>());
        };

        return step();
    }

    shared
    Iteratee<Element, Anything> expect<Element>(Element element)
            given Element satisfies Object {

        function iterateeForElement(Element? actual)
            =>  switch(actual)
                case (is Element)
                    if (actual == element)
                    then Done(null, nil.input<Element>())
                    else Error(Exception(
                            "Expected ```element``` but got ```actual```"),
                            nil.input<Element>())
                case (null)
                    Error(Exception(
                        "Premature end of input, expected: ```element```"),
                        nil.input<Element>());

        return head<Element>().flatMap(iterateeForElement);
    }

    shared
    Iteratee<Element, Integer> length<Element>()
        =>  fold<Element, Integer>(0)((partial, element)
            =>  partial + 1);

    shared
    Iteratee<In, Out> fold<In, Out>
            (Out initial)
            (Out accumulating(Out partial, In element)) {

        Next<In,Out> step(Out partial) => Next.onInput {
            function element(In element)
                =>  step(accumulating(partial, element));

            function nil()
                =>  step(partial);

            function eof()
                =>  Done(partial, eof.input<In>());
        };

        return step(initial);
    }

    shared
    Iteratee<In, Out> foldEarly<In, Out>
            (Out initial)
            ([Out, Boolean] accumulating(Out partial, In element)) {

        Next<In,Out> step(Out partial) => Next.onInput {

            function element(In element)
                =>  let ([result, done] = accumulating(partial, element))
                    if (done)
                    then Done(result, nil.input<In>())
                    else step(result);

            function nil()
                =>  step(partial);

            function eof()
                =>  Done(partial, eof.input<In>());
        };

        return step(initial);
    }
}
