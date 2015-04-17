shared
interface Bounce<out Result>
        of Call<Result> | Return<Result> {

    shared formal
    Result result;

    shared
    Bounce<Other> flatMap<Other>(
            Bounce<Other>(Result) collecting)
        =>  switch (self = this)
            case (is Return<Result>)
                Call(() => collecting(self.result))
            case (is Call<Result>)
                Call(() => self.f().flatMap(collecting));

    shared
    Bounce<Other> map<Other>(
            Other(Result) collecting)
        =>  flatMap((result)
            =>  Call(()
                =>  Return(collecting(result))));
}

shared final
class Call<out Result>(
        shared Bounce<Result>() f)
        satisfies Bounce<Result> {

    shared actual
    Result result {
        variable Bounce<Result> bounce = this;
        while (true) {
            switch (b = bounce of Call<Result> | Return<Result>)
            case (is Call<Anything>) {
                bounce = b.f();
            }
            else {
                return b.result;
            }
        }
    }
}

shared final
class Return<out Return>(
        shared actual Return result)
        satisfies Bounce<Return> {}
