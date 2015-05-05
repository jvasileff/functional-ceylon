"Interface for pull style streams"
shared
interface Pull<out T>
        satisfies Iterator<T> &
                  Application<PullType, T> {}

"Marker interface for simulated type
 constructor polymorphism"
shared sealed
class PullType() {}

"Unsafe narrowing operation; safe by convention"
shared
Pull<T> narrowPull<T>(Application<PullType, T> app) {
    assert (is Pull<T> app);
    return app;
}
