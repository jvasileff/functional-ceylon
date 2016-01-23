import test.com.vasileff.fc.core {
    wrapperExample,
    monoidExamples,
    functorExamples,
    applicativeExamples,
    coalesceExample,
    flattenExample,
    liftExample,
    intercalate
}

shared
void run() {
    functorExamples();
    applicativeExamples();
    coalesceExample();
    wrapperExample();
    flattenExample();
    liftExample();

    monoidExamples();
    intercalate();

    print("Testing complete.");
}
