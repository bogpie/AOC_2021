import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  List<String> signalPatterns = [];
  List<String> outputDigits = [];

  await read(signalPatterns, outputDigits);

  print(countUniques(outputDigits));
}

int countUniques(List<String> outputDigits) {
  return outputDigits
      .join(" ") // Strings at the end of the line need a separator
      .split(" ")
      .where((string) => isUnique(string.length) == true)
      .length;
}

bool isUnique(int length) {
  return length != 5 && length != 6;
}

Future<void> read(List<String> leftStrings, List<String> rightStrings) async {
  String input = await File('D08.in').readAsStringSync();
  LineSplitter splitter = LineSplitter();
  List<String> lines = splitter.convert(input);

  lines.forEach(
    (line) {
      List<String> split = line.split(" | ");
      leftStrings.add(split.first);
      rightStrings.add(split.last);
    },
  );
}
