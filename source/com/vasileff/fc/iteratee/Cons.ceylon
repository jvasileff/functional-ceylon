shared abstract
class ConsList<out Element>()
        of Cons<Element> | emptyCons
        satisfies {Element*} {

    shared actual formal
    Cons<Element|Other> follow<Other>(Other head);
}

shared final
class Cons<out Element>(
        shared actual Element first,
        shared actual ConsList<Element> rest = emptyCons)
        extends ConsList<Element>()
        satisfies {Element+} {

    shared actual
    Iterator<Element> iterator()
        =>  object satisfies Iterator<Element> {
                variable
                ConsList<Element> cons = outer;

                shared actual
                Element|Finished next() {
                    switch (current = cons)
                    case (is \IemptyCons) {
                        return finished;
                    }
                    else {
                        cons = current.rest;
                        return current.first;
                    }
                }
            };

    shared actual
    Cons<Element|Other> follow<Other>(Other head)
        =>  Cons<Element|Other>(head, this);
}

shared
object emptyCons extends ConsList<Nothing>() {
    shared actual
    \IemptyCons rest
        =>  emptyCons;

    shared actual
    Iterator<Nothing> iterator()
        =>  emptyIterator;

    shared actual
    Cons<Other> follow<Other>(Other head)
        =>  Cons(head);
}
