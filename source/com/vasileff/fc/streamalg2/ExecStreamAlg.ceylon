"Terminal Combinators"
shared
interface ExecStreamAlg<E, C> {
    shared formal
    Application<E, Integer> count<Element>(
            Application<C, Element> stream);

    shared formal
    Application<E, Element> reduce<Element>(
            Element identity,
            Element(Element, Element) accumulator,
            Application<C,Element> stream);
}
