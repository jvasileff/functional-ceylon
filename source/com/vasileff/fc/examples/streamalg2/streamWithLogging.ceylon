import com.vasileff.fc.streamalg2 {
    PushFactory,
    LoggingAdvice,
    PullFactory
}

shared
void streamWithLogging() {
    value pushAlg = PushFactory();
    // same as pushAlg, but also logs:
    value pushLoggingAlg = LoggingAdvice(pushAlg);
    value x = pushLoggingAlg.map(Integer.successor,
              pushAlg.filter(Integer.even,
              pushAlg.source(0..10)));
    x.invoke(print);

    //////

    value pullAlg = PullFactory();
    // same as pullAlg, but also logs:
    value pullLoggingAlg = LoggingAdvice(pullAlg);
    value y =   pullLoggingAlg.count(
                pullLoggingAlg.map(Integer.successor,
                pullAlg.filter(Integer.even,
                pullAlg.source(0..10))))
                .element;
    print("The count is: ``y``");
}
