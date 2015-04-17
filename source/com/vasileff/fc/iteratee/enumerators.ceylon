//https://github.com/ceylon/ceylon-compiler/issues/2072
shared
Enumerator<Element> enumerator<Element>({Element*} stream)
    =>  object extends Enumerator<Element>() {

        shared actual
        Iteratee<Element, Out> apply<Out>(
                variable Iteratee<Element, Out> iteratee) {

            for (x in stream) {
                switch(it = iteratee of IterateeEnum<Element, Out>)
                case(is NextRaw) {
                    iteratee = it.consume(Chunk(x));
                }
                case(is DoneRaw) {
                    break;
                }
                case(is ErrorRaw) {
                    break;
                }
            }
            return iteratee;
        }
    };
