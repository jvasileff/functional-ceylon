import com.vasileff.fc.iteratee {
    Done,
    nil,
    iteratees,
    Iteratee,
    enumerator,
    Error
}

alias IpAddress => [Integer, Integer, Integer, Integer];

Iteratee<Character, Anything> dropSpaceChars
    =   iteratees.dropWhile((Character c)
            =>  c != '\n' && c.whitespace);

Iteratee<Character, Integer> digits
    =   iteratees.takeWhile(Character.digit)
        .flatMap((chars)
            =>  switch (val = parseInteger(String(chars)))
                case (is Integer)
                    if (val in 0..255) then
                        Done(val, nil.input<Character>())
                    else
                        Error(Exception("``val`` out of range"),
                              nil.input<Character>())
                else
                    Error(Exception("invalid digits '``chars``'"),
                          nil.input<Character>()));

Iteratee<Character, IpAddress> ipAddress
    =   digits
        .flatMap((a)    =>  iteratees.expect('.')
        .flatMap((_)    =>  digits
        .flatMap((b)    =>  iteratees.expect('.')
        .flatMap((_)    =>  digits
        .flatMap((c)    =>  iteratees.expect('.')
        .flatMap((_)    =>  digits
        .map((d)        =>  [a, b, c, d])))))));

Iteratee<Character, [IpAddress*]> ipAddresses
        ([IpAddress*] addresses = [])
    =>  dropSpaceChars
        .flatMap((_)    =>  ipAddress
        .flatMap((addr) =>  dropSpaceChars
        .flatMap((_)    =>  iteratees.peek<Character>()
        .flatMap((char)
            =>  switch (char)
                case ('\n' | null)
                    Done(addresses.withTrailing(addr),
                         nil.input<Character>())
                else
                    ipAddresses(addresses.withTrailing(addr))))));

shared
void testParseIpAddress() {
    value input = enumerator("192.168.1.11 10.0.0.1");
    [IpAddress*] addresses = input.runOrThrow(ipAddresses());
    print(addresses);
}
