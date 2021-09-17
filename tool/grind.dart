import 'dart:io' hide ProcessException;

import 'package:grinder/grinder.dart';
import 'package:logging/logging.dart';

final int dartFmtLineLenght = 80;

void main(List<String> args) {
  Logger.root.onRecord.listen((record) => log(record.message));
  grind(args);
}

@Task()
void format() => DartFmt.format('.', lineLength: dartFmtLineLenght);

@Task()
void checkFormat() {
  if (DartFmt.dryRun('.', lineLength: dartFmtLineLenght)) {
    fail('Code is not properly formatted. Run `grind format`');
  }
}

@Task('Runs dartanalyzer and makes sure there are no warnings or lint proplems')
void analyze() async {
  await runAsync('dartanalyzer',
      arguments: ['.', '--fatal-hints', '--fatal-warnings', '--fatal-lints']);
}

@Task()
void testUnit() =>
    // Setting concurrency to 1 because it makes the output more readable and
    // the project is quite small anyway
    TestRunner().testAsync(files: Directory('test'), concurrency: 1);

@DefaultTask()
@Depends(checkFormat, analyze, testUnit)
void test() => true;
