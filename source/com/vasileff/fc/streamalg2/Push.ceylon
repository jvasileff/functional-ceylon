"Interface for push style streams"
shared
interface Push<Element> {
    shared formal
    void invoke(Anything(Element) k);
}

shared
alias Consumer<Element> => Anything(Element);
