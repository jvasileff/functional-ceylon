import com.vasileff.fc.streamalg2 {
    LoggingAdvice,
    pushAlgebra,
    pullAlgebra
}

shared
void streamWithLogging() {
    // same as pushAlgebra, but also logs:
    value pushLoggingAlgebra = LoggingAdvice(pushAlgebra);
    value x = pushLoggingAlgebra.map(Integer.successor,
              pushAlgebra.filter(Integer.even,
              pushAlgebra.source(0..10)));
    x.invoke(print);

    //////

    // same as pullAlgebra, but also logs:
    value pullLoggingAlgebra = LoggingAdvice(pullAlgebra);
    value y =   pullLoggingAlgebra.count(
                pullLoggingAlgebra.map(Integer.successor,
                pullAlgebra.filter(Integer.even,
                pullAlgebra.source(0..10))))
                .element;
    print("The count is: ``y``");
}
