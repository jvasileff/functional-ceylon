"Terminal Combinators"
shared
interface ExecStreamAlg<E, C> given E<E> given C<E> {
    shared formal
    E<Integer> count<Element>(
            C<Element> stream);

    shared formal
    E<Element> reduce<Element>(
            Element identity,
            Element(Element, Element) accumulator,
            C<Element> stream);
}
