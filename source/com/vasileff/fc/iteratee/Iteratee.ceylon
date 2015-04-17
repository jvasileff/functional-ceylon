shared
alias Consume<In, Out> => Iteratee<In, Out>(Input<In>);

alias IterateeEnum<In, out Out> => Next<In, Out>|Done<In, Out>|Error<In>;
alias NextRaw => Next<out Anything, Anything>;
alias DoneRaw => Done<out Anything, Anything>;
alias ErrorRaw => Error<out Anything>;

shared
interface Iteratee<In, out Out>
        of Next<In, Out> |
           Done<In, Out> |
           Error<In> {

    shared
    Result fold<Result>(
            Result(Consume<In, Out>) next,
            Result(Out, Input<In>) done,
            Result(Throwable, Input<In>) error)
        =>  switch (self = this of IterateeEnum<In, Out>)
            case (is NextRaw)
                next(self.consume)
            case (is DoneRaw)
                done(self.result, self.remainingInput)
            case (is ErrorRaw)
                error(self.throwable, self.remainingInput);

    shared
    Iteratee<In, OtherOut> flatMap<OtherOut>(
            Iteratee<In, OtherOut> collecting(Out result))
        =>  switch (self = this of IterateeEnum<In, Out>)
            case (is NextRaw)
                // we're not done;
                // return an iteratee that gives us first-shot at additional input
                Next((Input<In> input)
                    => self.consume(input).flatMap(collecting))
            case (is DoneRaw) (
                // determine the next iteratee
                switch (other = collecting(self.result) of IterateeEnum<In, OtherOut>)
                case (is DoneRaw)
                    // the new one is done too; preserve our remaining input
                    Done(other.result, self.remainingInput)
                case (is NextRaw)
                    // the new one is not done; process our remaining input
                    other.consume(self.remainingInput)
                case (is ErrorRaw)
                    other)
            case (is ErrorRaw)
                self;

    shared
    Iteratee<In, OtherOut> map<OtherOut>(
            OtherOut collecting(Out element))
        =>  switch (self = this of IterateeEnum<In, Out>)
            case (is NextRaw)
                Next((Input<In> input)
                    =>  self.consume(input).map(collecting))
            case (is DoneRaw)
                Done(collecting(self.result), self.remainingInput)
            case (is ErrorRaw)
                self;

    shared
    Out|Error<In> run()
        =>  switch (self = this of IterateeEnum<In, Out>)
            case (is NextRaw) self.consume(eof).run()
            case (is DoneRaw)     self.result
            case (is ErrorRaw)    self;

    shared
    Out runOrThrow() {
        switch (result = run())
        // perform 'is' check for Error first, to avoid
        // throwing if 'is' on Out throws...
        case (is Error<In>) {
            throw result.throwable;
        }
        else {
            return result;
        }
    }
}

shared final
class Next<In, out Out> satisfies Iteratee<In, Out> {

    shared
    Iteratee<In, Out> consume(Input<In> input);

    shared
    new (consume) {
        Iteratee<In, Out> consume(Input<In> input);
        this.consume = consume;
    }

    shared
    new On(element, nil, eof) {
        Iteratee<In, Out> element(In element);
        Iteratee<In, Out> nil();
        Iteratee<In, Out> eof();
        consume = (Input<In> input)
            =>  switch (input)
                case (package.nil) nil()
                case (package.eof) eof()
                else element(input.element);
    }
}

shared final
class Done<In, out Out=Anything>(
        shared Out result,
        shared Input<In> remainingInput = nil)
        satisfies Iteratee<In, Out> {}

shared final
class Error<In>(
        shared Throwable throwable,
        shared Input<In> remainingInput = nil)
        satisfies Iteratee<In, Nothing> {}
