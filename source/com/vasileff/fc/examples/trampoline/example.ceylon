import com.vasileff.ceylon.xmath.whole {
    zero,
    one,
    Whole
}
import com.vasileff.fc.trampoline {
    Call,
    Bounce,
    Return
}

Bounce<Boolean> even(Integer x, Boolean alwaysBounce = false)
    =>  if (x == 0) then
            Return(true)
        else if (alwaysBounce || 1000.divides(x)) then
            Call(() => odd(x - 1, alwaysBounce))
        else
            odd(x - 1, alwaysBounce);

Bounce<Boolean> odd(Integer x, Boolean alwaysBounce = false)
    =>  if (x == 0) then
            Return(false)
        else if (alwaysBounce || 1000.divides(x)) then
            Call(() => odd(x - 1, alwaysBounce))
        else
            even(x - 1, alwaysBounce);

Bounce<Boolean> flip(Boolean b)
    =>  Return(!b);

Bounce<Whole> fact(Integer x) {
    Bounce<Whole> step(Integer x, Whole acc = one)()
        =>  if (x <= 1)
            then Return(acc)
            else Call(step(x - 1, acc.timesInteger(x)));

    return step(x)();
}

Bounce<Whole> fib(Integer x) {
    Bounce<Whole> step(Integer x, Whole a = zero, Whole b = one)()
        =>  if (x <= 2)
            then Return(a + b)
            else Call(step(x - 1, b, a + b));

    return step(x)();
}

shared
void runTrampolineTest() {
    print(fact(6).map(Whole.integer).flatMap(fib).result);
    print(fib(20).map(Whole.integer).flatMap(fact).result);

    print(even(1M).flatMap(flip).result);
    print(even(1M).map((x) => !x).result);

//    value iters = 10M;
//    benchmark {
//        scale = iters / 1k; // picoseconds per iteration
//        ["instanceof", () => even(iters).result],
//        ["instanceof alwaysBounce", () => even(iters, true).result]
//
//        //repeat(iters, () => fact(100).result)
//    };
}

/*
    Summary min/max/avg/rstdev/pct
    instanceof              1411/1525/1470/2% (100%)
    reified                 1963/2095/2011/2% (139%)
    instanceof alwaysBounce 15505/15789/15625/0% (1098%)
    reified alwaysBounce    476167/478798/477435/0% (33741%)
*/
