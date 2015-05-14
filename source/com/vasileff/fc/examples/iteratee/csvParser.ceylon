import com.vasileff.fc.iteratee {
    Done,
    nil,
    iteratees,
    Iteratee,
    enumerator,
    enumeratees,
    Error
}

Iteratee<Character, Anything> dropSpaces
    =   iteratees.dropWhile((Character c) => c != '\n' && c.whitespace);

Iteratee<Character, String> unquoted
    =   iteratees.takeWhile((Character c) => c != ',' && c != '\n').map(String);

Iteratee<Character, String> quoted([Character*] data = [])
    =>  iteratees.expect('"')
        .flatMap((_)     => iteratees.takeWhile((Character c) => c != '"')
        .flatMap((maybe) => iteratees.expect('"')
        .flatMap((_)     => iteratees.peek<Character>()
        .flatMap((char)  =>
            switch(char)
            case ('"')
                quoted(data.append(maybe.sequence()).withTrailing('"'))
            else
                Done(String(data) + String(maybe), nil.input<Character>())))));

Iteratee<Character, String> field
    =   iteratees.peek<Character>()
        .flatMap((char)
            =>  switch (char)
                case (null)
                    Error(Exception(
                        "Premature end of input, expected a character"),
                        nil.input<Character>())
                case ('"')
                    quoted()
                else
                    unquoted);

Iteratee<Character, [String*]> record([String*] data = [])
    =>  dropSpaces
        .flatMap((_)    => field
        .flatMap((field)=> dropSpaces
        .flatMap((_)    => iteratees.head<Character>()
        .flatMap((char)
            =>  switch (char)
                case ('\n' | null)
                    Done(data.withTrailing(field), nil.input<Character>())
                case (',')
                    record(data.withTrailing(field))
                else
                    Error(Exception(
                        "Expected comma, newline, or eof, but found ```char```"),
                        nil.input<Character>())))));

shared
void csvTesting() {
    value file = enumerator("\"a\", \"b\", c\", d\n1,2,3,4\n5,6,7,8");
    value result = file.run(record());
    print(
        switch (result)
        case (is String[])  "The result is: ``result``"
        else                "Error: ``result.throwable.message``");

    value csv = enumeratees.Group(record());
    //value consumer = iteratees.consume<{String*}>();
    printAll(file.through(csv).runOrThrow(iteratees.consume<[String*]>()));

    print({{'a'},{'b'}});

    print(enumerator(1:13).runOrThrow(
        iteratees.drop<Integer>(2)
        .flatMap((_) => iteratees.take<Integer>(5)
        .flatMap((a) => iteratees.take<Integer>(2)
        .map((b)     => "``a``, and then ``b``")
        .flatMap((c) => iteratees.consume<Integer>()
        .map((d)     => "First it was \"``c``\", but " +
                        "then we stuck around for more: ``d``"))))));

    //benchmark {
    //    warmupIter = 10;
    //    scale=50k;
    //    () => enumerator(1:50k).runOrThrow(iteratees.consume<Integer>()),
    //    () => enumerator(1:50k).runOrThrow(iteratees.reversed<Integer>()).sequence().reversed
    //};

    /*
        Optimizing reified tests massively changed performance:

        Test #3 2264/2321/2304/0% (100%)
        Test #2 4168/4303/4226/1% (184%)

        Test #3 195/218/208/4% (100%)
        Test #2 261/345/299/8% (133%)

        And then, messed up performance by using new fold method,
        creating a ton of closures

        Test #3 187/212/198/4% (100%)
        Test #2 670/1973/941/54% (357%)

        So went back to switch statements before commit
     */

    //benchmark {
    //    warmupIter = 20;
    //    benchIter = 20;
    //    scale=100k;
    //    () => enumerator(1:100k).through(enumeratees.mapInput(identity<Input<Integer>>)).runOrThrow(iteratees.consume<Integer>()),
    //    () => enumerator(1:100k).through(enumeratees.map(identity<Integer>)).runOrThrow(iteratees.consume<Integer>()),
    //    () => enumerator(1:100k).mapInput(identity<Input<Integer>>).runOrThrow(iteratees.consume<Integer>()),
    //    () => enumerator(1:100k).map(identity<Integer>).runOrThrow(iteratees.consume<Integer>())
    //};

}
