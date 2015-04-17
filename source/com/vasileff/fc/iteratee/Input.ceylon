shared abstract
class Input<out Element>() of Chunk<Element> | nil | eof {
    shared formal
    Input<Other> map<Other>(Other(Element) collecting);
}

shared
object nil extends Input<Nothing>() {
    shared actual
    \Inil map<Other>(Other(Nothing) collecting) => this;

    shared
    Input<Element> input<Element>() => this;
}

shared
object eof extends Input<Nothing>() {
    shared actual
    \Ieof map<Other>(Other(Nothing) collecting) => this;

    shared
    Input<Element> input<Element>() => this;
}

shared
class Chunk<out Element>(
        shared Element element)
        extends Input<Element>() {
    shared actual
    Chunk<Other> map<Other>(Other(Element) collecting)
        => Chunk(collecting(element));
}

alias ChunkRaw => Chunk<Anything>;