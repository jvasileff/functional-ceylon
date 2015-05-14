shared
object enumeratees {

    shared
    Enumeratee<From, To> mapInput<From, To>(
            Input<To>(Input<From>) collecting) => object
            satisfies NextOnly<From, To> {

        shared actual
        Iteratee<From, Iteratee<To, Out>> next<Out>
                (Next<To, Out> inner)(Input<From> input)
            =>  switch (input)
                case (is Chunk<Anything> | \Inil)
                    apply(inner.consume(collecting(input)))
                case (eof)
                    Done(inner, input);
    };

    shared
    Enumeratee<From, To> map<From, To>(To(From) f)
        =>  mapInput((Input<From> i) => i.map(f));

    shared
    Enumeratee<From, To> group<From, To>(
            "The [[Iteratee]] that collects each group"
            Iteratee<From, To> collecting) => object
            satisfies NextOnly<From, To> {

        // FIXME this is ugly
        function forceFeed<In, Out>(Iteratee<In, Out> it, Input<In> input)
            =>  switch (it)
                case (is Next<In, Out>)
                    it.consume(input)
                case (is Done<In, Out> | Error<In>)
                    it;

        Iteratee<From, Iteratee<To, Out>> step<Out>(
                "The [[Iteratee]] that is collecting the group"
                Iteratee<From, To> git,
                "The [[Iteratee]] that accepts each completed group"
                Next<To, Out> inner)(
                "The [[Input]] to process"
                Input<From> input)
            =>  switch (input)
                case (is Chunk<Anything> | \Inil) (
                    switch (it = forceFeed(git, input) of IterateeEnum<From,To>)
                    case (is NextRaw)
                        // keep feeding the group iteratee
                        Next(step(it, inner))
                    case (is DoneRaw) (
                        // play it again, sam (next group)
                        switch(nextInner = inner.consume(Chunk(it.result))
                                of IterateeEnum<To,Out>)
                        case (is NextRaw)
                            if (is ChunkRaw remainder = it.remainingInput)
                            then step(collecting, nextInner)(remainder)
                            else Next(step(collecting, nextInner))
                        case (is DoneRaw | ErrorRaw)
                            Done(nextInner, nil.input<From>()))
                    case (is ErrorRaw)
                        it)
                case(eof) (
                    // extract the last group, feed 'inner', return Done
                    switch (result = git.run())
                    case (is Error<From>) result
                    else Done(inner.consume(Chunk(result)), input));

        shared actual
        Iteratee<From, Iteratee<To, Out>> next<Out>
                (Next<To, Out> inner)(Input<From> input)
            =>  step(collecting, inner)(input);
    };
}

// TODO NextOnly move back into `enumeratees`; see
// https://github.com/ceylon/ceylon-js/issues/549
"Convenience Enumeratee to only process [[Next]] [[Iteratee]]s"
interface NextOnly<From, To> satisfies Enumeratee<From, To> {

    "When provided with [[inner]], produces a [[Consume]]. Defined
     in curried form to simplify syntax for implementations."
    shared formal
    Iteratee<From, Iteratee<To, Out>> next<Out>
            (Next<To, Out> inner)(Input<From> input);

    shared actual
    Iteratee<From, Iteratee<To, Out>> apply<Out>(Iteratee<To, Out> inner)
        =>  switch (it = inner of IterateeEnum<To, Out>)
            case (is NextRaw)
                Next(next(it))
            case (is DoneRaw | ErrorRaw)
                Done(inner, nil.input<From>());
}
