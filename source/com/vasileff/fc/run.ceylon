import com.vasileff.fc.examples.iteratee { ... }
import com.vasileff.fc.examples.trampoline { ... }
import com.vasileff.fc.examples.core { coreRun=run }

shared void run() {
  csvTesting();
  testParseIpAddress();
  coreRun();
  runTrampolineTest();

  print("Testing complete.");
}
